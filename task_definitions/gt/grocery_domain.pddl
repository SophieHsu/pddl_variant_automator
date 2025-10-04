
(define (domain grocery-v1-expert)
  (:requirements :strips :typing :preferences :action-costs)
  (:types
    person cart location item - object
    store aisle - location
    dairy produce bread - item
  )

  (:predicates
    (at-home)
    (at-store)
    (at-dairy-aisle)
    (at-produce-aisle)
    (at-bakery-aisle)
    (at-cashier)

    (in-cart ?i - item ?c - cart)
    (in-bag ?i - item)

    (purchased ?i - item)
    (not-purchased ?i - item)
    (fresh ?i - item)
    (unbroken ?i - item)
    (coupon-applied ?i - item)

    (not-done-shopping)
    (done-shopping)

    (used-blind-pick)
    (reusable-bag-used)
    (has-reusable-bag)

    (is-dairy-aisle ?a - aisle)
    (is-produce-aisle ?a - aisle)
    (is-bakery-aisle ?a - aisle)
  )

  (:functions 
    (total-cost)
    (item-pickup-priority ?i - item)
    (item-bagging-priority ?i - item)
    (current-pickup-priority)
    (current-bagging-priority)
)

  (:action bring_reusable_bag
    :parameters ()
    :precondition (and 
      (at-home)
    )
    :effect (and 
      (has-reusable-bag) 
    )
  )

  (:action go_to_store
    :parameters ()
    :precondition (and
      (at-home)
    )
    :effect (and
      (at-store)
      (not (at-home))
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
      (= (current-pickup-priority) (item-pickup-priority ?i))
    )
    :effect (and 
      (in-cart ?i ?c)
      (assign (current-pickup-priority) (+ (current-pickup-priority) 1))
    )
  )

  (:action pick_produce_safe
    :parameters (?i - produce ?a - aisle ?c - cart)
    :precondition (and
      (at-store)
      (not-done-shopping)
      (at-produce-aisle)
      (fresh ?i)
      (= (current-pickup-priority) (item-pickup-priority ?i))
    )
    :effect (and 
      (in-cart ?i ?c)
      (assign (current-pickup-priority) (+ (current-pickup-priority) 1))
    )
  )

  (:action pick_dairy_safe
    :parameters (?i - dairy ?a - aisle ?c - cart)
    :precondition (and
      (at-store)
      (not-done-shopping)
      (at-dairy-aisle)
      (fresh ?i)
      (= (current-pickup-priority) (item-pickup-priority ?i))
    )
    :effect (and 
      (in-cart ?i ?c)
      (assign (current-pickup-priority) (+ (current-pickup-priority) 1))
    )
  )

  (:action pick_bread_blind
    :parameters (?i - bread ?a - aisle ?c - cart)
    :precondition (and
      (at-store)
      (not-done-shopping)
      (at-bakery-aisle)
      (= (current-pickup-priority) (item-pickup-priority ?i))
    )
    :effect (and 
      (in-cart ?i ?c)
      (not (fresh ?i))
      (used-blind-pick)
      (assign (current-pickup-priority) (+ (current-pickup-priority) 1))
    )
  )

  (:action pick_produce_blind
    :parameters (?i - produce ?a - aisle ?c - cart)
    :precondition (and
      (at-store)
      (not-done-shopping)
      (at-produce-aisle)
      (= (current-pickup-priority) (item-pickup-priority ?i))
    )
    :effect (and 
      (in-cart ?i ?c)
      (not (fresh ?i))
      (used-blind-pick)
      (assign (current-pickup-priority) (+ (current-pickup-priority) 1))
    )
  )

  (:action pick_dairy_blind
    :parameters (?i - dairy ?a - aisle ?c - cart)
    :precondition (and
      (at-store)
      (not-done-shopping)
      (at-dairy-aisle)
      (= (current-pickup-priority) (item-pickup-priority ?i))
    )
    :effect (and 
      (in-cart ?i ?c)
      (not (fresh ?i))
      (used-blind-pick)
      (assign (current-pickup-priority) (+ (current-pickup-priority) 1))
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
      (purchased ?i)
      (= (current-bagging-priority) (item-bagging-priority ?i))
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
      (= (current-bagging-priority) (item-bagging-priority ?i))
    )
    :effect (and
      (purchased ?i)
      (not (not-purchased ?i))
      ; (increase (total-cost) 2)
    )
  )

  (:action bag_safe_reusable
    :parameters (?i - item ?c - cart)
    :precondition (and 
      (at-store)
      (done-shopping)
      (in-cart ?i ?c)
      (purchased ?i)
      (has-reusable-bag)
      (= (current-bagging-priority) (item-bagging-priority ?i))
    )
    :effect (and
      (in-bag ?i)
      (reusable-bag-used)
      (assign (current-bagging-priority) (+ (current-bagging-priority) 1))
    )
  )

  (:action bag_toss_risky_reusable
    :parameters (?i - item ?c - cart)
    :precondition (and 
      (at-store)
      (done-shopping)
      (in-cart ?i ?c)
      (purchased ?i)
      (has-reusable-bag)
      (= (current-bagging-priority) (item-bagging-priority ?i))
    )
    :effect (and
      (in-bag ?i)
      (not (unbroken ?i))
      (reusable-bag-used)
      (assign (current-bagging-priority) (+ (current-bagging-priority) 1))
    )
  )

  (:action bag_safe_single_use
    :parameters (?i - item ?c - cart)
    :precondition (and 
      (at-store)
      (done-shopping)
      (in-cart ?i ?c)
      (purchased ?i)
      (= (current-bagging-priority) (item-bagging-priority ?i))
    )
    :effect (and
      (in-bag ?i)
      (assign (current-bagging-priority) (+ (current-bagging-priority) 1))
    )
  )

  (:action bag_toss_risky_single_use
    :parameters (?i - item ?c - cart)
    :precondition (and 
      (at-store)
      (done-shopping)
      (in-cart ?i ?c)
      (purchased ?i)
      (= (current-bagging-priority) (item-bagging-priority ?i))
    )
    :effect (and
      (in-bag ?i)
      (not (unbroken ?i))
      (assign (current-bagging-priority) (+ (current-bagging-priority) 1))
    )
  )
)
