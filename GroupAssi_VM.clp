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
	(printout t "Starting program:" crlf crlf)
)

(defrule Process
	(declare (salience 0))
	?fact <- (current-value (number ?num))
	=>
	(printout t "Add a Nickel(5c) or a Quarter(25c): [Q or N]   --> Current amount: " ?num "c" crlf ":> ")
	(bind ?ans (readline))
		(retract ?fact)					 
		(assert (current-value (number (actionAnswer ?ans ?num) )))
)

(defrule End
	(declare (salience 1))
	?fact <- (current-value (number ?total))
		(test(>= ?total 35))
	=>
	(printout t "DONE !!!   --> Current amount: " ?total "c" crlf crlf crlf)
		(retract ?fact)
		(reset)
		(run)
)

(deffacts vending
	(current-value (number 0))	
)
