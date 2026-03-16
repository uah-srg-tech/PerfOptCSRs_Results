#*****************************************************************************************
# Vivado (TM) v2022.2 (64-bit)
#
# PerfOptCSRs_ORmux_Directive.tcl: Tcl script for re-creating project 'PerfOptCSRs'
#
# This file contains the Vivado Tcl commands for re-creating the project to the state*
# when this script was generated. In order to re-create the project, please source this
# file in the Vivado Tcl Shell.
#
# * Note that the runs in the created project will be configured the same way as the
#   original project, however they will not be launched automatically. To regenerate the
#   run results please launch the synthesis/implementation runs as needed.
#
#*****************************************************************************************
#
#*****************************************************************************************

# Check file required for this script exists
proc checkRequiredFiles { origin_dir} {
  set status true
  set files [list \
 "[file normalize "$origin_dir/../src/sources/ip/clk_wiz_2/clk_wiz_2b.xci"]"\
 "[file normalize "$origin_dir/../src/sources/imports/constants.vhd"]"\
 "[file normalize "$origin_dir/../src/sources/imports/interfaces.vhd"]"\
 "[file normalize "$origin_dir/../src/sources/imports/GPRs.vhd"]"\
 "[file normalize "$origin_dir/../src/sources/imports/R_EX_MEM.vhd"]"\
 "[file normalize "$origin_dir/../src/sources/imports/R_ID_EX.vhd"]"\
 "[file normalize "$origin_dir/../src/sources/imports/R_MEM_WB.vhd"]"\
 "[file normalize "$origin_dir/../src/sources/imports/decode.vhd"]"\
 "[file normalize "$origin_dir/../src/sources/imports/instTB.vhd"]"\
 "[file normalize "$origin_dir/../src/sources/imports/CSRegs.vhd"]"\
 "[file normalize "$origin_dir/../src/sources/imports/procIFace.vhd"]"\
 "[file normalize "$origin_dir/../src/sources/imports/toplevel.vhd"]"\
 "[file normalize "$origin_dir/../src/constraints/constraints.xdc"]"\
# "[file normalize "$origin_dir/../src/sim/toplevel_tb.vhd"]"\
# "[file normalize "$origin_dir/../src/sim/toplevel_tb_behav.wcfg"]"\
 "[file normalize "$origin_dir/../src/utils/toplevel_postroute_physopt.dcp"]"\
  ]
  foreach ifile $files {
    if { ![file isfile $ifile] } {
      puts " Could not find local file $ifile "
      set status false
    }
  }

  return $status
}
# Set the reference directory for source file relative paths (by default the value is script directory path)
set origin_dir "."

# Use origin directory path location variable, if specified in the tcl shell
if { [info exists ::origin_dir_loc] } {
  set origin_dir $::origin_dir_loc
}

# Set the project name
set _xil_proj_name_ "Vivado-ORmux_Directive"

# Use project name variable, if specified in the tcl shell
if { [info exists ::user_project_name] } {
  set _xil_proj_name_ $::user_project_name
}

variable script_file
set script_file "PerfOptCSRs_ORmux_Directive.tcl"

# Help information for this script
proc print_help {} {
  variable script_file
  puts "\nDescription:"
  puts "Recreate a Vivado project from this script. The created project will be"
  puts "functionally equivalent to the original project for which this script was"
  puts "generated. The script contains commands for creating a project, filesets,"
  puts "runs, adding/importing sources and setting properties on various objects.\n"
  puts "Syntax:"
  puts "$script_file"
  puts "$script_file -tclargs \[--origin_dir <path>\]"
  puts "$script_file -tclargs \[--project_name <name>\]"
  puts "$script_file -tclargs \[--help\]\n"
  puts "Usage:"
  puts "Name                   Description"
  puts "-------------------------------------------------------------------------"
  puts "\[--origin_dir <path>\]  Determine source file paths wrt this path. Default"
  puts "                       origin_dir path value is \".\", otherwise, the value"
  puts "                       that was set with the \"-paths_relative_to\" switch"
  puts "                       when this script was generated.\n"
  puts "\[--project_name <name>\] Create project with the specified name. Default"
  puts "                       name is the name of the project from where this"
  puts "                       script was generated.\n"
  puts "\[--help\]               Print help information for this script"
  puts "-------------------------------------------------------------------------\n"
  exit 0
}

if { $::argc > 0 } {
  for {set i 0} {$i < $::argc} {incr i} {
    set option [string trim [lindex $::argv $i]]
    switch -regexp -- $option {
      "--origin_dir"   { incr i; set origin_dir [lindex $::argv $i] }
      "--project_name" { incr i; set _xil_proj_name_ [lindex $::argv $i] }
      "--help"         { print_help }
      default {
        if { [regexp {^-} $option] } {
          puts "ERROR: Unknown option '$option' specified, please type '$script_file -tclargs --help' for usage info.\n"
          return 1
        }
      }
    }
  }
}

# Set the directory path for the original project from where this script was exported
set orig_proj_dir "[file normalize "$origin_dir/../PerfOptCSRs"]"

# Check for paths and files needed for project creation
set validate_required 0
if { $validate_required } {
  if { [checkRequiredFiles $origin_dir] } {
    puts "Tcl file $script_file is valid. All files required for project creation is accesable. "
  } else {
    puts "Tcl file $script_file is not valid. Not all files required for project creation is accesable. "
    return
  }
}

# Create project
create_project ${_xil_proj_name_} ./${_xil_proj_name_} -part xc7a100tcsg324-1

# Set the directory path for the new project
set proj_dir [get_property directory [current_project]]

# Set project properties
set obj [current_project]
set_property -name "board_part" -value "digilentinc.com:nexys-a7-100t:part0:1.0" -objects $obj
set_property -name "default_lib" -value "work" -objects $obj
set_property -name "enable_resource_estimation" -value "0" -objects $obj
set_property -name "enable_vhdl_2008" -value "1" -objects $obj
set_property -name "ip_cache_permissions" -value "read write" -objects $obj
set_property -name "ip_output_repo" -value "$proj_dir/${_xil_proj_name_}.cache/ip" -objects $obj
set_property -name "mem.enable_memory_map_generation" -value "1" -objects $obj
set_property -name "platform.board_id" -value "nexys-a7-100t" -objects $obj
set_property -name "revised_directory_structure" -value "1" -objects $obj
set_property -name "sim.central_dir" -value "$proj_dir/${_xil_proj_name_}.ip_user_files" -objects $obj
set_property -name "sim.ip.auto_export_scripts" -value "1" -objects $obj
set_property -name "simulator_language" -value "Mixed" -objects $obj
set_property -name "sim_compile_state" -value "1" -objects $obj
set_property -name "target_language" -value "VHDL" -objects $obj
set_property -name "webtalk.activehdl_export_sim" -value "37" -objects $obj
set_property -name "webtalk.modelsim_export_sim" -value "37" -objects $obj
set_property -name "webtalk.questa_export_sim" -value "37" -objects $obj
set_property -name "webtalk.riviera_export_sim" -value "37" -objects $obj
set_property -name "webtalk.vcs_export_sim" -value "37" -objects $obj
set_property -name "webtalk.xsim_export_sim" -value "37" -objects $obj
set_property -name "webtalk.xsim_launch_sim" -value "1631" -objects $obj
set_property -name "xpm_libraries" -value "XPM_CDC" -objects $obj

# Create 'sources_1' fileset (if not found)
if {[string equal [get_filesets -quiet sources_1] ""]} {
  create_fileset -srcset sources_1
}

# Set 'sources_1' fileset object
set obj [get_filesets sources_1]
# Import local files from the original project
set files [list \
 [file normalize "${origin_dir}/src/sources/ip/clk_wiz_2/clk_wiz_2.xci"]\
 [file normalize "${origin_dir}/src/sources/imports/constants.vhd"]\
 [file normalize "${origin_dir}/src/sources/imports/interfaces.vhd"]\
 [file normalize "${origin_dir}/src/sources/imports/GPRs.vhd"]\
 [file normalize "${origin_dir}/src/sources/imports/R_EX_MEM.vhd"]\
 [file normalize "${origin_dir}/src/sources/imports/R_ID_EX.vhd"]\
 [file normalize "${origin_dir}/src/sources/imports/R_MEM_WB.vhd"]\
 [file normalize "${origin_dir}/src/sources/imports/decode.vhd"]\
 [file normalize "${origin_dir}/src/sources/imports/instTB.vhd"]\
 [file normalize "${origin_dir}/src/sources/imports/CSRegs.vhd"]\
 [file normalize "${origin_dir}/src/sources/imports/procIFace.vhd"]\
 [file normalize "${origin_dir}/src/sources/imports/toplevel.vhd"]\
]
set imported_files [import_files -fileset sources_1 $files]

# Set 'sources_1' fileset file properties for remote files
# None

# Set 'sources_1' fileset file properties for local files
set file "clk_wiz_2/clk_wiz_2.xci"
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "generate_files_for_reference" -value "0" -objects $file_obj
set_property -name "library" -value "work" -objects $file_obj
set_property -name "registered_with_manager" -value "1" -objects $file_obj
if { ![get_property "is_locked" $file_obj] } {
  set_property -name "synth_checkpoint_mode" -value "Singular" -objects $file_obj
}

set file "constants.vhd"
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "VHDL" -objects $file_obj
set_property -name "library" -value "work" -objects $file_obj

set file "interfaces.vhd"
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "VHDL" -objects $file_obj
set_property -name "library" -value "work" -objects $file_obj

set file "GPRs.vhd"
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "VHDL" -objects $file_obj
set_property -name "library" -value "work" -objects $file_obj

set file "R_EX_MEM.vhd"
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "VHDL" -objects $file_obj
set_property -name "library" -value "work" -objects $file_obj

set file "R_ID_EX.vhd"
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "VHDL" -objects $file_obj
set_property -name "library" -value "work" -objects $file_obj

set file "R_MEM_WB.vhd"
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "VHDL" -objects $file_obj
set_property -name "library" -value "work" -objects $file_obj

set file "decode.vhd"
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "VHDL" -objects $file_obj
set_property -name "library" -value "work" -objects $file_obj

set file "instTB.vhd"
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "VHDL" -objects $file_obj
set_property -name "library" -value "work" -objects $file_obj

set file "CSRegs.vhd"
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "VHDL" -objects $file_obj
set_property -name "library" -value "work" -objects $file_obj

set file "procIFace.vhd"
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "VHDL" -objects $file_obj
set_property -name "library" -value "work" -objects $file_obj

set file "toplevel.vhd"
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "VHDL" -objects $file_obj
set_property -name "library" -value "work" -objects $file_obj


# Set 'sources_1' fileset properties
set obj [get_filesets sources_1]
set_property -name "dataflow_viewer_settings" -value "min_width=16" -objects $obj
set_property -name "top" -value "toplevel" -objects $obj
set_property -name "top_auto_set" -value "0" -objects $obj

# Create 'constrs_1' fileset (if not found)
if {[string equal [get_filesets -quiet constrs_1] ""]} {
  create_fileset -constrset constrs_1
}

# Set 'constrs_1' fileset object
set obj [get_filesets constrs_1]

# Add/Import constrs file and set constrs file properties
set file "[file normalize ${origin_dir}/src/constraints/constraints.xdc]"
set file_imported [import_files -fileset constrs_1 [list $file]]
set file "constraints.xdc"
set file_obj [get_files -of_objects [get_filesets constrs_1] [list "*$file"]]
set_property -name "file_type" -value "XDC" -objects $file_obj
set_property -name "library" -value "work" -objects $file_obj

# Set 'constrs_1' fileset properties
set obj [get_filesets constrs_1]
set_property -name "target_constrs_file" -value "$proj_dir/${_xil_proj_name_}.srcs/constrs_1/imports/constraints/constraints.xdc" -objects $obj
set_property -name "target_ucf" -value "$proj_dir/${_xil_proj_name_}.srcs/constrs_1/imports/constraints/constraints.xdc" -objects $obj

## Create 'sim_1' fileset (if not found)
#if {[string equal [get_filesets -quiet sim_1] ""]} {
#  create_fileset -simset sim_1
#}
#
## Set 'sim_1' fileset object
#set obj [get_filesets sim_1]
## Import local files from the original project
#set files [list \
# [file normalize "${origin_dir}/src/sim/toplevel_tb.vhd"]\
# [file normalize "${origin_dir}/src/sim/toplevel_tb_behav.wcfg"]\
#]
#set imported_files [import_files -fileset sim_1 $files]
#
## Set 'sim_1' fileset file properties for remote files
## None
#
## Set 'sim_1' fileset file properties for local files
#set file "toplevel_tb.vhd"
#set file_obj [get_files -of_objects [get_filesets sim_1] [list "*$file"]]
#set_property -name "file_type" -value "VHDL 2008" -objects $file_obj
#set_property -name "library" -value "work" -objects $file_obj
#
#set file "toplevel_tb_behav.wcfg"
#set file_obj [get_files -of_objects [get_filesets sim_1] [list "*$file"]]
#set_property -name "library" -value "work" -objects $file_obj
#
## Set 'sim_1' fileset properties
#set obj [get_filesets sim_1]
#set_property -name "incremental" -value "0" -objects $obj
#set_property -name "nl.mode" -value "funcsim" -objects $obj
#set_property -name "top" -value "toplevel_tb" -objects $obj
#set_property -name "top_auto_set" -value "0" -objects $obj
#set_property -name "xsim.simulate.log_all_signals" -value "1" -objects $obj
#set_property -name "xsim.simulate.runtime" -value "1s" -objects $obj

# Set 'utils_1' fileset object
set obj [get_filesets utils_1]
# Import local files from the original project
set files [list \
 [file normalize "${origin_dir}/src/utils/toplevel_postroute_physopt.dcp" ]\
]
set imported_files [import_files -fileset utils_1 $files]

# Set 'utils_1' fileset file properties for remote files
# None

# Set 'utils_1' fileset file properties for local files
set file "toplevel_postroute_physopt.dcp"
set file_obj [get_files -of_objects [get_filesets utils_1] [list "*$file"]]
set_property -name "library" -value "work" -objects $file_obj
set_property -name "netlist_only" -value "0" -objects $file_obj


# Set 'utils_1' fileset properties
set obj [get_filesets utils_1]

set idrFlowPropertiesConstraints ""
catch {
 set idrFlowPropertiesConstraints [get_param runs.disableIDRFlowPropertyConstraints]
 set_param runs.disableIDRFlowPropertyConstraints 1
}

# Create 'synth_1' run (if not found)
if {[string equal [get_runs -quiet synth_1] ""]} {
    create_run -name synth_1 -part xc7a100tcsg324-1 -flow {Vivado Synthesis 2022} -strategy "Flow_PerfOptimized_high" -report_strategy {No Reports} -constrset constrs_1
} else {
  set_property strategy "Flow_PerfOptimized_high" [get_runs synth_1]
  set_property flow "Vivado Synthesis 2022" [get_runs synth_1]
}
set obj [get_runs synth_1]
set_property set_report_strategy_name 1 $obj
set_property report_strategy {Vivado Synthesis Default Reports} $obj
set_property set_report_strategy_name 0 $obj
# Create 'synth_1_synth_report_utilization_0' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs synth_1] synth_1_synth_report_utilization_0] "" ] } {
  create_report_config -report_name synth_1_synth_report_utilization_0 -report_type report_utilization:1.0 -steps synth_design -runs synth_1
}
set obj [get_report_configs -of_objects [get_runs synth_1] synth_1_synth_report_utilization_0]
if { $obj != "" } {
set_property -name "display_name" -value "synth_1_synth_report_utilization_0" -objects $obj

}
set obj [get_runs synth_1]
set_property -name "needs_refresh" -value "1" -objects $obj
set_property -name "auto_incremental_checkpoint" -value "1" -objects $obj
set_property -name "write_incremental_synth_checkpoint" -value "1" -objects $obj
set_property -name "auto_incremental_checkpoint.directory" -value "$proj_dir/synth_1" -objects $obj
set_property -name "strategy" -value "Flow_PerfOptimized_high" -objects $obj
set_property -name "steps.synth_design.args.directive" -value "LogicCompaction" -objects $obj
set_property -name "steps.synth_design.args.retiming" -value "0" -objects $obj
set_property -name "steps.synth_design.args.no_retiming" -value "0" -objects $obj
#set_property -name "steps.synth_design.args.fsm_extraction" -value "auto" -objects $obj
#set_property -name "steps.synth_design.args.keep_equivalent_registers" -value "0" -objects $obj
#set_property -name "steps.synth_design.args.resource_sharing" -value "auto" -objects $obj
#set_property -name "steps.synth_design.args.control_set_opt_threshold" -value "1" -objects $obj
set_property -name "steps.synth_design.args.no_lc" -value "0" -objects $obj
#set_property -name "steps.synth_design.args.no_srlextract" -value "0" -objects $obj
#set_property -name "steps.synth_design.args.shreg_min_size" -value "3" -objects $obj
#set_property -name "steps.synth_design.args.max_bram" -value "-1" -objects $obj
#set_property -name "steps.synth_design.args.max_uram" -value "-1" -objects $obj
#set_property -name "steps.synth_design.args.max_dsp" -value "-1" -objects $obj
#set_property -name "steps.synth_design.args.max_bram_cascade_height" -value "-1" -objects $obj
#set_property -name "steps.synth_design.args.max_uram_cascade_height" -value "-1" -objects $obj
#set_property -name "steps.synth_design.args.cascade_dsp" -value "auto" -objects $obj
#set_property -name "steps.synth_design.args.assert" -value "0" -objects $obj
set_property -name "steps.synth_design.args.incremental_mode" -value "aggressive" -objects $obj
set_property -name "steps.synth_design.args.more options" -value "" -objects $obj

# set the current synth run
current_run -synthesis [get_runs synth_1]

# Create 'impl_1' run (if not found)
if {[string equal [get_runs -quiet impl_1] ""]} {
    create_run -name impl_1 -part xc7a100tcsg324-1 -flow {Vivado Implementation 2022} -strategy "Vivado Implementation Defaults" -report_strategy {No Reports} -constrset constrs_1 -parent_run synth_1
} else {
  set_property strategy "Vivado Implementation Defaults" [get_runs impl_1]
  set_property flow "Vivado Implementation 2022" [get_runs impl_1]
}
set obj [get_runs impl_1]
set_property set_report_strategy_name 1 $obj
set_property report_strategy {Vivado Implementation Default Reports} $obj
set_property set_report_strategy_name 0 $obj
# Create 'impl_1_init_report_timing_summary_0' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs impl_1] impl_1_init_report_timing_summary_0] "" ] } {
  create_report_config -report_name impl_1_init_report_timing_summary_0 -report_type report_timing_summary:1.0 -steps init_design -runs impl_1
}
set obj [get_report_configs -of_objects [get_runs impl_1] impl_1_init_report_timing_summary_0]
if { $obj != "" } {
set_property -name "is_enabled" -value "0" -objects $obj
set_property -name "display_name" -value "Timing Summary - Design Initialization" -objects $obj
set_property -name "options.check_timing_verbose" -value "0" -objects $obj
set_property -name "options.delay_type" -value "" -objects $obj
set_property -name "options.setup" -value "0" -objects $obj
set_property -name "options.hold" -value "0" -objects $obj
set_property -name "options.max_paths" -value "10" -objects $obj
set_property -name "options.nworst" -value "" -objects $obj
set_property -name "options.unique_pins" -value "0" -objects $obj
set_property -name "options.path_type" -value "" -objects $obj
set_property -name "options.slack_lesser_than" -value "" -objects $obj
set_property -name "options.report_unconstrained" -value "1" -objects $obj
set_property -name "options.warn_on_violation" -value "0" -objects $obj
set_property -name "options.significant_digits" -value "" -objects $obj
set_property -name "options.cell" -value "" -objects $obj
set_property -name "options.more_options" -value "" -objects $obj

}
# Create 'impl_1_opt_report_drc_0' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs impl_1] impl_1_opt_report_drc_0] "" ] } {
  create_report_config -report_name impl_1_opt_report_drc_0 -report_type report_drc:1.0 -steps opt_design -runs impl_1
}
set obj [get_report_configs -of_objects [get_runs impl_1] impl_1_opt_report_drc_0]
if { $obj != "" } {
set_property -name "is_enabled" -value "1" -objects $obj
set_property -name "display_name" -value "DRC - Opt Design" -objects $obj
set_property -name "options.upgrade_cw" -value "0" -objects $obj
set_property -name "options.checks" -value "" -objects $obj
set_property -name "options.ruledecks" -value "" -objects $obj
set_property -name "options.more_options" -value "" -objects $obj

}
# Create 'impl_1_opt_report_timing_summary_0' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs impl_1] impl_1_opt_report_timing_summary_0] "" ] } {
  create_report_config -report_name impl_1_opt_report_timing_summary_0 -report_type report_timing_summary:1.0 -steps opt_design -runs impl_1
}
set obj [get_report_configs -of_objects [get_runs impl_1] impl_1_opt_report_timing_summary_0]
if { $obj != "" } {
set_property -name "is_enabled" -value "0" -objects $obj
set_property -name "display_name" -value "Timing Summary - Opt Design" -objects $obj
set_property -name "options.check_timing_verbose" -value "0" -objects $obj
set_property -name "options.delay_type" -value "" -objects $obj
set_property -name "options.setup" -value "0" -objects $obj
set_property -name "options.hold" -value "0" -objects $obj
set_property -name "options.max_paths" -value "10" -objects $obj
set_property -name "options.nworst" -value "" -objects $obj
set_property -name "options.unique_pins" -value "0" -objects $obj
set_property -name "options.path_type" -value "" -objects $obj
set_property -name "options.slack_lesser_than" -value "" -objects $obj
set_property -name "options.report_unconstrained" -value "1" -objects $obj
set_property -name "options.warn_on_violation" -value "0" -objects $obj
set_property -name "options.significant_digits" -value "" -objects $obj
set_property -name "options.cell" -value "" -objects $obj
set_property -name "options.more_options" -value "" -objects $obj

}
# Create 'impl_1_power_opt_report_timing_summary_0' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs impl_1] impl_1_power_opt_report_timing_summary_0] "" ] } {
  create_report_config -report_name impl_1_power_opt_report_timing_summary_0 -report_type report_timing_summary:1.0 -steps power_opt_design -runs impl_1
}
set obj [get_report_configs -of_objects [get_runs impl_1] impl_1_power_opt_report_timing_summary_0]
if { $obj != "" } {
set_property -name "is_enabled" -value "0" -objects $obj
set_property -name "display_name" -value "Timing Summary - Power Opt Design" -objects $obj
set_property -name "options.check_timing_verbose" -value "0" -objects $obj
set_property -name "options.delay_type" -value "" -objects $obj
set_property -name "options.setup" -value "0" -objects $obj
set_property -name "options.hold" -value "0" -objects $obj
set_property -name "options.max_paths" -value "10" -objects $obj
set_property -name "options.nworst" -value "" -objects $obj
set_property -name "options.unique_pins" -value "0" -objects $obj
set_property -name "options.path_type" -value "" -objects $obj
set_property -name "options.slack_lesser_than" -value "" -objects $obj
set_property -name "options.report_unconstrained" -value "1" -objects $obj
set_property -name "options.warn_on_violation" -value "0" -objects $obj
set_property -name "options.significant_digits" -value "" -objects $obj
set_property -name "options.cell" -value "" -objects $obj
set_property -name "options.more_options" -value "" -objects $obj

}
# Create 'impl_1_place_report_io_0' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs impl_1] impl_1_place_report_io_0] "" ] } {
  create_report_config -report_name impl_1_place_report_io_0 -report_type report_io:1.0 -steps place_design -runs impl_1
}
set obj [get_report_configs -of_objects [get_runs impl_1] impl_1_place_report_io_0]
if { $obj != "" } {
set_property -name "is_enabled" -value "1" -objects $obj
set_property -name "display_name" -value "IO - Place Design" -objects $obj
set_property -name "options.more_options" -value "" -objects $obj

}
# Create 'impl_1_place_report_utilization_0' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs impl_1] impl_1_place_report_utilization_0] "" ] } {
  create_report_config -report_name impl_1_place_report_utilization_0 -report_type report_utilization:1.0 -steps place_design -runs impl_1
}
set obj [get_report_configs -of_objects [get_runs impl_1] impl_1_place_report_utilization_0]
if { $obj != "" } {
set_property -name "is_enabled" -value "1" -objects $obj
set_property -name "display_name" -value "Utilization - Place Design" -objects $obj
set_property -name "options.pblocks" -value "" -objects $obj
set_property -name "options.cells" -value "" -objects $obj
set_property -name "options.slr" -value "0" -objects $obj
set_property -name "options.packthru" -value "0" -objects $obj
set_property -name "options.hierarchical" -value "0" -objects $obj
set_property -name "options.hierarchical_depth" -value "" -objects $obj
set_property -name "options.hierarchical_percentages" -value "0" -objects $obj
set_property -name "options.more_options" -value "" -objects $obj

}
# Create 'impl_1_place_report_control_sets_0' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs impl_1] impl_1_place_report_control_sets_0] "" ] } {
  create_report_config -report_name impl_1_place_report_control_sets_0 -report_type report_control_sets:1.0 -steps place_design -runs impl_1
}
set obj [get_report_configs -of_objects [get_runs impl_1] impl_1_place_report_control_sets_0]
if { $obj != "" } {
set_property -name "is_enabled" -value "1" -objects $obj
set_property -name "display_name" -value "Control Sets - Place Design" -objects $obj
set_property -name "options.verbose" -value "1" -objects $obj
set_property -name "options.cells" -value "" -objects $obj
set_property -name "options.more_options" -value "" -objects $obj

}
# Create 'impl_1_place_report_incremental_reuse_0' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs impl_1] impl_1_place_report_incremental_reuse_0] "" ] } {
  create_report_config -report_name impl_1_place_report_incremental_reuse_0 -report_type report_incremental_reuse:1.0 -steps place_design -runs impl_1
}
set obj [get_report_configs -of_objects [get_runs impl_1] impl_1_place_report_incremental_reuse_0]
if { $obj != "" } {
set_property -name "is_enabled" -value "0" -objects $obj
set_property -name "display_name" -value "Incremental Reuse - Place Design" -objects $obj
set_property -name "options.cells" -value "" -objects $obj
set_property -name "options.hierarchical" -value "0" -objects $obj
set_property -name "options.hierarchical_depth" -value "" -objects $obj
set_property -name "options.more_options" -value "" -objects $obj

}
# Create 'impl_1_place_report_incremental_reuse_1' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs impl_1] impl_1_place_report_incremental_reuse_1] "" ] } {
  create_report_config -report_name impl_1_place_report_incremental_reuse_1 -report_type report_incremental_reuse:1.0 -steps place_design -runs impl_1
}
set obj [get_report_configs -of_objects [get_runs impl_1] impl_1_place_report_incremental_reuse_1]
if { $obj != "" } {
set_property -name "is_enabled" -value "0" -objects $obj
set_property -name "display_name" -value "Incremental Reuse - Place Design" -objects $obj
set_property -name "options.cells" -value "" -objects $obj
set_property -name "options.hierarchical" -value "0" -objects $obj
set_property -name "options.hierarchical_depth" -value "" -objects $obj
set_property -name "options.more_options" -value "" -objects $obj

}
# Create 'impl_1_place_report_timing_summary_0' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs impl_1] impl_1_place_report_timing_summary_0] "" ] } {
  create_report_config -report_name impl_1_place_report_timing_summary_0 -report_type report_timing_summary:1.0 -steps place_design -runs impl_1
}
set obj [get_report_configs -of_objects [get_runs impl_1] impl_1_place_report_timing_summary_0]
if { $obj != "" } {
set_property -name "is_enabled" -value "0" -objects $obj
set_property -name "display_name" -value "Timing Summary - Place Design" -objects $obj
set_property -name "options.check_timing_verbose" -value "0" -objects $obj
set_property -name "options.delay_type" -value "" -objects $obj
set_property -name "options.setup" -value "0" -objects $obj
set_property -name "options.hold" -value "0" -objects $obj
set_property -name "options.max_paths" -value "10" -objects $obj
set_property -name "options.nworst" -value "" -objects $obj
set_property -name "options.unique_pins" -value "0" -objects $obj
set_property -name "options.path_type" -value "" -objects $obj
set_property -name "options.slack_lesser_than" -value "" -objects $obj
set_property -name "options.report_unconstrained" -value "1" -objects $obj
set_property -name "options.warn_on_violation" -value "0" -objects $obj
set_property -name "options.significant_digits" -value "" -objects $obj
set_property -name "options.cell" -value "" -objects $obj
set_property -name "options.more_options" -value "" -objects $obj

}
# Create 'impl_1_post_place_power_opt_report_timing_summary_0' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs impl_1] impl_1_post_place_power_opt_report_timing_summary_0] "" ] } {
  create_report_config -report_name impl_1_post_place_power_opt_report_timing_summary_0 -report_type report_timing_summary:1.0 -steps post_place_power_opt_design -runs impl_1
}
set obj [get_report_configs -of_objects [get_runs impl_1] impl_1_post_place_power_opt_report_timing_summary_0]
if { $obj != "" } {
set_property -name "is_enabled" -value "0" -objects $obj
set_property -name "display_name" -value "Timing Summary - Post-Place Power Opt Design" -objects $obj
set_property -name "options.check_timing_verbose" -value "0" -objects $obj
set_property -name "options.delay_type" -value "" -objects $obj
set_property -name "options.setup" -value "0" -objects $obj
set_property -name "options.hold" -value "0" -objects $obj
set_property -name "options.max_paths" -value "10" -objects $obj
set_property -name "options.nworst" -value "" -objects $obj
set_property -name "options.unique_pins" -value "0" -objects $obj
set_property -name "options.path_type" -value "" -objects $obj
set_property -name "options.slack_lesser_than" -value "" -objects $obj
set_property -name "options.report_unconstrained" -value "1" -objects $obj
set_property -name "options.warn_on_violation" -value "0" -objects $obj
set_property -name "options.significant_digits" -value "" -objects $obj
set_property -name "options.cell" -value "" -objects $obj
set_property -name "options.more_options" -value "" -objects $obj

}
# Create 'impl_1_phys_opt_report_timing_summary_0' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs impl_1] impl_1_phys_opt_report_timing_summary_0] "" ] } {
  create_report_config -report_name impl_1_phys_opt_report_timing_summary_0 -report_type report_timing_summary:1.0 -steps phys_opt_design -runs impl_1
}
set obj [get_report_configs -of_objects [get_runs impl_1] impl_1_phys_opt_report_timing_summary_0]
if { $obj != "" } {
set_property -name "is_enabled" -value "0" -objects $obj
set_property -name "display_name" -value "Timing Summary - Post-Place Phys Opt Design" -objects $obj
set_property -name "options.check_timing_verbose" -value "0" -objects $obj
set_property -name "options.delay_type" -value "" -objects $obj
set_property -name "options.setup" -value "0" -objects $obj
set_property -name "options.hold" -value "0" -objects $obj
set_property -name "options.max_paths" -value "10" -objects $obj
set_property -name "options.nworst" -value "" -objects $obj
set_property -name "options.unique_pins" -value "0" -objects $obj
set_property -name "options.path_type" -value "" -objects $obj
set_property -name "options.slack_lesser_than" -value "" -objects $obj
set_property -name "options.report_unconstrained" -value "1" -objects $obj
set_property -name "options.warn_on_violation" -value "0" -objects $obj
set_property -name "options.significant_digits" -value "" -objects $obj
set_property -name "options.cell" -value "" -objects $obj
set_property -name "options.more_options" -value "" -objects $obj

}
# Create 'impl_1_route_report_drc_0' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs impl_1] impl_1_route_report_drc_0] "" ] } {
  create_report_config -report_name impl_1_route_report_drc_0 -report_type report_drc:1.0 -steps route_design -runs impl_1
}
set obj [get_report_configs -of_objects [get_runs impl_1] impl_1_route_report_drc_0]
if { $obj != "" } {
set_property -name "is_enabled" -value "1" -objects $obj
set_property -name "display_name" -value "DRC - Route Design" -objects $obj
set_property -name "options.upgrade_cw" -value "0" -objects $obj
set_property -name "options.checks" -value "" -objects $obj
set_property -name "options.ruledecks" -value "" -objects $obj
set_property -name "options.more_options" -value "" -objects $obj

}
# Create 'impl_1_route_report_methodology_0' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs impl_1] impl_1_route_report_methodology_0] "" ] } {
  create_report_config -report_name impl_1_route_report_methodology_0 -report_type report_methodology:1.0 -steps route_design -runs impl_1
}
set obj [get_report_configs -of_objects [get_runs impl_1] impl_1_route_report_methodology_0]
if { $obj != "" } {
set_property -name "is_enabled" -value "1" -objects $obj
set_property -name "display_name" -value "Methodology - Route Design" -objects $obj
set_property -name "options.checks" -value "" -objects $obj
set_property -name "options.more_options" -value "" -objects $obj

}
# Create 'impl_1_route_report_power_0' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs impl_1] impl_1_route_report_power_0] "" ] } {
  create_report_config -report_name impl_1_route_report_power_0 -report_type report_power:1.0 -steps route_design -runs impl_1
}
set obj [get_report_configs -of_objects [get_runs impl_1] impl_1_route_report_power_0]
if { $obj != "" } {
set_property -name "is_enabled" -value "1" -objects $obj
set_property -name "display_name" -value "Power - Route Design" -objects $obj
set_property -name "options.advisory" -value "0" -objects $obj
set_property -name "options.xpe" -value "" -objects $obj
set_property -name "options.more_options" -value "" -objects $obj

}
# Create 'impl_1_route_report_route_status_0' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs impl_1] impl_1_route_report_route_status_0] "" ] } {
  create_report_config -report_name impl_1_route_report_route_status_0 -report_type report_route_status:1.0 -steps route_design -runs impl_1
}
set obj [get_report_configs -of_objects [get_runs impl_1] impl_1_route_report_route_status_0]
if { $obj != "" } {
set_property -name "is_enabled" -value "1" -objects $obj
set_property -name "display_name" -value "Route Status - Route Design" -objects $obj
set_property -name "options.of_objects" -value "" -objects $obj
set_property -name "options.route_type" -value "" -objects $obj
set_property -name "options.list_all_nets" -value "0" -objects $obj
set_property -name "options.show_all" -value "0" -objects $obj
set_property -name "options.has_routing" -value "0" -objects $obj
set_property -name "options.more_options" -value "" -objects $obj

}
# Create 'impl_1_route_report_timing_summary_0' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs impl_1] impl_1_route_report_timing_summary_0] "" ] } {
  create_report_config -report_name impl_1_route_report_timing_summary_0 -report_type report_timing_summary:1.0 -steps route_design -runs impl_1
}
set obj [get_report_configs -of_objects [get_runs impl_1] impl_1_route_report_timing_summary_0]
if { $obj != "" } {
set_property -name "is_enabled" -value "1" -objects $obj
set_property -name "display_name" -value "Timing Summary - Route Design" -objects $obj
set_property -name "options.check_timing_verbose" -value "0" -objects $obj
set_property -name "options.delay_type" -value "" -objects $obj
set_property -name "options.setup" -value "0" -objects $obj
set_property -name "options.hold" -value "0" -objects $obj
set_property -name "options.max_paths" -value "10" -objects $obj
set_property -name "options.nworst" -value "" -objects $obj
set_property -name "options.unique_pins" -value "0" -objects $obj
set_property -name "options.path_type" -value "" -objects $obj
set_property -name "options.slack_lesser_than" -value "" -objects $obj
set_property -name "options.report_unconstrained" -value "1" -objects $obj
set_property -name "options.warn_on_violation" -value "0" -objects $obj
set_property -name "options.significant_digits" -value "" -objects $obj
set_property -name "options.cell" -value "" -objects $obj
set_property -name "options.more_options" -value "" -objects $obj

}
# Create 'impl_1_route_report_incremental_reuse_0' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs impl_1] impl_1_route_report_incremental_reuse_0] "" ] } {
  create_report_config -report_name impl_1_route_report_incremental_reuse_0 -report_type report_incremental_reuse:1.0 -steps route_design -runs impl_1
}
set obj [get_report_configs -of_objects [get_runs impl_1] impl_1_route_report_incremental_reuse_0]
if { $obj != "" } {
set_property -name "is_enabled" -value "1" -objects $obj
set_property -name "display_name" -value "Incremental Reuse - Route Design" -objects $obj
set_property -name "options.cells" -value "" -objects $obj
set_property -name "options.hierarchical" -value "0" -objects $obj
set_property -name "options.hierarchical_depth" -value "" -objects $obj
set_property -name "options.more_options" -value "" -objects $obj

}
# Create 'impl_1_route_report_clock_utilization_0' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs impl_1] impl_1_route_report_clock_utilization_0] "" ] } {
  create_report_config -report_name impl_1_route_report_clock_utilization_0 -report_type report_clock_utilization:1.0 -steps route_design -runs impl_1
}
set obj [get_report_configs -of_objects [get_runs impl_1] impl_1_route_report_clock_utilization_0]
if { $obj != "" } {
set_property -name "is_enabled" -value "1" -objects $obj
set_property -name "display_name" -value "Clock Utilization - Route Design" -objects $obj
set_property -name "options.write_xdc" -value "0" -objects $obj
set_property -name "options.clock_roots_only" -value "0" -objects $obj
set_property -name "options.more_options" -value "" -objects $obj

}
# Create 'impl_1_route_report_bus_skew_0' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs impl_1] impl_1_route_report_bus_skew_0] "" ] } {
  create_report_config -report_name impl_1_route_report_bus_skew_0 -report_type report_bus_skew:1.1 -steps route_design -runs impl_1
}
set obj [get_report_configs -of_objects [get_runs impl_1] impl_1_route_report_bus_skew_0]
if { $obj != "" } {
set_property -name "is_enabled" -value "1" -objects $obj
set_property -name "display_name" -value "Bus Skew - Route Design" -objects $obj
set_property -name "options.delay_type" -value "" -objects $obj
set_property -name "options.setup" -value "0" -objects $obj
set_property -name "options.hold" -value "0" -objects $obj
set_property -name "options.max_paths" -value "" -objects $obj
set_property -name "options.nworst" -value "" -objects $obj
set_property -name "options.unique_pins" -value "0" -objects $obj
set_property -name "options.path_type" -value "" -objects $obj
set_property -name "options.slack_lesser_than" -value "" -objects $obj
set_property -name "options.slack_greater_than" -value "" -objects $obj
set_property -name "options.significant_digits" -value "" -objects $obj
set_property -name "options.warn_on_violation" -value "1" -objects $obj
set_property -name "options.more_options" -value "" -objects $obj

}
# Create 'impl_1_post_route_phys_opt_report_timing_summary_0' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs impl_1] impl_1_post_route_phys_opt_report_timing_summary_0] "" ] } {
  create_report_config -report_name impl_1_post_route_phys_opt_report_timing_summary_0 -report_type report_timing_summary:1.0 -steps post_route_phys_opt_design -runs impl_1
}
set obj [get_report_configs -of_objects [get_runs impl_1] impl_1_post_route_phys_opt_report_timing_summary_0]
if { $obj != "" } {
set_property -name "is_enabled" -value "1" -objects $obj
set_property -name "display_name" -value "Timing Summary - Post-Route Phys Opt Design" -objects $obj
set_property -name "options.check_timing_verbose" -value "0" -objects $obj
set_property -name "options.delay_type" -value "" -objects $obj
set_property -name "options.setup" -value "0" -objects $obj
set_property -name "options.hold" -value "0" -objects $obj
set_property -name "options.max_paths" -value "10" -objects $obj
set_property -name "options.nworst" -value "" -objects $obj
set_property -name "options.unique_pins" -value "0" -objects $obj
set_property -name "options.path_type" -value "" -objects $obj
set_property -name "options.slack_lesser_than" -value "" -objects $obj
set_property -name "options.report_unconstrained" -value "1" -objects $obj
set_property -name "options.warn_on_violation" -value "1" -objects $obj
set_property -name "options.significant_digits" -value "" -objects $obj
set_property -name "options.cell" -value "" -objects $obj
set_property -name "options.more_options" -value "" -objects $obj

}
# Create 'impl_1_post_route_phys_opt_report_bus_skew_0' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs impl_1] impl_1_post_route_phys_opt_report_bus_skew_0] "" ] } {
  create_report_config -report_name impl_1_post_route_phys_opt_report_bus_skew_0 -report_type report_bus_skew:1.1 -steps post_route_phys_opt_design -runs impl_1
}
set obj [get_report_configs -of_objects [get_runs impl_1] impl_1_post_route_phys_opt_report_bus_skew_0]
if { $obj != "" } {
set_property -name "is_enabled" -value "1" -objects $obj
set_property -name "display_name" -value "Bus Skew - Post-Route Phys Opt Design" -objects $obj
set_property -name "options.delay_type" -value "" -objects $obj
set_property -name "options.setup" -value "0" -objects $obj
set_property -name "options.hold" -value "0" -objects $obj
set_property -name "options.max_paths" -value "" -objects $obj
set_property -name "options.nworst" -value "" -objects $obj
set_property -name "options.unique_pins" -value "0" -objects $obj
set_property -name "options.path_type" -value "" -objects $obj
set_property -name "options.slack_lesser_than" -value "" -objects $obj
set_property -name "options.slack_greater_than" -value "" -objects $obj
set_property -name "options.significant_digits" -value "" -objects $obj
set_property -name "options.warn_on_violation" -value "1" -objects $obj
set_property -name "options.more_options" -value "" -objects $obj

}
set obj [get_runs impl_1]
set_property -name "constrset" -value "constrs_1" -objects $obj
set_property -name "description" -value "Default settings for Implementation." -objects $obj
set_property -name "flow" -value "Vivado Implementation 2022" -objects $obj
set_property -name "name" -value "impl_1" -objects $obj
set_property -name "needs_refresh" -value "0" -objects $obj
set_property -name "pr_configuration" -value "" -objects $obj
set_property -name "dfx_mode" -value "STANDARD" -objects $obj
set_property -name "srcset" -value "sources_1" -objects $obj
set_property -name "incremental_checkpoint" -value "$proj_dir/${_xil_proj_name_}.srcs/utils_1/imports/utils/toplevel_postroute_physopt.dcp" -objects $obj
set_property -name "auto_incremental_checkpoint" -value "0" -objects $obj
set_property -name "rqs_files" -value "" -objects $obj
set_property -name "ml_strategy_runs" -value "" -objects $obj
set_property -name "auto_rqs" -value "0" -objects $obj
set_property -name "strategy" -value "Vivado Implementation Defaults" -objects $obj
set_property -name "steps.init_design.tcl.pre" -value "" -objects $obj
set_property -name "steps.init_design.tcl.post" -value "" -objects $obj
set_property -name "steps.init_design.args.more options" -value "" -objects $obj
set_property -name "steps.opt_design.is_enabled" -value "1" -objects $obj
set_property -name "steps.opt_design.tcl.pre" -value "" -objects $obj
set_property -name "steps.opt_design.tcl.post" -value "" -objects $obj
set_property -name "steps.opt_design.args.verbose" -value "0" -objects $obj
set_property -name "steps.opt_design.args.directive" -value "Default" -objects $obj
set_property -name "steps.opt_design.args.more options" -value "-aggressive_remap -bram_power_opt -dsp_register_opt -sweep -propconst -verbose" -objects $obj
set_property -name "steps.power_opt_design.is_enabled" -value "0" -objects $obj
set_property -name "steps.power_opt_design.tcl.pre" -value "" -objects $obj
set_property -name "steps.power_opt_design.tcl.post" -value "" -objects $obj
set_property -name "steps.power_opt_design.args.more options" -value "" -objects $obj
set_property -name "steps.place_design.tcl.pre" -value "" -objects $obj
set_property -name "steps.place_design.tcl.post" -value "" -objects $obj
set_property -name "steps.place_design.args.directive" -value "ExtraNetDelay_high" -objects $obj
set_property -name "steps.place_design.args.more options" -value "" -objects $obj
set_property -name "steps.post_place_power_opt_design.is_enabled" -value "0" -objects $obj
set_property -name "steps.post_place_power_opt_design.tcl.pre" -value "" -objects $obj
set_property -name "steps.post_place_power_opt_design.tcl.post" -value "" -objects $obj
set_property -name "steps.post_place_power_opt_design.args.more options" -value "" -objects $obj
set_property -name "steps.phys_opt_design.is_enabled" -value "1" -objects $obj
set_property -name "steps.phys_opt_design.tcl.pre" -value "" -objects $obj
set_property -name "steps.phys_opt_design.tcl.post" -value "" -objects $obj
set_property -name "steps.phys_opt_design.args.directive" -value "AggressiveExplore" -objects $obj
set_property -name "steps.phys_opt_design.args.more options" -value "" -objects $obj
set_property -name "steps.route_design.tcl.pre" -value "" -objects $obj
set_property -name "steps.route_design.tcl.post" -value "" -objects $obj
set_property -name "steps.route_design.args.directive" -value "NoTimingRelaxation" -objects $obj
set_property -name "steps.route_design.args.more options" -value "" -objects $obj
set_property -name "steps.post_route_phys_opt_design.is_enabled" -value "1" -objects $obj
set_property -name "steps.post_route_phys_opt_design.tcl.pre" -value "" -objects $obj
set_property -name "steps.post_route_phys_opt_design.tcl.post" -value "" -objects $obj
set_property -name "steps.post_route_phys_opt_design.args.directive" -value "AggressiveExplore" -objects $obj
set_property -name "steps.post_route_phys_opt_design.args.more options" -value "" -objects $obj
set_property -name "steps.write_bitstream.tcl.pre" -value "" -objects $obj
set_property -name "steps.write_bitstream.tcl.post" -value "" -objects $obj
set_property -name "steps.write_bitstream.args.raw_bitfile" -value "0" -objects $obj
set_property -name "steps.write_bitstream.args.mask_file" -value "0" -objects $obj
set_property -name "steps.write_bitstream.args.no_binary_bitfile" -value "0" -objects $obj
set_property -name "steps.write_bitstream.args.bin_file" -value "0" -objects $obj
set_property -name "steps.write_bitstream.args.readback_file" -value "0" -objects $obj
set_property -name "steps.write_bitstream.args.logic_location_file" -value "0" -objects $obj
set_property -name "steps.write_bitstream.args.verbose" -value "0" -objects $obj
set_property -name "steps.write_bitstream.args.more options" -value "" -objects $obj

# set the current impl run
current_run -implementation [get_runs impl_1]
catch {
 if { $idrFlowPropertiesConstraints != {} } {
   set_param runs.disableIDRFlowPropertyConstraints $idrFlowPropertiesConstraints
 }
}

puts "INFO: Project created:${_xil_proj_name_}"
# Create 'drc_1' gadget (if not found)
if {[string equal [get_dashboard_gadgets  [ list "drc_1" ] ] ""]} {
create_dashboard_gadget -name {drc_1} -type drc
}
set obj [get_dashboard_gadgets [ list "drc_1" ] ]

# Create 'methodology_1' gadget (if not found)
if {[string equal [get_dashboard_gadgets  [ list "methodology_1" ] ] ""]} {
create_dashboard_gadget -name {methodology_1} -type methodology
}
set obj [get_dashboard_gadgets [ list "methodology_1" ] ]

# Create 'power_1' gadget (if not found)
if {[string equal [get_dashboard_gadgets  [ list "power_1" ] ] ""]} {
create_dashboard_gadget -name {power_1} -type power
}
set obj [get_dashboard_gadgets [ list "power_1" ] ]

# Create 'timing_1' gadget (if not found)
if {[string equal [get_dashboard_gadgets  [ list "timing_1" ] ] ""]} {
create_dashboard_gadget -name {timing_1} -type timing
}
set obj [get_dashboard_gadgets [ list "timing_1" ] ]

# Create 'utilization_1' gadget (if not found)
if {[string equal [get_dashboard_gadgets  [ list "utilization_1" ] ] ""]} {
create_dashboard_gadget -name {utilization_1} -type utilization
}
set obj [get_dashboard_gadgets [ list "utilization_1" ] ]
set_property -name "run.step" -value "synth_design" -objects $obj
set_property -name "run.type" -value "synthesis" -objects $obj

# Create 'utilization_2' gadget (if not found)
if {[string equal [get_dashboard_gadgets  [ list "utilization_2" ] ] ""]} {
create_dashboard_gadget -name {utilization_2} -type utilization
}
set obj [get_dashboard_gadgets [ list "utilization_2" ] ]

move_dashboard_gadget -name {utilization_1} -row 0 -col 0
move_dashboard_gadget -name {power_1} -row 1 -col 0
move_dashboard_gadget -name {drc_1} -row 2 -col 0
move_dashboard_gadget -name {timing_1} -row 0 -col 1
move_dashboard_gadget -name {utilization_2} -row 1 -col 1
move_dashboard_gadget -name {methodology_1} -row 2 -col 1
