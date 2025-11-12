(define (problem overcooked-fixed-expert)
    (:domain overcooked-fixed-expert)
    (:objects
        p1 - player
        start_loc loc0 loc1 loc2 loc3 loc4 loc5 loc6 loc7 - location
        onion_d1 - onion_dispenser
        dish_d1 - dish_dispenser
        tomato_d1 - tomato_dispenser
        pot1 - pot
        serve_c1 - serve_counter
        waste_b1 - waste
        door1 - door
        ; counter1 - counter
    )
    (:init
        (at p1 start_loc)
        (is_not_holding p1)

        ; (located_at counter1 loc0)
        (located_at onion_d1 loc1)
        (located_at pot1 loc2)
        (located_at dish_d1 loc3)
        (located_at tomato_d1 loc4)
        (located_at serve_c1 loc5)
        (located_at waste_b1 loc6)
        (located_at door1 loc7)

        (is_not_cooking pot1)
        (is_soup_unfinished pot1)

        (is_not_prev_action_move)

        (= (total-cost) 0)
        (= (n-ingredients-in-pot pot1) 0)
        (= (n-onions-in-pot pot1) 0)
        (= (n-tomatoes-in-pot pot1) 0)
        (= (cooking-count pot1) 0)
        (= (recipe-n-onions) 1)
        (= (recipe-n-tomatoes) 1)

        (= (n-free-counters) 5)
        (= (n-onions-on-counter) 0)

        (= (current-phase) 1)
        (= (onion-phase) 1)
        (= (tomato-phase) 2)
        (= (cook-phase) 3)
        (= (serve-phase) 4)
    )
    
    (:goal (and
        (preference correct_soup_cooked (correct_soup_cooked))
        (preference some_soup_cooked (soup_cooked))
        (preference correct_soup_served (correct_soup_served))
        (preference some_soup_served (soup_served))
        (preference attempt_onion_pickup (attempt_pickup_onion))
        (preference attempt_tomato_pickup (attempt_pickup_tomato))
        (preference attempt_add_onion (attempt_add_onion))
        (preference attempt_add_tomato (attempt_add_tomato))
        (preference attempt_dish_pickup (attempt_pickup_dish))
        (preference attempt_soup_pickup (attempt_pickup_soup))
        (preference attempt_door_open (attempt_door_open))
        (preference took_efficient_path (took_efficient_path))
    ))

    (:metric minimize (+
        (total-cost)
        (is-violated attempt_onion_pickup)
        (is-violated attempt_door_open)
        (is-violated took_efficient_path)
        (is-violated attempt_tomato_pickup)
        (is-violated attempt_add_onion)
        (is-violated attempt_add_tomato)
        (is-violated attempt_dish_pickup)
        (is-violated attempt_soup_pickup)
        (is-violated correct_soup_cooked)
        (is-violated some_soup_cooked)
        (is-violated correct_soup_served)
        (is-violated some_soup_served)  
    ))
)