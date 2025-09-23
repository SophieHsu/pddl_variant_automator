
(define (domain warehouse-v1-expert)
  (:requirements :strips :typing :preferences :action-costs)
  (:types
    robot aisle shelf scanner gripper bin tote pallet item - object
  )

  (:predicates
    (robot-at ?r - robot ?a - aisle)
    (available ?s - scanner)
    (shelf-at ?s - shelf ?a - aisle)

    (item-at ?i - item ?s - shelf)
    (in-bin ?i - item ?b - bin)
    (in-tote ?i - item ?t - tote)
    (on-pallet ?b - bin ?p - pallet)
    (not-on-pallet ?b - bin)
    (item-on-pallet ?i - item)

    (labeled ?i - item)
    (scanned ?i - item)
    (undamaged ?i - item)

    (pallet-done ?p - pallet)
    (pallet-not-done ?p - pallet)
    (wrapped ?p - pallet)

    (aisle-clear ?a - aisle)
    (blocked ?a - aisle)

    ;; Preference helper fact: becomes true only if no blind pick was used.
    (used-blind-pick)
  )

  (:functions (total-cost))

  ;; --- Actions ---

  (:action move
    :parameters (?r - robot ?from - aisle ?to - aisle)
    :precondition (and 
      (robot-at ?r ?from)
    )
    :effect (and
      (robot-at ?r ?to)
      (not (robot-at ?r ?from))
      (increase (total-cost) 0)
    )
  )

  (:action scan_item_safe
    :parameters (?r - robot ?i - item ?sc - scanner ?sh - shelf ?a - aisle)
    :precondition (and 
      (available ?sc)
      (item-at ?i ?sh)
      (shelf-at ?sh ?a)
      (robot-at ?r ?a)
    )
    :effect (and
      (scanned ?i)
      ; (increase (total-cost) 5)
    )
  )

  (:action print_and_attach_label
    :parameters (?i - item ?sc - scanner)
    :precondition (and 
      (scanned ?i) 
      (available ?sc)
    )
    :effect (and
      (labeled ?i)
      ; (increase (total-cost) 6)
    )
  )

  (:action pick_with_scan
    :parameters (?r - robot ?i - item ?s - shelf ?t - tote ?a - aisle)
    :precondition (and 
      (item-at ?i ?s)
      (shelf-at ?s ?a)
      (robot-at ?r ?a)
      (scanned ?i) 
      (undamaged ?i)
    )
    :effect (and
      (in-tote ?i ?t)
      (not (item-at ?i ?s))
      ;; bonus: certify that no blind pick occurred
      ; (no-blind-pick) 
      ; (increase (total-cost) 8)
    )
  )

  (:action pick_blind
    :parameters (?r - robot ?i - item ?s - shelf ?t - tote ?a - aisle)
    :precondition (and 
      (item-at ?i ?s)
      (shelf-at ?s ?a)
      (robot-at ?r ?a)
    )
    :effect (and
      (in-tote ?i ?t)
      (not (item-at ?i ?s))
      ;; risk: item may get damaged in blind picks (we model as guaranteed damage)
      (not (undamaged ?i))
      (used-blind-pick)
      ; (increase (total-cost) 4)
    )
  )

  (:action load_bin_from_tote
    :parameters (?i - item ?t - tote ?b - bin)
    :precondition (and 
      (in-tote ?i ?t)
      (not-on-pallet ?b)
    )
    :effect (and
      (in-bin ?i ?b)
      (not (in-tote ?i ?t))
      ; (increase (total-cost) 3)
    )
  )

  (:action palletize_bin
    :parameters (?b - bin ?p - pallet)
    :precondition (and 
      (pallet-not-done ?p)
    )
    :effect (and
      (on-pallet ?b ?p)
      (not (not-on-pallet ?b))
      ; (increase (total-cost) 5)
    )
  )

  (:action finish_loading_pallet
    :parameters (?p - pallet)
    :precondition (and 
      (pallet-not-done ?p)
    )
    :effect (and 
      (pallet-done ?p)
      (not (pallet-not-done ?p))
    )
  )

  (:action wrap_pallet
    :parameters (?p - pallet)
    :precondition (and
      (pallet-done ?p)
    )
    :effect (and
      ; (increase (total-cost) 7)
      (wrapped ?p)
    )
  )

  (:action clear_aisle
    :parameters (?r - robot ?a - aisle)
    :precondition (and 
      (robot-at ?r ?a)
      (blocked ?a)
    )
    :effect (and
      (aisle-clear ?a)
      (not (blocked ?a))
      ; (increase (total-cost) 4)
    )
  )

  (:action check_item_in_pallet
    :parameters (?i - item ?b - bin ?p - pallet)
    :precondition (and 
      (in-bin ?i ?b)
      (on-pallet ?b ?p)
    )
    :effect (and 
      (item-on-pallet ?i)
    )
  )
)
