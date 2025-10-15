(define (domain renovation-v1-expert-fixed)
	(
		:requirements
		:strips
		:typing
		:action-costs
		:numeric-fluents
		:preferences
		:negative-preconditions
		:disjunctive-preconditions
		:fluents
	)
	(
		:types
		object room wall paint roller brush tray - tool
	)
	(
		:predicates
		(wall-in-room ?w - wall ?r - room)
		(furniture-moved ?r - room)
		(edges-taped ?w - wall)
		(stirred ?p - paint)
		(first-coat ?w - wall)
		(second-coat ?w - wall)
		(edges-clean ?w - wall)
		(tool-clean ?t - tool)
		(paint-on-roller ?p - paint ?ro - roller)
		(paint-on-brush ?p - paint ?b - brush)
		(paint-in-tray ?p - paint ?tr - tray)
		(floor-undamaged ?r - room)
		(room-ready ?r - room)
		(current-wall ?w - wall)
		(next-wall ?a - wall ?b - wall)
		(final-wall ?w - wall)
		(wall-stage-prep ?w - wall)
		(wall-stage-first ?w - wall)
		(wall-stage-second ?w - wall)
		(wall-stage-detail ?w - wall)
		(enable-risky)
		(walls-finished)
	)
	(
		:functions
		(total-cost)
		(total-covers)
		(paint-remaining ?p - paint)
		(budget)
	)
	(:action move_furniture
		:parameters (?r - room)
		:precondition (and		)
		:effect (and
			(furniture-moved ?r)
		)
	)
	(:action cover_floor
		:parameters (?r - room)
		:precondition (and 
			(furniture-moved ?r)
			(> (total-covers) 0)
		)
		:effect (and
			(room-ready ?r)
			(decrease (total-covers) 1)
		)
	)
	(:action tape_edges
		:parameters (?w - wall ?r - room)
		:precondition (and 
			(current-wall ?w)
			(room-ready ?r)
			(wall-in-room ?w ?r)
		)
		:effect (and
			(edges-taped ?w)
			(wall-stage-prep ?w)
		)
	)
	(:action stir_paint
		:parameters (?p - paint ?tr - tray ?w - wall)
		:precondition (and 
			(> (paint-remaining ?p) 0)
			(
				or
				(tool-clean ?tr)
				(paint-in-tray ?p ?tr)
			)
			(current-wall ?w)
			(wall-stage-prep ?w)
		)
		:effect (and
			(stirred ?p)
			(paint-in-tray ?p ?tr)
			(not (tool-clean ?tr))
		)
	)
	(:action paint_first_coat_safe
		:parameters (?w - wall ?p - paint ?r - roller ?rm - room ?tr - tray)
		:precondition (and 
			(paint-in-tray ?p ?tr)
			(stirred ?p)
			(edges-taped ?w)
			(current-wall ?w)
			(room-ready ?rm)
			(wall-stage-prep ?w)
			(> (paint-remaining ?p) 0)
			(
				or
				(paint-on-roller ?p ?r)
				(tool-clean ?r)
			)
		)
		:effect (and
			(not (wall-stage-prep ?w))
			(wall-stage-first ?w)
			(first-coat ?w)
			(paint-on-roller ?p ?r)
			(not (tool-clean ?r))
			(increase (total-cost) 1)
			(decrease (paint-remaining ?p) 1)
		)
	)
	(:action paint_first_coat_floor_risky
		:parameters (?w - wall ?p - paint ?r - roller ?rm - room ?tr - tray)
		:precondition (and 
			(paint-in-tray ?p ?tr)
			(stirred ?p)
			(current-wall ?w)
			(not (room-ready ?rm))
			(enable-risky)
			(> (paint-remaining ?p) 0)
		)
		:effect (and
			(not (wall-stage-prep ?w))
			(wall-stage-first ?w)
			(not (floor-undamaged ?rm))
			(paint-on-roller ?p ?r)
			(not (tool-clean ?r))
			(first-coat ?w)
			(decrease (paint-remaining ?p) 1)
		)
	)
	(:action paint_first_coat_wall_risky
		:parameters (?w - wall ?p - paint ?r - roller ?rm - room ?tr - tray)
		:precondition (and 
			(paint-in-tray ?p ?tr)
			(stirred ?p)
			(current-wall ?w)
			(enable-risky)
			(> (paint-remaining ?p) 0)
			(
				or
				(
					not
					(paint-on-roller ?p ?r)
				)
				(not (tool-clean ?r))
			)
			(>= (budget) 5)
		)
		:effect (and
			(not (wall-stage-prep ?w))
			(wall-stage-first ?w)
			(wall-wrong-paint ?w)
			(paint-on-roller ?p ?r)
			(not (tool-clean ?r))
			(first-coat ?w)
			(decrease (paint-remaining ?p) 1)
			(decrease (budget) 5)
		)
	)
	(:action paint_second_coat_safe
		:parameters (?w - wall ?p - paint ?br - brush ?r - room ?tr - tray)
		:precondition (and 
			(paint-in-tray ?p ?tr)
			(first-coat ?w)
			(current-wall ?w)
			(wall-stage-first ?w)
			(wall-in-room ?w ?r)
			(room-ready ?r)
			(
				or
				(paint-on-brush ?p ?br)
				(tool-clean ?br)
			)
			(> (paint-remaining ?p) 0)
		)
		:effect (and
			(not (wall-stage-first ?w))
			(wall-stage-second ?w)
			(second-coat ?w)
			(paint-on-brush ?p ?br)
			(decrease (paint-remaining ?p) 1)
			(not (tool-clean ?br))
			(increase (total-cost) 2)
		)
	)
	(:action paint_second_coat_wall_risky
		:parameters (?w - wall ?p - paint ?br - brush ?r - room ?tr - tray)
		:precondition (and 
			(paint-in-tray ?p ?tr)
			(first-coat ?w)
			(current-wall ?w)
			(wall-stage-first ?w)
			(tool-clean ?br)
			(> (paint-remaining ?p) 0)
			(enable-risky)
			(wall-in-room ?w ?r)
			(
				or
				(
					not
					(paint-on-brush ?p ?br)
				)
				(not (tool-clean ?br))
			)
		)
		:effect (and
			(not (wall-stage-first ?w))
			(wall-stage-second ?w)
			(second-coat ?w)
			(wall-wrong-paint ?w)
			(not (tool-clean ?br))
			(paint-on-brush ?p ?br)
			(decrease (paint-remaining ?p) 1)
			(increase (total-cost) 2)
		)
	)
	(:action detail_edges_safe
		:parameters (?w - wall ?br - brush ?p - paint ?tr - tray)
		:precondition (and 
			(paint-in-tray ?p ?tr)
			(second-coat ?w)
			(current-wall ?w)
			(wall-stage-second ?w)
			(> (paint-remaining ?p) 0)
			(
				or
				(tool-clean ?br)
				(paint-on-brush ?p ?br)
			)
		)
		:effect (and
			(not (wall-stage-second ?w))
			(wall-stage-detail ?w)
			(edges-clean ?w)
			(paint-on-brush ?p ?br)
			(decrease (paint-remaining ?p) 1)
			(not (tool-clean ?br))
			(increase (total-cost) 1)
		)
	)
	(:action detail_edges_risky
		:parameters (?w - wall ?br - brush ?p - paint ?tr - tray)
		:precondition (and 
			(paint-in-tray ?p ?tr)
			(second-coat ?w)
			(current-wall ?w)
			(wall-stage-second ?w)
			(> (paint-remaining ?p) 0)
			(
				or
				(not (tool-clean ?br))
				(
					not
					(paint-on-brush ?p ?br)
				)
			)
		)
		:effect (and
			(not (wall-stage-second ?w))
			(wall-stage-detail ?w)
			(edges-clean ?w)
			(decrease (paint-remaining ?p) 1)
			(not (tool-clean ?br))
			(increase (total-cost) 1)
		)
	)
	(:action clean_tool
		:parameters (?t - tool)
		:precondition (and 
			(not (tool-clean ?t))
			(>= (budget) 1)
		)
		:effect (and
			(tool-clean ?t)
			(increase (total-cost) 1)
			(decrease (budget) 1)
		)
	)
	(:action advance_to_next_wall
		:parameters (?x - wall ?y - wall ?r - room)
		:precondition (and 
			(wall-in-room ?x ?r)
			(wall-in-room ?y ?r)
			(current-wall ?x)
			(next-wall ?x ?y)
			(wall-stage-detail ?x)
		)
		:effect (and
			(not (current-wall ?x))
			(current-wall ?y)
		)
	)
	(:action advance_to_next_room
		:parameters (?x - wall ?y - wall ?r - room)
		:precondition (and 
			(wall-in-room ?x ?r)
			(
				not
				(wall-in-room ?y ?r)
			)
			(current-wall ?x)
			(next-wall ?x ?y)
			(wall-stage-detail ?x)
		)
		:effect (and
			(not (current-wall ?x))
			(current-wall ?y)
		)
	)
	(:action mark_final_wall_done
		:parameters (?w - wall)
		:precondition (and 
			(current-wall ?w)
			(final-wall ?w)
			(wall-stage-detail ?w)
			(>= (budget) 1)
		)
		:effect (and
			(walls-finished)
			(decrease (budget) 1)
		)
	)
)
