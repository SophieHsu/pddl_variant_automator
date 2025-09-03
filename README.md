
# PDDL Variant Automator (Minimal)

This kit lets you **mass-produce** solvable PDDL variants that induce suboptimal behaviors while keeping OPTIC-feasible.

## What it does
- Parses domain/problem PDDL as **S-expressions** (no external deps).
- Applies **safe-by-construction transforms**:
  - `add_cost_spike`: injects `(increase (total-cost) K)` in a chosen action's effect.
  - `remove_effect_predicates`: removes hazard-like effects (e.g., `damaged`, `stubborn_sticking`).
  - `swap_object_types`: swaps declared object types in the **problem**.
  - `ensure_metric`: ensures the problem metric includes `(total-cost)` so OPTIC stays feasible.

> NOTE: The S-expr parser is pragmatic and works for typical domains with `:action` or `:durative-action`, but it's not a full PDDL parser. For complex grammars, consider swapping in a robust parser later.

## Quick start

```bash
python generate_variants.py \  --domain gt_pddl/gt_domain.pddl \  --problem gt_pddl/gt_problem.pddl \  --config example_config.json \  --out-dir out_variants
```

This writes files like:
- `out_variants/spike_any_open_domain.pddl`
- `out_variants/spike_any_open_problem.pddl`
- `out_variants/manifest.json` (logs per recipe)

## Integrating OPTIC + VAL

1. Run OPTIC on each variant (example):
   ```bash
   optic -N -o out_variants/spike_any_open_domain.pddl -f out_variants/spike_any_open_problem.pddl > plan.txt
   ```
   - `-N` lets OPTIC optimize numeric + preference violations.
2. Validate the plan with VAL (if available):
   ```bash
   Validate -v out_variants/spike_any_open_domain.pddl out_variants/spike_any_open_problem.pddl plan.txt
   ```

### Guardrails you still get
- `ensure_metric` keeps `(total-cost)` present in the problem's metric.
- Transforms avoid touching hard goals; **only** soft-goal achievement becomes expensive/impossible.
- You can combine multiple transforms by adding them in the `transforms` array for a recipe.

## Extending with more transforms

Add new ops to `transforms.py`, such as:
- duration scaling for `:durative-action` (`:duration (= ?duration X)`),
- resource budgets (add a function fluent, decrease it in effects),
- preference traps (add a `preference` but omit it from metric).

Then reference them from your config, e.g.:
```json
{
  "name": "budget_vs_quality",
  "transforms": [
    {"op": "add_resource_budget", "init": 10},
    {"op": "decrease_budget_on", "action_substr": "cook", "amount": 3},
    {"op": "ensure_metric"}
  ]
}
```

## Disclaimer
- This is a minimal skeleton designed to be **easy to customize**.
- For production-scale variant generation, consider replacing the S-expr parser with a dedicated PDDL parser and expanding unit tests around edge cases.
