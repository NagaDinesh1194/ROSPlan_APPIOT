;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Task assignment problem
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; find schedule of tasks to people so that they all get done asap
(define (domain MAZE)
  (:requirements :strips :typing :durative-actions :fluents 
				 :disjunctive-preconditions :negative-preconditions)
  (:types task expertise person truck warehouse road workorder)
  (:functions
                (freespace ?t - truck)
                (takestime ?r - road)
                (wh-loadtime ?wh - warehouse)
                (wh-unloadtime ?wh - warehouse)
                (wh-stock ?wh - warehouse)
                (wo-stock ?wo - workorder)
                (wo-timelimit ?wo - workorder)
                (wo-quality ?wo - workorder)
		(wh-xfertime)
		(total-expense)
  ) 
  (:predicates
                (truck-at ?t - truck ?w - warehouse)
                (truck-healthy ?t - truck)
                (links ?r - road ?ws ?wd - warehouse)
                (wo-dest ?wo - workorder ?wh - warehouse)
                (wo-src  ?wo - workorder ?wh - warehouse)
                (truck-haswo ?t -truck ?wo - workorder)
		(truck-idle ?t - truck)
                (delivered ?wo - workorder ?wh - warehouse)
		(yettoload ?wo - workorder)

  )
  
;;        (:durative-action  move
;;                :parameters (?t - truck ?r - road ?ws - warehouse ?wd - warehouse)
;;                :duration (= ?duration (takestime ?r))
;;                :condition (and
;;                                (at start (truck-at ?t ?ws))
;;                                (at start (links ?r ?ws ?wd))
;;                                (at start (truck-idle ?t))
;;                        )
;;                :effect (and
;;                                (at start (not (truck-at ?t ?ws)))
;;                                (at end (truck-at ?t ?wd))
;;                                (at start (not (truck-idle ?t)))
;;                                (at end (truck-idle ?t))
;;				(at end (increase (total-expense) (takestime ?r)))
;;                        )
;;        ) 

        (:durative-action load
                :parameters (?t - truck ?w - warehouse ?wo - workorder)
                :duration (= ?duration (wh-loadtime ?w)) 
                :condition (and
                        (at start (truck-idle ?t))
                        (at start (truck-healthy ?t))
                        (at start (truck-at ?t ?w))
                        (at start (wo-src ?wo ?w))
                        (at start (yettoload ?wo))
                        (at start (>= (wh-stock ?w) (wo-stock ?wo)) )
                        (at start (>= (freespace ?t) (wo-stock ?wo)) )
                        )
                :effect (and
                        (at start (decrease (freespace ?t) (wo-stock ?wo)))
                        (at start (decrease (wh-stock ?w) (wo-stock ?wo)))
                        (at start (not (truck-idle ?t)))
                        (at start (truck-haswo ?t ?wo))
                        (at start (not (yettoload ?wo)))
                        (at end   (truck-idle ?t))
			(at end (increase (total-expense) 8))
                        )
        )
        ;:condition (and

                                ;(at start (truck-healthy ?t))


        (:durative-action unload
		:parameters (?t -truck ?w - warehouse ?wo - workorder)
		:duration (= ?duration (wh-unloadtime ?w))
		:condition (and 
			(at start (truck-idle ?t))
			(at start (truck-at ?t ?w))
			(at start (truck-haswo ?t ?wo))
                        (at start (wo-dest ?wo ?w))
			)
		:effect (and 
                        (at start (not (truck-idle ?t)))
                        (at end (increase (freespace ?t) (wo-stock ?wo)))
                        (at end (increase (wh-stock ?w) (wo-stock ?wo)))
			(at end (delivered ?wo ?w))
                        (at end (not (truck-haswo ?t ?wo)))
                        (at end (truck-idle ?t))
			(at end (increase (total-expense) 8))
			)
	)

        (:durative-action xfer
		:parameters (?t1 ?t2 - truck ?wo - workorder ?w -warehouse)
		:duration (= ?duration (wh-xfertime) )
		:condition (and 
			(at start (truck-idle ?t1))
			(at start (truck-idle ?t2))
                        (at start (truck-healthy ?t2))
			(at start (truck-haswo ?t1 ?wo))
			(at start (truck-at ?t1 ?w))
			(at start (truck-at ?t2 ?w))
			)
		:effect  (and
			(at start (not (truck-idle ?t1)))
			(at start (not (truck-idle ?t2)))
			(at end   (truck-idle ?t1))
			(at end   (truck-idle ?t2))
			(at end (truck-haswo ?t2 ?wo))
			(at end (not (truck-haswo ?t1 ?wo)))
			(at end (increase (total-expense) 8))
			)
	)

        (:durative-action  move
                :parameters (?t - truck ?r - road ?ws - warehouse ?wd - warehouse)
                :duration (= ?duration (takestime ?r))
                :condition (and
                                (at start (truck-at ?t ?ws))
                                (at start (links ?r ?ws ?wd))
                                (at start (truck-idle ?t))
                                (at start (truck-healthy ?t))
                        )
                :effect (and
                                (at start (not (truck-at ?t ?ws)))
                                (at end (truck-at ?t ?wd))
                                (at start (not (truck-idle ?t)))
                                (at end (truck-idle ?t))
				(at end (increase (total-expense) (takestime ?r)))
                        )
        )

)



