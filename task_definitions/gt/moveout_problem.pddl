
(define (problem moveout-instance-1-fixed)
  (:domain moveout-v1-expert-fixed)

  (:objects
    bedroom kitchen living - room
    tv plates books - item
    box1 box2 box3 - box
    tape1 - tape
    label1 label2 label3 - label
    cart1 - cart
    truck1 - truck
    sponge - cleaner
    bag1 bag2 - trashbag
    key1 - key
  )

  (:init

    (at-room living)
    (in-room tv living)
    (in-room plates kitchen)
    (in-room books bedroom)

    (unsealed box1)
    (unsealed box2)
    (unsealed box3)
    (unoccupied box1)
    (unoccupied box2)
    (unoccupied box3)

    (undamaged tv)
    (undamaged plates)
    (undamaged books)

    (floor-undamaged bedroom)
    (floor-undamaged kitchen)
    (floor-undamaged living)

    (room-unfinished bedroom)
    (room-unfinished kitchen)
    (room-unfinished living)

    (room-uninspected bedroom)
    (room-uninspected kitchen)
    (room-uninspected living)

    (keys-in-hand)
    (room-unlocked)
    
		(= (total-cost) 0)
  )

  (:goal (and
    ;; Logistics: each item boxed (rewrite exists to disjunction for OPTIC compatibility)
    ; (preference tv-boxed (or (in-box tv box1) (in-box tv box2) (in-box tv box3)))
    ; (preference plates-boxed (or (in-box plates box1) (in-box plates box2) (in-box plates box3)))
    ; (preference books-boxed (or (in-box books box1) (in-box books box2) (in-box books box3)))
    (preference tv-boxed (in-box tv box1))
    (preference plates-boxed (in-box plates box2))
    (preference books-boxed (in-box books box3))



    ;; And corresponding "in truck" states
    ; (preference tv-in-truck (or (and (in-box tv box1) (in-truck box1))
    ;                             (and (in-box tv box2) (in-truck box2))
    ;                             (and (in-box tv box3) (in-truck box3))))
    ; (preference plates-in-truck (or (and (in-box plates box1) (in-truck box1))
    ;                                 (and (in-box plates box2) (in-truck box2))
    ;                                 (and (in-box plates box3) (in-truck box3))))
    ; (preference books-in-truck (or (and (in-box books box1) (in-truck box1))
    ;                                (and (in-box books box2) (in-truck box2))
    ;                                (and (in-box books box3) (in-truck box3))))
    ; (preference tv-in-truck (and (in-box tv box1) (in-truck box1)))
    ; (preference plates-in-truck (and (in-box plates box1) (in-truck box2)))
    ; (preference books-in-truck (and (in-box books box1) (in-truck box3)))
    (preference in-truck-box1 (in-truck box1))
    (preference in-truck-box2 (in-truck box2))
    (preference in-truck-box3 (in-truck box3))


    ;; Process quality
    ; (preference all-labeled (and (labeled box1) (labeled box2) (labeled box3)))
    ; (preference all-sealed (and (sealed box1) (sealed box2) (sealed box3)))
    (preference no-blind-pack-pref (not (used-blind-pack)))

    (preference labeled1 (labeled box1))
    (preference labeled2 (labeled box2))
    (preference labeled3 (labeled box3))
    (preference sealed1 (sealed box1))
    (preference sealed2 (sealed box2))
    (preference sealed3 (sealed box3))


    ;; Cleaning and handover

    (preference bedroom-floor-clean (floor-clean bedroom))
    (preference kitchen-floor-clean (floor-clean kitchen))
    (preference living-floor-clean (floor-clean living))
    (preference bedroom-floor-undamaged (floor-undamaged bedroom))
    (preference kitchen-floor-undamaged (floor-undamaged kitchen))
    (preference living-floor-undamaged (floor-undamaged living))
    (preference bedroom-trash-removed (trash-removed bedroom))
    (preference kitchen-trash-removed (trash-removed kitchen))
    (preference living-trash-removed (trash-removed living))
    
    (preference bedroom-inspected (room-inspected bedroom))
    (preference kitchen-inspected (room-inspected kitchen))
    (preference living-inspected (room-inspected living))

    (preference room-locked (room-locked))
    (preference keys-back (keys-returned))

    ;; Attention check: declared but not penalized in metric
    ; (preference empty-closets (and ))
  ))

  (:metric
    minimize (+
      (total-cost)
      (is-violated tv-boxed)
      (is-violated plates-boxed)
      (is-violated books-boxed)
      (is-violated in-truck-box1)
      (is-violated in-truck-box2)
      (is-violated in-truck-box3)
      (is-violated labeled1)
      (is-violated labeled2)
      (is-violated labeled3)
      (is-violated sealed1)
      (is-violated sealed2)
      (is-violated sealed3)


      (is-violated no-blind-pack-pref)

      (is-violated bedroom-floor-clean)
      (is-violated kitchen-floor-clean)
      (is-violated living-floor-clean)
      (is-violated bedroom-floor-undamaged)
      (is-violated kitchen-floor-undamaged)
      (is-violated living-floor-undamaged)
      (is-violated bedroom-trash-removed)
      (is-violated kitchen-trash-removed)
      (is-violated living-trash-removed)

      (is-violated bedroom-inspected)
      (is-violated kitchen-inspected)
      (is-violated living-inspected)
      (is-violated room-locked)
      (is-violated keys-back)
    )
  )
)
