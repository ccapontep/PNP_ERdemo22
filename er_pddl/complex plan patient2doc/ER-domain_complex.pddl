(define (domain ER-domain)
    (:requirements :strips)
    (:predicates    (at ?x ?y) (adj ?x ?y) (rob ?x)
                    (busy ?x) (person ?x) (request ?x ?y ?z) (conv ?topic) 
                    (Pdata ?patient-data ?loc) (issue ?x) (Preq ?patient-request) (req-done ?patient-request)
                    (Pwater ?water) (move-with-human ?patient-request ?to) (time4appt ?appt-time)
                    (moving-together ?moved) (return-robot ?return) (robot-home ?patient-request))

    (:action move-robot
        :parameters (?robot ?from ?to)
        :precondition (and (at ?robot ?from)
        		       (adj ?from ?to)
                       (rob ?robot)
                       (not (busy ?to)))
                       
        :effect (and (not (at ?robot ?from)) 
                          (at ?robot ?to)))
                         

    ; accompany human -- Barcelona with provide action in actionlib format
    ; until then, use only move robot. Assume human is moving with robot. 
    ; until Barcelona merge
    (:action move-human-robot
        :parameters (?human ?robot ?from ?to ?accompany ?moved)
        :precondition (and  (at ?human ?from)
                            (at ?robot ?from)
            		    (adj ?from ?to)
                            (person ?human)
                            (rob ?robot)
                            (moving-together ?moved)
                            (not (busy ?to)))
                       
        :effect (and        (not (at ?human ?from)) 
                            (not (at ?robot ?from))
                            (at ?robot ?to)
                            (at ?human ?to)))

    ; change as dialog, which has speak and listen inside it
    (:action speak
        :parameters (?robot ?topic  ?human ?loc)
        :precondition (and (at ?robot ?loc)
                           (at ?human ?loc)
                           (rob ?robot)
                           (person ?human)
                           (conv ?topic)
                           (not (request ?robot ?human ?topic)))
        :effect (and (request ?robot ?human ?topic)))
 
    ; name: collect data   -- remove    
    (:action listen
        :parameters (?human ?topic ?robot ?loc)
        :precondition (and (at ?robot ?loc)
                           (at ?human ?loc)
                           (rob ?robot)
                           (person ?human)
                           (conv ?topic)
                           (request ?robot ?human ?topic)
                           (not (request ?human ?robot ?topic)))
        :effect (and (request ?human ?robot ?topic)))

    (:action resolve-issue
        :parameters (?problem ?robot ?topic ?human ?loc)
        :precondition (and (at ?robot ?loc)
                           (at ?human ?loc)
                           (rob ?robot)
                           (person ?human)
                           (issue ?problem)
                           (request ?human ?robot ?topic))
        :effect (and (not (issue ?problem))))
    
    ; remove this, and use topic as get-patient-data       
    (:action get-patient-data
        :parameters (?patient-data ?robot ?topic ?human ?loc)
        :precondition (and (at ?robot ?loc)
                           (at ?human ?loc)
                           (rob ?robot)
                           (person ?human)
                           (not (Pdata ?patient-data ?loc))
                           (request ?human ?robot ?topic))
        :effect (and (Pdata ?patient-data ?loc)))
        
    ; (:action resolve-request
    ;     :parameters (?robot ?patient-request ?to) ; ?return)
    ;     :precondition (and  (rob ?robot)
    ;                         ; (return-robot ?return)
    ;                         (move-with-human ?patient-request ?to)
    ;                         (not (req-done ?patient-request))
    ;                         )
    ;     :effect (and    (req-done ?patient-request)))   


    ; use move-robot instead - remove
    (:action return-home
        :parameters (?robot ?patient-request ?to ?return) ; ?at-home)
        :precondition (and  (rob ?robot)
                            (return-robot ?return)
                            ; (at ?robot ?return)
                            (at ?robot ?to)
                            (adj ?to ?return)
                            (not (busy ?return))
                            (req-done ?patient-request)
                            (not (robot-home ?patient-request))
                            ; (not (req-done ?patient-request ?return))
                            )
        :effect (and    (robot-home ?patient-request)
                        (at ?robot ?return)
                        (not (at ?robot ?to))
                        ))  
        
    ; expanded domain -- more complex. Leave it with accompany robot instead         
    (:action take-patient2doc
        :parameters (?robot ?human ?from ?to ?patient-request ?appt-time) ; ?patient-data ?loc)
        :precondition (and (rob ?robot)
                          (person ?human)
                          (at ?robot ?from)
                          (at ?human ?from)
                          (adj ?from ?to)
                          (not (busy ?to))
                          (time4appt ?appt-time)
                        ;   (not (req-done ?accompany))
                        ;   (not (Preq ?accompany))
                          )
                        ;   (Pdata ?patient-data ?loc))
        :effect (and    (move-with-human ?patient-request ?to)
                        (not (time4appt ?appt-time))
                        ; (moving-together ?moved)
                        (not (at ?human ?from)) 
                        (not (at ?robot ?from)) 
                        (at ?robot ?to)
                        (at ?human ?to)
                        (req-done ?patient-request)
                        ; (Preq ?accompany)
                        ))          


    ; (:action get-water
    ;     :parameters (?loc ?robot  ?human ?want-water ?water ?Wloc ?request-done)
    ;     :precondition (and (rob ?robot)
    ;                       (person ?human)
    ;                       (Pwater ?water)
    ;                       (Preq ?want-water)
    ;                       (not (req-done ?request-done))
    ;                       (at ?robot ?Wloc)
    ;                       (at ?water ?Wloc)
    ;                       (not (at ?water ?loc)))
    ;     :effect (and (at ?water ?loc)
    ;                 (at ?robot ?loc)
    ;                 (req-done ?request-done)))                   
    

    ;(:action move-human
    ;    :parameters (?human ?from ?to)
    ;    :precondition (and (at ?human ?from)
    ;    		       (adj ?from ?to)
    ;                   (person ?human)
    ;                   (not (busy ?to)))
    ;                   
    ;    :effect (and (not (at ?human ?from)) 
    ;                      (at ?human ?to)))
                 
)
