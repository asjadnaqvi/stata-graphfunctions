
![StataMin](https://img.shields.io/badge/stata-2011-blue) ![issues](https://img.shields.io/github/issues/asjadnaqvi/stata-graphfunctions) ![license](https://img.shields.io/github/license/asjadnaqvi/stata-graphfunctions) ![Stars](https://img.shields.io/github/stars/asjadnaqvi/stata-graphfunctions) ![version](https://img.shields.io/github/v/release/asjadnaqvi/stata-graphfunctions) ![release](https://img.shields.io/github/release-date/asjadnaqvi/stata-graphfunctions)

[Installation](#Installation) | [Examples](#Examples) | [Feedback](#Feedback) | [Change log](#Change-log)

---


<img width="3000" height="1500" alt="graphfunctions_banner" src="https://github.com/user-attachments/assets/f001fa5c-cccf-40b7-9c05-525b28bc2ccc" />



# graphfunctions v1.6
*(19 Nov 2025)*

A modular grammar-of-graphics toolkit for Statadata visualizations.

The program contains a set of programs that allow users to build custom visualizations from the bottom up.

The package is currently *beta* and might still contains bugs and errors, and might still be missing all checks and balances. Please report these by opening an [issue](https://github.com/asjadnaqvi/stata-graphfunctions/issues).

This package contains the following programs:


|Program|Version|Updated|Description|
|----| ---- | ---- | ----- |
| [shapes](#shapes) | 1.4 | 19 Nov 2025 | Contains `shapes circle`, `shapes pie`, `shapes square`, `shapes rotate`, `shapes area`, `shapes translate`, `shapes dilate`, `shapes stretch`, `shapes round` |
| [arc](#arc) | 1.3 | 19 Nov 2025 | Draw major and minor arcs between two points |
| [radscatter](#radscatter) | 1.0 | 19 Nov 2025 | Generate scatter points and angles in polar coordinates |
| [labsplit](#labsplit) | 1.1 | 08 Oct 2024 | Text wrapper for labels |
| [catspline](#catspline) | 1.2 | 18 Feb 2025 | Catmull-Rom splines |


In the pipeline:

- Options for frames, and temp frames.
- Additional version control. Current program is v11 compatible but frames would imply v17 or higher.
- More checks to individual programs.

## Installation

The package can be installed via SSC or GitHub. The GitHub version, *might* be more recent due to bug fixes, feature updates etc, and *may* contain syntax improvements and changes in *default* values. See version numbers below. Eventually the GitHub version is published on SSC.

SSC (**v1.52**):

```stata
ssc install graphfunctions, replace
```

GitHub (**v1.6**):

```stata
net install graphfunctions, from("https://raw.githubusercontent.com/asjadnaqvi/stata-graphfunctions/main/installation/") replace
```

See the help file `help graphfunctions` for details. 


If you want to make a clean figure, then it is advisable to load a clean scheme, especially if you are not using newer Stata versions. My own setting is the following:

```stata
ssc install schemepack, replace
set scheme white_tableau  
graph set window fontface "Arial Narrow"
```


## labsplit 
*(v1.1: 08 Oct 2024)*

The program allows users to split text labels based on flexible or fixed character length or word positions.

Syntax:
```stata
labsplit variable, [ wrap(int) word(int) strict generate(newvar) ]
```

Examples:

```stata
clear
set obs 5
gen x = 1
gen y = _n

gen mylab = ""

replace mylab = "Test this really-hyphenated label." in 1
replace mylab = "Yet another label to test." in 2
replace mylab = "This is the third label" in 3
replace mylab = "How about we test this label as well" in 4
replace mylab = "Finally we are at the fifth label" in 5

```

Let's test the `labsplit` command:

```stata
labsplit mylab, wrap(10) gen(newlab1)
labsplit mylab, wrap(10) gen(newlab2) strict
labsplit mylab, word(2) gen(newlab3)
```

Code for figures:

```stata
twoway (scatter y x, mlabel(mylab)   mlabsize(3)), title("Standard")
twoway (scatter y x, mlabel(newlab1) mlabsize(3)), title("Wrapping")

twoway (scatter y x, mlabel(newlab2) mlabsize(3)), title("Wrapping strict") 
twoway (scatter y x, mlabel(newlab3) mlabsize(3)), title("Word wrap")
```

<img src="/figures/labsplit0.png" width="50%"><img src="/figures/labsplit1.png" width="50%">
<img src="/figures/labsplit2.png" width="50%"><img src="/figures/labsplit3.png" width="50%">

## catspline
*(v1.2: 18 Feb 2025)*


The program allows users to generate splines based on the [Catmull-Rom algorithm](https://en.wikipedia.org/wiki/Centripetal_Catmull%E2%80%93Rom_spline).

Syntax:
```stata
catspline y x, [ rho(num [0,1]) n(int) close sort(var) genx(str) geny(str) genid(str) genorder(str) replace ]
```

Examples:

```stata
clear
set obs 6
set seed 2021

gen x = runiformint(1,5)
gen y = runiformint(1,5)


catspline y x

twoway ///
	(scatter y x) ///
	(line _y _x,  cmissing(n))
```

<img src="/figures/catspline1.png" width="75%">

We can also close the loop by adding the `close` option:

```stata
cap drop _id _x _y
catspline y x, close 

twoway ///
	(scatter y x) ///
	(line _y _x,  cmissing(n))
```

<img src="/figures/catspline2.png" width="75%">


The Stata [spider](https://github.com/asjadnaqvi/stata-spider) package uses this function. 

## arc
*(v1.3: 19 Nov 2025)*

Draw minor or major arcs between two points. The arc orientation and be switched using `swap`, and major arcs can be drawn using `major`.

Syntax:

```stata
arc, x1(num) y1(num) x2(num) y2(num) [ radius(num) n(int) swap major genx(newvar) geny(newvar) dropbase replace ]
```

Examples:


```stata
arc, y1(-2) x1(-4) y2(4) x2(2) rad(6) replace

twoway ///
	(scatteri -2 -4)  (scatteri 4 2) ///
	(scatteri `r(ycirc)' `r(xcirc)') ///
	(line _y _x)  ///
	, legend(order(1 "Point 1" 2 "Point 2" 3 "Circumcenter" 4 "Arc") pos(6) row(1)) ///
	xlabel(-10(2)10) ylabel(-10(2)10) aspect(1) xsize(1) ysize(1) ///
	title("Right of starting point - minor")
```

<img src="/figures/arc1.png" width="75%">

```stata
arc, y1(-2) x1(-4) y2(4) x2(2) rad(6) major replace		

twoway ///
	(scatteri -2 -4)  (scatteri 4 2) ///
	(scatteri `r(ycirc)' `r(xcirc)') ///
	(line _y _x)  ///
	, legend(order(1 "Point 1" 2 "Point 2" 3 "Circumcenter" 4 "Arc") pos(6) row(1)) ///
	xlabel(-10(2)10) ylabel(-10(2)10) aspect(1) xsize(1) ysize(1) ///
	title("Right of starting point - major")	
	
```

<img src="/figures/arc2.png" width="75%">

```stata
arc, y1(-2) x1(-4) y2(4) x2(2) rad(6) swap replace		

twoway ///
	(scatteri -2 -4)  (scatteri 4 2) ///
	(scatteri `r(ycirc)' `r(xcirc)') ///
	(line _y _x)  ///
	, legend(order(1 "Point 1" 2 "Point 2" 3 "Circumcenter" 4 "Arc") pos(6) row(1)) ///
	xlabel(-10(2)10) ylabel(-10(2)10) aspect(1) xsize(1) ysize(1) ///
	title("Left of starting point - minor")
```

<img src="/figures/arc3.png" width="75%">

```stata
arc, y1(-2) x1(-4) y2(4) x2(2) rad(6) swap major replace

twoway ///
	(scatteri -2 -4)  (scatteri 4 2) ///
	(scatteri `r(ycirc)' `r(xcirc)') ///
	(line _y _x)  ///
	, legend(order(1 "Point 1" 2 "Point 2" 3 "Circumcenter" 4 "Arc") pos(6) row(1)) ///
	xlabel(-10(2)10) ylabel(-10(2)10) aspect(1) xsize(1) ysize(1) ///
	title("Left of starting point - Major")
```

<img src="/figures/arc4.png" width="75%">


The Stata [geoflow](https://github.com/asjadnaqvi/stata-geoflow) package uses this function. 



## shapes
*(v1.4: 19 Nov 2025)*

### shapes circle


Syntax: 

```stata
shapes circle, radius(num) [ x0(num) y0(num) n(int) rotate(degrees) genx(var) geny(var) genid(var) genorder(var) replace append ]
```


Examples:
```stata
shapes circle, replace

twoway /// 
		(connected _y _x, mlabel(_order)) ///
		, xsize(1) ysize(1) aspect(1)	///
		xlabel(-10 10) ylabel(-10 10)
```

<img src="/figures/circle1.png" width="75%">

```stata
shapes circle, n(6) replace


twoway /// 
		(connected _y _x, mlabel(_order)) ///
		, xsize(1) ysize(1) aspect(1)	///
		xlabel(-10 10) ylabel(-10 10)
```

<img src="/figures/circle2.png" width="75%">


```stata
shapes circle, n(6) rotate(30) replace

twoway /// 
		(connected _y _x, mlabel(_order)) ///
		, xsize(1) ysize(1) aspect(1)	///
		xlabel(-10 10) ylabel(-10 10)
```

<img src="/figures/circle3.png" width="75%">


```stata
shapes circle, rotate(45) rad(8) n(4) replace		

twoway /// 
		(connected _y _x, mlabel(_order)) ///
		, xsize(1) ysize(1) aspect(1)	///
		xlabel(-10 10) ylabel(-10 10)
```

<img src="/figures/circle4.png" width="75%">


```stata
shapes circle, n(100) replace	

twoway /// 
		(line _y _x) ///
		, xsize(1) ysize(1) aspect(1)	///
		xlabel(-10 10) ylabel(-10 10)
```

<img src="/figures/circle5.png" width="75%">


```stata
shapes circle,    	      n(8) replace
shapes circle, rotate(30) n(6) rad(8) append 
shapes circle, rotate(60) n(4) rad(3)  x0(1) y0(1) append

twoway (connected _y _x, cmissing(n)), aspect(1)
```

<img src="/figures/circle6.png" width="75%">

### shapes pie

Syntax:

```stata
shapes pie, radius(num) end(degrees) [ start(degrees) x0(num) y0(num) n(int) rotate(degrees) dropbase flip genx(var) geny(var) genid(var) genorder(var) replace append ]
```

Examples:
```stata
shapes pie, end(60) replace

twoway (area _y _x), xlabel(-10 10) ylabel(-10 10) xsize(1) ysize(1) aspect(1)
```

<img src="/figures/pie1.png" width="75%">


```stata
shapes pie, start(0) end(270) n(200) replace

twoway (area _y _x), xlabel(-10 10) ylabel(-10 10) xsize(1) ysize(1) aspect(1)
```

<img src="/figures/pie2.png" width="75%">

```stata
clear
shapes pie, start(0) end(45) ro(0)		rad(5) 	replace
shapes pie, start(0) end(45) ro(30) 	rad(6)  stack
shapes pie, start(0) end(45) ro(60) 	rad(7)  stack
shapes pie, start(0) end(45) ro(90) 	rad(8)  stack
shapes pie, start(0) end(45) ro(120) 	rad(9)  stack
shapes pie, start(0) end(45) ro(150) 	rad(10) stack


twoway (area _y _x, fcolor(%90) cmissing(n) nodropbase)	///
	, xlabel(-10 10) ylabel(-10 10) xsize(1) ysize(1) aspect(1)
```

<img src="/figures/pie3.png" width="75%">


without base:

```stata
shapes pie, start(0) end(230) rad(10) rotate(90) n(200) dropbase replace
shapes pie, start(0) end(230) rad(9)  rotate(90) n(200) dropbase append
shapes pie, start(0) end(200) rad(8)  rotate(90) n(200) dropbase append
shapes pie, start(0) end(180) rad(7)  rotate(90) n(200) dropbase append
shapes pie, start(0) end(160) rad(6)  rotate(90) n(200) dropbase append

twoway (line _y _x, cmissing(n) nodropbase)	///
	, xlabel(-10 10) ylabel(-10 10) xsize(1) ysize(1) aspect(1)
```

<img src="/figures/pie4.png" width="75%">

without base flipped direction:

```stata
shapes pie, start(0) end(350) rad(10) rotate(90) n(200) dropbase flip replace
shapes pie, start(0) end(150) rad(9)  rotate(90) n(200) dropbase flip append
shapes pie, start(0) end(130) rad(8)  rotate(90) n(200) dropbase flip append
shapes pie, start(0) end(80) rad(7)  rotate(90) n(200) dropbase flip append
shapes pie, start(0) end(60) rad(6)  rotate(90) n(200) dropbase flip append

twoway (line _y _x, cmissing(n) nodropbase)	///
	, xlabel(-10 10) ylabel(-10 10) xsize(1) ysize(1) aspect(1)
```

<img src="/figures/pie5.png" width="75%">


### shapes square

Syntax:

```stata
shapes square, [ length(num) x0(num) y0(num) rotate(degrees) genx(var) geny(var) genid(var) genorder(var) replace append ]
```

Examples:

```stata
shapes square, len(8) rotate(90) replace

twoway ///
	(area _y _x, nodropbase fcolor(%50))	///
	(scatter _y _x, mlab(_order))	///
		, ///
		legend(off) ///
		xlabel(-10(2)10) ylabel(-10(2)10) xsize(1) ysize(1) aspect(1)
```

<img src="/figures/square1.png" width="75%">


```stata
shapes square, x0(1) y0(1) len(10) rotate(40) replace
shapes square, x0(1) y0(1) len(9) rotate(30) append
shapes square, x0(1) y0(1) len(8) rotate(20) append
shapes square, x0(1) y0(1) len(7) rotate(10) append
shapes square, x0(1) y0(1) len(6) rotate(0)  append		


twoway ///
	(area _y _x, cmissing(n) nodropbase fcolor(%100) lw(0.1) lc(white))	///
		, ///
		legend(off) ///
		xlabel(-10(2)10) ylabel(-10(2)10) xsize(1) ysize(1) aspect(1)
```		

<img src="/figures/square2.png" width="75%">


### shapes translate


Syntax:

```stata
shapes translate <yvar> <xvar> [if] [in], [ x(num) y(num) genx(var) geny(var) replace ]
```

<img src="/figures/_translate.png" width="30%">


Move the object by `x(a)` and `y(b)` points:

$$ 
x = x + a
$$

$$
y = y + b
$$


### shapes dilate



Syntax:

```stata
shapes dilate <yvar> <xvar> [if] [in], [ factor(num) genx(var) geny(var) replace ]
```

<img src="/figures/_dilate.png" width="30%">


Expand or reduce the object by factor `factor(a)`:

$$ 
x = x * a
$$

$$
y = y * a
$$




### shapes stretch



Syntax:

```stata
shapes stretch <yvar> <xvar> [if] [in], [ x(num) y(num) replace ]
```

<img src="/figures/_stretch.png" width="30%">


Stretch the object by factors `x(a)` and `y(b)`:

$$ 
x = x * (1 + a)
$$

$$
y = y * (1 + b)
$$

### shapes rotate



Syntax:

```stata
shapes rotate <yvar> <xvar> [if] [in], [ rotate(degrees) x0(num) y0(num) center genx(var) geny(var) replace ]
```


<img src="/figures/_rotate.png" width="30%">


Rotate the shape by `rot(angle)` at points `x0(a)` and `y0(b)`:

$$ 
x = (x - a) * cos(angle) - (y - b) * sin(angle)
$$
`
$$
y = (x - a) * sin(angle) + (y - b) * cos(angle)
$$

By default $(a,b) = (0,0)$.


Let's generate a basic shape:

```stata
shapes square, x0( 5) y0(0) len(5) replace
shapes square, x0(-5) y0(0) len(5) append

twoway ///
	(area _y _x, cmissing(n) nodropbase fcolor(%80) lw(0.1) lc(white))	///
	(scatteri 0 0) ///
		, ///
		legend(off) ///
		xlabel(-10(2)10) ylabel(-10(2)10) xsize(1) ysize(1) aspect(1)	
```

<img src="/figures/rotate1.png" width="75%">



```stata
shapes rotate _y _x, rotate(30)


twoway ///
	(area _y _x, cmissing(n) nodropbase fcolor(%80) lw(0.1) lc(white))	///
	(area ynew  xnew, cmissing(n) nodropbase fcolor(%80) lw(0.1) lc(white))	///
	(scatteri 0 0) ///
		, ///
		legend(off) ///
		xlabel(-10(2)10) ylabel(-10(2)10) xsize(1) ysize(1) aspect(1)	
```

<img src="/figures/rotate2.png" width="75%">


```stata
shapes rotate _y _x, rotate(30) x0(5) y0(5) genx(xnew) geny(ynew)

twoway ///
	(area _y _x, cmissing(n) nodropbase fcolor(%80) lw(0.1) lc(white))	///
	(area ynew  xnew, cmissing(n) nodropbase fcolor(%80) lw(0.1) lc(white))	///
	(scatteri 0 0) ///
		, ///
		legend(off) ///
		xlabel(-10(2)10) ylabel(-10(2)10) xsize(1) ysize(1) aspect(1)	
```

<img src="/figures/rotate2_1.png" width="75%">


```stata
shapes rotate _y _x, rotate(60) center genx(xnew2) geny(ynew2)		

twoway ///
	(area _y _x, cmissing(n) nodropbase fcolor(%80) lw(0.1) lc(white))	///
	(area ynew2  xnew2, cmissing(n) nodropbase fcolor(%80) lw(0.1) lc(white))	///
	(scatteri 0 0) ///
		, ///
		legend(off) ///
		xlabel(-10(2)10) ylabel(-10(2)10) xsize(1) ysize(1) aspect(1)	
```

<img src="/figures/rotate3.png" width="75%">


```stata
shapes rotate _y _x, rotate(30) center by(_id) genx(xnew3) geny(ynew3)			
	
twoway ///
	(area _y _x, cmissing(n) nodropbase fcolor(%80) lw(0.1) lc(white))	///
	(area ynew3  xnew3, cmissing(n) nodropbase fcolor(%80) lw(0.1) lc(white))	///
	(scatteri 0 0) ///
		, ///
		legend(off) ///
		xlabel(-10(2)10) ylabel(-10(2)10) xsize(1) ysize(1) aspect(1)
```

<img src="/figures/rotate4.png" width="75%">


### shapes round



Syntax:

```stata
shapes round <yvar> <xvar> [if] [in], roundness(num) [ n(num) factor(num) genx(var) geny(var) genid(var) genorder(var) gensegvar(var) replace append ]
```

<img src="/figures/_round.png" width="50%">

This command will generate rounded edges with radius `roundness()`. The size of the rounding is determined by `factor()`. 

NOTE: If `roundness()` is larger than the shape length, then usual edges might be drawn so calibrate carefully.

The option `factor(1)` implies that center point of the arc is the exact middle of the edges. A larger factor moves the point away from the minor arc making it less curvy. If rounding is done on figures a large number of edges, e.g. hexagon, octagon, or higher, then reducing the rounding might fit better with the figure. So calibrate this option also carefully.


This command will generate or overwrite five new variables: `_rx, _ry, _rid, _rorder, _segvar`, or their respective custom names.

Each shape with rounded edges is assigned an `_rid` that is carried forward from the original shape `_id`. The shape is split into two segment types: lines and arcs, which are identitied by the `_segvar` variable, and `_rorder` is the drawing order of each segment variable. The `_rid`, `_segvar`, and `_rorder` give a unique sort and order that needs to be respected to draw the shapes correctly.


TODO: Add examples.


### shapes area

Syntax:

```stata
shapes area <yvar> <xvar>, [ {opt by(var} generate(var) replace ]
```

Examples:
```stata
clear
shapes pie, start(0) end(45) ro(0)		rad(5) 	replace
shapes pie, start(0) end(45) ro(30) 	rad(6)  stack
shapes pie, start(0) end(45) ro(60) 	rad(7)  stack
shapes pie, start(0) end(45) ro(90) 	rad(8)  stack
shapes pie, start(0) end(45) ro(120) 	rad(9)  stack
shapes pie, start(0) end(45) ro(150) 	rad(10) stack


twoway (area _y _x, fcolor(%90) cmissing(n) nodropbase)	///
	, xlabel(-10 10) ylabel(-10 10) xsize(1) ysize(1) aspect(1)
```

<img src="/figures/area1.png" width="75%">


calculate the areas

```stata
shapes area _y _x, by(_id) 
```

Generate some ranking of areas and plot


```stata
xtile grps = _area, n(4)	

levelsof _id, local(lvls)

foreach x of local lvls {
	colorpalette reds, nograph
	local myarea `myarea' (area _y _x if _id==`x', fcolor("`r(p`x')'%90") lc("`r(p`x')'") cmissing(n) nodropbase)	
}



twoway ///
	`myarea'	///
	, ///
		xlabel(-10 10) ylabel(-10 10) ///
		legend(off) ///
		xsize(1) ysize(1) aspect(1)
```


<img src="/figures/area2.png" width="75%">

## radscatter
*(v1.0: 19 Nov 2025)*

Syntax:

```stata
radscatter [ numvar ] [if] [in], [ rotate(angle) radius(num) flip displace(num) genx(str) geny(str) genangle(var) genheight(var) replace ]

```


## Examples



### Example 1: Custom radial bar plot with rounded edges and polar labels.

This example was showcased in the Stata Switzerland 2025 conference (Bern, 21 Nov 2025).

Load cleaned regional population file from Eurostat: 

```stata
use "https://github.com/asjadnaqvi/stata-spider/blob/main/data/demo_r_pjangrp3_clean.dta?raw=true", clear

ren y2023 pop
keep if nuts0=="CH"		// Keep Switzerland
collapse (sum) pop, by(nuts2 nuts2_label) // keep NUTS2 regions 
gsort -pop    	// reserve sort on population
gen group = _n  // generate order variable
```

For each group generate a square of length 10, whose bottom-left point is at the origin (default):

```stata
levelsof nuts2
local items = `r(r)'

local i = 1

while `i' <= `items' {
	shapes square, len(10) append
	local ++i
}
```

Plot and check:

```stata
twoway ///
	(area _y _x, cmissing(n) nodropbase fcolor(%80) lw(0.1) lc(white))	///
	(scatteri 0 0) ///
		, ///
		legend(off) ///
		xsize(1) ysize(1) aspect(1)		
```

<img src="/figures/example1_1.png" width="75%">

Let's now stretch each square based on the population size:


```stata
summ pop, meanonly
local mymax = r(max)	

levelsof nuts2
local items = `r(r)'
	
forval i = 1/`items' {
	summ pop if group==`i', meanonly
	local factor = r(max) / `mymax'
	shapes stretch _y _x  if _id==`i', y(0.2) x(`factor') replace
}
```

and plot it again:

```stata
twoway ///
	(area _y _x, cmissing(n) nodropbase fcolor(%30) lw(0.1) lc(black))	///
		, ///
		legend(off) ///
		xline(0) yline(0) ///
		xlabel(-10 10) ylabel(-10 10) ///
		xsize(1) ysize(1) aspect(1)
```

<img src="/figures/example1_2.png" width="75%">


We can also move these blocks down by one point to center on the x-axis:

```stata
shapes translate _y _x, y(-1) replace	
```

We can also check this:

```stata
twoway ///
	(area _y _x, cmissing(n) nodropbase fcolor(%30) lw(0.1) lc(black))	///
		, ///
		legend(off) ///
		xline(0) yline(0) ///
		xlabel(-10 10) ylabel(-10 10) ///
		xsize(1) ysize(1) aspect(1)
```

<img src="/figures/example1_3.png" width="75%">


We can now rotate and distribute the shapes on a circle:

```stata
levelsof nuts2
local items = `r(r)'	
	
forval i = 1/`items' {	
	local angle = (`i' - 1) / `items' * 360
	shapes rotate _y _x if _id==`i', rotate(`angle') replace
}	
``` 

Let's see what it looks like:

```stata
twoway ///
	(area _y _x, cmissing(n) nodropbase fcolor(%30) lw(0.1) lc(black))	///
		, ///
		legend(off) ///
		xline(0) yline(0) ///
		xlabel(-10 10) ylabel(-10 10) ///
		xsize(1) ysize(1) aspect(1)
```

<img src="/figures/example1_4.png" width="75%">



We can now round the edges:

```stata
levelsof nuts2
local items = `r(r)'	

forval i = 1/`items' {
	shapes round _y _x if _id==`i', r(0.5) n(20) append
}	
```

```stata
twoway ///
	(area _ry _rx , cmissing(no) nodropbase fcolor(%40) lw(0.1) lc(black))	///
		, ///
		legend(off) ///
		xline(0) yline(0) ///
		xlabel(-10 10) ylabel(-10 10) ///
		xsize(1) ysize(1) aspect(1)	
```

<img src="/figures/example1_5.png" width="75%">


Let's add some colors:

```stata
levelsof group, local(lvls)
local items = `r(r)'

foreach x of local lvls {
	
	colorpalette CET L20, nograph n(`items') reverse
	
	local myarea `myarea' (area _ry _rx if _rid==`x', cmissing(no) nodropbase fi(100) fcolor("`r(p`x')'%80") lw(0.1) lc(black))
		
}


twoway ///
	`myarea'	///
		, ///
		legend(off) ///
		xlabel(-10 10) ylabel(-10 10) ///
			xscale(off) yscale(off)	///
			xlabel(, nogrid) ylabel(, nogrid) ///
				xsize(1) ysize(1) aspect(1)		
```

<img src="/figures/example1_6.png" width="75%">


Which gives us a neat figure. But labels are missing. Since we don't want users to struggle with polar coordinates, we can use `radscatter` to generate the points:

```stata
radscatter pop, replace labangle rad(10) displace(2)
```

The option labangle gives us the angle that allows us to align the label to the ray from the original. Let's add this to our plot:

```stata
		
levelsof group, local(lvls)
local items = `r(r)'

foreach x of local lvls {
	
	colorpalette CET L20, nograph n(`items') reverse
		
	local myarea `myarea' (area _ry _rx if _rid==`x', cmissing(no) nodropbase fi(100) fcolor("`r(p`x')'%80") lw(0.1) lc(black))
	
	summ _labangle if _radid==`x', meanonly
	local myscatter `myscatter' (scatter _rady _radx if _radid==`x', mcolor(none) mlabel(nuts2_label) mlabangle(`r(mean)') mlabpos(0) mlabsize(2))
	
}


twoway ///
	`myarea'	///
	`myscatter' ///
		, ///
		legend(off) ///
		xlabel(-12 12) ylabel(-12 12) ///
		xsize(1) ysize(1) aspect(1)		///
			xscale(off) yscale(off)	///
			xlabel(, nogrid) ylabel(, nogrid) 
```

<img src="/figures/example1_7.png" width="75%">



We can of course get rid of all the intermediate plots and do all the calculations and just plots the final figure. Or we can even create our own program that generate this plot type.


### Example 2: Custom pie graph

This example was showcased in the Stata Switzerland 2025 conference (Bern, 21 Nov 2025).


Prepare the data (as above):


```stata
use "https://github.com/asjadnaqvi/stata-spider/blob/main/data/demo_r_pjangrp3_clean.dta?raw=true", clear

ren y2023 pop
keep if nuts0=="CH"		// Keep Switzerland
collapse (sum) pop, by(nuts2 nuts2_label) // keep NUTS2 regions 
gsort -pop    	// reserve sort on population
gen group = _n  // generate order variable
```


Let's generate a pie for each NUTS2 where each pie has a fixed angle but the height is normalized to the `pop` variable and rotate by a certain angle:

```stata		
levelsof nuts2
local items = `r(r)'
						
summ pop, meanonly
local mymax = r(max)	
	
local shift = 0
	
forval i = 1/`items' {
	
	summ pop if group==`i', meanonly
	local factor = (r(max) / `mymax') * 10
	 			
	shapes pie, start(0) end(60) rotate(`shift') n(30) rad(`factor') append

	local _range = 270
		
	local shift = `shift' + `_range' / `=`items' - 1'
	
}
```

Test the plot:

```stata
twoway (area _y _x, cmissing(no) nodropbase fcolor(%30))	///
	, ///
	xsize(1) ysize(1) aspect(1)		///			
		xlabel(-10 10) ylabel(-10 10) ///
			xscale(off) yscale(off)	///
			xlabel(, nogrid) ylabel(, nogrid) 
```

<img src="/figures/example2_1.png" width="75%">


Let's make it nicer:

```stata
local myarea

levelsof _id, local(lvls) 
local items = `r(r)'

foreach x of local lvls {
	colorpalette CET L20, nograph n(`items')
	local myarea `myarea' (area _y _x if _id==`x', cmissing(no) nodropbase fi(100) fcolor("`r(p`x')'%100") lw(0.1) lc(black))
		
}
			
			
twoway `myarea'	///
	, ///
	legend(off)	///
	xsize(1) ysize(1) aspect(1)		///			
		xlabel(-10 10) ylabel(-10 10) ///
			xscale(off) yscale(off)	///
			xlabel(, nogrid) ylabel(, nogrid) 
			
```

<img src="/figures/example2_2.png" width="75%">


### Example 3: Custom radial race plot

Prepare the data as above:

```stata
use "https://github.com/asjadnaqvi/stata-spider/blob/main/data/demo_r_pjangrp3_clean.dta?raw=true", clear

ren y2023 pop
keep if nuts0=="CH"		// Keep Switzerland
collapse (sum) pop, by(nuts2 nuts2_label) // keep NUTS2 regions 
gsort -pop    	// reserve sort on population
gen group = _n  // generate order variable
```

Now we generate arcs whose radii decrease in size by a value of one. The maximum length of the arcs is capped till the 3rd quadrant, or 270 degrees:


```stata
summ pop, meanonly
local mymax = r(max)	
	

levelsof nuts2
local items = `r(r)'

	
forval i = 1/`items' {
	
	summ pop if group==`i', meanonly
	local factor = (r(max) / `mymax') * 270
	
	local myradius = `items' + 5 - `i' 
	
	shapes pie, start(0) end(`factor') n(50) rad(`myradius') append dropbase flip rotate(90)

}
```

Test what we have:

```stata
twoway (line _y _x, cmissing(no) nodropbase fcolor(%30))	///
	, xsize(1) ysize(1) aspect(1)					
```

<img src="/figures/example3_1.png" width="75%">


Add scatter points at the starting line:

```stata
levelsof group, local(lvls) 
local items = `r(r)'
		
cap drop _sy _sx
gen _sy = `items' + 5 - group 	if !missing(group)
gen _sx = -0.2 					if !missing(group)

cap drop _mylab
gen _mylab = nuts2_label + " (" + string(pop, "%15.0fc") + ")" if !missing(group)
```

Make it epic:

```stata
summ pop, meanonly
local mymax = r(max)	

levelsof _id, local(lvls) 
local items = `r(r)'

foreach x of local lvls {
	
	summ pop if group==`x', meanonly
	local mylwid = (r(max) / `mymax') * 0.7 + 0.3
	
	colorpalette CET L06, nograph n(`items') 
	local mylines `mylines' (line _y _x if _id==`x', cmissing(no) nodropbase lcolor("`r(p`x')'%100") lw(`mylwid') )
		
}
			
			
twoway ///
	`mylines'	///
	(scatter _sy _sx, mlabel(_mylab) mlabpos(9) mcolor(none) mlabsize(1.8) ) ///
	, ///
	legend(off)	///
	xsize(1) ysize(1) aspect(1)		///			
		xlabel(-10 10) ylabel(-10 10) ///
			xscale(off) yscale(off)	///
			xlabel(, nogrid) ylabel(, nogrid) 
						
```

<img src="/figures/example3_2.png" width="75%">


### Example 4: Transformed shapes

Prepare the data as above:


```stata
use "https://github.com/asjadnaqvi/stata-spider/blob/main/data/demo_r_pjangrp3_clean.dta?raw=true", clear

ren y2023 pop
keep if nuts0=="CH"		// Keep Switzerland
collapse (sum) pop, by(nuts2 nuts2_label) // keep NUTS2 regions 
gsort -pop    	// reserve sort on population
gen group = _n  // generate order variable
```

Generate hexagons that are have radius normalized by the population. Also rotate them very slightly for the extra spiciness:

```stata
levelsof nuts2
local items = `r(N)'

local myrotate = 0					
					
summ pop, meanonly
local mymax = r(max)	
	

forval i = 1/`items' {
		
	summ pop if group==`i', meanonly
	local factor = (r(max) / `mymax') * 10
	
	shapes circle, rad(`factor') n(6) rotate(`myrotate')  append
	
	*local myrotate = `myrotate' + 2
}
```

Plot and check:


```stata
twoway (area _y _x, cmissing(no) nodropbase fcolor(%30))	///
	, xsize(1) ysize(1) aspect(1)
```

<img src="/figures/example4_1.png" width="75%">


Improve the plot:

```stata
local myarea
levelsof group, local(lvls) 
local items = `r(N)'


foreach x of local lvls {
		colorpalette CET L20, nograph  n(`items')
		
		local myarea `myarea' (area _y _x if _id==`x', cmissing(no) nodropbase fi(100) fcolor("`r(p`x')'%100") lw(0.1) lc(white))
}
			
				
twoway `myarea'	///
	, legend(off)	///
	xsize(1) ysize(1) aspect(1)		///			
		xlabel(-10 10) ylabel(-10 10) ///
			xscale(off) yscale(off)	///
			xlabel(, nogrid) ylabel(, nogrid) 
```

<img src="/figures/example4_2.png" width="75%">


Let's displace these shapes away from the origin, and rotate (or pivot) them on the origin:

```
levelsof _id, local(lvls)

local myrot = 0

foreach x of local lvls {
	
	shapes translate _y _x if _id==`x', x(15) replace
	
	shapes rotate _y _x if _id==`x', rotate(`myrot') replace
	
	local myrot = `myrot' + 20	
}
```

And check the plot:

```stata
local myarea
levelsof group, local(lvls) 
local items = `r(N)'


foreach x of local lvls {
		colorpalette CET L20, nograph  n(`items')
		
		local myarea `myarea' (area _y _x if _id==`x', cmissing(no) nodropbase fi(100) fcolor("`r(p`x')'%100") lw(0.1) lc(white))
}
			
			
twoway `myarea'	///
	, legend(off)	///
	xsize(1) ysize(1) aspect(1)		///			
		xlabel(-20 30) ylabel(-20 30) ///
			xscale(off) yscale(off)	///
			xlabel(, nogrid) ylabel(, nogrid) 	
```

<img src="/figures/example4_3.png" width="75%">


Let's round the edges for extra effects:

```stata
levelsof _id, local(lvls)

foreach x of local lvls {
	shapes round _y _x if _id==`x', round(1) n(20) factor(1.2) append	
}
```

And plot the figure:

```stata
local myarea
levelsof _rid, local(lvls) 
local items = `r(r)'


foreach x of local lvls {
		colorpalette CET L20, nograph  n(`items')
		
		local myarea `myarea' (area _ry _rx if _rid==`x', cmissing(no) nodropbase fi(100) fcolor("`r(p`x')'%100") lw(0.1) lc(white))
}
			
				
twoway `myarea'	///
	, legend(off)	///
	xsize(1) ysize(1) aspect(1)		///			
		xlabel(-20 20) ylabel(-20 20) ///
			xscale(off) yscale(off)	///
			xlabel(, nogrid) ylabel(, nogrid) 

```

<img src="/figures/example4_4.png" width="75%">




## Feedback

Please open an [issue](https://github.com/asjadnaqvi/stata-graphfunctions/issues) to report errors, feature enhancements, and/or other requests.


## Change log


**v1.6 (19 Nov 2025)**
- `shapes` updated to v1.4 to include better options for `shapes square`, `shapes pie`, `shapes cirle`, and `shapes rotate`. New commands include `shapes translate`, `shapes dilate`, `shapes stretch`, `shapes round`.
- `arc` updated with better options. `dropbase` added to ensure continuity across stacked arcs.
- New command `radscatter` added.
- Major rehaul of base routines, various bug fixes, better scripts that stack variables.


**v1.52 (18 Feb 2025)**
- `catspline` now generate the stated number of points.
- `catspline` now respects `if/in` conditions.
- Minor corrections and bug fixes.

**v1.51 (28 Nov 2024)**
- Fixed `catspline` to correct generate splines. Added options to replace variables. Change in routine to make it more efficient in computations.
- Added `replace`, `append` to `arc`. Various bug fixes.
- Added `append` as a substitute for `stack` in `shapes`. 
- Added `square` in `shapes.

**v1.5 (05 Nov 2024)**
- `shapes square` added for squares. Note that `shapes circle, n(4)` also returns a square but here we define the center-to-corner length using the radius, where as `shapes square` generates a side with a predefined length. Hence the area of `shapes circle, n(4) rad(5)` > `shapes square, len(5)`.
- `shapes rotate` added for generation rotations at specific points or center of shapes. Note that this is a more advanced rotation than what each individual function provides.
- `shapes area` added for calculating the areas (currently in undefined units) using [Meister's shoelace formula](https://en.wikipedia.org/wiki/Shoelace_formula). 
- Option `append` added as a substitute for `stack`. This is more in line with standard Stata syntax.
- Option `flip` added to change the drawing direction. This flips from counter-clockwise (Stata default) to clockwise.
- Better information added for rotations, orientations, and starting points.
- Cleanup of helpfiles.

**v1.4 (15 Oct 2024)**
- `shapes` is now also mirrored as `shape`.
- `shape circle` updated, and `shape pie` added.
- In `shapes`, users can now also define an origin using `x0()` and `y0()` options.
- More controls and checks.

**v1.3 (13 Oct 2024)**
- `shapes` added. Minor fixes to index tracking.
- `arc` bug fixes plus code cleanup.

**v1.2 (08 Oct 2024)**
- `arc` added.
- Bug fixes in `labsplit`.
- Additional checks in programs.

**v1.1 (04 Oct 2024)**
- `catspline` added.

**v1.0 (28 Sep 2024)**
- `labsplit` added.
- Public release.







