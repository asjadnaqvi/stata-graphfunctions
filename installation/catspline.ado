*! catspline v1.1 (28 Nov 2024)
*! Asjad Naqvi (asjadnaqvi@gmail.com)

* v1.1 (28 Nov 2024): Fix an issue with observations stacking. Fixed a minor bug in sort. Added a sort(), replace variable.
* v1.0 (04 Oct 2024): first release.


/*
to do: add option "replace", add option `sort()'.


*/


cap program drop catspline

program catspline, // sortpreserve

version 11
 
	syntax varlist(numeric min=2 max=2) [if] [in], [ rho(numlist max=1 >=0 <=1) n(real 40) close noid genx(string) geny(string) genid(string) genorder(string) sort(varlist max=1) replace ] 
 
	tokenize `varlist'
	local vary `1'
	local varx `2'
	
	// prepare the variables
	local xvar _x
	local yvar _y
	local idvar _id
	local ordervar _order

	if "`genx'" 	!= "" local xvar 	 `genx'
	if "`geny'" 	!= "" local yvar 	 `geny'				
	if "`genid'" 	!= "" local idvar 	 `genid'				
	if "`genorder'" != "" local ordervar `genorder'			
	
	
	if "`replace'" != "" {
		cap drop `xvar'
		cap drop `yvar'
		cap drop `idvar'
		cap drop `ordervar'
	}		
	

	cap confirm var _id
	if !_rc {
			display as error "Variable {it:_id} already exists."
			exit
	} 	
	
quietly {
preserve	
 
	
		

	keep `varlist' `sort'
	drop if missing(`varx')
	drop if missing(`vary')
	
	if "`sort'" != "" sort `sort'
	
	gen pts = _n
	order pts
 

 
	if "`rho'" == "" local rho 0.5
 
    if `n' < 5 {
        display as error "The number of points n() must be greater than 5."
        exit
    }
 
 
	if _N < `n' set obs `n'
	
	gen id = _n - 1
 
	levelsof pts, local(points)
	local last = r(r)
	
	foreach x of local points {
	
		// define the four points based on positioning
			
		local pt0 = `x'		
		local pt1 = `x' + 1
		local pt2 = `x' + 2
		local pt3 = `x' + 3
		
		if `pt1' > `last' local pt1 = `pt1' - `last'
		if `pt2' > `last' local pt2 = `pt2' - `last'
		if `pt3' > `last' local pt3 = `pt3' - `last'
			
		// control points indexed 0, 1, 2, 3

		forval i = 0/3 {
			summ `varx' if pts==`pt`i'', meanonly
			local x`i' = r(mean)
			
			summ `vary' if pts==`pt`i'', meanonly
			local y`i' = r(mean)
		}
	
		// generate the ts	
		tempvar t0 t1 t2 t3

		gen `t0' = 0
		gen double `t1' = (((`x1' - `x0')^2 + (`y1' - `y0')^2)^`rho') + `t0' 
		gen double `t2' = (((`x2' - `x1')^2 + (`y2' - `y1')^2)^`rho') + `t1'
		gen double `t3' = (((`x3' - `x2')^2 + (`y3' - `y2')^2)^`rho') + `t2'	
		
		local diff = abs(`t2' - `t1') / (`n' - 1)
		gen double t`x' = `t1' + (`diff' * id)
		
		
		**** calculate the As	
		forval i = 1/3 {
			local j = `i' - 1
				
			tempvar A`i'x A`i'y
				
			gen double `A`i'x' = (((`t`i'' - t`x') / (`t`i'' - `t`j'')) * `x`j'') + (((t`x' - `t`j'') / (`t`i'' - `t`j'')) * `x`i'')
			gen double `A`i'y' = (((`t`i'' - t`x') / (`t`i'' - `t`j'')) * `y`j'') + (((t`x' - `t`j'') / (`t`i'' - `t`j'')) * `y`i'')
				
		}

		**** calculate the Bs
		forval i = 1/2 {
			local j = `i' - 1
			local k = `i' + 1
			
			tempvar B`i'x B`i'y
			
			gen double `B`i'x' = (((`t`k'' - t`x') / (`t`k'' - `t`j'')) * `A`i'x') + (((t`x' - `t`j'') / (`t`k'' - `t`j'')) * `A`k'x')
			gen double `B`i'y' = (((`t`k'' - t`x') / (`t`k'' - `t`j'')) * `A`i'y') + (((t`x' - `t`j'') / (`t`k'' - `t`j'')) * `A`k'y')

		}
	
		**** calculate the Cs
		gen double `xvar'`x' = (((`t2' - t`x') / (`t2' - `t1')) * `B1x') + (((t`x' - `t1') / (`t2' - `t1')) * `B2x')
		gen double `yvar'`x' = (((`t2' - t`x') / (`t2' - `t1')) * `B1y') + (((t`x' - `t1') / (`t2' - `t1')) * `B2y')	
			
	}	
 

	cap drop `varlist' pts id

	local obs2 = `n'+ 1
	if _N < `obs2' set obs `obs2'	 // add an empty row


	gen `ordervar' = _n
	reshape long `xvar' `yvar' t, i(`ordervar') j(`idvar')
	
 
	if "`close'" == "" drop if `idvar'==`last' - 1
 
	drop t
	order `idvar' `ordervar'
	sort `idvar' `ordervar'
	
	tempfile mysplines
	save `mysplines', replace
	
	summ `idvar', meanonly
	local block1 = r(max)
	
	summ `ordervar', meanonly
	local block2 = r(max)

restore	

	local obs2 = `block1' * `block2'
	if _N < `obs2' set obs `obs2'
		
	egen `idvar'	= seq(), b(`block2')      // id
	egen `ordervar' = seq(), f(1) t(`block2') // order
	
	merge m:1 `idvar' `ordervar' using `mysplines'	
	drop _merge
	

	
}	
	
end

*********************************
******** END OF PROGRAM *********
*********************************
