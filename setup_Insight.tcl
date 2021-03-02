
# Setup the UI integration with the DSx skin. 
proc ::plugins::DYE::setup_ui_Insight {} {
	variable widgets 
	variable settings
	
	### INSIGHT HOME PAGE ###
	# Add an icon on the bottom-right Insight home page to open the demo page.
	::plugins::DGUI::add_symbol "off espresso_3" 2450 960 $settings(describe_icon) -size small -has_button 1 \
		-button_cmd { ::plugins::DYE::DE::load_page current }

	### SCREENSAVER ###
	# Makes the left side of the app screensaver clickable so that you can describe your last shot without waking up 
	# the DE1. Note that this would overlap with the DSx plugin management option, if enabled. Provided by Damian.
	if { $settings(describe_from_sleep) == 1} {
		set sleep_describe_symbol $settings(describe_icon)
		set sleep_describe_button_coords {0 0 230 230}
	} else { 
		set sleep_describe_symbol ""
		set sleep_describe_button_coords {0 0 0 0}
	}
	set widgets(describe_from_sleep_symbol) [add_de1_text "saver" 35 35 -font fontawesome_reg_big \
		-fill $::plugins::DGUI::font_color -anchor "nw" -text $sleep_describe_symbol]	
	set widgets(describe_from_sleep_button) [add_de1_button "saver" { ::plugins::DYE::DE::load_page current } \
		{*}$sleep_describe_button_coords]

}
