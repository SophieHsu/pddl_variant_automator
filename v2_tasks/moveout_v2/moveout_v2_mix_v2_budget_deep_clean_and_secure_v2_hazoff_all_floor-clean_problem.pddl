(define (problem moveout-instance-updated)
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
		key1 - key
	)
	(:init
		(current-room living)
		(room-unlocked bedroom)
		(room-unlocked kitchen)
		(room-unlocked living)
		(room-unfinished bedroom)
		(room-unfinished kitchen)
		(room-unfinished living)
		(room-uninspected bedroom)
		(room-uninspected kitchen)
		(room-uninspected living)
		(floor-undamaged bedroom)
		(floor-undamaged kitchen)
		(floor-undamaged living)
		(in-room tv living)
		(in-room plates kitchen)
		(in-room books bedroom)
		(undamaged tv)
		(undamaged plates)
		(undamaged books)
		(item-stage-prep tv)
		(item-stage-prep plates)
		(item-stage-prep books)
		(box-at box1 bedroom)
		(box-at box2 kitchen)
		(box-at box3 living)
		(assigned-box tv box3)
		(assigned-box plates box2)
		(assigned-box books box1)
		(assigned-label box1 label1)
		(assigned-label box2 label2)
		(assigned-label box3 label3)
		(keys-in-hand key1)
		(= (boxes-left bedroom) 1)
		(= (boxes-left kitchen) 1)
		(= (boxes-left living) 1)
		(= (tape-length tape1) 10)
		(= (cleaner-amount sponge) 5)
		(= (trashbags-left) 2)
		(= (total-cost) 0)
		(final-room kitchen)
		(= (budget) 12)
	)
	(:goal (and 
		(preference tv-boxed (
				or
				(in-box tv box1)
				(in-box tv box2)
				(in-box tv box3)
			))
		(preference plates-boxed (
				or
				(in-box plates box1)
				(in-box plates box2)
				(in-box plates box3)
			))
		(preference books-boxed (
				or
				(in-box books box1)
				(in-box books box2)
				(in-box books box3)
			))
		(
				preference
				tv-in-truck
				(
					or
					(
						and
						(in-box tv box1)
						(in-truck box1)
					)
					(
						and
						(in-box tv box2)
						(in-truck box2)
					)
					(
						and
						(in-box tv box3)
						(in-truck box3)
					)
				)
			)
		(
				preference
				plates-in-truck
				(
					or
					(
						and
						(in-box plates box1)
						(in-truck box1)
					)
					(
						and
						(in-box plates box2)
						(in-truck box2)
					)
					(
						and
						(in-box plates box3)
						(in-truck box3)
					)
				)
			)
		(
				preference
				books-in-truck
				(
					or
					(
						and
						(in-box books box1)
						(in-truck box1)
					)
					(
						and
						(in-box books box2)
						(in-truck box2)
					)
					(
						and
						(in-box books box3)
						(in-truck box3)
					)
				)
			)
		(preference all-labeled (and (labeled box1) (labeled box2) (labeled box3)))
		(preference all-sealed (and (sealed box1) (sealed box2) (sealed box3)))
		(preference no-blind-pack-pref (no-blind-pack))
		(preference floors-clean (and (floor-clean bedroom) (floor-clean kitchen) (floor-clean living)))
		(
				preference
				floors-undamaged
				(
					and
					(floor-undamaged bedroom)
					(floor-undamaged kitchen)
					(floor-undamaged living)
				)
			)
		(preference trash-removed-all (and (trash-removed bedroom) (trash-removed kitchen) (trash-removed living)))
		(preference keys-back (keys-returned))
		(moveout-complete)
		))
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
		))
)
