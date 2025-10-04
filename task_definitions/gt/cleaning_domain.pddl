
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

  (:functions 
    (total-cost)
    (procedure-number)
    (mop-current)
    (vacuum-current)
    (surface-mop-priority ?s - surface)
    (room-priority ?r - room)
    (mop-step-priority)
    (vacuum-step-priority)
    (trash-step-priority)
    (airfresh-step-priority)
  )


  (:action vacuum_room
    :parameters (?r - room ?v - vacuum)
    :precondition (and
      (= (procedure-number) (vacuum-step-priority))
      (= (vacuum-current) (room-priority ?r))
      (dirty ?r)
    )
    :effect (and
      (clean ?r)
      (not (dirty ?r))
      (assign (vacuum-current) (+ (vacuum-current) 1))
    )
  )

  (:action mop_mild
    :parameters (?s - surface ?m - mop ?c - cleaner)
    :precondition (and 
      (= (procedure-number) (mop-step-priority))
      (= (mop-current) (surface-mop-priority ?s))
      (unsanitized ?s)
    )
    :effect (and
      (sanitized ?s)
      (not (unsanitized ?s))
      (increase (total-cost) 0)
      (assign (mop-current) (+ (mop-current) 1))
    )
  )

  (:action mop_harsh
    :parameters (?s - surface ?m - mop ?c - cleaner)
    :precondition (and 
      (unsanitized ?s)
      (= (procedure-number) (mop-step-priority))
      (= (mop-current) (surface-mop-priority ?s))
    )
    :effect (and
      (sanitized ?s)
      (not (unsanitized ?s))
      (not (undamaged ?s))
      (used-harsh-chem)
      (assign (mop-current) (+ (mop-current) 1))
    )
  )

  (:action collect_trash
    :parameters (?b - bin ?bag - bag)
    :precondition (and 
      (trash-full ?b)
      (= (procedure-number) (trash-step-priority))
    )
    :effect (and
      (not (trash-full ?b))
      (trash-not-full ?b)
    )
  )

  (:action take_out_trash
    :parameters (?b - bin ?bag - bag)
    :precondition (and 
      (trash-not-full ?b)
      (= (procedure-number) (trash-step-priority))
    )
    :effect (and
      (trash-out ?b)
      ; (increase (total-cost) 2)
    )
  )

  (:action spray_airfreshener
    :parameters ()
    :precondition (and
      (= (procedure-number) (airfresh-step-priority))
    )
    :effect (and
      (pleasant-smell)
      ; (increase (total-cost) 1)
    )
  )

  (:action next_procedure
    :parameters ()
    :precondition (and )
    :effect (and 
      (assign (procedure-number) (+ (procedure-number) 1))
    )
  )

  (:action skip_surface
    :parameters ()
    :precondition (and 
      (= (procedure-number) (mop-step-priority))
    )
    :effect (and 
      (assign (mop-current) (+ (mop-current) 1))
    )
  )

  (:action skip_room
    :parameters ()
    :precondition (and 
      (= (procedure-number) (vacuum-step-priority))
    )
    :effect (and 
      (assign (vacuum-current) (+ (vacuum-current) 1))
    )
  )
)
