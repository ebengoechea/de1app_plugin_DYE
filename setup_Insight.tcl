
# Setup the UI integration with the Insight skin. 
proc ::plugins::DYE::setup_ui_Insight {} {
	variable widgets 
	variable settings
	
	### DUI ASPECTS & STYLES ###
	dui aspect set -style dsx_settings {dbutton.shape round dbutton.bwidth 384 dbutton.bheight 192 
		dbutton_symbol.pos {0.2 0.5} dbutton_symbol.font_size 37 
		dbutton_label.pos {0.65 0.5} dbutton_label.font_size 18 
		dbutton_label1.pos {0.65 0.8} dbutton_label1.font_size 16}
	
	set bold_font [dui aspect get text font_family -theme default -style bold]
	dui aspect set -style dsx_done [list dbutton.shape round dbutton.bwidth 220 dbutton.bheight 140 \
		dbutton_label.pos {0.5 0.5} dbutton_label.font_size 20 dbutton_label.font_family $bold_font]
	
	dui aspect set -type symbol -style dye_main_nav_button { font_size 24 fill "#35363d" }
	
	dui aspect set -type text -style section_header [list font_family $bold_font font_size 20] 
	
	### INSIGHT HOME PAGE ###
	# Add an icon on the bottom-right Insight home page to open the demo page.
	dui add symbol off 2450 960 -tags launch_dye -symbol $settings(describe_icon) -style small \
		-command [list dui page load DYE current]

	### SCREENSAVER ###
	# Makes the left side of the app screensaver clickable so that you can describe your last shot without waking up 
	# the DE1. Note that this would overlap with the DSx plugin management option, if enabled. Provided by Damian.
	if { [string is true $settings(describe_from_sleep)] } {
		set sleep_describe_symbol $settings(describe_icon)
		set sleep_describe_button_coords {0 0 230 230}
	} else { 
		set sleep_describe_symbol ""
		set sleep_describe_button_coords {0 0 0 0}
	}
	set widgets(describe_from_sleep) [dui add dbutton saver {*}$sleep_describe_button_coords -tags saver_to_dye \
		-symbol $sleep_describe_symbol -symbol_pos {0.5 0.5} -symbol_font_size 45 -canvas_anchor center -justify center \
		-command [list dui page load DYE current]]
}
