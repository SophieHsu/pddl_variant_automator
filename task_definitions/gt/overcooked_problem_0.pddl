(define (problem p1)
    (:domain overcooked-0-expert)
    (:objects
        p1 - player
        start_loc loc1 loc2 - location
        onion_d1 - onion_dispenser
        pot1 - pot
    )
    (:init
        (at p1 start_loc)
        (is_not_holding p1)

        (located_at onion_d1 loc1)
        (located_at pot1 loc2)

        (is_not_cooking pot1)

        (= (total-cost) 0)
        (= (current-phase) 0)
        (= (n-ingredients-in-pot pot1) 0)
        (= (n-onions-in-pot pot1) 0)
        (= (cooking-count pot1) 0)
        (= (recipe-n-onions) 1)
    )
    
    (:goal (and
        (preference p1_at_pot (at p1 loc2))
        (preference p1_holding_onion (holding_onion p1))
        (preference onion_in_pot (= (n-onions-in-pot pot1) 1))
        (preference correct_soup_cooked (correct_soup_ready pot1))
    ))

    (:metric minimize (+
        (total-cost)
        ; (is-violated p1_holding_onion)
        ; (is-violated p1_at_pot)
        ; (is-violated onion_in_pot)
        (is-violated correct_soup_cooked)
    ))
)





; (define (problem p1)
;     (:domain overcooked-0-expert)
;     (:objects
;         p1 - player
;         start_loc - location
;         onion_d1 - onion_dispenser
;         pot1 - pot
;     )
;     (:init
;         ; (at p1 start_loc)
;         ; (is_not_holding p1)

;         (at p1 pot1)
;         (is_at_pot p1)
;         (holding_onion p1)

;         (= (total-cost) 0)
;         (= (current-phase) 0)
;         (= (n-onions-on-counter) 0)
;         (= (n-tomatoes-on-counter) 0)
;         (= (n-soups-on-counter) 0)
;         (= (n-ingredients-in-pot pot1) 0)
;         (= (n-onions-in-pot pot1) 0)
;         (= (n-total-counters) 5)
;         (= (n-occupied-counters) 0)
;     )
    
;     (:goal (and
;         (preference p1_at_onion_dispenser (is_at_onion_dispenser p1))
;         (preference p1_at_pot (is_at_pot p1))
;         (preference p1_holding_onion (holding_onion p1))
;         (preference onion-in-pot (= (n-onions-in-pot pot1) 1))
;     ))

;     (:metric minimize (+
;         (total-cost)
;         (is-violated p1_at_onion_dispenser)
;         ; (is-violated p1_holding_onion)
;         ; (is-violated p1_at_pot)
;         ; (is-violated onion-in-pot)
;     ))

; )

