{smcl}
{* 05Nov2024}{...}
{hi:help shapes}{...}
{right:{browse "https://github.com/asjadnaqvi/stata-graphfunctions":graphfunctions (GitHub)}}

{hline}

{title:shapes}: A program for generating, transforming, and calculating features of shapes.

{it:Notes:}
1. {cmd:shape} can also be used as a substitute for {cmd:shapes}.
2. All shapes start at the 3 o' clock position (Stata default) relative to the origin.
3. All shapes are drawn counter-clockwise. Option {opt flip} can be used to change the drawing orientation in some cases.
4. The default origin is {cmd:(0,0)}.
5. Rotation is always around the origin.
6. Positive rotation values will result in counter-clockwise adjustments (Stata default). Negative angles are therefore clockwise.
7. Each shape will generate four variables {cmd:_x}, {cmd:_y}, {cmd:_order}, and {cmd:_id}. These represent the coordinates, point order, and shape identifier respectively.

This program is currenly {it:beta} and does not have all the checks.

{marker syntax}{title:Syntax}

{pstd}
Generating shapes:

{p 8 15 2}
{cmd:shapes} circle, {cmd:[} {help shapes##circle:{it:circle_options}} {help shapes##common:{it:common_options}} {cmd:]} 

{p 8 15 2}
{cmd:shapes} pie,    {cmd:[} {help shapes##pie:{it:pie_options}} {help shapes##common:{it:common_options}} {cmd:]} 

{p 8 15 2}
{cmd:shapes} square, {cmd:[} {help shapes##square:{it:square_options}} {help shapes##common:{it:common_options}} {cmd:]} 


{pstd}
Transforming shapes:

{p 8 15 2}
{cmd:shapes} rotate y x, {opt ro:tate(degrees)} {cmd:[} {help shapes##rotate:{it:rotate_options}} {cmd:]} 


{pstd}
Calculating shape features:

{p 8 15 2}
{cmd:shapes} area y x, {opt by(variable)} {cmd:[} {help shapes##area:{it:area_options}} {cmd:]} 



{synoptset 36 tabbed}{...}
{marker circle}{synopthdr:circle_options}
{synoptline}

{p2coldent : {opt rad:ius(num)}}Specify the radius length. Default is {opt rad(10)}.{p_end}

{p2coldent : {opt n(int)}}Number of points to evaluate for the shape. Default is {opt n(100)}. Smaller values, e.g. {opt n(6)} will generate a hexagon.{p_end}

{p2coldent : {opt ro:tate(degrees)}}Rotate the shape counter-clockwise by {it:degrees}. Default is {opt ro(0)}.{p_end}

{p2coldent : {opt x0(num)}, {opt y0(num)}}Center points. Defaults are {opt x0(0)} and {opt y0(0)}.{p_end}

{synoptline}



{synoptset 36 tabbed}{...}
{marker pie}{synopthdr:pie_options}
{synoptline}

{p2coldent : {opt start(degrees)}}Starting angle of the pie arc. Default is {opt start(0)}.{p_end}

{p2coldent : {opt end(degrees)}}Ending angle of the pie arc. Default is {opt end(30)}.{p_end}

{p2coldent : {opt rad:ius(num)}}Specify the radius length. Default is {opt rad(10)}.{p_end}

{p2coldent : {opt n(int)}}Number of points to evaluate for the arc. Default is {opt n(30)}.{p_end}

{p2coldent : {opt ro:tate(degrees)}}Rotate the shape by {it:degrees}. Default is {opt ro(0)}.{p_end}

{p2coldent : {opt x0(num)}, {opt y0(num)}}Points of the arc origin. Defaults are {opt x0(0)} and {opt y0(0)}.{p_end}

{p2coldent : {opt dropbase}}Drop the pie starting values (x0,y0), or, just generate an arc.{p_end}

{p2coldent : {opt flip}}Flips the drawing direction to clockwise.{p_end}

{synoptline}



{synoptset 36 tabbed}{...}
{marker square}{synopthdr:square_options}
{synoptline}

{p2coldent : {opt x0(num)}, {opt y0(num)}}Center points. Defaults are {opt x0(0)} and {opt y0(0)}.{p_end}

{p2coldent : {opt len:gth(num)}}Specify the square edge length. Default is {opt len(10)}.{p_end}

{p2coldent : {opt ro:tate(degrees)}}Rotate the shape by {it:degrees} at the center. Default is {opt ro(0)}.{p_end}

{synoptline}



{synoptset 36 tabbed}{...}
{marker common}{synopthdr:common_options}
{synoptline}

{p2coldent : {opt genx(newvar)}, {opt geny(newvar)}}Custom names for the {cmd:_x} and {cmd:_y} variables.{p_end}

{p2coldent : {opt genorder(newvar)}}Custom name for the {cmd:_order} variable.{p_end}

{p2coldent : {opt genid(newvar)}}Custom name for the {cmd:_id} variable.{p_end}

{p2coldent : {opt stack} {it:or} {opt append}}Append the shape variables. Can be used for generating a set of shapes.{p_end}

{p2coldent : {opt replace}}Replace the variables.{p_end}

{synoptline}

{p2colreset}{...}



{synoptset 36 tabbed}{...}
{marker rotate}{synopthdr:rotate_options}
{synoptline}

{p2coldent : {opt shapes rotate y x, rotate(degrees)}}Minimum required syntax.{p_end}

{p2coldent : {opt ro:tate(degrees)}}Rotate the shape by {it:degrees} at the center. Default is {opt ro(30)}.{p_end}

{p2coldent : {opt x0(num)}, {opt y0(num)}}Rotation points. Defaults are {opt x0(0)} and {opt y0(0)}.{p_end}

{p2coldent : {opt center}}Rotate on the mean of {varlist} variables.{p_end}

{p2coldent : {opt by(variable)}}Rotate each {opt by()} level individual. Can only be combined with {opt center}.{p_end}

{p2coldent : {opt genx(newvar)}, {opt geny(newvar)}}Custom names for the {cmd:_x} and {cmd:_y} variables.{p_end}

{synoptline}



{synoptset 36 tabbed}{...}
{marker area}{synopthdr:area_options}
{synoptline}

{p2coldent : {opt shapes area y x, by(var)}}Minimum required syntax.{p_end}

{p2coldent : {opt by(variable)}}Generate areas using {by()}. For default variable names, this is the {opt by(_id)} variable.{p_end}

{p2coldent : {opt gen:erate(newvar)}}Custom name for the {cmd:_area} variable.{p_end}

{synoptline}




{title:Examples}

Please see {browse "https://github.com/asjadnaqvi/stata-graphfunctions":GitHub} for a comprehensive set of examples.

Circles:
{stata shape circle, n(8) ro(22.5) rad(8) replace}
{stata twoway (connected _y _x), xsize(1) ysize(1) aspect(1) xlabel(-10 10) ylabel(-10 10)}

Pies:
{stata shape pie, start(0) end(60) ro(30) rad(8) replace}
{stata twoway (area _y _x, fcolor(%90) cmissing(n) nodropbase), xsize(1) ysize(1) aspect(1) xlabel(-10 10) ylabel(-10 10)}



{title:Package details}

Version      : {bf:shapes} v1.3 in {stata help graphfunctions:graphfunctions}
This release : 05 Nov 2024
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



