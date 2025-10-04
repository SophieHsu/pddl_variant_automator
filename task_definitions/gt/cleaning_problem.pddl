
(define (problem house-cleaning-instance-1)
  (:domain house-cleaning-v1-expert)

  (:objects
    kitchen bathroom living - room
    counter stove sink - surface
    vac1 - vacuum
    mop1 - mop
    gentle harsh - cleaner
    bin1 - bin
    bag1 - bag
  )

  (:init
    (dirty kitchen)
    (dirty living)
    (dirty bathroom)
    (unsanitized counter)
    (unsanitized stove)
    (unsanitized sink)
    (undamaged counter)
    (undamaged stove)
    (undamaged sink)
    (trash-full bin1)
		(= (total-cost) 0)
    (= (procedure-number) 1)
    (= (mop-current) 1)
    (= (vacuum-current) 1)

    ; order of surfaces and room the mop and vacuum actions should handle (1 = first)
    (= (surface-mop-priority stove) 1)
    (= (surface-mop-priority counter) 2)
    (= (surface-mop-priority sink) 3)
    (= (room-priority living) 1)
    (= (room-priority bathroom) 2)
    (= (room-priority kitchen) 3)

    (= (mop-step-priority) 1)
    (= (vacuum-step-priority) 2)
    (= (trash-step-priority) 3)
    (= (airfresh-step-priority) 4)
  )

  (:goal (and
    (preference clean-kitchen (clean kitchen))
    (preference clean-living (clean living))
    (preference clean-bathroom (clean bathroom))
    (preference sanitized-counter (sanitized counter))
    (preference sanitized-stove (sanitized stove))
    (preference sanitized-sink (sanitized sink))
    (preference undamaged-counter (undamaged counter))
    (preference undamaged-stove (undamaged stove))
    (preference undamaged-sink (undamaged sink))
    (preference trash-out (trash-out bin1))
    (preference pleasant (pleasant-smell))
    (preference no-harsh (not (used-harsh-chem)))

    ;; Declared but not penalized
    ; (preference coasters-placed (and ))
  ))

  (:metric
    minimize (+
      (total-cost)
      (is-violated clean-kitchen)
      (is-violated clean-living)
      (is-violated clean-bathroom)
      (is-violated sanitized-counter)
      (is-violated sanitized-stove)
      (is-violated sanitized-sink)
      (is-violated undamaged-counter)
      (is-violated undamaged-stove)
      (is-violated undamaged-sink)
      (is-violated trash-out)
      (is-violated pleasant)
      (is-violated no-harsh)
    )
  )
)
