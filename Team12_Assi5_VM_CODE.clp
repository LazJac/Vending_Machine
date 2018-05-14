(deftemplate current-value (slot number))		;Holds the amount of money you add
(deftemplate selected-value (slot amount))		;Holds the amount of the ITEM (ex. cola 8.50) you choose

(deffunction actionAnswer (?answer ?currentamount)
	(if (lexemep ?answer)						;Checks if answer is a string-value
	then 
		(bind ?answer (lowcase ?answer))
		(if (or (eq ?answer "5")(eq ?answer "r5")(eq ?answer "5.00")(eq ?answer "r5.00"))
		then 
			(bind ?answer (+ ?currentamount 5.00)) 		;Add 5.00 to ?currentamount ;?answer get re-used to store the new value
		else
			(if (or (eq ?answer "2")(eq ?answer "r2")(eq ?answer "2.00")(eq ?answer "r2.00")) 
			then 
				(bind ?answer (+ ?currentamount 2.00))
			else
				(if (or (eq ?answer "1")(eq ?answer "r1")(eq ?answer "1.00")(eq ?answer "r1.00")) 
				then 
					(bind ?answer (+ ?currentamount 1.00))
				else
					(if (or (eq ?answer "50")(eq ?answer "50c")(eq ?answer "0.50")(eq ?answer "0.50c")) 
					then 
						(bind ?answer (+ ?currentamount 0.50))
					else
						(if (or (eq ?answer "20")(eq ?answer "20c")(eq ?answer "0.20")(eq ?answer "0.20c"))
						then 
							(bind ?answer (+ ?currentamount 0.20))
						else
							(if (or (eq ?answer "10")(eq ?answer "10c")(eq ?answer "0.10")(eq ?answer "0.10c"))
							then 
								(bind ?answer (+ ?currentamount 0.10))
							else
								(bind ?answer ?currentamount) 	;current amount stays unchanged
								(printout t "Error: incorrect input" crlf) 	;Incorrent money amount given in ?answer
							)
						)
					)
				)
			)
		)
	else
		(bind ?answer ?currentamount) 	;current amount stays unchanged
		(printout t "Error: incorrect input" crlf) 	;?answer is not a string-value, but a number-value
	)
	(return ?answer) ;new ?answer get returned
)

(defrule Start ;Select an item to assert 'selected-value' to start the program
	=>
	(printout t "Starting program:" crlf "Your choice: [Give number]" 
		crlf "	1 -- (Cola 		R8.50)"
		crlf "	2 -- (Orange		R10.00)"
		crlf "	3 -- (Sweets		R12.50)"
		crlf "	4 -- (Chocolate	R15.00)" crlf)
	(bind ?ans (readline))
	(if (eq ?ans "1")
	then
		(assert(selected-value (amount 8.50)))
	else
		(if (eq ?ans "2")
		then
			(assert(selected-value (amount 10.00)))
		else
			(if (eq ?ans "3")
			then
				(assert(selected-value (amount 12.50)))
			else
				(if (eq ?ans "4")
				then
					(assert(selected-value (amount 15.00)))
				else
					(reset)
					(run)
				)
			)
		)
	)
)

(defrule Process
	?fact <- (current-value (number ?total))
	(selected-value (amount ?givenAmount&~:(>= ?total ?givenAmount)))		;check if 1.) selected-value (amount ?) exists, AND 2.) if the function (>= ?total ?givenAmount) == FALSE; 2.) is the "&~:(= ?total ?givenAmount)" part
	=>
	(printout t crlf "Needed amount: R" ?givenAmount crlf "	Add a R5,R2,R1,50c,20c,10c:   --> Current amount: R" ?total crlf ":>> ")
	(bind ?ans (readline))
		(retract ?fact)					
		(assert (current-value (number (actionAnswer ?ans ?total) )))		;current-value become a new value based on what function 'actionAnswer' returns
)

(defrule End
	?fact <- (current-value (number ?total))
	(selected-value (amount ?givenAmount&:(>= ?total ?givenAmount)))		;check if 1.) selected-value (amount ?) exists, AND 2.) if the function (>= ?total ?givenAmount) == TRUE; 2.) is the "&:(= ?total ?givenAmount)" part
	=>
	(bind ?leftover (- ?total ?givenAmount))	;create a var ?leftover = ?total - ?givenAmount
	(printout t crlf "DONE !!!   ==> Current amount: R" ?total "   ==> Change amount: R" ?leftover crlf crlf crlf) 
		(retract ?fact)
		(reset)
		(run)
)

(deffacts vending
	(current-value (number 0))	
)