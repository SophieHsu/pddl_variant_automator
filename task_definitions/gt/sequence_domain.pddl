(define (domain sequence-expert)
	(:requirements :strips :typing :preferences :action-costs)
	(:types
        item - object
	)

    (:functions
        (total-cost)
        (task-stage)
        (task-order ?i - item)
    )

    (:predicates
        (action1-done)
        (action2-done)
        (action3-done)
        (action4-done)
        (action5-done)
        (action6-done)
        (action7-done)
        (action8-done)
        (action9-done)
        (action10-done)
    )

    (:action action1
        :parameters (?i - item)
        :precondition (and 
            (= (task-stage) 1)
            (= (task-stage) (task-order ?i))
        )
        :effect (and
            (action1-done)
            (assign (task-stage) (+ (task-stage) 1))
        )
    )

    (:action action2
        :parameters (?i - item)
        :precondition (and 
            (= (task-stage) 2)
            (= (task-stage) (task-order ?i))
        )
        :effect (and
            (action2-done)
            (assign (task-stage) (+ (task-stage) 1))
        )
    )

    (:action action3
        :parameters (?i - item)
        :precondition (and 
            (= (task-stage) 3)
            (= (task-stage) (task-order ?i))
        )
        :effect (and
            (action3-done)
            (assign (task-stage) (+ (task-stage) 1))
        )
    )

    (:action action4
        :parameters (?i - item)
        :precondition (and 
            (= (task-stage) 4)
            (= (task-stage) (task-order ?i))
        )
        :effect (and
            (action4-done)
            (assign (task-stage) (+ (task-stage) 1))
        )
    )

    (:action action5
        :parameters (?i - item)
        :precondition (and 
            (= (task-stage) 5)
            (= (task-stage) (task-order ?i))
        )
        :effect (and
            (action5-done)
            (assign (task-stage) (+ (task-stage) 1))
        )
    )

    (:action action6
        :parameters (?i - item)
        :precondition (and 
            (= (task-stage) 6)
            (= (task-stage) (task-order ?i))
        )
        :effect (and
            (action6-done)
            (assign (task-stage) (+ (task-stage) 1))
        )
    )

    (:action action7
        :parameters (?i - item)
        :precondition (and 
            (= (task-stage) 7)
            (= (task-stage) (task-order ?i))
        )
        :effect (and
            (action7-done)
            (assign (task-stage) (+ (task-stage) 1))
        )
    )

    (:action action8
        :parameters (?i - item)
        :precondition (and 
            (= (task-stage) 8)
            (= (task-stage) (task-order ?i))
        )
        :effect (and
            (action8-done)
            (assign (task-stage) (+ (task-stage) 1))
        )
    )

    (:action action9
        :parameters (?i - item)
        :precondition (and 
            (= (task-stage) 9)
            (= (task-stage) (task-order ?i))
        )
        :effect (and
            (action9-done)
            (assign (task-stage) (+ (task-stage) 1))
        )
    )

    (:action action10
        :parameters (?i - item)
        :precondition (and 
            (= (task-stage) 10)
            (= (task-stage) (task-order ?i))
        )
        :effect (and
            (action10-done)
            (assign (task-stage) (+ (task-stage) 1))
        )
    )

    (:action skip_step
        :parameters ()
        :precondition (and )
        :effect (and 
            (assign (task-stage) (+ (task-stage) 1))
        )
    )
)