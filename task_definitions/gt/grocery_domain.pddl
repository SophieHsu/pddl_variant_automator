
(define (domain grocery-v1-expert)
  (:requirements :strips :typing :preferences :action-costs)
  (:types
    person cart bag location item - object
    store aisle - location
    dairy produce bread - item
  )

  (:predicates
    (at-store)
    (at-dairy-aisle)
    (at-produce-aisle)
    (at-bakery-aisle)
    (at-cashier)

    (in-cart ?i - item ?c - cart)
    (in-bag ?i - item ?b - bag)

    (purchased ?i - item)
    (not-purchased ?i - item)
    (fresh ?i - item)
    (unbroken ?i - item)
    (coupon-applied ?i - item)

    (not-done-shopping)
    (done-shopping)

    (used-blind-pick)
    (reusable-bag-used ?b - bag)

    (is-dairy-aisle ?a - aisle)
    (is-produce-aisle ?a - aisle)
    (is-bakery-aisle ?a - aisle)
  )

  (:functions (total-cost))

  (:action go_to_store
    :parameters ()
    :precondition (and)
    :effect (and
      (at-store)
      ; (not-done-shopping)
      ; (increase (total-cost) 0)
    )
  )

  (:action go_to_dairy_aisle
    :parameters (?a - aisle)
    :precondition (and 
      (at-store)
      (not-done-shopping)
      (is-dairy-aisle ?a)
    )
    :effect (and 
      (at-dairy-aisle)
      (not (at-produce-aisle))
      (not (at-bakery-aisle))
    )
  )

  (:action go_to_bakery_aisle
    :parameters (?a - aisle)
    :precondition (and 
      (at-store)
      (not-done-shopping)
      (is-bakery-aisle ?a)
    )
    :effect (and 
      (at-bakery-aisle)
      (not (at-produce-aisle))
      (not (at-dairy-aisle))
    )
  )

  (:action go_to_produce_aisle
    :parameters (?a - aisle)
    :precondition (and 
      (at-store)
      (not-done-shopping)
      (is-produce-aisle ?a)
    )
    :effect (and 
      (at-produce-aisle)
      (not (at-dairy-aisle))
      (not (at-bakery-aisle))
    )
  )

  (:action pick_bread_safe
    :parameters (?i - bread ?a - aisle ?c - cart)
    :precondition (and
      (at-store)
      (not-done-shopping)
      (at-bakery-aisle)
      (fresh ?i)
    )
    :effect (and 
      (in-cart ?i ?c)
    )
  )

  (:action pick_produce_safe
    :parameters (?i - produce ?a - aisle ?c - cart)
    :precondition (and
      (at-store)
      (not-done-shopping)
      (at-produce-aisle)
      (fresh ?i)
    )
    :effect (and 
      (in-cart ?i ?c)
    )
  )

  (:action pick_dairy_safe
    :parameters (?i - dairy ?a - aisle ?c - cart)
    :precondition (and
      (at-store)
      (not-done-shopping)
      (at-dairy-aisle)
      (fresh ?i)
    )
    :effect (and 
      (in-cart ?i ?c)
    )
  )

  (:action pick_bread_blind
    :parameters (?i - bread ?a - aisle ?c - cart)
    :precondition (and
      (at-store)
      (not-done-shopping)
      (at-bakery-aisle)
    )
    :effect (and 
      (in-cart ?i ?c)
      (not (fresh ?i))
      (used-blind-pick)
    )
  )

  (:action pick_produce_blind
    :parameters (?i - produce ?a - aisle ?c - cart)
    :precondition (and
      (at-store)
      (not-done-shopping)
      (at-produce-aisle)
    )
    :effect (and 
      (in-cart ?i ?c)
      (not (fresh ?i))
      (used-blind-pick)
    )
  )

  (:action pick_dairy_blind
    :parameters (?i - dairy ?a - aisle ?c - cart)
    :precondition (and
      (at-store)
      (not-done-shopping)
      (at-dairy-aisle)
    )
    :effect (and 
      (in-cart ?i ?c)
      (not (fresh ?i))
      (used-blind-pick)
    )
  )


  ; additional shopping prohibited after this action
  (:action go_to_cashier
    :parameters ()
    :precondition (and
      (at-store)
      (not-done-shopping)
    )
    :effect (and
      (done-shopping)
      (not (not-done-shopping))
      (at-cashier)
    )
  )

  (:action apply_coupon
    :parameters (?i - item)
    :precondition (and
      (at-cashier)
      (not-purchased ?i)
    )
    :effect (and
      (coupon-applied ?i)
      (increase (total-cost) 0)
    )
  )

  (:action scan_item
    :parameters (?i - item ?c - cart)
    :precondition (and
      (at-cashier)
      (not-purchased ?i)
      (in-cart ?i ?c)
    )
    :effect (and
      (purchased ?i)
      (not (not-purchased ?i))
      ; (increase (total-cost) 2)
    )
  )

  (:action bag_safe
    :parameters (?i - item ?b - bag ?c - cart)
    :precondition (and 
      (at-store)
      (done-shopping)
      (in-cart ?i ?c)
      (purchased ?i)
    )
    :effect (and
      (in-bag ?i ?b)
      ; (increase (total-cost) 1)
    )
  )

  (:action bag_toss_risky
    :parameters (?i - item ?b - bag ?c - cart)
    :precondition (and 
      (at-store)
      (done-shopping)
      (in-cart ?i ?c)
      (purchased ?i)
    )
    :effect (and
      (in-bag ?i ?b)
      (not (unbroken ?i))
      ; (increase (total-cost) 0)
    )
  )

  (:action use_reusable_bag
    :parameters (?b - bag)
    :precondition (and
      (at-cashier)
      (done-shopping)
    )
    :effect (and
      (reusable-bag-used ?b)
      ; (increase (total-cost) 0)
    )
  )
)
