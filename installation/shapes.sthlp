{smcl}
{* 19Nov2025}{...}
{hi:help shapes (v1.4): 19 Nov 2025}{...}
{right:{browse "https://github.com/asjadnaqvi/stata-graphfunctions":graphfunctions (GitHub)}}

{hline}

{it:(Back to {stata help graphfunctions})}

{title:shapes}: A program for generating, transforming, and calculating features of shapes.

{it:Notes:}
1. {cmd:shape} can also be used as a substitute for {cmd:shapes}.
2. All shapes start at the 3 o'clock position (Stata default) relative to the origin.
3. All shapes are drawn counter-clockwise. Option {opt flip} can be used to change the drawing orientation in some programs.
4. The default origin is {it:(0,0)} and can be modified in some programs.
5. Rotation is around the origin by default but can be modified in {cmd shapes rotate}.
6. Positive rotation values will result in counter-clockwise rotations (Stata default). Negative angles are therefore clockwise.
7. Each shape generation will create four variables {cmd:_x}, {cmd:_y}, {cmd:_id}, and {cmd:_order}. These represent the x, y coordinates, shape identifier, and point order respectively.
Changing or resorting these variables could result in irregular shapes. So modify carefully. 

This program is currenly {it:beta} and not all checks and balances have been added. Please report bugs to help improve the program.

{marker syntax}{title:Syntax}


{pstd}
Generating shapes:

{p 8 15 2}
{cmd:shapes} circle, {cmd:[} {help shapes##circle:{it:circle options}} {cmd:]} 

{p 8 15 2}
{cmd:shapes} pie,    {cmd:[} {help shapes##pie:{it:pie options}} {cmd:]} 

{p 8 15 2}
{cmd:shapes} square, {cmd:[} {help shapes##square:{it:square options}}  {cmd:]} 


{pstd}
Transforming shapes:

{p 8 15 2}
{cmd:shapes} translate y x, {cmd:[} {help shapes##translate:{it:translate options}} {cmd:]} 

{p 8 15 2}
{cmd:shapes} dilate y x, {cmd:[} {help shapes##dilate:{it:dilate options}} {cmd:]} 

{p 8 15 2}
{cmd:shapes} stretch y x, {cmd:[} {help shapes##stretch:{it:stretch options}} {cmd:]} 

{p 8 15 2}
{cmd:shapes} rotate y x, {cmd:[} {help shapes##rotate:{it:rotate options}} {cmd:]} 

{p 8 15 2}
{cmd:shapes} round y x, {cmd:[} {help shapes##round:{it:round options}} {cmd:]} 


{pstd}
Calculating shape features:

{p 8 15 2}
{cmd:shapes} area y x, {opt by(variable)} {cmd:[} {help shapes##area:{it:area options}} {cmd:]} 


{marker circle}{title:circle}

{p 4 15 2}
{cmd:shapes} circle, {opt rad:ius(num)} {cmd:[} {opt x0(num)} {opt y0(num)} {opt n(int)} {opt ro:tate(degrees)} {opt genx(var)} {opt geny(var)} {opt genid(var)} {opt genorder(var)} {opt replace} {opt append} {cmd:]} 

{synoptset 28 tabbed}{...}
{synopthdr:circle_options}
{synoptline}
{p2coldent : {opt rad:ius(num)}}Specify the radius length. Radius has to be greater than 0.{p_end}

{p2coldent : {opt x0(num)}, {opt y0(num)}}Specify the center points. Defaults are {opt x0(0)} and {opt y0(0)}.{p_end}

{p2coldent : {opt n(int)}}Number of points to evaluate for the shape. Default is {opt n(100)}. Smaller values, e.g. {opt n(6)} will generate a hexagon.{p_end}

{p2coldent : {opt ro:tate(degrees)}}Rotate the shape counter clockwise by {it:degrees}. Default is {opt ro(0)}.{p_end}


{p2coldent : {opt genx(var)}}Custom name for the {opt _x} variable.{p_end}

{p2coldent : {opt geny(var)}}Custom name for the {opt _y} variable.{p_end}

{p2coldent : {opt genorder(var)}}Custom name for the {opt _order} variable.{p_end}

{p2coldent : {opt genid(var)}}Custom name for the {opt _id} variable.{p_end}

{p2coldent : {opt replace}}Replace the variables.{p_end}

{p2coldent : {opt append}}Append the variables.{p_end}
{synoptline}


{marker pie}{title:pie}

{p 4 15 2}
{cmd:shapes} pie, {opt rad:ius(num)} {opt end(degrees)} {cmd:[} {opt start(degrees)} {opt x0(num)} {opt y0(num)} {opt n(int)} {opt ro:tate(degrees)} {opt dropbase} {opt flip}
{opt genx(var)} {opt geny(var)} {opt genid(var)} {opt genorder(var)} {opt replace} {opt append} {cmd:]} 

{synoptset 28 tabbed}{...}
{synopthdr:pie_options}
{synoptline}
{p2coldent : {opt rad:ius(num)}}Specify the radius length..{p_end}

{p2coldent : {opt start(degrees)}}Starting angle of the pie arc. Default is {opt start(0)}.{p_end}

{p2coldent : {opt end(degrees)}}Ending angle of the pie arc. Default is {opt end(30)}.{p_end}

{p2coldent : {opt n(int)}}Number of points to evaluate for the arc. Default is {opt n(30)}.{p_end}

{p2coldent : {opt ro:tate(degrees)}}Rotate the shape by {it:degrees}. Default is {opt ro(0)}.{p_end}

{p2coldent : {opt x0(num)}, {opt y0(num)}}Points of the arc origin. Defaults are {opt x0(0)} and {opt y0(0)}.{p_end}

{p2coldent : {opt dropbase}}Drop the pie starting values (x0,y0), or, just generate an arc.{p_end}

{p2coldent : {opt flip}}Flips the drawing direction to clockwise.{p_end}


{p2coldent : {opt genx(var)}}Custom name for the {opt _x} variable.{p_end}

{p2coldent : {opt geny(var)}}Custom name for the {opt _y} variable.{p_end}

{p2coldent : {opt genorder(var)}}Custom name for the {opt _order} variable.{p_end}

{p2coldent : {opt genid(var)}}Custom name for the {opt _id} variable.{p_end}

{p2coldent : {opt replace}}Replace the variables.{p_end}

{p2coldent : {opt append}}Append the variables.{p_end}
{synoptline}


{marker square}{title:square}

{p 4 15 2}
{cmd:shapes} square, {cmd:[} {opt len:gth(num)} {opt x0(num)} {opt y0(num)} {opt ro:tate(degrees)} {opt genx(var)} {opt geny(var)} {opt genid(var)} {opt genorder(var)} {opt replace} {opt append} {cmd:]} 

{synoptset 28 tabbed}{...}
{synopthdr:square_options}
{synoptline}
{p2coldent : {opt len:gth(num)}}Specify the square edge length. Default is {opt len(10)}.{p_end}

{p2coldent : {opt x0(num)}, {opt y0(num)}}Center points. If center points are not specified, then the bottom-left point of the square
will align to the origin (0,0).{p_end}

{p2coldent : {opt ro:tate(degrees)}}Rotate the shape by {it:degrees} at the origin (0,0).
For more advanced rotations, use the {cmd:shapes rotate} command.{p_end}


{p2coldent : {opt genx(var)}}Custom name for the {opt _x} variable.{p_end}

{p2coldent : {opt geny(var)}}Custom name for the {opt _y} variable.{p_end}

{p2coldent : {opt genorder(var)}}Custom name for the {opt _order} variable.{p_end}

{p2coldent : {opt genid(var)}}Custom name for the {opt _id} variable.{p_end}

{p2coldent : {opt replace}}Replace the variables.{p_end}

{p2coldent : {opt append}}Append the variables.{p_end}
{synoptline}


{marker translate}{title:translate}

{p 4 15 2}
{cmd:shapes} translate <yvar> <xvar> {ifin}, {cmd:[} {opt x(num)} {opt y(num)} {opt genx(var)} {opt geny(var)} {opt replace} {cmd:]} 

{synoptset 28 tabbed}{...}
{synopthdr:translate_options}
{synoptline}
{p2coldent : {opt x(num)}}Displace the x-axis coordinates.{p_end}

{p2coldent : {opt y(num)}}Displace the y-axis coordinates.{p_end}


{p2coldent : {opt genx(var)}}Custom name for the {opt _x} variable.{p_end}

{p2coldent : {opt geny(var)}}Custom name for the {opt _y} variable.{p_end}

{p2coldent : {opt replace}}Replace the variables.{p_end}
{synoptline}


{marker dilate}{title:dilate}

{p 4 15 2}
{cmd:shapes} dilate <yvar> <xvar> {ifin}, {cmd:[} {opt f:actor(num)} {opt genx(var)} {opt geny(var)} {opt replace} {cmd:]} 

{synoptset 28 tabbed}{...}
{marker dilate}{synopthdr:dilate_options}
{synoptline}
{p2coldent : {opt f:actor(num)}}Multiply the x- and y-axis coordinates by {opt f()}.{p_end}


{p2coldent : {opt genx(var)}}Custom name for the {opt _x} variable.{p_end}

{p2coldent : {opt geny(var)}}Custom name for the {opt _y} variable.{p_end}

{p2coldent : {opt replace}}Replace the variables.{p_end}
{synoptline}


{marker stretch}{title:stretch}

{p 4 15 2}
{cmd:shapes} stretch <yvar> <xvar> {ifin}, {cmd:[} {opt x(num)} {opt y(num)} {opt replace} {cmd:]} 

{synoptset 28 tabbed}{...}
{marker stretch}{synopthdr:stretch_options}
{synoptline}
{p2coldent : {opt x(num)}}Stretch (or shrink) x-axis coordinates by {opt x()} factor.{p_end}

{p2coldent : {opt y(num)}}Stretch (or shrink) y-axis coordinates by {opt y()} factor.{p_end}

{p2coldent : {opt replace}}Replace the orginal variables.{p_end}

{synoptline}


{marker rotate}{title:rotate}

{p 4 15 2}
{cmd:shapes} rotate <yvar> <xvar> {ifin}, {cmd:[} {opt ro:tate(degrees)} {opt x0(num)} {opt y0(num)} {opt center} {opt genx(var)} {opt geny(var)} {opt replace} {cmd:]} 

{synoptset 28 tabbed}{...}
{marker rotate}{synopthdr:rotate_options}
{synoptline}
{p2coldent : {opt ro:tate(degrees)}}Rotate the shape by {it:degrees} at the center. Default is {opt ro(30)}.{p_end}

{p2coldent : {opt x0(num)}, {opt y0(num)}}Rotation points. Defaults are {opt x0(0)} and {opt y0(0)}.{p_end}

{p2coldent : {opt center}}Rotate on the mean coordinates of the shape. For regular shapes this should be the center point.{p_end}

{p2coldent : {opt by(variable)}}Rotate each {opt by()} level individual. Can only be combined with {opt center}.{p_end}


{p2coldent : {opt genx(var)}}Custom name for the {opt _x_rot} variable.{p_end}

{p2coldent : {opt geny(var)}}Custom name for the {opt _y_rot} variable.{p_end}

{p2coldent : {opt replace}}Replace the variables.{p_end}

{synoptline}


{marker round}{title:round}

{p 4 15 2}
{cmd:shapes} round <yvar> <xvar> {ifin}, {opt r:oundness(num)} {cmd:[} {opt n(num)} {opt f:actor(num)} {opt genx(var)} {opt geny(var)} {opt genid(var)} {opt genorder(var)} {opt gensegvar(var)} {opt replace} {opt append}  {cmd:]} 

{synoptset 28 tabbed}{...}
{marker round}{synopthdr:round_options}
{synoptline}
{p2coldent : {opt r:oundness(num)}}Size of the rounded edge in pixels. This should be less than half the length of two segments whose 
connecting point is being rounded. For example, if we draw a square of length 10 and specifiy {opt r(5)}, then we effectively end up
with a circle.{p_end}

{p2coldent : {opt n(num)}}Number of points to generate for each rounded edge. Default is {opt n(20)}.{p_end}

{p2coldent : {opt f:actor(num)}}Factor is the displacement of the point which is used as a reference to draw the arc of size {opt r()}.
The default here is kept at {opt f(1.3)}. If the edges are not 90 degrees, especially higher, 
then this might make the rounded part look like it is bulging out. In this case, this parameter
can be used for fine-tuning the figure.{p_end}


{p2coldent : {opt genx(var)}}Custom name for the {opt _rx} variable.{p_end}

{p2coldent : {opt geny(var)}}Custom name for the {opt _ry} variable.{p_end}

{p2coldent : {opt genorder(var)}}Custom name for the {opt _rorder} variable.{p_end}

{p2coldent : {opt genid(var)}}Custom name for the {opt _rid} variable.{p_end}

{p2coldent : {opt gensegvar(var)}}Custom name for the {opt _rsegvar} variable. This is the order of drawing for each shape segment.{p_end}

{p2coldent : {opt replace}}Replace the variables.{p_end}

{p2coldent : {opt append}}Append the variables.{p_end}
{synoptline}


{marker area}{title:area}

{p 4 15 2}
{cmd:shapes} area <yvar> <xvar>, {cmd:[} {opt by(var} {opt gen:erate(var)} {opt replace} {cmd:]} 

{synoptset 28 tabbed}{...}
{marker area}{synopthdr:area_options}
{synoptline}
{p2coldent : {opt by(var)}}Generate areas using a {opt by()} variable. This is usually the {opt by(_id)} variable.{p_end}

{p2coldent : {opt gen:erate(newvar)}}Generate a new variable for the area values. Default is {it:_area}.{p_end}

{p2coldent : {opt replace}}Replace the variables.{p_end}
{synoptline}



{p2colreset}{...}


{title:Examples}

See {browse "https://github.com/asjadnaqvi/stata-graphfunctions":GitHub} for a comprehensive set of examples.


{title:Package details}

Version      : {bf:shapes} v1.4 in {stata help graphfunctions:graphfunctions}
This release : 19 Nov 2025
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

Visit {browse "https://ideas.repec.org/c/boc/bocode/s459379.html"} for the official SSC citation. 
Please note that the GitHub version might be newer than the SSC version.


{title:Other packages}

{psee}
    {helpb arcplot}, {helpb alluvial}, {helpb bimap}, {helpb bumparea}, {helpb bumpline}, {helpb circlebar}, {helpb circlepack}, {helpb clipgeo}, {helpb delaunay}, {helpb graphfunctions}, {helpb joyplot}, 
	{helpb marimekko}, {helpb polarspike}, {helpb sankey}, {helpb schemepack}, {helpb spider}, {helpb splinefit}, {helpb streamplot}, {helpb sunburst}, {helpb ternary}, {helpb treecluster}, {helpb treemap}, {helpb trimap}, {helpb waffle}

or visit {browse "https://github.com/asjadnaqvi":GitHub}.



