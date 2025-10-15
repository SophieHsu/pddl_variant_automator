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
		tide - stainremover
		sof1 - detergent
		pretreat1 - detergent
		jeans1 hoodie1 blouse1 tshirt1 - garment
	)
	(:init
		(in-hamper jeans1)
		(in-hamper hoodie1)
		(in-hamper blouse1)
		(in-hamper tshirt1)
		(is-dark jeans1)
		(is-dark hoodie1)
		(delicate blouse1)
		(is-light tshirt1)
		(stained blouse1)
		(tissue-in-pocket hoodie1)
		(coins-in-pocket jeans1)
		(zippers-open jeans1)
		(zippers-open hoodie1)
		(undamaged jeans1)
		(undamaged hoodie1)
		(undamaged blouse1)
		(undamaged tshirt1)
		(stage-prep jeans1)
		(stage-prep hoodie1)
		(stage-prep blouse1)
		(stage-prep tshirt1)
		(current jeans1)
		(next jeans1 hoodie1)
		(next hoodie1 blouse1)
		(next blouse1 tshirt1)
		(must-fold jeans1)
		(must-hang hoodie1)
		(must-hang blouse1)
		(must-fold tshirt1)
		(= (total-cost) 0)
		(is_stainremover tide)
		(is_detergent pretreat1)
		(is_detergent sof1)
	)
	(:goal (and 
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
		(preference pockets-checked-jeans (pockets-checked jeans1))
		(preference pockets-checked-hoodie (pockets-checked hoodie1))
		(preference zippers-closed-jeans (not (zippers-open jeans1)))
		(preference zippers-closed-hoodie (not (zippers-open hoodie1)))
		(preference no-tissue-hoodie (not (tissue-in-pocket hoodie1)))
		(preference no-coins-jeans (not (coins-in-pocket jeans1)))
		(preference inside-out-blouse (inside-out blouse1))
		(preference no-lint-jeans (not (lint-covered jeans1)))
		(preference no-lint-hoodie (not (lint-covered hoodie1)))
		(
				preference
				no-bleed-all
				(
					and
					(not (color-bled jeans1))
					(not (color-bled hoodie1))
					(not (color-bled blouse1))
					(not (color-bled tshirt1))
				)
			)
		(
				preference
				not-shrunk-all
				(
					and
					(not (shrunk jeans1))
					(not (shrunk hoodie1))
					(not (shrunk blouse1))
					(not (shrunk tshirt1))
				)
			)
		(
				preference
				undamaged-all
				(
					and
					(undamaged jeans1)
					(undamaged hoodie1)
					(undamaged blouse1)
					(undamaged tshirt1)
				)
			)
		(preference fresh-blouse (soften blouse1))
		(preference lint-removed-dryer (lint-removed dryer1))
		(preference perfect-press (and (ironed jeans1) (ironed hoodie1) (ironed blouse1) (ironed tshirt1)))
		))
	(:metric minimize (+
		(total-cost)
		(is-violated washed-jeans1)
		(is-violated dried-jeans1)
		(is-violated stored-jeans1)
		(is-violated washed-hoodie1)
		(is-violated dried-hoodie1)
		(is-violated stored-hoodie1)
		(is-violated washed-blouse1)
		(is-violated dried-blouse1)
		(is-violated stored-blouse1)
		(is-violated washed-tshirt1)
		(is-violated dried-tshirt1)
		(is-violated stored-tshirt1)
		(is-violated pockets-checked-jeans)
		(is-violated pockets-checked-hoodie)
		(is-violated zippers-closed-jeans)
		(is-violated zippers-closed-hoodie)
		(is-violated no-tissue-hoodie)
		(is-violated no-coins-jeans)
		(is-violated inside-out-blouse)
		(is-violated no-lint-jeans)
		(is-violated no-lint-hoodie)
		(is-violated no-bleed-all)
		(is-violated not-shrunk-all)
		(is-violated undamaged-all)
		(is-violated fresh-blouse)
		(is-violated lint-removed-dryer)
		))
)
