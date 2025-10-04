(define (problem moveout-instance-updated)
  (:domain moveout-v1-expert-fixed)

  (:objects
    ;; rooms
    bedroom kitchen living - room
    ;; items
    tv plates books - item
    ;; packaging / tools
    box1 box2 box3 - box
    tape1 - tape
    label1 label2 label3 - label
    cart1 - cart
    truck1 - truck
    sponge - cleaner
    key1 - key
  )

  (:init
    ;; agent location (use only the predicate your domain declares)
    (current-room living)

    ;; room state
    (room-unlocked bedroom)
    (room-unlocked kitchen)
    (room-unlocked living)

    (room-unfinished bedroom)
    (room-unfinished kitchen)
    (room-unfinished living)

    (room-uninspected bedroom)
    (room-uninspected kitchen)
    (room-uninspected living)

    ;; floors start undamaged (you may leave them not-clean to force cleaning)
    (floor-undamaged bedroom)
    (floor-undamaged kitchen)
    (floor-undamaged living)
    ;; leave floor-clean facts OUT initially if you want cleaning actions to apply

    ;; items and their rooms
    (in-room tv living)
    (in-room plates kitchen)
    (in-room books bedroom)

    ;; initial item condition
    (undamaged tv)
    (undamaged plates)
    (undamaged books)
    (item-stage-prep tv)
    (item-stage-prep plates)
    (item-stage-prep books)

    ;; boxes located at rooms (one per room to keep counters consistent)
    (box-at box1 bedroom)
    (box-at box2 kitchen)
    (box-at box3 living)

    ;; planned packing assignments (optional but useful if your actions consult these)
    (assigned-box tv box3)
    (assigned-box plates box2)
    (assigned-box books box1)

    (assigned-label box1 label1)
    (assigned-label box2 label2)
    (assigned-label box3 label3)

    ;; keys in hand (if your lock/unlock/return keys actions use this)
    (keys-in-hand key1)

    ;; numeric resources / counters
    ;; boxes-left counts boxes for the room that are NOT YET LOADED.
    ;; set equal to the number of boxes you intend to load per room.
    (= (boxes-left bedroom) 1)
    (= (boxes-left kitchen) 1)
    (= (boxes-left living) 1)

    ;; tape & cleaner resources (set to something reasonable)
    (= (tape-length tape1) 10)
    (= (cleaner-amount sponge) 5)

    ;; number of trash bags available (domain uses zero-arity trashbags-left)
    (= (trashbags-left) 2)

    ;; total-cost starts at 0 if you are minimizing it
    (= (total-cost) 0)

    ;; which room is the final one that gates moveout completion
    (final-room kitchen)
  )

  ;; Keep the goal simple and aligned with the domain’s last action:
  ;; mark_moveout_complete requires (final-room ?r) and (room-stage-done ?r),
  ;; then asserts (moveout-complete).
  (:goal (and
    ;; Logistics: each item boxed (rewrite exists to disjunction for OPTIC compatibility)
    (preference tv-boxed (or (in-box tv box1) (in-box tv box2) (in-box tv box3)))
    (preference plates-boxed (or (in-box plates box1) (in-box plates box2) (in-box plates box3)))
    (preference books-boxed (or (in-box books box1) (in-box books box2) (in-box books box3)))

    ;; And corresponding "in truck" states
    (preference tv-in-truck (or (and (in-box tv box1) (in-truck box1))
                                (and (in-box tv box2) (in-truck box2))
                                (and (in-box tv box3) (in-truck box3))))
    (preference plates-in-truck (or (and (in-box plates box1) (in-truck box1))
                                    (and (in-box plates box2) (in-truck box2))
                                    (and (in-box plates box3) (in-truck box3))))
    (preference books-in-truck (or (and (in-box books box1) (in-truck box1))
                                   (and (in-box books box2) (in-truck box2))
                                   (and (in-box books box3) (in-truck box3))))

    ;; Process quality
    (preference all-labeled (and (labeled box1) (labeled box2) (labeled box3)))
    (preference all-sealed (and (sealed box1) (sealed box2) (sealed box3)))
    (preference no-blind-pack-pref (no-blind-pack))

    ;; Cleaning and handover
    (preference floors-clean (and (floor-clean bedroom) (floor-clean kitchen) (floor-clean living)))
    (preference floors-undamaged (and (floor-undamaged bedroom) (floor-undamaged kitchen) (floor-undamaged living)))
    (preference trash-removed-all (and (trash-removed bedroom) (trash-removed kitchen) (trash-removed living)))
    (preference keys-back (keys-returned))
    (moveout-complete))
  )

  ;; Use whatever metric your domain supports; total-cost is common with :action-costs
  (:metric minimize (+
      (total-cost)
      (is-violated tv-boxed)
      (is-violated plates-boxed)
      (is-violated books-boxed)
      (is-violated tv-in-truck)
      (is-violated plates-in-truck)
      (is-violated books-in-truck)
      (is-violated all-labeled)
      (is-violated all-sealed)
      (is-violated no-blind-pack-pref)
      (is-violated floors-clean)
      (is-violated floors-undamaged)
      (is-violated trash-removed-all)
      (is-violated keys-back)
    )
  )
)
