(define (problem overcooked-fixed-expert)
    (:domain overcooked-fixed-expert)
    (:objects
        p1 - player
        start_loc loc0 loc1 loc2 loc3 loc4 loc5 - location
        onion_d1 - onion_dispenser
        dish_d1 - dish_dispenser
        tomato_d1 - tomato_dispenser
        pot1 - pot
        serve_c1 - serve_counter
        counter1 - counter
    )
    (:init
        (at p1 start_loc)
        (is_not_holding p1)

        (located_at counter1 loc0)
        (located_at onion_d1 loc1)
        (located_at pot1 loc2)
        (located_at dish_d1 loc3)
        (located_at tomato_d1 loc4)
        (located_at serve_c1 loc5)

        (is_not_cooking pot1)

        (= (total-cost) 0)
        (= (n-ingredients-in-pot pot1) 0)
        (= (n-onions-in-pot pot1) 0)
        (= (n-tomatoes-in-pot pot1) 0)
        (= (cooking-count pot1) 0)
        (= (recipe-n-onions) 1)
        (= (recipe-n-tomatoes) 1)

        (= (n-free-counters) 5)
        (= (n-onions-on-counter) 0)

        (= (current-phase) 0)
        (= (onion-phase) 0)
        (= (tomato-phase) 1)
        (= (cook-phase) 2)
        (= (serve-phase) 3)
    )
    
    (:goal (and
        ; (preference p1_at_pot (at p1 loc2))
        ; (preference p1_holding_onion (holding_onion p1))
        ; (preference onion_in_pot (= (n-onions-in-pot pot1) 1))
        ; (preference correct_soup_cooked (correct_soup_ready pot1))
        ; (preference p1_holding_dish (holding_dish p1))
        ; (preference p1_holding_correct_soup (holding_correct_soup p1))
        (preference correct_soup_served (correct_soup_served))
        ; (preference onions_on_counter2 (= (n-onions-on-counter) 2))
    ))

    (:metric minimize (+
        (total-cost)
        ; (is-violated p1_at_pot)
        ; (is-violated p1_holding_onion)
        ; (is-violated onion_in_pot)
        ; (is-violated correct_soup_cooked)
        ; (is-violated p1_holding_dish)
        ; (is-violated p1_holding_correct_soup)
        (is-violated correct_soup_served)
        ; (is-violated onions_on_counter2)
    ))
)