package require struct::list

proc ::plugins::DYE::setup_ui_DSx2 {} {
	variable settings
	DSx2_setup_dui_theme
	
	# DSx2 HOME PAGES UI INTEGRATION
	# Only done on strict DSx2 skin (no fork) and default "Damian" DSx2 theme
	if { ![is_DSx2 yes "Damian"] } {
		return
	}

	# Add new pages
	dui page add dsx2_dye_favs -namespace true -type fpdialog
	dui page add dsx2_dye_edit_fav -namespace true -type fpdialog
	
	# Modify DSx2 home page(s) to adapt to DYE UI widgets and workflow
	::dui::pages::dsx2_dye_home::setup
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
		dselector.fill $button_bg_c
		dselector.selectedfill $foreground_c
		dselector.outline $foreground_c
		dselector.selectedoutline $foreground_c
		dselector.label_fill $button_label_c
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
		
		line.fill.menu_dlg_sepline $foreground_c
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
		text_tag.font.dyev3_which_shot "[dui font get $font 15]"
		text_tag.justify.dyev3_which_shot center
		
		text_tag.justify.dyev3_profile_title center
		
		text_tag.foreground.dyev3_section $text_c
		text_tag.font.dyev3_section "[dui font get $font 17]" 
		text_tag.spacing1.dyev3_section [dui platform rescale_y 20]
		
		text_tag.foreground.dyev3_field $text_c 
		text_tag.lmargin1.dyev3_field [dui platform rescale_x 35] 
		text_tag.lmargin2.dyev3_field [dui platform rescale_x 45]
		
		text_tag.foreground.dyev3_value #4e85f4
		
		text_tag.foreground.dyev3_compare grey
		
		text_tag.font.dyev3_field_highlighted "[dui font get $font 15]"
		text_tag.background.dyev3_field_highlighted darkgrey
		text_tag.font.dyev3_field_nonhighlighted "[dui font get $font 15]"
		text_tag.background.dyev3_field_nonhighlighted {}	
	}]	
}


# Note that we use this workspace to modify the existing DSx2 home page, but this
# doesn't match a DUI page workspace.
namespace eval ::dui::pages::dsx2_dye_home {
	variable main_graph_height
	set main_graph_height [rescale_y_skin 840]
	
	proc setup {} {
		variable main_graph_height 
		
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
		bind $::home_espresso_graph [platform_button_press] +{::dui::pages::dsx2_dye_home::press_graph_hook}
		
		blt::vector create src_elapsed src_pressure src_pressure_goal src_flow src_flow_goal \
			src_flow_weight src_weight src_temperature src_temperature_goal src_resistance src_steps
		
		if { [ifexists ::settings(espresso_clock) 0] > 0 && \
				$::plugins::DYE::settings(next_src_clock) != $::settings(espresso_clock) && \
				[string is true $::plugins::DYE::settings(dsx2_update_chart_on_copy)] && \
				[string is true $::plugins::DYE::settings(dsx2_show_shot_desc_on_home)] } {
			# Called proc already defines the source shot desc
			load_home_graph_from $::plugins::DYE::settings(next_src_clock) 
		} else {
			::plugins::DYE::define_last_shot_desc
		}
		::plugins::DYE::define_next_shot_desc
		
		# Add last/source & next shot description buttons to the home page
		if { [string is true $::plugins::DYE::settings(dsx2_show_shot_desc_on_home)] } {
			set istate normal
		} else {
			set istate hidden
		}
		
		dui add dbutton $page 50 1370 -bwidth 1000 -bheight 170 -anchor nw \
			-tags launch_dye_last -labelvariable {$::plugins::DYE::settings(last_shot_desc)} \
			-label_pos {0.0 0.27} -label_anchor nw \
			-label_justify left -label_font_size -4 -label_fill $::skin_text_colour -label_width 900 \
			-label1variable {$::plugins::DYE::settings(last_shot_header)} -label1_font_family notosansuibold \
			-label1_font_size -4 -label1_fill $::skin_text_colour \
			-label1_pos {0.0 0.0} -label1_anchor nw -label1_justify left -label1_width 1000 \
			-command [::list ::plugins::DYE::open -which_shot "source"] -tap_pad {50 20 0 25} \
			-longpress_cmd [::list ::dui::page::open_dialog dye_which_shot_dlg -coords \[::list 50 1350\] -anchor sw] \
			-initial_state $istate
		
		# -labelvariable {[::plugins::DYE::define_next_shot_desc]}
		dui add dbutton $page 1950 1370 -bwidth 1000 -bheight 170 -anchor ne \
			-tags launch_dye_next -labelvariable {$::plugins::DYE::settings(next_shot_desc)} \
			-label_pos {1.0 0.27} -label_anchor ne \
			-label_justify right -label_font_size -4 -label_fill $::skin_text_colour -label_width 1000 \
			-label1variable {$::plugins::DYE::settings(next_shot_header)} -label1_font_family notosansuibold \
			-label1_font_size -4 -label1_fill $::skin_text_colour \
			-label1_pos {1.0 0.0} -label1_anchor ne -label1_justify right -label1_width 1000 \
			-command [::list ::plugins::DYE::open -which_shot next] -tap_pad {0 20 75 25} \
			-longpress_cmd [::list ::dui::page::open_dialog dye_which_shot_dlg -coords \[::list 1950 1350\] -anchor se] \
			-initial_state $istate
	
		toggle_show_shot_desc

#		# Add extra DYE inputs to the espresso settings page
#		#set ::wf_dose_x 160
#		# orig y 580
#		set y 1100	
#		dui add dtext $page [expr {840 + $::wf_dose_x}] $y -tags wf_heading_grinder_setting \
#			-text [translate "Grinder setting"] -font [skin_font font_bold 18] -fill $::skin_text_colour -anchor center
#		add_colour_button wf_grinder_setting_minus off [expr {730 + $::wf_dose_x}] [expr {$y+40}] 100 100 {\Uf106} \
#			[list [namespace current]::adjust grinder_setting 1]
#		set_button wf_grinder_setting_minus font [skin_font awesome_light [fixed_size 34]]
##		add_colour_button wf_dose_plus off [expr 730 + $::wf_dose_x] 820 100 100 {\Uf107} {adjust dose -1}; set_button wf_dose_plus font [skin_font awesome_light [fixed_size 34]]
##		add_colour_button wf_dose_minus_10 off [expr 850 + $::wf_dose_x] 620 100 100 {\Uf106} {adjust dose 0.1}; set_button wf_dose_minus_10 font [skin_font awesome_light [fixed_size 34]]
##		add_colour_button wf_dose_plus_10 off [expr 850 + $::wf_dose_x] 820 100 100 {\Uf107} {adjust dose -0.1}; set_button wf_dose_plus_10 font [skin_font awesome_light [fixed_size 34]]
##		dui add variable off [expr 840 + $::wf_dose_x] 770 -fill $::skin_text_colour  -font [skin_font font_bold 24] -tags wf_beans -anchor center -textvariable {[round_to_one_digits $::settings(grinder_dose_weight)]g}
##		
##		dui add dtext off [expr 840 - $::wf_dose_x] 580 -tags wf_heading_bean_cup -text [translate "Dose cup"] -font [skin_font font_bold 18] -fill $::skin_text_colour -anchor center
##		add_colour_button wf_bean_cup_button off [expr 730 - $::wf_dose_x] 620 220 100 {$::skin(bean_cup_g)g} {set_bean_cup_weight}
##		add_icon_button wf_info_button off [expr 630 - $::wf_dose_x] 620 100 100 {$::skin(icon_info)} {show_wf_espresso_info}
		
#		trace add execution ::show_espresso_settings leave ${ns}::show_espresso_settings_hook		

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
				dui item config $main_home_page dye_fav_icon_$i -initial_state hidden
			}
			
			dui item config $main_home_page {l_favs_number b_favs_number* bb_favs_number* } \
				-initial_state hidden
		}
		
		if { $::plugins::DYE::settings(dsx2_show_shot_desc_on_home) } {
			$::home_espresso_graph configure -height $main_graph_height
			dui item config $::skin_home_pages live_graph_data -initial_state hidden
			
			# Updates e.g. the profile title in the next shot desc if coming from a profile switch
			::plugins::DYE::define_next_shot_desc
		}
		
		return 1
	}
	
	proc show { args } {
		set main_home_page [lindex $::skin_home_pages 0]
		
		# This call doesn't work on the page load event, so we need to put it here,
		# but it produces a slight flickering effect as all DSx2 favs are first shown,
		# then hidden
		if { [string is true $::plugins::DYE::settings(dsx2_use_dye_favs)] } {
			dui item config $main_home_page {l_favs_number b_favs_number* bb_favs_number*} \
				-state hidden
		} else {
			::rest_fav_buttons
		}
		
		if { $::plugins::DYE::settings(dsx2_show_shot_desc_on_home) } {
			# If the graph is hidden, hide the shot desc texts too (this happens and is not
			# captured elsewhere e.g. if entering a DYE favs page from a GHC settings "page"
			# and coming back.
			if { [[dui canvas] itemcget main_graph -state ] eq "hidden"} {
				dui item config $main_home_page {launch_dye_last* launch_dye_next*} -state hidden
			}
		}
	}
	
	proc show_graph_hook { args } {
		variable main_graph_height
		set page [lindex $::skin_home_pages 0]
		
		if { $::plugins::DYE::settings(dsx2_show_shot_desc_on_home) } {
			$::home_espresso_graph configure -height $main_graph_height
			dui item config $page live_graph_data -initial_state hidden -state hidden
			dui item show $page {launch_dye_last* launch_dye_next*}
			::plugins::DYE::define_next_shot_desc
		}
	}
	
	proc hide_graph_hook { args } {
		set page [lindex $::skin_home_pages 0]
		
		if { [string is true $::plugins::DYE::settings(dsx2_use_dye_favs)] } {
			dui item config $page {l_favs_number b_favs_number* bb_favs_number* } \
				-state hidden
		}
		if { $::plugins::DYE::settings(dsx2_show_shot_desc_on_home) } {
			dui item hide $page {launch_dye_last* launch_dye_next*}
		}
	}
	
	proc press_graph_hook { args } {
		variable main_graph_height
		set page [lindex $::skin_home_pages 0]
		
		if { $::plugins::DYE::settings(dsx2_show_shot_desc_on_home) } {
			if { $::main_graph_height == [rescale_y_skin 1010] } {
				$::home_espresso_graph configure -height $main_graph_height
				dui item show $page {launch_dye_last* launch_dye_next*}
				dui item config $page live_graph_data -initial_state hidden -state hidden
			} elseif { $::main_graph_height == $main_graph_height } {
				dui item hide $page {launch_dye_last* launch_dye_next*}
			}
		}
	}
	
#	proc show_espresso_settings_hook { args } {
##		dui item show [lindex $::skin_home_pages 0] \
##			{wf_heading_grinder_setting} -initial 1 -current 1
#		#msg -INFO "DYE SHOWING wf_heading_grinder_setting"		
#		dui item config off wf_heading_grinder_setting -initial_state normal -state normal
#	}
	
	proc toggle_show_shot_desc { } {
		variable main_graph_height
		set main_home_page [lindex $::skin_home_pages 0]
	
		# Show or hide DYE launch button on the workflow GHC functions buttons row
		if { [string is true $::plugins::DYE::settings(dsx2_show_shot_desc_on_home)] } {
			dui item config $main_home_page {launch_dye_last* launch_dye_next*} \
				-initial_state normal
			dui item config $main_home_page live_graph_data -initial_state hidden
			$::home_espresso_graph configure -height $main_graph_height
			
			dui item config $main_home_page {bb_dye_bg* s_dye_bg* b_dye_bg* l_dye_bg li_dye_bg launch_dye*} \
				-initial_state hidden		
		} else {
			dui item config $main_home_page {launch_dye_last* launch_dye_next*} \
				-initial_state hidden
			
			dui item config $::skin_home_pages live_graph_data -initial_state normal
			if { [dui item cget $main_home_page graph_a -initial_state] ne "normal" } {
				$::home_espresso_graph configure -height [rescale_y_skin 1010]
			}
			
			dui item config $main_home_page {bb_dye_bg* s_dye_bg* b_dye_bg* l_dye_bg li_dye_bg launch_dye*} \
				-initial_state normal				
		}
	}
	
	proc adjust_hook { args } {
		::plugins::DYE::define_next_shot_desc	
	}
	
	proc adjust { var change } {
		if { $var eq "grinder_setting" } {
			if { $::settings(grinder_setting) eq {} } {
				set ::settings(grinder_setting) 0
			}
			if { [string is double $::settings(grinder_setting)] } {
				set ::settings(grinder_setting) [round_to_two_digits \
					[expr {$::settings(grinder_setting) + $change}]]
				::plugins::DYE::define_next_shot_desc
			}
		}
	}
	
	proc set_scale_weight_to_dose_hook { args } {
		::plugins::DYE::define_next_shot_desc
	}
	
	# Modified from ::restore_live_graphs
	proc load_home_graph_from { {src_clock {}} {src_array_name {}} } {
		if { [string is integer $src_clock] && $src_clock > 0 } {
			array set src_shot [::plugins::SDB::load_shot $src_clock 1 1 0 0]
		} elseif { $src_array_name ne {} } {
			upvar $src_array_name src_shot
		} else {
			msg -ERROR [namespace current] "DSx2_load_live_graphs_from: Invoked without input data"
			return
		}
		
		#set last_elapsed_time_index [expr {[espresso_elapsed length] - 1}]
		if { ! [info exists src_shot(graph_espresso_elapsed)] } {
			msg -WARNING [namespace current] "DSx2_load_live_graphs_from_shot: source shot data doesn't include 'graph_espresso_elapsed'"
			return
		}
		if {[llength $src_shot(graph_espresso_elapsed)] < 2} {
			msg -WARNING [namespace current] "DSx2_load_live_graphs_from_shot: source espresso_elapsed only has 0 or 1 elements"			
			return
		}
		
		src_elapsed length 0
		src_elapsed set $src_shot(graph_espresso_elapsed)
		
		# Apply the temp units transformation to all elements of the temps lists
		set src_shot(graph_espresso_temperature_basket) [::struct::list mapfor x \
				$src_shot(graph_espresso_temperature_basket) {skin_temperature_units $x}]
		set src_shot(graph_espresso_temperature_goal) [::struct::list mapfor x \
				$src_shot(graph_espresso_temperature_goal) {skin_temperature_units $x}]
		
		foreach lg {pressure_goal flow_goal temperature_goal pressure flow temperature_basket weight resistance state_change} {
			if { $lg eq "temperature_basket" } {
				set src_name temperature
			} elseif { $lg eq "state_change" } {
				set src_name steps
			} elseif { $lg eq "flow_weight" } {
				set src_name weight	
			} else {
				set src_name $lg
			}
			
			src_$src_name length 0
			if {[info exists src_shot(graph_espresso_$lg)]} {
				src_$src_name append $src_shot(graph_espresso_$lg)
				$::home_espresso_graph element configure home_$src_name -xdata src_elapsed -ydata src_$src_name	
			} else {
				msg -WARNING [namespace current] "DSx2_load_live_graphs_from_shot: series '$lg' not found on shot file with clock '$src_clock"
			}
		}
		
		::plugins::DYE::define_last_shot_desc src_shot
	}
		
}

namespace eval ::dui::pages::dsx2_dye_favs {
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
		
		dui::page::add_items $page headerbar
		
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
		dui add dtext $page [expr $x+$x_2nd_group_offset+$x_toggle_lbl_dist] $y -tags favs_group_by_profile_title_lbl -width 400 \
			-text [translate "Profile"]

		dui add dtoggle $page $x [incr y 125] -anchor nw -tags favs_group_by_workflow -variable favs_group_by_workflow \
			-command {%NS::validate_group_by workflow}
		dui add dtext $page [expr $x+$x_toggle_lbl_dist] $y -tags favs_group_by_workflow_lbl -width 400 \
			-text [translate "Workflow"]

		dui add dtoggle $page [expr $x+$x_2nd_group_offset] $y -anchor nw -tags favs_group_by_grinder_model \
			-variable favs_group_by_grinder_model -command {%NS::validate_group_by grinder_model}
		dui add dtext $page [expr $x+$x_2nd_group_offset+$x_toggle_lbl_dist] $y -tags favs_group_by_grinder_model_lbl -width 400 \
			-text [translate "Grinder"]
		
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
		for {set i 0} {$i < [::plugins::DYE::favorites::max_number]} {incr i 1} {
			if { $i < $data(max_dsx2_home_visible_favs) } {
				set target_pages [list $page dsx2_dye_edit_fav {*}$::skin_home_pages]
			} else {
				set target_pages [list $page dsx2_dye_edit_fav]
			}
			
			dui add dbutton $target_pages [expr $::skin(button_x_fav)-50] [incr y 120] -bwidth [expr 360+100] \
				-shape round_outline -bheight 100 -fill $::skin_forground_colour -outline $::skin_forground_colour \
				-tags [list dye_fav_$i dye_favs] -command [list %NS::load_favorite $i] \
				-labelvariable [subst {\[::plugins::DYE::favorites::fav_title $i\]}] -label_font_size 11 -label_width 450 \
				-initial_state hidden
			 
			dui add symbol $target_pages [expr $::skin(button_x_fav)-50+460+20] [expr {$y+50}] \
				-symbol [::plugins::DYE::favorites::fav_icon_symbol $i] -anchor w -font_size 11 \
				-tags [list dye_fav_icon_$i dye_favs_icons] -initial_state hidden

			dui add dbutton $page [expr $::skin(button_x_fav)-150] $y -bwidth 100 -bheight 100 -shape "" \
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
		
		dui::page::add_items $page skin_version
		
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
			dui item config $main_home_page dye_fav_icon_$i -initial_state $dye_favs_state
			if { $are_favs_visible } {
				dui item config $main_home_page dye_fav_$i* -state $dye_favs_state
				dui item config $main_home_page dye_fav_icon_$i -state $dye_favs_state
			}
		}
		for {set i $::plugins::DYE::settings(dsx2_n_visible_dye_favs)} {$i < $data(max_dsx2_home_visible_favs)} {incr i 1} {
			dui item config $main_home_page dye_fav_$i* -initial_state hidden -state hidden
			dui item config $main_home_page dye_fav_icon_$i -initial_state hidden -state hidden
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
		
		::plugins::DYE::favorites::load $n_fav
		if { $current_page eq "dsx2_dye_favs" } {
			page_done
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
					::dui::pages::dsx2_dye_home::load_home_graph_from $::plugins::DYE::settings(next_src_clock)
				}
				set ::plugins::DYE::settings(dsx2_update_chart_on_copy) 1
				set favs_changed 1
			} elseif { $data(dsx2_update_chart_on_copy) == 0 && \
						[string is true $::plugins::DYE::settings(dsx2_update_chart_on_copy)] } {
				if { $data(dsx2_disable_dye_favs) == 0 && \
						$::plugins::DYE::settings(next_src_clock) != [ifexists ::settings(espresso_clock) 0]} {
					::dui::pages::dsx2_dye_home::load_home_graph_from $::settings(espresso_clock)
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

namespace eval ::dui::pages::dsx2_dye_edit_fav {
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
		
		dui::page::add_items $page headerbar
		
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
			-labels [list [translate "Recent"] [translate "Fixed"]] \
			-initial_state hidden
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
			-text [translate "Yield"]
		
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
			
		
		dui::page::add_items $page skin_version
	}

	proc load { page_to_hide page_to_show n_fav } {
		variable data
		variable all_recent
		
		set data(fav_number) $n_fav
		set data(page_title) "[translate {Edit DYE Favorite}] #[expr $n_fav+1]"		
		array set all_recent {} 
		
		# Load the current favorite data
		set data(fav_type) [current_fav_type]
		change_fav_type
		
		return 1
	}
	
	proc show { page_to_hide page_to_show } {
		variable data
		
		# Show only the fav button for the favorite being edited
		dui item hide $page_to_show {dye_favs dye_favs_icons}
		dui item show $page_to_show dye_fav_$data(fav_number)* 
		dui item show $page_to_show dye_fav_icon_$data(fav_number)
		
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
		
		dui item config $page dye_fav_icon_$data(fav_number) -text \
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
				array set all_recent [::plugins::DYE::favorites::get_all_recent_descs_from_db \
					[expr {$recent_idx+1}]]
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
					if { [info exists example_shot($field_name)] } {
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
		
msg -INFO "DYE validate what_to_copy=[get_what_to_copy]"
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
			borg toast [translate "Please correct the invalid favorite data"]
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

