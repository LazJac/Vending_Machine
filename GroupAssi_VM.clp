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
	(declare (salience 2))
	=>
	(printout t "Starting program:" crlf)
)

(defrule Process
	; call actionAnswer(answer, current number)
	(declare (salience 0))
)

(defrule End
	(declare (salience 1))
	?fact <- (current-value (number ?total))
		(test(>= ?total 35))
	=>
	(printout t "DONE !!!" ?total)
	(retract ?fact)
	(reset)
	(run)
)

(deffacts vending
	(current-value (number 0))	
)
