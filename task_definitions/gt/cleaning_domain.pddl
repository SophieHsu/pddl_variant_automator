
(define (domain house-cleaning-v1-expert)
  (:requirements :strips :typing :preferences :action-costs)
  (:types
    room surface cleaner vacuum mop bin bag - object
  )

  (:predicates
    (dirty ?r - room)
    (clean ?r - room)

    (sanitized ?s - surface)
    (unsanitized ?s - surface)
    (undamaged ?s - surface)

    (trash-full ?b - bin)
    (trash-not-full ?b - bin)
    (trash-out ?b - bin)

    (pleasant-smell)
    (used-harsh-chem)
  )

  (:functions (total-cost))

  (:action vacuum_room
    :parameters (?r - room ?v - vacuum)
    :precondition (and 
      (dirty ?r)
    )
    :effect (and
      (clean ?r)
      (not (dirty ?r))
      ; (increase (total-cost) 0)
    )
  )

  (:action mop_mild
    :parameters (?s - surface ?m - mop ?c - cleaner)
    :precondition (and 
      (unsanitized ?s)
    )
    :effect (and
      (sanitized ?s)
      (not (unsanitized ?s))
      (increase (total-cost) 0)
    )
  )

  (:action mop_harsh
    :parameters (?s - surface ?m - mop ?c - cleaner)
    :precondition (and 
      (unsanitized ?s)
    )
    :effect (and
      (sanitized ?s)
      (not (unsanitized ?s))
      (not (undamaged ?s))
      (used-harsh-chem)
      ; (increase (total-cost) 1)
    )
  )

  (:action wipe_counters
    :parameters (?s - surface ?c - cleaner)
    :precondition (and 
      (unsanitized ?s)
    )
    :effect (and
      (sanitized ?s)
      (not (unsanitized ?s))
      ; (increase (total-cost) 1)
    )
  )

  (:action collect_trash
    :parameters (?b - bin ?bag - bag)
    :precondition (and 
      (trash-full ?b)
    )
    :effect (and
      (not (trash-full ?b))
      (trash-not-full ?b)
      ; (increase (total-cost) 1)
    )
  )

  (:action take_out_trash
    :parameters (?b - bin ?bag - bag)
    :precondition (and 
      (trash-not-full ?b)
    )
    :effect (and
      (trash-out ?b)
      ; (increase (total-cost) 2)
    )
  )

  (:action spray_airfreshener
    :parameters ()
    :precondition (and)
    :effect (and
      (pleasant-smell)
      ; (increase (total-cost) 1)
    )
  )
)
