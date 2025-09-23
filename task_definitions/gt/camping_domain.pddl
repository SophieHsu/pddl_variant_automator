
(define (domain camping-v1-expert-fixed)
  (:requirements :strips :typing :preferences :action-costs)
  (:types
    person car site permit bag gear - object
    tent stove fuel cooler food water firstaid flashlight sleepingbag - gear
  )

  (:predicates
    (at-home)
    (bag-loaded ?b - bag)
    (bag-not-loaded ?b - bag)
    (in-bag ?g - gear ?b - bag)
    (not-in-bag ?g - gear ?b - bag)
    (at-site)
    (ice-in-cooler ?c - cooler)
    (ice-not-in-cooler ?c - cooler)

    (pitched ?t - tent)
    (unpitched ?t - tent)
    (stove-lit ?s - stove)
    (stove-not-lit ?s - stove)
    (food-cold ?f - food)
    (food-cooked ?f - food)
    (food-uncooked ?f - food)
    (sleepingbag-laid ?sb - sleepingbag)
    (sleepingbag-not-laid ?sb - sleepingbag)

    (permits-valid ?pm - permit)
    (permits-invalid ?pm - permit)
    (bear-safe ?f - food)
    (fire-out)
    (used-blind-pack)
  )

  (:functions (total-cost))

  ;; --- Prep and packing ---
  (:action pack_unsafe
    :parameters (?g - gear ?b - bag)
    :precondition (and
      (at-home)
      (not-in-bag ?g ?b)
      (bag-not-loaded ?b)
    )
    :effect (and
      (in-bag ?g ?b)
      (not (not-in-bag ?g ?b))
      (used-blind-pack)
    )
  )

  (:action pack_safe
    :parameters (?g - gear ?b - bag)
    :precondition (and
      (at-home)
      (not-in-bag ?g ?b)
      (bag-not-loaded ?b)
    )
    :effect (and
      (in-bag ?g ?b)
      (not (not-in-bag ?g ?b))
    )
  )

  (:action load_bag_to_car
    :parameters (?b - bag)
    :precondition (and
      (at-home)
      (bag-not-loaded ?b)
    )
    :effect (and 
      (bag-loaded ?b) 
      (not (bag-not-loaded ?b))
    )
  )

  (:action add_ice_to_cooler
    :parameters (?cl - cooler)
    :precondition (and
      (at-home)
      (ice-not-in-cooler ?cl)
    )
    :effect (and
      (ice-in-cooler ?cl)
      (not (ice-not-in-cooler ?cl))
    )
  )

  (:action keep_food_cold
    :parameters (?f - food ?cl - cooler)
    :precondition (and
      (at-home)
      (ice-in-cooler ?cl)
    )
    :effect (and
      (food-cold ?f)
    )
  )

  (:action buy_permit
    :parameters (?pm - permit)
    :precondition (permits-invalid ?pm)
    :effect (and
      (permits-valid ?pm)
      (not (permits-invalid ?pm))
    )
  )

  (:action drive_to_site
    :parameters (?c - car ?s - site)
    :precondition (and
      (at-home)
    )
    :effect (and
      (at-site)
      (not (at-home))
    )
  )

  ;; --- Setup at site ---
  (:action pitch_tent
    :parameters (?t - tent ?b - bag)
    :precondition (and
      (at-site)
      (in-bag ?t ?b)
      (bag-loaded ?b)
      (unpitched ?t)
    )
    :effect (and
      (pitched ?t)
      (not (unpitched ?t))
    )
  )

  (:action lay_sleepingbag
    :parameters (?b - bag ?sb - sleepingbag ?t - tent)
    :precondition (and 
      (pitched ?t)
      (in-bag ?sb ?b)
      (bag-loaded ?b)
      (sleepingbag-not-laid ?sb)
    )
    :effect (and
      (sleepingbag-laid ?sb)
      (not (sleepingbag-not-laid ?sb))
    )
  )

  (:action light_stove
    :parameters (?st - stove ?b - bag ?fu - fuel)
    :precondition (and
      (at-site)
      (in-bag ?st ?b)
      (bag-loaded ?b)
      (stove-not-lit ?st)
    )
    :effect (and
      (stove-lit ?st)
      (not (stove-not-lit ?st))
    )
  )

  (:action cook_meal
    :parameters (?b - bag ?f - food ?st - stove)
    :precondition (and
      (stove-lit ?st)
      (in-bag ?f ?b)
      (bag-loaded ?b)
      (food-uncooked ?f)
    )
    :effect (and
      (food-cooked ?f)
      (not (food-uncooked ?f))
    )
  )

  (:action store_food_bear_safe
    :parameters (?b - bag ?f - food)
    :precondition (and
      (at-site)
      (in-bag ?f ?b)
      (bag-loaded ?b)
    )
    :effect (and
      (bear-safe ?f)
    )
  )

  (:action extinguish_fire
    :parameters (?st - stove)
    :precondition (and 
      (stove-lit ?st)
    )
    :effect (and
      (not (stove-lit ?st))
      (stove-not-lit ?st)
      (fire-out)
    )
  )
)
