*! labrepel v1.0 (08 Mar 2026)
*! Asjad Naqvi (asjadnaqvi@gmail.com)

* v1.0 (08 Mar 2026): initial release with core functionality and basic options

cap program drop labrepel

program labrepel, rclass
    version 11

    syntax varlist(numeric min=2 max=2) [if] [in], LABel(varname string) ///
        [ BOXPADding(real 0.05) push(real 3) pull(real 1.5) DAMPing(real 0.3) COOLing(real 0.2) ///
			MAXTime(real 10) MAXIter(integer 50) MAXOverlaps(integer 10) nudgex(real 0) nudgey(real 0) ///
			XLIMit(numlist min=2 max=2) YLIMit(numlist min=2 max=2) ///
			DIRection(string) SEED(numlist max=1 >0) HJust(real 0.5) VJust(real 0.5) MLABSize(real 2.5) ///
			MAXDISPlacement(real 0) JITter(real 0) nodetail xsize(real 5) ysize(real 3) center ///
        ]

    return local date 		20260308
	return local version 	1.7

    marksample touse
    quietly count if `touse'
    if r(N) == 0 {
        di as error "No observations"
        exit 2000
    }

    tokenize `varlist'
    local yvar `1'
    local xvar `2'

    * direction
    if "`direction'" == "" local direction "both"
    else {
        if !inlist("`direction'", "both", "x", "y") {
            di as error "Direction must be 'both', 'x', or 'y'"
            exit 198
        }
    }

    * limits
    if "`xlimit'" != "" {
        numlist "`xlimit'"
        tokenize `r(numlist)'
        local xmin `1'
        local xmax `2'
    }
    else {
        quietly summarize `xvar' if `touse', meanonly
        local xmin = r(min)
        local xmax = r(max)
    }

    if "`ylimit'" != "" {
        numlist "`ylimit'"
        tokenize `r(numlist)'
        local ymin `1'
        local ymax `2'
    }
    else {
        quietly summarize `yvar' if `touse', meanonly
        local ymin = r(min)
        local ymax = r(max)
    }

    tempvar x_orig y_orig x_new y_new lab_width lab_height box_x1 box_x2 box_y1 box_y2 ///
            valid_label overlap_count net_fx net_fy obs_num dx_sign dy_sign

    * originals + new positions - create for ALL observations
    quietly {
        gen double `x_orig' = `xvar'
        gen double `y_orig' = `yvar'
        gen double `x_new'  = `xvar' + `nudgex'
        gen double `y_new'  = `yvar' + `nudgey'

        * get valid labels
        gen  `valid_label' = 0
        replace `valid_label' = 1 if `touse' & trim(`label') != ""
    }

    * ranges + scales
    local xrange = `xmax' - `xmin'
    local yrange = `ymax' - `ymin'

    local xcenter = (`xmin' + `xmax') / 2
    local ycenter = (`ymin' + `ymax') / 2

    local x_scale = `xrange' / `xsize'   // data units per inch
    local y_scale = `yrange' / `ysize'   


    * displacement 
    if `maxdisplacement' <= 0 {
        local max_disp_x = `xrange' * 0.1    // allow 10% of data range displacement by default
        local max_disp_y = `yrange' * 0.1    // prevents labels from flying to extremes
    }
    else {
        local max_disp_x = `maxdisplacement' * `xrange'
        local max_disp_y = `maxdisplacement' * `yrange'
    }

    * size of fonts. check and refine.
    local base_inches = 0.03       // base unit height (~5pt for mlabsize=1)
    local char_width_ratio = 0.25  // proportional font width/height ratio

    local font_in = `mlabsize' * `base_inches'
    local char_in = `font_in' * `char_width_ratio'
    local height_in = `font_in' * 1.2
    
    quietly {
        gen double `lab_width'   = strlen(`label') * `char_in' * `x_scale'
        gen double `lab_height'  = (`height_in' + 0.002 * (strlen(`label') - 1)) * `y_scale'

        * guardrails
        replace `lab_width'  = min(`lab_width',  0.06*`xrange')     if `valid_label'
        replace `lab_height' = min(`lab_height', 0.06*`yrange')     if `valid_label'
        
        
        replace `lab_width' = 0  if !`valid_label'
        replace `lab_height' = 0 if !`valid_label'

        * initialize boxes
        gen double `box_x1' = `x_new' - `lab_width'  * `hjust'        - `boxpadding'
        gen double `box_x2' = `x_new' + `lab_width'  * (1-`hjust')    + `boxpadding'
        gen double `box_y1' = `y_new' - `lab_height' * `vjust'        - `boxpadding'
        gen double `box_y2' = `y_new' + `lab_height' * (1-`vjust')    + `boxpadding'

        * overlap counters + force accumulators
        gen int    `overlap_count' = 0
        gen double `net_fx' = 0
        gen double `net_fy' = 0

        * list of valid obs indices
        gen long `obs_num' = .
        replace `obs_num' = _n if `valid_label'
        levelsof `obs_num', local(valid_obs) clean
    }
    
    local n_labels : word count `valid_obs'

    if "`nodetail'" == "" {
        di as text "Starting label repulsion algorithm..."
        di as text "  Number of valid labels: `n_labels'"
        di as text "  Plot dimensions: xsize=`xsize', ysize=`ysize'"
        di as text "  Direction: `direction'"
        di as text "  Push: `push'"
        di as text "  Pull: `pull'"
        di as text "  Damping factor: `damping'"
        di as text "  Cooling minimum: `cooling'"
		di as text "  Max displacement: `maxdisplacement'"  
		di as text "  Max iterations: `maxiter'"
        
        quietly sum `lab_width' if `valid_label', meanonly
        local avg_lw = r(mean)
        di as text "  Avg label width: " %9.1f `avg_lw' " (" %4.1f (`avg_lw'/`xrange'*100) "% of X range)"
        
        quietly sum `lab_height' if `valid_label', meanonly
        local avg_lh = r(mean)
        di as text "  Avg label height: " %9.1f `avg_lh' " (" %4.1f (`avg_lh'/`yrange'*100) "% of Y range)"
        
        di as text "  Data range X: [`xmin', `xmax'] (span: `xrange')"
        di as text "  Data range Y: [`ymin', `ymax'] (span: `yrange')"
    }

    * buffers 
    local xbuf = `xrange' * 0.05
    local ybuf = `yrange' * 0.05

    local iter = 0
    local max_time_ms = `maxtime' * 1000
    local start_time = clock(c(current_date)+" "+c(current_time), "DMY hms")

    while `iter' < `maxiter' {
        local iter = `iter' + 1
        local moved = 0
        local overlaps_found = 0

        * check if min/max functions are really needed
        local cooling_denominator = max(`maxiter' * 0.5, 1)
        
        if `maxiter' == 1 {
            local cooling_factor = max(`cooling', 0.5)  // allow reasonable progress in single iteration
        }
        else if `maxiter' <= 5 {
            local cooling_factor = max(`cooling', 0.2)  // more moderate for few iterations
        }
        else {
            local cooling_factor = max(`cooling', 1 - (`iter' / `cooling_denominator'))
        }

        * add time limits
        local current_time = clock(c(current_date)+" "+c(current_time), "DMY hms")
        local elapsed = (`current_time' - `start_time')
        if `elapsed' > `max_time_ms' & `max_time_ms' > 0 {
            if "`nodetail'" == "" di as text "Time limit reached at iteration `iter'"
            continue, break
        }

        if `n_labels' == 0 continue, break

        quietly {
            replace `overlap_count' = 0
            replace `net_fx' = 0
            replace `net_fy' = 0

            local idx_i = 0
            foreach i_obs of local valid_obs {
                local ++idx_i

                local x1_i = `box_x1'[`i_obs']
                local y1_i = `box_y1'[`i_obs']
                local x2_i = `box_x2'[`i_obs']
                local y2_i = `box_y2'[`i_obs']
                local xc_i = `x_new'[`i_obs']
                local yc_i = `y_new'[`i_obs']

                local idx_j = 0
                foreach j_obs of local valid_obs {
                    local ++idx_j
                    if `idx_i' >= `idx_j' continue

                    local x1_j = `box_x1'[`j_obs']
                    local y1_j = `box_y1'[`j_obs']
                    local x2_j = `box_x2'[`j_obs']
                    local y2_j = `box_y2'[`j_obs']
                    local xc_j = `x_new'[`j_obs']
                    local yc_j = `y_new'[`j_obs']

                    local overlap_x = (`x1_i' < `x2_j') & (`x2_i' > `x1_j')
                    local overlap_y = (`y1_i' < `y2_j') & (`y2_i' > `y1_j')

                    if `overlap_x' & `overlap_y' {
                        local ++overlaps_found

                        * Overlap depth in each dimension (how far boxes penetrate)
                        local overlap_w = min(`x2_i', `x2_j') - max(`x1_i', `x1_j')
                        local overlap_h = min(`y2_i', `y2_j') - max(`y1_i', `y1_j')
                        
                        * Normalize overlap by plot scale to get visual overlap (in inches): CHECK!
                        local overlap_w_norm = `overlap_w' / `x_scale'
                        local overlap_h_norm = `overlap_h' / `y_scale'
                        
                        * Direction: push i away from j based on center positions
                        local dx = `xc_i' - `xc_j'
                        local dy = `yc_i' - `yc_j'
                        
                        * Handle coincident centers with random jitter
                        if abs(`dx') < 1 & abs(`dy') < 1 {
                            local dx = (runiform() - 0.5) * `xrange' * 0.01
                            local dy = (runiform() - 0.5) * `yrange' * 0.01
                        }
                        
                        * Sign of displacement (+1 or -1)
                        local sx = cond(`dx' >= 0, 1, -1)
                        local sy = cond(`dy' >= 0, 1, -1)
                        
                        * Force = normalized overlap × push multiplier × cooling
                        local fx = `sx' * `push' * `overlap_w_norm' * `x_scale' * `damping' * `cooling_factor'
                        local fy = `sy' * `push' * `overlap_h_norm' * `y_scale' * `damping' * `cooling_factor'

                        if "`direction'" == "both" | "`direction'" == "x" {
                            replace `net_fx' = `net_fx' + `fx' in `i_obs'
                            replace `net_fx' = `net_fx' - `fx' in `j_obs'
                        }
                        if "`direction'" == "both" | "`direction'" == "y" {
                            replace `net_fy' = `net_fy' + `fy' in `i_obs'
                            replace `net_fy' = `net_fy' - `fy' in `j_obs'
                        }

                        replace `overlap_count' = `overlap_count' + 1 in `i_obs'
                        replace `overlap_count' = `overlap_count' + 1 in `j_obs'
                    }
                }
            }
            
            * Add random jitter for overlapping labels
            if `jitter' > 0 {
                foreach i_obs of local valid_obs {
                    local n_overlaps = `overlap_count'[`i_obs']
                    if `n_overlaps' > 0 {

                        local jit_magnitude = `jitter' * (0.1 + 0.05 * min(`n_overlaps', 10))
                        local jit_x = (runiform() - 0.5) * `lab_width'[`i_obs'] * `jit_magnitude'
                        local jit_y = (runiform() - 0.5) * `lab_height'[`i_obs'] * `jit_magnitude'
                        if "`direction'" == "both" | "`direction'" == "x" {
                            replace `net_fx' = `net_fx' + `jit_x' in `i_obs'
                        }
                        if "`direction'" == "both" | "`direction'" == "y" {
                            replace `net_fy' = `net_fy' + `jit_y' in `i_obs'
                        }
                    }
                }
            }

            * pull forces
            foreach i_obs of local valid_obs {
                if "`center'" != "" {
                    * Direction away from center
                    local dx0 = `x_new'[`i_obs'] - `xcenter'
                    local dy0 = `y_new'[`i_obs'] - `ycenter'
                }
                else {
                    * Direction toward original point
                    local dx0 = `x_orig'[`i_obs'] - `x_new'[`i_obs']
                    local dy0 = `y_orig'[`i_obs'] - `y_new'[`i_obs']
                }

                local dist0 = sqrt(`dx0'^2 + `dy0'^2)
                local n_overlaps = `overlap_count'[`i_obs']
                

                if `dist0' > 0.001 {
                    * Adaptive pull
                    if `n_overlaps' == 0 {
                        local overlap_factor = 1.0  // Pull non-overlapping labels STRONGLY back
                    }
                    else if `n_overlaps' == 1 {
                        local overlap_factor = 0.3  // Weaken pull for labels with some overlaps
                    }
                    else {
                        local overlap_factor = 0.1  // Minimal pull for heavily overlapped labels
                    }
                    local pull_mag = `pull' * `overlap_factor' * `cooling_factor'
                    local fx_pull = `pull_mag' * `dx0' / `dist0'
                    local fy_pull = `pull_mag' * `dy0' / `dist0'
                    
                    if "`direction'" == "both" | "`direction'" == "x" {
                        replace `net_fx' = `net_fx' + `fx_pull' in `i_obs'
                    }
                    if "`direction'" == "both" | "`direction'" == "y" {
                        replace `net_fy' = `net_fy' + `fy_pull' in `i_obs'
                    }
                }
            }

            * CHECK IF NEEDED!
            replace `net_fx' = 0 if missing(`net_fx')
            replace `net_fy' = 0 if missing(`net_fy')
            
            if "`direction'" == "both" | "`direction'" == "x" {
                replace `x_new' = `x_new' + `net_fx' if `valid_label'
            }
            if "`direction'" == "both" | "`direction'" == "y" {
                replace `y_new' = `y_new' + `net_fy' if `valid_label'
            }

            * movement flag 
            qui count if (abs(`net_fx')>1e-12 | abs(`net_fy')>1e-12) & `valid_label'
            if r(N) > 0 local moved = 1
            
            * Check for force convergence: exit early if all forces are negligible
            if `moved' == 0 & `iter' > 10 {
                if "`nodetail'" == "" di as text "All net forces negligible - converged at iteration `iter'"
                continue, break
            }


            if "`center'" != "" {

                * When center is specified: allow symmetric displacement capping
                cap drop `dx_sign' `dy_sign'
                gen int `dx_sign' = cond(`x_orig' >= `xcenter', 1, -1)
                gen int `dy_sign' = cond(`y_orig' >= `ycenter', 1, -1)
                * Set to 0 for non-labeled observations
                replace `dx_sign' = 0 if !`valid_label'
                replace `dy_sign' = 0 if !`valid_label'
                
                * X-direction: cap both away and toward center symmetrically
                replace `x_new' = `x_orig' + `dx_sign' * `max_disp_x' ///
                    if `valid_label' & `dx_sign' * (`x_new' - `x_orig') > `max_disp_x' & !missing(`x_new')
                replace `x_new' = `x_orig' - `dx_sign' * `max_disp_x' ///
                    if `valid_label' & `dx_sign' * (`x_new' - `x_orig') < 0 & abs(`x_new' - `x_orig') > `max_disp_x' & !missing(`x_new')
                
                * Y-direction: cap both away and toward center symmetrically
                replace `y_new' = `y_orig' + `dy_sign' * `max_disp_y' ///
                    if `valid_label' & `dy_sign' * (`y_new' - `y_orig') > `max_disp_y' & !missing(`y_new')
                replace `y_new' = `y_orig' - `dy_sign' * `max_disp_y' ///
                    if `valid_label' & `dy_sign' * (`y_new' - `y_orig') < 0 & abs(`y_new' - `y_orig') > `max_disp_y' & !missing(`y_new')
            }
            else {
                * Without center: simple symmetric displacement caps
                replace `x_new' = `x_orig' + `max_disp_x' if `valid_label' & `x_new' > `x_orig' + `max_disp_x'
                replace `x_new' = `x_orig' - `max_disp_x' if `valid_label' & `x_new' < `x_orig' - `max_disp_x'
                replace `y_new' = `y_orig' + `max_disp_y' if `valid_label' & `y_new' > `y_orig' + `max_disp_y'
                replace `y_new' = `y_orig' - `max_disp_y' if `valid_label' & `y_new' < `y_orig' - `max_disp_y'
            }

            * Update boxes
            replace `box_x1' = `x_new' - `lab_width'  * `hjust'        - `boxpadding' if `valid_label'
            replace `box_y1' = `y_new' - `lab_height' * `vjust'        - `boxpadding' if `valid_label'
            replace `box_x2' = `x_new' + `lab_width'  * (1-`hjust')    + `boxpadding' if `valid_label'
            replace `box_y2' = `y_new' + `lab_height' * (1-`vjust')    + `boxpadding' if `valid_label'
        }

        if `moved' == 0 {
            if "`nodetail'" == "" di as text "Converged at iteration `iter'"
            continue, break
        }

        if "`nodetail'" == "" & mod(`iter', 100) == 0 {
            qui sum `overlap_count' if `valid_label', meanonly
            local avg_over = r(mean)
            qui sum `net_fx' if `valid_label', meanonly
            local avg_fx = r(mean)
            qui sum `net_fy' if `valid_label', meanonly
            local avg_fy = r(mean)
            di as text "  Iteration `iter': `overlaps_found' overlapping pairs, avg overlaps/label: " %6.2f `avg_over'
            di as text "    Mean net force: X=" %9.4f `avg_fx' ", Y=" %9.4f `avg_fy'
            
            * Check for convergence: if net forces are essentially zero for most labels
            qui count if (abs(`net_fx') < 1e-10 | abs(`net_fy') < 1e-10) & `valid_label'
            local converged_count = r(N)
            if `converged_count' == `n_labels' {
                di as text "    All labels have zero net force - converged"
                continue, break
            }
        }
    }

    if "`nodetail'" == "" {
        di as text "Repulsion complete after `iter' iterations"
        count if `overlap_count' > `maxoverlaps' & `valid_label'
        if r(N) > 0 {
            di as text "Warning: " r(N) " labels still have >" `maxoverlaps' " overlaps"
        }
        
        * Diagnostic: check for problematic clustering
        sum `overlap_count' if `valid_label', meanonly
        local total_overlaps = r(sum) / 2  // divide by 2 since each pair is counted twice
        count if `overlap_count' > 0 & `valid_label'
        local labels_with_overlaps = r(N)
        
        if `labels_with_overlaps' == 0 {
            di as text "INFO: No overlapping labels found - excellent!"
        }
        else if `labels_with_overlaps' < `n_labels' * 0.1 {
            di as text "INFO: Only " `labels_with_overlaps' " labels have overlaps - very sparse data"
            di as text "      Consider reducing push() or increasing plot size if clustering is observed"
        }
    }

    quietly {
        cap drop _xcoord
        cap drop _ycoord
        gen double _xcoord = .
        gen double _ycoord = .
        replace _xcoord = `x_new' if `valid_label'
        replace _ycoord = `y_new' if `valid_label'
        label variable _xcoord "Repelled x position"
        label variable _ycoord "Repelled y position"
    }

    return local n_labels `n_labels'
    return local iterations `iter'
    return local direction "`direction'"


end
