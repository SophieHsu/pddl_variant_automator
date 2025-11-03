(define (domain overcooked-0-expert)
    (:requirements :strips :typing :preferences :action-costs)
    (:types
        location player interactable - object
        onion_dispenser pot - interactable
    )

    (:functions
        (total-cost)
        (current-phase)
        (n-ingredients-in-pot ?pot - pot)
        (n-onions-in-pot ?pot - pot)
        (cooking-count ?pot - pot)
        (recipe-n-onions)
    )

    (:predicates
        ; player
        (at ?p - player ?l - location)
        (holding_onion ?p - player)
        (is_holding ?p - player)
        (is_not_holding ?p - player)

        ; Object Locations
        (located_at ?i - interactable ?l - location)

        ; Pot and Soup
        (is_cooking ?pot - pot)
        (is_not_cooking ?pot - pot)
        (correct_soup_ready ?pot - pot)
    )

    ;;; Move-to Actions
    (:action move_to
        :parameters (?p - player ?from - location ?to - location)
        :precondition (and
            (at ?p ?from)
        )
        :effect (and
            (not (at ?p ?from))
            (at ?p ?to)
        )
    )

    ;;; Pick up Items
    (:action pickup_onion_from_dispenser
        :parameters (?p - player ?l - location ?d - onion_dispenser)
        :precondition (and 
            (at ?p ?l)
            (located_at ?d ?l)
            (is_not_holding ?p)
        )
        :effect (and 
            (is_holding ?p)
            (not (is_not_holding ?p))
            (holding_onion ?p)
        )
    )

    ;;; Pot Items
    (:action place_onion_in_pot
        :parameters (?p - player ?l - location ?pot - pot)
        :precondition (and 
            (at ?p ?l)
            (located_at ?pot ?l)
            (holding_onion ?p)
            (is_not_cooking ?pot)
        )
        :effect (and 
            (not (holding_onion ?p))
            (not (is_holding ?p))
            (is_not_holding ?p)
            (assign (n-ingredients-in-pot ?pot) (+ (n-ingredients-in-pot ?pot) 1))
            (assign (n-onions-in-pot ?pot) (+ (n-onions-in-pot ?pot) 1))
        )
    )

    ;;; Cook
    (:action cook_soup
        :parameters (?p - player ?l - location ?pot - pot)
        :precondition (and 
            (at ?p ?l)
            (located_at ?pot ?l)
            (is_not_holding ?p)
            (> (n-ingredients-in-pot ?pot) 0)
            (< (cooking-count ?pot) (n-ingredients-in-pot ?pot))
        )
        :effect (and 
            (assign (cooking-count ?pot) (+ (cooking-count ?pot) 1))
            (is_cooking ?pot)
            (not (is_not_cooking ?pot))
        )
    )
    ; cooked correct soup defined in recipe
    (:action finished_cooking_recipe
        :parameters (?p - player ?l - location ?pot - pot)
        :precondition (and 
            (= (cooking-count ?pot) (n-ingredients-in-pot ?pot))
            (= (n-onions-in-pot ?pot) (recipe-n-onions))
            (is_not_holding ?p)
            (is_cooking ?pot)
        )
        :effect (and 
            (assign (n-ingredients-in-pot ?pot) 0)
            (assign (n-onions-in-pot ?pot) 0)
            (correct_soup_ready ?pot)
        )
    )
)   






; (define (domain overcooked-0-expert)
;     (:requirements :strips :typing :preferences :action-costs)
;     (:types
;         location player - object
;         onion_dispenser - location
;     )

;     (:functions
;         (total-cost)
;         (current-phase)
;         (n-onions-on-counter)
;         (n-tomatoes-on-counter)
;         (n-dishes-on-counter)
;         (n-soups-on-counter)
;         (n-ingredients-in-pot ?pot - pot)
;         (n-onions-in-pot ?pot - pot)
;         (n-tomatoes-in-pot ?pot - pot)
;         (n-total-counters)
;         (n-occupied-counters)
;     )

;     (:predicates
;         ; player
;         (at ?p - player ?l - location)
;         (is_at_counter_w_onion ?p - player)
;         (is_at_counter_w_tomato ?p - player)
;         (is_at_counter_w_dish ?p - player)
;         (is_at_counter_w_soup ?p - player)
;         (is_at_onion_dispenser ?p - player)
;         (is_at_tomato_dispenser ?p - player)
;         (is_at_dish_dispenser ?p - player)
;         (is_at_pot ?p - player)
;         (is_at_serve_point ?p - player)

;         (holding_onion ?p - player)
;         (holding_tomato ?p - player)
;         (holding_dish ?p - player)
;         (holding_soup ?p - player)
;         (is_holding ?p - player)
;         (is_not_holding ?p - player)

;         ; pot
;         (pot_full ?pot - pot)
;     )

;     ;;; Move-to Actions
;     (:action move_to_onion_dispenser
;         :parameters (?p - player ?from - location ?to - onion_dispenser)
;         :precondition (and
;             (at ?p ?from)
;         )
;         :effect (and
;             (not (at ?p ?from))
;             (at ?p ?to)
;             (not (is_at_counter_w_onion ?p))
;             (not (is_at_counter_w_tomato ?p))
;             (not (is_at_counter_w_dish ?p))
;             (not (is_at_counter_w_soup ?p))
;             (is_at_onion_dispenser ?p)
;             (not (is_at_tomato_dispenser ?p))
;             (not (is_at_dish_dispenser ?p))
;             (not (is_at_pot ?p))
;             (not (is_at_serve_point ?p))
;         )
;     )

;     ;;; Pick up Items
;     (:action pickup_onion_from_dispenser
;         :parameters (?p - player)
;         :precondition (and 
;             (is_at_onion_dispenser ?p)
;             (is_not_holding ?p)
;         )
;         :effect (and 
;             (is_holding ?p)
;             (holding_onion ?p)
;         )
;     )

;     ;;; Place Item in Pot
;     (:action place_onion_in_pot
;         :parameters (?p - player ?pot - pot)
;         :precondition (and 
;             (is_at_pot ?p)
;             (holding_onion ?p)
;         )
;         :effect (and 
;             (not (holding_onion ?p))
;             (not (is_holding ?p))
;             (is_not_holding ?p)
;             (assign (n-ingredients-in-pot ?pot) (+ (n-ingredients-in-pot ?pot) 1))
;             (assign (n-onions-in-pot ?pot) (+ (n-onions-in-pot ?pot) 1))
;         )
;     )
; )


