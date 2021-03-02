
# Setup the UI integration with the DSx skin.
proc ::plugins::DYE::setup_ui_DSx {} {
	variable widgets 
	
	### DE1APP SPLASH PAGE ###
	#	add_de1_variable "splash" 1280 1200 -justify center -anchor "center" -font [::plugins::DGUI::get_font $::plugins::DGUI::font 12] \
	#		-fill $::plugins::DYE::settings(orange) -textvariable {$::plugins::DGUI::db_progress_msg}
	
	### DSx HOME PAGE ###
	# Shortcuts menu (EXPERIMENTAL)
	if { [info exists ::debugging] && $::debugging == 1 } {
		::plugins::DGUI::add_symbol $::DSx_standby_pages 100 60 bars -size small -has_button 1 \
			-button_cmd ::plugins::DYE::MENU::load_page
	#		add_de1_text "$::DSx_standby_pages" 100 60 -font fontawesome_reg_small -fill $::plugins::DGUI::font_color \
	#			-anchor "nw" -text $::plugins::DGUI::symbol_bars
	#		::add_de1_button "$::DSx_standby_pages" { ::plugins::DYE::MENU::load_page } 70 40 175 150
	}
	
	# Icon and summary of next shot description below the profile & specs for next shot (left side)
	set x [lindex $::plugins::DYE::settings(next_shot_DSx_home_coords) 0]
	set y [lindex $::plugins::DYE::settings(next_shot_DSx_home_coords) 1]
	if { $x > 0 && $y > 0 } {
		::plugins::DGUI::add_symbol $::DSx_standby_pages [expr {$x-360}] [expr {$y-35}] $::plugins::DYE::settings(describe_icon) \
			-size small
		set ::plugins::DYE::next_shot_desc [::plugins::DYE::define_next_shot_desc]
		set widgets(DSx_home_next_shot_desc) [add_de1_variable "$::DSx_standby_pages" $x $y -justify center \
			-anchor "center" -font [::plugins::DGUI::get_font $::plugins::DGUI::font 6] -fill $::plugins::DYE::settings(shot_desc_font_color) \
			-width [rescale_x_skin 500] -textvariable {$::plugins::DYE::next_shot_desc} ] 
		add_de1_button "$::DSx_standby_pages" { ::plugins::DYE::DE::load_page next } [expr {$x-400}] [expr {$y-75}] \
			[expr {$x+250}] [expr {$y+75}]
	}
	
	# Icon and summary of the current (last) shot description below the shot chart and steam chart (right side)
	set x [lindex $::plugins::DYE::settings(last_shot_DSx_home_coords) 0]
	set y [lindex $::plugins::DYE::settings(last_shot_DSx_home_coords) 1]
	if { $x > 0 && $y > 0 } {
		::plugins::DGUI::add_symbol $::DSx_standby_pages [expr {$x+300}] [expr {$y-35}] $::plugins::DYE::settings(describe_icon) \
			-size small		
		set ::plugins::DYE::last_shot_desc [::plugins::DYE::define_last_shot_desc]
		set widgets(DSx_home_last_shot_desc) [add_de1_variable "$::DSx_standby_pages" $x $y -justify center \
			-anchor "center" -font [::plugins::DGUI::get_font $::plugins::DGUI::font 6] -fill $::plugins::DYE::settings(shot_desc_font_color) \
			-width [rescale_x_skin 500] -textvariable {$::plugins::DYE::last_shot_desc} ]
		add_de1_button "$::DSx_standby_pages" { 
			if { $::settings(history_saved) == 1 && [info exists ::DSx_settings(live_graph_time)] } {
				::plugins::DYE::DE::load_page current
			} 		
			} [expr {$x-300}] [expr {$y-75}] [expr {$x+400}] [expr {$y+75}]
	}
		
	### HISTORY VIEWER PAGE ###
	# Show espresso summary description (beans, grind, TDS, EY and enjoyment), and make it clickable to show to full
	# espresso description.
	set widgets(DSx_past_shot_desc) [add_de1_variable "DSx_past" 40 850 -text "" \
		-font [::plugins::DGUI::get_font $::plugins::DGUI::font 7] -fill $::plugins::DYE::settings(shot_desc_font_color) \
		-anchor "nw" -justify left -width [rescale_x_skin 1100] \
		-textvariable {$::plugins::DYE::past_shot_desc} ]
	add_de1_button "DSx_past" { 
			if { [ifexists ::DSx_settings(past_shot_file) ""] ne "" } { ::plugins::DYE::DE::load_page DSx_past }	
		} 40 850 1125 975
		
	set widgets(DSx_past_shot_desc2) [add_de1_variable "DSx_past" 1300 850 -text "" \
		-font [::plugins::DGUI::get_font $::plugins::DGUI::font 7] -fill $::plugins::DYE::settings(shot_desc_font_color) \
		-anchor "nw" -justify left -width [rescale_x_skin 1100] -textvariable {$::plugins::DYE::past_shot_desc2}]
	add_de1_button "DSx_past" { 
		if { [ifexists ::DSx_settings(past_shot_file2) ""] ne "" } { ::plugins::DYE::DE::load_page DSx_past2 }
		} 1300 850 2400 975
	
	# Update left and right side shot descriptions when they change
	trace add execution ::load_DSx_past_shot {leave} { ::plugins::DYE::define_past_shot_desc }
	trace add execution ::load_DSx_past2_shot {leave} { ::plugins::DYE::define_past_shot_desc2 }
	trace add execution ::clear_graph {leave} { ::plugins::DYE::define_past_shot_desc2 }	
	
	# Search/filter button for left side
	add_de1_image "DSx_past" 935 1390 "[skin_directory_graphics]/icons/store_button.png"
	::plugins::DGUI::add_symbol "DSx_past" 977 1473 filter -size small 
#	add_de1_text "DSx_past" 977 1473 -font fontawesome_reg_small \
#		-fill $::DSx_settings(font_colour) -anchor "nw" -text $::plugins::DGUI::symbol_filter
	add_de1_variable "DSx_past" 1066 1495 -font [::plugins::DGUI::get_font $::plugins::DGUI::font 7] \
		-fill $::plugins::DGUI::font_color -anchor "center" \
		-justify "center" -textvariable {$::plugins::DYE::FSH::data(left_filter_status)} 
	add_de1_button "DSx_past" { 
		if { $::plugins::DYE::FSH::data(left_filter_status) eq "on" } {
			set ::plugins::DYE::FSH::data(left_filter_status) "off"
			unset -nocomplain ::DSx_filtered_past_shot_files
			fill_DSx_past_shots_listbox
		} else {
			::plugins::DYE::FSH::load_page
		}
		} 935 1400 1120 1575
	
	# Search/filter button for right side
	add_de1_image "DSx_past" 1435 1390 "[skin_directory_graphics]/icons/store_button.png"
	::plugins::DGUI::add_symbol "DSx_past" 1477 1473 filter -size small 		
#	add_de1_text "DSx_past" 1477 1473 -font fontawesome_reg_small \
#		-fill $::plugins::DGUI::font_color -anchor "nw" -text $::plugins::DGUI::symbol_filter
	add_de1_variable "DSx_past" 1566 1495 -font [::plugins::DGUI::get_font $::plugins::DGUI::font 7] \
		-fill $::DSx_settings(font_colour) -anchor "center" \
		-justify "center" -textvariable {$::plugins::DYE::FSH::data(right_filter_status)}
	add_de1_button "DSx_past" { 
		if { $::plugins::DYE::FSH::data(right_filter_status) eq "on" } {
			set ::plugins::DYE::FSH::data(right_filter_status) "off"
			unset -nocomplain ::DSx_filtered_past_shot_files2
			fill_DSx_past2_shots_listbox
		} else {
			::plugins::DYE::FSH::load_page 
		}
		} 1435 1400 1620 1575
	
	### FULL PAGE CHARTS FROM HISTORY VIEWER ###
	set widgets(DSx_past_zoomed_shot_desc) [add_de1_variable "DSx_past_zoomed" 1280 1535 \
		-font [::plugins::DGUI::get_font $::plugins::DGUI::font 7] -fill $::plugins::DYE::settings(shot_desc_font_color) \
		-anchor "center" -justify center -width [rescale_x_skin 2200] \
		-textvariable {$::plugins::DYE::past_shot_desc_one_line}]
	set widgets(DSx_past_zoomed_shot_desc2) [add_de1_variable "DSx_past2_zoomed" 1280 1535 \
		-font [::plugins::DGUI::get_font $::plugins::DGUI::font 7] -fill $::plugins::DYE::settings(shot_desc_font_color) \
		-anchor "center" -justify center -width [rescale_x_skin 2200] \
		-textvariable {$::plugins::DYE::past_shot_desc_one_line2}]
	trace add execution ::history_godshots_switch leave ::plugins::DYE::history_godshots_switch_leave_hook
	
	### SCREENSAVER ###
	# Makes the left side of the app screensaver clickable so that you can describe your last shot without waking up 
	# the DE1. Note that this would overlap with the DSx plugin management option, if enabled. Provided by Damian.
	if { $::plugins::DYE::settings(describe_from_sleep) == 1} {
		set sleep_describe_symbol $::plugins::DYE::settings(describe_icon)
		set sleep_describe_button_coords {230 0 460 230}
	} else { 
		set sleep_describe_symbol ""
		set sleep_describe_button_coords {0 0 0 0}
	}
	set widgets(describe_from_sleep_symbol) [add_de1_text "saver" 275 35 -font fontawesome_reg_big \
		-fill $::plugins::DGUI::font_color -anchor "nw" -text $sleep_describe_symbol]	
	set widgets(describe_from_sleep_button) [add_de1_button "saver" { ::plugins::DYE::DE::load_page current } \
		{*}$sleep_describe_button_coords]
	
	### DEBUG TEXT IN SOME PAGES ###
	# Show the debug text variable. Set it to any value I want to see on screen at the moment.
	if { $::DSx_skindebug == 1 } {
		add_de1_variable "$::plugins::DGUI::pages DSx_past $::DSx_standby_pages" \
			20 20 -font [::plugins::DGUI::get_font $::plugins::DGUI::font 7] -fill $::plugins::DGUI::remark_color \
			-anchor "nw" -textvariable {$::plugins::DYE::debug_text}
		#-textvariable {enjoyment=$::plugins::DYE::DE::data(espresso_enjoyment)}
		
		# Debug button/text to do some debugging action (current to go straight to the ::plugins::DYE::DE page)
		# TODO This is not working. Console hides in background as soon as focus is given to anything, and cannot
		#	get it back.
		#add_de1_text "$::DSx_home_pages" 2300 225 -font [::plugins::DGUI::get_font $::plugins::DGUI::font 7] -fill $::DSx_settings(orange) -anchor "nw" \
		#	-text "CONSOLE"
		#add_de1_button "$::DSx_standby_pages" { catch { console hide } \
		# 	console show; set DYE_window {[focus -displayof .can]} } 2250 220 2500 280		
	}	
}

# Reset the descriptions of the shot in the right of the DSx History Viewer whenever the status of the right list is
# modified.
proc ::plugins::DYE::history_godshots_switch_leave_hook { args } {
	if { $::settings(skin) ne "DSx" } return
	if {[info exists ::DSx_settings(history_godshots)] &&  $::DSx_settings(history_godshots) ne "history" } {
		set ::plugins::DYE::past_shot_desc2 {}
		set ::plugins::DYE::past_shot_desc_one_line2 {}
	}
}