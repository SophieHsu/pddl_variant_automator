
(define (domain renovation-v1-expert-fixed)
  (:requirements :strips :typing :preferences :action-costs)
  (:types
    room wall tape cover paint painting_tools ladder bin - object
    roller brush tray - painting_tools
  )

  (:predicates
    (furniture-moved ?r - room)
    (floor-covered ?r - room)
    (floor-not-covered ?r - room)
    (edges-taped ?w - wall)
    (stirred ?p - paint)
    (first-coat ?w - wall)
    (second-coat ?w - wall)
    (edges-clean ?w - wall)
    (all-first-coat-done ?r - room)
    (all-first-coat-not-done ?r - room)
    (all-second-coat-done ?r - room)
    (all-second-coat-not-done ?r - room)
    (all-edges-done ?r - room)
    (all-edges-not-done ?r - room)
    (tool-dirty ?t - painting_tools)
    (tool-cleaned ?t - painting_tools)
    (trash-out ?b - bin)
    (floor-undamaged ?r - room)
    (used-risky-paint)
  )

  (:functions (total-cost))

  (:action move_furniture
    :parameters (?r - room)
    :precondition (and
      (floor-not-covered ?r)
    )
    :effect (and
      (furniture-moved ?r)
      (increase (total-cost) 0)
    )
  )

  (:action cover_floor
    :parameters (?r - room ?c - cover)
    :precondition (and 
      (furniture-moved ?r)
    )
    :effect (and
      (floor-covered ?r)
      ; (increase (total-cost) 2)
    )
  )

  (:action tape_edges
    :parameters (?w - wall ?t - tape)
    :precondition (and)
    :effect (and
      (edges-taped ?w)
      ; (increase (total-cost) 2)
    )
  )

  (:action stir_paint_risky
    :parameters (?p - paint ?tr - tray ?r - room)
    :precondition (and)
    :effect (and
      (stirred ?p)
      (tool-dirty ?tr)
      (used-risky-paint)
      ; (increase (total-cost) 1)
    )
  )

  (:action stir_paint_safe
    :parameters (?p - paint ?tr - tray ?r - room)
    :precondition (and 
      (floor-covered ?r)
    )
    :effect (and 
      (stirred ?p)
      (tool-dirty ?tr)
    )
  )

  (:action paint_first_coat_safe
    :parameters (?w - wall ?p - paint ?r - roller ?ld - ladder ?rm - room)
    :precondition (and 
      (all-first-coat-not-done ?rm)
      (stirred ?p) 
      (edges-taped ?w) 
      (floor-covered ?rm)
    )
    :effect (and
      (first-coat ?w)
      (tool-dirty ?r)
      ; (increase (total-cost) 3)
    )
  )

  (:action paint_first_coat_risky
    :parameters (?w - wall ?p - paint ?r - roller ?rm - room)
    :precondition (and 
      (all-first-coat-not-done ?rm)
      (stirred ?p)
    )
    :effect (and
      (first-coat ?w)
      (tool-dirty ?r)
      (not (floor-undamaged ?rm))
      (used-risky-paint)
      ; (increase (total-cost) 1)
    )
  )

  (:action paint_second_coat_safe
    :parameters (?w - wall ?p - paint ?br - brush ?rm - room)
    :precondition (and 
      (all-first-coat-done ?rm)
      (all-second-coat-not-done ?rm)
      (first-coat ?w)
      (edges-taped ?w) 
      (floor-covered ?rm)
    )
    :effect (and
      (second-coat ?w)
      (tool-dirty ?br)
      ; (increase (total-cost) 2)
    )
  )

  (:action paint_second_coat_risky
    :parameters (?w - wall ?p - paint ?br - brush ?rm - room)
    :precondition (and 
      (all-first-coat-done ?rm)
      (all-second-coat-not-done ?rm)
      (first-coat ?w)
    )
    :effect (and
      (second-coat ?w)
      (tool-dirty ?br)
      (not (floor-undamaged ?rm))
      (used-risky-paint)
      ; (increase (total-cost) 2)
    )
  )

  (:action detail_edges_safe
    :parameters (?w - wall ?br - brush ?rm - room)
    :precondition (and 
      (all-second-coat-done ?rm)
      (all-edges-not-done ?rm)
      (second-coat ?w)
      (floor-covered ?rm)
      (edges-taped ?w)
    )
    :effect (and
      (edges-clean ?w)
      (tool-dirty ?br)
      ; (increase (total-cost) 1)
    )
  )

  (:action detail_edges_risky
    :parameters (?w - wall ?br - brush ?rm - room)
    :precondition (and 
      (all-second-coat-done ?rm)
      (all-edges-not-done ?rm)
      (second-coat ?w)
    )
    :effect (and
      (edges-clean ?w)
      (tool-dirty ?br)
      (floor-undamaged ?rm)
      (used-risky-paint)
      ; (increase (total-cost) 1)
    )
  )

  ;; flags to enforce order
  (:action declare_all_first_coats_done
    :parameters (?r - room)
    :precondition (and )
    :effect (and 
      (all-first-coat-done ?r)
      (not (all-first-coat-not-done ?r))
    )
  )

  (:action declare_all_second_coats_done
    :parameters (?r - room)
    :precondition (and 
      (all-first-coat-done ?r)
    )
    :effect (and 
      (all-second-coat-done ?r)
      (not (all-second-coat-not-done ?r))
    )
  )

  (:action declare_all_edges_done
    :parameters (?r - room)
    :precondition (and 
      (all-second-coat-done ?r)
    )
    :effect (and 
      (all-edges-done ?r)
      (not (all-edges-not-done ?r))
    )
  )

  (:action clean_tool
    :parameters (?t - painting_tools ?r - room)
    :precondition (and
      (all-edges-done ?r)
      (tool-dirty ?t)
    )
    :effect (and
      (tool-cleaned ?t)
      (not (tool-dirty ?t))
      ; (increase (total-cost) 2)
    )
  )

  (:action take_out_trash
    :parameters (?b - bin ?r - room)
    :precondition (and
      (all-edges-done ?r)
    )
    :effect (and
      (trash-out ?b)
      ; (increase (total-cost) 1)
    )
  )
)
