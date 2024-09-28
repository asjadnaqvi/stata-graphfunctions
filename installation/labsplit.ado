*! labsplit v1.0 (28 Sep 2024)
*! Asjad Naqvi (asjadnaqvi@gmail.com)

* v1.0 (28 Sep 2024): first release.


cap program drop labsplit

program labsplit
version 11

	syntax varlist(max=1) [if] [in], [ wrap(numlist max=1 >0 integer) word(numlist max=1 >0 integer) strict GENerate(string) ]
	
	// error checks
	
	if "`wrap'" == "" & "`word'" == "" {
		display as error "Please specify one of {ul:wrap()} or {ul:word}. See {stata help labsplit}."
		exit
	}	
	
	if "`wrap'" != "" & "`word'" != "" {
		display as error "Both {ul:wrap()} and {ul:word()} cannot be specified together."
		exit
	}


quietly {	
	
	if "`generate'" != "" {
		gen `generate' = ""
		local _myvar `generate'
	}
	else {
		gen _labsplit = ""
		local _myvar _labsplit
	}
	
	if "`wrap'" != "" {
	
		if "`strict'" != "" {
			tempvar _length
			gen `_length' = length(`varlist') if !missing(`varlist')
			summ `_length', meanonly
			local _wraprounds = floor(`r(max)' / `wrap')
			
			replace `_myvar' = `varlist' // copy

			forval i = 1 / `_wraprounds' {
				local wraptag = `wrap' * `i'
				replace `_myvar' = substr(`_myvar', 1, `wraptag') + "`=char(10)'" + substr(`_myvar', `=`wraptag' + 1', .) if `_length' > `wraptag' & !missing(`_length')
			}
		}
		else {
			tempvar current_line _words _tempword length length0 length1
			
			gen `current_line' = word(`varlist', 1) if !missing(`varlist')
		
			
			gen `length0' = .
			gen `length1' = .
			gen `_words' = wordcount(`varlist')	
			
			summ `_words', meanonly
			local items = `r(max)'	

			
			
			forval i = 2/`items' {

				cap drop `_tempword'
				gen `_tempword' = word(`varlist', `i')  		if !missing(`varlist')
				
				replace `length0' = length(`current_line')  	if !missing(`varlist')
				replace `length1' = length(`_tempword')      	if !missing(`varlist')
				
				replace `current_line'	= `current_line' + " " + `_tempword' 		if (`length0' + `length1' + 1) <= `wrap' 
        		replace `_myvar' 		= `_myvar' + `current_line' + "`=char(10)'" if (`length0' + `length1' + 1) >  `wrap' & `_tempword'!=""
				replace `current_line' 	= `_tempword'    							if (`length0' + `length1' + 1) >  `wrap' & `_tempword'!=""				

			}
			

			replace `_myvar' = `_myvar' + `current_line' if !missing(`current_line') & `_myvar' != ""
			replace `_myvar' = word(`varlist', 1) if `_words'==1
		}
	}
	
	if "`word'" != "" {
		tempvar _part1 _part2 _words

		gen `_words' = wordcount(`varlist')	
		
		gen `_part1' = "" 			if `_words' > `word' 
		gen `_part2' = `varlist'	if `_words' > `word'
		

		forval i = 1 /`word' {
			replace `_part1' = `_part1' + word(`varlist', `i') + " " 				 if `_words' > `word'
			replace `_part2' = trim(ustrregexrf(`_part2', word(`varlist', `i'), "", .)) if `_words' > `word'
		}	
		
		replace `_myvar' = `_part1' + "`=char(10)'" + `_part2' if `_words' >  `word'
		replace `_myvar' = trim(`varlist')                     if `_words' <=  `word'
		
		
	}
}	
	
end


**** END OF DOFILE ****
