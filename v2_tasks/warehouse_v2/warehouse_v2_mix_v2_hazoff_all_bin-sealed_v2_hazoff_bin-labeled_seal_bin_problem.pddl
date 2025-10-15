(define (problem warehouse-instance-updated-prefs-softgoals)
	(:domain warehouse-v1-expert)
	(:requirements :preferences)
	(:objects 
		robot1 - robot
		scan1 - scanner
		tote1 - tote
		bin1 bin2 - bin
		pallet1 - pallet
		shelfA shelfB - shelf
		a1 a2 - aisle
		loc1 loc2 - location
		itemA itemB - item
	)
	(:init
		(at robot1 loc1)
		(in-aisle loc1 a1)
		(in-aisle loc2 a2)
		(aisle-clear a1)
		(not (aisle-clear a2))
		(available scan1)
		(current-item itemA)
		(next-item itemA itemB)
		(current-bin bin1)
		(next-bin bin1 bin2)
		(bin-open bin1)
		(bin-open bin2)
		(item-at itemA shelfA)
		(item-at itemB shelfB)
		(undamaged itemA)
		(undamaged itemB)
		(= (total-cost) 0)
	)
	(:goal (and 
		(preference binned-itemA (item-binned itemA))
		(preference binned-itemB (item-binned itemB))
		(preference undamaged-itemA (undamaged itemA))
		(preference undamaged-itemB (undamaged itemB))
		(preference labeled-itemA (labeled itemA))
		(preference labeled-itemB (labeled itemB))
		(preference bin-sealed-bin1 (bin-sealed bin1))
		(preference bin-labeled-bin1 (bin-labeled bin1))
		(preference palletized-bin1 (on-pallet bin1 pallet1))
		(preference wrapped-pallet1 (wrapped pallet1))
		(preference picked-itemA (in-tote itemA tote1))
		(preference picked-itemB (in-tote itemB tote1))
		(preference no-blind-pick-pref (not (blind-pick)))
		(preference aisle-clear-a2 (aisle-clear a2))
		(preference scanned-all (and (item-scanned itemA) (item-scanned itemB)))
		))
	(:metric minimize (+
		(total-cost)
		(is-violated binned-itemA)
		(is-violated binned-itemB)
		(is-violated undamaged-itemA)
		(is-violated undamaged-itemB)
		(is-violated labeled-itemA)
		(is-violated labeled-itemB)
		(is-violated bin-sealed-bin1)
		(is-violated bin-labeled-bin1)
		(is-violated palletized-bin1)
		(is-violated wrapped-pallet1)
		(is-violated picked-itemA)
		(is-violated picked-itemB)
		(is-violated no-blind-pick-pref)
		(is-violated aisle-clear-a2)
		))
)
