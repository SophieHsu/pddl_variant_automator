
(define (domain moveout-v1-expert-fixed)
  (:requirements :strips :typing :preferences :action-costs)
  (:types
    object
    room item box tape label cart truck cleaner key trashbag
    fragile_item - item
  )

  (:predicates
    ;; item locations and states
    (in-room ?i - item ?r - room)
    (in-box ?i - item ?b - box)
    (wrapped ?i - item)
    (undamaged ?i - item)

    ;; boxes and logistics
    (labeled ?b - box)
    (sealed ?b - box)
    (on-cart ?b - box)
    (in-truck ?b - box)

    ;; rooms and handover
    (floor-clean ?r - room)
    (floor-undamaged ?r - room)
    (trash-removed ?r - room)
    (keys-returned)

    ;; helper
    (no-blind-pack)
  )

  (:functions (total-cost))

  ;; --- Packing workflow ---

  ;; general wrap (works for any item, not just fragile)
  (:action wrap_item
    :parameters (?i - item ?r - room)
    :precondition (and (in-room ?i ?r) (undamaged ?i))
    :effect (and
      (wrapped ?i)
      (increase (total-cost) 2)
    )
  )

  (:action wrap_fragile
    :parameters (?i - fragile_item ?r - room)
    :precondition (and (in-room ?i ?r) (undamaged ?i))
    :effect (and
      (wrapped ?i)
      (increase (total-cost) 2)
    )
  )

  (:action pack_item_safe
    :parameters (?i - item ?b - box ?r - room)
    :precondition (and (in-room ?i ?r) (undamaged ?i) (wrapped ?i))
    :effect (and
      (in-box ?i ?b)
      (not (in-room ?i ?r))
      (no-blind-pack)
      (increase (total-cost) 3)
    )
  )

  (:action pack_item_blind
    :parameters (?i - item ?b - box ?r - room)
    :precondition (and (in-room ?i ?r))
    :effect (and
      (in-box ?i ?b)
      (not (in-room ?i ?r))
      (not (undamaged ?i))
      (increase (total-cost) 1)
    )
  )

  (:action label_box
    :parameters (?b - box ?l - label)
    :precondition (and)
    :effect (and
      (labeled ?b)
      (increase (total-cost) 1)
    )
  )

  (:action seal_box
    :parameters (?b - box ?t - tape)
    :precondition (and (labeled ?b))
    :effect (and
      (sealed ?b)
      (increase (total-cost) 1)
    )
  )

  (:action move_box_to_cart
    :parameters (?b - box ?c - cart)
    :precondition (and (sealed ?b))
    :effect (and
      (on-cart ?b)
      (increase (total-cost) 1)
    )
  )

  (:action load_truck
    :parameters (?b - box ?c - cart ?tr - truck)
    :precondition (and (on-cart ?b))
    :effect (and
      (in-truck ?b)
      (not (on-cart ?b))
      (increase (total-cost) 2)
    )
  )

  ;; --- Cleaning & trash ---

  (:action sweep_floor_soft
    :parameters (?r - room ?cl - cleaner)
    :precondition (and)
    :effect (and
      (floor-clean ?r)
      (increase (total-cost) 2)
    )
  )

  (:action sweep_floor_harsh
    :parameters (?r - room ?cl - cleaner)
    :precondition (and)
    :effect (and
      (floor-clean ?r)
      (not (floor-undamaged ?r))
      (increase (total-cost) 1)
    )
  )

  (:action bag_trash
    :parameters (?r - room ?tb - trashbag)
    :precondition (and)
    :effect (and
      (trash-removed ?r)
      (increase (total-cost) 1)
    )
  )

  (:action return_keys
    :parameters (?k - key)
    :precondition (and)
    :effect (and
      (keys-returned)
      (increase (total-cost) 1)
    )
  )
)
