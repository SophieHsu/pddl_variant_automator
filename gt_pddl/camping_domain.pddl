
(define (domain camping-v1-expert-fixed)
  (:requirements :strips :typing :preferences :action-costs)
  (:types
    object
    person car site permit bag
    gear
    tent stove fuel cooler food water firstaid flashlight sleepingbag - gear
  )

  (:predicates
    (at-home ?p - person)
    (loaded ?g - gear ?c - car)
    (in-bag ?g - gear ?b - bag)
    (in-car ?g - gear ?c - car)
    (at-site ?p - person ?s - site)

    (pitched ?t - tent)
    (stove-lit ?s - stove)
    (food-cold ?f - food)
    (food-cooked ?f - food)
    (water-packed ?w - water)
    (firstaid-packed ?fa - firstaid)
    (flashlight-packed ?fl - flashlight)
    (sleepingbag-laid ?sb - sleepingbag)

    (permits-valid ?pm - permit)
    (bear-safe)
    (fire-out)
    (no-blind-pack)
  )

  (:functions (total-cost))

  ;; --- Prep and packing ---
  (:action pack_safe
    :parameters (?g - gear ?b - bag)
    :precondition (and)
    :effect (and
      (in-bag ?g ?b)
      (no-blind-pack)
      (increase (total-cost) 1)
    )
  )

  (:action pack_blind
    :parameters (?g - gear ?b - bag)
    :precondition (and)
    :effect (and
      (in-bag ?g ?b)
      (increase (total-cost) 0)
    )
  )

  (:action load_car
    :parameters (?g - gear ?b - bag ?c - car)
    :precondition (and (in-bag ?g ?b))
    :effect (and
      (in-car ?g ?c)
      (increase (total-cost) 1)
    )
  )

  (:action add_ice_to_cooler
    :parameters (?cl - cooler)
    :precondition (and)
    :effect (and
      (increase (total-cost) 1)
    )
  )

  (:action buy_permit
    :parameters (?pm - permit)
    :precondition (and)
    :effect (and
      (permits-valid ?pm)
      (increase (total-cost) 2)
    )
  )

  (:action drive_to_site
    :parameters (?p - person ?c - car ?s - site)
    :precondition (and)
    :effect (and
      (at-site ?p ?s)
      (increase (total-cost) 5)
    )
  )

  ;; --- Setup at site ---
  (:action pitch_tent
    :parameters (?t - tent)
    :precondition (and)
    :effect (and
      (pitched ?t)
      (increase (total-cost) 3)
    )
  )

  (:action lay_sleepingbag
    :parameters (?sb - sleepingbag ?t - tent)
    :precondition (and (pitched ?t))
    :effect (and
      (sleepingbag-laid ?sb)
      (increase (total-cost) 1)
    )
  )

  (:action light_stove
    :parameters (?st - stove ?fu - fuel)
    :precondition (and)
    :effect (and
      (stove-lit ?st)
      (increase (total-cost) 1)
    )
  )

  (:action cook_meal
    :parameters (?f - food ?st - stove)
    :precondition (and (stove-lit ?st))
    :effect (and
      (food-cooked ?f)
      (increase (total-cost) 2)
    )
  )

  (:action keep_food_cold
    :parameters (?f - food ?cl - cooler)
    :precondition (and)
    :effect (and
      (food-cold ?f)
      (increase (total-cost) 1)
    )
  )

  (:action store_food_bear_safe
    :parameters (?f - food)
    :precondition (and)
    :effect (and
      (bear-safe)
      (increase (total-cost) 1)
    )
  )

  (:action extinguish_fire
    :parameters (?st - stove)
    :precondition (and (stove-lit ?st))
    :effect (and
      (fire-out)
      (increase (total-cost) 1)
    )
  )
)
