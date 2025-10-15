#!/usr/bin/env python3
"""
Generate PDDL configs from a meta config to further generate variants.
Usage:
  python generate_configs.py \
    --metaconfig configs/metaconfigs/warehouse_v2_meta.json \
    --domain gt_pddl/warehouse_v2_domain.pddl \
    --problem gt_pddl/warehouse_v2_problem.pddl \
    --savepath configs/warehouse_v2_configs.json
"""

import argparse
import json
import itertools
from collections import defaultdict

from pddl_knowledge.utils.pddl_chunk_utils import chunk_pddl

def _get_all_action_names(domain_chunks):
    all_action_names = []
    for chunk in domain_chunks:
        if chunk["chunk_type"] == "action":
            # print(chunk)
            all_action_names.append(chunk["chunk_name"])

    return all_action_names

def _get_true_object_types(problem_chunks):
    chunk_types = [chunk["chunk_type"] for chunk in problem_chunks]
    objects_block = problem_chunks[chunk_types.index("objects")]
    lines = [line.strip() for line in objects_block["raw_text"].splitlines()]
    true_obj_types = {}
    for line in lines:
        if "-" in line:
            objects, type = line.split("-")
            objects = objects.split()
            for obj in objects:
                true_obj_types[obj.strip()] = type.strip()

    return true_obj_types

def _get_obj_to_type_candidates(type_to_obj_candidates):
    out = defaultdict(list)
    for type, objs in type_to_obj_candidates.items():
        for obj in objs:
            out[obj].append(type)

    return out

def main(args):
    
    # load meta config
    with open(args.metaconfig, "r") as f:
        file = f.read()
    metaconf = json.loads(file)

    # load pddls and get chunks
    domain_chunks = chunk_pddl(args.domain)
    problem_chunks = chunk_pddl(args.problem)
    all_action_names = _get_all_action_names(domain_chunks)
    task_name = metaconf["task_name"]

    variants = []

    """ 
    Cost Spike Variants 
    """
    if metaconf["use_cost_spikes"]:

        cost_spike_actions = metaconf["actions_for_cost_spike"]
        cost_spike_values = metaconf["cost_spike_values"]
        cost_spike_exclude_actions = metaconf["cost_spike_exclude_actions"]

        # if all
        if cost_spike_actions == "all":
            cost_spike_actions = all_action_names

        if len(cost_spike_exclude_actions) > 0:
            cost_spike_actions = [a for a in cost_spike_actions if a not in cost_spike_exclude_actions]

        # generate entries
        for action in cost_spike_actions:
            for spike_val in cost_spike_values:
                variants.append({
                    "name": f"{task_name}_spike_{action}_{spike_val}",
                    "transforms": [
                        {"op": "add_cost_spike", "action_substr": action, "K": spike_val},
                        {"op": "ensure_metric"},
                    ],
                })
    
    """
    Budget Decrease Variants
    """
    if metaconf["use_budget_decrease"]:
        budget_decrease_actions = metaconf["actions_for_budget_decrease"]
        budget_initial_values = metaconf["budget_initial_values"]
        budget_decrease_values = metaconf["budget_decrease_values"]
        budget_decrease_special_action_sets = metaconf["budget_actions_special_action_sets"]

        """ Single action cases """
        if budget_decrease_actions == "all":
            budget_decrease_actions = all_action_names
        
        for action in budget_decrease_actions:
            for init_val in budget_initial_values:
                for decrease_val in budget_decrease_values:
                    variants.append({
                        "name": f"{task_name}_budget_{action}",
                        "transforms": [
                            {"op": "ensure_budget", "name": "budget", "init": init_val},
                            {"op": "decrease_budget_on", "action_substr": action, "name": "budget", "amount": decrease_val},
                            {"op": "ensure_metric"}
                        ],
                    })

        """ Special action sets """
        for name, data in budget_decrease_special_action_sets.items():
            init = data.get("initial", 1)
            transforms = [
                    {"op": "ensure_budget", "name": "budget", "init": init},
            ]
            for act, val in zip(data["actions"], data["decrease"]):
                transforms.append(
                    {"op": "decrease_budget_on", "action_substr": act, "name": "budget", "amount": val},
                )
            transforms.append({"op": "ensure_metric"})
            variants.append({
                "name": f"{task_name}_budget_{name}",
                "transforms": transforms,
            })
            
    """
    Remove Effects Variants (remove all occurrences of an effect)
    """
    if metaconf["use_remove_effects_all"]:
        removable_effects = metaconf["removable_effects"]
        for effect in removable_effects:
            variants.append({
                "name": f"{task_name}_hazoff_all_{effect}",
                "transforms": [
                    {"op": "remove_effect_predicates", "predicates": [effect]},
                    {"op": "ensure_metric"},
                ]
            })

    """
    TODO
    Remove Effects Variants (remove effect from single action)
    """
    if metaconf["use_remove_effects_single"]:
        removable_effects = metaconf["removable_effects"]
        for effect in removable_effects:
            for action in all_action_names:
                variants.append({
                    "name": f"{task_name}_hazoff_{effect}_{action}",
                    "transforms": [
                        {"op": "remove_effect_from_single_action", "predicates": [effect], "action_substr": action},
                        {"op": "ensure_metric"},
                    ]
                })

    """
    Type Swap Variants
    """
    if metaconf["use_type_swaps"]:
        type_to_obj_candidates = metaconf["object_type_to_compatible_objects"]
        
        # get object types defined in the problem file
        true_obj_types = _get_true_object_types(problem_chunks)
        obj_to_type_candidates = _get_obj_to_type_candidates(type_to_obj_candidates)
        swapped_pairs = []

        for obj, types in obj_to_type_candidates.items():
            true_type = true_obj_types[obj]
            ##### CASE 1: reassign SINGLE object to another type #####
            for type in types:
                if not type == true_type:
                    variants.append({
                        "name": f"{task_name}_type_{obj}_from_{true_type}_to_{type}",
                        "transforms": [
                            {"op": "swap_object_types", "renames": {obj: type}},
                            {"op": "ensure_metric"}
                        ]
                    })
            ##### CASE 2: swapping two object types #####
            type_pairs = itertools.combinations(types, 2)
            all_objs = obj_to_type_candidates.keys()
            for pair in type_pairs:
                for pair_candidate in all_objs:
                    if pair_candidate == obj:
                        continue
                    # skip if already swapped
                    if set(pair) in swapped_pairs:
                        continue
                    # conditions for legal swapping
                    candidate_true_type = true_obj_types[pair_candidate]
                    cond1 = true_type in obj_to_type_candidates[pair_candidate]
                    cond2 = candidate_true_type in obj_to_type_candidates[obj]
                    if cond1 and cond2:
                        variants.append({
                            "name": f"{task_name}_type_swap_{obj}_and_{pair_candidate}",
                            "transforms": [
                                {"op": "swap_object_types", "renames": {obj: candidate_true_type}},
                                {"op": "swap_object_types", "renames": {pair_candidate: true_type}},
                                {"op": "ensure_metric"}
                            ]
                        })
                        swapped_pairs.append(set(pair))

    """
    Mix Variants
    """
    if metaconf["use_mix"]:
        from itertools import combinations
        variant_pairs = list(combinations(variants, 2))
        for v1, v2 in variant_pairs:
            v1_name = "_".join(v1["name"].split("_")[1:])
            v2_name = "_".join(v2["name"].split("_")[1:])
            variants.append({
                "name": f"{task_name}_mix_{v1_name}_{v2_name}",
                "transforms": v1["transforms"] + v2["transforms"],
            })

    """
    Save generated config
    """
    config = {"variants": variants}
    options = {"indent": 4}

    with open(args.savepath, "w") as f:
        json.dump(config, f, **options)
    print(f"saved {len(variants)} unique variants")

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--metaconfig", type=str, help="path to meta config json", default="/home/ayanoh/pddl_variant_automator/configs/metaconfigs/breakfast_v2_meta.json")
    parser.add_argument("--domain", type=str, help="path to pddl domain file", default="/home/ayanoh/pddl_variant_automator/task_definitions/gt/breakfast_v2_domain.pddl")
    parser.add_argument("--problem", type=str, help="path to pddl problem file", default="/home/ayanoh/pddl_variant_automator/task_definitions/gt/breakfast_v2_problem.pddl")
    parser.add_argument("--savepath", type=str, help="path to save generated config json", default="test.json")
    args = parser.parse_args()

    main(args)