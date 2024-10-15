{smcl}
{* 15Oct2024}{...}
{hi:help shapes}{...}
{right:{browse "https://github.com/asjadnaqvi/stata-graphfunctions":graphfunctions (GitHub)}}

{hline}

{title:shapes}: A program for generating shapes. 

{it:Notes:}
1. Users can also use {cmd:shape} as a substitute for {cmd:shapes}.
2. All shapes start at the 3 o' clock position (Stata default) relative to the origin of the shape.
3. The default origin ({it:x0,y0}) is (0,0).
4. Rotation is around the origin.
5. Positive rotations values will result in counter-clockwise adjustments (Stata default).


{marker syntax}{title:Syntax}

{pstd}
Currently two shapes are available:

{p 8 15 2}
{cmd:shape} circle, {cmd:[} {help shapes##circle:{it:circle_options}} {cmd:]} 

{p 8 15 2}
{cmd:shape} pie, {cmd:[} {help shapes##pie:{it:pie_options}} {cmd:]} 


{synoptset 36 tabbed}{...}
{marker circle}{synopthdr:circle_options}
{synoptline}

{p2coldent : {opt rad:ius(num)}}Specify the radius length. Default is {opt rad(10)}.{p_end}

{p2coldent : {opt n(int)}}Number of points to evaluate for the shape. Default is {opt n(6)} which generate a hexagon. Option {opt n(4)} will yield a square.{p_end}

{p2coldent : {opt ro:tate(degrees)}}Rotate the shape counter-clockwise by {it:degrees}. Default is {opt ro(0)}.{p_end}

{p2coldent : {opt x0(num)}, {opt y0(num)}}Center points. Defaults are {opt x0(0)}, {opt y0(0)}.{p_end}

{p2coldent : {opt genx(newvar)}, {opt geny(newvar)}}Custom names for {it: _x, _y} variables.{p_end}

{p2coldent : {opt genorder(newvar)}, {opt genid(newvar)}}Custom names for {it: _order, _id} variables.{p_end}

{p2coldent : {opt replace}}Replace the dataset.{p_end}

{p2coldent : {opt stack}}Stack the shapes. Can be used for generating a set of shapes.{p_end}

{synoptline}



{synoptset 36 tabbed}{...}
{marker pie}{synopthdr:pie_options}
{synoptline}

{p2coldent : {opt start(degrees)}}Starting angle of the pie arc. Default is {opt start(0)}.{p_end}

{p2coldent : {opt end(degrees)}}Ending angle of the pie arc. Default is {opt end(30)}.{p_end}

{p2coldent : {opt rad:ius(num)}}Specify the radius length. Default is {opt rad(10)}.{p_end}

{p2coldent : {opt n(int)}}Number of points to evaluate for the arc. Default is {opt n(30)}.{p_end}

{p2coldent : {opt ro:tate(degrees)}}Rotate the shape by {it:degrees}. Default is {opt ro(0)}.{p_end}

{p2coldent : {opt x0(num)}, {opt y0(num)}}Center points. Defaults are {opt x0(0)}, {opt y0(0)}.{p_end}

{p2coldent : {opt genx(newvar)}, {opt geny(newvar)}}Custom names for {it: _x, _y} variables.{p_end}

{p2coldent : {opt genorder(newvar)}, {opt genid(newvar)}}Custom names for {it: _order, _id} variables.{p_end}

{p2coldent : {opt replace}}Replace the dataset.{p_end}

{p2coldent : {opt stack}}Stack the shapes. Can be used for generating a set of shapes.{p_end}

{synoptline}
{p2colreset}{...}


{pstd}
Both commands generates four variables {it:_order}, {it:_id}, {it:_x}, {it:_y}.




{title:Examples}

Circles:
{stata shape circle, n(8) ro(22.5) rad(8) replace}
{stata twoway (connected _y _x), xsize(1) ysize(1) aspect(1) xlabel(-10 10) ylabel(-10 10)}

Pies:
{stata shape pie, start(0) end(60) ro(30) rad(8) replace}
{stata twoway (area _y _x, fcolor(%90) cmissing(n) nodropbase), xsize(1) ysize(1) aspect(1) xlabel(-10 10) ylabel(-10 10)}

More examples on {browse "https://github.com/asjadnaqvi/stata-graphfunctions":GitHub}.


{title:Package details}

Version      : {bf:shapes} v1.2 in {stata help graphfunctions:graphfunctions}
This release : 15 Oct 2024
First release: 11 Oct 2024
Repository   : {browse "https://github.com/asjadnaqvi/stata-graphfunctions":GitHub}
Keywords     : Stata, graph, shapes
License      : {browse "https://opensource.org/licenses/MIT":MIT}

Author       : {browse "https://github.com/asjadnaqvi":Asjad Naqvi}
E-mail       : asjadnaqvi@gmail.com
Twitter/X    : {browse "https://x.com/AsjadNaqvi":@AsjadNaqvi}


{title:Feedback}

Please submit bugs, errors, feature requests on {browse "https://github.com/asjadnaqvi/stata-graphfunctions/issues":GitHub} by opening a new issue.


{title:Citation guidelines}

See {stata help graphfunctions:graphfunctions}.


{title:Other packages}

{psee}
    {helpb arcplot}, {helpb alluvial}, {helpb bimap}, {helpb bumparea}, {helpb bumpline}, {helpb circlebar}, {helpb circlepack}, {helpb clipgeo}, {helpb delaunay}, {helpb graphfunctions}, {helpb joyplot}, 
	{helpb marimekko}, {helpb polarspike}, {helpb sankey}, {helpb schemepack}, {helpb spider}, {helpb splinefit}, {helpb streamplot}, {helpb sunburst}, {helpb ternary}, {helpb treecluster}, {helpb treemap}, {helpb trimap}, {helpb waffle}

or visit {browse "https://github.com/asjadnaqvi":GitHub}.



