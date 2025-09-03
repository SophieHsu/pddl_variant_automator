
(define (problem camping-instance-1-fixed)
  (:domain camping-v1-expert-fixed)

  (:objects
    me - person
    car1 - car
    siteA - site
    pm1 - permit
    bag1 bag2 - bag
    tent1 - tent
    stove1 - stove
    fuel1 - fuel
    cooler1 - cooler
    food1 food2 - food
    water1 - water
    firstaid1 - firstaid
    flashlight1 - flashlight
    sleepingbag1 - sleepingbag
  )

  (:init
    (at-home me)
  )

  (:goal (and
    ;; Packed essentials
    (preference packed-tent (in-car tent1 car1))
    (preference packed-stove (in-car stove1 car1))
    (preference packed-fuel (in-car fuel1 car1))
    (preference packed-cooler (in-car cooler1 car1))
    (preference packed-food1 (in-car food1 car1))
    (preference packed-food2 (in-car food2 car1))
    (preference packed-water (in-car water1 car1))
    (preference packed-firstaid (in-car firstaid1 car1))
    (preference packed-flashlight (in-car flashlight1 car1))
    (preference packed-sleepingbag (in-car sleepingbag1 car1))
    (preference no-blind-pack-pref (no-blind-pack))

    ;; Permits and travel
    (preference permits-valid-pref (permits-valid pm1))
    (preference at-siteA (at-site me siteA))

    ;; Setup & camp operation
    (preference tent-pitched (pitched tent1))
    (preference bag-laid (sleepingbag-laid sleepingbag1))
    (preference meal-cooked (and (food-cooked food1) (food-cooked food2)))
    (preference food-cold-pref (and (food-cold food1) (food-cold food2)))
    (preference bear-safe-pref (bear-safe))
    (preference fire-out-pref (fire-out))

    ;; Attention check (declared but not in metric)
    (preference all-photos (and ))
  ))

  (:metric
    minimize (+
      (total-cost)
      (is-violated packed-tent)
      (is-violated packed-stove)
      (is-violated packed-fuel)
      (is-violated packed-cooler)
      (is-violated packed-food1)
      (is-violated packed-food2)
      (is-violated packed-water)
      (is-violated packed-firstaid)
      (is-violated packed-flashlight)
      (is-violated packed-sleepingbag)
      (is-violated no-blind-pack-pref)
      (is-violated permits-valid-pref)
      (is-violated at-siteA)
      (is-violated tent-pitched)
      (is-violated bag-laid)
      (is-violated meal-cooked)
      (is-violated food-cold-pref)
      (is-violated bear-safe-pref)
      (is-violated fire-out-pref)
    )
  )
)
