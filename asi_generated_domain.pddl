
(define (domain asi-domain)
  (:requirements :typing :equality :fluents)
  (:types component perspective drone capability knowledge-object)
  (:constants camera thermal-camera signal-measurer - capability image thermal-image signal-measurement - knowledge-object)
  (:predicates 
    (is-perspective ?p - perspective ?c - component)
    (is-available ?k - knowledge-object ?p - perspective)
    (has-capability ?d - drone ?c - capability)
    (is-at ?d - drone ?c - component ?p - perspective)
    (know ?k - knowledge-object ?c - component ?p - perspective)
    (is-launch-pad ?lp - perspective)
  )
  (:functions 
    (required-charge ?sc ?dc - component)
    (spent-energy)
  )
  (:action goto
    :parameters
      (?drone - drone ?srcComp - component ?srcPersp - perspective ?destComp - component ?destPersp - perspective)
    :precondition
      (and
        (is-at ?drone ?srcComp ?srcPersp)
        (is-perspective ?destPersp ?destComp)
      )
    :effect
      (and
        (is-at ?drone ?destComp ?destPersp)
        (not
          (is-at ?drone ?srcComp ?srcPersp)
        )
        (increase (spent-energy) (required-charge ?srcComp ?destComp))
      )
  )
  (:action take-image
    :parameters
      (?drone - drone ?component - component ?perspective - perspective)
    :precondition
      (and
        (is-available image ?perspective)
        (is-at ?drone ?component ?perspective)
        (has-capability ?drone camera)
      )
    :effect
      (and
        (know image ?component ?perspective)
        (increase (spent-energy) 2)
      )
  )
  (:action take-thermal-image
    :parameters
      (?drone - drone ?component - component ?perspective - perspective)
    :precondition
      (and
        (is-available thermal-image ?perspective)
        (is-at ?drone ?component ?perspective)
        (has-capability ?drone thermal-camera)
      )
    :effect
      (and
        (know thermal-image ?component ?perspective)
        (increase (spent-energy) 3)
      )
  )
  (:action take-signal-measurement
    :parameters
      (?drone - drone ?component - component ?perspective - perspective)
    :precondition
      (and
        (is-available signal-measurement ?perspective)
        (is-at ?drone ?component ?perspective)
        (has-capability ?drone signal-measurer)
      )
    :effect
      (and
        (know signal-measurement ?component ?perspective)
        (increase (spent-energy) 4)
      )
  )
)

