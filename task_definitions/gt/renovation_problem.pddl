
(define (problem renovation-instance-1-fixed)
  (:domain renovation-v1-expert-fixed)

  (:objects
    room1 - room
    wallA wallB wallC - wall
    t1 - tape
    cover1 - cover
    paint1 - paint
    roller1 - roller
    brush1 - brush
    tray1 - tray
    ladder1 - ladder
    bin1 - bin
  )

  (:init
    (floor-undamaged room1)
    (floor-not-covered room1)
    (all-first-coat-not-done room1)
    (all-second-coat-not-done room1)
    (all-edges-not-done room1)
		(= (total-cost) 0)
  )

  (:goal (and
    (preference furniture-moved-pref (furniture-moved room1))
    (preference floor-covered-pref (floor-covered room1))

    (preference first-coatA (first-coat wallA))
    (preference first-coatB (first-coat wallB))
    (preference first-coatC (first-coat wallC))
    (preference second-coatA (second-coat wallA))
    (preference second-coatB (second-coat wallB))
    (preference second-coatC (second-coat wallC))
    (preference edge-clean-A (edges-clean wallA))
    (preference edge-clean-B (edges-clean wallB))
    (preference edge-clean-C (edges-clean wallC))

    (preference no-risky-paint-pref (not (used-risky-paint)))

    (preference clean-roller (tool-cleaned roller1))
    (preference clean-brush (tool-cleaned brush1))
    (preference clean-tray (tool-cleaned tray1))


    (preference trash-out-pref (trash-out bin1))
    (preference floor-undamaged-pref (floor-undamaged room1))

    ;; Attention check
    ; (preference paint-sampled (and ))
  ))

  (:metric
    minimize (+
      (total-cost)
      (is-violated furniture-moved-pref)
      (is-violated floor-covered-pref)
      (is-violated first-coatA)
      (is-violated first-coatB)
      (is-violated first-coatC)
      (is-violated second-coatA)
      (is-violated second-coatB)
      (is-violated second-coatC)
      (is-violated edge-clean-A)
      (is-violated edge-clean-B)
      (is-violated edge-clean-C)
      (is-violated no-risky-paint-pref)
      (is-violated clean-roller)
      (is-violated clean-tray)
      (is-violated clean-brush)
      (is-violated trash-out-pref)
      (is-violated floor-undamaged-pref)
    )
  )
)
