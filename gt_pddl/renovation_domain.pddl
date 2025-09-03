
(define (domain renovation-v1-expert-fixed)
  (:requirements :strips :typing :preferences :action-costs)
  (:types
    object
    room wall tape cover paint roller brush tray ladder bin
  )

  (:predicates
    (furniture-moved ?r - room)
    (floor-covered ?r - room)
    (edges-taped ?w - wall)
    (stirred ?p - paint)
    (first-coat ?w - wall)
    (second-coat ?w - wall)
    (edges-clean ?w - wall)
    (tools-clean)
    (trash-out ?b - bin)
    (floor-undamaged ?r - room)
    (no-blind-paint)
  )

  (:functions (total-cost))

  (:action move_furniture
    :parameters (?r - room)
    :precondition (and)
    :effect (and
      (furniture-moved ?r)
      (increase (total-cost) 2)
    )
  )

  (:action cover_floor
    :parameters (?r - room ?c - cover)
    :precondition (and (furniture-moved ?r))
    :effect (and
      (floor-covered ?r)
      (increase (total-cost) 2)
    )
  )

  (:action tape_edges
    :parameters (?w - wall ?t - tape)
    :precondition (and)
    :effect (and
      (edges-taped ?w)
      (increase (total-cost) 2)
    )
  )

  (:action stir_paint
    :parameters (?p - paint ?tr - tray)
    :precondition (and)
    :effect (and
      (stirred ?p)
      (increase (total-cost) 1)
    )
  )

  (:action paint_first_coat_safe
    :parameters (?w - wall ?p - paint ?r - roller ?ld - ladder ?rm - room)
    :precondition (and (stirred ?p) (edges-taped ?w) (floor-covered ?rm))
    :effect (and
      (first-coat ?w)
      (no-blind-paint)
      (increase (total-cost) 3)
    )
  )

  (:action paint_first_coat_risky
    :parameters (?w - wall ?p - paint ?r - roller ?rm - room)
    :precondition (and (stirred ?p))
    :effect (and
      (first-coat ?w)
      (not (floor-undamaged ?rm))
      (increase (total-cost) 1)
    )
  )

  (:action paint_second_coat
    :parameters (?w - wall ?p - paint ?br - brush)
    :precondition (and (first-coat ?w))
    :effect (and
      (second-coat ?w)
      (increase (total-cost) 2)
    )
  )

  (:action detail_edges
    :parameters (?w - wall ?br - brush)
    :precondition (and (second-coat ?w))
    :effect (and
      (edges-clean ?w)
      (increase (total-cost) 1)
    )
  )

  (:action clean_tools
    :parameters (?tr - tray ?br - brush ?rl - roller)
    :precondition (and)
    :effect (and
      (tools-clean)
      (increase (total-cost) 2)
    )
  )

  (:action take_out_trash
    :parameters (?b - bin)
    :precondition (and)
    :effect (and
      (trash-out ?b)
      (increase (total-cost) 1)
    )
  )
)
