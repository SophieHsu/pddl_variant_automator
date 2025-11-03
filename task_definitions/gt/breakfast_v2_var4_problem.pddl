(define (problem problem_logistics)
	(:domain breakfast-v2-expert)
	(:requirements :strips :typing :preferences :action-costs)
	
	(:objects 
		premium_raw_silkie_egg - raw_egg
		premium_hard_boiled_egg1 - boiled_egg
		organic_canned_tomatosauce1 - tomatosauce
		opened_fatfree_milk1 - spoiled_milk
		unopened_whole_milk - fresh_milk
		pyrex_glass_bowl1 plastic_bowl1 - bowl
		antique_china_plate1 - plate
		french_nonstick_pan1 - pan
		souvenir_mug_cup1 - cup
		cane_sugar1 - sugar
		himalayan_sea_salt1 - salt
		sponge1 metal_brush1 - cleaner
	)
	
	(:init
		; all containers are clean
		(clean pyrex_glass_bowl1)
		(clean plastic_bowl1)
		(clean antique_china_plate1)
		(clean french_nonstick_pan1)
		(clean souvenir_mug_cup1)
		; all containers are unoccupied
		(unoccupied pyrex_glass_bowl1)
		(unoccupied plastic_bowl1)
		(unoccupied antique_china_plate1)
		(unoccupied french_nonstick_pan1)
		(unoccupied souvenir_mug_cup1)
		; all containers are undamaged
		(undamaged pyrex_glass_bowl1)
		(undamaged plastic_bowl1)
		(undamaged antique_china_plate1)
		(undamaged french_nonstick_pan1)
		(undamaged souvenir_mug_cup1)
		; container special properties
		(delicate french_nonstick_pan1)
		(microwave_safe pyrex_glass_bowl1)
		(microwave_unsafe plastic_bowl1)
		; pan is not preheated
		(not_preheated french_nonstick_pan1)
		; cleaner special properties
		(harsh_cleaner metal_brush1)
		(soft_cleaner sponge1)
		; eggs
		(shelled premium_raw_silkie_egg)
		(unbeated premium_raw_silkie_egg)
		(uncooked premium_raw_silkie_egg)
		(shelled premium_hard_boiled_egg1)
		(unbeated premium_hard_boiled_egg1)
		; nothing is seasoned
		(unseasoned premium_raw_silkie_egg cane_sugar1)
		(unseasoned premium_raw_silkie_egg himalayan_sea_salt1)
		; nothing is plated
		(unplated premium_raw_silkie_egg)
		(unplated organic_canned_tomatosauce1)
		; tomato sauce
		(can_unopened organic_canned_tomatosauce1)
		(canned organic_canned_tomatosauce1)
		(unheated organic_canned_tomatosauce1)
		; toppings
		(untopped_with premium_raw_silkie_egg organic_canned_tomatosauce1)
		(untopped_with organic_canned_tomatosauce1 premium_raw_silkie_egg)
		; ground truth types
		(is_raw_egg premium_raw_silkie_egg)
		(is_boiled_egg premium_hard_boiled_egg1)
		(is_sugar cane_sugar1)
		(is_salt himalayan_sea_salt1)
		(is_spoiled_milk opened_fatfree_milk1)
		(is_fresh_milk unopened_whole_milk)

		(is_cooking)
		(= (total-cost) 0)
		(= (current-phase) 1)
		(= (current-verify-priority) 1)
		(= (current-clean-priority) 1)
		(= (item-verify-priority cane_sugar1) 1)
		(= (item-verify-priority himalayan_sea_salt1) 2)
		(= (item-verify-priority premium_hard_boiled_egg1) 3)
		(= (item-verify-priority premium_raw_silkie_egg) 4)
		(= (item-clean-priority french_nonstick_pan1) 1)
		(= (item-clean-priority pyrex_glass_bowl1) 2)
		(= (item-clean-priority plastic_bowl1) 3)
	)
	
	(:goal (and 
		; salt verified
		(preference salt-verified (verified_salt himalayan_sea_salt1))
		; tomato sauce is opened and heated
		(preference opened-organic_canned_tomatosauce1 (can_opened organic_canned_tomatosauce1))
		(preference heated-organic_canned_tomatosauce1 (heated organic_canned_tomatosauce1))
		; egg is beated salted, no sugar, and cooked
		(preference unshelled-raw-egg1 (not (shelled premium_raw_silkie_egg)))
		(preference beated-raw-egg1 (beated premium_raw_silkie_egg))
		(preference salted-raw-egg1 (is_salted premium_raw_silkie_egg))
		(preference not-sugared-raw-egg1 (not (is_sugared premium_raw_silkie_egg)))
		(preference cooked-raw-egg1 (cooked premium_raw_silkie_egg))
		(preference plated-raw-egg1 (plated premium_raw_silkie_egg))
		; tomato sauced is topped on egg
		(preference raw-egg1-topped-with-organic_canned_tomatosauce1 (topped_with premium_raw_silkie_egg organic_canned_tomatosauce1))
		; all tools are clean and undamaged
		(preference clean-french_nonstick_pan1 (clean french_nonstick_pan1))
		(preference clean-pyrex_glass_bowl1 (clean pyrex_glass_bowl1))
		(preference clean-plastic_bowl1 (clean plastic_bowl1))
		(preference clean-sponge (not (dirty sponge1)))
		(preference undamaged-french_nonstick_pan1 (undamaged french_nonstick_pan1))
		(preference undamaged-pyrex_glass_bowl1 (undamaged pyrex_glass_bowl1))
		(preference undamaged-plastic_bowl1 (undamaged plastic_bowl1))
		(preference no-stubborn-sticking-french_nonstick_pan1 (not (stubborn_sticking french_nonstick_pan1)))
		; prefer not to take risky blind actions
		(preference no-blind-egg-crack (not (used_blind_egg_crack)))
		; milk in cup
		; (preference unopened_whole_milk-in-cup (in unopened_whole_milk souvenir_mug_cup1))
		(preference fresh-milk-poured (is_fresh_milk_poured))
		; preference to try opened_fatfree_milk1 first
		(preference tried-opened_fatfree_milk1-first (verified_spoiled_milk opened_fatfree_milk1))
	))

    (:metric minimize (+ 
		(total-cost)
		(is-violated salt-verified)
		(is-violated beated-raw-egg1)
		(is-violated salted-raw-egg1)
		(is-violated not-sugared-raw-egg1)
		(is-violated cooked-raw-egg1)
		(is-violated plated-raw-egg1)
		(is-violated opened-organic_canned_tomatosauce1)
		(is-violated heated-organic_canned_tomatosauce1)
		(is-violated raw-egg1-topped-with-organic_canned_tomatosauce1)
		(is-violated clean-pyrex_glass_bowl1)
		(is-violated clean-plastic_bowl1)
		(is-violated clean-french_nonstick_pan1)
        (is-violated undamaged-french_nonstick_pan1)
        (is-violated undamaged-pyrex_glass_bowl1)
        (is-violated undamaged-plastic_bowl1)
		(is-violated no-stubborn-sticking-french_nonstick_pan1)
		(is-violated no-blind-egg-crack)
		; (is-violated unopened_whole_milk-in-cup)
		(is-violated fresh-milk-poured)
		(is-violated tried-opened_fatfree_milk1-first)
    ))
)