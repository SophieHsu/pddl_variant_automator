(define (domain breakfast-v1-expert)
	(:requirements :strips :typing :preferences :action-costs)
	(
		:types
		food tool cleaner hand - object
		container utensil - tool
		ingredient seasoning - food
		egg tomatosauce milk - ingredient
		raw_egg boiled_egg - egg
		salt sugar - seasoning
		spoiled_milk fresh_milk - milk
		dish cookware - container
		bowl plate cup - dish
		pan - cookware
	)
	(:functions (total-cost))
	(
		:predicates
		(in ?i - ingredient ?c - container)
		(spoiled_in ?i - ingredient ?c - container)
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
		(shelled ?e - egg)
		(cracked ?e - egg)
		(beated ?e - egg)
		(unbeated ?e - egg)
		(is_raw_egg ?e - egg)
		(is_boiled_egg ?e - egg)
		(verified_raw_egg ?e - egg)
		(verified_boiled_egg ?e - egg)
		(is_spoiled_milk ?m - milk)
		(is_fresh_milk ?m - milk)
		(verified_spoiled_milk ?m - milk)
		(verified_fresh_milk ?m - milk)
		(canned ?i - ingredient)
		(uncanned ?i - ingredient)
		(can_opened ?i - ingredient)
		(can_unopened ?i - ingredient)
		(occupied ?c - container)
		(unoccupied ?c - container)
		(microwave_safe ?c - container)
		(microwave_unsafe ?c - container)
		(stubborn_sticking ?c - container)
		(damaged ?t - tool)
		(undamaged ?t - tool)
		(delicate ?t - tool)
		(non_delicate ?t - tool)
		(clean ?t - tool)
		(dirty ?t - tool)
		(preheated ?c - cookware)
		(not_preheated ?c - cookware)
		(harsh_cleaner ?c - cleaner)
		(soft_cleaner ?c - cleaner)
		(clean_hand ?h - hand)
		(dirty_hand ?h - hand)
		(is_salt ?s - seasoning)
		(is_sugar ?s - seasoning)
		(is_salted ?i - ingredient)
		(is_sugared ?i - ingredient)
		(verified_salt ?s - seasoning)
		(verified_sugar ?s - seasoning)
		(tried_raw_egg_first)
		(used_blind_egg_crack)
	)
	(:action verify_is_salt
		:parameters (?s - seasoning)
		:precondition (is_salt ?s)
		:effect (verified_salt ?s)
	)
	(:action verify_is_sugar
		:parameters (?s - seasoning)
		:precondition (is_sugar ?s)
		:effect (verified_sugar ?s)
	)
	(:action verify_is_raw_egg
		:parameters (?e - egg)
		:precondition (is_raw_egg ?e)
		:effect (verified_raw_egg ?e)
	)
	(:action verify_is_boiled_egg
		:parameters (?e - egg)
		:precondition (is_boiled_egg ?e)
		:effect (verified_boiled_egg ?e)
	)
	(:action preheat_pan
		:parameters (?p - pan)
		:precondition (and 
			(not_preheated ?p)
			(clean ?p)
			(unoccupied ?p)
		)
		:effect (and
			(not (not_preheated ?p))
			(preheated ?p)
		)
	)
	(:action crack_egg_raw
		:parameters (?e - egg ?b - bowl)
		:precondition (and 
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
	(:action beat_egg
		:parameters (?e - egg ?b - bowl)
		:precondition (and 
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
	(:action season_egg_blind_sugar
		:parameters (?e - egg ?s - sugar ?d - dish)
		:precondition (and 
			(in ?e ?d)
			(uncooked ?e)
			(unseasoned ?e ?s)
			(cracked ?e)
		)
		:effect (and
			(seasoned ?e ?s)
			(
				not
				(unseasoned ?e ?s)
			)
			(is_sugared ?e)
			(increase (total-cost) 1)
		)
	)
	(:action season_egg_blind_salt
		:parameters (?e - egg ?s - salt ?d - dish)
		:precondition (and 
			(in ?e ?d)
			(uncooked ?e)
			(unseasoned ?e ?s)
			(cracked ?e)
		)
		:effect (and
			(seasoned ?e ?s)
			(
				not
				(unseasoned ?e ?s)
			)
			(is_salted ?e)
			(increase (total-cost) 1)
		)
	)
	(:action season_egg_with_sugar
		:parameters (?e - egg ?s - seasoning ?d - dish)
		:precondition (and 
			(in ?e ?d)
			(uncooked ?e)
			(unseasoned ?e ?s)
			(cracked ?e)
			(verified_sugar ?s)
		)
		:effect (and
			(seasoned ?e ?s)
			(
				not
				(unseasoned ?e ?s)
			)
			(is_sugared ?e)
		)
	)
	(:action season_egg_with_salt
		:parameters (?e - egg ?s - seasoning ?d - dish)
		:precondition (and 
			(in ?e ?d)
			(uncooked ?e)
			(unseasoned ?e ?s)
			(cracked ?e)
			(verified_salt ?s)
		)
		:effect (and
			(seasoned ?e ?s)
			(
				not
				(unseasoned ?e ?s)
			)
			(is_salted ?e)
		)
	)
	(:action transfer_ingredient
		:parameters (?i - ingredient ?source - container ?dest - container)
		:precondition (and 
			(in ?i ?source)
			(clean ?dest)
			(unoccupied ?dest)
			(unplated ?i)
		)
		:effect (and
			(
				not
				(in ?i ?source)
			)
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
			(
				not
				(in ?i ?c)
			)
			(not (occupied ?c))
			(unoccupied ?c)
			(permanantly_removed ?i)
			(unplated ?i)
			(not (plated ?i))
		)
	)
	(:action cook_ingredient_in_non_preheated
		:parameters (?i - ingredient ?c - cookware)
		:precondition (and 
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
			(uncooked ?i)
			(in ?i ?c)
			(preheated ?c)
		)
		:effect (and
			(cooked ?i)
			(not (uncooked ?i))
			(increase (total-cost) 500)
		)
	)
	(:action open_can
		:parameters (?i - ingredient)
		:precondition (and 
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
	(:action serve_milk_blind_spoiled
		:parameters (?m - fresh_milk ?c - cup)
		:precondition (and 
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
			(unoccupied ?c)
			(clean ?c)
			(is_fresh_milk ?m)
		)
		:effect (and
			(verified_fresh_milk ?m)
			(in ?m ?c)
			(occupied ?c)
			(not (unoccupied ?c))
			(not (clean ?c))
			(dirty ?c)
		)
	)
	(:action microwave_ingredient_unsafe
		:parameters (?i - ingredient ?d - dish)
		:precondition (and 
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
	(:action add_topping
		:parameters (?base - ingredient ?topping - ingredient ?d - dish)
		:precondition (and 
			(in ?topping ?d)
			(plated ?base)
			(untopped_with ?base ?topping)
			(unplated ?topping)
		)
		:effect (and
			(topped_with ?base ?topping)
			(plated ?topping)
			(not (unplated ?topping))
			(
				not
				(in ?topping ?d)
			)
			(not (occupied ?d))
			(unoccupied ?d)
		)
	)
	(:action plate
		:parameters (?i - ingredient ?source - container ?p - plate)
		:precondition (and 
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
			(
				not
				(in ?i ?source)
			)
			(not (occupied ?source))
			(unoccupied ?source)
		)
	)
	(:action clean_container_harsh_damaging
		:parameters (?c - container ?cleaner - cleaner)
		:precondition (and 
			(dirty ?c)
			(unoccupied ?c)
			(harsh_cleaner ?cleaner)
			(delicate ?c)
		)
		:effect (and
			(clean ?c)
			(not (dirty ?c))
			(damaged ?c)
			(not (undamaged ?c))
			(not (stubborn_sticking ?c))
		)
	)
	(:action clean_container_soft
		:parameters (?c - container ?cleaner - cleaner)
		:precondition (and 
			(dirty ?c)
			(unoccupied ?c)
			(soft_cleaner ?cleaner)
		)
		:effect (and
			(clean ?c)
			(not (dirty ?c))
		)
	)
	(:action clean_container_harsh_safe
		:parameters (?c - container ?cleaner - cleaner)
		:precondition (and 
			(dirty ?c)
			(unoccupied ?c)
			(harsh_cleaner ?cleaner)
			(non_delicate ?c)
		)
		:effect (and
			(clean ?c)
			(not (dirty ?c))
		)
	)
)
