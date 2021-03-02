#######################################################################################################################
### A Decent DE1app plugin for the DSx skin that improves the default logging / "describe your espresso"
### functionality in Insight and DSx.
###  
### INSTALLATION: 
###	    1) Ensure you have DE1 app v1.33 stable (except for fontawesome symbols, which may need to be downloaded manually) 
###			or higher, and DSx version v4.39 or higher.
###		2) Copy this file "describe_your_espresso.dsx" to the "de1_plus/skins/DSx/DSx_Plugins" folder.
###		3) Restart the app with DSx as skin.
###
### Features:
###	1) "Describe your espresso" accesible from DSx home screen with a single click, for both next and last shots.
###	2) All main description data in a single screen for easier data entry.
###		* Irrelevant options ("I weight my beans" / "I use a refractometer") are removed.
###	3) Facilitate data entry in the UI:
###		* Numeric fields can be typed directly.
###		* Keyboard return in non-multiline entries take you directly to the next field.
###		* Choose categories fields (bean brand, type, grinder, etc) from a list of all previously typed values.
###		* Star-rating system for Enjoyment
###		* Mass-modify past entered categories values at once.
###	4) Description data from previous shot can now be retrieved and modified:
###		* A summary is shown on the History Viewer page, below the profile on both the left and right shots.
###		* When that summary is clicked, the describe page is open showing the description for the past shot,
###			which can be modified.
### 5) Create a SQLite database of shot descriptions.
### 	* Populate on startup
###		* User decides what is to be stored in the database.
###		* Update whenever there are new shots or shot data changes
###		* Update on startup when a shot file has been changed on disk (TODO using a simple/fast test, some cases
###			may be undetected, review)
###		* TBD Persist profiles too (as an option)
### 6) "Filter Shot History" page callable from the history viewer to restrict the shots being shown on both 
###		left and right listboxes.
### 7) TBD Add new description data: other equipment, beans details (country, variety), detailed coffee ratings like
##		in cupping scoring sheets, etc.
### 8) Upload shot files to Miha's visualizer or other repositories with a button press.
### 9) Configuration page allows defining settings and launch database maintenance actions from within the app. 
###
### Source code available in GitHub: https://github.com/ebengoechea/dye_de1app_dsx_plugin/
### This code is released under GPLv3 license. See LICENSE file under the DE1 source folder in github.
###
### By Enrique Bengoechea <enri.bengoechea@gmail.com> 
### (with lots of copy/paste/tweak from Damian, John and Johanna's code!)
########################################################################################################################
package require de1_logging 1.0

set ::skindebug 1 

namespace eval ::plugins::DYE {
	variable author "Enrique Bengoechea"
	variable contact "enri.bengoechea@gmail.com"
	variable version 2.00
	variable github_repo ebengoechea/de1app_plugin_DYE
	variable name [translate "Describe Your Espresso"]
	variable description [translate "Describe your shots: beans, grinder, extraction parameters or people involved.
Describe your last shot, plan the next one, or retrieve shots from your history, searching by any description field."]

	variable min_de1app_version {1.34.14}
	variable min_DSx_version {4.39}
	variable debug_text {}	
	
	# Store widgets used in the skin-specific GUI integration 
	variable widgets
	array set widgets {}
	
	variable desc_text_fields {bean_brand bean_type roast_date roast_level bean_notes grinder_model grinder_setting \
		espresso_notes my_name drinker_name skin repository_links}	
	variable desc_numeric_fields {grinder_dose_weight drink_weight drink_tds drink_ey espresso_enjoyment}
	variable propagated_fields {bean_brand bean_type roast_date roast_level bean_notes grinder_model grinder_setting \
		my_name drinker_name}
	
	variable default_shot_desc_font_color {#206ad4}
	variable last_shot_desc {}	
	variable next_shot_desc {}
	variable past_shot_desc {}
	variable past_shot_desc_one_line {}
	variable past_shot_desc2 {}
	variable past_shot_desc_one_line2 {}
}

### PLUGIN WORKFLOW ###################################################################################################

# Startup the Describe Your Espresso plugin.
proc ::plugins::DYE::main {} {
	msg "Starting the 'Describe Your Espresso' plugin"
	check_versions
		
	foreach ns {DE FSH CFG} { ::plugins::DYE::${ns}::setup_ui }
	# MENU
	
	set skin $::settings(skin)
	set skin_src_fn "[plugin_directory]/DYE/setup_${skin}.tcl"
	if { [file exists $skin_src_fn] } { source $skin_src_fn }
	
	if { [namespace which -command "::plugins::DYE::setup_ui_$::settings(skin)"] ne "" } {
		::plugins::DYE::setup_ui_$::settings(skin)
	}

	
	# Update the describe settings when the a shot is started 
	trace add execution ::reset_gui_starting_espresso enter ::plugins::DYE::reset_gui_starting_espresso_enter_hook
	trace add execution ::reset_gui_starting_espresso leave ::plugins::DYE::reset_gui_starting_espresso_leave_hook
	
	# Ensure the description summary is updated whenever last shot is saved to history.
	# We don't use 'register_state_change_handler' as that would not update the shot file if its metadata is 
	#	changed in the Godshots page in Insight or DSx (though currently that does not work)
	#register_state_change_handler Espresso Idle ::plugins::SDB::save_espresso_to_history_hook
	if { [plugins enabled visualizer_upload] } {
		plugins load visualizer_upload
		trace add execution ::plugins::visualizer_upload::uploadShotData leave ::plugins::DYE::save_espresso_to_history_hook
	} else {
		trace add execution ::save_this_espresso_to_history leave ::plugins::DYE::save_espresso_to_history_hook
	}
	
	if { [ifexists ::debugging 0] == 1 && $::android != 1 } {
		ifexists ::debugging_window_title "Decent"
		wm title . "$::debugging_window_title DYE v$::plugins::DYE::version"
	}
}

# Paint settings screen
proc ::plugins::DYE::preload {} {
	if { [plugins available DGUI] && [plugins available SDB] } {
		plugins preload DGUI
		plugins preload SDB

		::plugins::DGUI::set_symbols filter "\uf0b0" people "\uf500" plug "\uf1e6" cup "\uf0f4" \
			file_upload "\uf574" file_import "\uf56f" file_contract "\uf56c" cloud_download_alt "\uf381" \
			plus "\uf067" pencil "\uf303" paintbrush "\uf5a9" db "\uf1c0" sync "\uf021" \
			circle "\uf111" circle_right "\uf138" circle_left "\uf137" circle_up "\uf331" circle_down "\uf32d" \
			circle_times "\uf057" circle_check "\uf058" \
			bars "\uf0c9" window_close "\uf410" \
			forward "\uf04e" fast_forward "\uf050" backward "\uf04a" fast_backward "\uf049" search "\uf002"
		
		check_settings
		plugins save_settings DYE

		::plugins::DYE::CFG::setup_ui
		return "::plugins::DYE::CFG"
	}
}

proc ::plugins::DYE::msg { {flag ""} args } {
	if { [string range $flag 0 0] eq "-" && [llength $args] > 0 } {
		::logging::default_logger $flag "::plugins::DYE" {*}$args
	} else {
		::logging::default_logger "::plugins::DYE" $flag {*}$args
	}
}

# Verify the minimum required versions of DE1 app & skin are used, and that reuired plugins are availabe and installed,
#	otherwise prevents startup.
proc ::plugins::DYE::check_versions {} {
	if { [package vcompare [package version de1app] $::plugins::DYE::min_de1app_version] < 0 } {
		message_page "[translate {Plugin 'Describe Your Espreso'}] v$::plugins::DYE::plugin_version [translate requires] \
DE1app v$::plugins::DYE::min_de1app_version [translate {or higher}]\r\r[translate {Current DE1app version is}] [package version de1app]" \
		[translate Ok]
	}	
	
	set skin $::settings(skin)
	if { [info exists ::plugins::DYE::min_${skin}_version ] } {
		# TODO: Make a proc that properly returns the skin version??
		if { $skin eq "DSx" } {
			if { [package vcompare $::DSx_settings(version) [subst \$::plugins::DYE::min_$::settings(skin)_version]] < 0 } {
				message_page "[translate {Plugin 'Describe Your Espreso'}] v$::plugins::DYE::plugin_version [translate requires]\
$::settings(skin) skin v[subst \$::plugins::DYE::min_$::settings(skin)_version] [translate {or higher}]\r\r[translate {Current $::settings(sking) version is}] $::DSx_settings(version)" \
				[translate Ok]
			}
		}
	}
	
	# Check plugin dependencies, and ensure they're loaded in the correct order.
	set depends_msg "" 		
	if { [plugins available DGUI] } {
		plugins load DGUI
	} else {		
		append depends_msg [translate "Please install 'Describe GUI' plugin for 'Describe Your Espresso' to work"]
	}
	
	if { [plugins available SDB] } {
		plugins load SDB
	} else {
		append depends_msg "\n[translate {Please install 'Shot DataBase' plugin for 'Describe Your Espresso' to work}]
	}
	
	if { $depends_msg ne "" } {
		# Throw an error that is catched by the plugins system and the plugin is disabled
		error $depends_msg
	}
}

# Ensure all settings values are defined, otherwise set them to their default values.
proc ::plugins::DYE::check_settings {} {
	variable settings
	
	ifexists settings(calc_ey_from_tds) on
	ifexists settings(show_shot_desc_on_home) 1
	ifexists settings(shot_desc_font_color) $::plugins::DYE::default_shot_desc_font_color
	ifexists settings(describe_from_sleep) 1
	ifexists settings(date_format) "%d/%m/%Y"
	ifexists settings(describe_icon) $::plugins::DGUI::symbols(cup)
	ifexists settings(propagate_previous_shot_desc) 1
	ifexists settings(backup_modified_shot_files) 0
	ifexists settings(use_stars_to_rate_enjoyment) 1
	ifexists settings(next_shot_DSx_home_coords) {500 1150}
	ifexists settings(last_shot_DSx_home_coords) {2120 1150}
	ifexists settings(github_latest_url) "https://api.github.com/repos/ebengoechea/de1app_plugin_DYE/releases/latest"
	
	# Propagation mechanism 
	ifexists settings(next_modified) 0
	foreach field_name "$::plugins::DYE::propagated_fields espresso_notes" {
		if { ! [info exists settings(next_$field_name)] } {
			set settings(next_$field_name) {}
		}		
	}
	if { $settings(next_modified) == 0 } {
		if { $settings(propagate_previous_shot_desc) == 1 } {
			foreach field_name $::plugins::DYE::propagated_fields {
				set settings(next_$field_name) $::settings($field_name)
			}
			set settings(next_espresso_notes) {}
		} else {
			foreach field_name "$::plugins::DYE::propagated_fields next_espresso_notes" {
				set settings(next_$field_name) {}
			}
		}
	}
	
	ifexists settings(visualizer_url) "visualizer.coffee"
	ifexists settings(visualizer_endpoint) "api/shots/upload"
	if { ![info exists settings(visualizer_username)] } { set settings(visualizer_username) {} }
	if { ![info exists settings(visualizer_password)] } { set settings(visualizer_password) {} }
	if { ![info exists settings(last_visualizer_result)] } { set settings(last_visualizer_result) {} }
	ifexists settings(auto_upload_to_visualizer) 0
	ifexists settings(min_seconds_visualizer_auto_upload) 6

	set settings(version) $::plugins::DYE::version

	# Ensure load_DSx_past_shot and load_DSx_past2_shot in DSx includes exactly all fields we need when they load the 
	# shots.  	
	if { $::settings(skin) eq "DSx" } {
		# clock drink_weight grinder_dose_weight - already included
		set ::DSx_settings(extra_past_shot_fields) {bean_brand bean_type roast_date \
roast_level bean_notes grinder_model grinder_setting drink_tds drink_ey espresso_enjoyment \
espresso_notes my_name drinker_name scentone skin beverage_type final_desired_shot_weight repository_links}	
	}
}

# Update the current shot description from the "next" description when doing a new espresso, if it has been
# modified by the user.
proc ::plugins::DYE::reset_gui_starting_espresso_enter_hook { args } { 
	msg "DYE: reset_gui_starting_espresso_enter_hook"
	set propagate $::plugins::DYE::settings(propagate_previous_shot_desc)
	
#	if { $::plugins::DYE::settings(next_modified) == 1 } {
		foreach f $::plugins::DYE::propagated_fields {
			set ::settings($f) $::plugins::DYE::settings(next_$f)
#			if { $propagate == 0 } {
#				set ::plugins::DYE::settings(next_$f) {}
#			}
		}
#	} elseif { $propagate == 0 } {
#		foreach f $::plugins::DYE::propagated_fields {
#			set ::settings($f) {}
#		}
#	}
	set ::settings(repository_links) {}	
}


# Reset the "next" description and update the current shot summary description
proc ::plugins::DYE::reset_gui_starting_espresso_leave_hook { args } {
#	msg "DYE: reset_gui_starting_espresso_leave_hook, ::android=$::android, ::undroid=$::undroid"	
#	msg "DYE: reset_gui_starting_espresso_leave - DSx settings bean_weight=$::DSx_settings(bean_weight), settings grinder_dose_weight=$::settings(grinder_dose_weight), DSx_settings live_graph_beans=$::DSx_settings(live_graph_beans)"
#	msg "DYE: reset_gui_starting_espresso_leave - settings drink_weight=$::settings(drink_weight), DSx_settings saw=$::DSx_settings(saw), settings final_desired_shot_weight=$::settings(final_desired_shot_weight), DSx_settings live_graph_weight=$::DSx_settings(live_graph_weight), DE1 scale_sensor_weight $::de1(scale_sensor_weight)"
#	msg "DYE: reset_gui_starting_espresso_leave - DYE_settings next_modified=$::plugins::DYE::settings(next_modified)"
	
#	if { $::plugins::DYE::settings(next_modified) == 1 } {
		# This can't be set on <enter> as it is blanked in reset_gui_starting_espresso
		set ::settings(espresso_notes) $::plugins::DYE::settings(next_espresso_notes)
		set ::plugins::DYE::settings(next_espresso_notes) {}
		set ::plugins::DYE::settings(next_modified) 0
#	}

	if { $::settings(skin) eq "DSx" } {
		if { [info exists ::DSx_settings(live_graph_beans)] && $::DSx_settings(live_graph_beans) > 0 } {
			set ::settings(grinder_dose_weight) $::DSx_settings(live_graph_beans)
		} elseif { [info exists ::DSx_settings(bean_weight)] && $::DSx_settings(bean_weight) > 0 } {
			set ::settings(grinder_dose_weight) [round_to_one_digits [return_zero_if_blank $::DSx_settings(bean_weight)]]
		} else {
			set ::settings(grinder_dose_weight) 0
		}
	}
	
	if { $::undroid == 1 } {		
		if { [info exists ::DSx_settings(saw)] && $::DSx_settings(saw) > 0 } {
			set ::settings(drink_weight) [round_to_one_digits $::DSx_settings(saw)] 
		} elseif { [info exists ::settings(final_desired_shot_weight)] && $::settings(final_desired_shot_weight) > 0 } {
			set ::settings(drink_weight) [round_to_one_digits $::settings(final_desired_shot_weight)]
		} else {
			set ::settings(drink_weight) 0
		}
	} else {
		if { [info exists ::DSx_settings(live_graph_weight)] && $::DSx_settings(live_graph_weight) > 0 } {
			set ::settings(drink_weight) $::DSx_settings(live_graph_weight)
		# Don't use de1(scale_sensor_weight), if bluetooth scale disconnects then this is set to the previous shot weight
#		} elseif { $::de1(scale_sensor_weight) > 0 } {
#			set ::settings(drink_weight) [round_to_one_digits $::de1(scale_sensor_weight)]
		} elseif { [info exists ::DSx_settings(saw)] && $::DSx_settings(saw) > 0 } {
			set ::settings(drink_weight) [round_to_one_digits $::DSx_settings(saw)] 
		} elseif { [info exists ::settings(final_desired_shot_weight)] && $::settings(final_desired_shot_weight) > 0 } {
			set ::settings(drink_weight) [round_to_one_digits $::settings(final_desired_shot_weight)]
		} else {
			set ::settings(drink_weight) 0
		}
	}

	::plugins::DYE::define_last_shot_desc
	::plugins::DYE::define_next_shot_desc
	
	# Settings already saved in reset_gui_starting_espresso, but as we have redefined them...
	::save_settings
	plugins save_settings DYE
}

# Hook executed after save_espresso_rating_to_history
# TBD: NO LONGER NEEDED? define_last_shot_desc ALREADY DONE in reset_gui_starting_espresso_leave_hook,
#	only useful if this is invoked from Insight's original Godshots/Describe Espresso pages.
proc ::plugins::DYE::save_espresso_to_history_hook { args } {
	msg "save_espresso_to_history_hook"
	::plugins::DYE::define_last_shot_desc
}


# Returns a 2 or 3-lines formatted string with the summary of a shot description.
proc ::plugins::DYE::shot_description_summary { {bean_brand {}} {bean_type {}} {roast_date {}} {grinder_model {}} \
		{grinder_setting {}} {drink_tds 0} {drink_ey 0} {espresso_enjoyment 0} {lines 2} \
		{default_if_empty "Tap to describe this shot" }} {
	set shot_desc ""

	set beans_items [list_remove_element [list $bean_brand $bean_type $roast_date] ""]
	set grinder_items [list_remove_element [list $grinder_model $grinder_setting] ""]
	set extraction_items {}
	if {$drink_tds > 0} { lappend extraction_items "[translate TDS] $drink_tds\%" }
	if {$drink_ey > 0} { lappend extraction_items "[translate EY] $drink_ey\%" }
	if {$espresso_enjoyment > 0} { lappend extraction_items "[translate Enjoyment] $espresso_enjoyment" }
	
	set each_line {}
	if {[llength $beans_items] > 0} { lappend each_line [string trim [join $beans_items " "]] }
	if {[llength $grinder_items] > 0} { lappend each_line [string trim [join $grinder_items " \@ "]] }
	if {[llength $extraction_items] > 0} { lappend each_line [string trim [join $extraction_items ", "]] }
			
	if { $lines == 1 } {
		set shot_desc [join $each_line " \- "]
	} elseif { $lines == 2 } {
		if {[llength $each_line] == 3} {
			set shot_desc "[lindex $each_line 0] \- [lindex $each_line 1]\n[lindex $each_line 2]"
		} else {
			set shot_desc [join $each_line "\n"] 
		}
	} else {
		set shot_desc [join $each_line "\n"]
	}

	if {$shot_desc eq ""} { 
		set shot_desc "\[[translate $default_if_empty]\]" 
	}  		
	return $shot_desc
}

# Returns a string with the summary description of the current (last) shot.
# Needs the { args } as this is being used in a trace add execution.
proc ::plugins::DYE::define_last_shot_desc { args } {
	if { $::plugins::DYE::settings(show_shot_desc_on_home) == 1 } {
		if { $::settings(history_saved) == 1 } {		
			set ::plugins::DYE::last_shot_desc [shot_description_summary $::settings(bean_brand) \
				$::settings(bean_type) $::settings(roast_date) $::settings(grinder_model) \
				$::settings(grinder_setting) $::settings(drink_tds) $::settings(drink_ey) \
				$::settings(espresso_enjoyment) 3]
		} else {
			set ::plugins::DYE::last_shot_desc "\[ [translate {Shot not saved to history}] \]"
		}
	} else {
		set ::plugins::DYE::last_shot_desc ""
	}
}


# Returns a string with the summary description of the shot selected on the left side of the DSx History Viewer.
# Needs the { args } as this is being used in a trace add execution.
proc ::plugins::DYE::define_past_shot_desc { args } {
	variable past_shot_desc
	variable past_shot_desc_one_line
	
	if { $::settings(skin) eq "DSx" && [info exists ::DSx_settings(past_bean_brand)] } {
		set past_shot_desc [shot_description_summary $::DSx_settings(past_bean_brand) \
			$::DSx_settings(past_bean_type) $::DSx_settings(past_roast_date) $::DSx_settings(past_grinder_model) \
			$::DSx_settings(past_grinder_setting) $::DSx_settings(past_drink_tds) $::DSx_settings(past_drink_ey) \
			$::DSx_settings(past_espresso_enjoyment)]
		
		set past_shot_desc_one_line [shot_description_summary $::DSx_settings(past_bean_brand) \
			$::DSx_settings(past_bean_type) $::DSx_settings(past_roast_date) $::DSx_settings(past_grinder_model) \
			$::DSx_settings(past_grinder_setting) $::DSx_settings(past_drink_tds) $::DSx_settings(past_drink_ey) \
			$::DSx_settings(past_espresso_enjoyment) 1 ""]
	} else {
		set past_shot_desc ""
		set past_shot_desc_one_line ""
	}
}

# Returns a string with the summary description of the shot selected on the right side of the DSx History Viewer. 
# Needs the { args } as this is being used in a trace add execution.
proc ::plugins::DYE::define_past_shot_desc2 { args } {
	variable past_shot_desc2
	variable past_shot_desc_one_line2
	
	if { $::settings(skin) eq "DSx" } {
		if {$::DSx_settings(history_godshots) == "history" && [info exists ::DSx_settings(past_bean_brand2)] } {
			set past_shot_desc2 [shot_description_summary $::DSx_settings(past_bean_brand2) \
				$::DSx_settings(past_bean_type2) $::DSx_settings(past_roast_date2) $::DSx_settings(past_grinder_model2) \
				$::DSx_settings(past_grinder_setting2) $::DSx_settings(past_drink_tds2) $::DSx_settings(past_drink_ey2) \
				$::DSx_settings(past_espresso_enjoyment2)]
			
			set past_shot_desc_one_line2 [shot_description_summary $::DSx_settings(past_bean_brand2) \
				$::DSx_settings(past_bean_type2) $::DSx_settings(past_roast_date2) $::DSx_settings(past_grinder_model2) \
				$::DSx_settings(past_grinder_setting2) $::DSx_settings(past_drink_tds2) $::DSx_settings(past_drink_ey2) \
				$::DSx_settings(past_espresso_enjoyment2) 1 ""]
		} else {
			set past_shot_desc2 ""
			set past_shot_desc_one_line2 ""
		}
	} else {
		set past_shot_desc2 ""
		set past_shot_desc_one_line2 ""
	}
}

# Returns a string with the summary description of the next shot.
# Needs the { args } as this is being used in a trace add execution.
proc ::plugins::DYE::define_next_shot_desc { args } {
	variable settings
	variable next_shot_desc
	
	if { $settings(show_shot_desc_on_home) == 1 && [info exists settings(next_bean_brand)] } {
		set desc [shot_description_summary $settings(next_bean_brand) \
			$settings(next_bean_type) $settings(next_roast_date) $settings(next_grinder_model) \
			$settings(next_grinder_setting) {} {} {} 2 "\[Tap to describe the next shot\]" ]
		if { $settings(next_modified) == 1 } { append desc " *" }
		set next_shot_desc $desc
	} else {
		set next_shot_desc ""
	}
}

proc ::plugins::DYE::return_blank_if_zero {in} {
	if {$in == 0} { return {} }
	return $in
}

# A TEMPORAL COPY OF THE visualizer plugin upload proc, until it promotes to stable and can be invoked directly.	
#proc ::plugins::DYE::visualizer_upload {content} {
#	msg "uploading shot"
#	borg toast "Uploading Shot"
#	set ::plugins::DYE::settings(last_visualizer_result) {}
#	
#	set content [encoding convertto utf-8 $content]
#
#	http::register https 443 [list ::tls::socket -servername $::plugins::DYE::settings(visualizer_url)]
#
#	set username $::plugins::DYE::settings(visualizer_username)
#	set password $::plugins::DYE::settings(visualizer_password)
#
#	set auth "Basic [binary encode base64 $username:$password]"
#	set boundary "--------[clock seconds]"
#	set type "multipart/form-data, charset=utf-8, boundary=$boundary"
#	set headerl [list Authorization "$auth"]
#
#	set url "https://$::plugins::DYE::settings(visualizer_url)/$::plugins::DYE::settings(visualizer_endpoint)"
#	
#	set contentHeader "Content-Disposition: form-data; name=\"file\"; filename=\"file.shot\"\r\nContent-Type: application/octet-stream\r\n"
#	set body "--$boundary\r\n$contentHeader\r\n$content\r\n--$boundary--\r\n"
#
#	if {[catch {
#		set token [http::geturl $url -headers $headerl -method POST -type $type -query $body -timeout 30000]
#		set status [http::status $token]
#		set answer [http::data $token]
#		set returncode [http::ncode $token]
#		set returnfullcode [http::code $token]
#	} err] != 0} {
#		msg "Could not upload shot! $err"
#		borg toast "Upload failed!"
#		set ::plugins::DYE::settings(last_visualizer_result) "[translate {Upload failed}]: $err"
#		
#		catch { http::cleanup $token }
#		return
#	}
#			
#	msg "DYE Visualizer Upload: token: $token, status: $status, answer: $answer, returncode=$returncode, returnfullcode=$returnfullcode"
#	if {$returncode == 401} {
#		msg "DYE Visualizer Upload failed. Unauthorized"
#		borg toast [translate "Authentication failed: Please check username / password"]
#		set ::plugins::DYE::settings(last_visualizer_result) "[translate {Authentication failed}]: [translate {Please check username / password}]"
#		http::cleanup $token
#		return
#	}
#	if {[string length $answer] == 0 || $returncode != 200} {
#		msg "DYE Visualizer Upload failed: $returnfullcode, $answer"
#		borg toast [translate "Upload failed"]
#		set ::plugins::DYE::settings(last_visualizer_result) "[translate {Upload failed}]: $returnfullcode"
#		http::cleanup $token
#		return
#	}
#
#	borg toast "Upload successful"
#
#	if {[catch {
#		set response [::json::json2dict [http::data $token]]
#		set uploaded_id [dict get $response id]
#	} err] != 0} {
#		msg "Upload failed: Unexpected server answer $answer"
#		set ::plugins::DYE::settings(last_visualizer_result) "[translate {Upload failed}]: [translate {Unexpected server answer}]"
#		http::cleanup $token
#		return
#	}
#
#	set ::plugins::DYE::settings(last_visualizer_result) "[translate {Upload successful}]"
#	http::cleanup $token
#	return $uploaded_id
#}

# Takes a shot (if the shot contents array is provided, use it, otherwise reads from disk from the filename parameter),
# 	uploads it to visualizer, changes its repository_links settings if necessary, and persists the change to disk.
# 'clock' can have any format supported by proc get_shot_file_path, though it is ignored if contents is provided.
# Returns the repository link if successful, empty string otherwise
proc ::plugins::DYE::upload_to_visualizer_and_save { clock } {
	if { ! [plugins enabled visualizer_upload] } return
	array set arr_changes {}
	set content [::plugins::SDB::modify_shot_file $clock arr_changes 0 0]
	if { $content eq "" } return
	
	set ::plugins::visualizer_upload::settings(last_upload_shot) $clock
	set ::plugins::visualizer_upload::settings(last_upload_result) ""
	set ::plugins::visualizer_upload::settings(last_upload_id) ""
	
	set repo_link ""
	set visualizer_id [::plugins::visualizer_upload::upload $content]
	if { $visualizer_id ne "" } {
		regsub "<ID>" $::plugins::visualizer_upload::settings(visualizer_browse_url) $visualizer_id link 
		set repo_link "Visualizer $link"
		if { [string match "*$repo_link*" $content] != 1 } {
			set arr_changes(repository_links) $repo_link
			::plugins::SDB::modify_shot_file $clock arr_changes
		}
	}
	
	return $repo_link
}

# Adapted from skin_directory_graphics in utils.tcl 
proc ::plugins::DYE::plugin_directory_graphics {} {
	global screen_size_width
	global screen_size_height

	set plugindir "[plugin_directory]"

	set dir "$plugindir/DYE/${screen_size_width}x${screen_size_height}"

	if {[info exists ::rescale_images_x_ratio] == 1} {
		set dir "$plugindir/DYE/2560x1600"
	}
	
	return $dir
}

### "DESCRIBE YOUR ESPRESSO" PAGE #####################################################################################

namespace eval ::plugins::DYE::DE {
	variable widgets
	array set widgets {}
	
	# Widgets in the page bind to variables in this data array, not to the actual global variables behind, so they 
	# can be changed dynamically to load and save to different shots (last, next or those selected in the left or 
	# right of the history viewer). Values are actually saved only when tapping the "Done" button.
	variable data
	array set data {
		page_name "::plugins::DYE::DE"
		page_painted 0
		previous_page {}
		page_title {translate {Describe your espresso}}
		# next / current / past / DSx_past / DSx_past2
		describe_which_shot {current}
		read_from_status "last"
		read_from_last_text "Read from\rlast shot" 
		read_from_prev_text "Read from\rselection"
		read_from_label {}
		shot_file {}
		clock 0
		grinder_dose_weight 0
		drink_weight 0
		bean_brand {}
		bean_type {}
		roast_date {}
		roast_level {}
		bean_notes {}
		grinder_model {}
		grinder_setting {}
		drink_tds 0
		drink_ey 0
		espresso_enjoyment 0
		espresso_notes {}
		my_name {}
		drinker_name {}
		skin {}
		beverage_type {}
		upload_to_visualizer_label {}
		repository_links {}
	}
	#		other_equipment {}

	# src_data contains a copy of the source data when the page is loaded. So we can easily check whether something
	# has changed.
	variable src_data
	array set src_data {}
}

# 'which_shot' can be either a clock value matching a past shot clock, or any of 'current', 'next', 'DSx_past' or 
#	'DSx_past2'.
proc ::plugins::DYE::DE::load_page { which_shot } {
	variable data
	set ns [namespace current]
	
	if { [info exists ::settings(espresso_clock)] && $::settings(espresso_clock) ne "" && $::settings(espresso_clock) > 0} {
		set current_clock $::settings(espresso_clock)
	} else {	
		set current_clock 0
	}
	
	set data(describe_which_shot) $which_shot
	if { [string is integer $which_shot] && $which_shot > 0 } {
		if { $which_shot == $current_clock } {
			set data(describe_which_shot) "current"
		} else {
			set data(describe_which_shot) "past"
		}
		set data(clock) $which_shot
	} elseif { $which_shot eq "current" } { 
		if { $current_clock == 0 } {
			info_page [translate "Last shot is not available to describe"] [translate Ok]
			return
		} else {
			set data(clock) $current_clock
		}
	} elseif { $which_shot eq "next" } {
		set data(clock) {}
	} elseif { [string range $which_shot 0 2] eq "DSx" } {
		if { $::settings(skin) eq "DSx" } {
			set data(describe_which_shot) $which_shot
			if { $which_shot eq "DSx_past" } {
				if { [info exists ::DSx_settings(past_clock)] } {
					set data(clock) $::DSx_settings(past_clock)	
				} else {
					msg -ERROR "which_shot='$which_shot' but DSx_settings(past_clock) is undefined"
					info_page [translate "DSx History Viewer past shot is undefined"] [translate Ok]
					return						
				}
			} elseif { $which_shot eq "DSx_past2" } {
				if { [info exists ::DSx_settings(past_clock2)] } {
					set data(clock) $::DSx_settings(past_clock2)	
				} else {
					msg -ERROR "which_shot='$which_shot' but DSx_settings(past_clock2) is undefined"
					info_page [translate "DSx History Viewer past shot 2 is undefined"] [translate Ok]
					return
				}
			}
		} else {
			msg -ERROR "Can't use which shot '$which_shot' when not using the DSx skin"
			info_page [translate "Shot type '$which_shot' requires skin DSx"] [translate Ok]
			return
		}
	} else {
		msg -ERROR "Unrecognized value of which_shot: '$which_shot'"
		info_page "[translate {Unrecognized shot type to show in 'Describe Your Espresso'}]: '$which_shot'" [translate Ok]
		return
	}
	
	if { [load_description] == 0 } {
		info_page [translate "The requested shot description for '$which_shot' is not available"] [translate Ok]
		return
	}
	
	::plugins::DGUI::set_previous_page $ns
msg "DE, previous_page=$data(previous_page)"
	set ::current_espresso_page "off"
	page_to_show_when_off $ns
	
	if { ![ifexists data(page_painted) 0] } {
		::plugins::DGUI::relocate_dropdown_arrows ::plugins::DYE::DE::widgets "bean_brand bean_type roast_level \
			grinder_model grinder_setting my_name drinker_name"
		set data(page_painted) 1
	}
}

# This is added to the page context actions, so automatically executed every time (after) the page is shown.
proc ::plugins::DYE::DE::show_page {} {
	variable widgets
	variable data
	set ns [namespace current]

	::plugins::DGUI::enable_or_disable_widgets [expr {$data(describe_which_shot) ne "next"}] \
		"move_forward* move_to_next*" $ns
	if { $data(describe_which_shot) ne "next" } {
		set previous_shot [::plugins::SDB::previous_shot $data(clock)]
		::plugins::DGUI::enable_or_disable_widgets [expr {$previous_shot ne ""}] "move_backward*" $ns
	}
	
	if { $::plugins::DYE::settings(use_stars_to_rate_enjoyment) == 1 } {
		::plugins::DGUI::hide_widgets "espresso_enjoyment espresso_enjoyment_clicker*" $ns
		for { set i 1 } { $i <= 5 } { incr i } {
			.can itemconfig $widgets(espresso_enjoyment_rating$i) -state normal
			.can itemconfig $widgets(espresso_enjoyment_rating_half$i) -state hidden
		}
		::plugins::DGUI::show_widgets "espresso_enjoyment_rating_button" $ns
	} else {
		::plugins::DGUI::show_widgets "espresso_enjoyment espresso_enjoyment_clicker*" $ns
		
		for { set i 1 } { $i <= 5 } { incr i } {
			.can itemconfig $widgets(espresso_enjoyment_rating$i) -state hidden
			.can itemconfig $widgets(espresso_enjoyment_rating_half$i) -state hidden
		}
		::plugins::DGUI::hide_widgets "espresso_enjoyment_rating_button" $ns
	}

	if { $data(describe_which_shot) eq "next" } {
		::plugins::DGUI::disable_widgets "grinder_dose_weight* drink_weight* drink_tds* drink_ey* espresso_enjoyment* \
			espresso_enjoyment_rating*" $ns
	} else {
		::plugins::DGUI::enable_widgets "grinder_dose_weight* drink_weight* drink_tds* drink_ey* espresso_enjoyment*" $ns
		if { $::plugins::DYE::settings(use_stars_to_rate_enjoyment) == 1 } {
			::plugins::DGUI::enable_widgets "espresso_enjoyment_rating*" $ns
			::plugins::DGUI::draw_rating $ns espresso_enjoyment 5
		}
	}
	
	::plugins::DYE::DE::grinder_model_change
	::plugins::DYE::DE::update_visualizer_button 0
}
	
proc ::plugins::DYE::DE::unload_page {} {
	variable data

	if { $data(previous_page) eq "sleep" } {
		set_next_page off off
		set ::current_espresso_page "off"
		start_sleep				
	} elseif { $data(previous_page) ne "" } {
		page_to_show_when_off $data(previous_page)
	} else {
		page_to_show_when_off off
	}	
}
	
proc ::plugins::DYE::DE::setup_ui {} {
	variable data
	variable widgets
	set page [namespace current]
	set skin $::settings(skin)
	set img_dir [::plugins::DYE::plugin_directory_graphics]
	
	::plugins::DGUI::add_page $page -buttons_loc right 
	
	# LEFT COLUMN 
	set x_left_label 100; set x_left_field 400; set width_left_field 28; set x_left_down_arrow 990
	
	set y 35
	::plugins::DGUI::add_symbol $page $x_left_label $y backward -size small -has_button 1 \
		-button_cmd ::plugins::DYE::DE::move_backward -widget_name move_backward
	
	::plugins::DGUI::add_symbol $page [expr {$x_left_label+140}] $y search -size small -has_button 1 \
		-button_cmd ::plugins::DYE::DE::search_shot -widget_name search_shot
	
	::plugins::DGUI::add_symbol $page [expr {$x_left_label+280}] $y forward -size small -has_button 1 \
		-button_cmd ::plugins::DYE::DE::move_forward -widget_name move_forward
	
	::plugins::DGUI::add_symbol $page [expr {$x_left_label+420}] $y fast_forward -size small -has_button 1 \
		-button_cmd ::plugins::DYE::DE::move_to_next -widget_name move_to_next
	
	# BEANS DATA
	add_de1_image $page $x_left_label 150 "$img_dir/bean_${skin}.png"
	::plugins::DGUI::add_text $page $x_left_field 250 [translate "Beans"] -font_size $::plugins::DGUI::section_font_size 
	
	set x 570; set y 245
	::plugins::DGUI::add_symbol $page $x [expr {$y-4}] sort_down -size small
	add_de1_button $page ::plugins::DYE::DE::beans_select [expr {$x-200}] $y [expr {$x+60}] [expr {$y+75}]

	# Beans roaster / brand 
	set y 350
	::plugins::DGUI::add_select_entry $page bean_brand $x_left_label $y $x_left_field $y $width_left_field \
		-items [::plugins::SDB::available_categories bean_brand] 
	
	# Beans type/name
	incr y 100
	::plugins::DGUI::add_select_entry $page bean_type $x_left_label $y $x_left_field $y $width_left_field \
		-items [::plugins::SDB::available_categories bean_type]

	# Roast date
	incr y 100
	::plugins::DGUI::add_entry $page roast_date $x_left_label $y $x_left_field $y $width_left_field

	# Roast level
	incr y 100
	::plugins::DGUI::add_select_entry $page roast_level $x_left_label $y $x_left_field $y $width_left_field \
		-items [::plugins::SDB::available_categories roast_level]

	# Bean notes
	incr y 100
	::plugins::DGUI::add_multiline_entry $page bean_notes $x_left_label $y $x_left_field $y $width_left_field 3
	
	# EQUIPMENT
	set y 925

	add_de1_image $page $x_left_label $y "$img_dir/niche_${skin}.png"
	::plugins::DGUI::add_text $page $x_left_field [expr {$y+130}] [translate "Equipment"] \
		-font_size $::plugins::DGUI::section_font_size
		
	# Other equipment (EXPERIMENTAL)
	if { [info exists ::debugging] && $::debugging == 1 } {
		add_de1_button $page { say "" $::settings(sound_button_in); ::plugins::DYE::SEQ::load_page } \
			$x_left_label [expr {$y+50}] [expr {$x_left_field+400}] [expr {$y+200}]
	}
	
	# Grinder model
	incr y 240
	::plugins::DGUI::add_select_entry $page grinder_model $x_left_label $y $x_left_field $y $width_left_field \
		-items [::plugins::SDB::available_categories grinder_model] \
		-callback_cmd ::plugins::DYE::DE::select_grinder_model_callback
	
	# Grinder setting
	incr y 100
	::plugins::DGUI::add_select_entry $page grinder_setting $x_left_label $y $x_left_field $y $width_left_field \
		-select_cmd ::plugins::DYE::DE::grinder_setting_select 
	
	# EXTRACTION
	set x_right_label 1280; set x_right_field 1525
	add_de1_image $page $x_right_label 150 "$img_dir/espresso_${skin}.png"
	::plugins::DGUI::add_text $page 1550 250 [translate "Extraction"] -font_size $::plugins::DGUI::section_font_size

	# Calc EY from TDS button
	::plugins::DGUI::add_button2 $page calc_ey_from_tds 2000 125 [translate "Calc EY from TDS"] \
		{$::plugins::DYE::settings(calc_ey_from_tds)} "" ::plugins::DYE::DE::calc_ey_from_tds_click
	
	# Grinder Dose weight
	set y 350
	::plugins::DGUI::add_entry $page grinder_dose_weight $x_right_label $y $x_right_field $y 8
	bind $widgets(grinder_dose_weight) <FocusOut> ::plugins::DYE::DE::calc_ey_from_tds
	
	# Drink weight
	set offset 525
	::plugins::DGUI::add_entry $page drink_weight [expr {$x_right_label+$offset}] $y \
		[expr {$x_right_field+$offset}] $y 8
	bind $widgets(drink_weight) <FocusOut> ::plugins::DYE::DE::calc_ey_from_tds
	
	# Total Dissolved Solids
	set x_hclicker_field 2050
	incr y 100	
	::plugins::DGUI::add_entry $page drink_tds $x_right_label $y $x_hclicker_field $y 5 -clicker {} \
		-clicker_cmd ::plugins::DYE::DE::calc_ey_from_tds
	bind $widgets(drink_tds) <FocusOut> ::plugins::DYE::DE::calc_ey_from_tds

	# Extraction Yield
	incr y 100
	::plugins::DGUI::add_entry $page drink_ey $x_right_label $y $x_hclicker_field $y 5 -clicker {}
	
	# Enjoyment entry with horizontal clicker
	incr y 100
	::plugins::DGUI::add_entry $page espresso_enjoyment $x_right_label $y $x_hclicker_field $y 5 -clicker {}
	bind $widgets(espresso_enjoyment) <KeyPress> { if {[string is entier %K] != 1} break }
	
	# Enjoyment stars rating (on top of the enjoyment text entry + arrows, then dinamically one or the other is hidden
	#	when the page is shown, depending on the settings)
	::plugins::DGUI::add_rating $page espresso_enjoyment -1 -1 [expr {$x_hclicker_field-250}] $y 610
	
	# Espresso notes
	incr y 100
	::plugins::DGUI::add_multiline_entry $page espresso_notes $x_right_label $y $x_right_field $y 45 5

	# PEOPLE
	set y 1030
	add_de1_image $page $x_right_label $y "$img_dir/people_${skin}.png"
	::plugins::DGUI::add_text $page $x_right_field [expr {$y+140}] [translate "People"] \
		-font_size $::plugins::DGUI::section_font_size
		
	# Barista (my_name)
	incr y 240
	::plugins::DGUI::add_select_entry $page my_name $x_right_label $y $x_right_field $y 15 \
		-items [::plugins::SDB::available_categories my_name]
	
	# Drinker name
	::plugins::DGUI::add_select_entry $page drinker_name [expr {$x_right_label+700}] $y [expr {$x_right_field+600}] $y 15 \
		-items [::plugins::SDB::available_categories drinker_name]

	# BOTTOM BUTTONS	
	# Clear shot data (only clears "propagated" fields)
	set x 100; set y 1385
	::plugins::DGUI::add_button2 $page clear_shot_data $x $y [translate "Clear shot\rdata"] "" eraser \
		::plugins::DYE::DE::clear_shot_data_click	

	# Recover "propagated" fields from a previous shot
	set x [expr {$x+$::plugins::DGUI::button2_width+75}]
	set data(read_from_label) [translate $data(read_from_last_text)]
	::plugins::DGUI::add_button2 $page read_from $x $y "" "" file_import ::plugins::DYE::DE::read_from_click

	# Upload to Miha's Visualizer button
	set x [expr {$x+$::plugins::DGUI::button2_width+75}]
	set data(upload_to_visualizer_label) [translate "Upload to\rVisualizer"]
	::plugins::DGUI::add_button2 $page upload_to_visualizer $x $y "" "" file_upload \
		::plugins::DYE::DE::upload_to_visualizer_click
	
	::add_de1_action $page ${page}::show_page
}

proc ::plugins::DYE::DE::move_backward {} {
	variable data
	if { [ask_to_save_if_needed] eq "cancel" } return
	
	if { $data(describe_which_shot) eq "next" } {
		load_page current
		# show_page not invoked automatically when staying in the same page
		show_page
	} else {
		set previous_clock [::plugins::SDB::previous_shot $data(clock)]
		if { $previous_clock ne "" && $previous_clock > 0 } {
			load_page $previous_clock
			show_page
		}
	}
}

proc ::plugins::DYE::DE::move_forward {} {
	variable data
	if { $data(describe_which_shot) eq "next" } return
	if { [ask_to_save_if_needed] eq "cancel" } return
	
	if { $data(describe_which_shot) eq "last" || $data(clock) == $::settings(espresso_clock) } {
		load_page next
		# show_page not invoked automatically when staying in the same page
		show_page
	} else {
		set next_clock [::plugins::SDB::next_shot $data(clock)]
		if { $next_clock ne "" && $next_clock > 0} {
			load_page $next_clock
			show_page
		}
	}
}

proc ::plugins::DYE::DE::move_to_next {} {
	variable data
	if { $data(describe_which_shot) eq "next" } return	
	if { [ask_to_save_if_needed] eq "cancel" } return
	
	load_page next
	# show_page not invoked automatically when staying in the same page
	show_page
}

proc ::plugins::DYE::DE::search_shot {} {
	variable data
}


proc ::plugins::DYE::DE::beans_select {} {
	variable data
	say "" $::settings(sound_button_in)
	
	set selected [string trim "$data(bean_brand) $data(bean_type) $data(roast_date)"]
	regsub -all " +" $selected " " selected

	::plugins::DGUI::IS::load_page bean_desc "" "[::plugins::SDB::available_categories bean_desc]" \
		-callback_cmd ::plugins::DYE::DE::select_beans_callback -selected $selected
}

# Callback procedure returning control from the item_selection page to the describe_espresso page, to select the 
# full beans definition item from the list of previously entered values. 
proc ::plugins::DYE::DE::select_beans_callback { clock bean_desc item_type } {
	variable data
	page_to_show_when_off [namespace current]
		
	if { $bean_desc ne "" } {
		set db ::plugins::SDB::get_db
		db eval {SELECT bean_brand,bean_type,roast_date,roast_level,bean_notes FROM V_shot \
				WHERE clock=(SELECT MAX(clock) FROM V_shot WHERE bean_desc=$bean_desc)} {
			set data(bean_brand) $bean_brand
			set data(bean_type) $bean_type
			set data(roast_date) $roast_date
			set data(roast_level) $roast_level
			set data(bean_notes) $bean_notes
		}
	}
}

# Callback procedure returning control from the item_selection page to the describe_espresso page when a grinder
#	model is selected from the list. We need a callback proc, unlike with other fields, because we need to invoke
#	'grinder_model_change'.
proc ::plugins::DYE::DE::select_grinder_model_callback { id value type } {
	variable data
	page_to_show_when_off [namespace current]
	
	if { $value ne "" } {
		set data($type) $value
		if { $type eq "grinder_model" } ::plugins::DYE::DE::grinder_model_change
	}
}

proc ::plugins::DYE::DE::grinder_setting_select {} {
	variable data
	say "" $::settings(sound_button_in)
	if { $data(grinder_model) eq "" } return
	
	::plugins::DGUI::IS::load_page grinder_setting ::plugins::DYE::DE::data(grinder_setting) \
		[::plugins::SDB::available_categories grinder_setting \
		-filter " grinder_model=[::plugins::SDB::string2sql $data(grinder_model)]"]
}

proc ::plugins::DYE::DE::grinder_model_change {} {
	variable data
	if { $data(grinder_model) eq "" } {
		::plugins::DGUI::disable_widgets grinder_setting_dropdown* ::plugins::DYE::DE
	} else {
		::plugins::DGUI::enable_widgets grinder_setting_dropdown* ::plugins::DYE::DE
	}
}

proc ::plugins::DYE::DE::clear_shot_data_click {} {
	say "clear" $::settings(sound_button_in)
	foreach f $::plugins::DYE::propagated_fields {
		set ::plugins::DYE::DE::data($f) {}
	}
	set ::plugins::DYE::DE::data(espresso_notes) {}
#	if { $data(describe_which_shot) eq "next" } {
#		set ::plugins::DYE::settings(next_modified) 1
#	}
}

proc ::plugins::DYE::DE::read_from_click {} {
	variable data
	say "read" $::settings(sound_button_in)

	# Bring descriptive data from last shot (in-memory if editing the next description), if not using
	# the last shot use the DB to get it back.
	if { ![info exists data(clock) ]|| $data(clock) == 0 || $data(clock) eq {} } {			
		set filter "clock < [clock seconds]"
	} else {
		set filter "clock < $data(clock)"
	}
	set sql_conditions {}
	foreach f $::plugins::DYE::propagated_fields {
		lappend sql_conditions "LENGTH(TRIM(COALESCE($f,'')))>0"
	}
	
	if { $data(read_from_status) eq "prev" } {
		array set shots [::plugins::SDB::shots "clock shot_desc" 1 "$filter AND ([join $sql_conditions { OR }])" 500]
		::plugins::DGUI::IS::load_page shot "" $shots(shot_desc) -item_ids $shots(clock) \
			-callback_cmd ::plugins::DYE::DE::select_shot_callback 
		set data(read_from_status) "last"
	} else {
		array set last_shot [::plugins::SDB::shots "$::plugins::DYE::propagated_fields" 1 \
			"$filter AND ([join $sql_conditions { OR }])" 1]
		foreach f [array names last_shot] {
			set data($f) [lindex $last_shot($f) 0]
		}
				
		set data(read_from_status) "prev"
	}
	
	set data(read_from_label) [translate $data(read_from_${data(read_from_status)}_text)]
#	if { $data(describe_which_shot) eq "next" } {
#		set DYE::settings(next_modified) 1
#	}
}

# Callback procedure returning control from the item_selection page to the describe_espresso page, to select a 
# source shot to be used for next shot propagation values. 
proc ::plugins::DYE::DE::select_shot_callback { shot_clock shot_desc item_type } {
	variable data
	page_to_show_when_off [namespace current]
	
	if { $shot_clock ne "" } {
		array set shot [::plugins::SDB::shots "$::plugins::DYE::propagated_fields" 1 "clock=$shot_clock" 1]
		foreach f [array names shot] {
			set data($f) [lindex $shot($f) 0]
		}
	}
}

# Opens the last shot, the shot on the left of the history viewer, or the shot on the right of the history
# 	viewer, and writes all relevant DYE fields to the ::plugins::DYE::DE page variables.
# Returns 1 if successful, 0 otherwise.
proc ::plugins::DYE::DE::load_description {} {
	variable widgets
	variable data
	variable src_data
	
#	foreach f {grinder_dose_weight drink_weight drink_tds drink_ey espresso_enjoyment} {
#		$widgets(${f}) configure -state normal
#	}
	
	set data(read_from_label) [translate $data(read_from_${data(read_from_status)}_text)]
	
	if { $data(describe_which_shot) eq "DSx_past" } {
#		if { ! [info exists ::DSx_settings(past_clock)] } { return 0 }
#		set data(clock) $::DSx_settings(past_clock)
						
		set data(shot_file) $::DSx_settings(past_shot_file)
		set data(page_title) "Describe past espresso: $::DSx_settings(shot_date_time)"

		foreach f $::plugins::DYE::desc_text_fields {
			if { [info exists ::DSx_settings(past_$f)] } {
				set data($f) [string trim $::DSx_settings(past_$f)]
			} else {
				set data($f) {}
			}
		}
		foreach f $::plugins::DYE::desc_numeric_fields {
			if { [info exists ::DSx_settings(past_$f)] } {
				set data($f) [::plugins::DYE::return_blank_if_zero $::DSx_settings(past_$f)]
			} else {
				set data($f) {}
			}
		}
		
		# Bean and Drink weights past variable names don't follow the past_* naming convention, so we have to handle
		# them differently
		if { [return_zero_if_blank [ifexists ::DSx_settings(past_bean_weight) 0]] > 1 } {
			set data(grinder_dose_weight) $::DSx_settings(past_bean_weight)
		} else {
			set data(grinder_dose_weight) {}
		}
		
		if { [return_zero_if_blank [ifexists ::DSx_settings(drink_weight) 0]] > 1 } {
			set data(drink_weight) $::DSx_settings(drink_weight) 
#		} elseif { $::DSx_settings(past_final_desired_shot_weight) > 0 } {
#			set data(drink_weight) $::DSx_settings(past_final_desired_shot_weight)
		} else {
			set data(drink_weight) {}
		}

#		if { $data(drink_weight) eq "" && $::DSx_settings(past_final_desired_shot_weight) > 0 } {
#			set data(drink_weight) $::DSx_settings(past_final_desired_shot_weight)
#		}
	} elseif { $data(describe_which_shot) eq "DSx_past2" } {
#		if { ! [info exists ::DSx_settings(past_clock2)] } { return 0 }
#		set data(clock) $::DSx_settings(past_clock2)
		
		set data(shot_file) $::DSx_settings(past_shot_file2)
		set data(page_title) "Describe past espresso: $::DSx_settings(shot_date_time2)"
		
		foreach f $::plugins::DYE::desc_text_fields {
			if { [info exists ::DSx_settings(past_${f}2)] } {
				set data($f) [string trim $::DSx_settings(past_${f}2)]
			} else {
				set data($f) {}
			}
		}
		foreach f $::plugins::DYE::desc_numeric_fields {
			if { [info exists ::DSx_settings(past_${f}2)] } {
				set data($f) [::plugins::DYE::return_blank_if_zero $::DSx_settings(past_${f}2)]
			} else {
				set data($f) {}
			}
		}

		# Bean and Drink weights past variable names don't follow the past_* naming convention, so we have to handle
		# them differently
		if { [return_zero_if_blank [ifexists ::DSx_settings(past_bean_weight2) 0]] > 1 } {
			set data(grinder_dose_weight) $::DSx_settings(past_bean_weight2)
		} else {
			set data(grinder_dose_weight) {}
		}
		
		if { [return_zero_if_blank [ifexists ::DSx_settings(drink_weight2) 0]] > 1} {
			set data(drink_weight) $::DSx_settings(drink_weight2) 
#		} elseif { $::DSx_settings(past_final_desired_shot_weight2) > 0 } {
#			set data(drink_weight) $::DSx_settings(past_final_desired_shot_weight2)
		} else {
			set data(drink_weight) {}
		}
		
#		if { $data(drink_weight) eq "" && $::DSx_settings(past_final_desired_shot_weight) > 0 } {
#			set data(drink_weight) $::DSx_settings(past_final_desired_shot_weight)
#		}
		
	} elseif { $data(describe_which_shot) eq "next" } {
		#set data(clock) {}
		set data(shot_file) {}
		set data(page_title) "Describe your next espresso"

		foreach f {grinder_dose_weight drink_weight drink_tds drink_ey espresso_enjoyment} {
			set data($f) {}
#			$widgets($f) configure -state disabled
		}

#		foreach f {bean_brand bean_type roast_date roast_level bean_notes grinder_model grinder_setting \
#				other_equipment espresso_notes my_name drinker_name} 		
		foreach f {bean_brand bean_type roast_date roast_level bean_notes grinder_model grinder_setting \
				espresso_notes my_name drinker_name} {
			set data($f) [string trim $::plugins::DYE::settings(next_$f)]
		}
		
		set data(grinder_dose_weight) {}
		set data(drink_weight) {}
		set data(repository_links) {}
	} elseif { $data(describe_which_shot) eq "past" } {
		array set shot [::plugins::SDB::load_shot $data(clock)]
		if { [array size shot] == 0 } { return 0 }
		# What for?
		set data(shot_file) [::plugins::SDB::get_shot_file_path $data(clock)]
		set data(page_title) "Describe past espresso: [formatted_shot_date]"
		
		foreach f "$::plugins::DYE::desc_text_fields $::plugins::DYE::desc_numeric_fields" {
			set data($f) $shot($f) 
		}
		
	} elseif { $data(describe_which_shot) eq "current" } {
		#if { ! [info exists ::settings(espresso_clock)] } { return 0 }
		# Assume $data(describe_which_shot) eq "current"
		#set data(clock) $::settings(espresso_clock)
		
		set data(shot_file) [::plugins::SDB::get_shot_file_path $::settings(espresso_clock)]
		#"[homedir]/history/[clock format $::settings(espresso_clock) -format $::plugins::DYE::filename_clock_format].shot"
		set data(page_title) "Describe last espresso: [::plugins::DYE::DE::last_shot_date]"
		
		foreach f $::plugins::DYE::desc_text_fields {
			if { [info exists ::settings($f)] } {
				set data($f) [string trim $::settings($f)]
			} else {
				set data($f) {}
			}
		}		
		foreach f $::plugins::DYE::desc_numeric_fields {
			if { [info exists ::settings($f)] } {
				set data($f) [::plugins::DYE::return_blank_if_zero $::settings($f)]
			} else {
				set data($f) {}
			}
		}
		
	}
		
	array set src_data {}
	foreach fn "$::plugins::DYE::desc_numeric_fields $::plugins::DYE::desc_text_fields" {
		set src_data($fn) $data($fn)
	}
	
	return 1
}


# Saves the local variables from the Describe Espresso page into the target variables depending on which
#	description we're editing (last shot, left on the history viewer, or right in the history viewer),
#	and saves the modified data in the correct history .shot file.
proc ::plugins::DYE::DE::save_description {} {
	variable data
	variable src_data
	set needs_saving 0
	array set new_settings {}
	
	# $::settings(espresso_clock) may not be defined on a new install!
	set last_clock [ifexists ::settings(espresso_clock) 0]
	
	set is_past_edition_of_current 0
	if { $::settings(skin) eq "DSx" } {
		if { ($data(describe_which_shot) eq "DSx_past" && $::DSx_settings(past_clock) == $last_clock) || \
				($data(describe_which_shot) eq "DSx_past2" && $::DSx_settings(past_clock2) == $last_clock) } {
			set is_past_edition_of_current 1
		}
	}
	
	if { $::settings(skin) eq "DSx" && ($data(describe_which_shot) eq "DSx_past" || $data(describe_which_shot) eq "DSx_past2")} {
		if { $data(describe_which_shot) eq "DSx_past" || ($data(describe_which_shot) eq "DSx_past2" && \
				$::DSx_settings(past_clock) == $::DSx_settings(past_clock2)) } {
			set clock $::DSx_settings(past_clock) 
			foreach f $::plugins::DYE::desc_numeric_fields {
				if { ![info exists ::DSx_settings(past_$f)] || $::DSx_settings(past_$f) ne [return_zero_if_blank $data($f)] } {
					set ::DSx_settings(past_$f) [return_zero_if_blank $data($f)]
					set new_settings($f) [return_zero_if_blank $data($f)] 
					set needs_saving 1
					
					# These two don't follow the above var naming convention
					# These two don't follow the above var naming convention
					if { $f eq "grinder_dose_weight" && [return_zero_if_blank $data($f)] > 0 } {
						set ::DSx_settings(past_bean_weight) [round_to_one_digits $data(grinder_dose_weight)]
					}
					if { $f eq "drink_weight" && [return_zero_if_blank $data($f)] > 0 } {
						set ::DSx_settings(drink_weight) [round_to_one_digits $data(drink_weight)]
					}
				}
			}
			foreach f $::plugins::DYE::desc_text_fields {
				if { ![info exists ::DSx_settings(past_$f)] || $::DSx_settings(past_$f) ne $data($f) } {
					set ::DSx_settings(past_$f) [string trim $data($f)]
					set new_settings($f) $data($f)
					set needs_saving 1
				}
			}

			if { $needs_saving == 1 } { 
				::plugins::DYE::define_past_shot_desc 
				if { $::DSx_settings(past_clock) == $::DSx_settings(past_clock2) } {
					::plugins::DYE::define_past_shot_desc2
				}
				::save_DSx_settings
			}
		} 
		
		if { $data(describe_which_shot) eq "DSx_past2" || ($data(describe_which_shot) eq "DSx_past" && \
				$::DSx_settings(past_clock) == $::DSx_settings(past_clock2)) } {
			set clock $::DSx_settings(past_clock2) 
			foreach f $::plugins::DYE::desc_numeric_fields {
				if { ![info exists ::DSx_settings(past_${f}2)] || \
						$::DSx_settings(past_${f}2) ne [return_zero_if_blank $data($f)] } {
					set ::DSx_settings(past_${f}2) [return_zero_if_blank $data($f)]
					set new_settings($f) [return_zero_if_blank $data($f)]
					set needs_saving 1
					
					# These two don't follow the above var naming convention
					if { $f eq "grinder_dose_weight" && [return_zero_if_blank $data($f)] > 0 } {
						set ::DSx_settings(past_bean_weight2) [round_to_one_digits $data(grinder_dose_weight)]
					}
					if { $f eq "drink_weight" && [return_zero_if_blank $data($f)] > 0 } {
						set ::DSx_settings(drink_weight2) [round_to_one_digits $data(drink_weight)]
					}
				}
			}
			foreach f $::plugins::DYE::desc_text_fields {
				if { ![info exists ::DSx_settings(past_${f}2)] || $::DSx_settings(past_${f}2) ne $data($f) } {
					set ::DSx_settings(past_${f}2) $data($f)
					set new_settings($f) [string trim $data($f)]
					set needs_saving 1					
				}				
			}

			if { $needs_saving == 1 } { 
				::plugins::DYE::define_past_shot_desc2 
				if { $::DSx_settings(past_clock) == $::DSx_settings(past_clock2) } {
					::plugins::DYE::define_past_shot_desc
				}
			}
		}

		if { $needs_saving == 0 } { return }

		if { $is_past_edition_of_current == 0 } {
			::plugins::SDB::modify_shot_file $data(shot_file) new_settings
			
			if { $::plugins::SDB::settings(db_persist_desc) == 1 } {
				set new_settings(file_modification_date) [file mtime $data(shot_file)]
				::plugins::SDB::update_shot_description $clock new_settings
			}
			
			::save_DSx_settings
			msg "DYE: Save past espresso to history"
		}
	} 
	
	if { $data(describe_which_shot) eq "current" || $is_past_edition_of_current == 1 } {
		foreach f $::plugins::DYE::desc_numeric_fields {
			if { ![info exists ::settings($f)] || $::settings($f) ne [return_zero_if_blank $data($f)] } {
				set ::settings($f) [return_zero_if_blank $data($f)]
				set new_settings($f) [return_zero_if_blank $data($f)]
				set needs_saving 1
			}			
		}
		foreach f $::plugins::DYE::desc_text_fields {
			if { ![info exists ::settings($f)] || $::settings($f) ne $data($f) } {
				set ::settings($f) [string trim $data($f)]
				set new_settings($f) [string trim $data($f)]
				set needs_saving 1

				if { $::plugins::DYE::settings(next_modified) == 0 && [lsearch $::plugins::DYE::propagated_fields $f] > -1 && \
						$::plugins::DYE::settings(propagate_previous_shot_desc) == 1 } {
					set ::plugins::DYE::settings(next_$f) [string trim $data($f)]
				}
			}
		}

		set needs_save_DSx_settings 0
		if { $::settings(skin) eq "DSx" } {
			if { [return_zero_if_blank $data(grinder_dose_weight)] > 0 && \
					[ifexists ::DSx_settings(live_graph_beans) {}] ne $data(grinder_dose_weight)} {
				set ::DSx_settings(live_graph_beans) [round_to_one_digits $data(grinder_dose_weight)]
				set needs_save_DSx_settings 1
			}
			if { [return_zero_if_blank $data(drink_weight)] > 0 && \
					[ifexists ::DSx_settings(live_graph_weight) {}] ne $data(drink_weight) } {
				set ::DSx_settings(live_graph_weight) [round_to_one_digits $data(drink_weight)]
				set needs_save_DSx_settings 1
			}
		}
		
#		# TBD THIS IS TO UPDATE THE TEXT WITH THE WEIGHTS AND RATIOS BELOW THE LAST SHOT CHART IN THE MAIN PAGE,
#		# 	BUT THE TEXT IS NOT BEING UPDATED, UNLIKE IN THE HISTORY VIEWER.
#		if { [return_zero_if_blank $data(grinder_dose_weight)] > 0 && \
#				$data(grinder_dose_weight) != $::settings(DSx_bean_weight) } {
#			set ::settings(DSx_bean_weight) [round_to_one_digits $data(grinder_dose_weight)]
#		}
		
		if { $needs_save_DSx_settings } {
			::save_DSx_settings
		}
		if { $needs_saving == 1 } {
			::save_settings
			plugins save_settings DYE
			::plugins::SDB::modify_shot_file $data(shot_file) new_settings
			if { $::plugins::SDB::settings(db_persist_desc) == 1 } {
				set new_settings(file_modification_date) [file mtime $data(shot_file)]
				::plugins::SDB::update_shot_description $data(clock) new_settings
			}
			# OLD (before v1.11), wrongly stored profile changes for next shot made after making the shot but before editing last shot description.
			#::save_espresso_rating_to_history
			::plugins::DYE::define_last_shot_desc
			::plugins::DYE::define_next_shot_desc
		}
	
	} elseif { $data(describe_which_shot) eq "past" } {
		foreach f $::plugins::DYE::desc_numeric_fields {
			if { [return_zero_if_blank $data($f)] ne [return_zero_if_blank $src_data($f)] } {
				set new_settings($f) [return_zero_if_blank $data($f)]
				set needs_saving 1
			}			
		}
		foreach f $::plugins::DYE::desc_text_fields {
			if { $data($f) ne $src_data($f) } {
				set new_settings($f) [string trim $data($f)]
				set needs_saving 1
			}
		}
		
		if { $needs_saving } {
			::plugins::SDB::modify_shot_file $data(shot_file) new_settings
			if { $::plugins::SDB::settings(db_persist_desc) == 1 } {
				set new_settings(file_modification_date) [file mtime $data(shot_file)]
				::plugins::SDB::update_shot_description $data(clock) new_settings
			}
		}
	} elseif { $data(describe_which_shot) eq "next" } {
#		foreach f {bean_brand bean_type roast_date roast_level bean_notes grinder_model grinder_setting \
#				other_equipment espresso_notes my_name drinker_name} 		
		foreach f {bean_brand bean_type roast_date roast_level bean_notes grinder_model grinder_setting \
				espresso_notes my_name drinker_name} {
			if { $::plugins::DYE::settings(next_$f) ne $data($f) } {
				set ::plugins::DYE::settings(next_$f) [string trim $data($f)]
				set needs_saving 1
			}			
		}

		if { $needs_saving == 1 } {
			set ::plugins::DYE::settings(next_modified) 1
			::plugins::DYE::define_next_shot_desc
			plugins save_settings DYE
		}		
	}
}

# A clone of DSx last_shot_date, but uses settings(espresso_clock) if DSx_settings(live_graph_time) is not
# available (e.g. if DSx_settings.tdb were manually removed). Also will allow future skin-independence.
proc ::plugins::DYE::DE::last_shot_date {} {
	if { [info exists ::DSx_settings(live_graph_time)] } {
		return [::last_shot_date]
	} elseif { [info exists ::settings(espresso_clock)] } {
		set last_shot_clock $::settings(espresso_clock)
		set date [clock format $last_shot_clock -format {%a %d %b}]
		if {$::settings(enable_ampm) == 0} {
			set a [clock format $last_shot_clock -format {%H}]
			set b [clock format $last_shot_clock -format {:%M}]
			set c $a
		} else {
			set a [clock format $last_shot_clock -format {%I}]
			set b [clock format $last_shot_clock -format {:%M}]
			set c $a
			regsub {^[0]} $c {\1} c
		}
		if {[ifexists ::settings(enable_ampm) 1] == 1} {
			set pm [clock format $last_shot_clock -format %P]
		} else {
			set pm ""
		}
		return "$date $c$b$pm"
	} else {
		return ""
	}
}

# Adapted from Damian's DSx last_shot_date. 
proc ::plugins::DYE::DE::formatted_shot_date {} {
	variable data
	set shot_clock $data(clock)
	if { $shot_clock eq "" || $shot_clock <= 0 } {
		return ""
	}
	
	set date [clock format $shot_clock -format {%a %d %b}]
	if { [ifexists ::settings(enable_ampm) 0] == 0} {
		set a [clock format $shot_clock -format {%H}]
		set b [clock format $shot_clock -format {:%M}]
		set c $a
	} else {
		set a [clock format $shot_clock -format {%I}]
		set b [clock format $shot_clock -format {:%M}]
		set c $a
		regsub {^[0]} $c {\1} c
	}
	if { $::settings(enable_ampm) == 1 } {
		set pm [clock format $shot_clock -format %P]
	} else {
		set pm ""
	}
	return "$date $c$b$pm"
}

# Return 1 if some data has changed in the form.
proc ::plugins::DYE::DE::needs_saving { } {
	variable data
	variable src_data
	
	foreach fn $::plugins::DYE::desc_text_fields {
		if { $data($fn) ne $src_data($fn) } {
			return 1
		}
	}	
	foreach fn $::plugins::DYE::desc_numeric_fields {
		if { [return_zero_if_blank $data($fn)] != [return_zero_if_blank $src_data($fn)] } {
			return 1
		}
	}
	return 0
}

proc ::plugins::DYE::DE::calc_ey_from_tds_click {} {
	say "" $::settings(sound_button_in)
	if { $::plugins::DYE::settings(calc_ey_from_tds) eq "on" } {
		set ::plugins::DYE::settings(calc_ey_from_tds) off
	} else { 
		set ::plugins::DYE::settings(calc_ey_from_tds) on 
		::plugins::DYE::DE::calc_ey_from_tds
	}		
}

# Calculates the Extraction Yield % to be shown in the Describe Espresso page from the user-entered
# Total Dissolved Solids %, the dose and the drink weight. Uses standard formula.
proc ::plugins::DYE::DE::calc_ey_from_tds  {} {
	variable data 
	
	if { $::plugins::DYE::settings(calc_ey_from_tds) eq "on" } {		
		if { $data(drink_weight) > 0 && $data(grinder_dose_weight) > 0 && $data(drink_tds) > 0 } {
			set data(drink_ey) [round_to_two_digits [expr {$data(drink_weight) * $data(drink_tds) / \
				$data(grinder_dose_weight)}]]
		} else {
			set data(drink_ey) {}
		}
	}
}

proc ::plugins::DYE::DE::upload_to_visualizer_click {} {
	variable data
	variable widgets

#	if { $::plugins::DYE::DE::data(repository_links) ne {} } {
#		say [translate "browsing"] $::settings(sound_button_in)
#		if { [llength $::plugins::DYE::DE::data(repository_links)] > 1 } {
#			web_browser [lindex $::plugins::DYE::DE::data(repository_links) 1]
#		}
#		return
#	}
	
	say "" $::settings(sound_button_in)
	if { $::android == 1 && [borg networkinfo] eq "none" } {
		set data(upload_to_visualizer_label) [translate "Failed\rNo wifi"]
#		set ::plugins::DYE::settings(last_visualizer_result) "[translate {Upload failed}]: [translate {No wifi}]" 
		.can itemconfig $widgets(upload_to_visualizer_label) -fill ::plugins::DGUI::remark_color
		update
		after 3000 { ::plugins::DYE::DE::update_visualizer_button }
		say "" $::settings(sound_button_out)
		return
	}
	
	# Ensure latest values are in the shot file in case they have changed
	if { [::plugins::DYE::DE::needs_saving] } {
		set answer [ask_to_save_if_needed]
		if { $answer eq "cancel" } return
	}
		
	set data(upload_to_visualizer_label) [translate "Uploading..."]
	.can itemconfig $widgets(upload_to_visualizer_label) -fill $::plugins::DGUI::remark_color
	update
	
	set repo_link [::plugins::DYE::upload_to_visualizer_and_save $::plugins::DYE::DE::data(clock)]
	
	if { $repo_link eq "" } {
		set data(upload_to_visualizer_label) [translate "Upload\rfailed"]
		update
		after 3000 ::plugins::DYE::DE::update_visualizer_button
	} else {
		set data(upload_to_visualizer_label) [translate "Upload\rsuccessful"]
		if { $data(repository_links) eq "" } { 
			set data(repository_links) $repo_link
		} elseif { $data(repository_links) ne $repo_link } {
			lappend data(repository_links) $repo_link
		}
		
		update
		after 3000 ::plugins::DYE::DE::update_visualizer_button
	}
	say "" $::settings(sound_button_out)
}

proc ::plugins::DYE::DE::update_visualizer_button { {check_context 1} } {
	variable data
	variable widgets
	set page [namespace current]
	if { $check_context == 1 && $::de1(current_context) ne $page } {
		msg "WARNING: WRONG context in update_visualizer_button='$::de1(current_context)'"	
		return
	}

	if { $data(describe_which_shot) ne "next" && [plugins enabled visualizer_upload] &&
			$::plugins::visualizer_upload::settings(visualizer_username) ne "" && 
			$::plugins::visualizer_upload::settings(visualizer_password) ne "" } {
		.can itemconfig $widgets(upload_to_visualizer_label) -fill $::plugins::DGUI::button_font_fill
		::plugins::DGUI::show_widgets "upload_to_visualizer*" $page
#		foreach wn {_symbol _label _img ""} {
#			.can itemconfig $widgets(upload_to_visualizer$wn) -state normal
#		}
		if { $data(repository_links) eq {} } {
			#.can itemconfig $::plugins::DYE::DE::widgets(upload_to_visualizer_symbol) -text $::plugins::DGUI::symbols(file_upload)
			set data(upload_to_visualizer_label) [translate "Upload to\rVisualizer"]
		} else {
			set data(upload_to_visualizer_label) [translate "Re-upload to\rVisualizer"]
		}
#		else {
#			.can itemconfig $::plugins::DYE::DE::widgets(upload_to_visualizer_symbol) -text $::plugins::DGUI::symbols(file_contract)
#			set ::plugins::DYE::DE::data(upload_to_visualizer_label) [translate "See in\rVisualizer"]
#		}
	} else {
		::plugins::DGUI::hide_widgets "upload_to_visualizer*" $page
#		foreach wn {_symbol _label _img ""} {
#			.can itemconfig $widgets(upload_to_visualizer$wn) -state hidden
#		}		
	}
}

proc ::plugins::DYE::DE::ask_to_save_if_needed {} {
	if { [needs_saving] == 1 } {
		set answer [tk_messageBox -message "[translate {You have unsaved changes to the shot description.}]\r\
			[translate {Do you want to save your changes first?}]" \
			-type yesnocancel -icon question]
		if { $answer eq "yes" } { 
			::plugins::DYE::DE::save_description
		} 
		return $answer 
	} else {
		return "yes"
	}
}

proc ::plugins::DYE::DE::page_cancel {} {
	set answer [ask_to_save_if_needed]
	if { $answer eq "cancel" } return
	
	say [translate {cancel}] $::settings(sound_button_in);
	unload_page
}

proc ::plugins::DYE::DE::page_done {} {
	say [translate {done}] $::settings(sound_button_in)
	# BEWARE: If we don't fully qualify this call, call [info args $pname] in stacktrace, as invoked from 
	#	save_settings, fails.
	::plugins::DYE::DE::save_description
	unload_page
}

### "FILTER SHOT HISTORY" PAGE #########################################################################################

namespace eval ::plugins::DYE::FSH {
	variable widgets
	array set widgets {}
	
	variable data
	array set data {
		page_name "::plugins::DYE::FSH"
		page_painted 0
		page_title "Filter Shot History"
		category1 {profile_tile}
		categories1_label {}
		category2 {beans}
		categories2_label {}
		left_filter_status {off}
		right_filter_status {off}
		left_filter_shots {}
		right_filter_shots {}
		matched_shots {}
		n_matched_shots_text {}
		date_from {}
		date_to {}
		ey_from {}
		ey_to {}
		ey_max 0
		tds_from {}
		tds_to {}
		tds_max 0
		enjoyment_from {}
		enjoyment_to {}
		enjoyment_max 0
		order_by_date "Date"
		order_by_tds "TDS"
		order_by_ey "EY"
		order_by_enjoyment "Enjoyment"
	}
}

# Prepare the DYE_filter_shot_history page.
proc ::plugins::DYE::FSH::load_page { {category1 profile_title} {category2 bean_desc} } {
	variable widgets
	variable data
	set ns [namespace current]
	
	set data(category1) $category1
	set data(category2) $category2
	set_order_by date

	page_to_show_when_off $ns
	
	if { ![ifexists data(page_painted) 0] } {
		::plugins::DGUI::ensure_size $widgets(categories1) -width 500 -height 560
		::plugins::DGUI::ensure_size $widgets(categories2) -width 500 -height 560
		::plugins::DGUI::ensure_size $widgets(shots) -width 2375 -height 350
		::plugins::DGUI::set_scrollbars_dims $ns "categories1 categories2 shots"
		::plugins::DGUI::relocate_text_wrt $widgets(reset_categories1) $widgets(categories1_scrollbar) ne 0 -12 se \
			$widgets(reset_categories1_button)
		::plugins::DGUI::relocate_text_wrt $widgets(reset_categories2) $widgets(categories2_scrollbar) ne 0 -12 se \
			$widgets(reset_categories2_button)
		set data(page_painted) 1
	}
}

proc ::plugins::DYE::FSH::show_page {} {
	variable data
	variable widgets
	set page [namespace current]
	category1_change $data(category1)
	category2_change $data(category2)
	
	if { $::plugins::DYE::settings(use_stars_to_rate_enjoyment) == 1 } {
		.can itemconfig $widgets(enjoyment_from) -state hidden
		.can itemconfig $widgets(enjoyment_to_label) -state hidden
		.can itemconfig $widgets(enjoyment_to) -state hidden
		for { set i 1 } { $i <= 5 } { incr i } {
			.can itemconfig $widgets(enjoyment_from_rating$i) -state normal
			.can itemconfig $widgets(enjoyment_from_rating_half$i) -state normal
			.can itemconfig $widgets(enjoyment_to_rating$i) -state normal
			.can itemconfig $widgets(enjoyment_to_rating_half$i) -state normal
		}
		.can itemconfig $widgets(enjoyment_to_rating_label) -state normal
		.can itemconfig $widgets(enjoyment_from_rating_button) -state normal
		.can itemconfig $widgets(enjoyment_to_rating_button) -state normal
		
		::plugins::DGUI::draw_rating $page espresso_enjoyment -widget_name enjoyment_from
		::plugins::DGUI::draw_rating $page espresso_enjoyment -widget_name enjoyment_to
	} else {
		.can itemconfig $widgets(enjoyment_from) -state normal
		.can itemconfig $widgets(enjoyment_to_label) -state normal
		.can itemconfig $widgets(enjoyment_to) -state normal
		for { set i 1 } { $i <= 5 } { incr i } {
			.can itemconfig $widgets(enjoyment_from_rating$i) -state hidden
			.can itemconfig $widgets(enjoyment_from_rating_half$i) -state hidden
			.can itemconfig $widgets(enjoyment_to_rating$i) -state hidden
			.can itemconfig $widgets(enjoyment_to_rating_half$i) -state hidden
		}
		.can itemconfig $widgets(enjoyment_to_rating_label) -state hidden
		.can itemconfig $widgets(enjoyment_from_rating_button) -state hidden
		.can itemconfig $widgets(enjoyment_to_rating_button) -state hidden	
	}	
}

# Setup the "Search Shot History" page User Interface.
proc ::plugins::DYE::FSH::setup_ui {} {
	variable widgets
	variable data
	set page [namespace current]
	
	# -title [translate "Filter Shot History"] 
	::plugins::DGUI::add_page $page -cancel_button 0 -buttons_loc center
	
	# Categories1 listbox
	set x_left 60; set y 120
	::plugins::DGUI::add_listbox $page categories1 $x_left $y $x_left [expr {$y+80}] 25 10 \
		-label_font_size $::plugins::DGUI::section_font_size -selectmode multiple
	
	::plugins::DGUI::add_symbol $page [expr {$x_left+300}] [expr {$y+0}] sort_down -size small \
		-widget_name categories1_label_dropdown
	set "${page}::widgets(categories1_label_dropdown_button)" [::add_de1_button $page \
		::plugins::DYE::FSH::category1_dropdown_click [expr {$x_left}] $y [expr {$x_left+420}] [expr {$y+68}] ]
	
	# Reset categories1
	::plugins::DGUI::add_text $page [expr {$x_left+340}] [expr {$y+15}] "\[ [translate "Reset"] \]" \
		-widget_name reset_categories1 -fill $::plugins::DGUI::remark_color -has_button 1 \
		-button_cmd ::plugins::DYE::FSH::reset_categories1_click -button_width 150
	
	# Categories2 listbox
	set x_left2 700
	::plugins::DGUI::add_listbox $page categories2 700 $y $x_left2 [expr {$y+80}] 25 10 \
		-label_font_size $::plugins::DGUI::section_font_size -selectmode multiple

	::plugins::DGUI::add_symbol $page [expr {$x_left2+300}] [expr {$y+0}] sort_down -size small \
		-widget_name categories2_label_dropdown	
	set "${page}::widgets(categories2_label_dropdown_button)" [::add_de1_button $page \
		::plugins::DYE::FSH::category2_dropdown_click [expr {$x_left2}] $y [expr {$x_left2+420}] [expr {$y+68}] ]
	
	# Reset categories2
	::plugins::DGUI::add_text $page [expr {$x_left2+340}] [expr {$y+15}] "\[ [translate "Reset"] \]" \
		-widget_name reset_categories2 -fill $::plugins::DGUI::remark_color -has_button 1 \
		-button_cmd ::plugins::DYE::FSH::reset_categories2_click -button_width 150
	
	# Date period from
	set x_right_label 1450; set x_right_widget 1725; set y 200
	::plugins::DGUI::add_entry $page date_from $x_right_label $y $x_right_widget $y 11 -label [translate "Date from"] \
		-data_type date
	bind $widgets(date_from) <FocusOut> ::plugins::DYE::FSH::date_from_leave	
	# Date period to	
	::plugins::DGUI::add_entry $page date_to 1975 $y 2025 $y 11 -label [translate "to"] -data_type date
	bind $widgets(date_to) <FocusOut> ::plugins::DYE::FSH::date_to_leave
	
	# TDS from
	::plugins::DGUI::add_entry $page drink_tds $x_right_label [incr y 100] $x_right_widget $y 6 \
		-label [translate "TDS % from"] -widget_name tds_from
	# TDS to
	::plugins::DGUI::add_entry $page drink_tds 1875 $y 1925 $y 6 -label [translate "to"] -widget_name tds_to
	
	# EY from
	::plugins::DGUI::add_entry $page drink_ey $x_right_label [incr y 100] $x_right_widget $y 6 \
		-label [translate "EY % from"] -widget_name ey_from	
	# EY to
	::plugins::DGUI::add_entry $page drink_ey 1875 $y 1925 $y 6 -label [translate "to"] -widget_name ey_to
		
	# Enjoyment from
	::plugins::DGUI::add_entry $page espresso_enjoyment 1450 500 1725 500 6 -widget_name "enjoyment_from" \
		-label [translate "Enjoyment from"]	
	# Enjoyment to
	::plugins::DGUI::add_entry $page espresso_enjoyment 1875 500 1925 500 6 -widget_name "enjoyment_to" \
		-label [translate "to"]
	
	# Enjoyment stars rating from/to
	::plugins::DGUI::add_rating $page espresso_enjoyment -1 -1 1725 500 600 -widget_name "enjoyment_from"
	::plugins::DGUI::add_rating $page espresso_enjoyment 1650 575 1725 575 600 -widget_name "enjoyment_to" -label "to"

	# Order by
	::plugins::DGUI::add_text $page $x_right_label 690 [translate "Order by"] \
		-font [::plugins::DGUI::get_font $::plugins::DGUI::font 9]

	set x $x_right_widget; set y 720
	::plugins::DGUI::add_variable $page $x $y {$::plugins::DYE::FSH::data(order_by_date)} -anchor center -justify center \
		-has_button 1 -button_width 140 -button_cmd { say "" $::settings(sound_button_in); ::plugins::DYE::FSH::set_order_by date } 
	::plugins::DGUI::add_variable $page [incr x 175] $y {$::plugins::DYE::FSH::data(order_by_tds)} -anchor center -justify center \
		-has_button 1 -button_width 100 -button_cmd { say "" $::settings(sound_button_in); ::plugins::DYE::FSH::set_order_by tds } 
	::plugins::DGUI::add_variable $page [incr x 150] $y {$::plugins::DYE::FSH::data(order_by_ey)} -anchor center -justify center \
		-has_button 1 -button_width 100 -button_cmd { say "" $::settings(sound_button_in); ::plugins::DYE::FSH::set_order_by ey } 
	::plugins::DGUI::add_variable $page [incr x 200] $y {$::plugins::DYE::FSH::data(order_by_enjoyment)} -anchor center -justify center \
		-has_button 1 -button_width 130 -button_cmd { say "" $::settings(sound_button_in); ::plugins::DYE::FSH::set_order_by enjoyment } 
	
	# Reset button
	set y 825
	::plugins::DGUI::add_button1 $page reset $x_left $y [translate Reset] ::plugins::DYE::FSH::reset_click

	# Search button
	::plugins::DGUI::add_button1 $page search 2200 $y [translate Search] ::plugins::DYE::FSH::search_shot_history

	# Number of search matches
	set data(n_matched_shots_text) [translate "No shots"]
	::plugins::DGUI::add_variable $page 2150 900 {$::plugins::DYE::FSH::data(n_matched_shots_text)} \
		-font_size $::plugins::DGUI::section_font_size -anchor "ne" -justify "right" -width [rescale_x_skin 800]
	
	# Search results showing matching shots
	::plugins::DGUI::add_listbox $page shots -1 -1 $x_left 975 115 7 
	
	# Button "Apply to left history"
	set y 1375
	::plugins::DGUI::add_button2 $page apply_to_left_side $x_left $y "[translate {Apply to}]\n[translate {left side}]" \
		{$::plugins::DYE::FSH::data(left_filter_status)} filter ::plugins::DYE::FSH::apply_to_left_side_click
	
	# Button "Apply to right history"
	::plugins::DGUI::add_button2 $page apply_to_right_side 2050 $y "[translate {Apply to}]\n[translate {right side}]" \
		{$::plugins::DYE::FSH::data(right_filter_status)} filter ::plugins::DYE::FSH::apply_to_right_side_click
	
	::add_de1_action $page ${page}::show_page
}

proc ::plugins::DYE::FSH::category1_dropdown_click { } {
	variable data
	#set cats [::plugins::DGUI::field_names category]
	set cats {}
	foreach cat [array names ::plugins::DGUI::data_dictionary ] {
		lassign [::plugins::DGUI::field_lookup $cat "data_type name"] data_type cat_name
		if { $data_type eq "category" && $cat ne $data(category2) } {
			lappend cats "[list $cat "$cat_name"]" 
		}
	}

	set item_ids {}
	set items {}	
	set cats [lsort -dictionary -index 1 $cats]
	foreach cat $cats {
		lappend item_ids [lindex $cat 0]
		lappend items [lindex $cat 1]
	}
	
	say "select" $::settings(sound_button_in)
	::plugins::DGUI::IS::load_page categories ::plugins::DYE::FSH::data(categories1_label) $items \
		-item_ids $item_ids -page_title [translate "Select a category"] \
		-callback_cmd ::plugins::DYE::FSH::select_category1_callback  
}

proc ::plugins::DYE::FSH::category1_change { new_category } {
	variable data
	variable widgets
#	if { $data(category1) eq $new_category } return
		
	set data(category1) {}
	if { $new_category ne "" } {
		lassign [::plugins::DGUI::field_lookup $new_category "name data_type"] cat_name data_type
		if { $cat_name eq "" } {
			msg "DYE: ERROR on FSH::load_page, category1='$new_category' not found"
			return
		}
		if { $data_type ne "category" } {
			msg "DYE: ERROR on FSH::load_page, field '$new_category' is not a category"
			return
		}
		set data(category1) $new_category
		set data(categories1_label) [translate $cat_name]
		update
	}
	
	after 300 ::plugins::DGUI::relocate_text_wrt $widgets(categories1_label_dropdown) $widgets(categories1_label) e 12 -6 w
	fill_categories1_listbox
}

proc ::plugins::DYE::FSH::fill_categories1_listbox {} {
	variable data
	variable widgets

	$widgets(categories1) delete 0 end
	if { $data(category1) ne "" } {
		set cat_values [::plugins::SDB::available_categories $data(category1)]
		$widgets(categories1) insert 0 {*}$cat_values
	}
}

proc ::plugins::DYE::FSH::reset_categories1_click {} {
	variable widgets
	say [translate {reset}] $::settings(sound_button_in)
	$widgets(categories1) selection clear 0 end
}

proc ::plugins::DYE::FSH::select_category1_callback { category category_name type } {
	variable data
	set data(category1) $category
	page_to_show_when_off [namespace current]	
#	category1_change $category
}

proc ::plugins::DYE::FSH::category2_dropdown_click { } {
	variable data
	#set cats [::plugins::DGUI::field_names category]
	set cats {}
	foreach cat [array names ::plugins::DGUI::data_dictionary ] {
		lassign [::plugins::DGUI::field_lookup $cat "data_type name"] data_type cat_name
		if { $data_type eq "category" && $cat ne $data(category1) } {
			lappend cats "[list $cat "$cat_name"]" 
		}
	}

	set item_ids {}
	set items {}	
	set cats [lsort -dictionary -index 1 $cats]
	foreach cat $cats {
		lappend item_ids [lindex $cat 0]
		lappend items [lindex $cat 1]
	}
	
	say "select" $::settings(sound_button_in)
	::plugins::DGUI::IS::load_page categories ::plugins::DYE::FSH::data(categories2_label) $items \
		-item_ids $item_ids -page_title [translate "Select a category"] \
		-callback_cmd ::plugins::DYE::FSH::select_category2_callback  
}
	
proc ::plugins::DYE::FSH::category2_change { new_category } {
	variable data
	variable widgets
#	if { $data(category2) eq $new_category } return
		
	set data(category2) {}
	if { $new_category ne "" } {
		lassign [::plugins::DGUI::field_lookup $new_category "name data_type"] cat_name data_type
		if { $cat_name eq "" } {
			msg "DYE: ERROR on FSH::load_page, category2='$new_category' not found"
			return
		}
		if { $data_type ne "category" } {
			msg "DYE: ERROR on FSH::load_page, field '$new_category' is not a category"
			return			
		}
		set data(category2) $new_category
		set data(categories2_label) [translate $cat_name]
		update
	}

	after 300 ::plugins::DGUI::relocate_text_wrt $widgets(categories2_label_dropdown) $widgets(categories2_label) e 12 -6 w	
	fill_categories2_listbox	
}

proc ::plugins::DYE::FSH::fill_categories2_listbox {} {
	variable widgets
	variable data
	
	$widgets(categories2) delete 0 end
	if { $data(category2) ne "" } {
		set cat_values [::plugins::SDB::available_categories $data(category2)]
		$widgets(categories2) insert 0 {*}$cat_values
	}
}

proc ::plugins::DYE::FSH::reset_categories2_click {} {
	variable widgets
	say [translate {reset}] $::settings(sound_button_in)
	$widgets(categories2) selection clear 0 end
}

proc ::plugins::DYE::FSH::select_category2_callback { category category_name type } {
	variable data
	set data(category2) $category		
	page_to_show_when_off [namespace current]
#	category2_change $category	
}

proc ::plugins::DYE::FSH::date_from_leave {} {
	variable widgets
	variable data
	if { $data(date_from) eq ""} {
		$widgets(date_from) configure -bg $::plugins::DGUI::bg_color
	} elseif { [regexp {^([0-9][0-9]*/)*([0-9][0-9]*/)*[0-9]{4}$} $data(date_from)] == 0 } {
		$widgets(date_from) configure -bg $::plugins::DGUI::remark_color
	} else {
		$widgets(date_from)  configure -bg $::plugins::DGUI::bg_color
		
		if { [regexp {^[0-9]{4}$} $data(date_from)] == 1 } {
			set data(date_from) "1/1/$data(date_from)" 
		} elseif { [regexp {^[0-9][0-9]*/[0-9]{4}$} $data(date_from)] == 1 } {
			set data(date_from) "1/$data(date_from)"
		}	
#				set ::DYE_debug_text "Entered '$::plugins::DYE::FSH::data(date_from)'"
#				if { [catch {clock scan $::plugins::DYE::FSH::data(date_from) -format $::plugins::DYE::settings{date_format} -timezone :UTC}] } {
#					%W configure -bg $::DSx_settings(orange)
#				} else {
#					%W configure -bg $::DSx_settings(bg_colour)
#				}			
	}
	hide_android_keyboard	
}

proc ::plugins::DYE::FSH::date_to_leave {} {
	variable widgets
	variable data
	if { $data(date_to) eq ""} {
		$widgets(date_to) configure -bg $::plugins::DGUI::bg_color			
	} elseif { [regexp {^([0-9][0-9]*/)*([0-9][0-9]*/)*[0-9]{4}$} $::plugins::DYE::FSH::data(date_to)] == 0 } {
		$widgets(date_to) configure -bg $::plugins::DGUI::remark_color
	} else {
		$widgets(date_to) configure -bg $::plugins::DGUI::bg_color
		
		if { $::plugins::DYE::settings(date_format) eq "%d/%m/%Y" } {
			if { [regexp {^[0-9]{4}$} $data(date_to)] == 1 } {
				set data(date_to) "31/12/$data(date_to)" 
			} elseif { [regexp {^[0-9][0-9]*/[0-9]{4}$} $data(date_from)] == 1 } {
				set data(date_to) "31/$data(date_to)"
			}
		} elseif { $::plugins::DYE::settings(date_format) eq "%m/%d/%Y" }  {
			if { [regexp {^[0-9]{4}$} $data(date_to)] == 1 } {
				set data(date_to) "12/31/$data(date_to)" 
			}					
		}
			
	}
	hide_android_keyboard 
}

proc ::plugins::DYE::FSH::set_order_by { field } {
	variable data
	set data(order_by_date) "[translate Date]"
	set data(order_by_tds) "[translate TDS]"
	set data(order_by_ey) "[translate EY]"
	set data(order_by_enjoyment) "[translate Enjoyment]"
	
	set data(order_by_$field) "\[ $data(order_by_$field) \]"	
}

proc ::plugins::DYE::FSH::reset_click {} {
	variable data
	variable widgets	
	say [translate {reset}] $::settings(sound_button_in)
	set page [namespace current]
	
	$widgets(categories1) selection clear 0 end
	$widgets(categories2) selection clear 0 end
	set data(date_from) {}
	set data(date_to) {}
	set data(tds_from) {}
	set data(tds_to) {}
	set data(ey_from) {}
	set data(ey_to) {}
	set data(enjoyment_from) {}	
	set data(enjoyment_to) {}
	if { $::plugins::DYE::settings(use_stars_to_rate_enjoyment) == 1 } {
		::plugins::DGUI::draw_rating $page "" -widget_name enjoyment_from
		::plugins::DGUI::draw_rating $page "" -widget_name enjoyment_to
	}
	set_order_by date	
	$widgets(shots) delete 0 end
	set data(matched_shots) {}
	set data(n_matched_shots_text) "[translate {No matching shots}]"
}

# Runs the specified search in the shot history and show the results in the shots listbox.
# ::DSx_filtered_past_shot_files
proc ::plugins::DYE::FSH::search_shot_history {} {
	variable widgets
	variable data
	say [translate {search}] $::settings(sound_button_in)
	
	# Build the SQL SELECT statement
	set where_conds {}
	
	set c1_values [::plugins::DGUI::listbox_get_selection $widgets(categories1)]
	if { $c1_values ne "" } {
		lappend where_conds "$data(category1) IN ([::plugins::SDB::strings2sql $c1_values])"
	}
#	set c1_widget $widgets(categories1)
#	if {[$c1_widget curselection] ne ""} {
#		set c1_values {}
#		foreach idx [$c1_widget curselection] {
#			lappend c1_values [$c1_widget get $idx]
#		}
#		lappend where_conds "$data(category1) IN ([::plugins::SDB::strings2sql $c1_values])"
#	}

	set c2_values [::plugins::DGUI::listbox_get_selection $widgets(categories2)]
	if { $c2_values ne "" } {
		lappend where_conds "$data(category2) IN ([::plugins::SDB::strings2sql $c2_values])"
	}
#	set c2_widget $widgets(categories2)
#	if {[$c2_widget curselection] ne ""} {
#		set c2_values {}
#		foreach idx [$c2_widget curselection] {
#			lappend c2_values [$c2_widget get $idx]
#		}
#		lappend where_conds "bean_desc IN ([::plugins::SDB::strings2sql $beans])"
#	}
	
	if { $data(date_from) ne "" } {
		set from_clock [clock scan "$data(date_from) 00:00:00" -format "$::plugins::DYE::settings(date_format) %H:%M:%S"]
		lappend where_conds "clock>=$from_clock"
	}	
	if { $data(date_to) ne "" } {
		set to_clock [clock scan "$data(date_to) 23:59:59" -format "$::plugins::DYE::settings(date_format) %H:%M:%S"]
		lappend where_conds "clock<=$to_clock"
	}

	if { $data(tds_from) ne "" } {
		lappend where_conds "LENGTH(drink_tds)>0 AND drink_tds>=$data(tds_from)"
	}	
	if { $data(tds_to) ne "" } {
		lappend where_conds "LENGTH(drink_tds)>0 AND drink_tds<=$data(tds_to)"
	}
	
	if { $data(ey_from) ne "" } {
		lappend where_conds "LENGTH(drink_ey)>0 AND drink_ey>=$data(ey_from)"
	}	
	if { $data(ey_to) ne "" } {
		lappend where_conds "LENGTH(drink_ey)>0 AND drink_ey<=$data(ey_to)"
	}

	if { $data(enjoyment_from) ne "" } {
		lappend where_conds "LENGTH(espresso_enjoyment)>0 AND espresso_enjoyment>=$data(enjoyment_from)"
	}	
	if { $data(enjoyment_to) ne "" && $data(enjoyment_to) > 0 } {
		lappend where_conds "LENGTH(espresso_enjoyment)>0 AND espresso_enjoyment<=$data(enjoyment_to)"
	}
	
	set sql "SELECT filename, shot_desc FROM V_shot WHERE removed=0 "
	if {[llength $where_conds] > 0} { 
		append sql "AND [join $where_conds " AND "] "
	}
	
	if { [string first "\[" $data(order_by_enjoyment)] >= 0 } {
		append sql {ORDER BY espresso_enjoyment DESC, clock DESC}
	} elseif { [string first "\[" $data(order_by_ey)] >= 0 } {
		append sql {ORDER BY drink_ey DESC, clock DESC}
	} elseif { [string first "\[" $data(order_by_tds)] >= 0 } {
		append sql {ORDER BY drink_tds DESC, clock DESC}
	} else {
		append sql {ORDER BY clock DESC}
	}
		
	# Run the search
	set data(matched_shots) {}
	set cnt 0
	$widgets(shots) delete 0 end	
	
	set db ::plugins::SDB::get_db
	msg "DYE: $sql"
	db eval "$sql" {
		lappend data(matched_shots) $filename "$filename.shot"
		$widgets(shots) insert $cnt $shot_desc
		
		# TODO Move this line to the select for left side button.
		if { $cnt == 0 } { set ::DSx_settings(DSx_past_espresso_name) $filename }
			
		incr cnt
	}
	
	set data(n_matched_shots) $cnt
	if { $cnt == 0 } {
		set data(n_matched_shots_text) "[translate {No matching shots}]"
	} elseif { $cnt == 1 } {
		set data(n_matched_shots_text) "$cnt [translate {matching shot}]"
	} else {		
		set data(n_matched_shots_text) "$cnt [translate {matching shots}]"
	}
}

proc ::plugins::DYE::FSH::apply_to_left_side_click {} {
	variable data
	say [translate {filter}] $::settings(sound_button_in)
	if {$data(left_filter_status) eq "off"} {
		if {[llength $data(matched_shots)] > 0} {
			# Ensure the files still exist on disk, otherwise don't include them
			set ::DSx_filtered_past_shot_files {} 
			for { set i 0 } { $i < [llength $data(matched_shots)] } { incr i 2 } {
				set fn [lindex $data(matched_shots) $i]
				if { [file exists "[homedir]/history/${fn}.shot"] } {
					lappend ::DSx_filtered_past_shot_files $fn
					lappend ::DSx_filtered_past_shot_files "${fn}.shot"
				} elseif { [file exists "[homedir]/history_archive/${fn}.shot"] } {
					lappend ::DSx_filtered_past_shot_files $fn
					lappend ::DSx_filtered_past_shot_files "${fn}.shot"
				}
			}				
			#set ::DSx_filtered_past_shot_files $data(matched_shots)
			set data(left_filter_status) "on"
		}
	} else {
		set data(left_filter_status) "off"
		unset -nocomplain ::DSx_filtered_past_shot_files
	}	
}

proc ::plugins::DYE::FSH::apply_to_right_side_click {} {
	variable data
	say [translate {filter}] $::settings(sound_button_in)
	
	if {$data(right_filter_status) eq "off"} {
		if {[llength $data(matched_shots)] > 0} {
			# Ensure the files still exist on disk, otherwise don't include them
			set ::DSx_filtered_past_shot_files2 {} 
			for { set i 0 } { $i < [llength $data(matched_shots)] } { incr i 2 } {
				set fn [lindex $data(matched_shots) $i]
				if { [file exists "[homedir]/history/${fn}.shot"] } {
					lappend ::DSx_filtered_past_shot_files2 $fn
					lappend ::DSx_filtered_past_shot_files2 "${fn}.shot"
				} elseif { [file exists "[homedir]/history_archive/${fn}.shot"] } {
					lappend ::DSx_filtered_past_shot_files2 $fn
					lappend ::DSx_filtered_past_shot_files2 "${fn}.shot"
				}
			}				
			#set ::DSx_filtered_past_shot_files2 $data(matched_shots)
			set data(right_filter_status) "on"
		}
	} else {
		set data(right_filter_status) "off"
		unset -nocomplain ::DSx_filtered_past_shot_files
	}
}

proc ::plugins::DYE::FSH::page_done {} {
	say [translate {save}] $::settings(sound_button_in)
	page_to_show_when_off DSx_past
	
	if {$::plugins::DYE::FSH::data(left_filter_status) eq "on"} {
		fill_DSx_past_shots_listbox
	}
	if {$::plugins::DYE::FSH::data(right_filter_status) eq "on"} {
		fill_DSx_past2_shots_listbox
	}
}

	
### "SHORTCUTS MENU" PAGE #############################################################################################
### STILL EXPERIMENTAL, USED ONLY WHILE DEBUGGING 

namespace eval ::plugins::DYE::MENU {
	# State variables for the "DYE_menu" page. Not persisted. 
	variable widgets
	array set widgets {}
	# affected_shots_slider 1
	
	variable data
	array set data {
		page_name "::plugins::DYE::MENU"
		previous_page {}
		page_title {}
		previous_page {}
	}
}

# Prepare and launch the DYE_modify_category page.
proc ::plugins::DYE::MENU::load_page { } {	
	variable data
	variable widgets
	set ns [namespace current]
	
	::plugins::DGUI::set_previous_page $ns
	page_to_show_when_off $ns	
		
	hide_android_keyboard
}

proc ::plugins::DYE::MENU::setup_ui {} {
	variable data
	variable widgets
	set page [namespace current]

	add_de1_image $page 0 0 "[skin_directory_graphics]/background/bg2.jpg"

	::plugins::DGUI::add_text $page 650 100 [translate "Menu"] -widget_name page_title \
		-font_size $::plugins::DGUI::header_font_size -fill $::plugins::DGUI::page_title_color -anchor "center" 

	# Close menu
	::plugins::DGUI::add_symbol $page 1200	60 window_close -widget_name close_page -has_button 1 \
		-button_cmd ::plugins::DYE::MENU::page_done

	# DYE shortcuts
	set x 100; set y 200
	
	::plugins::DGUI::add_text $page $x $y [translate "Edit equipment types"] -widget_name edit_equipment -has_button 1 \
		-button_width 400 -button_cmd {say "" $::settings(sound_button_in); ::plugins::DYE::MODC::load_page equipment_type}

	::plugins::DGUI::add_text $page $x [incr y 80] [translate "Filter shot history"] -widget_name fsh -has_button 1 \
		-button_width 400 -button_cmd {say "" $::settings(sound_button_in); ::plugins::DYE::FSH::load_page}

	::plugins::DGUI::add_text $page $x [incr y 80] [translate "Numbers editor"] -widget_name edit_number -has_button 1 \
		-button_width 400 -button_cmd {say "" $::settings(sound_button_in); ::plugins::DYE::NUME::load_page drink_tds }
	
	set x 800; set y 200
	
	::plugins::DGUI::add_text $page $x $y [translate "DYE settings"] -widget_name edit_equipment -has_button 1 \
		-button_width 400 -button_cmd {say "" $::settings(sound_button_in); ::plugins::DYE::CFG::load_page}
	
}

proc ::plugins::DYE::MENU::page_done {} {
	variable data
	page_to_show_when_off $data(previous_page)
}

### "CONFIGURATION SETTINGS" PAGE ######################################################################################

namespace eval ::plugins::DYE::CFG {
	variable widgets
	array set widgets {}
	
	variable data
	array set data {
		page_name "::plugins::DYE::CFG"
		db_status_msg {}
		update_plugin_state {-}
		latest_plugin_version {}
		latest_plugin_url {}
		latest_plugin_desc {}
		update_plugin_msg {}
		plugin_has_been_updated 0
	}
}

# Normally not used as this is not invoked directly but by the DSx settings pages carousel, but still kept for 
# consistency or for launching the page from a menu.
proc ::plugins::DYE::CFG::load_page {} {
	page_to_show_when_off [namespace current]
}

# Added to context actions, so invoked automatically whenever the page is loaded
proc ::plugins::DYE::CFG::show_page {} {
	update_plugin_state	
}

# Setup the "DYE_configuration" page User Interface.
proc ::plugins::DYE::CFG::setup_ui {} {
	variable widgets
	set page [namespace current]

	# HEADERS
	::plugins::DGUI::add_page $page -add_bg_img 0 -title "Describe Your Espresso Settings" \
		-cancel_button 0 -buttons_loc center
		
	set y 180
	::plugins::DGUI::add_text $page 600 $y [translate "General options"] -font_size $::plugins::DGUI::section_font_size \
		-anchor "center" -justify "center" 	
#	::plugins::DGUI::add_text $page 1900 $y [translate "Database"] -font_size $::plugins::DGUI::section_font_size \
#		-anchor "center" -justify "center"	
	
	# LEFT SIDE
	set x_label 100; incr y 70
	::plugins::DGUI::add_checkbox $page ::plugins::DYE::settings(show_shot_desc_on_home) $x_label $y \
		::plugins::DYE::CFG::show_shot_desc_on_home_change -use_page_var 0 \
		-widget_name show_shot_desc_on_home \
		-label [translate "Show next & last shot description summaries on DSx home page"]
		
	incr y 80
	::plugins::DGUI::add_checkbox $page ::plugins::DYE::settings(propagate_previous_shot_desc) $x_label $y \
		::plugins::DYE::CFG::propagate_previous_shot_desc_change -use_page_var 0 \
		-widget_name propagate_previous_shot_desc \
		-label [translate "Propagate Beans, Equipment & People from last to next shot"]

	incr y 80
	::plugins::DGUI::add_checkbox $page ::plugins::DYE::settings(describe_from_sleep) $x_label $y \
		::plugins::DYE::CFG::describe_from_sleep_change -use_page_var 0 \
		-widget_name describe_from_sleep \
		-label [translate "Icon on screensaver to describe last shot without waking up DE1"]

	incr y 80
	::plugins::DGUI::add_checkbox $page ::plugins::DYE::settings(backup_modified_shot_files) $x_label $y \
		::plugins::DYE::CFG::backup_modified_shot_files_change -use_page_var 0 \
		-widget_name backup_modified_shot_files \
		-label [translate "Backup past shot files when they are modified (.bak)"]
	
	incr y 80
	::plugins::DGUI::add_checkbox $page ::plugins::DYE::settings(use_stars_to_rate_enjoyment) $x_label $y \
		{plugins save_settings DYE} -use_page_var 0 \
		-widget_name use_stars_to_rate_enjoyment \
		-label [translate "Use 1-5 stars rating to evaluate enjoyment"]
			
	incr y 125
	::plugins::DGUI::add_button2 $page shot_desc_font_color $x_label $y [translate "Shots\rsummaries\rcolor"] \
		"" paintbrush ::plugins::DYE::CFG::shot_desc_font_color_change -symbol_fill $::plugins::DYE::settings(shot_desc_font_color)
	incr y [expr {$::plugins::DGUI::button2_height+35}]
	::plugins::DGUI::add_text $page [expr {$x_label+$::plugins::DGUI::button2_width/2}] $y "\[ [translate {Use default color}] \]" \
		-anchor center -justify center -fill $::plugins::DYE::default_shot_desc_font_color
	::add_de1_button $page ::plugins::DYE::CFG::set_default_shot_desc_font_color $x_label [expr {$y-20}] \
		[expr {$x_label+$::plugins::DGUI::button2_width}] [expr {$y+50}]
	
	::add_de1_action $page ::plugins::DYE::CFG::show_page	
}

proc ::plugins::DYE::CFG::show_shot_desc_on_home_change {} {	
	::plugins::DYE::define_last_shot_desc
	::plugins::DYE::define_next_shot_desc
	plugins save_settings DYE
}

proc ::plugins::DYE::CFG::propagate_previous_shot_desc_change {} {
	if { $::plugins::DYE::settings(propagate_previous_shot_desc) == 1 } {
		if { $::plugins::DYE::settings(next_modified) == 0 } {
			foreach field_name $::plugins::DYE::propagated_fields {
				set ::plugins::DYE::settings(next_$field_name) $::settings($field_name)
			}
			set ::plugins::DYE::settings(next_espresso_notes) {}
		}
	} else {
		if { $::plugins::DYE::settings(next_modified) == 0 } {
			foreach field_name "$::plugins::DYE::propagated_fields next_espresso_notes" {
				set ::plugins::DYE::settings(next_$field_name) {}
			}			
		}
	}
	
	::plugins::DYE::define_next_shot_desc
	plugins save_settings DYE
}
	
proc ::plugins::DYE::CFG::describe_from_sleep_change {} {
	if { [info exists ::plugins::DYE::widgets(describe_from_sleep_symbol)] } {
		if { $::plugins::DYE::settings(describe_from_sleep) == 1 } {
			.can itemconfig $::plugins::DYE::widgets(describe_from_sleep_symbol) \
				-text $::plugins::DYE::settings(describe_icon)
			.can coords $::plugins::DYE::widgets(describe_from_sleep_button) [rescale_x_skin 230] [rescale_y_skin 0] \
				[rescale_x_skin 460] [rescale_y_skin 230]
		} else {
			.can itemconfig $::plugins::DYE::widgets(describe_from_sleep_symbol) -text ""
			.can coords $::plugins::DYE::widgets(describe_from_sleep_button) 0 0 0 0
		}
	}
	plugins save_settings DYE
}
	
proc ::plugins::DYE::CFG::backup_modified_shot_files_change {} {	
	plugins save_settings DYE
}

proc ::plugins::DYE::CFG::shot_desc_font_color_change {} {
	say "" $::settings(sound_button_in)	
	set colour [tk_chooseColor -initialcolor $::plugins::DYE::settings(shot_desc_font_color) \
		-title [translate "Set shot summary descriptions color"]]
	if {$colour != {}} {
		if { $::settings(skin) eq "DSx" } {
			foreach fn "DSx_home_next_shot_desc DSx_home_last_shot_desc DSx_past_shot_desc DSx_past_shot_desc2 \
					DSx_past_zoomed_shot_desc DSx_past_zoomed_shot_desc2" {
				.can itemconfigure $::plugins::DGUI::widgets($fn) -fill $colour
			}
			.can itemconfigure $::plugins::DYE::CFG::widgets(shot_desc_font_color_symbol) -fill $colour
		}
	
		set ::plugins::DYE::settings(shot_desc_font_color) $colour
		plugins save_settings DYE
	}	
}

proc ::plugins::DYE::CFG::set_default_shot_desc_font_color {} {
	say "" $::settings(sound_button_in)
	set colour $::plugins::DYE::default_shot_desc_font_color
	
	if { $::settings(skin) eq "DSx" } {
		foreach fn "DSx_home_next_shot_desc DSx_home_last_shot_desc DSx_past_shot_desc DSx_past_shot_desc2 \
				DSx_past_zoomed_shot_desc DSx_past_zoomed_shot_desc2" {
			.can itemconfigure $::plugins::DGUI::widgets($fn) -fill $colour
		}
		.can itemconfigure $::plugins::DYE::CFG::widgets(shot_desc_font_color_symbol) -fill $colour
	}

	set ::plugins::DYE::settings(shot_desc_font_color) $colour
	plugins save_settings DYE
}

proc ::plugins::DYE::CFG::show_or_hide_visualizer_pwd {} {
	variable widgets
	
	if { [$widgets(visualizer_password) cget -show] eq "*" } {
		$widgets(visualizer_password) configure -show ""
	} else {
		$widgets(visualizer_password) configure -show "*"
	}
}

proc ::plugins::DYE::CFG::update_plugin_state {} {
	variable data
	variable widgets
	
	::plugins::DGUI::enable_or_disable_widgets [expr !$data(plugin_has_been_updated)] update_plugin* [namespace current]
	if { $data(plugin_has_been_updated) == 1 } return
	
	.can itemconfig $widgets(update_plugin_state) -fill $::plugins::DGUI::font_color
	set data(update_plugin_msg) ""
	
	if { [ifexists ::plugins::DYE::settings(github_latest_url) "" ] eq "" } {
		set data(update_plugin_state) [translate "No update URL"]
	} elseif { $::android == 1 && [borg networkinfo] eq "none" } {
		set data(update_plugin_state) [translate "No wifi"]		
	} else {
		lassign [::plugins::DYE::github_latest_release $::plugins::DYE::settings(github_latest_url)] \
			data(latest_plugin_version) data(latest_plugin_url) data(latest_plugin_desc)
		
#msg "DYE PLUGIN UPDATE - Comparing [lindex [package versions describe_your_espresso] 0] and $data(latest_plugin_version)"		
		if { $data(latest_plugin_version) == -1 } {
			set data(update_plugin_state) [translate "Error"]
			set data(update_plugin_msg) $data(latest_plugin_desc)
		} elseif { [package vcompare [lindex [package versions describe_your_espresso] 0] \
				$data(latest_plugin_version) ] >= 0 } {
			set data(update_plugin_state) [translate "Up-to-date"]
		} else {
			set data(update_plugin_state) "v$data(latest_plugin_version) [translate available]"
			.can itemconfig $widgets(update_plugin_state) -fill $::plugins::DGUI::remark_color
			if { $data(latest_plugin_desc) ne "" } {
				set data(update_plugin_msg) "\[ [translate {What's new?}] \]"
			}
		}
	}
}

proc ::plugins::DYE::CFG::show_latest_plugin_description {} {
	variable data
	
	if { $data(latest_plugin_version) eq "" || $data(latest_plugin_version) == -1 || \
			$data(latest_plugin_desc) eq "" } return
	if { [package vcompare [lindex [package versions describe_your_espresso] 0] \
		$data(latest_plugin_version) ] >= 0 } return 
	
	::plugins::DYE::TXT::load_page "latest_plugin_desc" ::plugins::DYE::CFG::data(latest_plugin_desc) 1 \
		-page_title "[translate {What's new in DYE v}]$data(latest_plugin_version)"
}

proc ::plugins::DYE::CFG::update_plugin_click {} {
	variable data
	
	if { $data(latest_plugin_version) eq "" || $data(latest_plugin_version) == -1 } update_plugin_state
	if { $data(latest_plugin_version) eq "" || $data(latest_plugin_version) == -1 || \
			$data(latest_plugin_url) eq "" } return
	
	if { [package vcompare [lindex [package versions describe_your_espresso] 0] \
		$data(latest_plugin_version) ] >= 0 } return

	set update_result [::plugins::DYE::update_DSx_plugin_from_github $::plugins::DYE::plugin_file $data(latest_plugin_url)]
	if { $update_result == 1 } {
		set data(update_plugin_msg) "[translate {Plugin updated to v}]$data(latest_plugin_version)\r
[translate {Please quit and restart to load changes}]"
		set data(update_plugin_state) [translate "Up-to-date"]
		set data(plugin_has_been_updated) 1		
		update_plugin_state
		#set ::app_has_updated 1
	} else {
		set data(update_plugin_msg) [translate "Error downloading update"]
		set data(update_plugin_state) [translate "Error"]
	}
}

proc ::plugins::DYE::CFG::page_done {} {
	say [translate {Done}] $::settings(sound_button_in)
	fill_extensions_listbox
	page_to_show_when_off extensions
	set_extensions_scrollbar_dimensions
}

### GLOBAL STUFF AND STARTUP  #########################################################################################

# Ensure new metadata fields are initialized on the global settings on first use.
# This fails to create them for the first time if the code is on check_settings...
#foreach fn "drinker_name repository_links other_equipment"
foreach fn "drinker_name repository_links" {
	if { ! [info exists ::settings($fn)] } {
		set ::settings($fn) {}
	}
}
