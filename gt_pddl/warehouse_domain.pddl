
(define (domain warehouse-v1-expert)
  (:requirements :strips :typing :preferences :action-costs)
  (:types
    object
    location
    robot
    scanner
    gripper
    aisle
    shelf
    bin
    tote
    pallet
    item
  )

  (:predicates
    (at ?r - robot ?l - location)
    (near ?r - robot ?s - shelf)
    (available ?s - scanner)

    (item-at ?i - item ?s - shelf)
    (in-bin ?i - item ?b - bin)
    (in-tote ?i - item ?t - tote)
    (on-pallet ?b - bin ?p - pallet)

    (labeled ?i - item)
    (scanned ?i - item)
    (undamaged ?i - item)

    (aisle-clear ?a - aisle)
    (blocked ?a - aisle)

    ;; Preference helper fact: becomes true only if no blind pick was used.
    (no-blind-pick)
  )

  (:functions (total-cost))

  ;; --- Actions ---

  (:action move
    :parameters (?r - robot ?from - location ?to - location)
    :precondition (and (at ?r ?from))
    :effect (and
      (at ?r ?to)
      (not (at ?r ?from))
      (increase (total-cost) 2)
    )
  )

  (:action scan_item_safe
    :parameters (?i - item ?sc - scanner)
    :precondition (and (available ?sc))
    :effect (and
      (scanned ?i)
      (increase (total-cost) 5)
    )
  )

  (:action print_and_attach_label
    :parameters (?i - item ?sc - scanner)
    :precondition (and (scanned ?i) (available ?sc))
    :effect (and
      (labeled ?i)
      (increase (total-cost) 6)
    )
  )

  (:action pick_with_scan
    :parameters (?i - item ?s - shelf ?t - tote)
    :precondition (and (item-at ?i ?s) (scanned ?i) (undamaged ?i))
    :effect (and
      (in-tote ?i ?t)
      (not (item-at ?i ?s))
      ;; bonus: certify that no blind pick occurred
      (no-blind-pick)
      (increase (total-cost) 8)
    )
  )

  (:action pick_blind
    :parameters (?i - item ?s - shelf ?t - tote)
    :precondition (and (item-at ?i ?s))
    :effect (and
      (in-tote ?i ?t)
      (not (item-at ?i ?s))
      ;; risk: item may get damaged in blind picks (we model as guaranteed damage)
      (not (undamaged ?i))
      (increase (total-cost) 4)
    )
  )

  (:action load_bin_from_tote
    :parameters (?i - item ?t - tote ?b - bin)
    :precondition (and (in-tote ?i ?t))
    :effect (and
      (in-bin ?i ?b)
      (not (in-tote ?i ?t))
      (increase (total-cost) 3)
    )
  )

  (:action palletize_bin
    :parameters (?b - bin ?p - pallet)
    :precondition (and )
    :effect (and
      (on-pallet ?b ?p)
      (increase (total-cost) 5)
    )
  )

  (:action wrap_pallet
    :parameters (?p - pallet)
    :precondition (and )
    :effect (and
      (increase (total-cost) 7)
      (wrapped ?p)
    )
  )

  (:action clear_aisle
    :parameters (?a - aisle)
    :precondition (and (blocked ?a))
    :effect (and
      (aisle-clear ?a)
      (not (blocked ?a))
      (increase (total-cost) 4)
    )
  )
)
