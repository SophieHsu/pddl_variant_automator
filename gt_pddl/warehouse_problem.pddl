
(define (problem warehouse-instance-1)
  (:domain warehouse-v1-expert)

  (:objects
    robot1 - robot
    scan1 - scanner
    tote1 - tote
    bin1 bin2 - bin
    pallet1 - pallet
    shelfA shelfB - shelf
    a1 a2 - aisle
    loc1 loc2 - location
    itemA itemB - item
  )

  (:init
    (at robot1 loc1)
    (available scan1)

    ;; Items start on shelves and undamaged
    (item-at itemA shelfA)
    (item-at itemB shelfB)
    (undamaged itemA)
    (undamaged itemB)

    ;; Aisle a2 is blocked (needs clearing for a soft goal)
    (blocked a2)

    ;; No facts initially for: scanned, labeled, in-tote, etc.
  )

  ;; Soft goals expressed as preferences
  (:goal (and
    ;; Order picking and labeling
    (preference picked-itemA (in-tote itemA tote1))
    (preference picked-itemB (in-tote itemB tote1))
    (preference labeled-itemA (labeled itemA))
    (preference labeled-itemB (labeled itemB))

    ;; Care & safety
    (preference undamaged-itemA (undamaged itemA))
    (preference undamaged-itemB (undamaged itemB))
    (preference no-blind-pick-pref (no-blind-pick))

    ;; Packaging
    (preference palletized-bin1 (on-pallet bin1 pallet1))
    (preference wrapped-pallet1 (wrapped pallet1))

    ;; Facility state
    (preference aisle-clear-a2 (aisle-clear a2))

    ;; A declared-but-unpenalized preference (attention check)
    (preference scanned-all (and (scanned itemA) (scanned itemB)))
  ))

  ;; Optimize action cost + violations (scanned-all is deliberately not included)
  (:metric
    minimize (+
      (total-cost)
      (is-violated picked-itemA)
      (is-violated picked-itemB)
      (is-violated labeled-itemA)
      (is-violated labeled-itemB)
      (is-violated undamaged-itemA)
      (is-violated undamaged-itemB)
      (is-violated no-blind-pick-pref)
      (is-violated palletized-bin1)
      (is-violated wrapped-pallet1)
      (is-violated aisle-clear-a2)
    )
  )
)
