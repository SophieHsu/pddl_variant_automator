
(define (domain moveout-v1-expert-fixed)
  (:requirements :strips :typing :preferences :action-costs)
  (:types
    locations item - object
    room truck - locations
    box tape label cart cleaner key trashbag - tools
    fragile_item - item
  )

  (:predicates
    ;; item locations and states
    (at-room ?r - room)
    (box-at ?b - box ?r - room)
    (in-room ?i - item ?r - room)
    (in-box ?i - item ?b - box)
    (wrapped ?i - item)
    (undamaged ?i - item)

    ;; boxes and logistics
    (unoccupied ?b - box)
    (labeled ?b - box)
    (unsealed ?b - box)
    (sealed ?b - box)
    (on-cart ?b - box)
    (in-truck ?b - box)

    ;; rooms and handover
    (floor-clean ?r - room)
    (floor-undamaged ?r - room)
    (trash-removed ?r - room)
    (room-finished ?r - room)
    (room-unfinished ?r - room)
    (room-uninspected ?r - room)
    (room-inspected ?r - room)

    (keys-returned)
    (keys-in-hand)
    (room-locked)
    (room-unlocked)

    ;; helper
    (used-blind-pack)
  )

  (:functions (total-cost))

  ;; --- Moving between rooms ---
  (:action move_to_room
    :parameters (?from - room ?to - room)
    :precondition (and 
      (at-room ?from)
      (room-uninspected ?to)
    )
    :effect (and 
      (at-room ?to)
      (not (at-room ?from))
      ; (increase (total-cost) 1)
    )
  )

  ;; --- Packing workflow ---

  ;; general wrap (works for any item, not just fragile)
  (:action wrap_item
    :parameters (?i - item ?r - room)
    :precondition (and 
      (room-unlocked)
      (keys-in-hand)
      (room-unfinished ?r)
      (in-room ?i ?r) 
      (at-room ?r)
      (undamaged ?i)
    )
    :effect (and
      (wrapped ?i)
      (not (floor-clean ?r))
      ; (increase (total-cost) 2)
    )
  )

  (:action wrap_fragile
    :parameters (?i - fragile_item ?r - room)
    :precondition (and 
      (room-unlocked)
      (keys-in-hand)
      (room-unfinished ?r)
      (at-room ?r)
      (in-room ?i ?r)
      (undamaged ?i)
    )
    :effect (and
      (wrapped ?i)
      (not (floor-clean ?r))
      ; (increase (total-cost) 2)
    )
  )

  (:action pack_item_safe
    :parameters (?i - item ?b - box ?r - room)
    :precondition (and 
      (room-unlocked)
      (keys-in-hand)
      (room-unfinished ?r)
      (in-room ?i ?r) 
      (at-room ?r)
      (unsealed ?b)
      (unoccupied ?b)
      (undamaged ?i) 
      (wrapped ?i)
    )
    :effect (and
      (in-box ?i ?b)
      (box-at ?b ?r)
      (not (in-room ?i ?r))
      (not (unoccupied ?b))
      (not (floor-clean ?r))
      ; (increase (total-cost) 3)
    )
  )

  (:action pack_item_blind
    :parameters (?i - item ?b - box ?r - room)
    :precondition (and
      (room-unlocked)
      (keys-in-hand)
      (room-unfinished ?r)
      (in-room ?i ?r)
      (at-room ?r)
      (unsealed ?b)
      (unoccupied ?b)
    )
    :effect (and
      (in-box ?i ?b)
      (box-at ?b ?r)
      (not (in-room ?i ?r))
      (not (unoccupied ?b))
      (not (floor-clean ?r))
      (not (undamaged ?i))
      (used-blind-pack)
      ; (increase (total-cost) 1)
    )
  )

  (:action label_box
    :parameters (?b - box ?l - label ?r - room)
    :precondition (and
      (room-unlocked)
      (keys-in-hand)
      (room-unfinished ?r)
      (at-room ?r)
      (box-at ?b ?r)
      (sealed ?b)
    )
    :effect (and
      (labeled ?b)
      (not (floor-clean ?r))
      ; (increase (total-cost) 1)
    )
  )

  (:action seal_box
    :parameters (?b - box ?t - tape ?r - room)
    :precondition (and 
      (room-unlocked)
      (keys-in-hand)
      (room-unfinished ?r)
      (at-room ?r)
      (box-at ?b ?r)
    )
    :effect (and
      (sealed ?b)
      (not (unsealed ?b))
      (not (floor-clean ?r))
      ; (increase (total-cost) 1)
    )
  )

  (:action move_box_to_cart
    :parameters (?b - box ?c - cart ?r - room)
    :precondition (and 
      (room-unlocked)
      (keys-in-hand)
      (room-unfinished ?r)
      (box-at ?b ?r)
      (at-room ?r)
      (sealed ?b)
    )
    :effect (and
      (on-cart ?b)
      (not (floor-clean ?r))
      (not (box-at ?b ?r))
      ; (increase (total-cost) 1)
    )
  )

  (:action load_truck
    :parameters (?b - box ?c - cart ?tr - truck)
    :precondition (and 
      (room-unlocked)
      (on-cart ?b)
    )
    :effect (and
      (in-truck ?b)
      (not (on-cart ?b))
      ; (increase (total-cost) 2)
    )
  )

  ;; --- Flag to move on to cleaning phase ---
  (:action declare_room_movedout
      :parameters (?r - room)
      :precondition (and 
        (room-unfinished ?r)
        (at-room ?r)
      )
      :effect (and
        (room-finished ?r)
        (not (room-unfinished ?r))
      )
  )
  

  ;; --- Cleaning & trash ---

  (:action sweep_floor_soft
    :parameters (?r - room ?cl - cleaner)
    :precondition (and
      (room-unlocked)
      (room-finished ?r)
      (at-room ?r)
      (keys-in-hand)
    )
    :effect (and
      (floor-clean ?r)
      ; (increase (total-cost) 1)
    )
  )

  (:action sweep_floor_harsh
    :parameters (?r - room ?cl - cleaner)
    :precondition (and
      (room-unlocked)
      (room-finished ?r)
      (at-room ?r)
      (keys-in-hand)
    )
    :effect (and
      (floor-clean ?r)
      (not (floor-undamaged ?r))
      ; (increase (total-cost) 1)
    )
  )

  (:action bag_trash
    :parameters (?r - room ?tb - trashbag)
    :precondition (and
      (room-unlocked)
      (keys-in-hand)
      (room-finished ?r)
      (at-room ?r)
    )
    :effect (and
      (trash-removed ?r)
      (not (floor-clean ?r))
      ; (increase (total-cost) 1)
    )
  )

  (:action lock_room
    :parameters (?k - key)
    :precondition (and 
      (keys-in-hand)
    )
    :effect (and 
      (room-locked)
      (not (room-unlocked))
    )
  )

  (:action unlock_room
    :parameters (?k - key)
    :precondition (and 
      (keys-in-hand)
    )
    :effect (and 
      (room-unlocked)
      (not (room-locked))
    )
  )

  ; final room inspection
  (:action inspect_room
    :parameters (?r - room)
    :precondition (and 
      (room-unlocked)
      (keys-in-hand)
      (room-finished ?r)
      (at-room ?r)
      (floor-clean ?r)
    )
    :effect (and
      (room-inspected ?r)
      (not (room-uninspected ?r))
    )
  )

  (:action return_keys
    :parameters (?k - key)
    :precondition (and
      (keys-in-hand)
    )
    :effect (and
      (keys-returned)
      (not (keys-in-hand))
      ; (increase (total-cost) 1)
    )
  )
)
