(define (domain overcooked-0-expert)
    (:requirements :strips :typing :preferences :action-costs)
    (:types
        location player interactable - object
        onion_dispenser tomato_dispenser dish_dispenser pot serve_counter counter - interactable
    )

    (:functions
        (total-cost)
        
        (n-ingredients-in-pot ?pot - pot)
        (n-onions-in-pot ?pot - pot)
        (n-tomatoes-in-pot ?pot - pot)
        (cooking-count ?pot - pot)
        
        (recipe-n-onions)
        (recipe-n-tomatoes)
        
        (n-free-counters)
        (n-onions-on-counter)
    )

    (:predicates
        ; player
        (at ?p - player ?l - location)
        (holding_onion ?p - player)
        (holding_tomato ?p - player)
        (holding_dish ?p - player)
        (holding_correct_soup ?p - player)
        (holding_wrong_soup ?p - player)
        (is_holding ?p - player)
        (is_not_holding ?p - player)

        ; Object Locations
        (located_at ?i - interactable ?l - location)

        ; Pot and Soup
        (is_cooking ?pot - pot)
        (is_not_cooking ?pot - pot)
        (correct_soup_ready ?pot - pot)
        (wrong_soup_ready ?pot - pot)

        ; Task
        (correct_soup_served)
        (wrong_soup_served)
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
            (increase (total-cost) 0)
        )
    )

    ;;; Pick up Items from Dispenser
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

    (:action pickup_tomato_from_dispenser
        :parameters (?p - player ?l - location ?d - tomato_dispenser)
        :precondition (and 
            (at ?p ?l)
            (located_at ?d ?l)
            (is_not_holding ?p)
        )
        :effect (and 
            (is_holding ?p)
            (not (is_not_holding ?p))
            (holding_tomato ?p)
        )
    )

    (:action pickup_dish_from_dispenser
        :parameters (?p - player ?l - location ?d - dish_dispenser)
        :precondition (and 
            (at ?p ?l)
            (located_at ?d ?l)
            (is_not_holding ?p)
        )
        :effect (and 
            (is_holding ?p)
            (not (is_not_holding ?p))
            (holding_dish ?p)
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
            (increase (n-ingredients-in-pot ?pot) 1)
            (increase (n-onions-in-pot ?pot) 1)
        )
    )

    (:action place_tomato_in_pot
        :parameters (?p - player ?l - location ?pot - pot)
        :precondition (and 
            (at ?p ?l)
            (located_at ?pot ?l)
            (holding_tomato ?p)
            (is_not_cooking ?pot)
        )
        :effect (and 
            (not (holding_tomato ?p))
            (not (is_holding ?p))
            (is_not_holding ?p)
            (increase (n-ingredients-in-pot ?pot) 1)
            (increase (n-tomatoes-in-pot ?pot) 1)
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
            ; (assign (cooking-count ?pot) (+ (cooking-count ?pot) 1))
            (increase (cooking-count ?pot) 1)
            (is_cooking ?pot)
            (not (is_not_cooking ?pot))
        )
    )
    ; cooked correct soup defined in recipe
    (:action finished_cooking_correct_recipe
        :parameters (?p - player ?l - location ?pot - pot)
        :precondition (and 
            (at ?p ?l)
            (located_at ?pot ?l)
            (= (cooking-count ?pot) (n-ingredients-in-pot ?pot))
            (= (n-onions-in-pot ?pot) (recipe-n-onions))
            (= (n-tomatoes-in-pot ?pot) (recipe-n-tomatoes))
            (is_not_holding ?p)
            (is_cooking ?pot)
        )
        :effect (and 
            (assign (n-ingredients-in-pot ?pot) 0)
            (assign (n-onions-in-pot ?pot) 0)
            (assign (n-tomatoes-in-pot ?pot) 0)
            (assign (cooking-count ?pot) 0)
            (correct_soup_ready ?pot)
        )
    )
    ; wrong soup that doesn't match the recipe
    (:action finished_cooking_wrong_recipe
        :parameters (?p - player ?l - location ?pot - pot)
        :precondition (and 
            (at ?p ?l)
            (located_at ?pot ?l)
            (= (cooking-count ?pot) (n-ingredients-in-pot ?pot))
            (is_not_holding ?p)
            (is_cooking ?pot)
        )
        :effect (and 
            (assign (n-ingredients-in-pot ?pot) 0)
            (assign (n-onions-in-pot ?pot) 0)
            (assign (n-tomatoes-in-pot ?pot) 0)
            (assign (cooking-count ?pot) 0)
            (wrong_soup_ready ?pot)
        )
    )

    ;;; Pick up Soup
    (:action pickup_correct_soup
        :parameters (?p - player ?l - location ?pot - pot)
        :precondition (and 
            (at ?p ?l)
            (located_at ?pot ?l)
            (correct_soup_ready ?pot)
            (holding_dish ?p)
        )
        :effect (and 
            (not (holding_dish ?p))
            (holding_correct_soup ?p)
            (not (correct_soup_ready ?pot))
            (not (is_cooking ?pot))
            (is_not_cooking ?pot)
        )
    )
    
    (:action pickup_wrong_soup
        :parameters (?p - player ?l - location ?pot - pot)
        :precondition (and 
            (at ?p ?l)
            (located_at ?pot ?l)
            (wrong_soup_ready ?pot)
            (holding_dish ?p)
        )
        :effect (and 
            (not (holding_dish ?p))
            (holding_wrong_soup ?p)
            (not (wrong_soup_ready ?pot))
            (not (is_cooking ?pot))
            (is_not_cooking ?pot)
        )
    )

    ;;; Serve
    (:action serve_correct_soup
        :parameters (?p - player ?l - location ?s - serve_counter)
        :precondition (and 
            (at ?p ?l)
            (located_at ?s ?l)
            (holding_correct_soup ?p)
        )
        :effect (and 
            (not (is_holding ?p))
            (not (holding_correct_soup ?p))
            (is_not_holding ?p)
            (correct_soup_served)
        )
    )

    (:action serve_wrong_soup
        :parameters (?p - player ?l - location ?s - serve_counter)
        :precondition (and 
            (at ?p ?l)
            (located_at ?s ?l)
            (holding_wrong_soup ?p)
        )
        :effect (and 
            (not (is_holding ?p))
            (not (holding_wrong_soup ?p))
            (is_not_holding ?p)
            (wrong_soup_served)
        )
    )
    

    ;;; Place on Counter
    (:action place_onion_on_counter
        :parameters (?p - player ?l - location ?c - counter)
        :precondition (and 
            (at ?p ?l)
            (located_at ?c ?l)
            (holding_onion ?p)
            (> (n-free-counters ) 0)
        )
        :effect (and 
            (not (holding_onion ?p))
            (not (is_holding ?p))
            (is_not_holding ?p)
            (decrease (n-free-counters) 1)
            (increase (n-onions-on-counter) 1)
        )
    )
    
)   