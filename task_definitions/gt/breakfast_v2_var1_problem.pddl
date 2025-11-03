(define (problem problem_logistics)
	(:domain breakfast-v2-expert)
	(:requirements :strips :typing :preferences :action-costs)
	
	(:objects 
		raw_egg1 - raw_egg
		boiled_egg1 - boiled_egg
		tomatosauce1 - tomatosauce
		milk1 - spoiled_milk
		milk2 - fresh_milk
		bowl1 bowl2 - bowl
		plate1 - plate
		pan1 - pan
		cup1 - cup
		sugar1 - sugar
		salt1 - salt
		sponge1 metal_brush1 - cleaner
	)
	
	(:init
		; all containers are clean
		(clean bowl1)
		(clean bowl2)
		(clean plate1)
		(clean pan1)
		(clean cup1)
		; all containers are unoccupied
		(unoccupied bowl1)
		(unoccupied bowl2)
		(unoccupied plate1)
		(unoccupied pan1)
		(unoccupied cup1)
		; all containers are undamaged
		(undamaged bowl1)
		(undamaged bowl2)
		(undamaged plate1)
		(undamaged pan1)
		(undamaged cup1)
		; container special properties
		(delicate pan1)
		(microwave_safe bowl1)
		(microwave_unsafe bowl2)
		; pan is not preheated
		(not_preheated pan1)
		; cleaner special properties
		(harsh_cleaner metal_brush1)
		(soft_cleaner sponge1)
		; eggs
		(shelled raw_egg1)
		(unbeated raw_egg1)
		(uncooked raw_egg1)
		(shelled boiled_egg1)
		(unbeated boiled_egg1)
		; nothing is seasoned
		(unseasoned raw_egg1 sugar1)
		(unseasoned raw_egg1 salt1)
		; nothing is plated
		(unplated raw_egg1)
		(unplated tomatosauce1)
		; tomato sauce
		(can_unopened tomatosauce1)
		(canned tomatosauce1)
		(unheated tomatosauce1)
		; toppings
		(untopped_with raw_egg1 tomatosauce1)
		(untopped_with tomatosauce1 raw_egg1)
		; ground truth types
		(is_raw_egg raw_egg1)
		(is_boiled_egg boiled_egg1)
		(is_sugar sugar1)
		(is_salt salt1)
		(is_spoiled_milk milk1)
		(is_fresh_milk milk2)

		; problem variant - everything verified
		(verified_salt salt1)
		(verified_sugar sugar1)
		(verified_raw_egg raw_egg1)
		(verified_boiled_egg boiled_egg1)
		(verified_spoiled_milk milk1)
		(verified_fresh_milk milk2)

		(is_cooking)
		(= (total-cost) 0)
		(= (current-phase) 1)
		(= (current-verify-priority) 1)
		(= (current-clean-priority) 1)
		(= (item-verify-priority sugar1) 1)
		(= (item-verify-priority salt1) 2)
		(= (item-verify-priority boiled_egg1) 3)
		(= (item-verify-priority raw_egg1) 4)
		(= (item-clean-priority pan1) 1)
		(= (item-clean-priority bowl1) 2)
		(= (item-clean-priority bowl2) 3)
	)
	
	(:goal (and 
		; salt verified
		(preference salt-verified (verified_salt salt1))
		; tomato sauce is opened and heated
		(preference opened-tomatosauce1 (can_opened tomatosauce1))
		(preference heated-tomatosauce1 (heated tomatosauce1))
		; egg is beated salted, no sugar, and cooked
		(preference unshelled-raw-egg1 (not (shelled raw_egg1)))
		(preference beated-raw-egg1 (beated raw_egg1))
		(preference salted-raw-egg1 (is_salted raw_egg1))
		(preference not-sugared-raw-egg1 (not (is_sugared raw_egg1)))
		(preference cooked-raw-egg1 (cooked raw_egg1))
		(preference plated-raw-egg1 (plated raw_egg1))
		; tomato sauced is topped on egg
		(preference raw-egg1-topped-with-tomatosauce1 (topped_with raw_egg1 tomatosauce1))
		; all tools are clean and undamaged
		(preference clean-pan1 (clean pan1))
		(preference clean-bowl1 (clean bowl1))
		(preference clean-bowl2 (clean bowl2))
		(preference clean-sponge (not (dirty sponge1)))
		(preference undamaged-pan1 (undamaged pan1))
		(preference undamaged-bowl1 (undamaged bowl1))
		(preference undamaged-bowl2 (undamaged bowl2))
		(preference no-stubborn-sticking-pan1 (not (stubborn_sticking pan1)))
		; prefer not to take risky blind actions
		(preference no-blind-egg-crack (not (used_blind_egg_crack)))
		; milk in cup
		; (preference milk2-in-cup (in milk2 cup1))
		(preference fresh-milk-poured (is_fresh_milk_poured))
		; preference to try milk1 first
		(preference tried-milk1-first (verified_spoiled_milk milk1))
	))

    (:metric minimize (+ 
		(total-cost)
		(is-violated salt-verified)
		(is-violated beated-raw-egg1)
		(is-violated salted-raw-egg1)
		(is-violated not-sugared-raw-egg1)
		(is-violated cooked-raw-egg1)
		(is-violated plated-raw-egg1)
		(is-violated opened-tomatosauce1)
		(is-violated heated-tomatosauce1)
		(is-violated raw-egg1-topped-with-tomatosauce1)
		(is-violated clean-bowl1)
		(is-violated clean-bowl2)
		(is-violated clean-pan1)
        (is-violated undamaged-pan1)
        (is-violated undamaged-bowl1)
        (is-violated undamaged-bowl2)
		(is-violated no-stubborn-sticking-pan1)
		(is-violated no-blind-egg-crack)
		; (is-violated milk2-in-cup)
		(is-violated fresh-milk-poured)
		(is-violated tried-milk1-first)
    ))
)