
(define (problem laundry-instance-v3)
  (:domain laundry-v3-expert)

  (:objects
    washer1 - washer
    dryer1 - dryer
    steamer1 - steamer
    iron1 - iron
    closet1 - closet
    hanger1 hanger2 hanger3 hanger4 - hanger
    basket1 - basket
    tide - detergent
    sof1 - softener
    pretreat1 - stainremover
    jeans1 hoodie1 blouse1 tshirt1 - garment
  )

  (:init
    (in-hamper jeans1)
    (in-hamper hoodie1)
    (in-hamper blouse1)
    (in-hamper tshirt1)

    (is-dark jeans1)
    (is-dark hoodie1)
    (is-light tshirt1)
    (is-delicate blouse1)
    (stained blouse1)

    ;; Pocket hazards & prep needs
    (tissue-in-pocket hoodie1)
    (no-coins-in-pocket hoodie1)
    (zippers-open hoodie1)
  
    (coins-in-pocket jeans1)
    (no-tissue-in-pocket jeans1)
    (zippers-open jeans1)

    (no-tissue-in-pocket blouse1)
    (no-coins-in-pocket blouse1)
    (zippers-closed blouse1)

    (no-tissue-in-pocket tshirt1)
    (no-coins-in-pocket tshirt1)
    (zippers-closed tshirt1)
    

    ;; All start undamaged
    (undamaged jeans1)
    (undamaged hoodie1)
    (undamaged blouse1)
    (undamaged tshirt1)

		(= (total-cost) 0)
  )

  (:goal (and
    ;; Core washing / drying / storage for all
    (preference washed-jeans1 (washed jeans1))
    (preference dried-jeans1 (dried jeans1))
    (preference stored-jeans1 (put-away jeans1))

    (preference washed-hoodie1 (washed hoodie1))
    (preference dried-hoodie1 (dried hoodie1))
    (preference stored-hoodie1 (put-away hoodie1))

    (preference washed-blouse1 (washed blouse1))
    (preference dried-blouse1 (dried blouse1))
    (preference stored-blouse1 (put-away blouse1))

    (preference washed-tshirt1 (washed tshirt1))
    (preference dried-tshirt1 (dried tshirt1))
    (preference stored-tshirt1 (put-away tshirt1))

    ;; Prep & safety preferences (longer chain incentives)
    (preference pockets-checked-jeans (pockets-checked jeans1))
    (preference pockets-checked-hoodie (pockets-checked hoodie1))
    (preference zippers-closed-jeans (not (zippers-open jeans1)))
    (preference zippers-closed-hoodie (not (zippers-open hoodie1)))
    (preference no-tissue-hoodie (not (tissue-in-pocket hoodie1)))
    (preference no-coins-jeans (not (coins-in-pocket jeans1)))
    (preference inside-out-blouse (inside-out blouse1))

    ;; Quality outcomes to undo risky choices
    (preference no-lint-jeans (not (lint-covered jeans1)))
    (preference no-lint-hoodie (not (lint-covered hoodie1)))

    (preference no-bleed-jeans1 (not (color-bled jeans1)))
    (preference no-bleed-hoodie1 (not (color-bled hoodie1)))
    (preference no-bleed-blouse1 (not (color-bled blouse1)))
    (preference no-bleed-tshirt1 (not (color-bled tshirt1)))

    (preference not-shrunk-jeans1 (not (shrunk jeans1)))
    (preference not-shrunk-hoodie1 (not (shrunk hoodie1)))
    (preference not-shrunk-blouse1 (not (shrunk blouse1)))
    (preference not-shrunk-tshirt1 (not (shrunk tshirt1)))

    (preference undamaged-jeans1 (undamaged jeans1))
    (preference undamaged-hoodie1 (undamaged hoodie1))
    (preference undamaged-blouse1 (undamaged blouse1))
    (preference undamaged-tshirt1 (undamaged tshirt1))

    (preference no-stain-jeans1 (not (stained jeans1)))
    (preference no-stain-hoodie1 (not (stained hoodie1)))
    (preference no-stain-blouse1 (not (stained blouse1)))
    (preference no-stain-tshirt1 (not (stained tshirt1)))

    (preference fresh-blouse (fresh-smell blouse1))

    ;; Machine care
    (preference lint-removed-dryer (lint-removed dryer1))

    ;; Attention check (declared but not penalized)
    (preference perfect-press (and (ironed jeans1) (ironed hoodie1) (ironed blouse1) (ironed tshirt1)))
  ))

  (:metric
    minimize (+
      (total-cost)

      (is-violated washed-jeans1) (is-violated dried-jeans1) (is-violated stored-jeans1)
      (is-violated washed-hoodie1) (is-violated dried-hoodie1) (is-violated stored-hoodie1)
      (is-violated washed-blouse1) (is-violated dried-blouse1) (is-violated stored-blouse1)
      (is-violated washed-tshirt1) (is-violated dried-tshirt1) (is-violated stored-tshirt1)

      (is-violated pockets-checked-jeans)
      (is-violated pockets-checked-hoodie)
      (is-violated zippers-closed-jeans)
      (is-violated zippers-closed-hoodie)
      (is-violated no-tissue-hoodie)
      (is-violated no-coins-jeans)
      (is-violated inside-out-blouse)

      (is-violated no-lint-jeans)
      (is-violated no-lint-hoodie)

      (is-violated no-bleed-jeans1)
      (is-violated no-bleed-hoodie1)
      (is-violated no-bleed-blouse1)
      (is-violated no-bleed-tshirt1)

      (is-violated not-shrunk-jeans1)
      (is-violated not-shrunk-hoodie1)
      (is-violated not-shrunk-blouse1)
      (is-violated not-shrunk-tshirt1)

      (is-violated undamaged-jeans1)
      (is-violated undamaged-hoodie1)
      (is-violated undamaged-blouse1)
      (is-violated undamaged-tshirt1)

      (is-violated fresh-blouse)

      (is-violated lint-removed-dryer)
    )
  )
)
