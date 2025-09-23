
(define (problem laundry-instance-1)
  (:domain laundry-v1-expert)

  (:objects
    tshirt1 tshirt2 - garment
    dress1 - garment
  )

  (:init
    (in-hamper tshirt1)
    (in-hamper tshirt2)
    (in-hamper dress1)

    (delicate dress1)

    (undamaged tshirt1)
    (undamaged tshirt2)
    (undamaged dress1)
  )

  (:goal (and
    (preference washed-t1 (washed tshirt1))
    (preference dried-t1 (dried tshirt1))
    (preference folded-t1 (folded tshirt1))
    (preference put-away-t1 (put-away tshirt1))
    (preference undamaged-t1 (undamaged tshirt1))
    (preference no-bleed-t1 (not (color-bled tshirt1)))

    (preference washed-t2 (washed tshirt2))
    (preference dried-t2 (dried tshirt2))
    (preference folded-t2 (folded tshirt2))
    (preference put-away-t2 (put-away tshirt2))
    (preference undamaged-t2 (undamaged tshirt2))
    (preference no-bleed-t2 (not (color-bled tshirt2)))

    (preference washed-d1 (washed dress1))
    (preference dried-d1 (dried dress1))
    (preference folded-d1 (folded dress1))
    (preference put-away-d1 (put-away dress1))
    (preference undamaged-d1 (undamaged dress1))
    (preference fresh-d1 (fresh-smell dress1))


    (preference )

    ;; Declared but not penalized
    ; (preference matched-socks (and ))
  ))

  (:metric
    minimize (+
      (total-cost)



      ; (is-violated washed-t1)
      ; (is-violated dried-t1)
      ; (is-violated folded-t1)
      ; (is-violated put-away-t1)
      ; (is-violated undamaged-t1)
      ; (is-violated no-bleed-t1)

      ; (is-violated washed-t2)
      ; (is-violated dried-t2)
      ; (is-violated folded-t2)
      ; (is-violated put-away-t2)
      ; (is-violated undamaged-t2)
      ; (is-violated no-bleed-t2)

      ; (is-violated washed-d1)
      ; (is-violated dried-d1)
      ; (is-violated folded-d1)
      ; (is-violated put-away-d1)
      ; (is-violated undamaged-d1)
      ; (is-violated fresh-d1)
    )
  )
)
