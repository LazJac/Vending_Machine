(deftemplate current-value (slot number))

(deffunction actionAnswer (?answer ?number)
	(if (eq ?answer "n")
	then 
		(bind ?answer (+ ?number 5))
	else
		(if (eq ?answer "q") 
		then 
			(bind ?answer (+ ?number 25))
		else
			(bind ?answer ?number) 
		)
	)
	(return ?answer)
)

(defrule Start
	;
)

(defrule Process
	; call actionAnswer(answer, current number)
)

(defrule End
	;check if <= 35c
	=>
	(printout t "DONE !!!" ?total)
)

(deffacts vending
	(current-value (number 0))	
)