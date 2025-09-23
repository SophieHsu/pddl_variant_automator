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
    itemA itemB - item
  )

  (:init
    (available scan1)
    (robot-at robot1 a1)

    (shelf-at shelfA a1)
    (shelf-at shelfB a2)

    ;; Items start on shelves and undamaged
    (item-at itemA shelfA)
    (item-at itemB shelfB)
    (undamaged itemA)
    (undamaged itemB)

    (not-on-pallet bin1)
    (not-on-pallet bin2)
    (pallet-not-done pallet1)

    ;; Aisle a2 is blocked (needs clearing for a soft goal)
    (blocked a2)

		(= (total-cost) 0)
  
    ;; No facts initially for: scanned, labeled, in-tote, etc.
  )

  ;; Soft goals expressed as preferences
  (:goal (and
    ;; Order picking and labeling
    ; (preference picked-itemA (in-tote itemA tote1))
    ; (preference picked-itemB (in-tote itemB tote1))
    (preference labeled-itemA (labeled itemA))
    (preference labeled-itemB (labeled itemB))

    ;; Care & safety
    (preference undamaged-itemA (undamaged itemA))
    (preference undamaged-itemB (undamaged itemB))
    (preference no-blind-pick-pref (not (used-blind-pick)))

    ;; Packaging
    (preference palletized-bin1 (on-pallet bin1 pallet1))
    (preference wrapped-pallet1 (wrapped pallet1))
    (preference on-pallet-itemA (item-on-pallet itemA))
    (preference on-pallet-itemB (item-on-pallet itemB))

    ;; Facility state
    (preference aisle-clear-a2 (aisle-clear a2))

    ;; A declared-but-unpenalized preference (attention check)
    (preference scanned-itemA (scanned itemA))
    (preference scanned-itemB (scanned itemB))
  ))

  ;; Optimize action cost + violations (scanned-all is deliberately not included)
  (:metric
    minimize (+
      (total-cost)
      ; (is-violated picked-itemA)
      ; (is-violated picked-itemB)
      (is-violated labeled-itemA)
      (is-violated labeled-itemB)
      (is-violated scanned-itemA)
      (is-violated scanned-itemB)
      (is-violated undamaged-itemA)
      (is-violated undamaged-itemB)
      (is-violated no-blind-pick-pref)
      (is-violated palletized-bin1)
      (is-violated on-pallet-itemA)
      (is-violated on-pallet-itemB)
      (is-violated wrapped-pallet1)
      (is-violated aisle-clear-a2)
    )
  )
)
