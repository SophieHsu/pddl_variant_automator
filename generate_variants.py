
#!/usr/bin/env python3
"""
Generate PDDL variants by applying safe transform recipes.
Usage:
  python generate_variants.py \
    --domain gt_pddl/gt_domain.pddl \
    --problem gt_pddl/gt_problem.pddl \
    --config example_config.json \
    --out-dir out_variants
"""
import argparse, json, os, sys, copy
from typing import Dict, Any, List
from sexpr import parse, dumps
from transforms import add_cost_spike, remove_effect_predicates, swap_object_types, ensure_metric_has_total_cost, neutralize_damage, scale_duration, ensure_numeric_fluent, ensure_init_numeric, decrease_fluent_on

def load_text(path): 
    with open(path, 'r', encoding='utf-8') as f: 
        return f.read()

def save_text(path, text):
    with open(path, 'w', encoding='utf-8') as f:
        f.write(text + ("\n" if not text.endswith("\n") else ""))

def apply_recipe(domain_ast, problem_ast, recipe, verbose=False):
    steps = recipe.get("transforms", [])
    log, had_change = [], False
    for step in steps:
        op = step.get("op"); ok = False
        if op == "add_cost_spike":
            ok = add_cost_spike(domain_ast, step.get("action_substr",""), int(step.get("K",100000)), bool(step.get("at_end", False)))
        elif op == "remove_effect_predicates":
            ok = remove_effect_predicates(domain_ast, step.get("predicates", [])) > 0
        # elif op == "neutralize_damage":
        #     ok = neutralize_damage(domain_ast, step.get("extra_predicates")) > 0
        # elif op == "scale_duration":
        #     ok = scale_duration(domain_ast, step.get("action_substr",""), float(step.get("factor",2.0)), step.get("absolute"))
        elif op == "swap_object_types":
            ok = swap_object_types(problem_ast, step.get("renames", {}))
        elif op == "ensure_metric":
            ok = ensure_metric_has_total_cost(problem_ast)
        elif op == "ensure_budget":
            # two-step: declare fluent in domain + init value in problem
            ok1 = ensure_numeric_fluent(domain_ast, step.get("name","budget"))
            ok2 = ensure_init_numeric(problem_ast, step.get("name","budget"), int(step.get("init",10)))
            ok = ok1 or ok2
        elif op == "decrease_budget_on":
            ok = decrease_fluent_on(domain_ast, step.get("action_substr",""), step.get("name","budget"), int(step.get("amount",1)))
        else:
            log.append(f"Unknown op: {op}"); continue
        had_change = had_change or ok
        log.append(f"{'OK' if ok else 'NOOP'}: {op} {step}")
    return log, had_change

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--domain", required=True)
    ap.add_argument("--problem", required=True)
    ap.add_argument("--config", required=True)
    ap.add_argument("--out-dir", required=True)
    args = ap.parse_args()

    os.makedirs(args.out_dir, exist_ok=True)

    domain_text = load_text(args.domain)
    problem_text = load_text(args.problem)

    domain_ast = parse(domain_text)
    problem_ast = parse(problem_text)

    cfg = json.load(open(args.config, 'r', encoding='utf-8'))
    variants = cfg.get("variants", [])
    manifest = []

    for v in variants:
        name = v.get("name", "variant")
        d2 = copy.deepcopy(domain_ast)
        p2 = copy.deepcopy(problem_ast)
        log = apply_recipe(d2, p2, v, verbose=True)

        # Write files
        out_domain = os.path.join(args.out_dir, f"{name}_domain.pddl")
        out_problem = os.path.join(args.out_dir, f"{name}_problem.pddl")
        save_text(out_domain, '\n'.join(dumps(x) for x in d2))
        save_text(out_problem, '\n'.join(dumps(x) for x in p2))
        manifest.append({"name": name, "domain": out_domain, "problem": out_problem, "log": log})
        print(f"Wrote {name}:")
        for line in log: print("  ", line)
        print("  ->", out_domain)
        print("  ->", out_problem)

    # Save manifest
    man_path = os.path.join(args.out_dir, "manifest.json")
    json.dump(manifest, open(man_path, 'w', encoding='utf-8'), indent=2)
    print("Manifest:", man_path)

if __name__ == "__main__":
    main()
