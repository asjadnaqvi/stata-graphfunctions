{smcl}
{* 08Mar2026}{...}
{hi:help labrepel}{...}
{right:{browse "https://github.com/asjadnaqvi/stata-graphfunctions":graphfunctions (GitHub)}}

{hline}

{it:(back to {stata help graphfunctions})}

{title:labrepel}: is a Stata program for automatically repositioning point labels using a force-directed algorithm.

{p 4 4 2}
The command takes a y-x coordinate pair and a label variable, then creates adjusted coordinates in {it:_xcoord} and {it:_ycoord}.
It is designed for crowded scatter plots where labels overlap and manual adjustment is not practical.


{marker syntax}{title:Syntax}


{cmd:labrepel} {it:yvar xvar} {ifin}, {opt lab:el}({varname})
		{cmd:[} {opt boxpad:ding(num)} {opt push(num)}{opt pull(num)} {opt damping(num)} {opt cooling(num)} {opt maxit:er(int)} {opt maxt:ime(num)} {opt maxo:verlaps(int)} 
		  {opt maxd:isplacement(num)} {opt nudgex(num)} {opt nudgey(num)} {opt dir:ection(str)} {opt seed(int)} {opt jitter(num)} {opt xlim:it(min max)} {opt ylim:it(min max)}
		  {opt xsize(num)} {opt ysize(num)} {opt plotxs:ize(num)} {opt plotys:ize(num)} {opt mlabs:ize(num)} {opt hjust(num)} {opt vjust(num)} {opt center} {opt nodetail} {cmd:]} 


{marker options}{title:Options}

{synoptset 30 tabbed}{...}

{marker required}{dlgtab:Required}

{p2coldent : {opt labrepel} yvar xvar}The command requires two numeric variables in y-x order for label anchor positions.{p_end}

{p2coldent : {cmdab:lab:el(varname)}}String variable containing label text. Empty labels are ignored.{p_end}


{marker force}{dlgtab:Force parameters}

{p2coldent : {opt boxpad:ding(num)}}Padding around label bounding boxes. Higher values add more spacing. Default is {opt boxpadding(0.05)}.{p_end}

{p2coldent : {opt push(num)}}Repulsion strength for overlapping labels. Higher values push labels apart more strongly. Default is {opt push(1)}.{p_end}

{p2coldent : {opt pul:l(num)}}Attraction strength pulling labels toward original positions (or away from center with {opt center}). Default is {opt pull(1.5)}.{p_end}

{p2coldent : {opt dam:ping(num)}}Movement damping factor. Lower values move labels more slowly and smoothly. Default is {opt damping(0.3)}.{p_end}

{p2coldent : {opt cool:ing(num)}}Minimum cooling factor as iterations progress. Default is {opt cooling(0.2)}.{p_end}


{marker control}{dlgtab:Algorithm control}

{p2coldent : {opt maxit:er(int)}}Maximum number of iterations. The algorithm may converge earlier. Default is {opt maxiter(200)}.{p_end}

{p2coldent : {opt maxt:ime(num)}}Maximum runtime in seconds. Default is {opt maxtime(30)}.{p_end}

{p2coldent : {opt maxo:verlaps(int)}}Threshold used in overlap warnings in detailed output. Default is {opt maxoverlaps(10)}.{p_end}

{p2coldent : {opt maxd:isplacement(num)}}Maximum displacement as a fraction of data range. Default {opt maxdisplacement(0)} applies an internal 10% range cap.{p_end}

{p2coldent : {opt jit:ter(num)}}Random perturbation for breaking symmetric force cancellation in dense clusters. Default is {opt jitter(0)}.{p_end}

{p2coldent : {opt seed(int)}}Random seed used with {opt jitter()} for reproducible placement.{p_end}


{marker position}{dlgtab:Position control}

{p2coldent : {opt nudgex(num)}, {opt nudgey(num)}}Initial global x and y offsets applied before optimization. Defaults are {opt nudgex(0)} and {opt nudgey(0)}.{p_end}

{p2coldent : {opt dir:ection(str)}}Restrict movement to {it:both} (default), {it:x}, or {it:y}.{p_end}

{p2coldent : {opt center}}Push labels away from plot center rather than pulling them toward original anchor points.{p_end}


{marker dimensions}{dlgtab:Plot dimensions}

{p2coldent : {opt xlim:it(min max)}, {opt ylim:it(min max)}}Explicit coordinate limits. If omitted, limits are computed from the estimation sample.{p_end}

{p2coldent : {opt xsize(num)}, {opt ysize(num)}}Declared graph dimensions in inches for converting label sizes to data units. Defaults are {opt xsize(5)} and {opt ysize(3)}.{p_end}

{p2coldent : {opt plotxsize(num)}, {opt plotysize(num)}}Actual plot area dimensions in inches. Use when plot region differs from total graph size. Defaults are {opt plotxsize(0)} and {opt plotysize(0)} (use xsize/ysize).{p_end}


{marker text}{dlgtab:Label size and alignment}

{p2coldent : {opt mlab:size(num)}}Label size multiplier used for bounding-box calculations. Default is {opt mlabsize(2.5)}.{p_end}

{p2coldent : {opt hjust(num)}, {opt vjust(num)}}Horizontal and vertical label justification in [0,1]. Default is {opt hjust(0.5)} and {opt vjust(0.5)}.{p_end}


{marker display}{dlgtab:Display}

{p2coldent : {opt nodetail}}Suppress detailed iteration diagnostics, overlap summaries, and force statistics. By default, detailed output is shown.{p_end}

{synoptline}
{p2colreset}{...}


{title:Stored results}

{pstd}
{cmd:labrepel} stores the following in {cmd:r()}:

{p2col 5 20 24 2: Local macros}{p_end}
{p2coldent:{cmd:r(n_labels)}}number of non-empty labels processed{p_end}
{p2coldent:{cmd:r(iterations)}}number of iterations completed{p_end}
{p2coldent:{cmd:r(direction)}}movement direction used ({it:both}, {it:x}, or {it:y}){p_end}

{p2col 5 20 24 2: Variables created}{p_end}
{p2coldent:{cmd:_xcoord}}adjusted x coordinates for label positions{p_end}
{p2coldent:{cmd:_ycoord}}adjusted y coordinates for label positions{p_end}


{title:Examples}

See {browse "https://github.com/asjadnaqvi/stata-graphfunctions":GitHub} for more examples.

{hline}

{title:Feedback}

Please submit bugs, errors, feature requests on {browse "https://github.com/asjadnaqvi/stata-graphfunctions/issues":GitHub} by opening a new issue.


{title:Package details}

Version      : {bf:labrepel} v1.0 in {stata help graphfunctions:graphfunctions}
This release : 08 Mar 2026
First release: 08 Mar 2026
Repository   : {browse "https://github.com/asjadnaqvi/stata-graphfunctions":GitHub}
Keywords     : Stata, graph, labels, repulsion, force-directed layout
License      : {browse "https://opensource.org/licenses/MIT":MIT}

Author       : {browse "https://github.com/asjadnaqvi":Asjad Naqvi}
E-mail       : asjadnaqvi@gmail.com
Twitter/X    : {browse "https://x.com/AsjadNaqvi":@AsjadNaqvi}


{title:Citation guidelines}

Visit {browse "https://ideas.repec.org/c/boc/bocode/s459379.html"} for the official SSC citation.
Please note that the GitHub version might be newer than the SSC version.


{title:Other visualization packages}

{psee}
    {helpb arcplot}, {helpb alluvial}, {helpb bimap}, {helpb bumparea}, {helpb bumpline}, {helpb circlebar}, {helpb circlepack}, {helpb clipgeo}, {helpb delaunay}, {helpb graphfunctions},
	{helpb geoboundary}, {helpb geoflow}, {helpb joyplot}, {helpb marimekko}, {helpb polarspike}, {helpb sankey}, {helpb schemepack}, {helpb spider}, {helpb splinefit}, {helpb streamplot},
	{helpb sunburst}, {helpb ternary}, {helpb tidytuesday}, {helpb treecluster}, {helpb treemap}, {helpb trimap}, {helpb waffle}, {helpb vcontrol}

Visit {browse "https://github.com/asjadnaqvi":GitHub} for further details.

