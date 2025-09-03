
(define (domain laundry-v1-expert)
  (:requirements :strips :typing :preferences :action-costs)
  (:types
    object garment machine basket detergent softener hanger closet
  )

  (:predicates
    (in-hamper ?g - garment)
    (sorted-light ?g - garment)
    (sorted-dark ?g - garment)
    (delicate ?g - garment)

    (in-washer ?g - garment)
    (washed ?g - garment)
    (in-dryer ?g - garment)
    (dried ?g - garment)

    (folded ?g - garment)
    (put-away ?g - garment)
    (fresh-smell ?g - garment)
    (color-bled ?g - garment)
    (undamaged ?g - garment)

    (no-blind-wash)
  )

  (:functions (total-cost))

  ;; Sorting & loading
  (:action sort_light
    :parameters (?g - garment)
    :precondition (and (in-hamper ?g))
    :effect (and
      (sorted-light ?g)
      (increase (total-cost) 1)
    )
  )

  (:action sort_dark
    :parameters (?g - garment)
    :precondition (and (in-hamper ?g))
    :effect (and
      (sorted-dark ?g)
      (increase (total-cost) 1)
    )
  )

  (:action load_washer
    :parameters (?g - garment)
    :precondition (and (sorted-light ?g) (undamaged ?g))
    :effect (and
      (in-washer ?g)
      (not (in-hamper ?g))
      (increase (total-cost) 1)
    )
  )

  (:action load_washer_blind
    :parameters (?g - garment)
    :precondition (and (in-hamper ?g))
    :effect (and
      (in-washer ?g)
      (not (in-hamper ?g))
      (not (undamaged ?g))
      (increase (total-cost) 1)
    )
  )

  ;; Washing (safe vs risky)
  (:action wash_delicate
    :parameters (?g - garment)
    :precondition (and (in-washer ?g) (delicate ?g))
    :effect (and
      (washed ?g)
      (no-blind-wash)
      (increase (total-cost) 3)
    )
  )

  (:action wash_normal
    :parameters (?g - garment)
    :precondition (and (in-washer ?g))
    :effect (and
      (washed ?g)
      (increase (total-cost) 2)
    )
  )

  (:action wash_hot_risky
    :parameters (?g - garment)
    :precondition (and (in-washer ?g))
    :effect (and
      (washed ?g)
      (color-bled ?g)
      (not (undamaged ?g))
      (increase (total-cost) 1)
    )
  )

  ;; Drying
  (:action move_to_dryer
    :parameters (?g - garment)
    :precondition (and (in-washer ?g) (washed ?g))
    :effect (and
      (in-dryer ?g)
      (not (in-washer ?g))
      (increase (total-cost) 1)
    )
  )

  (:action dry_normal
    :parameters (?g - garment)
    :precondition (and (in-dryer ?g))
    :effect (and
      (dried ?g)
      (increase (total-cost) 2)
    )
  )

  (:action hang_dry
    :parameters (?g - garment)
    :precondition (and (washed ?g))
    :effect (and
      (dried ?g)
      (no-blind-wash)
      (increase (total-cost) 1)
    )
  )

  ;; Finish
  (:action add_softener_after
    :parameters (?g - garment)
    :precondition (and (dried ?g))
    :effect (and
      (fresh-smell ?g)
      (increase (total-cost) 1)
    )
  )

  (:action fold
    :parameters (?g - garment)
    :precondition (and (dried ?g))
    :effect (and
      (folded ?g)
      (increase (total-cost) 1)
    )
  )

  (:action put_away
    :parameters (?g - garment)
    :precondition (and (folded ?g))
    :effect (and
      (put-away ?g)
      (increase (total-cost) 1)
    )
  )
)
