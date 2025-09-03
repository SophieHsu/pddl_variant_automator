
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
  )

  (:goal (and
    (preference furniture-moved-pref (furniture-moved room1))
    (preference floor-covered-pref (floor-covered room1))

    (preference first-coats (and (first-coat wallA) (first-coat wallB) (first-coat wallC)))
    (preference second-coats (and (second-coat wallA) (second-coat wallB) (second-coat wallC)))
    (preference edges-clean-pref (and (edges-clean wallA) (edges-clean wallB) (edges-clean wallC)))
    (preference no-blind-paint-pref (no-blind-paint))

    (preference tools-clean-pref (tools-clean))
    (preference trash-out-pref (trash-out bin1))
    (preference floor-undamaged-pref (floor-undamaged room1))

    ;; Attention check
    (preference paint-sampled (and ))
  ))

  (:metric
    minimize (+
      (total-cost)
      (is-violated furniture-moved-pref)
      (is-violated floor-covered-pref)
      (is-violated first-coats)
      (is-violated second-coats)
      (is-violated edges-clean-pref)
      (is-violated no-blind-paint-pref)
      (is-violated tools-clean-pref)
      (is-violated trash-out-pref)
      (is-violated floor-undamaged-pref)
    )
  )
)
