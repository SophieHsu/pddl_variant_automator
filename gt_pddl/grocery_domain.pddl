
(define (domain grocery-v1-expert)
  (:requirements :strips :typing :preferences :action-costs)
  (:types
    object person store aisle cart bag item
  )

  (:predicates
    (at-store ?p - person ?s - store)
    (at-aisle ?p - person ?a - aisle)
    (in-cart ?i - item ?c - cart)
    (in-bag ?i - item ?b - bag)
    (purchased ?i - item)
    (fresh ?i - item)
    (fragile ?i - item)
    (unbroken ?i - item)
    (coupon-applied ?i - item)
    (reusable-bag-used ?b - bag)
    (checked-out ?p - person)
    (no-blind-pick)
  )

  (:functions (total-cost))

  (:action go_to_store
    :parameters (?p - person ?s - store)
    :precondition (and)
    :effect (and
      (at-store ?p ?s)
      (increase (total-cost) 5)
    )
  )

  (:action go_to_aisle
    :parameters (?p - person ?a - aisle)
    :precondition (and)
    :effect (and
      (at-aisle ?p ?a)
      (increase (total-cost) 1)
    )
  )

  (:action pick_item_safe
    :parameters (?i - item ?p - person ?a - aisle ?c - cart)
    :precondition (and (at-aisle ?p ?a) (fresh ?i))
    :effect (and
      (in-cart ?i ?c)
      (no-blind-pick)
      (increase (total-cost) 1)
    )
  )

  (:action pick_item_blind
    :parameters (?i - item ?p - person ?a - aisle ?c - cart)
    :precondition (and (at-aisle ?p ?a))
    :effect (and
      (in-cart ?i ?c)
      (not (fresh ?i))
      (increase (total-cost) 0)
    )
  )

  (:action bag_safe
    :parameters (?i - item ?b - bag)
    :precondition (and (in-cart ?i ?b)) ; treat bag as cart for simplicity
    :effect (and
      (in-bag ?i ?b)
      (increase (total-cost) 1)
    )
  )

  (:action bag_toss_risky
    :parameters (?i - item ?b - bag)
    :precondition (and (in-cart ?i ?b))
    :effect (and
      (in-bag ?i ?b)
      (not (unbroken ?i))
      (increase (total-cost) 0)
    )
  )

  (:action apply_coupon
    :parameters (?i - item)
    :precondition (and)
    :effect (and
      (coupon-applied ?i)
      (increase (total-cost) 0)
    )
  )

  (:action checkout_item
    :parameters (?i - item ?p - person)
    :precondition (and)
    :effect (and
      (purchased ?i)
      (checked-out ?p)
      (increase (total-cost) 2)
    )
  )

  (:action use_reusable_bag
    :parameters (?b - bag)
    :precondition (and)
    :effect (and
      (reusable-bag-used ?b)
      (increase (total-cost) 0)
    )
  )
)
