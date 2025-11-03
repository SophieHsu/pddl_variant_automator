
(define (problem camping-instance-1-fixed)
  (:domain camping-v1-expert-fixed)

  (:objects
    me - person
    car1 - car
    siteA - site
    pm1 - permit
    bag1 - bag
    tent1 - tent
    stove1 - stove
    fuel1 - fuel
    cooler1 - cooler
    food1 - food
    water1 - water
    firstaid1 - firstaid
    flashlight1 - flashlight
    sleepingbag1 - sleepingbag
  )

  (:init
    (at-home)
    ; nothing in bag, cooler, or car
    (not-in-bag tent1 bag1)
    (not-in-bag stove1 bag1)
    (not-in-bag fuel1 bag1)
    (not-in-bag cooler1 bag1)
    (not-in-bag food1 bag1)
    (not-in-bag water1 bag1)
    (not-in-bag firstaid1 bag1)
    (not-in-bag flashlight1 bag1)
    (not-in-bag sleepingbag1 bag1)
    (ice-not-in-cooler cooler1)
    (bag-not-loaded bag1)

    ; priorities for preparation
    (= (priority pm1) 1)
    (= (priority tent1) 2)
    (= (priority water1) 3)
    (= (priority stove1) 4)
    (= (priority fuel1) 5)
    (= (priority sleepingbag1) 6)
    (= (priority firstaid1) 7)
    (= (priority flashlight1) 8)
    (= (priority food1) 9)
    (= (priority cooler1) 10)

    ;; start with the highest priority available
    (= (next_priority) 1)

    ; no permit
    (permits-invalid pm1)

    ; at site
    (unpitched tent1)
    (sleepingbag-not-laid sleepingbag1)
    (stove-not-lit stove1)
    (food-uncooked food1)

    (= (onsite-action-priority) 1)
		(= (total-cost) 0)
  )

  (:goal (and
    (preference packed-tent (in-bag tent1 bag1))
    (preference packed-stove (in-bag stove1 bag1))
    (preference packed-fuel (in-bag fuel1 bag1))
    (preference packed-cooler (in-bag cooler1 bag1))
    (preference packed-food1 (in-bag food1 bag1))
    (preference packed-water (in-bag water1 bag1))
    (preference packed-firstaid (in-bag firstaid1 bag1))
    (preference packed-flashlight (in-bag flashlight1 bag1))
    (preference packed-sleepingbag (in-bag sleepingbag1 bag1))
    (preference no-blind-pack-pref (not (used-blind-pack)))

    ;; Permits and travel
    (preference permits-valid-pref (permits-valid pm1))
    (preference at-siteA (at-site))

    ;; Setup & camp operation
    (preference tent-pitched (pitched tent1))
    (preference bag-laid (sleepingbag-laid sleepingbag1))
    (preference food1-cooked (food-cooked food1)) 
    (preference food1-cold (food-cold food1))
    (preference food1-bear-safe (bear-safe food1))
    (preference fire-out-pref (fire-out))
))

  (:metric
    minimize (+
      (total-cost)
      (is-violated packed-tent)
      (is-violated packed-stove)
      (is-violated packed-fuel)
      (is-violated packed-cooler)
      (is-violated packed-food1)
      (is-violated packed-water)
      (is-violated packed-firstaid)
      (is-violated packed-flashlight)
      (is-violated packed-sleepingbag)
      (is-violated no-blind-pack-pref)
      (is-violated permits-valid-pref)
      (is-violated at-siteA)
      (is-violated tent-pitched)
      (is-violated bag-laid)
      (is-violated food1-cooked)
      (is-violated food1-cold)
      (is-violated food1-bear-safe)
      (is-violated fire-out-pref)
    )
  )
)
