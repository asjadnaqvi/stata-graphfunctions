{smcl}
{* 08Oct2024}{...}
{hi:help arc}{...}
{right:{browse "https://github.com/asjadnaqvi/stata-graphfunctions":graphfunctions v1.2 (GitHub)}}

{hline}

{title:arc}: A program for generating arcs between two points. 

The program inputs two pairs of coordinates ({it:x1, y1}) and ({it:x2, y2}) and outputs points for the arc segment in variables {it:_x, _y}.
The program is {stata help return:r-class} so type {stata return list} after running the command to see the stored locals.

{marker syntax}{title:Syntax}

{p 8 15 2}
{cmd:arc}, {cmd:x1}({it:num}) {cmd:y1}({it:num}) {cmd:x2}({it:num}) {cmd:y2}({it:num}) {cmd:[} {cmdab:rad:ius}({it:num}) {cmd:n}({it:int}) {cmd:swap} {cmd:major} {cmdab:genx}({it:newvar}) {cmdab:geny}({it:newvar}) {cmd:replace} {cmd:]}


{synoptset 36 tabbed}{...}
{synopthdr}
{synoptline}

{p2coldent : {opt arc}, x1() y1() x2() y2()}Input two coordinate pairs.{p_end}

{p2coldent : {opt rad:ius(num)}}Specify the radius length. Must be at least equal to half the chord length. Stored in local {it:r(chord)}. Default is the chord length.{p_end}

{p2coldent : {opt n(int)}}Number of points to generate for each arc. Default is {opt n(80)}, Must be great or equal to 5.{p_end}

{p2coldent : {opt swap}}Swap the arc side. Arcs are, by default, oriented to the right of the line starting at ({it:x1, y1}) and ending at ({it:x2, y2}).
Or the arc circumcenter is to the left of the line.{p_end}

{p2coldent : {opt major}}Draw a major arc around the circumcenter rather than the default minor arc.{p_end}

{p2coldent : {opt genx(newvar)} {opt geny(newvar)}}Custom names for the generated {it:x,y} variables.
Defaults are {it: _x, _y}.{p_end}

{p2coldent : {opt replace}}Overwrite the generated variables if they exist. Use carefully.{p_end}

{synoptline}
{p2colreset}{...}


{title:Examples}

Generate data:
{stata clear}
{stata arc, y1(-2) x1(-4) y2(4) x2(2) rad(6)}
{stata return list}
{stata twoway (scatteri -2 -4) (scatteri 4 2) (scatteri `r(ycirc)' `r(xcirc)') (line _y _x), legend(order(1 "Point 1" 2 "Point 2" 3 "Circumcenter" 4 "Arc") pos(6) row(1)) xlabel(-10(2)10) ylabel(-10(2)10) aspect(1) xsize(1) ysize(1)}

More examples on {browse "https://github.com/asjadnaqvi/stata-graphfunctions":GitHub}.


{title:Package details}

Version      : {bf:arc} v1.0 in {stata help graphfunctions:graphfunctions}
This release : 08 Oct 2024
First release: 08 Oct 2024
Repository   : {browse "https://github.com/asjadnaqvi/stata-graphfunctions":GitHub}
Keywords     : Stata, graph, arcs
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



