
# Transform primitives for PDDL domain/problem ASTs (via sexpr).
from typing import List, Dict, Tuple, Optional, Callable, Any
import copy

# AST is a nested list of atoms/Lists. Atoms are strings.
# This code is heuristic and aims to be robust on typical domains with :action or :durative-action.

def _is_atom(x): return isinstance(x, str)

def _walk_lists(node):
    if isinstance(node, list):
        yield node
        for x in node:
            yield from _walk_lists(x)

def _find_define_block(ast: List) -> Optional[List]:
    # Return the (define ...) top-level list.
    for node in ast:
        if isinstance(node, list) and node and node[0] == 'define':
            return node
    return None

def _find_section(define_block: List, head: str) -> Optional[List]:
    # Look for a (head ...) form in the define block.
    for node in define_block:
        if isinstance(node, list) and node and node[0] == head:
            return node
    return None

def _list_actions(define_block: List) -> List[Tuple[List, str, str]]:
    # Return [(action_list, action_name, kind)] where kind in {':action', ':durative-action'}
    out = []
    for node in define_block:
        if isinstance(node, list) and node:
            if node[0] in (':action', ':durative-action'):
                if len(node) >= 2 and isinstance(node[1], str):
                    out.append((node, node[1], node[0]))
    return out

def _find_action_by_name(define_block: List, name_substr: str) -> Optional[Tuple[List, str, str]]:
    for act, name, kind in _list_actions(define_block):
        if name_substr in name:
            return (act, name, kind)
    return None

def _get_or_create_effect_list(action_list: List) -> List:
    # Find ':effect' entry; ensure its value is a proper list, and return that list to be extended.
    # Action structure is like: ( :action name :parameters (...) :precondition (...) :effect (...) )
    i = 0
    while i < len(action_list):
        if action_list[i] == ':effect':
            # Next item is the effect specification
            if i+1 >= len(action_list):
                action_list.append(['and'])
                return action_list[-1]
            eff = action_list[i+1]
            if isinstance(eff, list):
                # if it's (and ...), return the list inside; else ensure it's (and eff ...)
                if len(eff) >= 1 and eff[0] == 'and':
                    return eff
                else:
                    new_eff = ['and', eff]
                    action_list[i+1] = new_eff
                    return new_eff
            else:
                # Atom? wrap it
                new_eff = ['and', eff]
                action_list[i+1] = new_eff
                return new_eff
        i += 1
    # If not found, create one at end
    action_list.extend([':effect', ['and']])
    return action_list[-1]

def add_cost_spike(domain_ast: List, action_name_substr: str, K: int = 100000, at_end: bool=False) -> bool:
    """Add (increase (total-cost) K) into the chosen action's effect.
    If at_end=True, wrap as (at end (increase ...)) for durative domains.
    Returns True if modified, False otherwise."""
    define = _find_define_block(domain_ast)
    if not define: return False
    found = _find_action_by_name(define, action_name_substr) or ( _list_actions(define)[:1][0] if _list_actions(define) else None )
    if not found: return False
    action_list, name, kind = found
    eff = _get_or_create_effect_list(action_list)
    inc = ['increase', ['total-cost'], str(K)]
    if at_end and kind == ':durative-action':
        eff.append(['at', 'end', inc])
    else:
        eff.append(inc)
    return True

def remove_effect_predicates(domain_ast: List, predicate_names: List[str]) -> int:
    """Remove any effect literals whose functor matches predicate_names (or their negations). Return count removed."""
    define = _find_define_block(domain_ast)
    if not define: return 0
    removed = 0
    for action_list, name, kind in _list_actions(define):
        # find :effect
        i = 0
        while i < len(action_list):
            if action_list[i] == ':effect' and i+1 < len(action_list) and isinstance(action_list[i+1], list):
                eff = action_list[i+1]
                # normalize to (and ...)
                if eff and eff[0] != 'and':
                    action_list[i+1] = ['and', eff]
                    eff = action_list[i+1]
                if eff and isinstance(eff, list):
                    new_items = []
                    for lit in eff[1:]:
                        keep = True
                        # handle (not (p ...)) or (p ...)
                        if isinstance(lit, list) and lit:
                            if lit[0] == 'not' and len(lit) == 2 and isinstance(lit[1], list) and lit[1]:
                                functor = lit[1][0]
                                if functor in predicate_names:
                                    keep = False
                            else:
                                functor = lit[0]
                                if functor in predicate_names:
                                    keep = False
                        if keep:
                            new_items.append(lit)
                        else:
                            removed += 1
                    action_list[i+1] = ['and'] + new_items
            i += 1
    return removed

def _read_typed_object_blocks(objs: List[str]) -> List[Tuple[List[str], str]]:
    """Given a flat token list from :objects (e.g., ['a','b','-','type','c','-','t2']),
       return [([names], type), ...]."""
    groups = []
    i = 0
    names = []
    while i < len(objs):
        tok = objs[i]
        if tok == '-':
            if i+1 >= len(objs):
                break
            typ = objs[i+1]
            if names:
                groups.append((names, typ))
            names = []
            i += 2
        else:
            names.append(tok)
            i += 1
    if names:
        # untyped trailing names (rare in typed PDDL); default to 'object'
        groups.append((names, 'object'))
    return groups

def _write_typed_object_blocks(groups: List[Tuple[List[str], str]]) -> List[str]:
    out = []
    for names, typ in groups:
        out.extend(names + ['-', typ])
    return out

def swap_object_types(problem_ast: List, renames: Dict[str, str]) -> bool:
    """Change the declared type of specific objects in :objects. renames: {obj_name: new_type}."""
    define = _find_define_block(problem_ast)
    if not define: return False
    # find (:objects ...)
    for i,node in enumerate(define):
        if isinstance(node, list) and node and node[0] == ':objects':
            # node looks like [':objects', ...typed tokens...]
            flat = node[1:]
            # Flatten nested lists just in case
            tokens = []
            for x in flat:
                if isinstance(x, list): tokens.extend(x)
                else: tokens.append(x)
            groups = _read_typed_object_blocks(tokens)
            changed = False
            for idx,(names, typ) in enumerate(groups):
                new_names = []
                for nm in names:
                    if nm in renames:
                        typ = renames[nm]
                        changed = True
                    new_names.append(nm)
                groups[idx] = (new_names, typ)
            if changed:
                define[i] = [':objects'] + _write_typed_object_blocks(groups)
                return True
    return False

def ensure_metric_has_total_cost(problem_ast: List) -> bool:
    """Ensure problem has a metric minimizing total-cost (or adds it to a sum)."""
    define = _find_define_block(problem_ast)
    if not define: return False
    for i,node in enumerate(define):
        if isinstance(node, list) and node and node[0] == ':metric':
            # want something like (:metric minimize (+ (total-cost) ...)) or (:metric minimize (total-cost))
            # If it's not a sum including (total-cost), add it.
            if len(node) >= 3 and node[1] == 'minimize':
                expr = node[2]
                def contains_total_cost(e):
                    if isinstance(e, list):
                        if e and e[0] == 'total-cost':
                            return True
                        return any(contains_total_cost(x) for x in e)
                    return False
                if not contains_total_cost(expr):
                    node[2] = ['+', ['total-cost'], expr]
                return True
    # No metric: add one
    define.append([':metric', 'minimize', ['total-cost']])
    return True

def _ensure_functions_section(define_block: List) -> List:
    sec = _find_section(define_block, ':functions')
    if sec is None:
        sec = [':functions']
        define_block.append(sec)
    return sec

def ensure_numeric_fluent(domain_ast: List, name: str) -> bool:
    define = _find_define_block(domain_ast)
    if not define: return False
    funcs = _ensure_functions_section(define)
    # Add (name) if not present
    if not any(isinstance(x, list) and x and x[0] == name for x in funcs[1:]):
        funcs.append([name])
        return True
    return False

def ensure_init_numeric(problem_ast: List, name: str, value: int) -> bool:
    define = _find_define_block(problem_ast)
    if not define: return False
    init = _find_section(define, ':init')
    if init is None:
        init = [':init']
        define.append(init)
    assign = ['=', [name], str(int(value))]
    # Replace existing or append
    for i in range(1, len(init)):
        if isinstance(init[i], list) and len(init[i]) == 3 and init[i][0] == '=' and init[i][1] == [name]:
            init[i] = assign
            return True
    init.append(assign); return True

def decrease_fluent_on(domain_ast: List, action_name_substr: str, name: str, amount: int) -> bool:
    define = _find_define_block(domain_ast)
    if not define: return False
    found = _find_action_by_name(define, action_name_substr)
    if not found: return False
    action_list, _, _ = found
    eff = _get_or_create_effect_list(action_list)
    eff.append(['decrease', [name], str(int(amount))])
    return True

def scale_duration(domain_ast: List, action_name_substr: str, factor: float = 2.0, absolute: int = None) -> bool:
    define = _find_define_block(domain_ast)
    if not define: return False
    found = _find_action_by_name(define, action_name_substr)
    if not found: return False
    action_list, _, kind = found
    if kind != ':durative-action': return False

    # Find or add :duration (= ?duration X)
    i = 0; inserted = False
    while i < len(action_list):
        if action_list[i] == ':duration' and i+1 < len(action_list):
            dur = action_list[i+1]
            # Expect (= ?duration N)
            if isinstance(dur, list) and dur and dur[0] == '=' and len(dur) == 3:
                rhs = dur[2]
                if absolute is not None:
                    dur[2] = str(int(absolute))
                else:
                    try:
                        dur[2] = str(int(round(int(rhs) * factor)))
                    except Exception:
                        return False
                return True
        i += 1
    # No :duration → insert one
    if absolute is None:
        absolute = 2
    action_list.extend([':duration', ['=', '?duration', str(int(absolute))]])
    return True

def neutralize_damage(domain_ast: List, extra_predicates: List[str] = None) -> int:
    base = ["damaged", "undamaged", "stubborn_sticking"]
    if extra_predicates:
        for p in extra_predicates:
            if p not in base:
                base.append(p)
    return remove_effect_predicates(domain_ast, base)
