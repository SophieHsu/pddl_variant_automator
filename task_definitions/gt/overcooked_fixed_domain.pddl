(define (domain overcooked-fixed-expert)
    (:requirements :strips :typing :preferences :action-costs)
    (:types
        location player interactable - object
        onion_dispenser tomato_dispenser dish_dispenser pot serve_counter door waste - interactable
    )

    (:functions
        (total-cost)
        (current-phase)
        (onion-phase)
        (tomato-phase)
        (cook-phase)
        (serve-phase)
        
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
        ; Player
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
        (is_soup_unfinished ?pot - pot)
        (correct_soup_ready ?pot - pot)
        (wrong_soup_ready ?pot - pot)

        ; Door
        (is_door_open ?d - door)

        ; Task
        (correct_soup_cooked)
        (soup_cooked)
        (correct_soup_served)
        (soup_served)
        (attempt_pickup_onion)
        (attempt_pickup_tomato)
        (attempt_pickup_dish)
        (attempt_add_onion)
        (attempt_add_tomato)
        (attempt_pickup_soup)
        (attempt_serve_soup)
        (attempt_door_open)
        (took_efficient_path)

        ; Prevent Extra Moving
        (is_not_prev_action_move)
    )

    ;;; Move-to Actions
    (:action move_to_onion_dispenser
        :parameters (?p - player ?from - location ?to - location ?d - onion_dispenser)
        :precondition (and
            (= (current-phase) (onion-phase))
            (is_not_prev_action_move)
            (at ?p ?from)
            (located_at ?d ?to)
        )
        :effect (and
            (not (at ?p ?from))
            (at ?p ?to)
            (not (is_not_prev_action_move))
        )
    )

    ; (:action move_to_tomato_dispenser
    ;     :parameters (?p - player ?from - location ?to - location ?d - tomato_dispenser)
    ;     :precondition (and 
    ;         (= (current-phase) (tomato-phase))
    ;         (is_not_prev_action_move)
    ;         (at ?p ?from)
    ;         (located_at ?d ?to)
    ;     )
    ;     :effect (and 
    ;         (not (at ?p ?from))
    ;         (at ?p ?to)
    ;         (not (is_not_prev_action_move))
    ;     )
    ; )
    (:action move_to_tomato_dispenser_long
        :parameters (?p - player ?from - location ?to - location ?d - tomato_dispenser)
        :precondition (and 
            (= (current-phase) (tomato-phase))
            (is_not_prev_action_move)
            (at ?p ?from)
            (located_at ?d ?to)
        )
        :effect (and 
            (not (at ?p ?from))
            (at ?p ?to)
            (not (is_not_prev_action_move))
            (increase (total-cost) 1)
        )
    )
    
    (:action move_to_tomato_dispenser_short
        :parameters (?p - player ?from - location ?to - location ?d - tomato_dispenser ?door - door)
        :precondition (and 
            (= (current-phase) (tomato-phase))
            (is_not_prev_action_move)
            (at ?p ?from)
            (located_at ?d ?to)
            (is_door_open ?door)
        )
        :effect (and 
            (not (at ?p ?from))
            (at ?p ?to)
            (not (is_not_prev_action_move))
            (took_efficient_path)
        )
    )

    (:action move_to_dish_dispenser
        :parameters (?p - player ?from - location ?to - location ?d - dish_dispenser)
        :precondition (and 
            (= (current-phase) (serve-phase))
            (is_not_prev_action_move)
            (at ?p ?from)
            (located_at ?d ?to)
        )
        :effect (and 
            (not (at ?p ?from))
            (at ?p ?to)
            (not (is_not_prev_action_move))
        )
    )

    (:action move_to_pot_onion_phase
        :parameters (?p - player ?from - location ?to - location ?pot - pot)
        :precondition (and 
            (= (current-phase) (onion-phase))
            (is_not_prev_action_move)
            (at ?p ?from)
            (located_at ?pot ?to)
        )
        :effect (and 
            (not (at ?p ?from))
            (at ?p ?to)
            (not (is_not_prev_action_move))
        )
    )

    (:action move_to_pot_tomato_phase
        :parameters (?p - player ?from - location ?to - location ?pot - pot)
        :precondition (and 
            (= (current-phase) (tomato-phase))
            (is_not_prev_action_move)
            (at ?p ?from)
            (located_at ?pot ?to)
        )
        :effect (and 
            (not (at ?p ?from))
            (at ?p ?to)
            (not (is_not_prev_action_move))
        )
    )

    (:action move_to_pot_serve_phase
        :parameters (?p - player ?from - location ?to - location ?pot - pot)
        :precondition (and 
            (= (current-phase) (serve-phase))
            (is_not_prev_action_move)
            (at ?p ?from)
            (located_at ?pot ?to)
        )
        :effect (and 
            (not (at ?p ?from))
            (at ?p ?to)
            (not (is_not_prev_action_move))
        )
    )

    (:action move_to_serve_counter
        :parameters (?p - player ?from - location ?to - location ?c - serve_counter)
        :precondition (and 
            (= (current-phase) (serve-phase))
            (is_not_prev_action_move)
            (at ?p ?from)
            (located_at ?c ?to)
        )
        :effect (and 
            (not (at ?p ?from))
            (at ?p ?to)
            (not (is_not_prev_action_move))
        )
    )

    (:action move_to_door
        :parameters (?p - player ?from - location ?to - location ?door - door)
        :precondition (and 
            (= (current-phase) (tomato-phase))
            (is_not_prev_action_move)
            (at ?p ?from)
            (located_at ?door ?to)
        )
        :effect (and 
            (not (at ?p ?from))
            (at ?p ?to)
            (not (is_not_prev_action_move))
        )
    )
    
    

    ;;; Pick up Items from Dispenser
    (:action pickup_onion_from_dispenser
        :parameters (?p - player ?l - location ?d - onion_dispenser)
        :precondition (and 
            (= (current-phase) (onion-phase))
            (at ?p ?l)
            (located_at ?d ?l)
            (is_not_holding ?p)
        )
        :effect (and 
            (is_holding ?p)
            (not (is_not_holding ?p))
            (holding_onion ?p)
            (attempt_pickup_onion)
            (is_not_prev_action_move)
        )
    )

    (:action pickup_tomato_from_dispenser
        :parameters (?p - player ?l - location ?d - tomato_dispenser)
        :precondition (and 
            (= (current-phase) (tomato-phase))
            (at ?p ?l)
            (located_at ?d ?l)
            (is_not_holding ?p)
        )
        :effect (and 
            (is_holding ?p)
            (not (is_not_holding ?p))
            (holding_tomato ?p)
            (attempt_pickup_tomato)
            (is_not_prev_action_move)
        )
    )

    (:action pickup_dish_from_dispenser
        :parameters (?p - player ?l - location ?d - dish_dispenser)
        :precondition (and 
            (= (current-phase) (serve-phase))
            (at ?p ?l)
            (located_at ?d ?l)
            (is_not_holding ?p)
        )
        :effect (and 
            (is_holding ?p)
            (not (is_not_holding ?p))
            (holding_dish ?p)
            (attempt_pickup_dish)
            (is_not_prev_action_move)
        )
    )

    (:action attempt_pickup_onion_from_dispenser
        :parameters (?p - player ?l - location ?d - onion_dispenser)
        :precondition (and 
            (= (current-phase) (onion-phase))
            (at ?p ?l)
            (located_at ?d ?l)
            (is_not_holding ?p)
        )
        :effect (and 
            (is_not_prev_action_move)
            (attempt_pickup_onion)
        )
    )

    (:action attempt_pickup_tomato_from_dispenser
        :parameters (?p - player ?l - location ?d - tomato_dispenser)
        :precondition (and 
            (= (current-phase) (tomato-phase))
            (at ?p ?l)
            (located_at ?d ?l)
            (is_not_holding ?p)
        )
        :effect (and 
            (is_not_prev_action_move)
            (attempt_pickup_tomato)
        )
    )
    
    (:action attempt_pickup_dish_from_dispenser
        :parameters (?p - player ?l - location ?d - dish_dispenser)
        :precondition (and 
            (= (current-phase) (serve-phase))
            (at ?p ?l)
            (located_at ?d ?l)
            (is_not_holding ?p)
        )
        :effect (and 
            (is_not_prev_action_move)
            (attempt_pickup_dish)
        )
    )

    ;;; Pot Items
    (:action place_onion_in_pot
        :parameters (?p - player ?l - location ?pot - pot)
        :precondition (and 
            (= (current-phase) (onion-phase))
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
            (attempt_add_onion)
            (is_not_prev_action_move)
        )
    )

    (:action place_tomato_in_pot
        :parameters (?p - player ?l - location ?pot - pot)
        :precondition (and 
            (= (current-phase) (tomato-phase))
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
            (attempt_add_tomato)
            (is_not_prev_action_move)
        )
    )

    (:action attempt_place_onion_in_pot
        :parameters (?p - player ?l - location ?pot - pot)
        :precondition (and 
            (= (current-phase) (onion-phase))
            (at ?p ?l)
            (located_at ?pot ?l)
            (holding_onion ?p)
            (is_not_cooking ?pot)
        )
        :effect (and 
            (attempt_add_onion)
            (is_not_prev_action_move)
        )
    )

    (:action attempt_place_tomato_in_pot
        :parameters (?p - player ?l - location ?pot - pot)
        :precondition (and 
            (= (current-phase) (tomato-phase))
            (at ?p ?l)
            (located_at ?pot ?l)
            (holding_tomato ?p)
            (is_not_cooking ?pot)
        )
        :effect (and 
            (attempt_add_tomato)
            (is_not_prev_action_move)
        )
    )

    ;;; Cook
    (:action cook_soup
        :parameters (?p - player ?l - location ?pot - pot)
        :precondition (and 
            (= (current-phase) (cook-phase))
            (at ?p ?l)
            (located_at ?pot ?l)
            (is_not_holding ?p)
            (> (n-ingredients-in-pot ?pot) 0)
            (< (cooking-count ?pot) (n-ingredients-in-pot ?pot))
        )
        :effect (and 
            (increase (cooking-count ?pot) 1)
            (is_cooking ?pot)
            (not (is_not_cooking ?pot))
            (is_not_prev_action_move)
        )
    )
    ; cooked correct soup defined in recipe
    (:action finished_cooking_correct_recipe
        :parameters (?p - player ?l - location ?pot - pot)
        :precondition (and 
            (= (current-phase) (cook-phase))
            (at ?p ?l)
            (located_at ?pot ?l)
            (= (cooking-count ?pot) (n-ingredients-in-pot ?pot))
            (= (n-onions-in-pot ?pot) (recipe-n-onions))
            (= (n-tomatoes-in-pot ?pot) (recipe-n-tomatoes))
            (is_not_holding ?p)
            (is_cooking ?pot)
            (is_soup_unfinished ?pot)
        )
        :effect (and 
            (assign (n-ingredients-in-pot ?pot) 0)
            (assign (n-onions-in-pot ?pot) 0)
            (assign (n-tomatoes-in-pot ?pot) 0)
            (assign (cooking-count ?pot) 0)
            (correct_soup_ready ?pot)
            (not (is_soup_unfinished ?pot))
            (correct_soup_cooked)
            (soup_cooked)
            (is_not_prev_action_move)
        )
    )
    ; wrong soup that doesn't match the recipe
    (:action finished_cooking_wrong_recipe
        :parameters (?p - player ?l - location ?pot - pot)
        :precondition (and 
            (= (current-phase) (cook-phase))
            (at ?p ?l)
            (located_at ?pot ?l)
            (= (cooking-count ?pot) (n-ingredients-in-pot ?pot))
            (is_not_holding ?p)
            (is_cooking ?pot)
            (is_soup_unfinished ?pot)
        )
        :effect (and 
            (assign (n-ingredients-in-pot ?pot) 0)
            (assign (n-onions-in-pot ?pot) 0)
            (assign (n-tomatoes-in-pot ?pot) 0)
            (assign (cooking-count ?pot) 0)
            (wrong_soup_ready ?pot)
            (not (is_soup_unfinished ?pot))
            (soup_cooked)
            (is_not_prev_action_move)
        )
    )

    ;;; Pick up Soup
    (:action pickup_correct_soup
        :parameters (?p - player ?l - location ?pot - pot)
        :precondition (and 
            (= (current-phase) (serve-phase))
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
            (is_soup_unfinished ?pot)
            (attempt_pickup_soup)
            (is_not_prev_action_move)
        )
    )
    
    (:action pickup_wrong_soup
        :parameters (?p - player ?l - location ?pot - pot)
        :precondition (and 
            (= (current-phase) (serve-phase))
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
            (is_soup_unfinished ?pot)
            (attempt_pickup_soup)
            (is_not_prev_action_move)
        )
    )

    (:action attempt_pickup_correct_soup
        :parameters (?p - player ?l - location ?pot - pot)
        :precondition (and 
            (= (current-phase) (serve-phase))
            (at ?p ?l)
            (located_at ?pot ?l)
            (correct_soup_ready ?pot)
            (holding_dish ?p)
        )
        :effect (and 
            (attempt_pickup_soup)
            (is_not_prev_action_move)           
        )
    )
    
    (:action attempt_pickup_wrong_soup
        :parameters (?p - player ?l - location ?pot - pot)
        :precondition (and 
            (= (current-phase) (serve-phase))
            (at ?p ?l)
            (located_at ?pot ?l)
            (wrong_soup_ready ?pot)
            (holding_dish ?p)
        )
        :effect (and 
            (attempt_pickup_soup)
            (is_not_prev_action_move)           
        )
    )

    ;;; Serve
    (:action serve_correct_soup
        :parameters (?p - player ?l - location ?s - serve_counter)
        :precondition (and 
            (= (current-phase) (serve-phase))
            (at ?p ?l)
            (located_at ?s ?l)
            (holding_correct_soup ?p)
        )
        :effect (and 
            (not (is_holding ?p))
            (not (holding_correct_soup ?p))
            (is_not_holding ?p)
            (correct_soup_served)
            (soup_served)
            (is_not_prev_action_move)
        )
    )

    (:action serve_wrong_soup
        :parameters (?p - player ?l - location ?s - serve_counter)
        :precondition (and 
            (= (current-phase) (serve-phase))
            (at ?p ?l)
            (located_at ?s ?l)
            (holding_wrong_soup ?p)
        )
        :effect (and 
            (not (is_holding ?p))
            (not (holding_wrong_soup ?p))
            (is_not_holding ?p)
            ; (wrong_soup_served)
            (soup_served)
            (is_not_prev_action_move)
        )
    )

    (:action attempt_serve_correct_soup
        :parameters (?p - player ?l - location ?s - serve_counter)
        :precondition (and 
            (= (current-phase) (serve-phase))
            (at ?p ?l)
            (located_at ?s ?l)
            (holding_correct_soup ?p)
        )
        :effect (and 
            (attempt_serve_soup)
            (is_not_prev_action_move)
        )
    )

    (:action attempt_serve_wrong_soup
        :parameters (?p - player ?l - location ?s - serve_counter)
        :precondition (and 
            (= (current-phase) (serve-phase))
            (at ?p ?l)
            (located_at ?s ?l)
            (holding_wrong_soup ?p)
        )
        :effect (and 
            (attempt_serve_soup)
            (is_not_prev_action_move)
        )
    )

    ;;; Door
    (:action open_door
        :parameters (?p - player ?l - location ?d - door)
        :precondition (and 
            (= (current-phase) (tomato-phase))
            (at ?p ?l)
            (located_at ?d ?l)
        )
        :effect (and 
            (is_door_open ?d)
            (attempt_door_open)
            (is_not_prev_action_move)
        )
    )

    (:action attempt_open_door
        :parameters (?p - player ?l - location ?d - door)
        :precondition (and 
            (= (current-phase) (tomato-phase))
            (at ?p ?l)
            (located_at ?d ?l)
        )
        :effect (and 
            (attempt_door_open)
            (is_not_prev_action_move)
        )
    )

    ; ;;; Place on Counter
    ; (:action place_onion_on_counter
    ;     :parameters (?p - player ?l - location ?c - counter)
    ;     :precondition (and 
    ;         (at ?p ?l)
    ;         (located_at ?c ?l)
    ;         (holding_onion ?p)
    ;         (> (n-free-counters ) 0)
    ;     )
    ;     :effect (and 
    ;         (not (holding_onion ?p))
    ;         (not (is_holding ?p))
    ;         (is_not_holding ?p)
    ;         (decrease (n-free-counters) 1)
    ;         (increase (n-onions-on-counter) 1)
    ;         (is_not_prev_action_move)
    ;     )
    ; )    

    ;;; To Next Phase
    (:action to_next_phase
        :parameters ()
        :precondition (and )
        :effect (and 
            (increase (current-phase) 1)
            (is_not_prev_action_move)
        )
    )
)