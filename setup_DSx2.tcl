
proc ::plugins::DYE::setup_ui_DSx2 {} {

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
		dtext.fill.page_title $foreground_c
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

	
	########################################################################################################
	## HOME PAGES INTEGRATION
	::plugins::DYE::update_favorites
	::plugins::DYE::define_past_shot_desc
	
	dui page add dsx2_dye_favs -namespace true -type fpdialog
	dui page add dsx2_dye_edit_fav -namespace true -type fpdialog
	
	# Original 1010
	set ::main_graph_height [rescale_y_skin 900]
	$::home_espresso_graph configure -height [rescale_y_skin 900]
	
	dui item config off live_graph_data -initial_state hidden -state hidden 
	
	#	dui add variable off 30 1570 -tags dye_last_shot_desc -textvariable {$::plugins::DYE::past_shot_desc_one_line} \
	#		-font_size 12 -fill $::skin_forground_colour -anchor "e" -justify "left" -width 2200
	
	dui add dtext off 50 1450 -tags dye_past_shot_title -text "LAST SHOT, 6 minutes ago: Americano workflow" \
		-font_size 12 -fill $::skin_forground_colour -anchor w -justify left -width 2200 \
		-font_family notosansuibold
		
	dui add dtext off 50 1500 -tags dye_past_shot_desc1 -text "Extractamundo 2 - D'Origen Ethiopia Maba Mumbi 18.03.23" \
		-font_size 12 -fill $::skin_forground_colour -anchor w -justify left -width 2200
		
	dui add dtext off 50 1550 -tags dye_past_shot_desc2 -text "P100 @ 1.25 - 18.0g : 36.0g (1:2.0) in 3 + 10 = 12 s" \
		-font_size 12 -fill $::skin_forground_colour -anchor w -justify left -width 2200

	dui add dbutton off 1950 1410 -bwidth 900 -bheight 170 -anchor ne \
		-tags launch_dye_next -labelvariable {$::plugins::DYE::settings(next_shot_desc)} -label_pos {1.0 0.27} -label_anchor ne \
		-label_justify right -label_font_size -4 -label_fill $::skin_forground_colour -label_width 900 \
		-label1 "NEXT SHOT:" -label1_font_family notosansuibold -label1_font_size -4 -label1_fill $::skin_forground_colour \
		-label1_pos {1.0 0.0} -label1_anchor ne -label1_justify right -label1_width 900 \
		-command [::list ::plugins::DYE::open -which_shot next] -tap_pad {0 20 75 25} \
		-longpress_cmd [::list ::dui::page::open_dialog dye_which_shot_dlg -coords {1950 1400} -anchor se]
		
	dui add dtext off 1950 1450 -tags dye_next_shot_title -text "NEXT SHOT: Espresso workflow" \
		-font_size 12 -fill $::skin_forground_colour -anchor e -justify right -width 2200 \
		-font_family notosansuibold
		
	dui add dtext off 1950 1500 -tags dye_next_shot_desc1 -text "Blooming Espresso - D'Origen Ethiopia Maba Mumbi 18.03.23" \
		-font_size 12 -fill $::skin_forground_colour -anchor e -justify right -width 2200
		
	dui add dtext off 1950 1550 -tags dye_next_shot_desc2 -text "P100 @ 1.5 - 19.1g : 50.0g (1:2.6)" \
		-font_size 12 -fill $::skin_forground_colour -anchor e -justify right -width 2200

	
	dui item config $::skin_home_pages launch_dye* -initial_state normal -state normal
	
}

namespace eval ::dui::pages::dsx2_dye_favs {
	variable widgets
	array set widgets {}
	
	variable data
	array set data {
		max_home_visible_favs 5
	}
	
	# This proc also adds the first 5 favorite buttons to the DSx2 home page
	proc setup {} {
		variable data
		variable widgets	
		set page [namespace tail [namespace current]]
		
		dui::page::add_items $page headerbar
		
		dui add dtext $page 1000 175 -text [translate "DYE Favorites"] -tags dye_favs_title -style page_title 
			#-anchor center -justify center
		
		# Favorites bar on the right
		set y -20
		for {set i 0} {$i < $::plugins::DYE::max_n_favorites} {incr i 1} {
			if { $i < $data(max_home_visible_favs) } {
				set target_pages [list $page dsx2_dye_edit_fav {*}$::skin_home_pages]
			} else {
				set target_pages [list $page dsx2_dye_edit_fav]
			}
			
			dui add dbutton $target_pages [expr $::skin(button_x_fav)-50] [incr y 120] -bwidth [expr 360+100] \
				-shape round_outline -bheight 100 -fill $::skin_forground_colour -outline $::skin_forground_colour \
				-tags [list dye_fav_$i dye_favs] -command [list ::plugins::DYE::::load_favorite $i] \
				-labelvariable [subst "\[::plugins::DYE::favorite_title $i\]"] -label_font_size 12 -initial_state hidden
			
			dui add dbutton $page [expr $::skin(button_x_fav)-150] $y -bwidth 100 -bheight 100 -shape "" \
				-fill $::skin_background_colour -tags [list dye_fav_edit_$i dye_fav_edits] \
				-command [list ::dui::page::load dsx2_dye_edit_fav $i] \
				-symbol pen -symbol_pos {0.5 0.5} -symbol_anchor center -symbol_justify center -symbol_font_size 20 \
				-symbol_fill $::skin_forground_colour 
		}
		
		dui add dbutton $::skin_home_pages [expr $::skin(button_x_fav)-50] \
			[expr 108+(120*$::plugins::DYE::settings(dsx2_n_visible_dye_favs))] \
			-bwidth 460 -bheight 80 -shape {} -fill $::skin_background_colour -tags dye_fav_more \
			-label {. . .} -label_font_size 20 -label_font_family notosansuibold -label_pos {0.5 0.2} \
			-label_fill $::skin_forground_colour -command [list dui::page::load dsx2_dye_favs]
		
		# Bottom area
		dui add dbutton $page 800 1425 -bwidth 300 -bheight 100 -shape round -tags close_dye_edit_favs \
			-label [translate "Back"] -label_pos {0.5 0.5} -label_justify center -command dui::page::close_dialog
		
		dui::page::add_items $page skin_version
		
		show_or_hide_dye_favorites
	}

	proc show { page_to_hide page_to_show } {
		dui item show $page_to_show dye_favs
	}

	proc hide { page_to_hide page_to_show } {
		variable data
		for {set i $::plugins::DYE::settings(dsx2_n_visible_dye_favs)} {$i < $data(max_home_visible_favs)} {incr i 1} {
			dui item hide $page_to_show dye_fav_$i
		}
	}

	# Globally Enables/Shows or Disables/Hides the DYE favorites
	proc show_or_hide_dye_favorites { {show {}} } {
		variable widgets
		variable data
		set page [namespace tail [namespace current]]
		
		if {$show eq {}} {
			set show $::plugins::DYE::settings(dsx2_use_dye_favs)
		}
		
		if {[string is true $show]} {
			set dsx2_favs_state hidden
			set dye_favs_state normal
		} else {
			set dsx2_favs_state normal
			set dye_favs_state hidden
		}
		
		# Show or hide DSx2 favorites
		for { set i 1 } { $i < 6 } { incr i } {
			dui item config $::skin_home_pages bb_fav$i* -initial_state $dsx2_favs_state -state $dsx2_favs_state
			dui item config $::skin_home_pages s_fav$i* -initial_state $dsx2_favs_state -state $dsx2_favs_state
			dui item config $::skin_home_pages b_fav$i -initial_state $dsx2_favs_state -state $dsx2_favs_state
			dui item config $::skin_home_pages l_fav$i -initial_state $dsx2_favs_state -state $dsx2_favs_state
			dui item config $::skin_home_pages li_fav$i -initial_state $dsx2_favs_state -state $dsx2_favs_state
			
			dui item config $::skin_home_pages b_fav${i}_edit -initial_state $dsx2_favs_state -state $dsx2_favs_state
			dui item config $::skin_home_pages l_fav${i}_edit -initial_state $dsx2_favs_state -state $dsx2_favs_state
		}
	
		dui item config $::skin_home_pages bb_dye_bg* -initial_state $dsx2_favs_state -state $dsx2_favs_state
		dui item config $::skin_home_pages s_dye_bg* -initial_state $dsx2_favs_state -state $dsx2_favs_state
		dui item config $::skin_home_pages b_dye_bg -initial_state $dsx2_favs_state -state $dsx2_favs_state
		dui item config $::skin_home_pages l_dye_bg -initial_state $dsx2_favs_state -state $dsx2_favs_state
		dui item config $::skin_home_pages li_dye_bg -initial_state $dsx2_favs_state -state $dsx2_favs_state

		# Show or hide DYE favorites
		for {set i 0} {$i < $::plugins::DYE::settings(dsx2_n_visible_dye_favs)} {incr i 1} {
			dui item config $page dye_fav_$i* -initial_state $dye_favs_state -state $dye_favs_state 
		}
		for {set i $::plugins::DYE::settings(dsx2_n_visible_dye_favs)} {$i < $data(max_home_visible_favs)} {incr i 1} {
			dui item config $page dye_fav_$i* -initial_state hidden -state hidden
		}
		
		dui item config [lindex $::skin_home_pages 0] dye_fav_more* -initial_state $dye_favs_state -state $dye_favs_state 
	}
	
	
}

namespace eval ::dui::pages::dsx2_dye_edit_fav {
	variable widgets
	array set widgets {}
	
	variable data
	array set data {
		page_title {Edit DYE Favorite}
		editing_fav -1		
		fav_type n_recent
		fav_title {}
		fav_workflow 1
		fav_workflow {espresso}		
		fav_profile {Extractamundo 2}
		fav_beans {D'Origen Panama BMM}
		fav_grinder {P100 @ 1.25}
		fav_ratio {18:36}
		fav_comment {Comment}
		fav_people {Enrique / Enrique}
		fav_copy_workflow 1	
		fav_copy_workflow_settings 1
		fav_copy_profile_title 1
		fav_copy_profile 1
		fav_copy_beans 1
		fav_copy_grinder 1
		fav_copy_ratio 1
		fav_copy_comment 0
		fav_copy_people 0
	}
	
	proc setup {} {
		variable data
		variable widgets	
		set page [namespace tail [namespace current]]
		
		dui::page::add_items $page headerbar
		
		dui add variable $page 1000 175 -textvariable {page_title} -tags dye_edit_fav_title -style page_title 
			#-anchor center -justify center
		
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
			-labels [list [translate "Recent beans"] [translate "Fixed values"]] 
		
		dui add entry $page [expr $x+300] [incr y 130] -tags {fav_title fav_editing} -canvas_width 800 \
			-label [translate "Favorite title"] -label_pos [list $x $y] 

		dui add dtext $page $x [incr y 160] -tags {fav_what_copy_lbl fav_editing} -width 1000 \
			-text [translate "What to copy?"] -font_family notosansuibold 
		dui add dtext $page $x_data $y -tags {fav_data_lbl fav_editing} -width 800 \
			-text [translate "Data to copy (from Next Shot definition)"] -font_family notosansuibold 

		dui add dtoggle $page $x [incr y 100] -anchor nw -tags {fav_copy_workflow fav_editing} \
			-variable fav_copy_workflow 
		dui add dtext $page [expr $x+$x_toggle_lbl_dist] $y -tags {fav_copy_workflow_lbl fav_editing} -width 400 \
			-text [translate "Workflow"] 
		dui add dtoggle $page [expr $x+$x_2nd_what_offset] $y -anchor nw -tags {fav_copy_workflow_settings fav_editing} \
			-variable fav_copy_workflow_settings 
		dui add dtext $page [expr $x+$x_2nd_what_offset+$x_toggle_lbl_dist] $y -tags {fav_copy_workflow_settings_lbl fav_editing} -width 400 \
			-text [translate "Workflow settings"] 
		dui add variable $page $x_data $y -tags {fav_workflow fav_editing} -width 800 -textvariable fav_workflow \
			-anchor nw -justify left -font_size -2 
		
		dui add dtoggle $page $x [incr y 100] -anchor nw -tags {fav_copy_profile_title fav_editing} \
			-variable fav_copy_profile_title 
		dui add dtext $page [expr $x+$x_toggle_lbl_dist] $y -tags {fav_copy_profile_title_lbl fav_editing} -width 800 \
			-text [translate "Profile title"] 
		dui add dtoggle $page [expr $x+$x_2nd_what_offset] $y -anchor nw -tags {fav_copy_profile fav_editing} -variable fav_copy_profile \
			
		dui add dtext $page [expr $x+$x_2nd_what_offset+$x_toggle_lbl_dist] $y -tags {fav_copy_profile_lbl fav_editing} -width 800 \
			-text [translate "Full profile"] 		
		dui add variable $page $x_data $y -tags {fav_profile fav_editing} -width 800 -textvariable fav_profile \
			-anchor nw -justify left -font_size -2 
		
		dui add dtoggle $page $x [incr y 100] -anchor nw -tags {fav_copy_beans fav_editing} -variable fav_copy_beans \
			
		dui add dtext $page [expr $x+$x_toggle_lbl_dist] $y -tags {fav_copy_beans_lbl fav_editing} -width 800 \
			-text [translate "Beans"] 
		dui add dtoggle $page [expr $x+$x_2nd_what_offset] $y -anchor nw -tags {fav_copy_roast_date fav_editing} \
			-variable fav_copy_roast_date 
		dui add dtext $page [expr $x+$x_2nd_what_offset+$x_toggle_lbl_dist] $y -tags {fav_copy_roast_date_lbl fav_editing} -width 800 \
			-text [translate "Roast date"] 		
		dui add variable $page $x_data $y -tags {fav_beans fav_editing} -width 800 -textvariable fav_beans \
			-anchor nw -justify left -font_size -2 
		
		dui add dtoggle $page $x [incr y 100] -anchor nw -tags {fav_copy_grinder fav_editing} -variable fav_copy_grinder \
			
		dui add dtext $page [expr $x+$x_toggle_lbl_dist] $y -tags {fav_copy_grinder_lbl fav_editing} -width 800 \
			-text [translate "Grinder"] 
		dui add dtoggle $page [expr $x+$x_2nd_what_offset] $y -anchor nw -tags {fav_copy_grinder_setting fav_editing} \
			-variable fav_copy_grinder_setting 
		dui add dtext $page [expr $x+$x_2nd_what_offset+$x_toggle_lbl_dist] $y -tags {fav_copy_grinder_setting_lbl fav_editing} -width 800 \
			-text [translate "Grinder setting"] 
		dui add variable $page $x_data $y -tags {fav_grinder fav_editing} -width 800 -textvariable fav_grinder \
			-anchor nw -justify left -font_size -2 
		
		dui add dtoggle $page $x [incr y 100] -anchor nw -tags {fav_copy_dose fav_editing} -variable fav_copy_dose \
			
		dui add dtext $page [expr $x+$x_toggle_lbl_dist] $y -tags {fav_copy_dose_lbl fav_editing} -width 800 \
			-text [translate "Dose"] 
		dui add dtoggle $page [expr $x+$x_2nd_what_offset] $y -anchor nw -tags {fav_copy_drink_weight fav_editing} \
			-variable fav_copy_drink_weight 
		dui add dtext $page [expr $x+$x_2nd_what_offset+$x_toggle_lbl_dist] $y -tags {fav_copy_drink_weight_lbl fav_editing} -width 800 \
			-text [translate "Drink weight"] 
		dui add variable $page $x_data $y -tags {fav_ratio fav_editing} -width 800 -textvariable fav_ratio \
			-anchor nw -justify left -font_size -2 

		dui add dtoggle $page $x [incr y 100] -anchor nw -tags {fav_copy_comment fav_editing} -variable fav_copy_comment \
			
		dui add dtext $page [expr $x+150] $y -tags {fav_copy_comment_lbl fav_editing} -width 800 \
			-text [translate "Espresso comment"]  
		dui add variable $page $x_data $y -tags {fav_comment fav_editing} -width 800 -textvariable fav_comment \
			-anchor nw -justify left -font_size -2 
		
		dui add dtoggle $page $x [incr y 100] -anchor nw -tags {fav_copy_barista fav_editing} -variable fav_copy_barista \
			
		dui add dtext $page [expr $x+150] $y -tags {fav_copy_barista_lbl fav_editing} -width 800 \
			-text [translate "Barista"] 
		dui add dtoggle $page [expr $x+$x_2nd_what_offset] $y -anchor nw -tags {fav_copy_drinker fav_editing} \
			-variable fav_copy_drinker 
		dui add dtext $page [expr $x+$x_2nd_what_offset+150] $y -tags {fav_copy_drinker_lbl fav_editing} -width 800 \
			-text [translate "Drinker"] 		
		dui add variable $page $x_data $y -tags {fav_people fav_editing} -width 800 -textvariable fav_people \
			-anchor nw -justify left -font_size -2 
		
		# Bottom area
		dui add dbutton $page 600 1425 -bwidth 300 -bheight 100 -shape round -tags save_fav_edits \
			-label [translate "Save favorite"] -label_pos {0.5 0.5} -label_justify center -command save_fav_edits \
			
		dui add dbutton $page 1000 1425 -bwidth 300 -bheight 100 -shape round -tags cancel_fav_edits \
			-label [translate "Cancel edit"] -label_pos {0.5 0.5} -label_justify center -command cancel_fav_edits \
			
		
		dui::page::add_items $page skin_version
		
		#show_or_hide_dye_favorites
	}

	proc load { page_to_hide page_to_show n_fav } {
		variable data
		
		set data(editing_fav) $n_fav
		set data(page_title) "[translate {Edit DYE Favorite}] #[expr $n_fav+1]"

		# Load the favorite data
		set fav [lindex $::plugins::DYE::settings(favorites) $n_fav]
		set data(fav_type) [lindex $fav 0]
		change_fav_type
				
		return 1
	}
	
	proc show { page_to_hide page_to_show } {
		variable data
		
		# Show only the fav button for the favorite being edited
		dui item hide $page_to_show dye_favs
		dui item show $page_to_show dye_fav_$data(editing_fav)* 
		
		# Move the bracket "index triangle" to point at the fav being edited
		# NOTE that dui::item::moveto doesn't work with polygons atm as it's restricted to 4 coordinates
		#	and polygons need more.
		set x [expr $::skin(button_x_fav)-135]
		set y [expr 123+(120*$data(editing_fav))]
		[dui canvas] coords [dui item get $page_to_show edit_bracket_index] \
			[dui::page::calc_x $page_to_show [expr $x+8]] [dui::page::calc_y $page_to_show [expr $y]] \
			[dui::page::calc_x $page_to_show [expr $x+8+35]] [dui::page::calc_y $page_to_show [expr $y+20]] \
			[dui::page::calc_x $page_to_show [expr $x+8]] [dui::page::calc_y $page_to_show [expr $y+40]]
	}

#	proc hide { page_to_hide page_to_show } {
#	}
	
	proc edit_favorite { n_fav } {
		variable data
		set page [namespace tail [namespace current]]
		
		set data(page_title) "[translate {Edit DYE Favorite}] #[expr $data(editing_fav)+1]"
		
		# Show editing widgets
		# NOTE that dui::item::moveto doesn't work with polygons atm as it's restricted to 4 coordinates
		#	and polygons need more.
		set x [expr $::skin(button_x_fav)-135]
		set y [expr 123+(120*$n_fav)]
		[dui canvas] coords [dui item get $page edit_bracket_index] \
			[dui::page::calc_x $page [expr $x+8]] [dui::page::calc_y $page [expr $y]] \
			[dui::page::calc_x $page [expr $x+8+35]] [dui::page::calc_y $page [expr $y+20]] \
			[dui::page::calc_x $page [expr $x+8]] [dui::page::calc_y $page [expr $y+40]]
		dui item show $page edit_bracket
		
		for {set i 0} {$i < $::plugins::DYE::max_n_favorites} {incr i 1} {
			dui item hide $page dye_fav_edit_$i*
			if {$i != $n_fav} {
				dui item hide $page dye_fav_$i*
			}
		}
		
#		dui item show $page fav_type*
#		dui item show $page fav_editing
#		dui item hide $page close_dye_edit_favs*
#		dui item show $page save_fav_edits*
#		dui item show $page cancel_fav_edits*

		# Load the favorite data
		set fav [lindex $::plugins::DYE::settings(favorites) $n_fav]
		set data(fav_type) [lindex $fav 0]
		change_fav_type
	}
	
	proc change_fav_type {} {
		variable data
		set page [namespace tail [namespace current]]
		
		set fav [lindex $::plugins::DYE::settings(favorites) $data(editing_fav)]
		
		
		if {$data(fav_type) eq "n_recent"} {
			dui item config $page fav_data_lbl -text [translate "Example data (from recent shot)"]
			dui item disable $page fav_title
		
			set data(fav_title) [lindex $fav 1]
			array set fav_values [lindex $fav 2]
			set data(fav_workflow) [value_or_default fav_values(workflow) {}]
			set data(fav_profile) [value_or_default fav_values(profile_title) {}]
			set data(fav_beans) [string trim "[value_or_default fav_values(bean_brand) {}] [value_or_default fav_values(bean_type) {}] [value_or_default fav_values(roast_date) {}]"]
			set data(fav_grinder) "[value_or_default fav_values(grinder_model) {}] @ [value_or_default fav_values(grinder_setting) {}]"
			set data(fav_ratio) "[value_or_default fav_values(grinder_dose_weight) {}]g : [value_or_default fav_values(drink_weight) {}]g"
			set data(fav_comment) [value_or_default fav_values(espresso_comment)]
			set data(fav_ratio) "[value_or_default fav_values(barista) {}] / [value_or_default fav_values(drinker) {}]"
		} elseif {$data(fav_type) eq "fixed"} {
			dui item config $page fav_data_lbl -text [translate "Data to copy (from Next Shot definition)"]
			dui item enable $page fav_title
			
			set data(fav_title) {}
			set data(fav_workflow) [value_or_default fav_values(workflow) {}]
			set data(fav_profile) $::settings(profile_title)
			set data(fav_beans) [string trim "[value_or_default ::settings(bean_brand) {}] [value_or_default ::settings(bean_type) {}] [value_or_default ::settings(roast_date) {}]"]
			set data(fav_grinder) "[value_or_default ::settings(grinder_model) {}] @ [value_or_default ::settings(grinder_setting) {}]"
			set data(fav_ratio) "[value_or_default ::settings(grinder_dose_weight) {}]g : [value_or_default ::settings(drink_weight) {}]g"
			set data(fav_comment) [value_or_default ::settings(espresso_comment)]
			set data(fav_ratio) "[value_or_default ::settings(barista) {}] / [value_or_default ::settings(drinker) {}]"
		}
	}

	proc save_fav_edits {} {
		dui page close_dialog
	}
	
	proc cancel_fav_edits {} {
		dui page close_dialog
	}
	
	proc stop_editing {} {
		variable data
		set data(editing_fav) -1
		set page [namespace tail [namespace current]]
		
#		set data(page_title) [translate "DYE Favorites"]
#		dui item hide $page fav_type*
#		dui item hide $page fav_editing
#		dui item hide $page edit_bracket
#		dui item hide $page save_fav_edits*
#		dui item hide $page cancel_fav_edits*
#		dui item show $page close_dye_edit_favs*
#		
#		for {set i 0} {$i < $::plugins::DYE::max_n_favorites} {incr i 1} {
#			dui item show $page dye_fav_$i*
#			dui item show $page dye_fav_edit_$i*
#		}
	}
	
}
