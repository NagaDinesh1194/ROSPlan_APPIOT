(define (problem task)
(:domain maze)
(:objects
    t0001 t0002 t0003 - truck
    w0001 w0002 w0003 w0004 - warehouse
    r0001 r0002 r0003 r0004 r0005 r0006 - road
    wo0001 wo0002 - workorder
)
(:init
    (truck-at t0001 w0001)
    (truck-at t0002 w0002)
    (truck-at t0003 w0001)

    (truck-healthy t0001)

    (links r0002 w0001 w0003)
    (links r0002 w0003 w0001)
    (links r0003 w0002 w0003)
    (links r0003 w0003 w0002)
    (links r0006 w0004 w0003)
    (links r0006 w0003 w0004)

    (wo-dest wo0001 w0004)
    (wo-dest wo0002 w0004)

    (wo-src wo0001 w0001)
    (wo-src wo0002 w0002)


    (truck-idle t0001)
    (truck-idle t0002)
    (truck-idle t0003)


    (yettoload wo0001)
    (yettoload wo0002)

    (= (freespace t0001) 100)
    (= (freespace t0002) 100)
    (= (freespace t0003) 100)

    (= (takestime r0002) 100)
    (= (takestime r0003) 100)
    (= (takestime r0006) 2000)

    (= (wh-loadtime w0001) 5)
    (= (wh-loadtime w0002) 5)
    (= (wh-loadtime w0003) 5)
    (= (wh-loadtime w0004) 5)

    (= (wh-unloadtime w0001) 5)
    (= (wh-unloadtime w0002) 5)
    (= (wh-unloadtime w0003) 5)
    (= (wh-unloadtime w0004) 5)

    (= (wh-stock w0001) 100)
    (= (wh-stock w0002) 100)
    (= (wh-stock w0003) 0)
    (= (wh-stock w0004) 0)

    (= (wo-stock wo0001) 40)
    (= (wo-stock wo0002) 70)

    (= (wo-timelimit wo0001) 150)
    (= (wo-timelimit wo0002) 150)

    (= (wo-quality wo0001) 80)
    (= (wo-quality wo0002) 80)

    (= (wh-xfertime) 5)

    (= (total-expense) 0)

)
(:goal (and
    (delivered wo0001 w0004)
    (delivered wo0002 w0004)
))
(:metric minimize (+ (total-expense) (total-time)))
)
