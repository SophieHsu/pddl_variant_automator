(define (domain laundry-v3-expert)
	(
		:requirements
		:strips
		:typing
		:negative-preconditions
		:preferences
		:action-costs
		:fluents
	)
	(
		:types
		object
		garment
		machine
		washer
		dryer
		steamer
		iron
		basket
		hanger
		closet
		additive
		detergent
		softener
		sheet
		stainremover
	)
	(
		:predicates
		(in-hamper ?g - garment)
		(sorted-light ?g - garment)
		(sorted-dark ?g - garment)
		(sorted-delicate ?g - garment)
		(delicate ?g - garment)
		(stained ?g - garment)
		(pockets-checked ?g - garment)
		(tissue-in-pocket ?g - garment)
		(coins-in-pocket ?g - garment)
		(zippers-open ?g - garment)
		(inside-out ?g - garment)
		(in-washer ?g - garment)
		(in-dryer ?g - garment)
		(washed ?g - garment)
		(dried ?g - garment)
		(ironed ?g - garment)
		(steamed ?g - garment)
		(folded ?g - garment)
		(hung ?g - garment)
		(put-away ?g - garment)
		(soften ?g - garment)
		(lint-covered ?g - garment)
		(color-bled ?g - garment)
		(shrunk ?g - garment)
		(undamaged ?g - garment)
		(lint-removed ?d - dryer)
		(eco-washed ?g - garment)
		(no-blind-wash)
		(is-light ?g - garment)
		(is-dark ?g - garment)
		(current ?g - garment)
		(next ?x - garment ?y - garment)
		(stage-prep ?g - garment)
		(stage-sorted ?g - garment)
		(stage-pretreated ?g - garment)
		(stage-loaded ?g - garment)
		(stage-washed ?g - garment)
		(stage-in-dryer ?g - garment)
		(stage-dried ?g - garment)
		(stage-finished ?g - garment)
		(stage-ironed ?g - garment)
		(gate-tissue ?g - garment)
		(gate-coins ?g - garment)
		(gate-zippers ?g - garment)
		(gate-insideout ?g - garment)
		(must-fold ?g - garment)
		(must-hang ?g - garment)
		(must-iron ?g - garment)
		(lint-cleared)
		(enable-risky)
	)
	(:functions (total-cost) (budget))
	(:action sort_light
		:parameters (?g - garment)
		:precondition (and 
			(current ?g)
			(stage-prep ?g)
			(in-hamper ?g)
			(is-light ?g)
		)
		:effect (and
			(sorted-light ?g)
			(not (stage-prep ?g))
			(stage-sorted ?g)
			(increase (total-cost) 1)
		)
	)
	(:action sort_dark
		:parameters (?g - garment)
		:precondition (and 
			(current ?g)
			(stage-prep ?g)
			(in-hamper ?g)
			(is-dark ?g)
		)
		:effect (and
			(sorted-dark ?g)
			(not (stage-prep ?g))
			(stage-sorted ?g)
			(increase (total-cost) 1)
		)
	)
	(:action sort_delicate
		:parameters (?g - garment)
		:precondition (and 
			(current ?g)
			(stage-prep ?g)
			(in-hamper ?g)
			(delicate ?g)
		)
		:effect (and
			(sorted-delicate ?g)
			(not (stage-prep ?g))
			(stage-sorted ?g)
			(increase (total-cost) 2)
		)
	)
	(:action pretreat_stain
		:parameters (?g - garment ?sr - stainremover)
		:precondition (and 
			(current ?g)
			(stage-sorted ?g)
			(stained ?g)
			(in-hamper ?g)
		)
		:effect (and
			(not (stained ?g))
			(increase (total-cost) 2)
		)
	)
	(:action check_pockets
		:parameters (?g - garment)
		:precondition (and 
			(current ?g)
			(stage-sorted ?g)
			(in-hamper ?g)
			(
				or
				(not (stained ?g))
				(
					and
					(stained ?g)
					(not (stained ?g))
				)
			)
			(>= (budget) 1)
		)
		:effect (and
			(pockets-checked ?g)
			(not (stage-sorted ?g))
			(stage-pretreated ?g)
			(increase (total-cost) 1)
			(decrease (budget) 1)
		)
	)
	(:action remove_tissue
		:parameters (?g - garment)
		:precondition (and 
			(current ?g)
			(stage-pretreated ?g)
			(tissue-in-pocket ?g)
		)
		:effect (and
			(not (tissue-in-pocket ?g))
			(gate-tissue ?g)
			(increase (total-cost) 1)
		)
	)
	(:action remove_coins
		:parameters (?g - garment)
		:precondition (and 
			(current ?g)
			(stage-pretreated ?g)
			(gate-tissue ?g)
			(coins-in-pocket ?g)
		)
		:effect (and
			(not (coins-in-pocket ?g))
			(gate-coins ?g)
			(increase (total-cost) 1)
		)
	)
	(:action close_zippers
		:parameters (?g - garment)
		:precondition (and 
			(current ?g)
			(stage-pretreated ?g)
			(gate-coins ?g)
			(zippers-open ?g)
		)
		:effect (and
			(not (zippers-open ?g))
			(gate-zippers ?g)
			(increase (total-cost) 1)
		)
	)
	(:action turn_inside_out_delicate
		:parameters (?g - garment)
		:precondition (and 
			(current ?g)
			(stage-pretreated ?g)
			(gate-zippers ?g)
			(delicate ?g)
			(not (inside-out ?g))
		)
		:effect (and
			(inside-out ?g)
			(gate-insideout ?g)
			(increase (total-cost) 1)
			(increase (total-cost) 10000)
		)
	)
	(:action load_washer_safe
		:parameters (?g - garment ?w - washer)
		:precondition (and 
			(current ?g)
			(stage-pretreated ?g)
			(lint-cleared)
			(or (sorted-light ?g) (sorted-dark ?g) (sorted-delicate ?g))
			(pockets-checked ?g)
			(not (tissue-in-pocket ?g))
			(not (coins-in-pocket ?g))
			(not (zippers-open ?g))
		)
		:effect (and
			(in-washer ?g)
			(not (in-hamper ?g))
			(not (stage-pretreated ?g))
			(stage-loaded ?g)
			(increase (total-cost) 0)
		)
	)
	(:action load_washer_blind
		:parameters (?g - garment ?w - washer)
		:precondition (and 
			(enable-risky)
			(current ?g)
			(in-hamper ?g)
		)
		:effect (and
			(in-washer ?g)
			(not (in-hamper ?g))
			(color-bled ?g)
			(increase (total-cost) 0)
		)
	)
	(:action wash_eco
		:parameters (?g - garment ?w - washer ?d - detergent)
		:precondition (and 
			(current ?g)
			(stage-loaded ?g)
			(in-washer ?g)
		)
		:effect (and
			(washed ?g)
			(eco-washed ?g)
			(not (stage-loaded ?g))
			(stage-washed ?g)
			(increase (total-cost) 3)
		)
	)
	(:action wash_quick_risky
		:parameters (?g - garment ?w - washer)
		:precondition (and 
			(enable-risky)
			(current ?g)
			(in-washer ?g)
		)
		:effect (and
			(washed ?g)
			(color-bled ?g)
			(lint-covered ?g)
			(not (undamaged ?g))
			(increase (total-cost) 1)
		)
	)
	(:action add_softener_after
		:parameters (?g - garment ?s - softener)
		:precondition (and 
			(current ?g)
			(stage-washed ?g)
		)
		:effect (and
			(soften ?g)
			(increase (total-cost) 1)
		)
	)
	(:action move_to_dryer
		:parameters (?g - garment ?w - washer ?d - dryer)
		:precondition (and 
			(current ?g)
			(stage-washed ?g)
			(in-washer ?g)
			(washed ?g)
		)
		:effect (and
			(in-dryer ?g)
			(not (in-washer ?g))
			(not (stage-washed ?g))
			(stage-in-dryer ?g)
			(increase (total-cost) 1)
		)
	)
	(:action dry_low_safe
		:parameters (?g - garment ?d - dryer)
		:precondition (and 
			(current ?g)
			(stage-in-dryer ?g)
			(in-dryer ?g)
		)
		:effect (and
			(dried ?g)
			(not (stage-in-dryer ?g))
			(stage-dried ?g)
			(increase (total-cost) 2)
		)
	)
	(:action dry_high_risky
		:parameters (?g - garment ?d - dryer)
		:precondition (and 
			(enable-risky)
			(current ?g)
			(in-dryer ?g)
		)
		:effect (and
			(dried ?g)
			(shrunk ?g)
			(increase (total-cost) 1)
		)
	)
	(:action hang_dry
		:parameters (?g - garment ?h - hanger)
		:precondition (and 
			(current ?g)
			(stage-washed ?g)
			(washed ?g)
			(delicate ?g)
		)
		:effect (and
			(dried ?g)
			(not (stage-washed ?g))
			(stage-dried ?g)
			(increase (total-cost) 1)
		)
	)
	(:action remove_lint_from_dryer
		:parameters (?d - dryer)
		:precondition (and 
			(not (lint-cleared))
		)
		:effect (and
			(lint-removed ?d)
			(lint-cleared)
			(increase (total-cost) 1)
		)
	)
	(:action delint_garment
		:parameters (?g - garment)
		:precondition (and 
			(current ?g)
			(stage-dried ?g)
			(lint-covered ?g)
		)
		:effect (and
			(not (lint-covered ?g))
			(increase (total-cost) 1)
		)
	)
	(:action iron_garment
		:parameters (?g - garment ?i - iron)
		:precondition (and 
			(current ?g)
			(stage-dried ?g)
		)
		:effect (and
			(ironed ?g)
			(increase (total-cost) 1)
		)
	)
	(:action steam_garment
		:parameters (?g - garment ?st - steamer)
		:precondition (and 
			(current ?g)
			(stage-dried ?g)
		)
		:effect (and
			(steamed ?g)
			(increase (total-cost) 1)
		)
	)
	(:action fold_garment
		:parameters (?g - garment)
		:precondition (and 
			(current ?g)
			(stage-dried ?g)
			(must-fold ?g)
		)
		:effect (and
			(folded ?g)
			(not (stage-dried ?g))
			(stage-finished ?g)
			(increase (total-cost) 1)
		)
	)
	(:action hang_garment
		:parameters (?g - garment ?h - hanger)
		:precondition (and 
			(current ?g)
			(stage-dried ?g)
			(must-hang ?g)
		)
		:effect (and
			(hung ?g)
			(not (stage-dried ?g))
			(stage-finished ?g)
			(increase (total-cost) 1)
		)
	)
	(:action put_away_closet
		:parameters (?g - garment ?c - closet)
		:precondition (and 
			(current ?g)
			(stage-finished ?g)
		)
		:effect (and
			(put-away ?g)
			(increase (total-cost) 1)
		)
	)
	(:action advance_to_next
		:parameters (?x - garment ?y - garment)
		:precondition (and 
			(current ?x)
			(next ?x ?y)
			(put-away ?x)
		)
		:effect (and
			(not (current ?x))
			(current ?y)
		)
	)
)
