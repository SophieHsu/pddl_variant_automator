(define (domain moveout-v1-expert-fixed)
	(
		:requirements
		:strips
		:typing
		:preferences
		:action-costs
		:negative-preconditions
	)
	(
		:types
		locations item - object
		room truck - locations
		box tape label cart cleaner key - tools
		fragile_item - item
	)
	(
		:predicates
		(box-at ?b - box ?r - room)
		(in-room ?i - item ?r - room)
		(in-box ?i - item ?b - box)
		(wrapped ?i - item)
		(undamaged ?i - item)
		(unoccupied ?b - box)
		(labeled ?b - box)
		(unsealed ?b - box)
		(sealed ?b - box)
		(on-cart ?b - box ?c - cart)
		(in-truck ?b - box ?tr - truck)
		(cart-avaliable ?c - cart)
		(cart-unavaliable ?c - cart)
		(hard-cleaner ?cl - cleaner)
		(soft-cleaner ?cl - cleaner)
		(floor-clean ?r - room)
		(floor-undamaged ?r - room)
		(trash-removed ?r - room)
		(room-finished ?r - room)
		(room-unfinished ?r - room)
		(room-uninspected ?r - room)
		(room-inspected ?r - room)
		(keys-returned ?k)
		(keys-in-hand ?k)
		(room-locked ?r - room)
		(room-unlocked ?r - room)
		(used-blind-pack)
		(current-room ?r - room)
		(next-room ?a - room ?b - room)
		(item-stage-prep ?i - item)
		(item-stage-wrapped ?i - item)
		(item-stage-boxed ?i - item)
		(item-stage-sealed ?i - item)
		(item-stage-carted ?i - item)
		(item-stage-loaded ?i - item)
		(room-stage-pack ?r - room)
		(room-stage-clean ?r - room)
		(room-stage-inspect ?r - room)
		(room-stage-done ?r - room)
		(assigned-box ?i - item ?b - box)
		(assigned-label ?b - box ?l - label)
		(final-room ?r - room)
		(moveout-complete)
		(enable-risky)
	)
	(
		:functions
		(total-cost)
		(boxes-left ?r - room)
		(tape-length ?t - tape)
		(cleaner-amount ?cl - cleaner)
		(trashbags-left)
	)
	(:action move_to_room
		:parameters (?from - room ?to - room)
		:precondition (and 
			(room-uninspected ?to)
			(current-room ?from)
			(next-room ?from ?to)
			(room-stage-done ?from)
		)
		:effect (and
			(current-room ?to)
			(not (current-room ?from))
		)
	)
	(:action wrap_item
		:parameters (?i - item ?r - room)
		:precondition (and 
			(room-unlocked ?r)
			(room-unfinished ?r)
			(in-room ?i ?r)
			(undamaged ?i)
			(current-room ?r)
			(item-stage-prep ?i)
		)
		:effect (and
			(item-stage-wrapped ?i)
			(not (item-stage-prep ?i))
		)
	)
	(:action wrap_fragile
		:parameters (?i - fragile_item ?r - room)
		:precondition (and 
			(room-unlocked ?r)
			(room-unfinished ?r)
			(in-room ?i ?r)
			(undamaged ?i)
			(current-room ?r)
		)
		:effect (and
			(item-stage-wrapped ?i)
			(not (item-stage-prep ?i))
		)
	)
	(:action pack_item_safe
		:parameters (?i - item ?b - box ?r - room)
		:precondition (and 
			(room-unlocked ?r)
			(room-unfinished ?r)
			(in-room ?i ?r)
			(unsealed ?b)
			(unoccupied ?b)
			(undamaged ?i)
			(wrapped ?i)
			(current-room ?r)
			(item-stage-wrapped ?i)
			(assigned-box ?i ?b)
		)
		:effect (and
			(item-stage-boxed ?i)
			(not (item-stage-wrapped ?i))
			(in-box ?i ?b)
			(room-stage-pack ?r)
			(box-at ?b ?r)
			(
				not
				(in-room ?i ?r)
			)
			(not (unoccupied ?b))
			(not (floor-clean ?r))
		)
	)
	(:action pack_item_blind
		:parameters (?i - item ?b - box ?r - room)
		:precondition (and 
			(room-unlocked ?r)
			(room-unfinished ?r)
			(in-room ?i ?r)
			(unsealed ?b)
			(unoccupied ?b)
			(current-room ?r)
			(enable-risky)
			(item-stage-wrapped ?i)
			(assigned-box ?i ?b)
		)
		:effect (and
			(item-stage-boxed ?i)
			(not (item-stage-wrapped ?i))
			(in-box ?i ?b)
			(box-at ?b ?r)
			(room-stage-pack ?r)
			(
				not
				(in-room ?i ?r)
			)
			(not (unoccupied ?b))
			(not (floor-clean ?r))
			(not (undamaged ?i))
			(used-blind-pack)
		)
	)
	(:action label_box
		:parameters (?b - box ?l - label ?r - room)
		:precondition (and 
			(room-unlocked ?r)
			(room-unfinished ?r)
			(box-at ?b ?r)
			(sealed ?b)
			(current-room ?r)
			(assigned-label ?b ?l)
		)
		:effect (and
			(labeled ?b)
			(not (floor-clean ?r))
		)
	)
	(:action seal_box
		:parameters (?b - box ?t - tape ?r - room)
		:precondition (and 
			(room-unlocked ?r)
			(room-unfinished ?r)
			(> (tape-length ?t) 0)
			(box-at ?b ?r)
			(current-room ?r)
		)
		:effect (and
			(not (unsealed ?b))
			(not (floor-clean ?r))
			(decrease (tape-length ?t) 1)
		)
	)
	(:action move_box_to_cart
		:parameters (?b - box ?c - cart ?r - room)
		:precondition (and 
			(room-unlocked ?r)
			(room-unfinished ?r)
			(box-at ?b ?r)
			(cart-avaliable ?c)
			(sealed ?b)
			(current-room ?r)
		)
		:effect (and
			(on-cart ?b ?c)
			((cart-unavaliable ?c))
			(not (cart-avaliable ?c))
			(not (floor-clean ?r))
			(
				not
				(box-at ?b ?r)
			)
		)
	)
	(:action load_truck
		:parameters (?b - box ?c - cart ?tr - truck ?r - room)
		:precondition (and 
			(room-unlocked ?r)
			(on-cart ?b ?c)
		)
		:effect (and
			(in-truck ?b ?tr)
			(cart-avaliable ?c)
			(not (cart-unavaliable ?c))
			(
				not
				(on-cart ?b ?c)
			)
			(decrease (boxes-left ?r) 1)
		)
	)
	(:action declare_room_moved_out
		:parameters (?r - room)
		:precondition (and 
			(room-unlocked ?r)
			(room-unfinished ?r)
			(current-room ?r)
			(= (boxes-left ?r) 0)
		)
		:effect (and
			(room-stage-clean ?r)
			(room-finished ?r)
			(not (room-unfinished ?r))
			(not (room-stage-pack ?r))
		)
	)
	(:action sweep_floor_soft
		:parameters (?r - room ?cl - cleaner)
		:precondition (and 
			(room-unlocked ?r)
			(room-finished ?r)
			(soft-cleaner ?cl)
			(> (cleaner-amount ?cl) 0)
			(current-room ?r)
			(room-stage-clean ?r)
		)
		:effect (and
			(decrease (cleaner-amount ?cl) 1)
			(floor-clean ?r)
		)
	)
	(:action sweep_floor_harsh
		:parameters (?r - room ?cl - cleaner)
		:precondition (and 
			(room-unlocked ?r)
			(room-finished ?r)
			(hard-cleaner ?cl)
			(> (cleaner-amount ?cl) 0)
			(current-room ?r)
			(enable-risky)
			(room-stage-clean ?r)
		)
		:effect (and
			(floor-clean ?r)
			(not (floor-undamaged ?r))
			(decrease (cleaner-amount ?cl) 1)
			(increase (total-cost) 10000)
		)
	)
	(:action bag_trash
		:parameters (?r - room)
		:precondition (and 
			(room-unlocked ?r)
			(room-finished ?r)
			(> (trashbags-left) 0)
			(current-room ?r)
			(room-stage-clean ?r)
		)
		:effect (and
			(trash-removed ?r)
			(room-stage-inspect ?r)
			(not (room-stage-clean ?r))
			(decrease (trashbags-left) 1)
		)
	)
	(:action lock_room
		:parameters (?k - key ?r - room)
		:precondition (and 
			(keys-in-hand ?k)
			(current-room ?r)
			(room-stage-done ?r)
		)
		:effect (and
			(room-locked ?r)
			(not (room-unlocked ?r))
		)
	)
	(:action unlock_room
		:parameters (?k - key ?r - room)
		:precondition (and 
			(keys-in-hand ?k)
			(current-room ?r)
		)
		:effect (and
			(room-unlocked ?r)
			(not (room-locked ?r))
		)
	)
	(:action inspect_room
		:parameters (?r - room)
		:precondition (and 
			(room-unlocked ?r)
			(room-finished ?r)
			(floor-clean ?r)
			(current-room ?r)
			(room-stage-inspect ?r)
		)
		:effect (and
			(room-stage-done ?r)
		)
		(room-inspected ?r)
		(not (room-uninspected ?r))
	)
	(:action return_keys
		:parameters (?k - key)
		:precondition (and 
			(keys-in-hand ?k)
			(moveout-complete)
		)
		:effect (and
			(keys-returned ?k)
			(not (keys-in-hand ?k))
		)
	)
	(:action mark_moveout_complete
		:parameters (?r - room)
		:precondition (and 
			(final-room ?r)
			(room-stage-done ?r)
		)
		:effect (moveout-complete)
	)
)
