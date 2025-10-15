(define (domain warehouse-v1-expert)
	(
		:requirements
		:strips
		:typing
		:action-costs
		:numeric-fluents
		:disjunctive-preconditions
	)
	(
		:types
		object
		location
		robot
		scanner
		aisle
		shelf
		bin
		tote
		pallet
		item
	)
	(
		:predicates
		(at ?r - robot ?l - location)
		(available ?s - scanner)
		(item-at ?i - item ?s - shelf)
		(in-bin ?i - item ?b - bin)
		(in-tote ?i - item ?t - tote)
		(on-pallet ?b - bin ?p - pallet)
		(labeled ?i - item)
		(undamaged ?i - item)
		(aisle-clear ?a - aisle)
		(in-aisle ?l - location ?a - aisle)
		(blind-pick)
		(current-bin ?b - bin)
		(next-bin ?x - bin ?y - bin)
		(final-bin ?b - bin)
		(current-item ?i - item)
		(next-item ?x - item ?y - item)
		(final-item ?i - item)
		(item-scanned ?i - item)
		(item-binned ?i - item)
		(bin-open ?b - bin)
		(bin-sealed ?b - bin)
		(bin-labeled ?b - bin)
		(pallet-ready ?p - pallet)
		(wrapped ?p - pallet)
		(assigned-bin ?i - item ?b - bin)
		(enable-blind)
	)
	(:functions (total-cost))
	(:action move
		:parameters (?r - robot ?from - location ?to - location ?a - aisle)
		:precondition (and 
			(at ?r ?from)
			(in-aisle ?from ?a)
			(in-aisle ?to ?a)
			(aisle-clear ?a)
		)
		:effect (and
			(at ?r ?to)
			(
				not
				(at ?r ?from)
			)
			(increase (total-cost) 2)
		)
	)
	(:action scan_item
		:parameters (?i - item ?sc - scanner)
		:precondition (and 
			(available ?sc)
			(current-item ?i)
		)
		:effect (and		)
	)
	(:action print_and_attach_label
		:parameters (?i - item ?sc - scanner ?b - bin)
		:precondition (and 
			(item-scanned ?i)
			(available ?sc)
			(current-item ?i)
		)
		:effect (and
			(labeled ?i)
			(assigned-bin ?i ?b)
			(increase (total-cost) 10000)
		)
	)
	(:action pick_with_scan
		:parameters (?i - item ?s - shelf ?t - tote)
		:precondition (and 
			(item-at ?i ?s)
			(item-scanned ?i)
			(current-item ?i)
		)
		:effect (and
			(in-tote ?i ?t)
			(
				not
				(item-at ?i ?s)
			)
		)
	)
	(:action pick_blind
		:parameters (?i - item ?s - shelf ?t - tote)
		:precondition (and 
			(item-at ?i ?s)
			(current-item ?i)
			(enable-blind)
		)
		:effect (and
			(in-tote ?i ?t)
			(
				not
				(item-at ?i ?s)
			)
			(not (undamaged ?i))
			(blind-pick)
		)
	)
	(:action load_bin_from_tote
		:parameters (?i - item ?t - tote ?b - bin)
		:precondition (and 
			(in-tote ?i ?t)
			(current-item ?i)
			(current-bin ?b)
			(item-scanned ?i)
			(bin-open ?b)
			(
				or
				(assigned-bin ?i ?b)
				(blind-pick)
			)
		)
		:effect (and
			(in-bin ?i ?b)
			(
				not
				(in-tote ?i ?t)
			)
			(item-binned ?i)
		)
	)
	(:action seal_bin
		:parameters (?b - bin)
		:precondition (and 
			(current-bin ?b)
			(bin-open ?b)
		)
		:effect (and
			(bin-sealed ?b)
			(not (bin-open ?b))
		)
	)
	(:action label_bin
		:parameters (?b - bin)
		:precondition (and 
			(current-bin ?b)
			(bin-sealed ?b)
		)
		:effect (and
			(bin-labeled ?b)
		)
	)
	(:action palletize_bin
		:parameters (?b - bin ?p - pallet)
		:precondition (and 
			(current-bin ?b)
			(bin-sealed ?b)
		)
		:effect (and
			(on-pallet ?b ?p)
			(pallet-ready ?p)
		)
	)
	(:action wrap_pallet
		:parameters (?p - pallet)
		:precondition (and 
			(pallet-ready ?p)
		)
		:effect (and
			(wrapped ?p)
		)
	)
	(:action clear_aisle
		:parameters (?a - aisle)
		:precondition (and 
			(not (aisle-clear ?a))
		)
		:effect (and
			(aisle-clear ?a)
		)
	)
	(:action advance_to_next_item
		:parameters (?x - item ?y - item)
		:precondition (and 
			(current-item ?x)
			(next-item ?x ?y)
			(item-binned ?x)
		)
		:effect (and
			(not (current-item ?x))
			(current-item ?y)
		)
	)
	(:action advance_to_next_bin
		:parameters (?x - bin ?y - bin)
		:precondition (and 
			(current-bin ?x)
			(next-bin ?x ?y)
			(bin-labeled ?x)
		)
		:effect (and
			(not (current-bin ?x))
			(current-bin ?y)
		)
	)
)
