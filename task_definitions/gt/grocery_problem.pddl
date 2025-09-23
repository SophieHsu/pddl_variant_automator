
(define (problem grocery-instance-1)
  (:domain grocery-v1-expert)

  (:objects
    mart - store
    dairy_aisle produce_aisle bakery_aisle - aisle
    cart1 - cart
    bag1 - bag
    milk - dairy
    eggs - produce
    bread - bread
  )

  (:init
    (fresh milk)
    (fresh bread)
    (fresh eggs)

    ; (fragile eggs)
    (not-purchased milk)
    (not-purchased eggs)
    (not-purchased bread)

    (unbroken milk)
    (unbroken eggs)
    (unbroken bread)

    (not-done-shopping)

    (is-bakery-aisle bakery_aisle)
    (is-produce-aisle produce_aisle)
    (is-dairy-aisle dairy_aisle)
		(= (total-cost) 0)
  )

  (:goal (and
    (preference milk-bought (purchased milk))
    (preference bread-bought (purchased bread))
    (preference eggs-bought (purchased eggs))

    (preference milk-bagged (in-bag milk bag1))
    (preference bread-bagged (in-bag bread bag1))
    (preference eggs-bagged (in-bag eggs bag1))

    (preference items-fresh (and (fresh milk) (fresh bread) (fresh eggs)))
    (preference coupon-milk (coupon-applied milk))
    (preference reusable-bag (reusable-bag-used bag1))
    (preference no-blind-pick-pref (not (used-blind-pick)))

    ;; Declared but not penalized
    ; (preference took-receipt (and ))
  ))

  (:metric
    minimize (+
      (total-cost)
      (is-violated milk-bought)
      (is-violated bread-bought)
      (is-violated eggs-bought)
      (is-violated milk-bagged)
      (is-violated bread-bagged)
      (is-violated eggs-bagged)
      (is-violated items-fresh)
      (is-violated coupon-milk)
      (is-violated reusable-bag)
      (is-violated no-blind-pick-pref)
    )
  )
)
