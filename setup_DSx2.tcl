package require struct::list

proc ::plugins::DYE::setup_ui_DSx2 {} {
	variable settings
	variable widgets
	
	if { [is_DSx2 yes]  } {
		DSx2_setup_dui_theme
		
		# Only do Home Page UI integration on strict DSx2 skin (no fork) and default "Damian" DSx2 theme
		if { $::skin(theme) ne "Damian" } {
			return
		}
	} else {
		return
	}
	
	# DSx2 HOME PAGES UI INTEGRATION

	# NEW PAGES
	set pages_ns [namespace current]::pages
	dui page add dsx2_dye_favs -namespace ${pages_ns}::dsx2_dye_favs -type fpdialog
	dui page add dsx2_dye_edit_fav -namespace ${pages_ns}::dsx2_dye_edit_fav -type fpdialog
	dui page add dsx2_dye_hv -namespace ${pages_ns}::dsx2_dye_hv -type fpdialog
	
	# Modify DSx2 home page(s) to adapt to DYE UI widgets and workflow
	::plugins::DYE::pages::dsx2_dye_home::setup
	
	trace add variable ::plugins::DYE::settings(selected_n_fav) write \
		::plugins::DYE::pages::dsx2_dye_favs::change_selected_favorite
	
	# SCREENSAVER 
	# Makes the left side of the app screensaver clickable so that you can describe your 
	# last shot without waking up the DE1.
	set sleep_describe_button_coords [value_or_default \
		settings(DSx2_sleep_describe_button_coords) {240 40 380 180}]

	dui add dbutton saver {*}$sleep_describe_button_coords -tags saver_to_dye -shape round \
		-radius 30 -fill #333 -symbol $settings(describe_icon) -symbol_pos {0.52 0.4} \
		-symbol_anchor center -symbol_justify center -symbol_fill #666 -symbol_font_size 32 \
		-label [translate "DYE"] -label_pos {0.46 0.8} -label_anchor center -label_justify center \
		-label_fill #666 -label_font_size 14 -command {::plugins::DYE::open -which_shot last}
}

proc ::plugins::DYE::DSx2_setup_dui_theme { } {
	### DUI ASPECTS & STYLES ###
	dui theme add DSx2
	dui theme set DSx2

	# Skin colors
	set background_c $::skin_background_colour
	set foreground_c $::skin_forground_colour
	set text_c $::skin_text_colour
	set button_label_c $::skin_button_label_colour 
	set header_button_c $::skin_button_label_colour
	set unselected_c $::skin_background_colour
	set selected_c $::skin_selected_colour
	set error_c $::skin_red
	set fill_and_insert_c $::skin_text_colour
	set button_bg_c $::skin_forground_colour
	set disabled_c $::skin_grey

	#DYE fonts
	set font "notosansuiregular"
	set boldfont "notosansuibold"
	set default_font_size 16

	dui aspect set -theme DSx2 [subst {
		page.bg_img {}
		page.bg_color $background_c
		dialog_page.bg_shape round_outline
		dialog_page.bg_color $background_c
		dialog_page.fill $background_c
		dialog_page.outline $text_c
		dialog_page.width 1
		
		font.font_family "$font"
		font.font_size $default_font_size
		
		dtext.font_family "$font"
		dtext.font_size $default_font_size
		dtext.fill $text_c
		dtext.disabledfill $disabled_c
		dtext.anchor nw
		dtext.justify left
		
		dtext.fill.remark $fill_and_insert_c
		dtext.fill.error $error_c
		dtext.font_family.section_title "$font"
		
		dtext.font_family.page_title "$font"
		dtext.font_size.page_title 26
		dtext.fill.page_title $text_c
		dtext.anchor.page_title center
		dtext.justify.page_title center
					
		symbol.font_family "Font Awesome 6 Pro-Regular-400"
		symbol.font_size 55
		symbol.fill $text_c
		symbol.disabledfill $disabled_c
		symbol.anchor nw
		symbol.justify left
		
		symbol.font_size.small 24
		symbol.font_size.medium 40
		symbol.font_size.big 55
		
		dbutton.debug_outline yellow
		dbutton.fill $button_bg_c
		dbutton.disabledfill $unselected_c
		dbutton.outline $text_c
		dbutton.disabledoutline $unselected_c
		dbutton.width 0
		
		dbutton_label.pos {0.5 0.5}
		dbutton_label.font_size [expr {$default_font_size+1}]
		dbutton_label.anchor center	
		dbutton_label.justify center
		dbutton_label.fill $button_label_c
		dbutton_label.disabledfill $disabled_c
		
		dbutton_label1.pos {0.5 0.8}
		dbutton_label1.font_size [expr {$default_font_size-1}]
		dbutton_label1.anchor center
		dbutton_label1.justify center
		dbutton_label1.fill $button_label_c
		dbutton_label1.activefill $fill_and_insert_c
		dbutton_label1.disabledfill $disabled_c
		
		dbutton_symbol.pos {0.2 0.5}
		dbutton_symbol.font_size 28
		dbutton_symbol.anchor center
		dbutton_symbol.justify center
		dbutton_symbol.fill $button_label_c
		dbutton_symbol.disabledfill $disabled_c
		
		dbutton.shape.insight_ok round
		dbutton.radius.insight_ok 30
		dbutton.bwidth.insight_ok 480
		dbutton.bheight.insight_ok 118
		dbutton_label.font_family.insight_ok "$boldfont"
		dbutton_label.font_size.insight_ok 19
		
		dclicker.fill {}
		dclicker.disabledfill {}
		dclicker_label.pos {0.5 0.5}
		dclicker_label.font_size 16
		dclicker_label.fill $text_c
		dclicker_label.anchor center
		dclicker_label.justify center
		
		entry.relief sunken
		entry.bg $background_c
		entry.disabledbackground $disabled_c
		entry.width 2
		entry.foreground $text_c
		entry.disabledforeground $background_c
		entry.font_size $default_font_size
		entry.insertbackground $fill_and_insert_c
			
		multiline_entry.relief sunken
		multiline_entry.foreground $text_c
		multiline_entry.bg $background_c
		multiline_entry.width 2
		multiline_entry.font_family "$font"
		multiline_entry.font_size $default_font_size
		multiline_entry.width 15
		multiline_entry.height 5
		multiline_entry.insertbackground $fill_and_insert_c
		multiline_entry.wrap word
	
		dcombobox.relief sunken
		dcombobox.bg $background_c
		dcombobox.width 2
		dcombobox.font_family "$font"
		dcombobox.font_size $default_font_size
		
		dbutton_dda.shape {}
		dbutton_dda.fill {}
		dbutton_dda.disabledfill {}
		dbutton_dda.bwidth 70
		dbutton_dda.bheight 65
		dbutton_dda.symbol "sort-down"
		
		dbutton_dda_symbol.pos {0.5 0.2}
		dbutton_dda_symbol.font_size 24
		dbutton_dda_symbol.anchor center
		dbutton_dda_symbol.justify center
		dbutton_dda_symbol.fill $text_c
		dbutton_dda_symbol.disabledfill $disabled_c
				
		dcheckbox.font_family "Font Awesome 6 Pro"
		dcheckbox.font_size 18
		dcheckbox.fill $text_c
		dcheckbox.anchor nw
		dcheckbox.justify left
		
		dcheckbox_label.pos "e 30 0"
		dcheckbox_label.anchor w
		dcheckbox_label.justify left
		
		listbox.relief sunken
		listbox.borderwidth 1
		listbox.foreground $text_c
		listbox.background $background_c
		listbox.selectforeground $background_c
		listbox.selectbackground $text_c
		listbox.selectborderwidth 1
		listbox.disabledforeground $disabled_c
		listbox.selectmode browse
		listbox.justify left
		
		listbox_label.pos "wn -10 0"
		listbox_label.anchor ne
		listbox_label.justify right
		
		listbox_label.font_family.section_title "$font"
		
		scrollbar.orient vertical
		scrollbar.width 120
		scrollbar.length 300
		scrollbar.sliderlength 120
		scrollbar.from 0.0
		scrollbar.to 1.0
		scrollbar.bigincrement 0.2
		scrollbar.borderwidth 1
		scrollbar.showvalue 0
		scrollbar.resolution 0.01
		scrollbar.background $text_c
		scrollbar.foreground $foreground_c
		scrollbar.troughcolor $background_c
		scrollbar.relief flat
		scrollbar.borderwidth 0
		scrollbar.highlightthickness 0
		
		dscale.orient horizontal
		dscale.foreground $text_c
		dscale.background $button_label_c
		dscale.sliderlength 75
		
		scale.orient horizontal
		scale.foreground $foreground_c
		scale.background $text_c
		scale.troughcolor $background_c
		scale.showvalue 0
		scale.relief flat
		scale.borderwidth 0
		scale.highlightthickness 0
		scale.sliderlength 125
		scale.width 150
		
		drater.fill $text_c 
		drater.disabledfill $disabled_c
		drater.font_size 24
		
		rect.fill.insight_back_box $background_c
		rect.width.insight_back_box 0
		line.fill.insight_back_box_shadow $background_c
		line.width.insight_back_box_shadow 2
		rect.fill.insight_front_box $background_c
		rect.width.insight_front_box 0
		
		graph.plotbackground $background_c
		graph.borderwidth 1
		graph.background $background_c
		graph.plotrelief raised
		graph.plotpady 0 
		graph.plotpadx 10
		
		text.bg $background_c
		text.foreground $text_c
		text.font_size $default_font_size
		text.relief flat
		text.highlightthickness 1
		text.insertbackground $fill_and_insert_c
		text.wrap word
		
		dselector.radius 40
		dselector.fill $background_c
		dselector.selectedfill $foreground_c
		dselector.outline $foreground_c
		dselector.selectedoutline $foreground_c
		dselector.label_fill $text_c
		dselector.label_selectedfill $selected_c

		dtoggle.width 120
		dtoggle.height 68
		dtoggle.outline_width 0
		dtoggle.background $foreground_c
		dtoggle.foreground $button_label_c
		dtoggle.outline $button_label_c
		dtoggle.selectedbackground $foreground_c
		dtoggle.selectedforeground $selected_c
		dtoggle.selectedoutline $selected_c
		dtoggle.disabledbackground $disabled_c
		dtoggle.disabledforeground $button_label_c
		dtoggle.disabledoutline $button_label_c		
	}]

	# dui_number_editor page styles
	dui aspect set -theme DSx2 {
		dbutton.shape.dne_clicker outline 
		dbutton.bwidth.dne_clicker 120 
		dbutton.bheight.dne_clicker 140 
		dbutton.fill.dne_clicker {}
		dbutton.width.dne_clicker 3
		dbutton.anchor.dne_clicker center
		dbutton_symbol.pos.dne_clicker {0.5 0.4} 
		dbutton_symbol.anchor.dne_clicker center 
		dbutton_symbol.font_size.dne_clicker 20
		dbutton_label.pos.dne_clicker {0.5 0.8} 
		dbutton_label.font_size.dne_clicker 10 
		dbutton_label.anchor.dne_clicker center
		
		dbutton.shape.dne_pad_button outline 
		dbutton.bwidth.dne_pad_button 280 
		dbutton.bheight.dne_pad_button 220
		dbutton.fill.dne_pad_button {}
		dbutton.width.dne_pad_button 3
		dbutton.anchor.dne_pad_button nw
		dbutton_label.pos.dne_pad_button {0.5 0.5} 
		dbutton_label.font_family.dne_pad_button notosansuibold 
		dbutton_label.font_size.dne_pad_button 24 
		dbutton_label.anchor.dne_pad_button center
	}
	
	# DUI confirm dialog styles
	dui aspect set -theme DSx2 {
		dbutton.shape.dui_confirm_button outline
		dbutton.bheight.dui_confirm_button 100
		dbutton.width.dui_confirm_button 1
		dbutton.arc_offset.dui_confirm_button 20
	}

	# Menu dialogs
	dui aspect set -theme DSx2 [subst {
		dtext.font_size.menu_dlg_title +1
		dtext.anchor.menu_dlg_title center
		dtext.justify.menu_dlg_title center
		
		dbutton.shape.menu_dlg_close rect 
		dbutton.fill.menu_dlg_close {} 
		dbutton.symbol.menu_dlg_close xmark
		dbutton_symbol.pos.menu_dlg_close {0.5 0.5}
		dbutton_symbol.anchor.menu_dlg_close center
		dbutton_symbol.justify.menu_dlg_close center
		dbutton_symbol.fill.menu_dlg_close $foreground_c
		
		dbutton.shape.menu_dlg_btn rect
		dbutton.fill.menu_dlg_btn {}
		dbutton.disabledfill.menu_dlg_btn {}
		dbutton_label.pos.menu_dlg_btn {0.25 0.4} 
		dbutton_label.anchor.menu_dlg_btn w
		dbutton_label.fill.menu_dlg_btn $text_c
		dbutton_label.disabledfill.menu_dlg_btn $disabled_c
		
		dbutton_label1.pos.menu_dlg_btn {0.25 0.78} 
		dbutton_label1.anchor.menu_dlg_btn w
		dbutton_label1.fill.menu_dlg_btn $text_c
		dbutton_label1.disabledfill.menu_dlg_btn $disabled_c
		dbutton_label1.font_size.menu_dlg_btn -3
		
		dbutton_symbol.pos.menu_dlg_btn {0.15 0.5} 
		dbutton_symbol.anchor.menu_dlg_btn center
		dbutton_symbol.fill.menu_dlg_btn $button_label_c
		dbutton_symbol.disabledfill.menu_dlg_btn $disabled_c
		
		line.fill.menu_dlg_sepline $disabled_c
		line.width.menu_dlg_sepline 1
		
		dtext.fill.menu_dlg $text_c
		dtext.disabledfill.menu_dlg $disabled_c
		dcheckbox.fill.menu_dlg $text_c
		dcheckbox.disabledfill.menu_dlg $disabled_c
		dcheckbox_label.fill.menu_dlg $text_c
		dcheckbox_label.disabledfill.menu_dlg $disabled_c
		
		dbutton.shape.menu_dlg outline
		dbutton.arc_offset.menu_dlg 25
		dbutton.width.menu_dlg 3
	}]
	
	# History Viewer styles
#	set smooth $::settings(live_graph_smoothing_technique)
#	set zoomed_y_axis_max 8
#	set x_axis_colour white
#	dui aspect set -theme DSx2 [subst {
#		graph_axis.color.hv_graph_axis $x_axis_colour
#		graph_axis.min.hv_graph_axis 0.0
#		graph_axis.max.hv_graph_axis [expr 12 * 10]
#		
#		graph_xaxis.color.hv_graph_axis $x_axis_colour  
#		graph_xaxis.tickfont.hv_graph_axis "[DSx_font font 7]" 
#		graph_xaxis.min.hv_graph_axis 0.0
#			
#		graph_yaxis.color.hv_graph_axis "#008c4c"
#		graph_yaxis.tickfont.hv_graph_axis "[DSx_font font 7]"
#		graph_yaxis.min.hv_graph_axis 0.0 
#		graph_yaxis.max.hv_graph_axis $zoomed_y_axis_max
#		graph_yaxis.subdivisions.hv_graph_axis 5 
#		graph_yaxis.majorticks.hv_graph_axis {0 1 2 3 4 5 6 7 8 9 10 11 12} 
#		graph_yaxis.hide.hv_graph_axis 0
#		
#		graph_y2axis.color.hv_graph_axis "#206ad4"
#		graph_y2axis.tickfont.hv_graph_axis "[DSx_font font 7]"
#		graph_y2axis.min.hv_graph_axis 0.0 
#		graph_y2axis.max.hv_graph_axis $zoomed_y_axis_max
#		graph_y2axis.subdivisions.hv_graph_axis 2 
#		graph_y2axis.majorticks.hv_graph_axis {0 1 2 3 4 5 6 7 8 9 10 11 12} 
#		graph_y2axis.hide.hv_graph_axis 0
#
#		graph_grid.color.hv_graph_grid $::DSx_settings(grid_colour)
#		
#		graph_line.linewidth.hv_temperature_goal $::DSx_settings(hist_temp_goal_curve) 
#		graph_line.color.hv_temperature_goal #ffa5a6 
#		graph_line.smooth.hv_temperature_goal $smooth 
#		graph_line.dashes.hv_temperature_goal {5 5}
#		
#		graph_line.linewidth.hv_temperature_basket $::DSx_settings(hist_temp_curve) 
#		graph_line.color.hv_temperature_basket #e73249
#		graph_line.smooth.hv_temperature_basket $smooth 
#		graph_line.dashes.hv_temperature_basket [list $::settings(chart_dashes_temperature)]
#
#		graph_line.linewidth.hv_temperature_mix $::DSx_settings(hist_temp_curve) 
#		graph_line.color.hv_temperature_mix #ff888c
#		graph_line.smooth.hv_temperature_mix $smooth 
#
#		graph_line.linewidth.hv_temperature_goal $::DSx_settings(hist_temp_goal_curve) 
#		graph_line.color.hv_temperature_goal #ffa5a6 
#		graph_line.smooth.hv_temperature_goal $smooth 
#		graph_line.dashes.hv_temperature_goal {5 5}
#
#		graph_line.linewidth.hv_pressure_goal $::DSx_settings(hist_goal_curve) 
#		graph_line.color.hv_pressure_goal #69fdb3
#		graph_line.smooth.hv_pressure_goal $smooth 
#		graph_line.dashes.hv_pressure_goal {5 5}
#
#		graph_line.linewidth.hv_flow_goal $::DSx_settings(hist_goal_curve) 
#		graph_line.color.hv_flow_goal #7aaaff
#		graph_line.smooth.hv_flow_goal $smooth 
#		graph_line.dashes.hv_flow_goal {5 5}
#			
#		graph_line.linewidth.hv_pressure [dui platform rescale_x 8] 
#		graph_line.color.hv_pressure #008c4c
#		graph_line.smooth.hv_pressure $smooth 
#		graph_line.dashes.hv_pressure [list $::settings(chart_dashes_pressure)]
#			
#		graph_line.linewidth.hv_flow [dui platform rescale_x 8] 
#		graph_line.color.hv_flow #4e85f4
#		graph_line.smooth.hv_flow $smooth 
#		graph_line.dashes.hv_flow [list $::settings(chart_dashes_flow)]
#
#		graph_line.linewidth.hv_flow_weight [dui platform rescale_x 8] 
#		graph_line.color.hv_flow_weight #a2693d
#		graph_line.smooth.hv_flow_weight $smooth 
#		graph_line.dashes.hv_flow_weight [list $::settings(chart_dashes_flow)]
#
#		graph_line.linewidth.hv_weight [dui platform rescale_x 8] 
#		graph_line.color.hv_weight #a2693d
#		graph_line.smooth.hv_weight $smooth 
#		graph_line.dashes.hv_weight [list $::settings(chart_dashes_espresso_weight)]
#
#		graph_line.linewidth.hv_state_change $::DSx_settings(hist_goal_curve) 
#		graph_line.color.hv_state_change #AAAAAA
#
#		graph_line.linewidth.hv_resistance $::DSx_settings(hist_resistance_curve) 
#		graph_line.color.hv_resistance #e5e500
#		graph_line.smooth.hv_resistance $smooth 
#		graph_line.dashes.hv_resistance {6 2}		
#	}]
	
#	dui aspect set { dbutton.width 3 }
	# DYE-specific styles
	dui aspect set -style dsx_settings [subst {dbutton.shape round dbutton.fill $button_bg_c dbutton.disabledfill $unselected_c
		dbutton.bwidth 384 dbutton.bheight 192 dbutton.width 0
		dbutton_symbol.pos {0.2 0.5} dbutton_symbol.font_size 37 
		dbutton_label.pos {0.65 0.5} dbutton_label.font_size 17 
		dbutton_label1.pos {0.65 0.8} dbutton_label1.font_size 16}]
	
	dui aspect set -style dsx_midsize {dbutton.shape outline dbutton.bwidth 220 dbutton.bheight 140 dbutton.width 6 dbutton.arc_offset 15
		dbutton_label.pos {0.7 0.5} dbutton_label.font_size 14 dbutton_symbol.font_size 24 dbutton_symbol.pos {0.25 0.5} }

	dui aspect set -style dsx_archive {dbutton.shape outline dbutton.bwidth 180 dbutton.bheight 110 dbutton.width 6 
		canvas_anchor nw anchor nw dbutton.arc_offset 12 dbutton_label.pos {0.7 0.5} dbutton_label.font_size 14 
		dbutton_symbol.font_size 24 dbutton_symbol.pos {0.3 0.5} }
	
	set bold_font [dui aspect get dtext font_family -theme default -style bold]
	dui aspect set -style dsx_done [list dbutton.shape outline dbutton.bwidth 220 dbutton.bheight 140 dbutton.width 5 \
		dbutton_label.pos {0.5 0.5} dbutton_label.font_size 20 dbutton_label.font_family $bold_font]
	
	dui aspect set -style dye_main_nav_button [subst { dbutton.shape {} dbutton.fill {} dbutton.disabledfill {}
		dbutton_symbol.font_size 28 dbutton_symbol.fill $text_c dbutton_symbol.disabledfill $disabled_c}]

	dui aspect set -type dtext -style section_header [list font_family $bold_font font_size 20 fill $foreground_c]
	
	dui aspect set -type dclicker -style dye_double [subst {shape {} fill $background_c 
		disabledfill $background_c width 0 orient horizontal use_biginc 1 
		symbol chevrons-left symbol1 chevron-left symbol2 chevron-right symbol3 chevrons-right}]
	dui aspect set -type dclicker_symbol -style dye_double [subst {pos {0.075 0.5} font_size 24 anchor center 
		fill $button_bg_c disabledfill $disabled_c}]
	dui aspect set -type dclicker_symbol1 -style dye_double [subst {pos {0.275 0.5} font_size 24 anchor center 
		fill $button_bg_c disabledfill $disabled_c}]
	dui aspect set -type dclicker_symbol2 -style dye_double [subst {pos {0.725 0.5} font_size 24 anchor center 
		fill $button_bg_c disabledfill $disabled_c}]
	dui aspect set -type dclicker_symbol3 -style dye_double [subst {pos {0.925 0.5} font_size 24 anchor center 
		fill $button_bg_c disabledfill $disabled_c}]

	dui aspect set -type dclicker -style dye_single {orient horizontal use_biginc 0 symbol chevron-left symbol1 chevron-right}
	dui aspect set -type dclicker_symbol -style dye_single {pos {0.1 0.5} font_size 24 anchor center fill "#7f879a"} 
	dui aspect set -type dclicker_symbol1 -style dye_single {pos {0.9 0.5} font_size 24 anchor center fill "#7f879a"} 

	# New aspects for the DYE main page section images, so they can be modified depending on color choices.
	# Uses code contributed by Eran Yaniv. This determines which image to use depending on the
	#	darkness of the current skin theme background color. 
	lassign [winfo rgb . $::skin_background_colour] r g b
	set luma [ expr { ((0.2126 * $r) + (0.7152 * $g) + (0.0722 * $b)) / 65535 } ]
	if { $luma > 0.7} {
		dui aspect set -type image -style dye_beans_img -source "bean_DSx2_black.png"
		dui aspect set -type image -style dye_equipment_img -source "niche_DSx2_black.png"
		dui aspect set -type image -style dye_extraction_img -source "espresso_DSx2_black.png"
		dui aspect set -type image -style dye_people_img -source "people_DSx2_black.png"
	} else {
		dui aspect set -type image -style dye_beans_img -source "bean_DSx.png"
		dui aspect set -type image -style dye_equipment_img -source "niche_DSx.png"
		dui aspect set -type image -style dye_extraction_img -source "espresso_DSx.png"
		dui aspect set -type image -style dye_people_img -source "people_DSx.png"
	}
	
	# Profile viewer
	dui aspect set [subst {
		shape.fill.dye_pv_icon_btn CadetBlue4 
		dtext.fill.dye_pv_profile_title white
		dtext.font_size.dye_pv_profile_title +8
		dtext.font_family.dye_pv_profile_title notosansuibold
		text_tag.spacing1.dye_pv_step [dui::platform::rescale_y 20] 
		text_tag.foreground.dye_pv_step Brown2
		text_tag.lmargin1.dye_pv_step_line [dui::platform::rescale_x 35]
		text_tag.lmargin2.dye_pv_step_line [dui::platform::rescale_x 55]
		text_tag.foreground.dye_pv_value $::plugins::DYE::default_shot_desc_font_color
	}]
	
	### DYE V3 STYLES ####
	set btn_spacing 100
	set half_button_width [expr {int(($::dui::pages::DYE_v3::page_coords(panel_width)-$btn_spacing)/2)}]
	
	dui aspect set -theme DSx2 [subst { 
		dbutton.bheight.dyev3_topnav 90 
		dbutton.shape.dyev3_topnav rect 
		dbutton.fill.dyev3_topnav grey
		dbutton_label.font_size.dyev3_topnav -1 
		dbutton_label.pos.dyev3_topnav {0.5 0.5} 
		dbutton_label.anchor.dyev3_topnav center 
		dbutton_label.justify.dyev3_topnav center 
	
		dbutton.bwidth.dyev3_nav_button 100 
		dbutton.bheight.dyev3_nav_button 120
		dbutton.fill.dyev3_nav_button {} 
		dbutton.disabledfill.dyev3_nav_button {}
		dbutton_symbol.pos.dyev3_nav_button {0.5 0.5} 
		dbutton_symbol.fill.dyev3_nav_button #ccc
		
		text.font_size.dyev3_top_panel_text -1
		text.yscrollbar.dyev3_top_panel_text no
		text.bg.dyev3_top_panel_text $background_c
		text.borderwidth.dyev3_top_panel_text 0
		text.highlightthickness.dyev3_top_panel_text 0
		text.relief.dyev3_top_panel_text flat
		
		text.font_size.dyev3_bottom_panel_text -1
	
		dtext.font_family.dyev3_right_panel_title "$font" 
		dtext.font_size.dyev3_right_panel_title +2
		dtext.fill.dyev3_right_panel_title $text_c
		dtext.anchor.dyev3_right_panel_title center
		dtext.justify.dyev3_right_panel_title center
		
		graph.background.dyev3_text_graph $background_c 
		graph.plotbackground.dyev3_text_graph $background_c 
		graph.borderwidth.dyev3_text_graph 1 
		graph.plotrelief.dyev3_text_graph flat
		
		dtext.font_size.dyev3_chart_stage_title +2 
		dtext.anchor.dyev3_chart_stage_title center 
		dtext.justify.dyev3_chart_stage_title center 
		dtext.fill.dyev3_chart_stage_title $text_c
		
		dtext.anchor.dyev3_chart_stage_colheader center 
		dtext.justify.dyev3_chart_stage_colheader center
		
		dtext.anchor.dyev3_chart_stage_value center
		dtext.justify.dyev3_chart_stage_value center
		
		dtext.anchor.dyev3_chart_stage_comp center
		dtext.justify.dyev3_chart_stage_comp center
		dtext.font_size.dyev3_chart_stage_comp -4
		dtext.fill.dyev3_chart_stage_comp grey
	
		line.fill.dyev3_chart_stage_line_sep grey

		dbutton.shape.dyev3_action_half outline
		dbutton.fill.dyev3_action_half {}
		dbutton.disabledfill.dyev3_action_half {}
		dbutton.width.dyev3_action_half [dui platform rescale_x 7]
		dbutton.outline.dyev3_action_half white
		dbutton.disabledoutline.dyev3_action_half $disabled_c
		dbutton.bwidth.dyev3_action_half $half_button_width
		dbutton.bheight.dyev3_action_half 125
		dbutton_symbol.pos.dyev3_action_half {0.2 0.5} 
		dbutton_label.pos.dyev3_action_half {0.6 0.5}
		dbutton_label.width.dyev3_action_half [expr {$half_button_width-75}]
		
		#text_tag.foregroud.which_shot $background_c
		text_tag.font.dyev3_which_shot "[dui font get $font 13]"
		text_tag.justify.dyev3_which_shot center
		
		text_tag.justify.dyev3_profile_title center
		
		text_tag.foreground.dyev3_section $text_c
		text_tag.font.dyev3_section "[dui font get $font 12]" 
		text_tag.spacing1.dyev3_section [dui platform rescale_y 15]
		
		text_tag.foreground.dyev3_field $text_c 
		text_tag.lmargin1.dyev3_field [dui platform rescale_x 35] 
		text_tag.lmargin2.dyev3_field [dui platform rescale_x 45]
		
		text_tag.foreground.dyev3_value #4e85f4
		
		text_tag.foreground.dyev3_compare grey
		
		text_tag.font.dyev3_field_highlighted "[dui font get $font 10]"
		text_tag.background.dyev3_field_highlighted darkgrey
		text_tag.font.dyev3_field_nonhighlighted "[dui font get $font 10]"
		text_tag.background.dyev3_field_nonhighlighted {}	
	}]	
	
	
	# New DSx2-specific styles
	# dbutton.width.dsx2 0
	dui aspect set -theme DSx2 [subst {
		dbutton.shape.dsx2 round
		dbutton.bheight.dsx2 100
		dbutton.fill.dsx2 $button_bg_c
		dbutton.pressfill.dsx2 \{ $button_label_c 150 \}
		dbutton.disabledfill.dsx2 $unselected_c		
		
		dbutton_label.pos.dsx2 {0.5 0.5}
		dbutton_label.font_size.dsx2 [expr {$default_font_size+1}]
		dbutton_label.anchor.dsx2 center	
		dbutton_label.justify.dsx2 center
		dbutton_label.fill.dsx2 $button_label_c
		dbutton_label.pressfill.dsx2 \{ $button_bg_c 150 \}
		dbutton_label.disabledfill.dsx2 $disabled_c
		
		dbutton_label1.pos.dsx2 {0.5 0.8}
		dbutton_label1.font_size.dsx2 [expr {$default_font_size-1}]
		dbutton_label1.anchor.dsx2 center
		dbutton_label1.justify.dsx2 center
		dbutton_label1.fill.dsx2 $button_label_c
		dbutton_label1.pressfill.dsx2 \{ $selected_c 150 $selected_c \}
		dbutton_label1.activefill.dsx2 $fill_and_insert_c
		dbutton_label1.disabledfill.dsx2 $disabled_c
		
		dbutton_symbol.pos.dsx2 {0.2 0.5}
		dbutton_symbol.font_size.dx2 28
		dbutton_symbol.anchor.dsx2 center
		dbutton_symbol.justify.dsx2 center
		dbutton_symbol.fill.dsx2 $button_label_c
		dbutton_symbol.disabledfill.dsx2 $disabled_c
		
		dbutton.shape.dsx2_pm round_outline
		dbutton.bheight.dsx2_pm 100
		dbutton.bwidth.dsx2_pm 100
		dbutton.fill.dsx2_pm $button_bg_c
		dbutton.disabledfill.dsx2_pm $unselected_c
		dbutton.outline.dsx2_pm $::skin_forground_colour
		dbutton.disabledoutline.dsx2_pm $unselected_c

		dbutton_label.pos.dsx2_pm {0.5 0.5}
		dbutton_label.font_family.dsx2_pm "$::skin(font_awesome_light)"
		dbutton_label.font_size.dsx2_pm [fixed_size 30]
		dbutton_label.anchor.dsx2_pm center	
		dbutton_label.justify.dsx2_pm center
		dbutton_label.fill.dsx2_pm $button_label_c
		dbutton_label.disabledfill.dsx2_pm $disabled_c

		dtext.font_family.dsx2_setting_heading "$boldfont"
		dtext.font_size.dsx2_setting_heading 15
		dtext.fill.dsx2_setting_heading $text_c 
		dtext.disabledfill.dsx2_setting_heading $disabled_c
		dtext.anchor.dsx2_setting_heading center
		dtext.justify.dsx2_setting_heading center
	}]
	
}

##### DYE DSx2 FAVORITES PAGES ##################################################################### 
# Note that we use this workspace to modify the existing DSx2 home page, but this
# doesn't match a DUI page workspace.
namespace eval ::plugins::DYE::pages::dsx2_dye_home {
	variable main_graph_height	
	set main_graph_height [rescale_y_skin 840]
	
	variable data
	array set data {
		days_offroast_msg {}
	}
	
	proc setup {} {
		variable data
		variable main_graph_height
		variable ::plugins::DYE::settings
		
		set page [lindex $::skin_home_pages 0]
		
		# Define hooks for Damian's pages and procs
		set ns [namespace current]
		dui page add_action $page load ${ns}::load
		dui page add_action $page show ${ns}::show
		trace add execution ::show_graph leave ${ns}::show_graph_hook
		trace add execution ::hide_graph leave ${ns}::hide_graph_hook
		trace add execution ::adjust leave ${ns}::adjust_hook
		trace add execution ::set_scale_weight_to_dose leave ${ns}::set_scale_weight_to_dose_hook
		
		# Main DSx2 graph
		bind $::home_espresso_graph [dui::platform::button_press] \
			[list ::plugins::DYE::pages::dsx2_dye_home::press_graph_hook %W %x %y]
		
		blt::vector create src_elapsed src_temperature_goal src_temperature_goal10th \
			src_temperature src_temperature10th src_pressure_goal src_pressure \
			src_flow_goal src_flow_goal_2x src_flow src_flow_2x \
			src_weight src_weight_2x src_weight_chartable src_resistance src_steps
		
		# Add last/source & next shot description buttons to the home page
		if { [string is true $settings(dsx2_show_shot_desc_on_home)] } {
			set istate normal
		} else {
			set istate hidden
		}
		
		dui add dbutton [concat $page dsx2_dye_hv] 50 1370 -bwidth 850 -bheight 190 -anchor nw \
			-shape rect -fill [dui::aspect::get page bg_color] \
			-tags launch_dye_last -labelvariable {$::plugins::DYE::settings(last_shot_desc)} \
			-label_pos {0.0 0.27} -label_anchor nw \
			-label_justify left -label_font_size -4 -label_fill $::skin_text_colour -label_width 850 \
			-label1variable {$::plugins::DYE::settings(last_shot_header)} -label1_font_family notosansuibold \
			-label1_font_size -4 -label1_fill $::skin_text_colour \
			-label1_pos {0.0 0.0} -label1_anchor nw -label1_justify left -label1_width 850 \
			-initial_state $istate -tap_pad {20 15 0 50} \
			-command [::list [namespace current]::home_shot_desc_clicked left] \
			-longpress_cmd [::list [namespace current]::home_shot_desc_longclicked left]
			
		
		dui add dbutton $page 1000 1380 -bwidth 120 -bheight 180 -style dsx2 -anchor n \
			-tags launch_dye_dsx2_hv -symbol clock-rotate-left -symbol_pos {0.5 0.3} \
			-label [translate {history viewer}] -label_width 115 -label_pos {0.5 0.78} \
			-label_anchor center -label_justify center -label_font_size 10 \
			-tap_pad {20 40 20 40} -command {::dui::page::load dsx2_dye_hv} -initial_state hidden

		# A try to rebind clicks on the main graph, but can't make it work
#		bindtags $::home_espresso_graph [concat [dui::canvas].launch_dye_dsx2_hv \
#				[list_remove_element [bindtags $::home_espresso_graph] $::home_espresso_graph]]
		
		# -labelvariable {[::plugins::DYE::shots::define_next_desc]}
		dui add dbutton [concat $page dsx2_dye_hv] 1950 1370 -bwidth 850 -bheight 190 -anchor ne \
			-shape rect -fill [dui::aspect::get page bg_color] \
			-tags launch_dye_next -labelvariable {$::plugins::DYE::settings(next_shot_desc)} \
			-label_pos {1.0 0.27} -label_anchor ne \
			-label_justify right -label_font_size -4 -label_fill $::skin_text_colour -label_width 850 \
			-label1variable {$::plugins::DYE::settings(next_shot_header)} -label1_font_family notosansuibold \
			-label1_font_size -4 -label1_fill $::skin_text_colour \
			-label1_pos {1.0 0.0} -label1_anchor ne -label1_justify right -label1_width 850 \
			-initial_state $istate -tap_pad {0 15 20 50} \
			-command [::list [namespace current]::home_shot_desc_clicked right] \
			-longpress_cmd [::list [namespace current]::home_shot_desc_longclicked right]
	
		toggle_show_shot_desc

		# Add extra DYE inputs to the espresso settings page
		set y 1110
				
		set x 200
		dui add dtext $page [expr {$x+580/2}] $y -tags wf_heading_beans -style dsx2_setting_heading \
			-text [translate "Beans"] -initial_state hidden
		dui add dbutton $page $x [expr {$y+40}] -style dsx2 -bwidth 580 -tags wf_dye_beans \
			-labelvariable {[maxstring "$::plugins::DYE::settings(next_bean_brand) $::plugins::DYE::settings(next_bean_type)" 46]} \
			-label_font [skin_font font 16] -label_width 575 -initial_state hidden \
			-command [namespace current]::select_beans
			
		# Grinder model 200+580/2
		dui add dtext $page [expr {$x+580/2}] [expr {$y+200}] -tags wf_heading_grinder \
			-style dsx2_setting_heading -text [translate "Grinder"] -initial_state hidden
		dui add dbutton $page $x [expr {$y+240}] -style dsx2 -bwidth 580 -tags wf_grinder \
			-labelvariable {[maxstring "$::plugins::DYE::settings(next_grinder_model)" 46]} \
			-label_font [skin_font font 16] -label_width 575 -initial_state hidden \
			-command [namespace current]::select_grinder

		# Roast date
		set x 1000 
		dui add dtext $page $x $y -tags wf_heading_roast_date -style dsx2_setting_heading \
			-text [translate "Roast date"] -initial_state hidden
		set w [dui add entry $page [expr {$x-115}] [expr {$y+55}] -tags wf_roast_date -width 10 \
			-justify center -textvariable ::plugins::DYE::settings(next_roast_date) -initial_state hidden]
		bind $w <FocusOut> [list + [namespace current]::compute_days_offroast]
		
		dui add variable $page $x [expr {$y+140}] -tags wf_days_offroast -width 250 \
			-textvariable {$::plugins::DYE::pages::dsx2_dye_home::data(days_offroast_msg)} -font [skin_font font 16] \
			-fill $::skin_text_colour -anchor n -justify center -initial_state hidden
		
		# Grinder setting
		set x 1340
		dui add dtext $page $x $y -tags wf_heading_grinder_setting -style dsx2_setting_heading \
			-text [translate "Grinder setting"] -initial_state hidden
		dui add dbutton $page [expr {$x-110}] [expr {$y+40}] -style dsx2_pm \
			-tags {wf_grinder_setting_plus_big wf_grinder_setting*} -label \Uf106 \
			-command [list [namespace current]::change_grinder_setting plus_big] \
			-initial_state hidden
		dui add dbutton $page [expr {$x-110}] [expr {$y+240}] -style dsx2_pm \
			-tags {wf_grinder_setting_minus_big wf_grinder_setting*} -label \Uf107 \
			-command [list [namespace current]::change_grinder_setting minus_big] \
			-initial_state hidden
		dui add dbutton $page [expr {$x+10}] [expr {$y+40}] -style dsx2_pm \
			-tags {wf_grinder_setting_plus_small wf_grinder_setting*} -label \Uf106 \
			-command [list [namespace current]::change_grinder_setting plus_small] \
			-initial_state hidden
		dui add dbutton $page [expr {$x+10}] [expr {$y+240}] -style dsx2_pm  \
			-tags {wf_grinder_setting_minus_small wf_grinder_setting*} -label \Uf107 \
			-command [list [namespace current]::change_grinder_setting minus_small] \
			-initial_state hidden
		dui add variable $page $x [expr {$y+190}] \
			-font [skin_font font_bold 24] -tags {wf_grinder_setting wf_grinder_setting*} -anchor center \
			-textvariable {$::plugins::DYE::settings(next_grinder_setting)} \
			-initial_state hidden
		# Grinder setting Entry hidden by default, only shown if grinder has no spec 
		set w [dui add entry $page $x [expr {$y+190}] -tags wf_grinder_setting_entry -width 8 \
			-canvas_anchor center -justify center -initial_state hidden \
			-textvariable ::plugins::DYE::settings(next_grinder_setting)]
		bind $w <Leave> [list + [namespace current]::change_grinder_setting_entry]
		
		trace add execution ::show_espresso_settings leave ${ns}::show_espresso_settings_hook
		trace add execution ::hide_espresso_settings leave ${ns}::hide_espresso_settings_hook
		hide_espresso_settings_hook
	}
	
	proc load { args } {
		variable main_graph_height
		set main_home_page [lindex $::skin_home_pages 0]
		
		if { [string is true $::plugins::DYE::settings(dsx2_use_dye_favs)] } {
			for {set i 0} {$i < $::plugins::DYE::settings(dsx2_n_visible_dye_favs)} {incr i 1} {
				dui item config $main_home_page dye_fav_$i -initial_state normal
			}
			for {set i $::plugins::DYE::settings(dsx2_n_visible_dye_favs)} {$i < 5} {incr i 1} {
				dui item config $main_home_page dye_fav_$i -initial_state hidden
			}
			
			dui item config $main_home_page {l_favs_number b_favs_number* bb_favs_number* } \
				-initial_state hidden
		}
		
		if { $::plugins::DYE::settings(dsx2_show_shot_desc_on_home) } {
			$::home_espresso_graph configure -height $main_graph_height			
			dui item config $::skin_home_pages live_graph_data -initial_state hidden
			
			# Updates e.g. the profile title in the next shot desc if coming from a profile switch
			::plugins::DYE::shots::define_next_desc
			
			if { $::wf_espresso_set_showing || $::wf_flush_set_showing || \
					$::wf_water_set_showing || $::wf_steam_set_showing || $::graph_hidden } {
				dui item hide $main_home_page {launch_dye_last* launch_dye_next* launch_dye_dsx2_hv*} -initial 1 -current 1
			} else {
				dui item show $main_home_page {launch_dye_last* launch_dye_next* launch_dye_dsx2_hv*} -initial 1 
			}
		}
		
		::plugins::DYE::pages::dsx2_dye_home::compute_days_offroast
		
		return 1
	}
	
	proc show { args } {
		variable ::plugins::DYE::settings
		set main_home_page [lindex $::skin_home_pages 0]
		
		# This call doesn't work on the page load event, so we need to put it here,
		# but it produces a slight flickering effect as all DSx2 favs are first shown,
		# then hidden
		if { [string is true $settings(dsx2_use_dye_favs)] } {
			dui item config $main_home_page {l_favs_number b_favs_number* bb_favs_number*} \
				-state hidden
		} else {
			::rest_fav_buttons
		}

		# Coming back from a dialog may not execute the load proc, so we make sure again here
		if { $settings(dsx2_show_shot_desc_on_home) && !$::wf_espresso_set_showing &&
				!$::wf_flush_set_showing && !$::wf_water_set_showing && !$::wf_steam_set_showing && 
				!$::graph_hidden } {
			dui item show $main_home_page {launch_dye_last* launch_dye_next* launch_dye_dsx2_hv*}
		}
		
		if { $::wf_espresso_set_showing } {
			ensure_valid_grinder_spec
		}
	}
	
	proc show_graph_hook { args } {
		variable main_graph_height
		set page [lindex $::skin_home_pages 0]
		
		if { $::plugins::DYE::settings(dsx2_show_shot_desc_on_home) } {
			$::home_espresso_graph configure -height $main_graph_height
			dui item config $page live_graph_data -initial_state hidden -state hidden
			dui item show $page {launch_dye_last* launch_dye_next* launch_dye_dsx2_hv*} -current 1 -initial 0
			::plugins::DYE::shots::define_next_desc
		}
	}
	
	proc hide_graph_hook { args } {
		set page [lindex $::skin_home_pages 0]
		
		if { [string is true $::plugins::DYE::settings(dsx2_use_dye_favs)] } {
			dui item config $page {l_favs_number b_favs_number* bb_favs_number* } \
				-state hidden
		}
		if { $::plugins::DYE::settings(dsx2_show_shot_desc_on_home) } {
			dui item hide $page {launch_dye_last* launch_dye_next* launch_dye_dsx2_hv*} -initial 1 -current 1
		}
	}
	
	proc press_graph_hook { args } {
		variable main_graph_height
		set page [lindex $::skin_home_pages 0]
		
		if { [dui page current] eq "dsx2_dye_hv" } {
			::plugins::DYE::pages::dsx2_dye_hv::press_graph {*}$args
		} else {
			::toggle_cache_graphs
			
			if { $::plugins::DYE::settings(dsx2_show_shot_desc_on_home) } {
				if { [.can itemcget graph_a -state] eq "hidden" } {
					$::home_espresso_graph configure -height $main_graph_height
					dui item show $page {launch_dye_last* launch_dye_next* launch_dye_dsx2_hv*}
					dui item config $page live_graph_data -initial_state hidden -state hidden
				} else {
					dui item hide $page {launch_dye_last* launch_dye_next* launch_dye_dsx2_hv*}
					foreach curve {temperature zoom_temperature pressure flow flow_2x weight \
							weight_2x resistance steps} {
						$::home_espresso_graph element configure compare_${curve} -hide 0
					}
				}
			}
		}
	}
	
	proc show_espresso_settings_hook { args } {
		set page [lindex $::skin_home_pages 0]
		dui item show $page {wf_heading_beans wf_dye_beans* wf_heading_roast_date wf_roast_date* \
			wf_days_offroast wf_heading_grinder wf_grinder* \
			wf_heading_grinder_setting wf_grinder_setting*} -initial yes -current yes
		 
#		if { $::settings(grinder_setting) ne {} && ![string is double $::settings(grinder_setting)] } {
#			dui item disable $page wf_grinder_setting*
#		}
		
		if { [string is true $::plugins::DYE::settings(dsx2_show_shot_desc_on_home)] } {
			dui item show $page {bb_dye_bg* s_dye_bg* b_dye_bg* l_dye_bg li_dye_bg launch_dye*} \
				-initial yes -current yes
		}
		::plugins::DYE::pages::dsx2_dye_home::compute_days_offroast
		::plugins::DYE::pages::dsx2_dye_home::ensure_valid_grinder_spec
	}

	proc hide_espresso_settings_hook { args } {
		set page [lindex $::skin_home_pages 0]
		dui item hide $page {wf_heading_beans wf_dye_beans* wf_heading_roast_date wf_roast_date* \
			wf_days_offroast wf_heading_grinder wf_grinder* \
			wf_heading_grinder_setting wf_grinder_setting* wf_grinder_setting_entry*} \
			-initial yes -current yes
		
		if { [string is true $::plugins::DYE::settings(dsx2_show_shot_desc_on_home)] } {
			dui item hide $page {bb_dye_bg* s_dye_bg* b_dye_bg* l_dye_bg li_dye_bg launch_dye*} \
				-initial yes -current yes
		}
	}
	
	proc toggle_show_shot_desc { } {
		variable main_graph_height
		set main_home_page [lindex $::skin_home_pages 0]
	
		# Show or hide DYE launch button on the workflow GHC functions buttons row
		if { [string is true $::plugins::DYE::settings(dsx2_show_shot_desc_on_home)] } {
			dui item config $main_home_page {launch_dye_last* launch_dye_next* launch_dye_dsx2_hv*} \
				-initial_state normal
			dui item config $main_home_page live_graph_data -initial_state hidden
			$::home_espresso_graph configure -height $main_graph_height
			
			dui item config $main_home_page {bb_dye_bg* s_dye_bg* b_dye_bg* l_dye_bg li_dye_bg launch_dye*} \
				-initial_state hidden		
		} else {
			dui item config $main_home_page {launch_dye_last* launch_dye_next* launch_dye_dsx2_hv*} \
				-initial_state hidden
			
			dui item config $::skin_home_pages live_graph_data -initial_state normal
			if { [dui item cget $main_home_page graph_a -initial_state] ne "normal" } {
				$::home_espresso_graph configure -height [rescale_y_skin 1010]
			}
			
			dui item config $main_home_page {bb_dye_bg* s_dye_bg* b_dye_bg* l_dye_bg li_dye_bg launch_dye*} \
				-initial_state normal				
		}
	}
	
	proc adjust_hook { adjust_args args } {
		::plugins::DYE::shots::define_next_desc
		
		set adjust_var [lindex $adjust_args 1]
		if { $adjust_var eq "dose" } {
			set adjust_var "grinder_dose_weight"
		} elseif { $adjust_var eq "saw" } {
			set adjust_var "drink_weight"
		}		
		::plugins::DYE::favorites::clear_selected_if_needed $adjust_var
	}

	proc home_shot_desc_clicked { side } {
		set current_page [dui::page::current]
		if { $side eq "left" } {
			if { $current_page eq "dsx2_dye_hv" } {
				::plugins::DYE::pages::dsx2_dye_hv::click_base_description
			} else {
				::plugins::DYE::open -which_shot "source"
			}
		} elseif { $side eq "right" } {
			if { $current_page eq "dsx2_dye_hv" } {
				::plugins::DYE::pages::dsx2_dye_hv::click_comp_description
			} else {
				::plugins::DYE::open -which_shot "next"
			}
		}
	}
	
	proc home_shot_desc_longclicked { side } {
		set current_page [dui::page::current]
		if { $side eq "left" } {
			if { $current_page eq "dsx2_dye_hv" } {
				home_shot_desc_clicked left
			} else {
				dui page open_dialog dye_which_shot_dlg -coords {50 1350} -anchor sw
			}
		} else {
			if { $current_page eq "dsx2_dye_hv" } {
				home_shot_desc_clicked right
			} else {
				dui page open_dialog dye_which_shot_dlg -coords {1950 1350} -anchor se
			}
		}
	}
	
	proc change_grinder_setting_entry { } {
		set ::settings(grinder_setting) $::plugins::DYE::settings(next_grinder_setting)
		plugins save_settings DYE
		::save_settings
		::plugins::DYE::shots::define_next_desc
	}

	# change needs to be one of plus_small, plus_big, minus_small or minus_big.
	proc change_grinder_setting { change } {
		set page [lindex $::skin_home_pages 0]
		array set spec [::plugins::DYE::grinders::get_spec]
		if { [array size spec] == 0 } {
			# Shouldn't happen if ensure_valid_grinder_spec has been used
			return
		}
		
		dui item enable $page wf_grinder_setting*
		
		set setting $::plugins::DYE::settings(next_grinder_setting)
		if { $setting eq {} } {
			set setting [value_or_default spec(default) 1.5]
		}
		
		if { [string is true [value_or_default spec(is_numeric) 1]] } {
			switch $change \
				plus_big {
					set setting [expr {$setting + [ifexists spec(big_step) 1]}]
				} plus_small {
					set setting [expr {$setting + [ifexists spec(small_step) 0.1]}]
				} minus_big {
					set setting [expr {$setting - [ifexists spec(big_step) 1]}]
				} minus_small {
					set setting [expr {$setting - [ifexists spec(small_step) 0.1]}]
				}
			
			if { $setting < [ifexists spec(min) 0.0] } {
				set setting $spec(min)
				dui item disable $page {wf_grinder_setting_minus_small* wf_grinder_setting_minus_big*}
			} elseif { $setting > [ifexists spec(max) 50.0] } {	
				set setting $spec(max)
				dui item disable $page {wf_grinder_setting_plus_small* wf_grinder_setting_plus_big*}
			}
			
			set max_dec [value_or_default spec(max_dec) 2]
			if { $max_dec == 0 } {
				set setting [round_to_integer $setting]
			} elseif { $max_dec == 1 } {
				set setting [round_to_one_digits $setting]
			} else {
				set setting [round_to_two_digits $setting]
			}
		} else {
			set values [value_or_default spec(values) {}]
			set big_step [value_or_default spec(big_step) 5]
			if { [llength $values] > 0 } {
				set setting_idx [lsearch $values $setting]
				if { $setting_idx > -1 } {
					switch $change \
						plus_big {
							incr setting_idx $big_step
						} plus_small {
							incr setting_idx 1
						} minus_big {
							incr setting_idx -$big_step
						} minus_small {
							incr setting_idx -1
						}
					if { $setting_idx < 0 } {
						set setting_idx 0
						dui item disable $page {wf_grinder_setting_minus_small* wf_grinder_setting_minus_big*}
					} elseif { $setting_idx >= [llength $values] } {
						set setting_idx [expr {[llength $values]-1}]
						dui item disable $page {wf_grinder_setting_plus_small* wf_grinder_setting_plus_big*}
					} 
					set setting [lindex $values $setting_idx]
				} else {
					set setting [value_or_default spec(default) [lindex $values 0]]
				}
			}
		}
		
		set ::plugins::DYE::settings(next_grinder_setting) $setting
		plugins save_settings DYE
		
		if { $setting ne $::settings(grinder_setting) } {
			set ::settings(grinder_setting) $setting
			::save_settings
		}
		
		::plugins::DYE::favorites::clear_selected_if_needed grinder_setting
		::plugins::DYE::shots::define_next_desc
	}	
	
	proc select_beans {} {
		variable ::plugins::DYE::settings
		say "" $::settings(sound_button_in)
		
		set selected [string trim "$settings(next_bean_brand) $settings(next_bean_type) $settings(next_roast_date)"]
		regsub -all " +" $selected " " selected

		# [::plugins::SDB::available_categories bean_desc]
		set db ::plugins::SDB::get_db
		set beans [list]
		set last_clocks [list]
		set details [list]
		db eval {SELECT bean_desc, MAX(clock) AS last_clock, COUNT(clock) AS n_shots FROM V_shot s \
				WHERE removed=0 AND LENGTH(TRIM(COALESCE(bean_desc,''))) > 0  \
				GROUP BY bean_desc ORDER BY MAX(clock) DESC} {
			lappend beans $bean_desc
			set detail ""
			if { [return_zero_if_blank $n_shots] > 0 } {
				append detail "$n_shots [translate {shots}]"
			} else {
				append detail [translate "no shots"]
			}
			set last_clock [return_zero_if_blank $last_clock]
			lappend last_clocks $last_clock
			if { $last_clock > 0 } {
				append detail ", last [::plugins::DYE::format_date $last_clock]"
			}
			lappend details $detail
		}
		
		dui page open_dialog dye_item_select_dlg {} $beans -values_details $details -values_extras $last_clocks \
			-coords {490 1580} -anchor s -theme [dui theme get] -page_title "Select beans" \
			-category_name beans -allow_add 1 -add_label "Add new beans" \
			-add_embedded 0 -option1 $settings(beans_select_copy_to_next) \
			-option1_label "Copy beans last shot to Next" \
			-empty_items_msg "No beans to show" -default_filter_msg "Search beans..." \
			-selected $selected -return_callback [namespace current]::select_beans_callback
	}
	
	proc select_beans_callback { {bean_desc {}} {idx {}} {last_clock {}} {item_type {}} \
			{load_last_shot_into_next 0} {option2 {}} args } {
		variable ::plugins::DYE::settings
		dui page show [lindex $::skin_home_pages 0]

		set settings(beans_select_copy_to_next) $load_last_shot_into_next
				
		if { $idx eq "<ADD_NEW>" } {
			foreach fn {bean_brand bean_type roast_level roast_date bean_notes} {
				set ::settings($fn) {}
				set settings(next_$fn) {} 
			}
			plugins::save_settings DYE
			::save_settings
			
			::plugins::DYE::open -which_shot next
		} elseif { $bean_desc ne "" } {
			if { [string is true $load_last_shot_into_next] && [return_zero_if_blank $last_clock] > 0 } {
				set load_success [::plugins::DYE::shots::source_next_from $last_clock {} \
					$::plugins::DYE::settings(favs_n_recent_what_to_copy)]
				if { [string is true $load_success] } {
					dui say [translate "Last shot with selected beans copied to next"] 
				} else {
					dui say [translate "Error loading last shot with selected beans"]
				}
			} elseif { [return_zero_if_blank $last_clock] > 0 } {
				set db ::plugins::SDB::get_db
				db eval {SELECT bean_brand,bean_type,roast_date,roast_level,bean_notes FROM V_shot \
						WHERE clock=$last_clock} {
					set settings(next_bean_brand) $bean_brand
					set ::settings(bean_brand) $bean_brand
					set settings(next_bean_type) $bean_type
					set ::settings(bean_type) $bean_type
					set ::plugins::DYE::settings(next_roast_date) $roast_date
					set ::settings(roast_date) $roast_date
					set ::plugins::DYE::settings(next_roast_level) $roast_level
					set ::settings(roast_level) $roast_level
					set ::plugins::DYE::settings(next_bean_notes) $bean_notes
					set ::settings(bean_notes) $bean_notes
				}
				plugins::save_settings DYE
				::save_settings
				
				::plugins::DYE::favorites::clear_selected_if_needed bean_type
				::plugins::DYE::shots::define_next_desc
			}
			compute_days_offroast
		} else {
			plugins::save_settings DYE
		}
	}
	
	# TODO: Refactor this calculation into its own general proc in ::plugins::DYE
	proc compute_days_offroast { {reformat 1} } {
		variable ::plugins::DYE::settings
		variable data
		
		set roast_date [string trim $settings(next_roast_date)]	
		if { $roast_date eq "" } {
			set data(days_offroast_msg) ""
			if { $::settings(roast_date) ne {} } {
				set ::settings(roast_date) {}
				::save_settings
				::plugins::DYE::favorites::clear_selected_if_needed roast_date
			}
			return
		} 
			
		set fmt $settings(date_input_format)
		if { $fmt ni {MDY DMY YMD} } {
			set fmt "MDY"
		}
		
		set roast_date [regsub -all {[^0-9[:alpha:]]} $roast_date -]
		set roast_date [regsub -all {\-+} $roast_date -]
		set roast_date_parts [list_remove_element [split $roast_date -] ""]
		
		if { [llength $roast_date_parts] == 1 } {
			set day [lindex $roast_date_parts 0]
			set month {}
			set year {}
		} elseif { [llength $roast_date_parts] == 2 } {
			if { $fmt eq "DMY" } {
				set day [lindex $roast_date_parts 0]
				set month [lindex $roast_date_parts 1]
				set year {}
			} else {
				set day [lindex $roast_date_parts 1]
				set month [lindex $roast_date_parts 0]
				set year {}	
			}
		} else {
			if { $fmt eq "DMY" } {
				set day [lindex $roast_date_parts 0]
				set month [lindex $roast_date_parts 1]
				set year [lindex $roast_date_parts 2]
			} elseif { $fmt eq "YMD" } {
				set day [lindex $roast_date_parts 2]
				set month [lindex $roast_date_parts 1]
				set year [lindex $roast_date_parts 0]
			} else {
				set day [lindex $roast_date_parts 1]
				set month [lindex $roast_date_parts 0]
				set year [lindex $roast_date_parts 2]
			}
		}
		
		if { $month ne "" && ![string is integer [scan $month %d]] } {
			set month [lsearch -nocase {jan feb mar apr may jun jul aug sep oct nov dec} [string range $month 0 2]]
			if { $month == -1 } {
				set month {}
			} else {
				incr month
			}
		}
		
		set ref_date [clock seconds]
		
		if { $month eq "" } {
			if { $day <= [clock format $ref_date -format %d] } {
				set month [clock format $ref_date -format %N]
				set year [clock format $ref_date -format %Y]
			} elseif { [clock format $ref_date -format %N] == 1 } {
				set month 12
				set year [expr {[clock format $ref_date -format %Y]-1}]
			} else {
				set month [expr {[clock format $ref_date -format %N]-1}]
				set year [clock format $ref_date -format %Y]
			}
		} elseif { $year eq "" } {
			set daymonth_thisyear ""
			catch {
				set daymonth_thisyear [clock scan "${day}.${month}.[clock format $ref_date -format %Y]" -format "%d.%m.%Y"]
			}
			if { $daymonth_thisyear ne "" && $daymonth_thisyear > $ref_date } {
				set year [expr {[clock format $ref_date -format %Y]-1}]
			} else {
				set year [clock format $ref_date -format %Y]
			}
		}
	
		if { $year > 1900 } {
			set year_fmt "%Y"
		} else {
			set year_fmt "%y"
		}
		
		set roast_clock ""
		set data(days_offroast_msg) ""
		try {
			set roast_clock [clock scan "${day}.${month}.${year}" -format "%d.%m.${year_fmt}"]
		} on error err {
			msg -NOTICE [namespace current] compute_days_offroast: "can't parse roast date '$roast_date' as '${day}.${month}.${year}': $err"
		}
		
		if { $roast_clock ne "" } {
			if { [string is true $reformat] } {
				set reformatted_date [clock format $roast_clock -format [::plugins::DYE::roast_date_format]]
				set reformatted_date [regsub -all {[[:space:]]+} [string trim $reformatted_date] " "]
				if { [llength $roast_date_parts] > 3 } {
					append reformatted_date " [join [lrange $roast_date_parts 3 end] { }]"
				}
				set settings(next_roast_date) $reformatted_date
			}
			
			set days [expr {int(($ref_date-$roast_clock)/(24.0*60.0*60.0))}]
			if { $days >= 0 } {
				set data(days_offroast_msg) [::plugins::DYE::singular_or_plural $days {day off-roast} {days off-roast}]
			} else {
				set data(days_offroast_msg) [translate {Date in the future!}]
			}
		}
		
		if { $::settings(roast_date) ne $settings(next_roast_date) } {
			set ::settings(roast_date) $settings(next_roast_date)
			::save_settings
			::plugins::DYE::favorites::clear_selected_if_needed roast_date
		}
	}
	
	proc select_grinder { } {
		variable data
		variable ::plugins::DYE::settings
		say "" $::settings(sound_button_in)

		# Compute the last setting for each grinder, if possible matching beans and profile,
		# o/w only beans, o/w only profile, o/w just the last one.		
		set db ::plugins::SDB::get_db
		set grinder_models [list]
		set last_grinder_settings [list]
		db eval {SELECT grinder_model, grinder_setting FROM shot s \
				WHERE trim(coalesce(grinder_model,''))<>'' \
					AND clock=(SELECT MAX(clock) FROM shot WHERE grinder_model=s.grinder_model) \
				GROUP BY grinder_model ORDER BY MAX(clock) DESC} {
			lappend grinder_models $grinder_model
			lappend last_grinder_settings $grinder_setting
		}
		# Add grinders from the settings, if needed
		foreach grinder [::plugins::DYE::grinders::models] {
			if { $grinder ni $grinder_models } {
				lappend grinder_models $grinder
				array set gspec [::plugins::DYE::grinders::get_spec $grinder]
				lappend last_grinder_settings [::plugins::DYE::grinders::get_default_setting $grinder]
			}
		}
		
		# Find grinder settings matching beans, if available
		set grinder_setting_match [lrepeat [llength $grinder_models] "no beans match"]
		
		if { $::plugins::DYE::settings(next_bean_brand) ne {} || \
				$::plugins::DYE::settings(next_bean_type) ne {} } {
			db eval {SELECT grinder_model, grinder_setting FROM shot s \
					WHERE trim(coalesce(grinder_model,''))<>'' \
						AND bean_brand=$::plugins::DYE::settings(next_bean_brand) \
						AND bean_type=$::plugins::DYE::settings(next_bean_type) \
						AND clock=(SELECT MAX(clock) FROM shot WHERE grinder_model=s.grinder_model \
							AND bean_brand=s.bean_brand AND bean_type=s.bean_type) \
					GROUP BY grinder_model ORDER BY MAX(clock) DESC} {
				if { $grinder_setting ne {} } {
					set grinder_idx [lsearch -nocase $grinder_models $grinder_model]
					if { $grinder_idx > -1 } {
						lset last_grinder_settings $grinder_idx $grinder_setting
						lset grinder_setting_match $grinder_idx "matching beans"
					}
				}
			}
		}

		set grinder_details [list]
		for { set i 0 } { $i < [llength $last_grinder_settings] } { incr i 1 } {
			if { [lindex $last_grinder_settings $i] eq {} } {
				lappend grinder_details {}
			} else {
				lappend grinder_details "[translate {Last setting:}] [lindex $last_grinder_settings $i] ([translate [lindex $grinder_setting_match $i]])" 
			}
		}

		# WARNING: Don't pass the DYE settings variable to the dialog, as in the callback we need
		#	to check whether it has been changed to know what to do with the setting
		dui page open_dialog dye_item_select_dlg {} \
			 $grinder_models -values_details $grinder_details -values_extras $last_grinder_settings \
			-coords {490 1580} -anchor s -theme [dui theme get] -page_title "Select grinder model" \
			-allow_add 1 -add_label "Add new grinder" -add_embedded 1 -category_name grinder \
			-option1 $settings(grinder_select_load_last_setting) -option1_label "Load last grinder setting" \
			-empty_items_msg "No grinders to show" -default_filter_msg "Search grinders..." \
			-default_new_item_msg "New grinder name" -selected [string trim $settings(next_grinder_model)] \
			-return_callback [namespace current]::select_grinder_callback
	}
	
	proc select_grinder_callback { {grinder_model {}} {id {}} {last_grinder_setting {}} {type {}} \
			{load_last_grinder_setting 0} {option2 {}} args } {
		variable ::plugins::DYE::settings
		variable data
		dui page show [lindex $::skin_home_pages 0]

		set settings(grinder_select_load_last_setting) $load_last_grinder_setting
		set needs_saving 0
		set orig_grinder_setting $settings(next_grinder_setting)
				
		if { $grinder_model ne ""} {
			if { $grinder_model ne $settings(next_grinder_model) } {
				set settings(next_grinder_model) $grinder_model
				set ::settings(grinder_model) $grinder_model
				::plugins::DYE::favorites::clear_selected_if_needed grinder_model
				set needs_saving 1
			}
			if { [string is true $load_last_grinder_setting] && $last_grinder_setting ne {}} {
				set settings(next_grinder_setting) $last_grinder_setting
				set ::settings(grinder_setting) $last_grinder_setting
				::plugins::DYE::favorites::clear_selected_if_needed grinder_setting
			} elseif { $needs_saving } {
				# Grinder changed, if we are not using the last setting, the default is loaded
				set default_setting [::plugins::DYE::grinders::get_default_setting $grinder_model]

				set settings(next_grinder_setting) $default_setting
				set ::settings(grinder_setting) $default_setting
				
			}
			
			# ensure_valid_grinder_spec may modify the setting, so we tell it not to save 
			# (to avoid saving settins twice) and check afterwards
			ensure_valid_grinder_spec 1 0
			
			if { $settings(next_grinder_setting) ne $orig_grinder_setting } {
				::plugins::DYE::favorites::clear_selected_if_needed grinder_setting
				set needs_saving 1
			}
		}

		if { $needs_saving } {
			::save_settings			
			::plugins::save_settings DYE
			::plugins::DYE::shots::define_next_desc
		}
	}
	
	proc ensure_valid_grinder_spec { {check_setting 1} {save_settings 1} } {
		variable ::plugins::DYE::settings
		
		set page [lindex $::skin_home_pages 0]
		set grinder $settings(next_grinder_model)
		array set spec [::plugins::DYE::grinders::get_spec $grinder]
		
		if { [array size spec] == 0 } {
			dui item disable $page wf_grinder_setting*
			dui item show $page wf_grinder_setting_entry
			msg -NOTICE [namespace current] "::ensure_valid_grinder_spec: no spec for next grinder model '$grinder'"
		} elseif { [string is true $check_setting] } { 
			if { $settings(next_grinder_setting) ne {}} {
				set gsetting $settings(next_grinder_setting)
				if { [string is true [value_or_default spec(is_numeric) 1]] } {
					if { [string is double $gsetting] } {
						set  gsetting [number_in_range $gsetting 0 [value_or_default spec(min) 0.0] \
							[value_or_default spec(max) 100.0] 0 [value_or_default spec(max_dec) 2]]
						if { $gsetting != $settings(next_grinder_setting) } {
							set ::plugins::DYE::settings(next_grinder_setting) $gsetting
							set ::settings(grinder_setting) $gsetting
							if { [string is true $save_settings] } {
								plugins save_settings DYE
								::save_settings
							}
						}
						dui item enable $page wf_grinder_setting*
						dui item hide $page wf_grinder_setting_entry
					} else {
						dui item disable $page wf_grinder_setting*
						dui item show $page wf_grinder_setting_entry
						msg -NOTICE [namespace current] "::ensure_valid_grinder_spec: grinder setting '$gsetting' is not a number"							
					}
				} else {
					if { $gsetting in $spec(values) } {
						dui item enable $page wf_grinder_setting*
						dui item hide $page wf_grinder_setting_entry
					} else {
						dui item disable $page wf_grinder_setting*
						dui item show $page wf_grinder_setting_entry
						msg -NOTICE [namespace current] "::ensure_valid_grinder_spec: grinder setting '$gsetting' is not among valid set of values"
					}
				}
			}
		} else {
			dui item enable $page wf_grinder_setting*
			dui item hide $page wf_grinder_setting_entry
		}
	}
	
	proc set_scale_weight_to_dose_hook { args } {
		::plugins::DYE::shots::define_next_desc
	}
	

	# Modified from ::restore_live_graphs
	proc load_home_graph_from { {src_clock {}} {src_array_name {}} {reset_compare 1} } {
		if { [string is integer $src_clock] && $src_clock > 0 } {
			array set src_shot [::plugins::SDB::load_shot $src_clock 1 1 0 0]
		} elseif { $src_array_name ne {} } {
			upvar $src_array_name src_shot
		} else {
			msg -ERROR [namespace current] "load_home_graph_from: Invoked without input shot"
			return
		}
		
		#set last_elapsed_time_index [expr {[espresso_elapsed length] - 1}]
		if { ! [info exists src_shot(graph_espresso_elapsed)] } {
			msg -WARNING [namespace current] "load_home_graph_from: source shot data doesn't include 'graph_espresso_elapsed'"
			return
		}
		if {[llength $src_shot(graph_espresso_elapsed)] < 2} {
			msg -WARNING [namespace current] "load_home_graph_from: source espresso_elapsed only has 0 or 1 elements"			
			return
		}
		
		src_elapsed set $src_shot(graph_espresso_elapsed)
		
		src_temperature_goal10th set [::struct::list mapfor x $src_shot(graph_espresso_temperature_goal) \
				{skin_temperature_units $x}] 
		$::home_espresso_graph element configure home_temperature_goal -xdata src_elapsed -ydata src_temperature_goal10th

		if {$::settings(enable_fahrenheit) == 1} {
			src_temperature_goal set [::struct::list mapfor x $src_shot(graph_espresso_temperature_goal) \
					{celsius_to_fahrenheit $x}] 
		} else {
			src_temperature_goal set $src_shot(graph_espresso_temperature_goal)
		}	
		$::home_espresso_graph element configure home_zoom_temperature_goal -xdata src_elapsed -ydata src_temperature_goal
		
		src_temperature10th set [::struct::list mapfor x $src_shot(graph_espresso_temperature_basket) \
				{skin_temperature_units $x}] 
		$::home_espresso_graph element configure home_temperature -xdata src_elapsed -ydata src_temperature10th

		if {$::settings(enable_fahrenheit) == 1} {
			src_temperature set [::struct::list mapfor x $src_shot(graph_espresso_temperature_basket) \
					{celsius_to_fahrenheit $x}] 
		} else {
			src_temperature set $src_shot(graph_espresso_temperature_basket)
		}	
		$::home_espresso_graph element configure home_zoom_temperature -xdata src_elapsed -ydata src_temperature
		
		src_pressure_goal set $src_shot(graph_espresso_pressure_goal)
		$::home_espresso_graph element configure home_pressure_goal -xdata src_elapsed -ydata src_pressure_goal

		src_pressure set $src_shot(graph_espresso_pressure)
		$::home_espresso_graph element configure home_pressure -xdata src_elapsed -ydata src_pressure

		src_flow_goal set $src_shot(graph_espresso_flow_goal)
		$::home_espresso_graph element configure home_flow_goal -xdata src_elapsed -ydata src_flow_goal

		src_flow_goal_2x set [::struct::list mapfor x $src_shot(graph_espresso_flow_goal) \
				{round_to_two_digits [expr {2.0 * $x}]}]
		$::home_espresso_graph element configure home_flow_goal_2x -xdata src_elapsed -ydata src_flow_goal_2x
		
		src_flow set $src_shot(graph_espresso_flow)
		$::home_espresso_graph element configure home_flow -xdata src_elapsed -ydata src_flow

		src_flow_2x set [::struct::list mapfor x $src_shot(graph_espresso_flow) \
				{round_to_two_digits [expr {2.0 * $x}]}]
		$::home_espresso_graph element configure home_flow_2x -xdata src_elapsed -ydata src_flow_2x
		
		src_weight set $src_shot(graph_espresso_flow_weight)
		$::home_espresso_graph element configure home_weight -xdata src_elapsed -ydata src_weight
		
		src_weight_2x set [::struct::list mapfor x $src_shot(graph_espresso_flow_weight) \
				{round_to_two_digits [expr {2.0 * $x}]}]
		$::home_espresso_graph element configure home_weight_2x -xdata src_elapsed -ydata src_weight_2x

		src_weight_chartable set [::struct::list mapfor x $src_shot(graph_espresso_weight) \
				{round_to_two_digits [expr {0.1 * $x}]}] 
		$::home_espresso_graph element configure home_weight_chartable -xdata src_elapsed -ydata src_weight_chartable

		if {[info exists src_shot(graph_espresso_resistance)]} {
			src_resistance set $src_shot(graph_espresso_resistance)
		} else {
			src_resistance length 0
		}
		$::home_espresso_graph element configure home_resistance -xdata src_elapsed -ydata src_resistance
		
		if {[info exists src_shot(graph_espresso_state_change)]} {
			src_steps set $src_shot(graph_espresso_state_change)
		} else {
			src_steps length 0
		}
		$::home_espresso_graph element configure home_steps -xdata src_elapsed -ydata src_steps	
		
		if { [string is true $reset_compare] } {
			$::home_espresso_graph element configure compare_temperature -hide 1
			$::home_espresso_graph element configure compare_zoom_temperature -hide 1
			$::home_espresso_graph element configure compare_pressure -hide 1
			$::home_espresso_graph element configure compare_flow -hide 1
			$::home_espresso_graph element configure compare_flow_2x -hide 1
			$::home_espresso_graph element configure compare_weight -hide 1
			$::home_espresso_graph element configure compare_weight_2x -hide 1
			$::home_espresso_graph element configure compare_weight_chartable -hide 1
			$::home_espresso_graph element configure compare_resistance -hide 1
			$::home_espresso_graph element configure compare_steps -hide 1
		}

		# Debug which series are created and their contents
#		foreach sn [$::home_espresso_graph element names] {
#			msg "GRAPH SERIES $sn: xdata=[$::home_espresso_graph element cget $sn -xdata], ydata=xdata=[$::home_espresso_graph element cget $sn -ydata]"
#		}
		::plugins::DYE::shots::define_last_desc src_shot
	}
		
	proc load_home_graph_comp_from { {comp_clock {}} {comp_array_name {}} } {
		if { [string is integer $comp_clock] && $comp_clock > 0 } {
			array set comp_shot [::plugins::SDB::load_shot $comp_clock 1 1 0 0]
		} elseif { $comp_array_name ne {} } {
			upvar $comp_array_name comp_shot
		} else {
			msg -ERROR [namespace current] "load_home_graph_comp_from: Invoked without input data"
			return
		}
		
		if { ! [info exists comp_shot(graph_espresso_elapsed)] } {
			msg -WARNING [namespace current] "load_home_graph_comp_from: comp shot data doesn't include 'graph_espresso_elapsed'"
			return
		}
		if {[llength $comp_shot(graph_espresso_elapsed)] < 2} {
			msg -WARNING [namespace current] "load_home_graph_comp_from: comp espresso_elapsed only has 0 or 1 elements"			
			return
		}

		compare_espresso_elapsed length 0
		compare_espresso_elapsed set $comp_shot(graph_espresso_elapsed)

		compare_espresso_temperature_basket10th set [::struct::list mapfor x \
				$comp_shot(graph_espresso_temperature_basket) {skin_temperature_units $x}]
		$::home_espresso_graph element configure compare_temperature -linewidth [rescale_x_skin 4] \
			-xdata compare_espresso_elapsed -ydata compare_espresso_temperature_basket10th \
			-hide [expr {$::skin(temperature) == 0}]
		
		if {$::settings(enable_fahrenheit) == 1} {
			compare_espresso_temperature_basket set [::struct::list mapfor x \
					$comp_shot(graph_espresso_temperature_basket) {celsius_to_fahrenheit $x}]
		} else {
			compare_espresso_temperature_basket set $comp_shot(graph_espresso_temperature_basket)
		}
		$::home_espresso_graph element configure compare_zoom_temperature -linewidth [rescale_x_skin 4] \
			-xdata compare_espresso_elapsed -ydata compare_espresso_temperature_basket
		
		compare_espresso_pressure set $comp_shot(graph_espresso_pressure)
		$::home_espresso_graph element configure compare_pressure -linewidth [rescale_x_skin 4] \
			-xdata compare_espresso_elapsed -ydata compare_espresso_pressure \
			-hide [expr {$::skin(pressure) == 0}]
		
		compare_espresso_flow set $comp_shot(graph_espresso_flow)
		$::home_espresso_graph element configure compare_flow -linewidth [rescale_x_skin 4] \
			-xdata compare_espresso_elapsed -ydata compare_espresso_flow \
			-hide [expr {$::skin(flow) == 0 || $::skin(show_y2_axis) == 1}] 
		
		compare_espresso_flow_2x set [::struct::list mapfor x $comp_shot(graph_espresso_flow) \
				{round_to_two_digits [expr {2.0 * $x}]}]
		$::home_espresso_graph element configure compare_flow_2x -linewidth [rescale_x_skin 4] \
			-xdata compare_espresso_elapsed -ydata compare_espresso_flow_2x \
			-hide [expr {$::skin(flow) == 0 || $::skin(show_y2_axis) == 0}]
		
		compare_espresso_flow_weight set $comp_shot(graph_espresso_flow_weight)
		$::home_espresso_graph element configure compare_weight -linewidth [rescale_x_skin 4] \
			-xdata compare_espresso_elapsed -ydata compare_espresso_flow_weight \
			-hide [expr {$::skin(weight) == 0 || $::skin(show_y2_axis) == 1}]
		
		compare_espresso_flow_weight_2x set [::struct::list mapfor x \
				$comp_shot(graph_espresso_flow_weight) {round_to_two_digits [expr {2.0 * $x}]}]
		$::home_espresso_graph element configure compare_weight_2x -linewidth [rescale_x_skin 4] \
			-xdata compare_espresso_elapsed -ydata compare_espresso_flow_weight_2x \
			-hide [expr {$::skin(weight) == 0 || $::skin(show_y2_axis) == 0}]

		compare_espresso_weight_chartable set [::struct::list mapfor x \
				$comp_shot(graph_espresso_weight) {round_to_two_digits [expr {0.1 * $x}]}] 
		$::home_espresso_graph element configure compare_weight_chartable -linewidth [rescale_x_skin 4] \
			-xdata compare_espresso_elapsed -ydata compare_espresso_weight_chartable \
			-hide [expr {$::skin(flow) == 0 || $::skin(show_y2_axis) == 1}] 

		compare_espresso_resistance set $comp_shot(graph_espresso_resistance)
		$::home_espresso_graph element configure compare_resistance -linewidth [rescale_x_skin 4] \
			-xdata compare_espresso_elapsed -ydata compare_espresso_resistance \
			-hide [expr {$::skin(resistance) == 0}]
		
		compare_espresso_state_change set $comp_shot(graph_espresso_state_change)
		$::home_espresso_graph element configure compare_steps -linewidth [rescale_x_skin 2] \
			-xdata compare_espresso_elapsed -ydata compare_espresso_state_change \
			-hide [expr {$::skin(steps) == 0}]
		
		#::check_graph_axis
		
		::plugins::DYE::shots::define_next_desc comp_shot	
	}
}

namespace eval ::plugins::DYE::pages::dsx2_dye_favs {
	variable widgets
	array set widgets {}
	
	variable data
	array set data {
		max_dsx2_home_visible_favs 5
		dsx2_n_visible_dye_favs 4
		dsx2_update_chart_on_copy 1
		dsx2_disable_dye_favs 0
		favs_group_by_beans 1
		favs_group_by_profile_title 1
		favs_group_by_workflow 1
		favs_group_by_grinder_model 1
		favs_settings_changed 0
	}
	
	# This proc also adds the first 5 favorite buttons to the DSx2 home page
	proc setup {} {
		variable data
		variable widgets	
		set page [namespace tail [namespace current]]
		
		dui::page::add_items [concat $page dsx2_dye_edit_fav dsx2_dye_hv] headerbar
		
		dui add dtext $page 1000 175 -text [translate "DYE Favorites"] -tags dye_favs_title -style page_title 
		
		# Options on the left "panel"
		set x 100
		set x_toggle_lbl_dist 150
		set x_2nd_group_offset 500 
		set y 300
		
		dui add dtext $page [expr $x] $y -tags favs_group_by_lbl -width 1000 -font_family notosansuibold \
			-text [translate "Group recent favorites by"]

		dui add dtext $page [expr $x+900] [expr $y+100] -width 900 -style error -tags favs_group_by_val_msg \
			-text [translate "At least one grouping variable needs to be selected"] -initial_state hidden

		dui add dtoggle $page $x [incr y 100] -anchor nw -tags favs_group_by_beans -variable favs_group_by_beans \
			-command {%NS::validate_group_by beans}
		dui add dtext $page [expr $x+$x_toggle_lbl_dist] $y -tags favs_group_by_beans_lbl -width 400 \
			-text [translate "Beans"]

		dui add dtoggle $page [expr $x+$x_2nd_group_offset] $y -anchor nw -tags favs_group_by_profile_title \
			-variable favs_group_by_profile_title -command {%NS::validate_group_by profile_title}
		dui add dtext $page [expr $x+$x_2nd_group_offset+$x_toggle_lbl_dist] $y \
			-tags favs_group_by_profile_title_lbl -width 400 -text [translate "Profile"]

		dui add dtoggle $page $x [incr y 125] -anchor nw -tags favs_group_by_workflow -variable favs_group_by_workflow \
			-command {%NS::validate_group_by workflow}
		dui add dtext $page [expr $x+$x_toggle_lbl_dist] $y -tags favs_group_by_workflow_lbl -width 400 \
			-text [translate "Workflow"]

		dui add dtoggle $page [expr $x+$x_2nd_group_offset] $y -anchor nw -tags favs_group_by_grinder_model \
			-variable favs_group_by_grinder_model -command {%NS::validate_group_by grinder_model}
		dui add dtext $page [expr $x+$x_2nd_group_offset+$x_toggle_lbl_dist] $y \
			-tags favs_group_by_grinder_model_lbl -width 400 -text [translate "Grinder"]
		
		dui add dtext $page $x [incr y 210] -width 1000 -anchor w \
			-text "[translate {Number of DYE favorites to show on home page}] (0-$data(max_dsx2_home_visible_favs))" 
		
		dui add dbutton $page [expr $x+1018] [expr $y-134] -bwidth 100 -bheight 100 -shape round \
			-symbol angle-up -symbol_pos {0.5 0.5} -symbol_font_size 34 \
			-command {%NS::change_dsx2_n_visible_dye_favs 1}
		dui add dbutton $page [expr $x+1018] [expr $y+35] -bwidth 100 -bheight 100 -shape round \
			-symbol angle-down -symbol_pos {0.5 0.5} -symbol_font_size 34 \
			-command {%NS::change_dsx2_n_visible_dye_favs -1}
		dui add variable $page [expr $x+1050] $y -fill $::skin_text_colour -font [skin_font font_bold 24] -anchor w \
			-tags dsx2_n_visible_dye_favs -textvariable dsx2_n_visible_dye_favs
		
		dui add dtoggle $page $x [incr y 200] -anchor nw -tags dsx2_update_chart_on_copy \
			-variable dsx2_update_chart_on_copy
		dui add dtext $page [expr $x+$x_toggle_lbl_dist] $y -tags dsx2_update_chart_on_copy_lbl -width 1400 \
			-text [translate "Show source shot chart on home page when loading a recent-type favorite"] 

		dui add dtoggle $page $x [incr y 275] -anchor nw -tags dsx2_disable_dye_favs -variable dsx2_disable_dye_favs \
			-command show_or_hide_disable_dye_favs_msg
		dui add dtext $page [expr $x+$x_toggle_lbl_dist] $y -tags dsx2_disable_dye_favs_lbl -width 1000 \
			-text [translate "Disable DYE favorites"] 

		dui add dtext $page [expr $x+600] $y -width 1000 -style error -tags disable_dye_favs_msg \
			-text [translate "When you leave this page, DSx2 favorites will be used instead of DYE favorites. You can re-enable DYE favorites from the DYE settings page."] -initial_state hidden

		# Favorites bar on the right
		set y -20
		set x
		for {set i 0} {$i < [::plugins::DYE::favorites::max_number]} {incr i 1} {
			if { $i < $data(max_dsx2_home_visible_favs) } {
				set target_pages [list $page dsx2_dye_edit_fav {*}$::skin_home_pages]
			} else {
				set target_pages [list $page dsx2_dye_edit_fav]
			}
			
			dui add dbutton $target_pages [expr {$::skin(button_x_fav)-75}] [incr y 120] -bwidth [expr 360+150] \
				-style dsx2 -tags [list dye_fav_$i dye_favs] -command [list %NS::load_favorite $i] \
				-labelvariable [subst {\[::plugins::DYE::favorites::fav_title $i\]}] \
				-label_font_size 11 -label_width 495 -label_pos {0.6 0.5} \
				-label1variable [::dui::symbol::get [::plugins::DYE::favorites::fav_icon_symbol $i]] \
				-label1_pos {50 0.5} -label1_anchor center -label1_justify center \
				-label1_font_family [dui::aspect::get symbol font_family] -label1_font_size 18 \
				-initial_state hidden
			
			dui add shape rect $target_pages [expr {$::skin(button_x_fav)+25}] [expr {$y+2}] \
				[expr {$::skin(button_x_fav)+29}] [expr {$y+99}] -width 0 \
				-fill $::skin_background_colour -tags [list dye_fav_l$i dye_fav_$i* dye_favs] \
				-initial_state hidden

			dui add dbutton $page [expr $::skin(button_x_fav)-175] $y -bwidth 100 -bheight 100 -shape "" \
				-fill $::skin_background_colour -tags [list dye_fav_edit_$i dye_fav_edits] \
				-command [list ::dui::page::load dsx2_dye_edit_fav $i] \
				-symbol pen -symbol_pos {0.5 0.5} -symbol_anchor center -symbol_justify center -symbol_font_size 20 \
				-symbol_fill $::skin_text_colour
		}
				
		dui add dbutton $::skin_home_pages [expr $::skin(button_x_fav)-50] \
			[expr 108+(120*$::plugins::DYE::settings(dsx2_n_visible_dye_favs))] \
			-bwidth 460 -bheight 80 -shape {} -fill $::skin_background_colour -tags dye_fav_more \
			-label {. . .} -label_font_size 20 -label_font_family notosansuibold -label_pos {0.5 0.2} \
			-label_fill $::skin_text_colour -command [list dui::page::load dsx2_dye_favs]
		
				
		# Bottom area
		dui add dbutton $page 800 1425 -bwidth 300 -bheight 100 -shape round -tags close_dye_edit_favs \
			-label [translate "Back"] -label_pos {0.5 0.5} -label_justify center -command page_done
		
		dui add dtext [list $page dsx2_dye_edit_fav dsx2_dye_hv] 2540 1580 -tags plugin_version \
			-font [skin_font font 13] -fill $::skin_text_colour -anchor e -text "DYE v$::plugins::DYE::version"
		
		show_or_hide_dye_favorites
	}

	proc load { page_to_hide page_to_show args } {
		variable data
		
		set data(dsx2_n_visible_dye_favs) $::plugins::DYE::settings(dsx2_n_visible_dye_favs)
		
		if { [string is true $::plugins::DYE::settings(dsx2_show_shot_desc_on_home)] } {
			set data(dsx2_update_chart_on_copy) [string is true $::plugins::DYE::settings(dsx2_update_chart_on_copy)]
			dui item enable $page_to_show dsx2_update_chart_on_copy -initial 1
		} else {
			set data(dsx2_update_chart_on_copy) 0
			dui item disable $page_to_show dsx2_update_chart_on_copy -initial 1 
		}
		
		foreach group_var [::plugins::DYE::favorites::all_grouping_vars] {
			set data(favs_group_by_$group_var) [expr \
				[lsearch -nocase $::plugins::DYE::settings(favs_n_recent_grouping) $group_var] > -1]
		}
		
		set data(dsx2_disable_dye_favs) 0
		
		return 1
	}
	
	proc show { page_to_hide page_to_show } {
		dui item config $page_to_show {dye_favs dye_favs_icons} -state normal
		change_selected_favorite
	}

#	proc hide { page_to_hide page_to_show } {
#		variable data
#		set favs_changed 0
#		
#		if { $::plugins::DYE::settings(dsx2_n_visible_dye_favs) != $data(dsx2_n_visible_dye_favs) } {
#			set ::plugins::DYE::settings(dsx2_n_visible_dye_favs) $data(dsx2_n_visible_dye_favs)
#			set favs_changed 1
#
#			if { $data(dsx2_disable_dye_favs) == 0 } {
#				show_or_hide_dye_favorites 1
#			}
#		}
#		
#		if { $::plugins::DYE::settings(dsx2_update_chart_on_copy) != $data(dsx2_update_chart_on_copy) } {
#			set ::plugins::DYE::settings(dsx2_update_chart_on_copy) $data(dsx2_update_chart_on_copy)
#			set favs_changed 1
#		}
#			
#		set group_recent_by [list]
#		foreach group_var {beans profile workflow grinder} {
#    		if { $data(favs_group_by_$group_var) == 1 } {
#    			lappend group_recent_by $group_var
#    		}
#		}
#		if { $::plugins::DYE::settings(favs_n_recent_grouping) ne $group_recent_by } {
#			set ::plugins::DYE::settings(favs_n_recent_grouping) $group_recent_by
#			set favs_changed 1
#			::plugins::DYE::update_favorites
#		}
#			
#		if { $data(dsx2_disable_dye_favs) == 1 } {
#			set ::plugins::DYE::settings(dsx2_use_dye_favs) 0
#			set favs_changed 1
#			show_or_hide_dye_favorites 0
#		} else {
#			# Ensure DSx2 home pages shows the correct number of favorites
#			# when returning
##			for {set i 0} {$i < $data(dsx2_n_visible_dye_favs)} {incr i 1} {
##				dui item config [lindex $::skin_home_pages 0] dye_fav_$i -initial_state normal -state normal
##			}
#			
##			for {set i $::plugins::DYE::settings(dsx2_n_visible_dye_favs)} {$i < $data(max_dsx2_home_visible_favs)} {incr i 1} {
##				dui item config [lindex $::skin_home_pages 0] dye_fav_$i -initial_state hidden -state hidden 
##			}
#		}
#			
#		if { $favs_changed == 1 } { 
#			plugins::save_settings DYE
#		}
#	}

	# Globally Enables/Shows or Disables/Hides the DYE favorites.
	# Beware this is called from different pages, so -state changes need to be made conditional
	#	to whether favorites are actually visible now or not.
	proc show_or_hide_dye_favorites { {show {}} } {
		variable widgets
		variable data
		set page [namespace tail [namespace current]]
		set are_favs_visible [expr {[dui page current] in [list {} $page {*}$::skin_home_pages]}]
		
		if {$show eq {}} {
			set show $::plugins::DYE::settings(dsx2_use_dye_favs)
		}
		
		if {[string is true $show]} {
			set dsx2_favs_state hidden
			set dye_favs_state normal
		} else {
			set dsx2_favs_state normal
			set dye_favs_state hidden
			::rest_fav_buttons
		}
		
		# Show or hide DSx2 favorites
		set main_home_page [lindex $::skin_home_pages 0]
		for { set i 1 } { $i < 6 } { incr i } {
			dui item config $main_home_page [list bb_fav$i* s_fav$i* b_fav$i l_fav$i li_fav$i \
				b_fav${i}_edit l_fav${i}_edit] -initial_state $dsx2_favs_state
			
			if { $are_favs_visible } {
				dui item config $main_home_page [list bb_fav$i* s_fav$i* b_fav$i l_fav$i li_fav$i \
					b_fav${i}_edit l_fav${i}_edit] -state $dsx2_favs_state
			}
		}
	
#		if { $are_favs_visible } {
#			dui item config $main_home_page {bb_dye_bg* s_dye_bg* b_dye_bg l_dye_bg li_dye_bg launch_dye*} \
#				-state $dsx2_favs_state
#		}

		# Show or hide DYE favorites
		for {set i 0} {$i < $::plugins::DYE::settings(dsx2_n_visible_dye_favs)} {incr i 1} {
			dui item config $main_home_page dye_fav_$i* -initial_state $dye_favs_state
			if { $are_favs_visible } {
				dui item config $main_home_page dye_fav_$i* -state $dye_favs_state
			}
		}
		for {set i $::plugins::DYE::settings(dsx2_n_visible_dye_favs)} {$i < $data(max_dsx2_home_visible_favs)} {incr i 1} {
			dui item config $main_home_page dye_fav_$i* -initial_state hidden -state hidden
		}
		if { $are_favs_visible } {
			change_selected_favorite
		}
		
		dui item config $main_home_page dye_fav_more* -initial_state $dye_favs_state
		dui item moveto $main_home_page dye_fav_more* [expr $::skin(button_x_fav)-50] \
			[expr 108+(120*$::plugins::DYE::settings(dsx2_n_visible_dye_favs))]
	}
	
	proc validate_group_by { group_by_var } {
		variable data
		set page [namespace tail [namespace current]]
		
		if { $data(favs_group_by_beans) == 0 && $data(favs_group_by_grinder_model) == 0 && \
				$data(favs_group_by_workflow) == 0 && $data(favs_group_by_profile_title) == 0 } {
			set data(favs_group_by_$group_by_var) 1
			dui item show $page favs_group_by_val_msg
			after 2000 [list dui::item::hide $page favs_group_by_val_msg]
		} 
	}
	
	proc change_dsx2_n_visible_dye_favs { change } {
		variable data
		if { [string is integer $change] } {
			if { $data(dsx2_n_visible_dye_favs) + $change >= 0 && \
					$data(dsx2_n_visible_dye_favs) + $change <= $data(max_dsx2_home_visible_favs)} {
				set data(dsx2_n_visible_dye_favs) [expr $data(dsx2_n_visible_dye_favs) + $change]
			}
		}
	}
	
	proc show_or_hide_disable_dye_favs_msg {} {
		variable data
		set page [namespace tail [namespace current]]
	
		if { $data(dsx2_disable_dye_favs) == 1 } {
			dui item show $page disable_dye_favs_msg 
		} else {
			dui item hide $page disable_dye_favs_msg
		}
	}
	
	proc load_favorite { n_fav } {		
		set current_page [dui page current]
		if { $current_page eq "dsx2_dye_edit_fav" } {
			return
		}
		
		set sel_n_fav [::plugins::DYE::favorites::selected_n_fav]
		if { [::plugins::DYE::favorites::load $n_fav] } {
			if { $sel_n_fav > -1 } {
				dui item config dsx2_dye_favs dye_fav_${sel_n_fav}-lbl1 \
					-fill [::dui::aspect::get dbutton_label1 fill -style dsx2]  
			}
			set sel_n_fav [::plugins::DYE::favorites::selected_n_fav]
#			if { $sel_n_fav > -1 } {
#				after 210 [namespace current]::change_selected_favorite
#			}
		}
		
		if { $current_page eq "dsx2_dye_favs" } {
			page_done
		}
	}

	# Executed whenever DYE settings(selected_n_fav) is modified
	proc change_selected_favorite { args } {
		set sel_n_fav [::plugins::DYE::favorites::selected_n_fav]
		set max_n_fav [::plugins::DYE::favorites::max_number]
		set fill_c [::dui::aspect::get dbutton_label1 fill -style dsx2]

		if { $sel_n_fav > -1 && $sel_n_fav < $max_n_fav} {
			dui item config dsx2_dye_favs dye_fav_${sel_n_fav}-lbl1 \
				-fill $::skin_selected_colour
		}
		for { set i 0 } { $i < $max_n_fav } { incr i 1 } {
			if { $i != $sel_n_fav } {
				dui item config dsx2_dye_favs dye_fav_${i}-lbl1 -fill $fill_c
			}
		}
	}
	
	
	# Note that we cannot make all the button showing/hiding when changing the number of favorites shown if
	# we run this code in the "hide" proc/event (not sure why...) so we do here, at the risk that unexpectedly
	# going out of the page (e.g. GHC command) will not save the changes.
	proc page_done {} {
		variable data
		set favs_changed 0
		
		if { $::plugins::DYE::settings(dsx2_n_visible_dye_favs) != $data(dsx2_n_visible_dye_favs) } {
			set ::plugins::DYE::settings(dsx2_n_visible_dye_favs) $data(dsx2_n_visible_dye_favs)
			set favs_changed 1

			if { $data(dsx2_disable_dye_favs) == 0 } {
				show_or_hide_dye_favorites 1
			}
		}
		
		set group_recent_by [list]
		foreach group_var [::plugins::DYE::favorites::all_grouping_vars] {
			if { $data(favs_group_by_$group_var) == 1 } {
				lappend group_recent_by $group_var
			}
		}
		if { $::plugins::DYE::settings(favs_n_recent_grouping) ne $group_recent_by } {
			set ::plugins::DYE::settings(favs_n_recent_grouping) $group_recent_by
			set favs_changed 1
			::plugins::DYE::favorites::update_recent
		}
		
		if { [string is true $::plugins::DYE::settings(dsx2_show_shot_desc_on_home)] } {
			if { $data(dsx2_update_chart_on_copy) == 1 && \
					! [string is true $::plugins::DYE::settings(dsx2_update_chart_on_copy)] } {
				if { $data(dsx2_disable_dye_favs) == 0 && \
						$::plugins::DYE::settings(next_src_clock) != [ifexists ::settings(espresso_clock) 0]} {
					::plugins::DYE::pages::dsx2_dye_home::load_home_graph_from $::plugins::DYE::settings(next_src_clock)
				}
				set ::plugins::DYE::settings(dsx2_update_chart_on_copy) 1
				set favs_changed 1
			} elseif { $data(dsx2_update_chart_on_copy) == 0 && \
						[string is true $::plugins::DYE::settings(dsx2_update_chart_on_copy)] } {
				if { $data(dsx2_disable_dye_favs) == 0 && \
						$::plugins::DYE::settings(next_src_clock) != [ifexists ::settings(espresso_clock) 0]} {
					::plugins::DYE::pages::dsx2_dye_home::load_home_graph_from $::settings(espresso_clock)
				}
				set ::plugins::DYE::settings(dsx2_update_chart_on_copy) 0
				set favs_changed 1
			}
		}
		
		if { $data(dsx2_disable_dye_favs) == 1 } {
			set ::plugins::DYE::settings(dsx2_use_dye_favs) 0
			set favs_changed 1
			show_or_hide_dye_favorites 0
		}
			
		if { $favs_changed == 1 } { 
			plugins::save_settings DYE
		}

		# Don't need to save_description here, it is done automatically in dui::pages::DYE::hide.
		dui sound make sound_button_in
		dui page close_dialog
	}
}

namespace eval ::plugins::DYE::pages::dsx2_dye_edit_fav {
	variable widgets
	array set widgets {}
	
	variable data
	array set data {
		page_title {Edit DYE Favorite}
		fav_number -1
		
		current_fav_type {n_recent}
		current_fav_title {}
		current_fav_values {} 
		
		fav_type n_recent
		fav_title {}
		
		fav_workflow {}	
		fav_steam_timeout 0
		fav_hotwater_flow 0
		fav_water_temperature 0
		fav_water_volume 0
		fav_steam_disabled 0
		fav_profile_title {}
		fav_profile_filename {}
		fav_bean_brand {}
		fav_bean_type {}
		fav_roast_level {}
		fav_roast_date {}
		fav_bean_notes {}
		fav_grinder_model {}
		fav_grinder_setting 0
		fav_grinder_dose_weight 0
		fav_drink_weight 0
		fav_espresso_notes {}
		fav_my_name {}
		fav_drinker_name {}
		
		fav_copy_workflow 1	
		fav_copy_workflow_settings 1
		fav_copy_profile_title 1
		fav_copy_full_profile 1
		fav_copy_beans 1
		fav_copy_roast_date 1
		fav_copy_grinder_model 1
		fav_copy_grinder_setting 1
		fav_copy_grinder_dose_weight 1
		fav_copy_drink_weight 1
		fav_copy_espresso_notes 0
		fav_copy_my_name 0
		fav_copy_drinker_name 0
	}

	# all_recent keeps an "updated" 12th recent favs from the DB, so they
	# can be used as example data (e.g. if the data edited changes fav type).
	# It's updated only once per page load, on the change_fav_type() proc. 
	variable all_recent 
	array set all_recent {}
	
	variable copy_fields
	set copy_fields {workflow workflow_settings profile_title full_profile beans roast_date grinder_model \
		grinder_setting grinder_dose_weight drink_weight espresso_notes my_name drinker_name}
	
	variable fav_fields
	set fav_fields {workflow steam_timeout hotwater_flow water_temperature water_volume steam_disabled \
		profile_title profile_filename bean_brand bean_type roast_level roast_date bean_notes \
		grinder_model grinder_setting grinder_dose_weight drink_weight espresso_notes \
		my_name drinker_name}
	
	proc setup {} {
		variable data
		variable widgets	
		set page [namespace tail [namespace current]]
		
		#dui::page::add_items $page headerbar
		
		dui add variable $page 1000 175 -textvariable {page_title} -tags dye_edit_fav_title -style page_title 
		
		# Vertical bracket
		set x [expr $::skin(button_x_fav)-135]
		set y 125
		set bracket_height 1350
		dui add canvas_item arc $page [expr $x-50+4] [expr $y-50+8] [expr $x+4] [expr $y+50] -start 0 \
			-width [dui::page::calc_width $page 8] -style {} -style arc -outline $::skin_forground_colour \
			-tags {edit_bracket_top edit_bracket} 
		dui add canvas_item arc $page [expr $x-50+4] [expr $y+$bracket_height-50] [expr $x+4] [expr $y+$bracket_height+50-8] -start 275 \
			-width [dui::page::calc_width $page 8] -style {} -style arc -outline $::skin_forground_colour \
			-tags {edit_bracket_bottom edit_bracket}
		dui add canvas_item rect $page $x $y [expr $x+8] [expr $y+$bracket_height] -width 0 -fill $::skin_forground_colour -tags {edit_bracket_line edit_bracket}
		set y 147
		dui add canvas_item polygon $page [expr $x+8] [expr $y+100] [expr $x+8+35] [expr $y+100+20] [expr $x+8] [expr $y+100+40] \
			-fill $::skin_forground_colour -tags {edit_bracket_index edit_bracket}

		# Favorite editing
		set x 100
		set x_2nd_what_offset 400
		set x_right [expr $::skin(button_x_fav)-175-100]
		set x_data 1100
		set y 265
		set x_toggle_lbl_dist 140
		
		dui add dtext $page $x [expr $y+25] -tags {fav_type_lbl fav_editing} -width 280 \
			-text [translate "Favorite type"] 
		dui add dselector $page [expr $x+300] $y -bwidth 800 -anchor nw -tags {fav_type fav_editing} \
			-variable fav_type -values {n_recent fixed} -command change_fav_type \
			-labels [list [translate "Recent"] [translate "Fixed"]]
		# Temporal text
#		dui add dtext $page [expr {$x+300}] [expr {$y+25}] -width 800 -text [translate "Recent beans"] \
#			-font_size +2 -font_family notosansuibold
		
		dui add entry $page [expr {$x+300}] [incr y 130] -tags {fav_title fav_editing} -canvas_width 800 \
			-label [translate "Favorite title"] -label_pos [list $x $y] \
			-validate all -vcmd {expr {[string length %P] <= 55}}
		bind $widgets(fav_title) <Leave> [namespace current]::validate_all

		dui add dtext $page [expr {$x+1150}] $y -tags title_validate_msg -style "error" -width 700 \
			-text [translate {Title for fixed favs cannot be left empty}] -font_size -1 -initial_state hidden
		
		dui add dtext $page $x [incr y 160] -tags {fav_what_copy_lbl fav_editing} -width 1000 \
			-text [translate "What to copy?"] -font_family notosansuibold
		dui add dtext $page [expr {$x+320}] [expr {$y+5}] -tags fav_what_copy_msg -width 650 \
			-text [translate "(applies to ALL recent favorites)"] -font_size -3
		dui add dtext $page $x_data $y -tags {fav_data_lbl fav_editing} -width 800 \
			-text [translate "Data to copy (from Next Shot)"] -font_family notosansuibold 

		dui add dtoggle $page $x [incr y 100] -anchor nw -tags {fav_copy_workflow fav_editing} \
			-variable fav_copy_workflow -command change_copy_workflow 
		dui add dtext $page [expr $x+$x_toggle_lbl_dist] $y -tags {fav_copy_workflow_lbl fav_editing} -width 400 \
			-text [translate "Workflow"] 
		dui add dtoggle $page [expr $x+$x_2nd_what_offset] $y -anchor nw \
			-tags {fav_copy_workflow_settings fav_editing} \
			-variable fav_copy_workflow_settings -command change_copy_workflow 
		dui add dtext $page [expr $x+$x_2nd_what_offset+$x_toggle_lbl_dist] $y \
			-tags {fav_copy_workflow_settings_lbl fav_editing} -width 400 \
			-text [translate "Workflow settings"] 
		dui add dtext $page $x_data $y -tags {fav_workflow_desc fav_editing} -width 800 \
			-anchor nw -justify left -font_size -2 
		
		dui add dtoggle $page $x [incr y 100] -anchor nw -tags {fav_copy_profile_title fav_editing} \
			-variable fav_copy_profile_title -command change_copy_profile_title
		dui add dtext $page [expr $x+$x_toggle_lbl_dist] $y -tags {fav_copy_profile_title_lbl fav_editing} -width 800 \
			-text [translate "Disk profile"] 
		
		dui add dtoggle $page [expr $x+$x_2nd_what_offset] $y -anchor nw -tags {fav_copy_full_profile fav_editing} \
			-variable fav_copy_full_profile -command change_copy_full_profile
		dui add dtext $page [expr $x+$x_2nd_what_offset+$x_toggle_lbl_dist] $y -tags {fav_copy_full_profile_lbl fav_editing} \
			-width 800 -text [translate "Shot profile"] 		
		dui add dtext $page $x_data $y -tags {fav_profile_desc fav_editing} -width 800 \
			-anchor nw -justify left -font_size -2 
		
		dui add dtoggle $page $x [incr y 100] -anchor nw -tags {fav_copy_beans fav_editing} -variable fav_copy_beans \
			-command change_copy_beans
		dui add dtext $page [expr $x+$x_toggle_lbl_dist] $y -tags {fav_copy_beans_lbl fav_editing} -width 800 \
			-text [translate "Beans"] 
		dui add dtoggle $page [expr $x+$x_2nd_what_offset] $y -anchor nw -tags {fav_copy_roast_date fav_editing} \
			-variable fav_copy_roast_date -command change_copy_beans
		dui add dtext $page [expr $x+$x_2nd_what_offset+$x_toggle_lbl_dist] $y -tags {fav_copy_roast_date_lbl fav_editing} -width 800 \
			-text [translate "Roast date"] 		
		dui add dtext $page $x_data $y -tags {fav_beans_desc fav_editing} -width 800 -anchor nw -justify left -font_size -2 
		
		dui add dtoggle $page $x [incr y 100] -anchor nw -tags {fav_copy_grinder_model fav_editing} \
			-variable fav_copy_grinder_model -command change_copy_grind			
		dui add dtext $page [expr $x+$x_toggle_lbl_dist] $y -tags {fav_copy_grinder_model_lbl fav_editing} -width 800 \
			-text [translate "Grinder"] 
		dui add dtoggle $page [expr $x+$x_2nd_what_offset] $y -anchor nw -tags {fav_copy_grinder_setting fav_editing} \
			-variable fav_copy_grinder_setting -command change_copy_grind
		dui add dtext $page [expr $x+$x_2nd_what_offset+$x_toggle_lbl_dist] $y -tags {fav_copy_grinder_setting_lbl fav_editing} -width 800 \
			-text [translate "Grinder setting"] 
		dui add dtext $page $x_data $y -tags {fav_grind_desc fav_editing} -width 800 -anchor nw -justify left -font_size -2
		
		dui add dtoggle $page $x [incr y 100] -anchor nw -tags {fav_copy_grinder_dose_weight fav_editing} \
			-variable fav_copy_grinder_dose_weight -command change_copy_ratio
		dui add dtext $page [expr $x+$x_toggle_lbl_dist] $y -tags {fav_copy_grinder_dose_weight_lbl fav_editing} -width 800 \
			-text [translate "Dose"] 
		
		dui add dtoggle $page [expr $x+$x_2nd_what_offset] $y -anchor nw -tags {fav_copy_drink_weight fav_editing} \
			-variable fav_copy_drink_weight -command change_copy_ratio
		dui add dtext $page [expr $x+$x_2nd_what_offset+$x_toggle_lbl_dist] $y -tags {fav_copy_drink_weight_lbl fav_editing} -width 800 \
			-text [translate "Target yield"]
		
		dui add dtext $page $x_data $y -tags {fav_ratio_desc fav_editing} -width 800 -anchor nw -justify left -font_size -2 
			 
		dui add dtoggle $page $x [incr y 100] -anchor nw -tags {fav_copy_espresso_notes fav_editing} \
			-variable fav_copy_espresso_notes -command change_copy_espresso_notes
		dui add dtext $page [expr $x+150] $y -tags {fav_copy_espresso_notes_lbl fav_editing} -width 800 \
			-text [translate "Espresso note"]  
		dui add dtext $page $x_data $y -tags {fav_espresso_notes_desc fav_editing} -width 800 \
			-anchor nw -justify left -font_size -2 
		
		dui add dtoggle $page $x [incr y 100] -anchor nw -tags {fav_copy_my_name fav_editing} -variable fav_copy_my_name \
			-command change_copy_people			
		dui add dtext $page [expr $x+150] $y -tags {fav_copy_my_name_lbl fav_editing} -width 800 \
			-text [translate "Barista"] 
		dui add dtoggle $page [expr $x+$x_2nd_what_offset] $y -anchor nw -tags {fav_copy_drinker_name fav_editing} \
			-variable fav_copy_drinker_name -command change_copy_people 
		dui add dtext $page [expr $x+$x_2nd_what_offset+150] $y -tags {fav_copy_drinker_name_lbl fav_editing} -width 800 \
			-text [translate "Drinker"] 		
		dui add variable $page $x_data $y -tags {fav_people_desc fav_editing} -width 800 -anchor nw -justify left -font_size -2
			 
		dui add dtext $page $x [incr y 100] -tags what_to_copy_validate_msg -style "error" -width 1800 \
			-text [translate {At least one element to be copied must be selected}] -font_size -1 -initial_state hidden
		
		# Bottom area
		dui add dbutton $page 600 1425 -bwidth 300 -bheight 100 -shape round -tags save_fav_edits \
			-label [translate "Save favorite"] -label_pos {0.5 0.5} -label_justify center -command save_fav_edits \
			
		dui add dbutton $page 1000 1425 -bwidth 300 -bheight 100 -shape round -tags cancel_fav_edits \
			-label [translate "Cancel edit"] -label_pos {0.5 0.5} -label_justify center -command cancel_fav_edits \
			
		#dui::page::add_items $page skin_version
	}

	proc load { page_to_hide page_to_show n_fav } {
		variable data
		variable all_recent
		
		set data(fav_number) $n_fav
		set data(page_title) "[translate {Edit DYE Favorite}] #[expr $n_fav+1]"
		# all_recent loaded from the DB on each page load, but only the first time
		# it's actually needed, on proc change_fav_type
		array set all_recent {} 
		
		# Load the current favorite data
		set data(fav_type) [current_fav_type]
		change_fav_type
		
		return 1
	}
	
	proc show { page_to_hide page_to_show } {
		variable data
		
		# Show only the fav button for the favorite being edited
		dui item hide $page_to_show dye_favs
		dui item show $page_to_show dye_fav_$data(fav_number)*
		dui item show $page_to_show dye_fav_l$data(fav_number)
		
		# Move the bracket "index triangle" to point at the fav being edited
		# BEWARE that dui::item::moveto doesn't work with polygons atm as it's restricted to 4 coordinates
		#	and polygons need more.
		set x [expr $::skin(button_x_fav)-135]
		set y [expr 123+(120*$data(fav_number))]
		[dui canvas] coords [dui item get $page_to_show edit_bracket_index] \
			[dui::page::calc_x $page_to_show [expr $x+8]] [dui::page::calc_y $page_to_show [expr $y]] \
			[dui::page::calc_x $page_to_show [expr $x+8+35]] [dui::page::calc_y $page_to_show [expr $y+20]] \
			[dui::page::calc_x $page_to_show [expr $x+8]] [dui::page::calc_y $page_to_show [expr $y+40]]
		
		# The call to change_fav_type on the loade proc doesn't disable fav_title when opening the page, 
		# as the page is not shown yet at that moment.
		dui item enable_or_disable [expr {$data(fav_type) eq "fixed"}] $page_to_show fav_title
		
		change_copy_workflow no
		change_copy_profile_title no
		change_copy_beans no
		change_copy_grind no
		change_copy_ratio no
		change_copy_espresso_notes no
		change_copy_people no
		validate_all
	}

	proc change_fav_type {} {
		variable data
		variable copy_fields
		variable fav_fields
		variable all_recent
		
		set page [namespace tail [namespace current]]
		
		foreach field_name $copy_fields {
			set data(fav_copy_$field_name) 0
		}
		foreach field_name $fav_fields {
			set data(fav_$field_name) {}
		}

		dui item config $page dye_fav_$data(fav_number)-lbl1 -text \
			[::dui::symbol::get [::plugins::DYE::favorites::fav_icon_symbol $data(fav_type)]]
		
		if {$data(fav_type) eq "n_recent"} {
			dui item config $page fav_what_copy_msg -text [translate "(applies to ALL recent favorites)"]
			dui item config $page fav_data_lbl -text [translate "Example data (recent shot)"]
			dui item disable $page fav_title -initial yes -current yes
			dui item enable $page {fav_copy_full_profile_lbl fav_copy_full_profile} -initial yes -current yes 
			
			# Load all recents up to the one we need			
			set recent_idx [expr [::plugins::DYE::favorites::recent_number $data(fav_number)]-1]
			if { $recent_idx < 0 } {
				set recent_idx 0
			}			
			if { [current_fav_type] ne "n_recent" } {
				incr recent_idx 1
			}
			if { [array size all_recent] == 0 } {
				# First time load, only updated once per page load, so need to load all 12
				array set all_recent [::plugins::DYE::favorites::get_all_recent_descs_from_db]
			}
			if { [array size all_recent] > 0 } {
				if { [llength $all_recent([lindex [array names all_recent] 0])] <= $recent_idx } {
					set recent_idx [expr [llength $all_recent([lindex [array names all_recent] 0])]-1]
				}
				
				if { [value_or_default all_recent(last_clock) 0] > 0 } {
					array set example_shot [::plugins::SDB::shots "*" 1 \
						"clock=[lindex $all_recent(last_clock) $recent_idx]" 1 {}]
				} else {
					msg -ERROR "change_fav_type: all_recent doesn't include last_clock"
				}

				foreach field_name $fav_fields {
					if { $field_name eq "drink_weight" } {
						if { [info exists example_shot(target_drink_weight)] &&
								[lindex $example_shot(target_drink_weight) 0] > 0 } {
							set data(fav_drink_weight) [lindex $example_shot(target_drink_weight) 0]
							set example_shot(drink_weight) [lindex $example_shot(target_drink_weight) 0]
						} elseif { [info exists example_shot(drink_weight)] && \
								[lindex $example_shot(drink_weight) 0] > 0 } {
							set data(fav_drink_weight) [lindex $example_shot(drink_weight) 0]
							set example_shot(drink_weight) [lindex $example_shot(drink_weight) 0]
						}
					} elseif { [info exists example_shot($field_name)] } {
						set data(fav_$field_name) [lindex $example_shot($field_name) 0]
						set example_shot($field_name) [lindex $example_shot($field_name) 0]
					}
				}
				
				set data(fav_title) [::plugins::DYE::favorites::define_recent_title \
					example_shot [expr {$recent_idx+1}]]
			}
		
			# Initialize the "What to copy" toggle booleans from the DYE settings
			# (changes here apply for equal to ALL recent-type favorites)
			foreach field_name $::plugins::DYE::settings(favs_n_recent_what_to_copy) {
				set data(fav_copy_$field_name) 1
			}
			
			
		} elseif {$data(fav_type) eq "fixed"} {
			dui item config $page fav_what_copy_msg -text [translate "(applies only to THIS favorite)"]
			dui item config $page fav_data_lbl -text [translate "Data to copy (from Next Shot)"]
			dui item enable $page fav_title -initial yes -current yes
			set data(fav_copy_full_profile) 0
			dui item disable $page {fav_copy_full_profile_lbl fav_copy_full_profile} -initial yes -current yes
			
			if { [current_fav_type] eq "fixed" } {
				set data(fav_title) [current_fav_title]
				array set fav_values [current_fav_values]
				foreach field_name [value_or_default fav_values(what_to_copy) \
						$::plugins::DYE::settings(favs_n_recent_what_to_copy)] {
					if { [info exists data(fav_copy_$field_name)] } {
						set data(fav_copy_$field_name) 1
					}
				}
			} else {
				set data(fav_title) ""
				
				# As no default what_to_copy in current fav, use the default
				# ones for n_recent favs. 
				foreach field_name $::plugins::DYE::settings(favs_n_recent_what_to_copy) {
					if { $field_name ne "full_profile" } {
						set data(fav_copy_$field_name) 1
					}
				}
			}
			
			# Copy actual data from the current settings (data for Next Shot)
#			foreach field_name [concat [metadata fields -domain shot -category description] \
#					profile_title DSx2_workflow] {}
			foreach field_name $fav_fields {
				if { [info exists ::plugins::DYE::settings(next_$field_name)] } {
					set data(fav_$field_name) $::plugins::DYE::settings(next_$field_name)
				} elseif { [info exists ::settings($field_name)] } {
					set data(fav_$field_name) $::settings($field_name)
				}
			}
			if { [::plugins::DYE::is_DSx2] } {
				set data(fav_workflow) [value_or_default ::skin(workflow) "none"]
			}
		}
		
		# Incompatible options
		if { $data(fav_copy_profile_title) } {
			set data(fav_copy_full_profile) 0
		} elseif { $data(fav_copy_full_profile) } {
			set data(fav_copy_profile_title) 0
		}
		
		change_copy_workflow 0
		change_copy_profile 0
		change_copy_beans 0
		change_copy_grind 0
		change_copy_ratio 0
		change_copy_espresso_notes 0
		change_copy_people 0
	}

	proc validate_title { } {
		variable data
		variable widgets
		set page [namespace tail [namespace current]]
		
		if { $data(fav_type) ne "fixed" } {
			dui item hide $page title_validate_msg
			return 1
		} elseif { $data(fav_title) eq {} } {
			dui item config $widgets(title_validate_msg) -text [translate {Title for fixed favs cannot be left empty}]
			dui item show $page title_validate_msg
			return 0
		} elseif { [::plugins::DYE::favorites::fixed_title_exists $data(fav_title) $data(fav_number)] } {
			dui item config $widgets(title_validate_msg) -text [translate {Title can't be duplicated, please use a different title}]
			dui item show $page title_validate_msg
			return 0
		}
		
		dui item hide $page title_validate_msg
		return 1
	}
	
	proc validate_what_to_copy { } {
		variable data
		set page [namespace tail [namespace current]]
		
		if { [llength [get_what_to_copy]] == 0 } {
			dui item show $page what_to_copy_validate_msg
			#after 2000 [list dui::item::hide $page what_to_copy_validate_msg]
			return 0
		} else {
			dui item hide $page what_to_copy_validate_msg
			return 1
		}
	}
	
	proc validate_all { } {
		set page [namespace tail [namespace current]]
		
		# Don't embed this commands into the condition or
		# the second may not execute
		set validate_title [validate_title]
		set validate_what_to_copy [validate_what_to_copy]
		if { $validate_title && $validate_what_to_copy } {
			dui item enable $page save_fav_edits*
			return 1
		} else {
			dui item disable $page save_fav_edits*
			return 0
		}
	}
	
	proc get_what_to_copy {} {
		variable data 
		variable copy_fields
		
		set what_to_copy [list]
		foreach field_name $copy_fields {
			if { $data(fav_copy_$field_name) == 1 } {
				lappend what_to_copy $field_name
			}
		}

		return $what_to_copy
	}

	proc current_fav_type {} {
		variable data
		return [::plugins::DYE::favorites::fav_type $data(fav_number)]
	}
	
	proc current_fav_title {} {
		variable data
		return [::plugins::DYE::favorites::fav_title $data(fav_number)]
	}
	
	proc current_fav_values {} {
		variable data
		return [::plugins::DYE::favorites::fav_values $data(fav_number)]
	}
	
	proc change_copy_workflow { {validate_all 1} } {
		variable data
		set page [namespace tail [namespace current]]
		if { $data(fav_workflow) eq "" } {
			set workflow [translate "none"]
		} else {
			set workflow [translate $data(fav_workflow)]
		}
		
		if { $data(fav_copy_workflow_settings)  } {
			set data(fav_copy_workflow) 1
			dui item disable $page fav_copy_workflow* 
			
			set desc "${workflow}: "
			if { $workflow eq "none" } {
				append desc [translate {Steam and hot water settings}]
			} elseif { $workflow eq "latte" } {
				append desc [translate {Steam settings}]
			} elseif { $workflow eq "espresso" } {
				append desc [translate {Steam on/off}]
			} else {
				append desc [translate {Hot water settings & steam on/off}]
			}
		} else {
			dui item enable $page fav_copy_workflow*
			
			if { $data(fav_copy_workflow)  } {
				set desc "$workflow"
			} else {
				set desc ""
			}
		}
		dui item config $page fav_workflow_desc -text [maxstring $desc 40]
		
		if {[string is true $validate_all]} {
			validate_all
		}
	}
	
	proc change_copy_profile_title { {validate_all 1} } {
		variable data
		set page [namespace tail [namespace current]]
		
		if { $data(fav_copy_profile_title) } {
			set data(fav_copy_full_profile) 0
			dui item disable $page fav_copy_full_profile* 
		} else {
			dui item enable $page fav_copy_full_profile*
		}		
		change_copy_profile $validate_all
	}

	proc change_copy_full_profile { {validate_all 1} } {
		variable data
		set page [namespace tail [namespace current]]
		
		if { $data(fav_copy_full_profile) } {
			set data(fav_copy_profile_title) 0
			dui item disable $page fav_copy_profile_title* 
		} else {
			dui item enable $page fav_copy_profile_title*
		}
		change_copy_profile $validate_all
	}
	
	proc change_copy_profile { {validate_all 1} } {
		variable data
		set page [namespace tail [namespace current]]
		
		if { $data(fav_profile_title) eq {} } {
			set profile_title "<[translate {Blank}]>"
		} else {
			set profile_title [translate $data(fav_profile_title)]"
		}
		if { $data(fav_copy_full_profile)  } {
			set desc "[translate {Recent shot version of }] $profile_title"
		} elseif { $data(fav_copy_profile_title)  } {
			set data(fav_copy_full_profile) 0
			set desc "[translate {Disk version of }] $profile_title"
		} else {
			set desc ""
		}
		dui item config $page fav_profile_desc -text [maxstring $desc 40]
		
		if {[string is true $validate_all]} {
			validate_all
		}
	}
	
	proc change_copy_beans { {validate_all 1} } {
		variable data
		set page [namespace tail [namespace current]]
		set desc ""
		
		if { $data(fav_copy_beans)  } {
			append desc "$data(fav_bean_brand) $data(fav_bean_type)" 
		} 
		if { $data(fav_copy_roast_date) } {
			append desc " $data(fav_roast_date)"
		}
		set desc [string trim $desc]
		if { ($data(fav_copy_beans) || $data(fav_copy_roast_date)) && 
				$desc eq {} } {
			set desc "<[translate {Blank}]>"
		}
		
		dui item config $page fav_beans_desc -text [maxstring $desc 40]
		
		if {[string is true $validate_all]} {
			validate_all
		}
	}
	
	proc change_copy_grind { {validate_all 1} } {
		variable data
		set page [namespace tail [namespace current]]
		set desc ""
		
		if { $data(fav_copy_grinder_model) } {
			append desc "$data(fav_grinder_model)" 
		} 
		if { $data(fav_copy_grinder_setting) && $data(fav_grinder_setting) ne {} } {
			append desc " @ $data(fav_grinder_setting)"
		}
		set desc [string trim $desc]
		if { ($data(fav_copy_grinder_model) || $data(fav_copy_grinder_setting)) && 
				$desc eq {} } {
			set desc "<[translate {Blank}]>"
		}
		
		dui item config $page fav_grind_desc -text [maxstring $desc 40]
		
		if {[string is true $validate_all]} {
			validate_all
		}		
	}
	
	proc change_copy_ratio { {validate_all 1} } {
		variable data
		set page [namespace tail [namespace current]]
		set desc ""
		
		if { $data(fav_copy_grinder_dose_weight) && $data(fav_copy_drink_weight) } {
			set desc "$data(fav_grinder_dose_weight)g : $data(fav_drink_weight)g"
		} elseif { $data(fav_copy_grinder_dose_weight) } {
			set desc "$data(fav_grinder_dose_weight)g : "
		} elseif { $data(fav_copy_drink_weight) } {
			set desc " : $data(fav_drink_weight)g"
		} else {
			set desc ""
		}
		set desc_len [string length [string trim $desc]]
		if { $desc_len > 0 && $desc_len < 6 } {
			set desc "<[translate {Blank}]>"
		}
		dui item config $page fav_ratio_desc -text [maxstring $desc 40]
		
		if {[string is true $validate_all]} {
			validate_all
		}
	}	

	proc change_copy_espresso_notes { {validate_all 1} } {
		variable data
		set page [namespace tail [namespace current]]
		set desc ""
		
		if { $data(fav_copy_espresso_notes) } {
			if { [string trim $data(fav_espresso_notes)] eq {} } {
				set desc "<[translate {Blank}]>"
			} else {
				set desc "$data(fav_espresso_notes)"
			}
		} else {
			set desc ""
		}
		dui item config $page fav_espresso_notes_desc -text [maxstring $desc 40]
		
		if {[string is true $validate_all]} {
			validate_all
		}		
	}
	
	proc change_copy_people { {validate_all 1} } {
		variable data
		set page [namespace tail [namespace current]]
		set desc ""
		
		if { $data(fav_copy_my_name) && $data(fav_copy_drinker_name) } {
			set desc "$data(fav_my_name) / $data(fav_drinker_name)"
		} elseif { $data(fav_copy_my_name) } {
			set desc "$data(fav_my_name) / "
		} elseif { $data(fav_copy_drinker_name) } {
			set desc " / $data(fav_drinker_name)"
		} else {
			set desc ""
		}
		set desc_len [string length [string trim $desc]]
		if { $desc_len > 0 && $desc_len < 3 } {
			set desc "<[translate {Blank}]>"
		}
		dui item config $page fav_people_desc -text [maxstring $desc 40]
		
		if {[string is true $validate_all]} {
			validate_all
		}
	}
	
	proc save_fav_edits {} {
		variable data
		variable fav_fields
		variable copy_fields 
		variable all_recent

		if { ![validate_all] } {
			dui say [translate "Please correct the invalid favorite data"]
			return {} 
		}
		
		set what_to_copy [get_what_to_copy]
		set fav_values [list]
		
		if { $data(fav_type) eq "n_recent" } {
			# Save changes to what to copy. These apply to all recent-type favs, so are stored in the settings.
			set ::plugins::DYE::settings(favs_n_recent_what_to_copy) $what_to_copy
		} else {
			lappend fav_values "what_to_copy" $what_to_copy

			foreach what_copy $what_to_copy {
				if { $what_copy eq "workflow_settings" } {
					foreach workflow_field \
							$::plugins::DYE::workflow_settings_vars([value_or_default ::settings(DSx2_workflow) {none}]) {
						if { [info exists ::settings($workflow_field)] } {
							lappend fav_values $workflow_field $::settings($workflow_field)
						} else {
							msg -WARNING [namespace current] "save_fav_edits: workflow field $workflow_field not found in global settings"
						}
					}
				} elseif { $what_copy eq "beans" } {
					lappend fav_values bean_brand $data(fav_bean_brand)
					lappend fav_values bean_type $data(fav_bean_type)
					lappend fav_values roast_level $data(fav_roast_level)
					lappend fav_values bean_notes $data(fav_bean_notes)
				} elseif { $what_copy eq "profile_title" } {
					lappend fav_values profile_title $data(fav_profile_title)
					lappend fav_values profile_filename $data(fav_profile_filename)
				} elseif { [info exists data(fav_$what_copy)] } {
					lappend fav_values $what_copy $data(fav_$what_copy)
				} elseif { [info exists ::settings($what_copy)] } {
					lappend fav_values $what_copy $::settings($what_copy)
				} else {
					msg -WARNING [namespace current] "save_fav_edits: field $what_copy not found"
				}
			}
		}

		::plugins::DYE::favorites::set_fav $data(fav_number) $data(fav_type) "$data(fav_title)" $fav_values 0
		# Updating recent favs already saves DYE settings, no need to call it here too
		::plugins::DYE::favorites::update_recent
		
		dui page close_dialog
	}
	
	proc cancel_fav_edits {} {
		dui page close_dialog
	}
	
}

##### DYE DSx2 HISTORY VIEWER ######################################################################

namespace eval ::plugins::DYE::pages::dsx2_dye_hv {
	variable widgets
	array set widgets {}
	
	variable data
	array set data {
		selected_side "right"
		right_panel_mode "sel_comp"
		left_clock 0
		right_clock 0
		data_panel "small"
		
		shown_indexes {}
		filter_matching {beans}
		filter_string ""
		n_shots 0
		n_matches_text ""
		selected {}
		show_diff_only 0
		
		base_time "-"
		base_peak_pressure "-"
		base_final_pressure "-"
		base_peak_flow "-"
		base_final_flow "-"
		base_peak_weight "-"
		base_final_weight "-"
		base_peak_temperature "-"
		base_final_temperature "-"
		base_volume "-"
		base_weight "-"
		
		base_extr_peak_pressure "-"
		base_full_final_flow "-"
		
		comp_time "-"
		comp_peak_pressure "-"
		comp_final_pressure "-"
		comp_peak_flow "-"
		comp_final_flow "-"
		comp_peak_weight "-"
		comp_final_weight "-"
		comp_peak_temperature "-"
		comp_final_temperature "-"
		comp_volumen "-"
		comp_weight "-"

		comp_extr_peak_pressure "-"
		comp_full_final_flow "-"
	}
	
	variable shots
	array set shots {}
	
	variable base_shot
	array set base_shot {}	
	variable base_shot_steps
	array set base_shot {}
	
	variable comp_shot
	array set comp_shot {}
	variable comp_shot_steps
	array set comp_shot_steps {}
	
	variable click_graph_timer {}
	variable click_graph_previous_xvline {}
	variable click_graph_previous_clock {}
	
	variable stored_moved_coords
	array set stored_moved_coords {}
	
	proc setup { } {
		variable data
		variable widgets	
		set page [namespace tail [namespace current]]
		
		dui add dbutton $page 40 250 -bwidth 120 -bheight 140  -style dsx2 -anchor nw \
			-tags dye_dsx2_hv_back -symbol arrow-left-long -symbol_pos {0.5 0.4} \
			-label [translate {back}] -label_width 115 -label_pos {0.5 0.8} \
			-label_anchor center -label_justify center -label_font_size 10 \
			-tap_pad {40 100 50 30} -command [namespace current]::page_done

		# TOP SMALL PANEL
		set x 850 
		set y 90
		set panel_width 900
		dui add shape outline $page $x $y -bwidth $panel_width -bheight 300 -tags {smallp_box data_smallp} \
			-width 2 -outline [dui::aspect::get dtext fill] 

		dui add shape line $page [expr {$x+40}] [expr {$y+70}] [expr {$x+$panel_width-40}] \
			[expr {$y+70}] -width [dui::platform::rescale_y 2] -outline "light grey" \
			-tags {smallp_line1 data_smallp}
		dui add shape line $page [expr {$x+40}] [expr {$y+180}] [expr {$x+$panel_width-40}] \
			[expr {$y+180}] -width [dui::platform::rescale_y 2] -outline "light grey" \
			-tags {smallp_line2 data_smallp}

		dui add dtext $page [expr {$x+50}] [expr {$y+70+(180-70)/2}] -anchor w -width 200 \
			-text "[translate {Base shot}]" -font_family notosansuibold -font_size 14 \
			-tags {smallp_base data_smallp}
		dui add dtext $page [expr {$x+50}] [expr {$y+180+(300-180)/2}] -anchor w -width 200 \
			-text "[translate {Comp shot}]" -font_family notosansuibold -font_size 14 \
			-tags {smallp_comp data_smallp} 

		set xwidth [expr {($panel_width-300)/2}]
		set xv [expr {$x+250+$xwidth/2}]
		set y_colheader [expr {$y+35}]
		dui add dtext $page $xv $y_colheader -anchor center -justify center \
			-text "[translate {Peak extr. pressure}]" -font_family notosansuibold -font_size 12 \
			-tags {smallp_pressure data_smallp}
		dui add dtext $page [expr {$xv+$xwidth}] [expr {$y+35}] -anchor center -justify center \
			-text "[translate {Final flow}]" -font_family notosansuibold -font_size 12 \
			-tags {smallp_flow data_smallp}
		
		# Data variables
		set y_base [expr {$y+70+(180-70)/2}]
		set y_comp [expr {$y+180+(300-180)/2}]
		
		dui add variable $page $xv $y_base -anchor center -justify center \
			-tags {base_extr_peak_pressure data_smallp} -font_size 16
		dui add variable $page $xv $y_comp -anchor center -justify center \
			-tags {comp_extr_peak_pressure data_smallp} -font_size 16 
				
		dui add variable $page [expr {$xv+$xwidth}] $y_base -anchor center -justify center \
			-tags {base_full_final_flow data_smallp} -font_size 16
		dui add variable $page [expr {$xv+$xwidth}] $y_comp -anchor center -justify center \
			-tags {comp_full_final_flow data_smallp} -font_size 16
		
		dui add dbutton $page $x $y -bwidth $panel_width -bheight 300 -command toggle_data_panel \
			-tags {smallp_btn data_smallp}
		
		# TOP BIG PANEL
		set x 225 
		set y 90
		set panel_width 1540
		dui add shape outline $page $x $y -bwidth $panel_width -bheight 300 -tags {bigp_box data_bigp} \
			-width 2 -outline [dui::aspect::get dtext fill] -initial_state hidden
		
		dui add dbutton $page $x $y -bwidth 100 -bheight 300 -tags {move_prev_step data_bigp} \
			-symbol caret-left -symbol_pos {0.6 0.5} -symbol_font_size 40 \
			-symbol_fill [dui::aspect::get dtext fill] -tap_pad 30 -initial_state hidden
		dui add dbutton $page [expr {$x+$panel_width-100}] $y -bwidth 100 -bheight 300 \
			-tags {move_next_step data_bigp} -symbol caret-right -symbol_pos {0.4 0.5} \
			-symbol_font_size 40 -symbol_fill [dui::aspect::get dtext fill] -tap_pad 30 \
			-initial_state hidden
		
		dui add shape line $page [expr {$x+120}] [expr {$y+70}] [expr {$x+$panel_width-120}] \
			[expr {$y+70}] -width [dui::platform::rescale_y 2] -outline "light grey" \
			-tags {bigp_line1 data_bigp} -initial_state hidden
		dui add shape line $page [expr {$x+120}] [expr {$y+180}] [expr {$x+$panel_width-120}] \
			[expr {$y+180}] -width [dui::platform::rescale_y 2] -outline "light grey" \
			-tags {bigp_line2 data_bigp} -initial_state hidden
		
		dui add dtext $page [expr {$x+130}] [expr {$y+35}] -anchor w -justify left -tags step_name \
			-text "[translate {Full shot}]" -font_size 14 -fill brown -tags {step_name data_bigp} \
			-initial_state hidden
		
		dui add dtext $page [expr {$x+130}] [expr {$y+70+(180-70)/2}] -anchor w -width 130 \
			-text "[translate {Base shot}]" -font_family notosansuibold -font_size 14 \
			-tags {bigp_base data_bigp} -initial_state hidden
		dui add dtext $page [expr {$x+130}] [expr {$y+180+(300-180)/2}] -anchor w -width 130 \
			-text "[translate {Comp shot}]" -font_family notosansuibold -font_size 14 \
			-tags {bigp_comp data_bigp} -initial_state hidden
		
		dui add dtext $page [expr {$x+130+130}] [expr {$y+70+(180-70)/4}] -anchor w -width 120 \
			-text "[translate Peak]" -font_size 12 -tags {bigp_base_peak data_bigp} \
			-initial_state hidden
		dui add dtext $page [expr {$x+130+130}] [expr {$y+70+(180-70)*3/4}] -anchor w -width 120 \
			-text "[translate Final]" -font_size 12 -tags {bigp_base_final data_bigp} \
			-initial_state hidden

		dui add dtext $page [expr {$x+130+130}] [expr {$y+180+(300-180)/4}] -anchor w -width 120 \
			-text "[translate Peak]" -font_size 12 -tags {bigp_comp_peak data_bigp} \
			-initial_state hidden
		dui add dtext $page [expr {$x+130+130}] [expr {$y+180+(300-180)*3/4}] -anchor w -width 120 \
			-text "[translate Final]" -font_size 12 -tags {bigp_comp_final data_bigp} \
			-initial_state hidden
				
		set xwidth [expr {($panel_width-240-240)/6}]
		set xv [expr {$x+370+$xwidth/2}]
		set y_colheader [expr {$y+35}]
		dui add dtext $page $xv $y_colheader -anchor center -justify center \
			-text "[translate Time]" -font_family notosansuibold -font_size 12 \
			-tags {bigp_time data_bigp} -initial_state hidden
		dui add dtext $page [expr {$xv+$xwidth}] [expr {$y+35}] -anchor center -justify center \
			-text "[translate Pressure]" -font_family notosansuibold -font_size 12 \
			-tags {bigp_pressure data_bigp} -initial_state hidden
		dui add dtext $page [expr {$xv+$xwidth*2}] [expr {$y+35}] -anchor center -justify center \
			-text "[translate Flow]" -font_family notosansuibold -font_size 12 \
			-tags {bigp_flow data_bigp} -initial_state hidden
		dui add dtext $page [expr {$xv+$xwidth*3}] [expr {$y+35}] -anchor center -justify center \
			-text "[translate Scale]" -font_family notosansuibold -font_size 12 \
			-tags {bigp_scale data_bigp} -initial_state hidden
		dui add dtext $page [expr {$xv+$xwidth*4}] [expr {$y+35}] -anchor center -justify center \
			-text "[translate {Vol./Weight}]" -font_family notosansuibold -font_size 12 \
			-tags {bigp_volw data_bigp} -initial_state hidden
		dui add dtext $page [expr {$xv+$xwidth*5}] [expr {$y+35}] -anchor center -justify center \
			-text "[translate Temp.]" -font_family notosansuibold -font_size 12 \
			-tags {bigp_temp data_bigp} -initial_state hidden

		# Data variables		
		set y_base_peak [expr {$y+70+(180-70)/4}]
		set y_base_final [expr {$y+70+(180-70)*3/4}]
		set y_comp_peak [expr {$y+180+(300-180)/4}]
		set y_comp_final [expr {$y+180+(300-180)*3/4}]
		
		dui add variable $page $xv $y_base_final -anchor center -justify center \
			-tags {base_time data_bigp} -font_size 12 -initial_state hidden
		dui add variable $page $xv $y_comp_final -anchor center -justify center \
			-tags {comp_time data_bigp} -font_size 12 -initial_state hidden
		
		dui add variable $page [expr {$xv+$xwidth}] $y_base_peak -anchor center -justify center \
			-tags {base_peak_pressure data_bigp} -font_size 12 -initial_state hidden
		dui add variable $page [expr {$xv+$xwidth}] $y_base_final -anchor center -justify center \
			-tags {base_final_pressure data_bigp} -font_size 12	-initial_state hidden
		dui add variable $page [expr {$xv+$xwidth}] $y_comp_peak -anchor center -justify center \
			-tags {comp_peak_pressure data_bigp} -font_size 12 -initial_state hidden
		dui add variable $page [expr {$xv+$xwidth}] $y_comp_final -anchor center -justify center \
			-tags {comp_final_pressure data_bigp} -font_size 12 -initial_state hidden

		dui add variable $page [expr {$xv+$xwidth*2}] $y_base_peak -anchor center -justify center \
			-tags {base_peak_flow data_bigp} -font_size 12 -initial_state hidden
		dui add variable $page [expr {$xv+$xwidth*2}] $y_base_final -anchor center -justify center \
			-tags {base_final_flow data_bigp} -font_size 12	-initial_state hidden
		dui add variable $page [expr {$xv+$xwidth*2}] $y_comp_peak -anchor center -justify center \
			-tags {comp_peak_flow data_bigp} -font_size 12 -initial_state hidden
		dui add variable $page [expr {$xv+$xwidth*2}] $y_comp_final -anchor center -justify center \
			-tags {comp_final_flow data_bigp} -font_size 12 -initial_state hidden

		dui add variable $page [expr {$xv+$xwidth*3}] $y_base_peak -anchor center -justify center \
			-tags {base_peak_weight data_bigp} -font_size 12 -initial_state hidden
		dui add variable $page [expr {$xv+$xwidth*3}] $y_base_final -anchor center -justify center \
			-tags {base_final_weight data_bigp} -font_size 12 -initial_state hidden
		dui add variable $page [expr {$xv+$xwidth*3}] $y_comp_peak -anchor center -justify center \
			-tags {comp_peak_weight data_bigp} -font_size 12 -initial_state hidden
		dui add variable $page [expr {$xv+$xwidth*3}] $y_comp_final -anchor center -justify center \
			-tags {comp_final_weight data_bigp} -font_size 12 -initial_state hidden

		dui add variable $page [expr {$xv+$xwidth*4}] $y_base_peak -anchor center -justify center \
			-tags {base_volume data_bigp} -font_size 12 -initial_state hidden
		dui add variable $page [expr {$xv+$xwidth*4}] $y_base_final -anchor center -justify center \
			-tags {base_weight data_bigp} -font_size 12 -initial_state hidden
		dui add variable $page [expr {$xv+$xwidth*4}] $y_comp_peak -anchor center -justify center \
			-tags {comp_volume data_bigp} -font_size 12 -initial_state hidden
		dui add variable $page [expr {$xv+$xwidth*4}] $y_comp_final -anchor center -justify center \
			-tags {comp_weight data_bigp} -font_size 12 -initial_state hidden

		dui add variable $page [expr {$xv+$xwidth*5}] $y_base_peak -anchor center -justify center \
			-tags {base_peak_temperature data_bigp} -font_size 12 -initial_state hidden
		dui add variable $page [expr {$xv+$xwidth*5}] $y_base_final -anchor center -justify center \
			-tags {base_final_temperature data_bigp} -font_size 12 -initial_state hidden
		dui add variable $page [expr {$xv+$xwidth*5}] $y_comp_peak -anchor center -justify center \
			-tags {comp_peak_temperature data_bigp} -font_size 12 -initial_state hidden
		dui add variable $page [expr {$xv+$xwidth*5}] $y_comp_final -anchor center -justify center \
			-tags {comp_final_temperature data_bigp} -font_size 12 -initial_state hidden

		dui add dbutton $page [expr {$x+150}] $y -bwidth [expr {$panel_width-300}] -bheight 300 \
			-command toggle_data_panel -tags {bigp_btn data_bigp}
		
		# GRAPH
		# Beware correct sorting of legend items here is critical or they may have the wrong z-order
		dui page add_items $page [list main_graph graph_key_shape \
			pressure_text pressure_key_button flow_text flow_key_button weight_text weight_key_button \
			temperature_text temperature_key_button resistance_text resistance_key_button \
			steps_text steps_key_button \
			main_graph_toggle_view_label main_graph_toggle_view_button \
			main_graph_toggle_goal_label main_graph_toggle_goal_button]
		
		dui add dtext $page [expr $::skin(graph_key_x)+976+150] [expr $::skin(graph_key_y)+30] \
			-width 550 -tags press_steps -text "steps" -anchor sw -initial_state hidden \
			-font [skin_font font $::key_font_size] -fill $::skin_text_colour
		
		bind $::home_espresso_graph [dui::platform::button_unpress] \
			[list [namespace current]::unpress_graph %W %x %y]
		bind $::home_espresso_graph <B1--Motion> [list \
			[namespace current]::pressmotion_graph %W %x %y]	

		trace add execution ::check_graph_axis leave [namespace current]::toggle_y2_axis_hook
		
		# RIGHT SIDE PANEL, select panel mode
		set x 1820 
		set y 90
		set panel_width 700
		dui add dselector $page $x $y -bwidth $panel_width -bheight 100 -tags right_panel_mode \
			-values {sel_base sel_comp compare dialin} -multiple no -label_font_size -3 \
			-labels [list [translate "Select base"] [translate "Select comp"] \
				[translate "Compare shots"] [translate "Dial-in"]] \
			-label_width [expr {$panel_width/4-10}] -command right_panel_mode

		dui add shape outline $page $x [incr y 130] -bwidth $panel_width -bheight 1330 \
			-tags right_panel -width 2 -outline [dui::aspect::get dtext fill]
		
		# RIGHT SIDE PANEL, Search left or right shot mode
		dui add dtext $page [expr {$x+$panel_width/2}] [incr y 10] -anchor n -justify center \
			-tags {search_shot_title search_shot_panel} -width 690 -style menu_dlg_title \
			-font_family notosansuibold -text [translate {Select comparison shot}]
		
		dui add dtext $page [expr {$x+$panel_width/2}] [incr y 60] -anchor n -justify center -font_size 10 \
			-tags {select_shot_label search_shot_panel} -text [translate {M A T C H   B A S E   S H O T}]

		dui add dselector $page [expr {$x+30}] [incr y 40] -bwidth [expr {$panel_width-60}] -bheight 90 \
			-tags {filter_matching search_shot_panel} -values {beans profile grinder} -multiple yes \
			-label_font_size -1 -labels [list [translate "Beans"] [translate "Profile"] [translate "Grinder"]] \
			-command filter_shots 
		
		set tw [dui add text $page [expr {$x+20}] [incr y 110] -tags {shots search_shot_panel} \
			-canvas_width [expr {$panel_width-40}] -canvas_height 1075 -canvas_anchor nw \
			-yscrollbar 0 -font_size 12 -exportselection 0 \
			-highlightthickness 0 -initial_state disabled -foreground [dui::aspect::get dtext fill]]

		# RIGHT SIDE PANEL, Compare mode
		set y 220
		dui add dtext $page 2170 [incr y 10] -anchor n -justify center -tags {compare_title compare_panel} \
			-width 690 -style menu_dlg_title -font_family notosansuibold \
			-text [translate {Shots comparison}] -initial_state hidden

		incr y 80
		dui add dtext $page 1990 [expr {$y+4}] -tags {diff_only_label compare_panel} \
			-text [translate {Show only differences}] -initial_state hidden
		dui add dtoggle $page 1850 $y -tags {show_diff_only compare_panel} \
			-tap_pad {10 10 600 10} -initial_state hidden
		
		set ctw [dui add text $page 1840 [incr y 80] -tags {compare compare_panel} -canvas_width 660 \
			-canvas_height 1135 -canvas_anchor nw -yscrollbar 0 -font_size 11 \
			-highlightthickness 0 -initial_state hidden -foreground [dui::aspect::get dtext fill] \
			-exportselection 0]

		# Define Tk Text tag styles for shot selection
		$tw tag configure datetime -foreground brown -spacing3 -20
		$tw tag configure shotsep -spacing1 [dui::platform::rescale_y 15]
		$tw tag configure details -lmargin1 [dui::platform::rescale_x 25] -lmargin2 [dui::platform::rescale_x 40] \
			-font [dui font get notosansuiregular 10] -spacing1 -20
		$tw tag configure symbol -font [dui font get $::dui::symbol::font_filename 16]
		# Selected shot
		$tw tag configure selshot -background [dui::aspect::get dbutton fill -style dsx2] \
			-foreground [dui::aspect::get dbutton_label fill -style dsx2] 
		$tw tag configure selother -background grey 
		
		# BEWARE: DON'T USE [dui::platform::button_press] as event for tag binding, or tapping doesn't work on android 
		# when use_finger_down_for_tap=0. 
		$tw tag bind shot <ButtonPress-1> [list + [namespace current]::click_shot_text %W %x %y %X %Y]
		# Temporarily disabled, until compare mode is ready
		#$tw tag bind shot <Double-Button-1> [list [namespace current]::right_panel_mode compare]
		
		# Define Tk Text tag styles for shot comparison (TEMPORAL, TODO change styles)
		$ctw tag configure section {*}[dui aspect list -type text_tag -style dyev3_section -as_options yes]
		$ctw tag configure field {*}[dui aspect list -type text_tag -style dyev3_field -as_options yes]  
		$ctw tag configure value {*}[dui aspect list -type text_tag -style dyev3_value -as_options yes]
		$ctw tag configure measure_unit {*}[dui aspect list -type text_tag -style dyev3_measure_unit -as_options yes]
		$ctw tag configure compare -elide 1 {*}[dui aspect list -type text_tag -style dyev3_compare -as_options yes]
	}
	
	proc load { page_to_hide page_to_show {base_clock 0} {comp_clock 0} args } {
		variable data 
		variable widgets
		variable base_shot
		variable comp_shot
		variable comp_shot_steps
		variable shots
		variable stored_moved_coords
		variable ::plugins::DYE::settings
		 
		# Modify home UI elements		
		::plugins::DYE::ui::store_items_coords $page_to_show stored_moved_coords \
			steps_text steps_key_button main_graph_toggle_view_label main_graph_toggle_view_button \
			main_graph_toggle_goal_label main_graph_toggle_goal_button launch_dye_next*
		
		$::home_espresso_graph configure -width [dui::platform::rescale_x 1750]
		dui item moveby $page_to_show launch_dye_next* -200
		dui item moveby $page_to_show {steps_text steps_key_button* main_graph_toggle_view_label \
			main_graph_toggle_view_button* main_graph_toggle_goal_label main_graph_toggle_goal_button*} -60 
		
		# Initialize data
		set data(selected) {}

		# If not specific shots are requested and the source shot is already the currently
		# loaded base shot, open the page as it was left on last page opening.
		if { $base_clock == 0 && $comp_clock == 0 && $data(left_clock) > 0 && \
					$data(left_clock) == $settings(next_src_clock) } {
			# Ensure a description is selected if on base or comp selection mode
			right_panel_mode $data(right_panel_mode)
			::plugins::DYE::pages::dsx2_dye_home::load_home_graph_comp_from {} comp_shot
		} elseif { $base_clock == 0 && $comp_clock == 0 && $settings(next_src_clock) == 0 } {
			# Initialization for first time installs
			set data(n_shots) 0
			set data(filter_string) ""
			
			load_base_shot 0
			load_comp_shot 0
		} else {
			set data(n_shots) 0
			set data(filter_string) ""
				
			if { $base_clock <= 0 } {
				set base_clock $settings(next_src_clock)
			}
			# We need to load the base shot before filter_shots, otherwise
			# matching data is not loaded yet, then do the selection afterwards
			load_base_shot $base_clock
			
			# This also fills the shot history
			filter_shots
	
			shot_select $base_clock 0 left 1
		
			if { $comp_clock > 0 } {
				shot_select $comp_clock 1 right 1
			} else {
				# By default, compare if possible with the previous matching shot 
				set next_idx [expr {[lsearch -exact $shots(clock) $base_clock]+1}]
				if { $next_idx > 0 && $next_idx < [llength $shots(clock)] } {
					shot_select [lindex $shots(clock) $next_idx] 1 right 1
				} else {
					set data(right_clock) 0
					array unset comp_shot
					array unset comp_shot_steps
					set settings(next_shot_header) {}
					set settings(next_shot_desc) "\[ [translate {Select a shot to compare with}] \]"
				}
			}
	
			right_panel_mode sel_comp
		}

		# Ensure (if it's shown) that the base clock is always visible
		if { $base_clock > 0 } {
			catch {
				$widgets(shots) see shot_${base_clock}.first
			}
		}
		
		return 1
	}
	
	proc show { page_to_hide page_to_show } {
		$::home_espresso_graph configure -width [dui::platform::rescale_x 1750]
		dui item show $page_to_show {launch_dye_last* launch_dye_next*}
		if { $::skin(show_heading) == 1 } {
			dui item hide $page_to_show {headerbar_heading heading}
		}
		
		# Temporal adjustments
		dui item disable $page_to_show {right_panel_mode_3* right_panel_mode_4*}
	}
	
	proc hide { page_to_hide page_to_show } {
		variable data
		variable stored_moved_coords
		
		select_base 0
		select_comp 0
		
		::plugins::DYE::ui::restore_items_coords $page_to_show stored_moved_coords 
		$::home_espresso_graph configure -width [dui::platform::rescale_x 1950]
		
		# Hiding the compare series is not enough, as they're still there and if afterwards
		# the mini-charts are open from the home page they may appear. So we rather empty the 
		# compare vectors
		foreach vec {elapsed pressure flow flow_weight flow_2x flow_weight_2x state_change \
				temperature_basket temperature_basket10th resistance } {
			compare_espresso_$vec length 0
		}
				
#		foreach curve {temperature zoom_temperature pressure flow flow_2x weight weight_2x resistance steps} {
#			$::home_espresso_graph element configure compare_${curve} -hide 1
#		}
		
		# Even if the source shot has not changed, as soon as it has been compared with another
		# shot the X axis has been modified, and returning to the original is not trivial, so we
		# just reload the source shot always.
		::plugins::DYE::pages::dsx2_dye_home::load_home_graph_from {} ::plugins::DYE::shots::src_shot
		::plugins::DYE::shots::define_next_desc
		
		if { $::skin(show_heading) == 1 } {
			dui item show $page_to_hide {headerbar_heading heading}
		}
	}
	
	proc toggle_data_panel {} {
		variable data
		set page [namespace tail [namespace current]]
		
		if { $data(data_panel) eq "small" } {
			dui item hide $page data_smallp
			dui item show $page data_bigp
			dui item disable $page {move_prev_step* move_next_step*}
			set data(data_panel) "big"
		} else {
			dui item hide $page data_bigp
			dui item show $page data_smallp
			set data(data_panel) "small"
		}
	}
	
	proc press_graph { widget x y } {
		variable data
		variable base_shot
		variable comp_shot
		variable click_graph_previous_xvline
		variable click_graph_previous_clock
		variable click_graph_timer
		variable orig_x
		
		::plugins::DYE::pages::dsx2_dye_home::src_elapsed variable xdata
		::plugins::DYE::pages::dsx2_dye_home::src_pressure variable pressure
		::plugins::DYE::pages::dsx2_dye_home::src_flow variable flow
		::plugins::DYE::pages::dsx2_dye_home::src_weight variable weight
		::plugins::DYE::pages::dsx2_dye_home::src_weight_chartable variable weight_chartable
		::plugins::DYE::pages::dsx2_dye_home::src_temperature variable temp
		set src_n [::plugins::DYE::pages::dsx2_dye_home::src_elapsed length]

		set orig_x $x
		set x [$widget axis invtransform x $x]
		lassign [$widget axis limits x] x_min x_max
		if { $x <= $x_min } {
			set x [expr {$x_min+0.001}]
		} elseif { $x > $x_max } {
			set x $x_max
		}
		
		set idx [lsearch -sorted -increasing -bisect -real $base_shot(graph_espresso_elapsed) $x]
		if { $idx < 0 } {
			set idx 0
		}
		set x_vline $xdata($idx)
		if { $data(right_clock) > 0 } {
			set comp_idx [lsearch -sorted -increasing -bisect -real \
					$comp_shot(graph_espresso_elapsed) $x]
			if { $comp_idx < 0 } {
				set comp_idx 0
			}
			
			if { $comp_idx > $idx } {
				compare_espresso_elapsed variable comp_xdata
				set x_vline $comp_xdata($comp_idx)
			}
		}
		
		# Don't do unneeded calculations & drawings, specially in slower tablets
		if { $click_graph_previous_xvline == $x_vline } {
			return
		} elseif { $click_graph_previous_clock ne {} && \
				[expr {[clock milliseconds]-$click_graph_previous_clock}] < 200 } {
			after cancel click_graph_timer
			set click_graph_timer [after 200 [namespace current]::press_graph $widget $orig_x $y]
			return
		}

		$widget marker delete vline vline_time
		$widget marker create line -coords { $x_vline -Inf $x_vline Inf } -name vline -dashes dash \
			-linewidth 2 -outline $::skin_red
		
		if { $idx <= $src_n } {
			set time_label [format {%.1f} $x]
			set step_idx [lsearch -sorted -increasing -bisect -real $base_shot(steps_indexes) $idx]
			if { $step_idx > -1 } {
				set step_label [lindex $base_shot(steps_names) $step_idx]
			} else {
				set step_label ""
			}
			set pressure_label "[round_to_one_digits $pressure($idx)]"
			set flow_label "[round_to_one_digits $flow($idx)]"
			set weight_label "[round_to_one_digits $weight($idx)]"
			if {$::settings(enable_fahrenheit) == 1} {
				set temp_label [round_to_one_digits [celsius_to_fahrenheit $temp($idx)]]
			} else {
				set temp_label [round_to_one_digits $temp($idx)]
			}
		} else {
			set time_label ""
			set step_label ""
			set pressure_label "-"
			set flow_label "-"
			set weight_label "-"
			set temp_label "-"
		}
		
		if { $data(right_clock) > 0 } {
			set step_idx [lsearch -sorted -increasing -bisect -real \
					$comp_shot(steps_indexes) $comp_idx]
			if { $step_idx > -1 } {
				set comp_step_label [lindex $comp_shot(steps_names) $step_idx]
				if { $comp_step_label ne $step_label } {
					set step_label "[translate Base]:   $step_label\n[translate Comp]: $comp_step_label"
				}
			} else {
				set comp_step_label ""
			}
				
			compare_espresso_pressure variable comp_pressure
			compare_espresso_flow variable comp_flow
			compare_espresso_flow_weight variable comp_weight
			compare_espresso_weight_chartable variable comp_weight_chartable
			compare_espresso_temperature_basket variable comp_temp
			set comp_n [compare_espresso_pressure length]
			
			if { $comp_idx < $comp_n } {
				append pressure_label " | [round_to_one_digits $comp_pressure($comp_idx)]"
				append flow_label " | [round_to_one_digits $comp_flow($comp_idx)]"
				append weight_label " | [round_to_one_digits $comp_weight($comp_idx)]"
				if {$::settings(enable_fahrenheit) == 1} {
					append temp_label " | [round_to_one_digits [celsius_to_fahrenheit $comp_temp($comp_idx)]]"
				} else {
					append temp_label " | [round_to_one_digits $comp_temp($comp_idx)]"
				}
			} else {
				append pressure_label " | - "
				append flow_label " | - "
				append weight_label " | - "
				append temp_label " | - "
			}
		} 

		append time_label [translate "s"]
		append pressure_label [translate "bar"]
		append flow_label [translate "ml/s"]
		append weight_label [translate "g/s"]
		if {$::settings(enable_fahrenheit) == 1} {
			append temp_label "\u00B0F"
		} else {
			append temp_label "\u00B0C"
		}
		
		$widget marker create text -name vline_time -text $time_label -coords [list $x 0] \
			-anchor s -fill $::skin_red -foreground white
		dui item config dsx2_dye_hv pressure_text -text $pressure_label
		dui item config dsx2_dye_hv flow_text -text $flow_label	
		dui item config dsx2_dye_hv weight_text -text $weight_label
		dui item config dsx2_dye_hv temperature_text -text $temp_label
		
		dui item hide dsx2_dye_hv {resistance_icon resistance_text resistance_key_button \
				steps_icon steps_text steps_key_button \
				main_graph_toggle_view_label main_graph_toggle_view_button \
				main_graph_toggle_goal_label main_graph_toggle_goal_button}
		dui item config dsx2_dye_hv press_steps -text $step_label
		dui item show dsx2_dye_hv press_steps

		set click_graph_previous_xvline $x_vline
		set click_graph_previous_clock [clock milliseconds]	
	}

	proc pressmotion_graph { widget x y } {
		if { [dui::page::current] ne [namespace tail [namespace current]] } {
			return
		}
		
		variable click_graph_timer
		after cancel $click_graph_timer
		set click_graph_timer {}
		
		press_graph $widget $x $y
	}
	
	proc unpress_graph { widget x y } {
		if { [dui::page::current] ne [namespace tail [namespace current]] } {
			return
		}

		variable click_graph_timer
		variable click_graph_previous_xvline
		variable click_graph_previous_clock
		
		after cancel $click_graph_timer
		set click_graph_timer {}
		set click_graph_previous_xvline {}
		set click_graph_previous_clock {}
		
		$widget marker delete vline vline_time
		dui item config dsx2_dye_hv pressure_text -text [translate pressure]
		dui item config dsx2_dye_hv flow_text -text "[translate {flow rate}]"		
		dui item config dsx2_dye_hv weight_text -text "[translate {scale rate}]"
		dui item config dsx2_dye_hv temperature_text -text [translate temperature]
		dui item show dsx2_dye_hv {resistance_icon resistance_text resistance_key_button \
			steps_icon steps_text steps_key_button \
			main_graph_toggle_view_label main_graph_toggle_view_button \
			main_graph_toggle_goal_label main_graph_toggle_goal_button}
		dui item hide dsx2_dye_hv press_steps
	}
	
	# The proc on DSx2 doesn't show/hide the compare shots in the same way as DYE, so we
	# need to do it here
	proc toggle_y2_axis_hook { args } {
		set page [namespace tail [namespace current]]
		
		if { [dui page current] eq $page } {
			if {$::skin(show_y2_axis) == 1} {
				$::home_espresso_graph element configure compare_flow -hide 1
				$::home_espresso_graph element configure compare_weight -hide 1	
				$::home_espresso_graph element configure compare_flow_2x -hide 0
				$::home_espresso_graph element configure compare_weight_2x -hide 0	
			} else {
				$::home_espresso_graph element configure compare_flow -hide 0
				$::home_espresso_graph element configure compare_weight -hide 0	
				$::home_espresso_graph element configure compare_flow_2x -hide 1
				$::home_espresso_graph element configure compare_weight_2x -hide 1
			}			
		}
	}
	
	proc right_panel_mode { {mode {}} {load_shot 0} }  {
		variable data
		variable widgets

		set page [namespace tail [namespace current]]
		set tw $widgets(shots)
		
		if { $mode eq {} } {
			set mode $data(right_panel_mode)
		} else {
			if { $mode ni {sel_base sel_comp charts compare} } {
				msg -WARNING [namespace current] "right_panel_mode: mode '$mode' not recognized"
				set mode "sel_comp"
			}
			set data(right_panel_mode) $mode
		}
		
		if { $mode eq "sel_base" } {
			$tw tag delete selother
			dui item hide $page compare_panel -initial 1
			dui item show $page search_shot_panel -initial 1
			select_base
			
			dui item config $page search_shot_title -text [translate {Select base shot}]
			dui item config $page describe_shot-lbl -text [translate {Describe base shot}]
			dui item config $page copy_to_next-lbl -text [translate {Copy base shot to Next}]
			
			shot_select $data(left_clock) 0 left 1
			if { $data(right_clock) > 0 } {
				catch {
					$tw tag add selother shot_$data(right_clock).first shot_$data(right_clock).last
					$tw tag configure selother -background "light grey"
				}
			}
		} elseif { $mode eq "sel_comp" } {
			$tw tag delete selother	
			dui item hide $page compare_panel -initial 1
			dui item show $page search_shot_panel -initial 1
			select_comp
			
			dui item config $page search_shot_title -text [translate {Select comparison shot}]
			dui item config $page describe_shot-lbl -text [translate {Describe comp. shot}]
			dui item config $page copy_to_next-lbl -text [translate {Copy comp. shot to Next}]
			
			shot_select $data(right_clock) 0 right 1
			if { $data(left_clock) > 0 } {
				catch {
					$tw tag add selother shot_$data(left_clock).first shot_$data(left_clock).last
					$tw tag configure selother -background "light grey"
				}
			}	
		} elseif { $mode eq "charts" } {
			dui item hide $page compare_panel -initial 1
			dui item show $page search_shot_panel -initial 1
			select_base 0
			select_comp 0
		} elseif { $mode eq "compare" } {
			dui item hide $page search_shot_panel -initial 1
			dui item show $page compare_panel -initial 1
			select_base 0
			select_comp 0
			
			fill_comparison
		} 
		
		return $mode
	}
	
	proc click_base_description {} {
		variable data
		if { $data(right_panel_mode) eq "sel_base" } {
			# Temporarily disabled, until compare mode is ready
			#right_panel_mode compare
		} else {
			right_panel_mode sel_base
		}
	}

	proc click_comp_description {} {
		variable data
		if { $data(right_panel_mode) eq "sel_comp" } {
			# Temporarily disabled, until compare mode is ready
			#right_panel_mode compare
		} else {
			right_panel_mode sel_comp
		}
	}
	
	proc select_base { {select 1} } {
		variable data
		set page [namespace tail [namespace current]]
		
		if { [string is true $select] } {
			set data(selected_side) "left"
			dui item config $page launch_dye_last-btn -fill [dui::aspect::get dbutton fill -style dsx2]
			dui item config $page launch_dye_last-lbl -fill [dui::aspect::get dbutton_label fill -style dsx2]
			dui item config $page launch_dye_last-lbl1 -fill [dui::aspect::get dbutton_label fill -style dsx2]
			
			dui item config $page launch_dye_next-btn -fill [dui::aspect::get page bg_color]
			dui item config $page launch_dye_next-lbl -fill [dui::aspect::get dtext fill]
			dui item config $page launch_dye_next-lbl1 -fill [dui::aspect::get dtext fill]
		} else {
			if { $data(selected_side) eq "left" } {
				set data(selected_side) ""
			}
			dui item config $page launch_dye_last-btn -fill [dui::aspect::get page bg_color]
			dui item config $page launch_dye_last-lbl -fill [dui::aspect::get dtext fill]
			dui item config $page launch_dye_last-lbl1 -fill [dui::aspect::get dtext fill]
		}
		
	}

	proc select_comp { {select 1} } {
		variable data
		set page [namespace tail [namespace current]]
		
		if { [string is true $select] } {
			set data(selected_side) "right"
			dui item config $page launch_dye_next-btn -fill [dui::aspect::get dbutton fill -style dsx2]
			dui item config $page launch_dye_next-lbl -fill [dui::aspect::get dbutton_label fill -style dsx2]
			dui item config $page launch_dye_next-lbl1 -fill [dui::aspect::get dbutton_label fill -style dsx2]
			
			dui item config $page launch_dye_last-btn -fill [dui::aspect::get page bg_color]
			dui item config $page launch_dye_last-lbl -fill [dui::aspect::get dtext fill]
			dui item config $page launch_dye_last-lbl1 -fill [dui::aspect::get dtext fill]
		} else {
			if { $data(selected_side) eq "right" } {
				set data(selected_side) ""
			}
			dui item config $page launch_dye_next-btn -fill [dui::aspect::get page bg_color]
			dui item config $page launch_dye_next-lbl -fill [dui::aspect::get dtext fill]
			dui item config $page launch_dye_next-lbl1 -fill [dui::aspect::get dtext fill]
		}
	}

	proc load_base_shot { clock } {
		variable data
		variable base_shot
		variable ::plugins::DYE::settings
		
		if { $clock == 0 || $clock eq {} } {
			# Initialize filtering variables to avoid runtime errors when filtering on new app
			# installs with zero shots in the history
			set data(left_clock) 0
			array unset base_shot
			set base_shot(clock) 0
			set base_shot(bean_brand) {}
			set base_shot(bean_type) {}
			set base_shot(grinder_model) {}
			set base_shot(grinder_setting) {}
			set base_shot(profile_title) {}
		} elseif { $data(left_clock) != $clock || [array size base_shot] == 0 } {
			if { $clock == $settings(next_src_clock) } {
				array set base_shot [array get ::plugins::DYE::shots::src_shot]
				#msg "DSX2_DYE_HV LOAD_BASE_SHOT FROM SRC_SHOT, clock=$clock, dt=$base_shot(date_time)"
			} else {
				array set base_shot [::plugins::SDB::load_shot $clock 1 1 1 1]
				#msg "DSX2_DYE_HV LOAD_BASE_SHOT FROM DISK, clock=$clock, dt=$base_shot(date_time)"	
			}
			::plugins::DYE::pages::dsx2_dye_home::load_home_graph_from {} base_shot 0
			
			array set steps [::plugins::DYE::shots::shot_steps base_shot]
			set base_shot(steps_indexes) $steps(indexes)
			set base_shot(steps_elapsed) $steps(elapsed)
			set base_shot(steps_names) $steps(names)
			
			set data(left_clock) $clock
		}
		
		calc_shot_stats left -1
	}

	proc load_comp_shot { clock } {
		variable data
		variable comp_shot
		variable ::plugins::DYE::settings
		
		if { $clock == 0 || $clock eq {} } {
			# Initialize filtering variables to avoid runtime errors when filtering on new app
			# installs with zero shots in the history
			set data(right_clock) 0
			array unset comp_shot
			set comp_shot(clock) 0
			set comp_shot(bean_brand) {}
			set comp_shot(bean_type) {}
			set comp_shot(grinder_model) {}
			set comp_shot(grinder_setting) {}
			set comp_shot(profile_title) {}
		} elseif { $data(right_clock) != $clock || [array size comp_shot] == 0 } {
			if { $clock == $settings(next_src_clock) } {
				array set comp_shot [array get ::plugins::DYE::shots::src_shot]
				#msg "DSX2_DYE_HV LOAD_COMP_SHOT FROM SRC_SHOT, clock=$clock, dt=$comp_shot(date_time)"
			} else {
				array set comp_shot [::plugins::SDB::load_shot $clock 1 1 1 1]
				#msg "DSX2_DYE_HV LOAD_COMP_SHOT FROM DISK, clock=$clock, dt=$comp_shot(date_time)"
			}			
			::plugins::DYE::pages::dsx2_dye_home::load_home_graph_comp_from {} comp_shot
			
			array set steps [::plugins::DYE::shots::shot_steps comp_shot]
			set comp_shot(steps_indexes) $steps(indexes)
			set comp_shot(steps_elapsed) $steps(elapsed)
			set comp_shot(steps_names) $steps(names)
			
			set data(right_clock) $clock
		}
		
		calc_shot_stats right -1
	}
	
	proc filter_shots {} {
		variable data
		variable base_shot
		variable shots
		array set shots {}
				
		# These would be better initialized somewhere... but at least prevent runtime errors
		# on first time installs without any shot to be selected
#		ifexists base_shot(bean_brand) {}
#		ifexists base_shot(bean_type) {}
#		ifexists base_shot(profile_title) {}
#		ifexists base_shot(grinder_model) {}
		
		# BUILD THE QUERY
		set filter ""
		if { $data(filter_matching) ne {} } {
			if { "beans" in $data(filter_matching) && ($base_shot(bean_brand) ne "" || $base_shot(bean_type) ne "") } {
				if { $base_shot(bean_brand) ne "" } { 
					append filter "bean_brand=[::plugins::SDB::string2sql $base_shot(bean_brand)] AND "
				}
				if { $base_shot(bean_type) ne "" } {
					append filter "bean_type=[::plugins::SDB::string2sql $base_shot(bean_type)] AND "
				}
			}
			if { "profile" in $data(filter_matching) && $base_shot(profile_title) ne "" } {
				append filter "profile_title=[::plugins::SDB::string2sql $base_shot(profile_title)] AND "
			}
			if { "grinder" in $data(filter_matching) && $base_shot(grinder_model) ne "" } {
				append filter "grinder_model=[::plugins::SDB::string2sql $base_shot(grinder_model)] AND "
			}
		}
		
		# Case-insensitive search doesn't work on SQLite on Androwish "Eppur si Muove" (2019). Using COLLATE NOCASE does
		# nothing, and doing LOWER(shot_desc) or UPPER(shot_desc) triggers a runtime error. So we apply the string
		# filtering in Tcl instead.
#		if { $data(filter_string) ne "" } {
#			set filter "shot_desc LIKE '%[regsub -all {[[:space:]]} $data(filter_string) %]%' AND "
#		}

		if { $filter ne "" } {
			set filter [string range $filter 0 end-5]
		}
		
		# Search shots
		set data(n_shots) [::plugins::SDB::shots count 1 $filter 1]
		if { $data(n_shots) == 0 } {
			set data(n_matches_text) [translate "No shots found"]
		} else {
			array set shots [::plugins::SDB::shots {clock filename shot_desc profile_title grinder_dose_weight drink_weight 
				extraction_time bean_desc espresso_enjoyment grinder_model grinder_setting} 1 $filter 500 "clock DESC"]
		}
		
		apply_string_filter
		# Ensure selected shot is highlighted
		right_panel_mode $data(right_panel_mode)
	}
	
	proc apply_string_filter {} {
		variable data
		variable shots
		
		set data(show_indexes) {}
		
		if { $data(n_shots) == 0 || [array size shots] == 0 } {
			# First install, no shots available yet
			set data(n_matches_text) [translate "No shots found"]
			fill_shots
			return {}
		} 
		
		if { [string length $data(filter_string)] > 0 } {
			set filter "*[regsub -all {[[:space:]]} $data(filter_string) *]*"
			set data(shown_indexes) [lsearch -all -nocase $shots(shot_desc) $filter]
			
			set n [llength $data(shown_indexes)] 
			if { $n == 0 } {
				set data(n_matches_text) [translate "No shots found"]
			} else {
				set data(n_matches_text) "$n [translate {shots found}]"
			}
		} else {
			set data(shown_indexes) [lsequence 0 [expr {[llength $shots(shot_desc)]-1}]]

			if { $data(n_shots) == 0 } {
				set data(n_matches_text) [translate "No shots found"]
			} else {
				set data(n_matches_text) "$data(n_shots) [translate {shots found}]"
				if { $data(n_shots) > 500 } {
					append data(n_matches_text) ", [translate {showing first 500}]"
				}
			}
		}
		
		fill_shots
	}
	

	# Write the current filtered shot list into the Tk Text widget
	proc fill_shots {} {
		variable widgets
		variable data
		variable shots
		
		set star [dui symbol get star]
		set half_star [dui symbol get star-half]
		
		set tw $widgets(shots)
		$tw configure -state normal
		$tw delete 1.0 end

		if { $data(n_shots) == 0 || [llength $data(shown_indexes)] == 0 } {
			$tw insert insert [translate "No shots found"]
			$tw configure -state disabled
			return
		}
		
		for { set i 0 } { $i < [llength $data(shown_indexes)] } { incr i } {
			set idx [lindex $data(shown_indexes) $i]
			
			set shot_clock [lindex $shots(clock) $idx]
			if { $shot_clock eq "" } {
				msg -WARNING [namespace current] fill_shots: "empty clock"
				continue
			}
			
			set tags [list shot shot_$shot_clock]
			set dtags [list shot shot_$shot_clock details]
			if { $i == 0 } {
				$tw insert insert "[::plugins::DYE::format_date $shot_clock]" [concat $tags datetime]
			} else {
				$tw insert insert "[::plugins::DYE::format_date $shot_clock]" [concat $tags datetime shotsep]
			}
			
			$tw mark set stype_$shot_clock insert
			$tw mark gravity stype_$shot_clock left
			
			if { $shot_clock eq $data(left_clock) } {
				$tw insert insert " \[[translate BASE]\]" [concat $tags sel_base]
			} elseif { $shot_clock eq $data(right_clock) } {
				$tw insert insert " \[[translate COMP]\]" [concat $tags sel_comp]
			}
			
			set enjoy [lindex $shots(espresso_enjoyment) $idx]
			if { $enjoy > 0 } {
				set stars "\t"
				for { set j 0 } { $j < int((($enjoy-1)/10 + 1)/2) } { incr j } {
					append stars $star
				}
				if { int((($enjoy-1)/10 + 1))/2.0 > $j } {
					append stars $half_star
				}
				$tw insert insert "\t $stars" [concat $tags symbol]
			}			
			$tw insert insert "\n" $tags
			
			$tw insert insert "[lindex $shots(profile_title) $idx]" [concat $dtags profile_title] ", " $tags
			set dose [lindex $shots(grinder_dose_weight) $idx]
			set yield [lindex $shots(drink_weight) $idx]
			if { $dose > 0 || $yield > 0 } {
				if { $dose == 0 || $dose eq {} } {
					set dose "?"
				}
				$tw insert insert "[round_to_one_digits $dose]g:[round_to_one_digits $yield]g" [concat $dtags ratio]
				if { $dose ne "?" && $yield > 0 } {
					$tw insert insert " (1:[round_to_one_digits [expr {double($yield/$dose)}]])" [concat $dtags ratio]
				}
			}
			$tw insert insert " in [expr {round([lindex $shots(extraction_time) $idx])}] sec" [concat $dtags ratio] "\n" $dtags
			
			if { [lindex $shots(bean_desc) $idx] ne {} } {
				$tw insert insert "[lindex $shots(bean_desc) $idx]" [concat $dtags details beans]
			}
			
			if { [lindex $shots(grinder_model) $idx] ne {} || [lindex $shots(grinder_setting) $idx] ne {} } {
				if { [lindex $shots(grinder_model) $idx] ne {} } {
					$tw insert insert ", [lindex $shots(grinder_model) $idx]" [concat $dtags grinder]
				}
				if { [lindex $shots(grinder_setting) $idx] ne {} } {
					$tw insert insert " @ [lindex $shots(grinder_setting) $idx]" [concat $dtags gsetting]
				}
			}
			$tw insert insert "\n" $dtags
			
		}

		$tw configure -state disabled
	}
		
	# Returns the index of the selected shot on the namespace 'shots' array, taking into account the active
	# filter. Returns an empty string if either there's not a selected profile or there's no match.
	proc selected_shot_data_index {} {
		variable data
		variable shots
		
		set idx ""
		if { $data(selected) ne "" } {
			set idx [lsearch -exact $shots(clock) $data(selected)]
		}
		if { [string is integer $idx] && $idx < 0 } {
			set idx ""
		}
		return $idx
	}
	
	proc click_shot_text { widget x y X Y } {
		variable data
	
		set clicked_tags [$widget tag names @$x,$y]
		
		if { [llength $clicked_tags] > 1 } {
			set shot_idx [lsearch $clicked_tags "shot_*"]
			if { $shot_idx > -1 } {
				set shot_tag [lindex $clicked_tags $shot_idx]
				shot_select [string range $shot_tag 5 end]
			}
		}
	}	
	
	proc shot_select { clock {load_shot 1} {side {}} {force 0} } {
		variable data
		variable widgets
		variable shots
		variable base_shot
		variable comp_shot
		variable ::plugins::DYE::settings

		set widget $widgets(shots)
		
		if { $clock eq {} || $clock <= 0} {
			$widget tag delete selshot
			set data(selected) {}
			return
		} elseif { $data(selected) eq $clock && ![string is true $force] } {
			return
		}

		# If selecting the other shot, do nothing
		if { $data(selected_side) eq "left" && $data(right_clock) == $clock } {
			return
		} elseif { $data(selected_side) eq "right" && $data(left_clock) == $clock } {
			return
		}
		
		if { $side eq {} } {
			set data(selected) $clock
		}

		$widget tag delete selshot
		# if a tag like shot_$clock can't be found in the widget, this raises an error, so embed in try
		try {
			$widget tag add selshot shot_${clock}.first shot_${clock}.last
		} on error err {
			msg -NOTICE [namespace current] "shot_select: tag 'shot_$clock' not found on text widget, $err"
			return
		}
			
		$widget tag configure selshot -background [dui::aspect::get dbutton fill -style dsx2] \
			-foreground [dui::aspect::get dbutton_label fill -style dsx2] 
		$widget see shot_${clock}.last
		$widget see shot_${clock}.first
		
		if { $side eq {} } {
			set side $data(selected_side) 
		}
		if { $side eq "left" } {
			$widget configure -state normal
			catch {
				$widget delete sel_base.first sel_base.last
				$widget tag delete sel_base
			}
			$widget insert stype_$clock " \[[translate BASE]\]" [list shot shot_$clock selshot sel_base]
			$widget configure -state disabled
			if { [string is true $load_shot] } { 
				load_base_shot $clock
			}
		} elseif { $side eq "right" } {
			$widget configure -state normal
			catch {
				$widget delete sel_comp.first sel_comp.last
				$widget tag delete sel_comp
			}			
			$widget insert stype_$clock " \[[translate COMP]\]" [list shot shot_$clock selshot sel_comp]
			$widget configure -state disabled
			
			if { [string is true $load_shot] } {
				load_comp_shot $clock
			}
		}
	}
	
	proc _stats_strings { side series_name unit {vector_name {}} } {
		variable data
		
		if { $vector_name eq "" } {
			set vector_name $series_name
		}
		if { $side eq "left" } {
			set vecname ::plugins::DYE::pages::dsx2_dye_home::src_$vector_name
			set prefix "base"
		} elseif { $side eq "right" } {
			if { $series_name eq "temperature" } {
				set vecname compare_espresso_temperature_basket
			} else {
				set vecname compare_espresso_$vector_name
			}
			set prefix "comp"
		} else {
			return
		}
		
		set unit [translate $unit]
		if { $series_name eq "temperature" } {
			set data(${prefix}_peak_temperature) \
				"[return_temperature_measurement [expr {[vector expr max($vecname)]}]]"
			set data(${prefix}_final_temperature) \
				"[return_temperature_measurement [expr {[$vecname range end end]}]]"
		} else {
			set data(${prefix}_peak_$series_name) "[format {%.1f} [vector expr max($vecname)]] $unit"
			set data(${prefix}_final_$series_name) "[format {%.1f} [$vecname range end end]] $unit"
		}
	}
	
	# Use step -1 for the whole shot
	proc calc_shot_stats { side {step -1} } {
		variable data
		variable base_shot
		variable comp_shot
		vector create extr_pressure
		set data(step_name) [translate {Full shot}]
		
		if { $side eq "left" } {
			if { $data(left_clock) <= 0 } {
				set data(base_time) "-"
				set data(base_peak_pressure) "-"
				set data(base_final_pressure) "-"
				set data(base_peak_flow) "-"
				set data(base_final_flow) "-"
				set data(base_peak_weight) "-"
				set data(base_final_weight) "-"
				set data(base_peak_temperature) "-"
				set data(base_final_temperature) "-"

				set data(base_extr_peak_pressure) "-"
				set data(base_full_final_flow) "-"
			} else {
				set data(base_time) "[format {%.0f} $base_shot(extraction_time)] [translate s]"
				_stats_strings left pressure bar
				_stats_strings left flow "ml/s"
				_stats_strings left weight "g/s"
				_stats_strings left temperature ""
				
				if { $step < 0 } {
					# Full shot
					if { [llength $base_shot(steps_indexes)] > 1 } {
						set extr_start_idx 2
					} else {
						set extr_start_idx 1
					}

					extr_pressure append [::plugins::DYE::pages::dsx2_dye_home::src_pressure range \
						[lindex $base_shot(steps_indexes) $extr_start_idx] end]
					set data(base_extr_peak_pressure) \
						"[format {%.1f} [vector expr max(extr_pressure)]] [translate {bar}]"
					
					set data(base_full_final_flow) $data(base_final_flow)
				}
			}
		} elseif { $side eq "right" } { 
			if { $data(right_clock) <= 0 } {
				set data(comp_time) "-"
				set data(comp_peak_pressure) "-"
				set data(comp_final_pressure) "-"
				set data(comp_peak_flow) "-"
				set data(comp_final_flow) "-"
				set data(comp_peak_weight) "-"
				set data(comp_final_weight) "-"
				set data(comp_peak_temperature) "-"
				set data(comp_final_temperature) "-"
				
				set data(comp_extr_peak_pressure) "-"
				set data(comp_full_final_flow) "-"
			} else {
				set data(comp_time) "[format {%.0f} $comp_shot(extraction_time)] [translate s]"
				_stats_strings right pressure bar
				_stats_strings right flow "ml/s"
				_stats_strings right weight "g/s" flow_weight
				_stats_strings right temperature ""
				
				if { $step < 0 } {
					if { [llength $comp_shot(steps_indexes)] > 1 } {
						set extr_start_idx 2
					} else {
						set extr_start_idx 1
					}
					if { [extr_pressure  length] > 0 } {
						extr_pressure delete 0:end
					}
					extr_pressure append [compare_espresso_pressure range \
						[lindex $comp_shot(steps_indexes) $extr_start_idx] end]
					set data(comp_extr_peak_pressure) \
						"[format {%.1f} [vector expr max(extr_pressure)]] [translate {bar}]"
					
					set data(comp_full_final_flow) $data(comp_final_flow)
				}
			}
		}
		
		vector destroy extr_pressure
	}
	
	proc fill_comparison {} {
		variable widgets
		variable data
		variable base_shot
		variable comp_shot
		
		::plugins::DYE::ui::shot_to_tk_text $widgets(compare) base_shot -comp comp_shot \
			-show_diff_only $data(show_diff_only) -clear_text 1
	}
	
	proc page_done {} {
		dui page close_dialog
	}
}

