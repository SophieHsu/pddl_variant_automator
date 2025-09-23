
(define (domain laundry-v3-expert)
  (:requirements :strips :typing :negative-preconditions :preferences :action-costs)
  (:types
    machine garment storage fabric_care - object
    washer dryer steamer iron - machine
    basket hanger closet - storage
    additive detergent softener sheet stainremover - fabric_care
  )

  (:predicates
    ;; garment states & placement
    (in-hamper ?g - garment)
    (is-light ?g - garment)
    (is-dark ?g - garment)
    
    (sorted-light ?g - garment)
    (sorted-dark ?g - garment)
    (sorted-delicate ?g - garment)
    (is-delicate ?g - garment)
    (stained ?g - garment)

    (pockets-checked ?g - garment)
    (tissue-in-pocket ?g - garment)
    (no-tissue-in-pocket ?g - garment)
    (coins-in-pocket ?g - garment)
    (no-coins-in-pocket ?g - garment)
    (zippers-open ?g - garment)
    (zippers-closed ?g - garment)
    (inside-out ?g - garment)
    (not-inside-out ?g - garment)

    (washer-loaded ?w - washer)
    (washer-not-loaded ?w - washer)

    (in-washer ?g - garment)
    (washed ?g - garment)
    (in-dryer ?g - garment)
    (dried ?g - garment)

    (ironed ?g - garment)
    (steamed ?g - garment)
    (folded ?g - garment)
    (hung ?g - garment)
    (put-away ?g - garment)

    ;; quality
    (fresh-smell ?g - garment)
    (lint-covered ?g - garment)
    (color-bled ?g - garment)
    (shrunk ?g - garment)
    (undamaged ?g - garment)

    ;; machine care / global flags
    (lint-removed ?d - dryer)
    (eco-washed ?g - garment)
    (used-risky-wash)
  )

  (:functions (total-cost))

  ;; --- Sorting & pre-treatment ---
  (:action sort_light
    :parameters (?g - garment)
    :precondition (and 
      (in-hamper ?g)
      (is-light ?g)
    )
    :effect (and 
      (sorted-light ?g) 
      (increase (total-cost) 0)
    )
  )

  (:action sort_dark
    :parameters (?g - garment)
    :precondition (and 
      (in-hamper ?g)
      (is-dark ?g)
    )
    :effect (and 
      (sorted-dark ?g) 
      ; (increase (total-cost) 1)
    )
  )

  (:action sort_delicate
    :parameters (?g - garment)
    :precondition (and 
      (in-hamper ?g)
      (is-delicate ?g)
    )
    :effect (and 
      (sorted-delicate ?g) 
      ; (increase (total-cost) 2)
    )
  )

  (:action pretreat_stain
    :parameters (?g - garment ?sr - stainremover)
    :precondition (and 
      (in-hamper ?g)
      (stained ?g)
    )
    :effect (and 
      (not (stained ?g)) 
      ; (increase (total-cost) 2)
    )
  )

  ;; --- Pocket & garment prep ---
  (:action check_pockets
    :parameters (?g - garment)
    :precondition (and 
      (in-hamper ?g)
    )
    :effect (and 
      (pockets-checked ?g) 
      ; (increase (total-cost) 1)
    )
  )

  (:action remove_tissue
    :parameters (?g - garment)
    :precondition (and 
      (pockets-checked ?g) 
      (tissue-in-pocket ?g)
    )
    :effect (and 
      (not (tissue-in-pocket ?g)) 
      (no-tissue-in-pocket ?g)
      ; (increase (total-cost) 1)
    )
  )

  (:action remove_coins
    :parameters (?g - garment)
    :precondition (and 
      (pockets-checked ?g) 
      (coins-in-pocket ?g)
    )
    :effect (and 
      (not (coins-in-pocket ?g)) 
      (no-coins-in-pocket ?g)
      ; (increase (total-cost) 1)
    )
  )

  (:action close_zippers
    :parameters (?g - garment)
    :precondition (and 
      (zippers-open ?g)
    )
    :effect (and 
      (not (zippers-open ?g))
      (zippers-closed ?g)
      ; (increase (total-cost) 1)
    )
  )

  (:action turn_inside_out_delicate
    :parameters (?g - garment)
    :precondition (and 
      (is-delicate ?g)
    )
    :effect (and 
      (inside-out ?g) 
      ; (increase (total-cost) 1)
    )
  )

  ;; --- Loading (safe vs blind) ---
  (:action load_washer_safe_light
    :parameters (?g - garment ?w - washer)
    :precondition (and
      (undamaged ?g)
      (sorted-light ?g)
      (pockets-checked ?g)
      (no-tissue-in-pocket ?g)
      (no-coins-in-pocket ?g)
      (zippers-closed ?g)
    )
    :effect (and 
      (in-washer ?g) 
      (not (in-hamper ?g)) 
      ; (increase (total-cost) 1)
    )
  )

  (:action load_washer_safe_dark
    :parameters (?g - garment ?w - washer)
    :precondition (and
      (undamaged ?g)
      (sorted-dark ?g)
      (pockets-checked ?g)
      (no-tissue-in-pocket ?g)
      (no-coins-in-pocket ?g)
      (zippers-closed ?g)
    )
    :effect (and 
      (in-washer ?g) 
      (not (in-hamper ?g)) 
      ; (increase (total-cost) 1)
    )
  )

  (:action load_washer_safe_delicate
    :parameters (?g - garment ?w - washer)
    :precondition (and
      (undamaged ?g)
      (sorted-delicate ?g)
      (pockets-checked ?g)
      (no-tissue-in-pocket ?g)
      (no-coins-in-pocket ?g)
      (zippers-closed ?g)
    )
    :effect (and 
      (in-washer ?g) 
      (not (in-hamper ?g)) 
      ; (increase (total-cost) 1)
    )
  )

  (:action load_washer_blind
    :parameters (?g - garment ?w - washer)
    :precondition (and 
      (in-hamper ?g)
    )
    :effect (and
      (in-washer ?g) 
      (not (in-hamper ?g))
      (color-bled ?g)
      ; (increase (total-cost) 0)
    )
  )

  ; ;; --- Washing (eco vs quick risky) ---
  (:action wash_eco
    :parameters (?g - garment ?w - washer ?d - detergent)
    :precondition (and 
      (in-washer ?g)
    )
    :effect (and
      (washed ?g)
      (eco-washed ?g)
      ; (increase (total-cost) 3))
    )
  )

  (:action wash_quick_risky
    :parameters (?g - garment ?w - washer)
    :precondition (and 
      (in-washer ?g)
    )
    :effect (and
      (washed ?g)
      (color-bled ?g)
      (lint-covered ?g)
      (not (undamaged ?g))
      (used-risky-wash)
      ; (increase (total-cost) 1))
    )
  )

  ;; --- Dryer & drying options ---
  (:action move_to_dryer
    :parameters (?g - garment ?w - washer ?d - dryer)
    :precondition (and 
      (in-washer ?g) 
      (washed ?g)
    )
    :effect (and 
      (in-dryer ?g) 
      (not (in-washer ?g)) 
      ; (increase (total-cost) 1)
    )
  )

  (:action dry_low_safe
    :parameters (?g - garment ?d - dryer)
    :precondition (and 
      (in-dryer ?g)
    )
    :effect (and 
      (dried ?g) 
      ; (no-blind-wash) 
      ; (increase (total-cost) 2)
    )
  )

  (:action dry_high_risky
    :parameters (?g - garment ?d - dryer)
    :precondition (and 
      (in-dryer ?g)
    )
    :effect (and 
      (dried ?g) 
      (shrunk ?g) 
      (used-risky-wash)
      ; (increase (total-cost) 1)
    )
  )

  (:action hang_dry
    :parameters (?g - garment ?h - hanger)
    :precondition (and 
      (washed ?g)
    )
    :effect (and 
      (dried ?g) 
      ; (no-blind-wash) 
      ; (increase (total-cost) 1)
    )
  )

  (:action remove_lint_from_dryer
    :parameters (?d - dryer)
    :precondition (and)
    :effect (and 
      (lint-removed ?d) 
      ; (increase (total-cost) 1)
    )
  )

  (:action delint_garment
    :parameters (?g - garment)
    :precondition (and 
      (dried ?g) 
      (lint-covered ?g)
    )
    :effect (and 
      (not (lint-covered ?g)) 
      ; (increase (total-cost) 1)
    )
  )

  ;; --- Finish & storage ---
  (:action add_softener_after
    :parameters (?g - garment ?s - softener)
    :precondition (and 
      (dried ?g)
    )
    :effect (and 
      (fresh-smell ?g) 
      ; (increase (total-cost) 1)
    )
  )

  (:action iron_garment
    :parameters (?g - garment ?i - iron)
    :precondition (and (dried ?g))
    :effect (and 
      (ironed ?g) 
      ; (increase (total-cost) 1)
    )
  )

  (:action steam_garment
    :parameters (?g - garment ?st - steamer)
    :precondition (and 
      (dried ?g)
    )
    :effect (and 
      (steamed ?g) 
      ; (increase (total-cost) 1)
    )
  )

  (:action fold_garment
    :parameters (?g - garment)
    :precondition (and 
      (dried ?g)
    )
    :effect (and 
      (folded ?g) 
      ; (increase (total-cost) 1)
    )
  )

  (:action hang_garment
    :parameters (?g - garment ?h - hanger)
    :precondition (and 
      (dried ?g)
    )
    :effect (and 
      (hung ?g) 
      ; (increase (total-cost) 1)
    )
  )

  (:action put_away_closet_folded
    :parameters (?g - garment ?c - closet)
    :precondition (and 
      (folded ?g)
    )
    :effect (and 
      (put-away ?g) 
      ; (increase (total-cost) 1)
    )
  )

  (:action put_away_closet_hung
    :parameters (?g - garment ?c - closet)
    :precondition (and 
      (hung ?g)
    )
    :effect (and 
      (put-away ?g) 
      ; (increase (total-cost) 1)
    )
  )
)
