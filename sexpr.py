
# Tiny S-expression utilities for PDDL-like files (no external deps).
# - parse(text) -> nested Python lists
# - dumps(ast)  -> string with parentheses and reasonable whitespace
# Not a complete PDDL parser, but good enough for structural transforms.

import re

def tokenize(s):
    # Keep parentheses as tokens; split on whitespace otherwise.
    # Preserve symbols like :action, - (for type declarations), etc.
    # Handle ; comments by stripping to line end.
    lines = []
    for line in s.splitlines():
        if ';' in line:
            line = line.split(';', 1)[0]
        lines.append(line)
    s = '\n'.join(lines)
    s = s.replace('(', ' ( ').replace(')', ' ) ')
    tokens = [t for t in s.split() if t]
    return tokens

def parse(text):
    tokens = tokenize(text)
    pos = 0

    def read():
        nonlocal pos
        if pos >= len(tokens):
            raise ValueError("Unexpected EOF while reading s-expr")
        tok = tokens[pos]
        pos += 1
        if tok == '(':
            lst = []
            while True:
                if pos >= len(tokens):
                    raise ValueError("Unexpected EOF in list")
                if tokens[pos] == ')':
                    pos += 1
                    return lst
                lst.append(read())
        elif tok == ')':
            raise ValueError("Unexpected ')'")
        else:
            return tok

    ast = []
    while pos < len(tokens):
        ast.append(read())
    return ast

def _is_atom(x): return isinstance(x, str)

def dumps(node, indent=0):
    # Pretty-printer with simple heuristics.
    sp = '\t' * indent  # Use tabs instead of spaces
    if _is_atom(node):
        return node
    # Flatten short lists in one line; otherwise multi-line
    if not node:
        return '()'
    
    # Special handling for define construct
    if isinstance(node, list) and len(node) >= 2 and node[0] == 'define':
        # Format as (define (domain/problem name) ...)
        if len(node) >= 3 and isinstance(node[1], list) and len(node[1]) >= 2:
            # Preserve whether it's domain or problem
            define_type = node[1][0]  # 'domain' or 'problem'
            define_name = node[1][1]
            result = f'(define ({define_type} {define_name})\n'
            # Process remaining sections
            for i in range(2, len(node)):
                result += sp + '\t' + dumps(node[i], indent + 1) + '\n'
            result += sp + ')'
            return result
    
    # Special handling for actions to match ground truth format
    if isinstance(node, list) and len(node) >= 2 and node[0] == ':action':
        # Format as (:action name ...parameters... :precondition ... :effect ...)
        result = '(:action ' + node[1] + '\n'  # (:action name
        i = 2
        while i < len(node):
            if isinstance(node[i], str) and node[i].startswith(':'):
                # Keywords like :parameters, :precondition, :effect
                keyword = node[i]
                result += sp + '\t' + keyword
                if i + 1 < len(node):
                    value = node[i + 1]
                    if isinstance(value, list) and len(value) > 0 and value[0] == 'and':
                        # Special handling for (and ...) - put 'and' on same line
                        result += ' (and'
                        if len(value) > 1:
                            if keyword == ':precondition':
                                result += ' \n'
                            else:
                                result += '\n'
                            for item in value[1:]:
                                result += sp + '\t\t' + dumps(item, indent + 2) + '\n'
                        result += sp + '\t)\n'
                    else:
                        result += ' ' + dumps(value, indent + 1) + '\n'
                    i += 2
                else:
                    result += '\n'
                    i += 1
            else:
                result += sp + '\t' + dumps(node[i], indent + 1) + '\n'
                i += 1
        result += sp + ')'
        return result
    
    # Keep preference expressions compact on single lines
    if isinstance(node, list) and len(node) >= 2 and node[0] == 'preference':
        text_items = [dumps(x, indent) for x in node]
        one_line = '(' + ' '.join(text_items) + ')'
        if len(one_line) <= 120:  # Slightly longer limit for preferences
            return one_line
    
    # Special handling for :objects section to keep type declarations on same line
    if isinstance(node, list) and len(node) >= 2 and node[0] == ':objects':
        result = '(:objects \n'
        i = 1
        while i < len(node):
            # Flatten any nested lists at this level
            if isinstance(node[i], list):
                # If it's a nested list, process it with default formatting
                result += sp + '\t' + dumps(node[i], indent + 2) + '\n'
                i += 1
                continue
            
            # Collect object names until we hit a '-' or end
            objects = []
            while i < len(node) and node[i] != '-' and isinstance(node[i], str):
                objects.append(node[i])
                i += 1
            
            # If we collected some objects
            if objects:
                # Check if there's a type after the '-'
                if i < len(node) and node[i] == '-' and i + 1 < len(node) and isinstance(node[i + 1], str):
                    # Found type declaration
                    type_name = node[i + 1]
                    result += sp + '\t' + ' '.join(objects) + ' - ' + type_name + '\n'
                    i += 2  # Skip the '-' and type
                else:
                    # No type, just list the objects
                    for obj in objects:
                        result += sp + '\t' + obj + '\n'
            else:
                # No objects collected, skip this item and move on
                if i < len(node):
                    i += 1
        
        result += sp + ')'
        return result
    
    # Special handling for :init section
    if isinstance(node, list) and len(node) >= 2 and node[0] == ':init':
        result = '(:init\n'
        for i in range(1, len(node)):
            init_item = node[i]
            if isinstance(init_item, list):
                # Format init predicates/facts on their own lines
                result += sp + '\t' + dumps(init_item, indent + 2) + '\n'
            else:
                # Handle atoms
                result += sp + '\t' + str(init_item) + '\n'
        result += sp + ')'
        return result
    
    # Special handling for :goal section
    if isinstance(node, list) and len(node) >= 2 and node[0] == ':goal':
        result = '(:goal '
        if len(node) == 2:
            goal_content = node[1]
            if isinstance(goal_content, list) and len(goal_content) > 0 and goal_content[0] == 'and':
                # Handle (and ...) goals
                result += '(and \n'
                for item in goal_content[1:]:
                    result += sp + '\t' + dumps(item, indent + 2) + '\n'
                result += sp + '\t)'
            else:
                # Single goal or other format
                result += dumps(goal_content, indent + 1)
        result += ')'
        return result
    
    # Special handling for :metric section
    if isinstance(node, list) and len(node) >= 2 and node[0] == ':metric':
        result = '(:metric '
        if len(node) >= 3:
            # Format as (:metric minimize (+ ...))
            optimize_type = node[1]  # 'minimize' or 'maximize'
            metric_expr = node[2]
            
            # Special handling for (+ ...) expressions - keep + on same line as minimize
            if isinstance(metric_expr, list) and len(metric_expr) > 0 and metric_expr[0] == '+':
                result += optimize_type + ' (+\n'
                # Add each term on its own line
                for i in range(1, len(metric_expr)):
                    result += sp + '\t' + dumps(metric_expr[i], indent + 2) + '\n'
                result += sp + '\t)'
            else:
                result += optimize_type + ' ' + dumps(metric_expr, indent + 1)
        result += ')'
        return result
    
    # Special handling for :types section to keep type declarations on same line
    if isinstance(node, list) and len(node) >= 2 and node[0] == ':types':
        result = '(\n' + sp + '\t:types\n'
        i = 1
        while i < len(node):
            # Flatten any nested lists at this level
            if isinstance(node[i], list):
                # If it's a nested list, process it with default formatting
                result += sp + '\t' + dumps(node[i], indent + 2) + '\n'
                i += 1
                continue
            
            # Collect type names until we hit a '-' or end
            types = []
            while i < len(node) and node[i] != '-' and isinstance(node[i], str):
                types.append(node[i])
                i += 1
            
            # If we collected some types
            if types:
                # Check if there's a parent type after the '-'
                if i < len(node) and node[i] == '-' and i + 1 < len(node) and isinstance(node[i + 1], str):
                    # Found parent type declaration
                    parent_type = node[i + 1]
                    result += sp + '\t' + ' '.join(types) + ' - ' + parent_type + '\n'
                    i += 2  # Skip the '-' and parent type
                else:
                    # No parent type, just list the types
                    for typ in types:
                        result += sp + '\t' + typ + '\n'
            else:
                # No types collected, skip this item and move on
                if i < len(node):
                    i += 1
        
        result += sp + ')'
        return result
    
    # Special handling for :predicates section to format predicates nicely
    if isinstance(node, list) and len(node) >= 2 and node[0] == ':predicates':
        result = '(\n' + sp + '\t:predicates\n'
        for i in range(1, len(node)):
            predicate = node[i]
            if isinstance(predicate, list):
                # Format predicate on its own line with proper indentation
                result += sp + '\t' + dumps(predicate, indent + 2) + '\n'
            else:
                # Handle atoms (shouldn't normally happen in predicates but just in case)
                result += sp + '\t' + str(predicate) + '\n'
        result += sp + ')'
        return result
    
    # Special handling for :effect section to format effects nicely
    if isinstance(node, list) and len(node) >= 2 and node[0] == ':effect':
        result = sp + ':effect'
        if len(node) == 2:
            effect_content = node[1]
            if isinstance(effect_content, list) and len(effect_content) > 0 and effect_content[0] == 'and':
                # Handle (and ...) effects
                result += ' (and'
                if len(effect_content) > 1:
                    result += '\n'
                    for item in effect_content[1:]:
                        result += sp + '\t' + dumps(item, indent + 2) + '\n'
                result += sp + '\t)'
            else:
                # Single effect or other format
                result += ' ' + dumps(effect_content, indent + 1)
        return result
    
    # If first element is a symbol and list is "short", keep in one line
    inline = all(_is_atom(x) or (isinstance(x, list) and len(x) <= 2 and all(_is_atom(y) for y in x)) for x in node)
    text_items = [dumps(x, indent) for x in node]
    one_line = '(' + ' '.join(text_items) + ')'
    if len(one_line) <= 80 and inline:
        return one_line
    # Multiline: special-case top constructs
    inner = []
    for x in node:
        inner.append(dumps(x, indent+1))
    return '(\n' + '\n'.join(sp + '\t' + line for line in inner) + '\n' + sp + ')'
