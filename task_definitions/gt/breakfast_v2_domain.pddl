(define (domain breakfast-v2-expert)
	(:requirements :strips :typing :preferences :action-costs)
	
	(:types
		food tool hand - object
		container utensil cleaner - tool
		ingredient seasoning - food
		egg tomatosauce milk - ingredient 
		raw_egg boiled_egg - egg
		salt sugar - seasoning
		spoiled_milk fresh_milk - milk
		dish cookware - container
		bowl plate cup - dish
		pan - cookware
	)

	(:functions 
		(total-cost)
		(current-phase)
		(current-verify-priority)
		(current-clean-priority)
		(item-verify-priority ?f - food)
		(item-clean-priority ?c - container)
	)

	(:predicates
		(in ?i - ingredient ?c - container)
		(spoiled_in ?i - ingredient ?c - container)

		; general for ingredients
		(cooked ?i - ingredient)
		(uncooked ?i - ingredient)
		(heated ?i - ingredient)
		(unheated ?i - ingredient)
		(seasoned ?i - ingredient ?s - seasoning)
		(unseasoned ?i - ingredient ?s - seasoning)
		(topped_with ?base - ingredient ?topping - ingredient)
		(untopped_with ?base - ingredient ?topping - ingredient)
		(plated ?i - ingredient)
		(unplated ?i - ingredient)
		(permanantly_removed ?i - ingredient)

		; specific to eggs
		(shelled ?e - egg)
		(cracked ?e - egg)
		(beated ?e - egg)
		(unbeated ?e - egg)
		(is_raw_egg ?e - egg)
		(is_boiled_egg ?e - egg)
		(verified_raw_egg ?e - egg)
		(verified_boiled_egg ?e - egg)
		
		; specific to milk
		(is_spoiled_milk ?m - milk)
		(is_fresh_milk ?m - milk)
		(verified_spoiled_milk ?m - milk)
		(verified_fresh_milk ?m - milk)

		; specific to canned items
		(canned ?i - ingredient)
		(uncanned ?i - ingredient)
		(can_opened ?i - ingredient)
		(can_unopened ?i - ingredient)

		; specific to containers
		(occupied ?c - container)
		(unoccupied ?c - container)
		(microwave_safe ?c - container)
		(microwave_unsafe ?c - container)
		(stubborn_sticking ?c - container)

		; for tools
		(damaged ?t - tool)
		(undamaged ?t - tool)
		(delicate ?t - tool)
		(non_delicate ?t - tool)
		(clean ?t - tool)
		(dirty ?t - tool)

		; for cookware
		(preheated ?c - cookware)
		(not_preheated ?c - cookware)

		; specific to cleaners
		(harsh_cleaner ?c - cleaner)
		(soft_cleaner ?c - cleaner)

		(is_salt ?s - seasoning)
		(is_sugar ?s - seasoning)
		(is_salted ?i - ingredient)
		(is_sugared ?i - ingredient)
		(verified_salt ?s - seasoning)
		(verified_sugar ?s - seasoning)

		; flags
		(tried_raw_egg_first)
		(used_blind_egg_crack)
		(egg_plated)
		(extra_verify)
		(extra_soft_clean)

		(is_cooking)
		(is_cleaning) 
		(is_fresh_milk_poured)
		(is_egg_ready_to_cook)
	)

	; verification actions
	(:action verify_is_salt
		:parameters (?s - seasoning)
		:precondition (and
			(= (current-phase) 1)
			(= (current-verify-priority) (item-verify-priority ?s))
			(is_cooking)
			(is_salt ?s)
		)
		:effect (and
			(verified_salt ?s)
			(assign (current-verify-priority) (+ (current-verify-priority) 1))
		)
	)

	(:action verify_is_sugar
		:parameters (?s - seasoning)
		:precondition (and
			(= (current-phase) 1)
			(= (current-verify-priority) (item-verify-priority ?s))
			(is_cooking)
			(is_sugar ?s)
		)
		:effect (and
			(verified_sugar ?s)
			(assign (current-verify-priority) (+ (current-verify-priority) 1))
		)
	)

	(:action verify_is_raw_egg
		:parameters (?e - egg)
		:precondition (and
			(= (current-phase) 1)
			(= (current-verify-priority) (item-verify-priority ?e))
			(is_cooking)
			(is_raw_egg ?e)
		)
		:effect (and
			(verified_raw_egg ?e)
			(assign (current-verify-priority) (+ (current-verify-priority) 1))
		)
	)

	(:action verify_is_boiled_egg
		:parameters (?e - egg)
		:precondition (and
			(= (current-phase) 1)
			(= (current-verify-priority) (item-verify-priority ?e))
			(is_cooking)
			(is_boiled_egg ?e)
		)
		:effect (and
			(verified_boiled_egg ?e)
			(assign (current-verify-priority) (+ (current-verify-priority) 1))
		)
	)

	(:action skip_verification
		:parameters ()
		:precondition (and
			(= (current-phase) 1)
		)
		:effect (and
			(assign (current-verify-priority) (+ (current-verify-priority) 1))
		)
	)

	; Pan related actions
	(:action preheat_pan
		:parameters (?p - pan ?e - egg)
		:precondition (and
			(= (current-phase) 3)
			(is_cooking)
			(is_egg_ready_to_cook)
			(not_preheated ?p)
			(clean ?p)
			(unoccupied ?p)
		)
		:effect (and 
			(not (not_preheated ?p))
			(preheated ?p)
		)
	)

	; Crack egg actions
	(:action crack_egg_raw
		:parameters (?e - egg ?b - bowl)
		:precondition (and 
			(= (current-phase) 3)
			(is_cooking)
			(verified_raw_egg ?e)
			(shelled ?e)
			(clean ?b)
			(unoccupied ?b)
		)
		:effect (and
			(cracked ?e)
			(not (shelled ?e))
			(dirty ?b)
			(not (clean ?b))
			(in ?e ?b)
			(occupied ?b)
			(not (unoccupied ?b))
		)
	)

	(:action crack_egg_boiled
		:parameters (?e - egg ?b - bowl)
		:precondition (and 
			(= (current-phase) 3)
			(is_cooking)
			(verified_boiled_egg ?e)
			(shelled ?e)
			(clean ?b)
			(unoccupied ?b)
		)
		:effect (and
			(not (shelled ?e))
			(dirty ?b)
			(not (clean ?b))
			(in ?e ?b)
			(occupied ?b)
			(not (unoccupied ?b))
		)
	)

	(:action crack_egg_thinks_raw_is_boiled
		:parameters (?e - raw_egg ?b - bowl)
		:precondition (and
			(= (current-phase) 3)
			(is_cooking)
			(is_boiled_egg ?e)
			(shelled ?e)
			(clean ?b)
			(unoccupied ?b)
		)
		:effect (and 
			(verified_boiled_egg ?e)
			(tried_raw_egg_first)
			(used_blind_egg_crack)
		)
	)

	(:action crack_egg_thinks_raw_is_raw
		:parameters (?e - raw_egg ?b - bowl)
		:precondition (and 
			(= (current-phase) 3)
			(is_cooking)
			(is_raw_egg ?e)
			(shelled ?e)
			(clean ?b)
			(unoccupied ?b)
		)
		:effect (and
			(verified_raw_egg ?e)
			(cracked ?e)
			(not (shelled ?e))
			(dirty ?b)
			(not (clean ?b))
			(in ?e ?b)
			(occupied ?b)
			(not (unoccupied ?b))
			(tried_raw_egg_first)
			(used_blind_egg_crack)
		)
	)

	(:action crack_egg_thinks_boiled_is_boiled
		:parameters (?e - boiled_egg ?b - bowl)
		:precondition (and 
			(= (current-phase) 3)
			(is_cooking)
			(tried_raw_egg_first)
			(is_boiled_egg ?e)
			(shelled ?e)
			(clean ?b)
			(unoccupied ?b)
		)
		:effect (and
			(not (shelled ?e))
			(dirty ?b)
			(not (clean ?b))
			(in ?e ?b)
			(occupied ?b)
			(not (unoccupied ?b))
			(used_blind_egg_crack)
		)
	)

	(:action crack_egg_thinks_boiled_is_raw
		:parameters (?e - boiled_egg ?b - bowl)
		:precondition (and 
			(= (current-phase) 3)
			(is_cooking)
			(tried_raw_egg_first)
			(is_raw_egg ?e)
			(shelled ?e)
			(clean ?b)
			(unoccupied ?b)
		)
		:effect (and
			(verified_raw_egg ?e)
			(cracked ?e)
			(not (shelled ?e))
			(dirty ?b)
			(not (clean ?b))
			(in ?e ?b)
			(occupied ?b)
			(not (unoccupied ?b))
			(used_blind_egg_crack)
		)
	)

	; Beat egg action
	(:action beat_egg
		:parameters (?e - egg ?b - bowl)
		:precondition (and
			(= (current-phase) 3)
			(is_cooking)
			(verified_raw_egg ?e)
			(cracked ?e)
			(in ?e ?b)
			(uncooked ?e)
			(unbeated ?e)
		)
		:effect (and
			(beated ?e)
			(not (unbeated ?e))    
		)
	)

	; Season egg actions
	(:action season_egg_blind_sugar
		:parameters (?e - egg ?s - sugar ?b - bowl)
		:precondition (and
			(= (current-phase) 3)
			(is_cooking)
			(in ?e ?b)
			(uncooked ?e)
			(unseasoned ?e ?s)
			(beated ?e)
		)
		:effect (and
			(seasoned ?e ?s)
			(not (unseasoned ?e ?s))
			(is_sugared ?e)
			(is_egg_ready_to_cook)
			(increase (total-cost) 1)
		)
	)

	(:action season_egg_blind_salt
		:parameters (?e - egg ?s - salt ?b - bowl)
		:precondition (and
			(= (current-phase) 3)
			(is_cooking)
			(in ?e ?b)
			(uncooked ?e)
			(unseasoned ?e ?s)
			(beated ?e)
		)
		:effect (and
			(seasoned ?e ?s)
			(not (unseasoned ?e ?s))
			(is_salted ?e)
			(is_egg_ready_to_cook)
			(increase (total-cost) 1)
		)
	)

	(:action season_egg_with_sugar
		:parameters (?e - egg ?s - seasoning ?b - bowl)
		:precondition (and
			(= (current-phase) 3)
			(is_cooking)
			(in ?e ?b) 
			(uncooked ?e) 
			(unseasoned ?e ?s) 
			(beated ?e)
			(verified_sugar ?s)
		)
		:effect (and
			(seasoned ?e ?s)
			(not (unseasoned ?e ?s))
			(is_sugared ?e)
			(is_egg_ready_to_cook)
		)
	)

	(:action season_egg_with_salt
		:parameters (?e - egg ?s - seasoning ?b - bowl)
		:precondition (and
			(= (current-phase) 3)
			(is_cooking)
			(in ?e ?b) 
			(uncooked ?e) 
			(unseasoned ?e ?s) 
			(beated ?e)
			(verified_salt ?s)
		)
		:effect (and
			(seasoned ?e ?s)
			(not (unseasoned ?e ?s))
			(is_salted ?e)
			(is_egg_ready_to_cook)
		)
	)

	; Ingredient transfer actions
	(:action transfer_ingredient
		:parameters (?i - ingredient ?source - container ?dest - container)
		:precondition (and
			(= (current-phase) 3)
			(is_cooking)
			(in ?i ?source)
			(clean ?dest)
			(unoccupied ?dest)
			(unplated ?i)
		)
		:effect (and
			(not (in ?i ?source))
			(in ?i ?dest)
			(not (clean ?dest))
			(dirty ?dest)
			(not (occupied ?source))
			(unoccupied ?source)
			(occupied ?dest)
			(not (unoccupied ?dest))
		)
	)

	(:action dispose_ingredient
		:parameters (?i - ingredient ?c - container)
		:precondition (in ?i ?c)
		:effect (and 
			(is_cooking)
			(not (in ?i ?c))
			(not (occupied ?c))
			(unoccupied ?c)
			(permanantly_removed ?i)
			(unplated ?i)
			(not (plated ?i))
			(increase (total-cost) 1)
		)
	)

	; Cooking actions
	(:action cook_ingredient_in_non_preheated
		:parameters (?i - ingredient ?c - cookware)
		:precondition (and 
			(= (current-phase) 3)
			(is_cooking)
			(uncooked ?i)
			(in ?i ?c)
			(not_preheated ?c)
		)
		:effect (and 
			(cooked ?i)
			(not (uncooked ?i))
			(stubborn_sticking ?c)
		)
	)

	(:action cook_ingredient_in_preheated
		:parameters (?i - ingredient ?c - cookware)
		:precondition (and
			(= (current-phase) 3)
			(is_cooking)
			(uncooked ?i)
			(in ?i ?c)
			(preheated ?c)
		)
		:effect (and 
			(cooked ?i)
			(not (uncooked ?i))
		)
	)

	; Canned object actions
	(:action open_can
		:parameters (?i - ingredient)
		:precondition (and 
			(= (current-phase) 4)
			(is_cooking)
			(egg_plated)
			(canned ?i)
			(can_unopened ?i)
		)
		:effect (and
			(can_opened ?i)
			(not (can_unopened ?i))
		)
	)

	(:action dump_can_to
		:parameters (?i - ingredient ?b - bowl)
		:precondition (and 
			(= (current-phase) 4)
			(is_cooking)
			(canned ?i)
			(can_opened ?i)
			(unoccupied ?b)
			(clean ?b)
		)
		:effect (and 
			(in ?i ?b)
			(uncanned ?i)
			(not (canned ?i))
			(occupied ?b)
			(not (unoccupied ?b))
			(not (clean ?b))
			(dirty ?b)
		)
	)

	; Serve milk actions
	(:action serve_milk_blind_spoiled
		:parameters (?m - fresh_milk ?c - cup)
		:precondition (and 
			(= (current-phase) 2)
			(is_cooking)
			(unoccupied ?c)
			(clean ?c)
			(is_spoiled_milk ?m)
		)
		:effect (and 
			(verified_spoiled_milk ?m)
			(spoiled_in ?m ?c)
			(in ?m ?c)
			(occupied ?c)
			(not (unoccupied ?c))
			(not (clean ?c))
			(dirty ?c)
		)
	)

	(:action serve_milk_blind_fresh
		:parameters (?m - fresh_milk ?c - cup)
		:precondition (and 
			(= (current-phase) 2)
			(is_cooking)
			(unoccupied ?c)
			(clean ?c)
			(is_fresh_milk ?m)
		)
		:effect (and 
			(is_fresh_milk_poured)
			(verified_fresh_milk ?m)
			(in ?m ?c)
			(occupied ?c)
			(not (unoccupied ?c))
			(not (clean ?c))
			(dirty ?c)
		)
	)

	; Microwaving actions
	(:action microwave_ingredient_unsafe
		:parameters (?i - ingredient ?d - dish)
		:precondition (and
			(= (current-phase) 4)
			(is_cooking)
			(in ?i ?d)
			(unheated ?i)
			(unplated ?i)
			(microwave_unsafe ?d)
		)
		:effect (and
			(heated ?i)
			(not (unheated ?i))
			(damaged ?d)
			(not (undamaged ?d))
		)
	)
	(:action microwave_ingredient_safe
		:parameters (?i - ingredient ?d - dish)
		:precondition (and
			(= (current-phase) 4)
			(is_cooking)
			(in ?i ?d)
			(unheated ?i)
			(unplated ?i)
			(microwave_safe ?d)
		)
		:effect (and 
			(heated ?i)
			(not (unheated ?i))
		)
	)

	; Topping and plating actions
	(:action add_topping
		:parameters (?base - ingredient ?topping - ingredient ?d - dish)
		:precondition (and
			(= (current-phase) 5)
			(is_cooking)
			(in ?topping ?d)
			(plated ?base)
			(untopped_with ?base ?topping)
			(unplated ?topping)
		)
		:effect (and 
			(topped_with ?base ?topping)
			(plated ?topping)
			(not (unplated ?topping))
			(not (in ?topping ?d))
			(not (occupied ?d))
			(unoccupied ?d)
		)
	)

	(:action plate_egg
		:parameters (?i - egg ?source - container ?p - plate)
		:precondition (and 
			(= (current-phase) 3)
			(is_cooking)
			(in ?i ?source)
			(unoccupied ?p)
			(clean ?p)
		)
		:effect (and
			(in ?i ?p)
			(occupied ?p)
			(not (unoccupied ?p))
			(plated ?i)
			(not (unplated ?i))
			(not (in ?i ?source))
			(not (occupied ?source))
			(unoccupied ?source)
			(egg_plated)
		)
	)

	; Cleaning actions
	(:action clean_container_harsh_damaging
		:parameters (?c - container ?cleaner - cleaner)
		:precondition (and 
			(= (current-phase) 6)
			(= (current-clean-priority) (item-clean-priority ?c))
			(dirty ?c)
			(unoccupied ?c)
			(harsh_cleaner ?cleaner)
		)
		:effect (and 
			(is_cleaning)
			(not (is_cooking))
			(clean ?c)
			(not (dirty ?c))
			(damaged ?c)
			(not (undamaged ?c))
			(not (stubborn_sticking ?c))
			(assign (current-clean-priority) (+ (current-clean-priority) 1))
		)
	)

	(:action clean_container_soft
		:parameters (?c - container ?cleaner - cleaner)
		:precondition (and 
			(= (current-phase) 6)
			(= (current-clean-priority) (item-clean-priority ?c))
			(dirty ?c)
			(unoccupied ?c)
			(soft_cleaner ?cleaner)
		)
		:effect (and
			(is_cleaning)
			(not (is_cooking))
			(clean ?c)
			(not (dirty ?c))
			(dirty ?cleaner)
			(assign (current-clean-priority) (+ (current-clean-priority) 1))
		)
	)

	(:action switch_back_to_cooking
		:parameters ()
		:precondition (and 
			(is_cleaning)
		)
		:effect (and 
			(is_cooking)
			(not (is_cleaning))
			(increase (total-cost) 1)
		)
	)

	(:action go_to_next_phase
		:parameters ()
		:precondition (and )
		:effect (and
			(assign (current-phase) (+ (current-phase) 1))
		)
	)
)