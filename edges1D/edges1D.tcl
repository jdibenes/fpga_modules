
################################################################
# This is a generated script based on design: edges1D
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

namespace eval _tcl {
proc get_script_folder {} {
   set script_path [file normalize [info script]]
   set script_folder [file dirname $script_path]
   return $script_folder
}
}
variable script_folder
set script_folder [_tcl::get_script_folder]

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2017.4
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   catch {common::send_msg_id "BD_TCL-109" "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."}

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source edges1D_script.tcl

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xczu9eg-ffvb1156-2-e
   set_property BOARD_PART xilinx.com:zcu102:part0:3.1 [current_project]
}


# CHANGE DESIGN NAME HERE
variable design_name
set design_name edges1D

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      common::send_msg_id "BD_TCL-001" "INFO" "Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   common::send_msg_id "BD_TCL-002" "INFO" "Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   common::send_msg_id "BD_TCL-003" "INFO" "Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   common::send_msg_id "BD_TCL-004" "INFO" "Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

common::send_msg_id "BD_TCL-005" "INFO" "Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   catch {common::send_msg_id "BD_TCL-114" "ERROR" $errMsg}
   return $nRet
}

set bCheckIPsPassed 1
##################################################################
# CHECK IPs
##################################################################
set bCheckIPs 1
if { $bCheckIPs == 1 } {
   set list_check_ips "\ 
xilinx.com:ip:xlconstant:1.1\
xilinx.com:ip:c_addsub:12.0\
xilinx.com:ip:div_gen:5.1\
xilinx.com:ip:xlconcat:2.1\
xilinx.com:ip:xlslice:1.0\
xilinx.com:ip:c_shift_ram:12.0\
xilinx.com:ip:util_vector_logic:2.0\
xilinx.com:ip:c_counter_binary:12.0\
"

   set list_ips_missing ""
   common::send_msg_id "BD_TCL-006" "INFO" "Checking if the following IPs exist in the project's IP catalog: $list_check_ips ."

   foreach ip_vlnv $list_check_ips {
      set ip_obj [get_ipdefs -all $ip_vlnv]
      if { $ip_obj eq "" } {
         lappend list_ips_missing $ip_vlnv
      }
   }

   if { $list_ips_missing ne "" } {
      catch {common::send_msg_id "BD_TCL-115" "ERROR" "The following IPs are not found in the IP Catalog:\n  $list_ips_missing\n\nResolution: Please add the repository containing the IP(s) to the project." }
      set bCheckIPsPassed 0
   }

}

if { $bCheckIPsPassed != 1 } {
  common::send_msg_id "BD_TCL-1003" "WARNING" "Will not continue with creation of design due to the error(s) above."
  return 3
}

##################################################################
# DESIGN PROCs
##################################################################


# Hierarchical cell: stage2_1
proc create_hier_cell_stage2_1_1 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_stage2_1_1() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins

  # Create pins
  create_bd_pin -dir I -type clk CLK
  create_bd_pin -dir I -from 10 -to 0 -type data abs_sum
  create_bd_pin -dir O -from 10 -to 0 -type data abs_sum_d
  create_bd_pin -dir O -from 10 -to 0 -type data cmp
  create_bd_pin -dir I -from 10 -to 0 -type data threshold

  # Create instance: cmp, and set properties
  set cmp [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_addsub:12.0 cmp ]
  set_property -dict [ list \
   CONFIG.A_Type {Signed} \
   CONFIG.A_Width {11} \
   CONFIG.Add_Mode {Subtract} \
   CONFIG.B_Type {Signed} \
   CONFIG.B_Value {00000000000} \
   CONFIG.B_Width {11} \
   CONFIG.CE {false} \
   CONFIG.Latency {1} \
   CONFIG.Latency_Configuration {Automatic} \
   CONFIG.Out_Width {11} \
 ] $cmp

  # Create instance: tap_1_abs, and set properties
  set tap_1_abs [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 tap_1_abs ]
  set_property -dict [ list \
   CONFIG.AsyncInitVal {00000000000} \
   CONFIG.DefaultData {00000000000} \
   CONFIG.Depth {1} \
   CONFIG.SyncInitVal {00000000000} \
   CONFIG.Width {11} \
 ] $tap_1_abs

  # Create port connections
  connect_bd_net -net CLK_1 [get_bd_pins CLK] [get_bd_pins cmp/CLK] [get_bd_pins tap_1_abs/CLK]
  connect_bd_net -net abs_sum_abs_sum [get_bd_pins abs_sum] [get_bd_pins cmp/B] [get_bd_pins tap_1_abs/D]
  connect_bd_net -net c_addsub_0_S [get_bd_pins cmp] [get_bd_pins cmp/S]
  connect_bd_net -net pad_signed_dout [get_bd_pins threshold] [get_bd_pins cmp/A]
  connect_bd_net -net tap_1_abs_Q [get_bd_pins abs_sum_d] [get_bd_pins tap_1_abs/Q]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: stage1_1
proc create_hier_cell_stage1_1_1 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_stage1_1_1() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins

  # Create pins
  create_bd_pin -dir I -from 1 -to 0 -type data A
  create_bd_pin -dir I -type data BYPASS
  create_bd_pin -dir I -type clk CLK
  create_bd_pin -dir O -from 10 -to 0 -type data S
  create_bd_pin -dir I -from 10 -to 0 -type data sum

  # Create instance: abs_b, and set properties
  set abs_b [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_addsub:12.0 abs_b ]
  set_property -dict [ list \
   CONFIG.A_Type {Signed} \
   CONFIG.A_Width {2} \
   CONFIG.Add_Mode {Subtract} \
   CONFIG.B_Type {Signed} \
   CONFIG.B_Value {00000000000} \
   CONFIG.B_Width {11} \
   CONFIG.Bypass {true} \
   CONFIG.Bypass_Sense {Active_Low} \
   CONFIG.CE {false} \
   CONFIG.Latency {1} \
   CONFIG.Latency_Configuration {Automatic} \
   CONFIG.Out_Width {11} \
 ] $abs_b

  # Create port connections
  connect_bd_net -net CLK_1 [get_bd_pins CLK] [get_bd_pins abs_b/CLK]
  connect_bd_net -net abs_sum_abs_sum [get_bd_pins S] [get_bd_pins abs_b/S]
  connect_bd_net -net dgfilter1_sum [get_bd_pins sum] [get_bd_pins abs_b/B]
  connect_bd_net -net xlconstant_0_dout [get_bd_pins A] [get_bd_pins abs_b/A]
  connect_bd_net -net xlslice_0_Dout [get_bd_pins BYPASS] [get_bd_pins abs_b/BYPASS]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: stage2_1
proc create_hier_cell_stage2_1 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_stage2_1() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins

  # Create pins
  create_bd_pin -dir I -type clk CLK
  create_bd_pin -dir I -from 10 -to 0 -type data abs_sum
  create_bd_pin -dir O -from 10 -to 0 -type data abs_sum_d
  create_bd_pin -dir O -from 10 -to 0 -type data cmp
  create_bd_pin -dir I -from 10 -to 0 -type data threshold

  # Create instance: cmp, and set properties
  set cmp [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_addsub:12.0 cmp ]
  set_property -dict [ list \
   CONFIG.A_Type {Signed} \
   CONFIG.A_Width {11} \
   CONFIG.Add_Mode {Subtract} \
   CONFIG.B_Type {Signed} \
   CONFIG.B_Value {00000000000} \
   CONFIG.B_Width {11} \
   CONFIG.CE {false} \
   CONFIG.Latency {1} \
   CONFIG.Latency_Configuration {Automatic} \
   CONFIG.Out_Width {11} \
 ] $cmp

  # Create instance: tap_1_abs, and set properties
  set tap_1_abs [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 tap_1_abs ]
  set_property -dict [ list \
   CONFIG.AsyncInitVal {00000000000} \
   CONFIG.DefaultData {00000000000} \
   CONFIG.Depth {1} \
   CONFIG.SyncInitVal {00000000000} \
   CONFIG.Width {11} \
 ] $tap_1_abs

  # Create port connections
  connect_bd_net -net CLK_1 [get_bd_pins CLK] [get_bd_pins cmp/CLK] [get_bd_pins tap_1_abs/CLK]
  connect_bd_net -net abs_sum_abs_sum [get_bd_pins abs_sum] [get_bd_pins cmp/B] [get_bd_pins tap_1_abs/D]
  connect_bd_net -net c_addsub_0_S [get_bd_pins cmp] [get_bd_pins cmp/S]
  connect_bd_net -net pad_signed_dout [get_bd_pins threshold] [get_bd_pins cmp/A]
  connect_bd_net -net tap_1_abs_Q [get_bd_pins abs_sum_d] [get_bd_pins tap_1_abs/Q]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: stage1_1
proc create_hier_cell_stage1_1 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_stage1_1() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins

  # Create pins
  create_bd_pin -dir I -from 1 -to 0 -type data A
  create_bd_pin -dir I -type data BYPASS
  create_bd_pin -dir I -type clk CLK
  create_bd_pin -dir O -from 10 -to 0 -type data S
  create_bd_pin -dir I -from 10 -to 0 -type data sum

  # Create instance: abs_b, and set properties
  set abs_b [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_addsub:12.0 abs_b ]
  set_property -dict [ list \
   CONFIG.A_Type {Signed} \
   CONFIG.A_Width {2} \
   CONFIG.Add_Mode {Subtract} \
   CONFIG.B_Type {Signed} \
   CONFIG.B_Value {00000000000} \
   CONFIG.B_Width {11} \
   CONFIG.Bypass {true} \
   CONFIG.Bypass_Sense {Active_Low} \
   CONFIG.CE {false} \
   CONFIG.Latency {1} \
   CONFIG.Latency_Configuration {Automatic} \
   CONFIG.Out_Width {11} \
 ] $abs_b

  # Create port connections
  connect_bd_net -net CLK_1 [get_bd_pins CLK] [get_bd_pins abs_b/CLK]
  connect_bd_net -net abs_sum_abs_sum [get_bd_pins S] [get_bd_pins abs_b/S]
  connect_bd_net -net dgfilter1_sum [get_bd_pins sum] [get_bd_pins abs_b/B]
  connect_bd_net -net xlconstant_0_dout [get_bd_pins A] [get_bd_pins abs_b/A]
  connect_bd_net -net xlslice_0_Dout [get_bd_pins BYPASS] [get_bd_pins abs_b/BYPASS]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: slice1
proc create_hier_cell_slice1 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_slice1() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins

  # Create pins
  create_bd_pin -dir I -from 23 -to 0 Din
  create_bd_pin -dir O -from 0 -to 0 lsnz
  create_bd_pin -dir O -from 10 -to 0 lsw
  create_bd_pin -dir O -from 0 -to 0 msnz
  create_bd_pin -dir O -from 10 -to 0 msw

  # Create instance: xlslice_0, and set properties
  set xlslice_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_0 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {10} \
   CONFIG.DIN_TO {0} \
   CONFIG.DIN_WIDTH {24} \
   CONFIG.DOUT_WIDTH {11} \
 ] $xlslice_0

  # Create instance: xlslice_1, and set properties
  set xlslice_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_1 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {22} \
   CONFIG.DIN_TO {12} \
   CONFIG.DIN_WIDTH {24} \
   CONFIG.DOUT_WIDTH {11} \
 ] $xlslice_1

  # Create instance: xlslice_2, and set properties
  set xlslice_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_2 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {11} \
   CONFIG.DIN_TO {11} \
   CONFIG.DIN_WIDTH {24} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_2

  # Create instance: xlslice_3, and set properties
  set xlslice_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_3 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {23} \
   CONFIG.DIN_TO {23} \
   CONFIG.DIN_WIDTH {24} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_3

  # Create port connections
  connect_bd_net -net Din_1 [get_bd_pins Din] [get_bd_pins xlslice_0/Din] [get_bd_pins xlslice_1/Din] [get_bd_pins xlslice_2/Din] [get_bd_pins xlslice_3/Din]
  connect_bd_net -net xlslice_0_Dout [get_bd_pins lsw] [get_bd_pins xlslice_0/Dout]
  connect_bd_net -net xlslice_1_Dout [get_bd_pins msw] [get_bd_pins xlslice_1/Dout]
  connect_bd_net -net xlslice_2_Dout [get_bd_pins lsnz] [get_bd_pins xlslice_2/Dout]
  connect_bd_net -net xlslice_3_Dout [get_bd_pins msnz] [get_bd_pins xlslice_3/Dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: slice0
proc create_hier_cell_slice0 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_slice0() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins

  # Create pins
  create_bd_pin -dir I -from 23 -to 0 Din
  create_bd_pin -dir O -from 0 -to 0 lsnz
  create_bd_pin -dir O -from 10 -to 0 lsw
  create_bd_pin -dir O -from 0 -to 0 msnz
  create_bd_pin -dir O -from 10 -to 0 msw

  # Create instance: xlslice_0, and set properties
  set xlslice_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_0 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {10} \
   CONFIG.DIN_TO {0} \
   CONFIG.DIN_WIDTH {24} \
   CONFIG.DOUT_WIDTH {11} \
 ] $xlslice_0

  # Create instance: xlslice_1, and set properties
  set xlslice_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_1 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {22} \
   CONFIG.DIN_TO {12} \
   CONFIG.DIN_WIDTH {24} \
   CONFIG.DOUT_WIDTH {11} \
 ] $xlslice_1

  # Create instance: xlslice_2, and set properties
  set xlslice_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_2 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {11} \
   CONFIG.DIN_TO {11} \
   CONFIG.DIN_WIDTH {24} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_2

  # Create instance: xlslice_3, and set properties
  set xlslice_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_3 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {23} \
   CONFIG.DIN_TO {23} \
   CONFIG.DIN_WIDTH {24} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_3

  # Create port connections
  connect_bd_net -net Din_1 [get_bd_pins Din] [get_bd_pins xlslice_0/Din] [get_bd_pins xlslice_1/Din] [get_bd_pins xlslice_2/Din] [get_bd_pins xlslice_3/Din]
  connect_bd_net -net xlslice_0_Dout [get_bd_pins lsw] [get_bd_pins xlslice_0/Dout]
  connect_bd_net -net xlslice_1_Dout [get_bd_pins msw] [get_bd_pins xlslice_1/Dout]
  connect_bd_net -net xlslice_2_Dout [get_bd_pins lsnz] [get_bd_pins xlslice_2/Dout]
  connect_bd_net -net xlslice_3_Dout [get_bd_pins msnz] [get_bd_pins xlslice_3/Dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: control
proc create_hier_cell_control { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_control() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins

  # Create pins
  create_bd_pin -dir I -type clk CLK
  create_bd_pin -dir O -from 0 -to 0 in2out
  create_bd_pin -dir O -from 0 -to 0 keep
  create_bd_pin -dir I -from 0 -to 0 y1_nz
  create_bd_pin -dir I -from 0 -to 0 y2_nz

  # Create instance: in2out, and set properties
  set in2out [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 in2out ]
  set_property -dict [ list \
   CONFIG.C_SIZE {1} \
 ] $in2out

  # Create instance: in_region, and set properties
  set in_region [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 in_region ]
  set_property -dict [ list \
   CONFIG.C_OPERATION {or} \
   CONFIG.C_SIZE {1} \
   CONFIG.LOGO_FILE {data/sym_orgate.png} \
 ] $in_region

  # Create instance: out_region, and set properties
  set out_region [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 out_region ]
  set_property -dict [ list \
   CONFIG.C_OPERATION {not} \
   CONFIG.C_SIZE {1} \
   CONFIG.LOGO_FILE {data/sym_notgate.png} \
 ] $out_region

  # Create instance: previous_in, and set properties
  set previous_in [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 previous_in ]
  set_property -dict [ list \
   CONFIG.AsyncInitVal {0} \
   CONFIG.DefaultData {0} \
   CONFIG.Depth {1} \
   CONFIG.SyncInitVal {0} \
   CONFIG.Width {1} \
 ] $previous_in

  # Create port connections
  connect_bd_net -net CLK_1 [get_bd_pins CLK] [get_bd_pins previous_in/CLK]
  connect_bd_net -net in2out_Res [get_bd_pins in2out] [get_bd_pins in2out/Res]
  connect_bd_net -net previous_in_Q [get_bd_pins in2out/Op1] [get_bd_pins previous_in/Q]
  connect_bd_net -net slice0_lsnz [get_bd_pins y1_nz] [get_bd_pins in_region/Op2]
  connect_bd_net -net slice1_msnz [get_bd_pins y2_nz] [get_bd_pins in_region/Op1]
  connect_bd_net -net util_vector_logic_4_Res [get_bd_pins in2out/Op2] [get_bd_pins out_region/Res]
  connect_bd_net -net util_vector_logic_5_Res [get_bd_pins keep] [get_bd_pins in_region/Res] [get_bd_pins out_region/Op1] [get_bd_pins previous_in/D]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: threshold1
proc create_hier_cell_threshold1 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_threshold1() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins

  # Create pins
  create_bd_pin -dir I CLK
  create_bd_pin -dir O -from 10 -to 0 abs_value
  create_bd_pin -dir O -from 0 -to 0 nz
  create_bd_pin -dir I -from 10 -to 0 -type data sum
  create_bd_pin -dir I -from 9 -to 0 threshold

  # Create instance: n_bit, and set properties
  set n_bit [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 n_bit ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {10} \
   CONFIG.DIN_TO {10} \
   CONFIG.DIN_WIDTH {11} \
   CONFIG.DOUT_WIDTH {1} \
 ] $n_bit

  # Create instance: pad_signed, and set properties
  set pad_signed [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 pad_signed ]
  set_property -dict [ list \
   CONFIG.IN0_WIDTH {10} \
 ] $pad_signed

  # Create instance: sign_bit, and set properties
  set sign_bit [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 sign_bit ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {10} \
   CONFIG.DIN_TO {10} \
   CONFIG.DIN_WIDTH {11} \
   CONFIG.DOUT_WIDTH {1} \
 ] $sign_bit

  # Create instance: stage1_1
  create_hier_cell_stage1_1_1 $hier_obj stage1_1

  # Create instance: stage2_1
  create_hier_cell_stage2_1_1 $hier_obj stage2_1

  # Create instance: zero, and set properties
  set zero [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 zero ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
   CONFIG.CONST_WIDTH {2} \
 ] $zero

  # Create instance: zero_1, and set properties
  set zero_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 zero_1 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
 ] $zero_1

  # Create port connections
  connect_bd_net -net CLK_1 [get_bd_pins CLK] [get_bd_pins stage1_1/CLK] [get_bd_pins stage2_1/CLK]
  connect_bd_net -net abs_sum_abs_sum [get_bd_pins stage1_1/S] [get_bd_pins stage2_1/abs_sum]
  connect_bd_net -net c_addsub_0_S [get_bd_pins n_bit/Din] [get_bd_pins stage2_1/cmp]
  connect_bd_net -net dgfilter1_sum [get_bd_pins sum] [get_bd_pins sign_bit/Din] [get_bd_pins stage1_1/sum]
  connect_bd_net -net n_bit_Dout [get_bd_pins nz] [get_bd_pins n_bit/Dout]
  connect_bd_net -net pad_signed_dout [get_bd_pins pad_signed/dout] [get_bd_pins stage2_1/threshold]
  connect_bd_net -net stage2_1_abs_sum_d [get_bd_pins abs_value] [get_bd_pins stage2_1/abs_sum_d]
  connect_bd_net -net threshold_1 [get_bd_pins threshold] [get_bd_pins pad_signed/In0]
  connect_bd_net -net xlconstant_0_dout [get_bd_pins stage1_1/A] [get_bd_pins zero/dout]
  connect_bd_net -net xlslice_0_Dout [get_bd_pins sign_bit/Dout] [get_bd_pins stage1_1/BYPASS]
  connect_bd_net -net zero_dout [get_bd_pins pad_signed/In1] [get_bd_pins zero_1/dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: threshold0
proc create_hier_cell_threshold0 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_threshold0() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins

  # Create pins
  create_bd_pin -dir I CLK
  create_bd_pin -dir O -from 10 -to 0 abs_value
  create_bd_pin -dir O -from 0 -to 0 nz
  create_bd_pin -dir I -from 10 -to 0 -type data sum
  create_bd_pin -dir I -from 9 -to 0 threshold

  # Create instance: n_bit, and set properties
  set n_bit [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 n_bit ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {10} \
   CONFIG.DIN_TO {10} \
   CONFIG.DIN_WIDTH {11} \
   CONFIG.DOUT_WIDTH {1} \
 ] $n_bit

  # Create instance: pad_signed, and set properties
  set pad_signed [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 pad_signed ]
  set_property -dict [ list \
   CONFIG.IN0_WIDTH {10} \
 ] $pad_signed

  # Create instance: sign_bit, and set properties
  set sign_bit [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 sign_bit ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {10} \
   CONFIG.DIN_TO {10} \
   CONFIG.DIN_WIDTH {11} \
   CONFIG.DOUT_WIDTH {1} \
 ] $sign_bit

  # Create instance: stage1_1
  create_hier_cell_stage1_1 $hier_obj stage1_1

  # Create instance: stage2_1
  create_hier_cell_stage2_1 $hier_obj stage2_1

  # Create instance: zero, and set properties
  set zero [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 zero ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
   CONFIG.CONST_WIDTH {2} \
 ] $zero

  # Create instance: zero_1, and set properties
  set zero_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 zero_1 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
 ] $zero_1

  # Create port connections
  connect_bd_net -net CLK_1 [get_bd_pins CLK] [get_bd_pins stage1_1/CLK] [get_bd_pins stage2_1/CLK]
  connect_bd_net -net abs_sum_abs_sum [get_bd_pins stage1_1/S] [get_bd_pins stage2_1/abs_sum]
  connect_bd_net -net c_addsub_0_S [get_bd_pins n_bit/Din] [get_bd_pins stage2_1/cmp]
  connect_bd_net -net dgfilter1_sum [get_bd_pins sum] [get_bd_pins sign_bit/Din] [get_bd_pins stage1_1/sum]
  connect_bd_net -net n_bit_Dout [get_bd_pins nz] [get_bd_pins n_bit/Dout]
  connect_bd_net -net pad_signed_dout [get_bd_pins pad_signed/dout] [get_bd_pins stage2_1/threshold]
  connect_bd_net -net stage2_1_abs_sum_d [get_bd_pins abs_value] [get_bd_pins stage2_1/abs_sum_d]
  connect_bd_net -net threshold_1 [get_bd_pins threshold] [get_bd_pins pad_signed/In0]
  connect_bd_net -net xlconstant_0_dout [get_bd_pins stage1_1/A] [get_bd_pins zero/dout]
  connect_bd_net -net xlslice_0_Dout [get_bd_pins sign_bit/Dout] [get_bd_pins stage1_1/BYPASS]
  connect_bd_net -net zero_dout [get_bd_pins pad_signed/In1] [get_bd_pins zero_1/dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: tap_2
proc create_hier_cell_tap_2 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_tap_2() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins

  # Create pins
  create_bd_pin -dir I -type clk CLK
  create_bd_pin -dir I -from 0 -to 0 -type data last_in
  create_bd_pin -dir O -from 0 -to 0 -type data last_out
  create_bd_pin -dir I -from 0 -to 0 -type data user_in
  create_bd_pin -dir O -from 0 -to 0 -type data user_out
  create_bd_pin -dir I -from 0 -to 0 -type data valid_in
  create_bd_pin -dir O -from 0 -to 0 -type data valid_out

  # Create instance: tap_2_last, and set properties
  set tap_2_last [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 tap_2_last ]
  set_property -dict [ list \
   CONFIG.AsyncInitVal {0} \
   CONFIG.DefaultData {0} \
   CONFIG.Depth {2} \
   CONFIG.SyncInitVal {0} \
   CONFIG.Width {1} \
 ] $tap_2_last

  # Create instance: tap_2_user, and set properties
  set tap_2_user [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 tap_2_user ]
  set_property -dict [ list \
   CONFIG.AsyncInitVal {0} \
   CONFIG.DefaultData {0} \
   CONFIG.Depth {2} \
   CONFIG.SyncInitVal {0} \
   CONFIG.Width {1} \
 ] $tap_2_user

  # Create instance: tap_2_valid, and set properties
  set tap_2_valid [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 tap_2_valid ]
  set_property -dict [ list \
   CONFIG.AsyncInitVal {0} \
   CONFIG.DefaultData {0} \
   CONFIG.Depth {2} \
   CONFIG.SyncInitVal {0} \
   CONFIG.Width {1} \
 ] $tap_2_valid

  # Create port connections
  connect_bd_net -net CLK_1 [get_bd_pins CLK] [get_bd_pins tap_2_last/CLK] [get_bd_pins tap_2_user/CLK] [get_bd_pins tap_2_valid/CLK]
  connect_bd_net -net last_in_1 [get_bd_pins last_in] [get_bd_pins tap_2_last/D]
  connect_bd_net -net sof_in_1 [get_bd_pins user_in] [get_bd_pins tap_2_user/D]
  connect_bd_net -net tap_2_last_Q [get_bd_pins last_out] [get_bd_pins tap_2_last/Q]
  connect_bd_net -net tap_2_sof_Q [get_bd_pins user_out] [get_bd_pins tap_2_user/Q]
  connect_bd_net -net tap_2_valid_Q [get_bd_pins valid_out] [get_bd_pins tap_2_valid/Q]
  connect_bd_net -net valid_in_1 [get_bd_pins valid_in] [get_bd_pins tap_2_valid/D]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: slice
proc create_hier_cell_slice { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_slice() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins

  # Create pins
  create_bd_pin -dir I -from 21 -to 0 Din
  create_bd_pin -dir O -from 10 -to 0 lsw
  create_bd_pin -dir O -from 10 -to 0 msw

  # Create instance: xlslice_0, and set properties
  set xlslice_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_0 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {10} \
   CONFIG.DIN_TO {0} \
   CONFIG.DIN_WIDTH {22} \
   CONFIG.DOUT_WIDTH {11} \
 ] $xlslice_0

  # Create instance: xlslice_1, and set properties
  set xlslice_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_1 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {21} \
   CONFIG.DIN_TO {11} \
   CONFIG.DIN_WIDTH {22} \
   CONFIG.DOUT_WIDTH {11} \
 ] $xlslice_1

  # Create port connections
  connect_bd_net -net Din_1 [get_bd_pins Din] [get_bd_pins xlslice_0/Din] [get_bd_pins xlslice_1/Din]
  connect_bd_net -net xlslice_0_Dout [get_bd_pins lsw] [get_bd_pins xlslice_0/Dout]
  connect_bd_net -net xlslice_1_Dout [get_bd_pins msw] [get_bd_pins xlslice_1/Dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: mux_ymaxcol
proc create_hier_cell_mux_ymaxcol { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_mux_ymaxcol() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins

  # Create pins
  create_bd_pin -dir O -from 11 -to 0 Res
  create_bd_pin -dir I -from 11 -to 0 i0
  create_bd_pin -dir I -from 11 -to 0 i1
  create_bd_pin -dir I -from 0 -to 0 sel

  # Create instance: util_vector_logic_0, and set properties
  set util_vector_logic_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_0 ]
  set_property -dict [ list \
   CONFIG.C_SIZE {12} \
 ] $util_vector_logic_0

  # Create instance: util_vector_logic_1, and set properties
  set util_vector_logic_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_1 ]
  set_property -dict [ list \
   CONFIG.C_SIZE {12} \
 ] $util_vector_logic_1

  # Create instance: util_vector_logic_2, and set properties
  set util_vector_logic_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_2 ]
  set_property -dict [ list \
   CONFIG.C_OPERATION {not} \
   CONFIG.C_SIZE {1} \
   CONFIG.LOGO_FILE {data/sym_notgate.png} \
 ] $util_vector_logic_2

  # Create instance: util_vector_logic_3, and set properties
  set util_vector_logic_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_3 ]
  set_property -dict [ list \
   CONFIG.C_OPERATION {or} \
   CONFIG.C_SIZE {12} \
   CONFIG.LOGO_FILE {data/sym_orgate.png} \
 ] $util_vector_logic_3

  # Create instance: xlconcat_0, and set properties
  set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]
  set_property -dict [ list \
   CONFIG.IN0_WIDTH {1} \
   CONFIG.IN10_WIDTH {1} \
   CONFIG.IN11_WIDTH {1} \
   CONFIG.IN1_WIDTH {1} \
   CONFIG.IN2_WIDTH {1} \
   CONFIG.IN3_WIDTH {1} \
   CONFIG.IN4_WIDTH {1} \
   CONFIG.IN5_WIDTH {1} \
   CONFIG.IN6_WIDTH {1} \
   CONFIG.IN7_WIDTH {1} \
   CONFIG.IN8_WIDTH {1} \
   CONFIG.IN9_WIDTH {1} \
   CONFIG.NUM_PORTS {12} \
 ] $xlconcat_0

  # Create instance: xlconcat_1, and set properties
  set xlconcat_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_1 ]
  set_property -dict [ list \
   CONFIG.IN0_WIDTH {1} \
   CONFIG.IN10_WIDTH {1} \
   CONFIG.IN1_WIDTH {1} \
   CONFIG.IN2_WIDTH {1} \
   CONFIG.IN3_WIDTH {1} \
   CONFIG.IN4_WIDTH {1} \
   CONFIG.IN5_WIDTH {1} \
   CONFIG.IN6_WIDTH {1} \
   CONFIG.IN7_WIDTH {1} \
   CONFIG.IN8_WIDTH {1} \
   CONFIG.IN9_WIDTH {1} \
   CONFIG.NUM_PORTS {12} \
 ] $xlconcat_1

  # Create port connections
  connect_bd_net -net i0_1 [get_bd_pins i0] [get_bd_pins util_vector_logic_1/Op1]
  connect_bd_net -net i1_1 [get_bd_pins i1] [get_bd_pins util_vector_logic_0/Op1]
  connect_bd_net -net sub_y2y1_S [get_bd_pins sel] [get_bd_pins util_vector_logic_2/Op1] [get_bd_pins xlconcat_0/In0] [get_bd_pins xlconcat_0/In1] [get_bd_pins xlconcat_0/In2] [get_bd_pins xlconcat_0/In3] [get_bd_pins xlconcat_0/In4] [get_bd_pins xlconcat_0/In5] [get_bd_pins xlconcat_0/In6] [get_bd_pins xlconcat_0/In7] [get_bd_pins xlconcat_0/In8] [get_bd_pins xlconcat_0/In9] [get_bd_pins xlconcat_0/In10] [get_bd_pins xlconcat_0/In11]
  connect_bd_net -net util_vector_logic_0_Res [get_bd_pins util_vector_logic_0/Res] [get_bd_pins util_vector_logic_3/Op1]
  connect_bd_net -net util_vector_logic_1_Res [get_bd_pins util_vector_logic_1/Res] [get_bd_pins util_vector_logic_3/Op2]
  connect_bd_net -net util_vector_logic_2_Res [get_bd_pins util_vector_logic_2/Res] [get_bd_pins xlconcat_1/In0] [get_bd_pins xlconcat_1/In1] [get_bd_pins xlconcat_1/In2] [get_bd_pins xlconcat_1/In3] [get_bd_pins xlconcat_1/In4] [get_bd_pins xlconcat_1/In5] [get_bd_pins xlconcat_1/In6] [get_bd_pins xlconcat_1/In7] [get_bd_pins xlconcat_1/In8] [get_bd_pins xlconcat_1/In9] [get_bd_pins xlconcat_1/In10] [get_bd_pins xlconcat_1/In11]
  connect_bd_net -net util_vector_logic_3_Res [get_bd_pins Res] [get_bd_pins util_vector_logic_3/Res]
  connect_bd_net -net xlconcat_0_dout [get_bd_pins util_vector_logic_0/Op2] [get_bd_pins xlconcat_0/dout]
  connect_bd_net -net xlconcat_1_dout [get_bd_pins util_vector_logic_1/Op2] [get_bd_pins xlconcat_1/dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: mux_ymaxR
proc create_hier_cell_mux_ymaxR { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_mux_ymaxR() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins

  # Create pins
  create_bd_pin -dir O -from 10 -to 0 Res
  create_bd_pin -dir I -from 10 -to 0 i0
  create_bd_pin -dir I -from 10 -to 0 i1
  create_bd_pin -dir I -from 0 -to 0 sel

  # Create instance: util_vector_logic_0, and set properties
  set util_vector_logic_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_0 ]
  set_property -dict [ list \
   CONFIG.C_SIZE {11} \
 ] $util_vector_logic_0

  # Create instance: util_vector_logic_1, and set properties
  set util_vector_logic_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_1 ]
  set_property -dict [ list \
   CONFIG.C_SIZE {11} \
 ] $util_vector_logic_1

  # Create instance: util_vector_logic_2, and set properties
  set util_vector_logic_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_2 ]
  set_property -dict [ list \
   CONFIG.C_OPERATION {not} \
   CONFIG.C_SIZE {1} \
   CONFIG.LOGO_FILE {data/sym_notgate.png} \
 ] $util_vector_logic_2

  # Create instance: util_vector_logic_3, and set properties
  set util_vector_logic_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_3 ]
  set_property -dict [ list \
   CONFIG.C_OPERATION {or} \
   CONFIG.C_SIZE {11} \
   CONFIG.LOGO_FILE {data/sym_orgate.png} \
 ] $util_vector_logic_3

  # Create instance: xlconcat_0, and set properties
  set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]
  set_property -dict [ list \
   CONFIG.IN0_WIDTH {1} \
   CONFIG.IN10_WIDTH {1} \
   CONFIG.IN1_WIDTH {1} \
   CONFIG.IN2_WIDTH {1} \
   CONFIG.IN3_WIDTH {1} \
   CONFIG.IN4_WIDTH {1} \
   CONFIG.IN5_WIDTH {1} \
   CONFIG.IN6_WIDTH {1} \
   CONFIG.IN7_WIDTH {1} \
   CONFIG.IN8_WIDTH {1} \
   CONFIG.IN9_WIDTH {1} \
   CONFIG.NUM_PORTS {11} \
 ] $xlconcat_0

  # Create instance: xlconcat_1, and set properties
  set xlconcat_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_1 ]
  set_property -dict [ list \
   CONFIG.IN0_WIDTH {1} \
   CONFIG.IN10_WIDTH {1} \
   CONFIG.IN1_WIDTH {1} \
   CONFIG.IN2_WIDTH {1} \
   CONFIG.IN3_WIDTH {1} \
   CONFIG.IN4_WIDTH {1} \
   CONFIG.IN5_WIDTH {1} \
   CONFIG.IN6_WIDTH {1} \
   CONFIG.IN7_WIDTH {1} \
   CONFIG.IN8_WIDTH {1} \
   CONFIG.IN9_WIDTH {1} \
   CONFIG.NUM_PORTS {11} \
 ] $xlconcat_1

  # Create port connections
  connect_bd_net -net slice0_lsw [get_bd_pins i0] [get_bd_pins util_vector_logic_1/Op1]
  connect_bd_net -net slice1_msw [get_bd_pins i1] [get_bd_pins util_vector_logic_0/Op1]
  connect_bd_net -net sub_y2y1_S [get_bd_pins sel] [get_bd_pins util_vector_logic_2/Op1] [get_bd_pins xlconcat_0/In0] [get_bd_pins xlconcat_0/In1] [get_bd_pins xlconcat_0/In2] [get_bd_pins xlconcat_0/In3] [get_bd_pins xlconcat_0/In4] [get_bd_pins xlconcat_0/In5] [get_bd_pins xlconcat_0/In6] [get_bd_pins xlconcat_0/In7] [get_bd_pins xlconcat_0/In8] [get_bd_pins xlconcat_0/In9] [get_bd_pins xlconcat_0/In10]
  connect_bd_net -net util_vector_logic_0_Res [get_bd_pins util_vector_logic_0/Res] [get_bd_pins util_vector_logic_3/Op1]
  connect_bd_net -net util_vector_logic_1_Res [get_bd_pins util_vector_logic_1/Res] [get_bd_pins util_vector_logic_3/Op2]
  connect_bd_net -net util_vector_logic_2_Res [get_bd_pins util_vector_logic_2/Res] [get_bd_pins xlconcat_1/In0] [get_bd_pins xlconcat_1/In1] [get_bd_pins xlconcat_1/In2] [get_bd_pins xlconcat_1/In3] [get_bd_pins xlconcat_1/In4] [get_bd_pins xlconcat_1/In5] [get_bd_pins xlconcat_1/In6] [get_bd_pins xlconcat_1/In7] [get_bd_pins xlconcat_1/In8] [get_bd_pins xlconcat_1/In9] [get_bd_pins xlconcat_1/In10]
  connect_bd_net -net util_vector_logic_3_Res [get_bd_pins Res] [get_bd_pins util_vector_logic_3/Res]
  connect_bd_net -net xlconcat_0_dout [get_bd_pins util_vector_logic_0/Op2] [get_bd_pins xlconcat_0/dout]
  connect_bd_net -net xlconcat_1_dout [get_bd_pins util_vector_logic_1/Op2] [get_bd_pins xlconcat_1/dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: mux_ymaxL
proc create_hier_cell_mux_ymaxL { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_mux_ymaxL() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins

  # Create pins
  create_bd_pin -dir O -from 10 -to 0 Res
  create_bd_pin -dir I -from 10 -to 0 i0
  create_bd_pin -dir I -from 10 -to 0 i1
  create_bd_pin -dir I -from 0 -to 0 sel

  # Create instance: util_vector_logic_0, and set properties
  set util_vector_logic_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_0 ]
  set_property -dict [ list \
   CONFIG.C_SIZE {11} \
 ] $util_vector_logic_0

  # Create instance: util_vector_logic_1, and set properties
  set util_vector_logic_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_1 ]
  set_property -dict [ list \
   CONFIG.C_SIZE {11} \
 ] $util_vector_logic_1

  # Create instance: util_vector_logic_2, and set properties
  set util_vector_logic_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_2 ]
  set_property -dict [ list \
   CONFIG.C_OPERATION {not} \
   CONFIG.C_SIZE {1} \
   CONFIG.LOGO_FILE {data/sym_notgate.png} \
 ] $util_vector_logic_2

  # Create instance: util_vector_logic_3, and set properties
  set util_vector_logic_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_3 ]
  set_property -dict [ list \
   CONFIG.C_OPERATION {or} \
   CONFIG.C_SIZE {11} \
   CONFIG.LOGO_FILE {data/sym_orgate.png} \
 ] $util_vector_logic_3

  # Create instance: xlconcat_0, and set properties
  set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]
  set_property -dict [ list \
   CONFIG.IN0_WIDTH {1} \
   CONFIG.IN10_WIDTH {1} \
   CONFIG.IN1_WIDTH {1} \
   CONFIG.IN2_WIDTH {1} \
   CONFIG.IN3_WIDTH {1} \
   CONFIG.IN4_WIDTH {1} \
   CONFIG.IN5_WIDTH {1} \
   CONFIG.IN6_WIDTH {1} \
   CONFIG.IN7_WIDTH {1} \
   CONFIG.IN8_WIDTH {1} \
   CONFIG.IN9_WIDTH {1} \
   CONFIG.NUM_PORTS {11} \
 ] $xlconcat_0

  # Create instance: xlconcat_1, and set properties
  set xlconcat_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_1 ]
  set_property -dict [ list \
   CONFIG.IN0_WIDTH {1} \
   CONFIG.IN10_WIDTH {1} \
   CONFIG.IN1_WIDTH {1} \
   CONFIG.IN2_WIDTH {1} \
   CONFIG.IN3_WIDTH {1} \
   CONFIG.IN4_WIDTH {1} \
   CONFIG.IN5_WIDTH {1} \
   CONFIG.IN6_WIDTH {1} \
   CONFIG.IN7_WIDTH {1} \
   CONFIG.IN8_WIDTH {1} \
   CONFIG.IN9_WIDTH {1} \
   CONFIG.NUM_PORTS {11} \
 ] $xlconcat_1

  # Create port connections
  connect_bd_net -net slice0_lsw [get_bd_pins i0] [get_bd_pins util_vector_logic_1/Op1]
  connect_bd_net -net slice1_msw [get_bd_pins i1] [get_bd_pins util_vector_logic_0/Op1]
  connect_bd_net -net sub_y2y1_S [get_bd_pins sel] [get_bd_pins util_vector_logic_2/Op1] [get_bd_pins xlconcat_0/In0] [get_bd_pins xlconcat_0/In1] [get_bd_pins xlconcat_0/In2] [get_bd_pins xlconcat_0/In3] [get_bd_pins xlconcat_0/In4] [get_bd_pins xlconcat_0/In5] [get_bd_pins xlconcat_0/In6] [get_bd_pins xlconcat_0/In7] [get_bd_pins xlconcat_0/In8] [get_bd_pins xlconcat_0/In9] [get_bd_pins xlconcat_0/In10]
  connect_bd_net -net util_vector_logic_0_Res [get_bd_pins util_vector_logic_0/Res] [get_bd_pins util_vector_logic_3/Op1]
  connect_bd_net -net util_vector_logic_1_Res [get_bd_pins util_vector_logic_1/Res] [get_bd_pins util_vector_logic_3/Op2]
  connect_bd_net -net util_vector_logic_2_Res [get_bd_pins util_vector_logic_2/Res] [get_bd_pins xlconcat_1/In0] [get_bd_pins xlconcat_1/In1] [get_bd_pins xlconcat_1/In2] [get_bd_pins xlconcat_1/In3] [get_bd_pins xlconcat_1/In4] [get_bd_pins xlconcat_1/In5] [get_bd_pins xlconcat_1/In6] [get_bd_pins xlconcat_1/In7] [get_bd_pins xlconcat_1/In8] [get_bd_pins xlconcat_1/In9] [get_bd_pins xlconcat_1/In10]
  connect_bd_net -net util_vector_logic_3_Res [get_bd_pins Res] [get_bd_pins util_vector_logic_3/Res]
  connect_bd_net -net xlconcat_0_dout [get_bd_pins util_vector_logic_0/Op2] [get_bd_pins xlconcat_0/dout]
  connect_bd_net -net xlconcat_1_dout [get_bd_pins util_vector_logic_1/Op2] [get_bd_pins xlconcat_1/dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: mux_ymax
proc create_hier_cell_mux_ymax { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_mux_ymax() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins

  # Create pins
  create_bd_pin -dir O -from 10 -to 0 Res
  create_bd_pin -dir I -from 10 -to 0 i0
  create_bd_pin -dir I -from 10 -to 0 i1
  create_bd_pin -dir I -from 0 -to 0 sel

  # Create instance: util_vector_logic_0, and set properties
  set util_vector_logic_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_0 ]
  set_property -dict [ list \
   CONFIG.C_SIZE {11} \
 ] $util_vector_logic_0

  # Create instance: util_vector_logic_1, and set properties
  set util_vector_logic_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_1 ]
  set_property -dict [ list \
   CONFIG.C_SIZE {11} \
 ] $util_vector_logic_1

  # Create instance: util_vector_logic_2, and set properties
  set util_vector_logic_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_2 ]
  set_property -dict [ list \
   CONFIG.C_OPERATION {not} \
   CONFIG.C_SIZE {1} \
   CONFIG.LOGO_FILE {data/sym_notgate.png} \
 ] $util_vector_logic_2

  # Create instance: util_vector_logic_3, and set properties
  set util_vector_logic_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_3 ]
  set_property -dict [ list \
   CONFIG.C_OPERATION {or} \
   CONFIG.C_SIZE {11} \
   CONFIG.LOGO_FILE {data/sym_orgate.png} \
 ] $util_vector_logic_3

  # Create instance: xlconcat_0, and set properties
  set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]
  set_property -dict [ list \
   CONFIG.IN0_WIDTH {1} \
   CONFIG.IN10_WIDTH {1} \
   CONFIG.IN1_WIDTH {1} \
   CONFIG.IN2_WIDTH {1} \
   CONFIG.IN3_WIDTH {1} \
   CONFIG.IN4_WIDTH {1} \
   CONFIG.IN5_WIDTH {1} \
   CONFIG.IN6_WIDTH {1} \
   CONFIG.IN7_WIDTH {1} \
   CONFIG.IN8_WIDTH {1} \
   CONFIG.IN9_WIDTH {1} \
   CONFIG.NUM_PORTS {11} \
 ] $xlconcat_0

  # Create instance: xlconcat_1, and set properties
  set xlconcat_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_1 ]
  set_property -dict [ list \
   CONFIG.IN0_WIDTH {1} \
   CONFIG.IN10_WIDTH {1} \
   CONFIG.IN1_WIDTH {1} \
   CONFIG.IN2_WIDTH {1} \
   CONFIG.IN3_WIDTH {1} \
   CONFIG.IN4_WIDTH {1} \
   CONFIG.IN5_WIDTH {1} \
   CONFIG.IN6_WIDTH {1} \
   CONFIG.IN7_WIDTH {1} \
   CONFIG.IN8_WIDTH {1} \
   CONFIG.IN9_WIDTH {1} \
   CONFIG.NUM_PORTS {11} \
 ] $xlconcat_1

  # Create port connections
  connect_bd_net -net slice0_lsw [get_bd_pins i0] [get_bd_pins util_vector_logic_1/Op1]
  connect_bd_net -net slice1_msw [get_bd_pins i1] [get_bd_pins util_vector_logic_0/Op1]
  connect_bd_net -net sub_y2y1_S [get_bd_pins sel] [get_bd_pins util_vector_logic_2/Op1] [get_bd_pins xlconcat_0/In0] [get_bd_pins xlconcat_0/In1] [get_bd_pins xlconcat_0/In2] [get_bd_pins xlconcat_0/In3] [get_bd_pins xlconcat_0/In4] [get_bd_pins xlconcat_0/In5] [get_bd_pins xlconcat_0/In6] [get_bd_pins xlconcat_0/In7] [get_bd_pins xlconcat_0/In8] [get_bd_pins xlconcat_0/In9] [get_bd_pins xlconcat_0/In10]
  connect_bd_net -net util_vector_logic_0_Res [get_bd_pins util_vector_logic_0/Res] [get_bd_pins util_vector_logic_3/Op1]
  connect_bd_net -net util_vector_logic_1_Res [get_bd_pins util_vector_logic_1/Res] [get_bd_pins util_vector_logic_3/Op2]
  connect_bd_net -net util_vector_logic_2_Res [get_bd_pins util_vector_logic_2/Res] [get_bd_pins xlconcat_1/In0] [get_bd_pins xlconcat_1/In1] [get_bd_pins xlconcat_1/In2] [get_bd_pins xlconcat_1/In3] [get_bd_pins xlconcat_1/In4] [get_bd_pins xlconcat_1/In5] [get_bd_pins xlconcat_1/In6] [get_bd_pins xlconcat_1/In7] [get_bd_pins xlconcat_1/In8] [get_bd_pins xlconcat_1/In9] [get_bd_pins xlconcat_1/In10]
  connect_bd_net -net util_vector_logic_3_Res [get_bd_pins Res] [get_bd_pins util_vector_logic_3/Res]
  connect_bd_net -net xlconcat_0_dout [get_bd_pins util_vector_logic_0/Op2] [get_bd_pins xlconcat_0/dout]
  connect_bd_net -net xlconcat_1_dout [get_bd_pins util_vector_logic_1/Op2] [get_bd_pins xlconcat_1/dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: mux_ycol
proc create_hier_cell_mux_ycol { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_mux_ycol() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins

  # Create pins
  create_bd_pin -dir O -from 11 -to 0 Res
  create_bd_pin -dir I -from 11 -to 0 i0
  create_bd_pin -dir I -from 11 -to 0 i1
  create_bd_pin -dir I -from 0 -to 0 sel

  # Create instance: util_vector_logic_0, and set properties
  set util_vector_logic_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_0 ]
  set_property -dict [ list \
   CONFIG.C_SIZE {12} \
 ] $util_vector_logic_0

  # Create instance: util_vector_logic_1, and set properties
  set util_vector_logic_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_1 ]
  set_property -dict [ list \
   CONFIG.C_SIZE {12} \
 ] $util_vector_logic_1

  # Create instance: util_vector_logic_2, and set properties
  set util_vector_logic_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_2 ]
  set_property -dict [ list \
   CONFIG.C_OPERATION {not} \
   CONFIG.C_SIZE {1} \
   CONFIG.LOGO_FILE {data/sym_notgate.png} \
 ] $util_vector_logic_2

  # Create instance: util_vector_logic_3, and set properties
  set util_vector_logic_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_3 ]
  set_property -dict [ list \
   CONFIG.C_OPERATION {or} \
   CONFIG.C_SIZE {12} \
   CONFIG.LOGO_FILE {data/sym_orgate.png} \
 ] $util_vector_logic_3

  # Create instance: xlconcat_0, and set properties
  set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]
  set_property -dict [ list \
   CONFIG.IN0_WIDTH {1} \
   CONFIG.IN10_WIDTH {1} \
   CONFIG.IN11_WIDTH {1} \
   CONFIG.IN1_WIDTH {1} \
   CONFIG.IN2_WIDTH {1} \
   CONFIG.IN3_WIDTH {1} \
   CONFIG.IN4_WIDTH {1} \
   CONFIG.IN5_WIDTH {1} \
   CONFIG.IN6_WIDTH {1} \
   CONFIG.IN7_WIDTH {1} \
   CONFIG.IN8_WIDTH {1} \
   CONFIG.IN9_WIDTH {1} \
   CONFIG.NUM_PORTS {12} \
 ] $xlconcat_0

  # Create instance: xlconcat_1, and set properties
  set xlconcat_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_1 ]
  set_property -dict [ list \
   CONFIG.IN0_WIDTH {1} \
   CONFIG.IN10_WIDTH {1} \
   CONFIG.IN1_WIDTH {1} \
   CONFIG.IN2_WIDTH {1} \
   CONFIG.IN3_WIDTH {1} \
   CONFIG.IN4_WIDTH {1} \
   CONFIG.IN5_WIDTH {1} \
   CONFIG.IN6_WIDTH {1} \
   CONFIG.IN7_WIDTH {1} \
   CONFIG.IN8_WIDTH {1} \
   CONFIG.IN9_WIDTH {1} \
   CONFIG.NUM_PORTS {12} \
 ] $xlconcat_1

  # Create port connections
  connect_bd_net -net i0_1 [get_bd_pins i0] [get_bd_pins util_vector_logic_1/Op1]
  connect_bd_net -net i1_1 [get_bd_pins i1] [get_bd_pins util_vector_logic_0/Op1]
  connect_bd_net -net sub_y2y1_S [get_bd_pins sel] [get_bd_pins util_vector_logic_2/Op1] [get_bd_pins xlconcat_0/In0] [get_bd_pins xlconcat_0/In1] [get_bd_pins xlconcat_0/In2] [get_bd_pins xlconcat_0/In3] [get_bd_pins xlconcat_0/In4] [get_bd_pins xlconcat_0/In5] [get_bd_pins xlconcat_0/In6] [get_bd_pins xlconcat_0/In7] [get_bd_pins xlconcat_0/In8] [get_bd_pins xlconcat_0/In9] [get_bd_pins xlconcat_0/In10] [get_bd_pins xlconcat_0/In11]
  connect_bd_net -net util_vector_logic_0_Res [get_bd_pins util_vector_logic_0/Res] [get_bd_pins util_vector_logic_3/Op1]
  connect_bd_net -net util_vector_logic_1_Res [get_bd_pins util_vector_logic_1/Res] [get_bd_pins util_vector_logic_3/Op2]
  connect_bd_net -net util_vector_logic_2_Res [get_bd_pins util_vector_logic_2/Res] [get_bd_pins xlconcat_1/In0] [get_bd_pins xlconcat_1/In1] [get_bd_pins xlconcat_1/In2] [get_bd_pins xlconcat_1/In3] [get_bd_pins xlconcat_1/In4] [get_bd_pins xlconcat_1/In5] [get_bd_pins xlconcat_1/In6] [get_bd_pins xlconcat_1/In7] [get_bd_pins xlconcat_1/In8] [get_bd_pins xlconcat_1/In9] [get_bd_pins xlconcat_1/In10] [get_bd_pins xlconcat_1/In11]
  connect_bd_net -net util_vector_logic_3_Res [get_bd_pins Res] [get_bd_pins util_vector_logic_3/Res]
  connect_bd_net -net xlconcat_0_dout [get_bd_pins util_vector_logic_0/Op2] [get_bd_pins xlconcat_0/dout]
  connect_bd_net -net xlconcat_1_dout [get_bd_pins util_vector_logic_1/Op2] [get_bd_pins xlconcat_1/dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: mux_y3y2
proc create_hier_cell_mux_y3y2 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_mux_y3y2() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins

  # Create pins
  create_bd_pin -dir O -from 10 -to 0 Res
  create_bd_pin -dir I -from 10 -to 0 i0
  create_bd_pin -dir I -from 10 -to 0 i1
  create_bd_pin -dir I -from 0 -to 0 sel

  # Create instance: util_vector_logic_0, and set properties
  set util_vector_logic_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_0 ]
  set_property -dict [ list \
   CONFIG.C_SIZE {11} \
 ] $util_vector_logic_0

  # Create instance: util_vector_logic_1, and set properties
  set util_vector_logic_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_1 ]
  set_property -dict [ list \
   CONFIG.C_SIZE {11} \
 ] $util_vector_logic_1

  # Create instance: util_vector_logic_2, and set properties
  set util_vector_logic_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_2 ]
  set_property -dict [ list \
   CONFIG.C_OPERATION {not} \
   CONFIG.C_SIZE {1} \
   CONFIG.LOGO_FILE {data/sym_notgate.png} \
 ] $util_vector_logic_2

  # Create instance: util_vector_logic_3, and set properties
  set util_vector_logic_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_3 ]
  set_property -dict [ list \
   CONFIG.C_OPERATION {or} \
   CONFIG.C_SIZE {11} \
   CONFIG.LOGO_FILE {data/sym_orgate.png} \
 ] $util_vector_logic_3

  # Create instance: xlconcat_0, and set properties
  set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]
  set_property -dict [ list \
   CONFIG.IN0_WIDTH {1} \
   CONFIG.IN10_WIDTH {1} \
   CONFIG.IN1_WIDTH {1} \
   CONFIG.IN2_WIDTH {1} \
   CONFIG.IN3_WIDTH {1} \
   CONFIG.IN4_WIDTH {1} \
   CONFIG.IN5_WIDTH {1} \
   CONFIG.IN6_WIDTH {1} \
   CONFIG.IN7_WIDTH {1} \
   CONFIG.IN8_WIDTH {1} \
   CONFIG.IN9_WIDTH {1} \
   CONFIG.NUM_PORTS {11} \
 ] $xlconcat_0

  # Create instance: xlconcat_1, and set properties
  set xlconcat_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_1 ]
  set_property -dict [ list \
   CONFIG.IN0_WIDTH {1} \
   CONFIG.IN10_WIDTH {1} \
   CONFIG.IN1_WIDTH {1} \
   CONFIG.IN2_WIDTH {1} \
   CONFIG.IN3_WIDTH {1} \
   CONFIG.IN4_WIDTH {1} \
   CONFIG.IN5_WIDTH {1} \
   CONFIG.IN6_WIDTH {1} \
   CONFIG.IN7_WIDTH {1} \
   CONFIG.IN8_WIDTH {1} \
   CONFIG.IN9_WIDTH {1} \
   CONFIG.NUM_PORTS {11} \
 ] $xlconcat_1

  # Create port connections
  connect_bd_net -net slice0_lsw [get_bd_pins i0] [get_bd_pins util_vector_logic_1/Op1]
  connect_bd_net -net slice1_msw [get_bd_pins i1] [get_bd_pins util_vector_logic_0/Op1]
  connect_bd_net -net sub_y2y1_S [get_bd_pins sel] [get_bd_pins util_vector_logic_2/Op1] [get_bd_pins xlconcat_0/In0] [get_bd_pins xlconcat_0/In1] [get_bd_pins xlconcat_0/In2] [get_bd_pins xlconcat_0/In3] [get_bd_pins xlconcat_0/In4] [get_bd_pins xlconcat_0/In5] [get_bd_pins xlconcat_0/In6] [get_bd_pins xlconcat_0/In7] [get_bd_pins xlconcat_0/In8] [get_bd_pins xlconcat_0/In9] [get_bd_pins xlconcat_0/In10]
  connect_bd_net -net util_vector_logic_0_Res [get_bd_pins util_vector_logic_0/Res] [get_bd_pins util_vector_logic_3/Op1]
  connect_bd_net -net util_vector_logic_1_Res [get_bd_pins util_vector_logic_1/Res] [get_bd_pins util_vector_logic_3/Op2]
  connect_bd_net -net util_vector_logic_2_Res [get_bd_pins util_vector_logic_2/Res] [get_bd_pins xlconcat_1/In0] [get_bd_pins xlconcat_1/In1] [get_bd_pins xlconcat_1/In2] [get_bd_pins xlconcat_1/In3] [get_bd_pins xlconcat_1/In4] [get_bd_pins xlconcat_1/In5] [get_bd_pins xlconcat_1/In6] [get_bd_pins xlconcat_1/In7] [get_bd_pins xlconcat_1/In8] [get_bd_pins xlconcat_1/In9] [get_bd_pins xlconcat_1/In10]
  connect_bd_net -net util_vector_logic_3_Res [get_bd_pins Res] [get_bd_pins util_vector_logic_3/Res]
  connect_bd_net -net xlconcat_0_dout [get_bd_pins util_vector_logic_0/Op2] [get_bd_pins xlconcat_0/dout]
  connect_bd_net -net xlconcat_1_dout [get_bd_pins util_vector_logic_1/Op2] [get_bd_pins xlconcat_1/dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: mux_y2y1
proc create_hier_cell_mux_y2y1 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_mux_y2y1() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins

  # Create pins
  create_bd_pin -dir O -from 10 -to 0 Res
  create_bd_pin -dir I -from 10 -to 0 i0
  create_bd_pin -dir I -from 10 -to 0 i1
  create_bd_pin -dir I -from 0 -to 0 sel

  # Create instance: util_vector_logic_0, and set properties
  set util_vector_logic_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_0 ]
  set_property -dict [ list \
   CONFIG.C_SIZE {11} \
 ] $util_vector_logic_0

  # Create instance: util_vector_logic_1, and set properties
  set util_vector_logic_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_1 ]
  set_property -dict [ list \
   CONFIG.C_SIZE {11} \
 ] $util_vector_logic_1

  # Create instance: util_vector_logic_2, and set properties
  set util_vector_logic_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_2 ]
  set_property -dict [ list \
   CONFIG.C_OPERATION {not} \
   CONFIG.C_SIZE {1} \
   CONFIG.LOGO_FILE {data/sym_notgate.png} \
 ] $util_vector_logic_2

  # Create instance: util_vector_logic_3, and set properties
  set util_vector_logic_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_3 ]
  set_property -dict [ list \
   CONFIG.C_OPERATION {or} \
   CONFIG.C_SIZE {11} \
   CONFIG.LOGO_FILE {data/sym_orgate.png} \
 ] $util_vector_logic_3

  # Create instance: xlconcat_0, and set properties
  set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]
  set_property -dict [ list \
   CONFIG.IN0_WIDTH {1} \
   CONFIG.IN10_WIDTH {1} \
   CONFIG.IN1_WIDTH {1} \
   CONFIG.IN2_WIDTH {1} \
   CONFIG.IN3_WIDTH {1} \
   CONFIG.IN4_WIDTH {1} \
   CONFIG.IN5_WIDTH {1} \
   CONFIG.IN6_WIDTH {1} \
   CONFIG.IN7_WIDTH {1} \
   CONFIG.IN8_WIDTH {1} \
   CONFIG.IN9_WIDTH {1} \
   CONFIG.NUM_PORTS {11} \
 ] $xlconcat_0

  # Create instance: xlconcat_1, and set properties
  set xlconcat_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_1 ]
  set_property -dict [ list \
   CONFIG.IN0_WIDTH {1} \
   CONFIG.IN10_WIDTH {1} \
   CONFIG.IN1_WIDTH {1} \
   CONFIG.IN2_WIDTH {1} \
   CONFIG.IN3_WIDTH {1} \
   CONFIG.IN4_WIDTH {1} \
   CONFIG.IN5_WIDTH {1} \
   CONFIG.IN6_WIDTH {1} \
   CONFIG.IN7_WIDTH {1} \
   CONFIG.IN8_WIDTH {1} \
   CONFIG.IN9_WIDTH {1} \
   CONFIG.NUM_PORTS {11} \
 ] $xlconcat_1

  # Create port connections
  connect_bd_net -net slice0_lsw [get_bd_pins i0] [get_bd_pins util_vector_logic_1/Op1]
  connect_bd_net -net slice1_msw [get_bd_pins i1] [get_bd_pins util_vector_logic_0/Op1]
  connect_bd_net -net sub_y2y1_S [get_bd_pins sel] [get_bd_pins util_vector_logic_2/Op1] [get_bd_pins xlconcat_0/In0] [get_bd_pins xlconcat_0/In1] [get_bd_pins xlconcat_0/In2] [get_bd_pins xlconcat_0/In3] [get_bd_pins xlconcat_0/In4] [get_bd_pins xlconcat_0/In5] [get_bd_pins xlconcat_0/In6] [get_bd_pins xlconcat_0/In7] [get_bd_pins xlconcat_0/In8] [get_bd_pins xlconcat_0/In9] [get_bd_pins xlconcat_0/In10]
  connect_bd_net -net util_vector_logic_0_Res [get_bd_pins util_vector_logic_0/Res] [get_bd_pins util_vector_logic_3/Op1]
  connect_bd_net -net util_vector_logic_1_Res [get_bd_pins util_vector_logic_1/Res] [get_bd_pins util_vector_logic_3/Op2]
  connect_bd_net -net util_vector_logic_2_Res [get_bd_pins util_vector_logic_2/Res] [get_bd_pins xlconcat_1/In0] [get_bd_pins xlconcat_1/In1] [get_bd_pins xlconcat_1/In2] [get_bd_pins xlconcat_1/In3] [get_bd_pins xlconcat_1/In4] [get_bd_pins xlconcat_1/In5] [get_bd_pins xlconcat_1/In6] [get_bd_pins xlconcat_1/In7] [get_bd_pins xlconcat_1/In8] [get_bd_pins xlconcat_1/In9] [get_bd_pins xlconcat_1/In10]
  connect_bd_net -net util_vector_logic_3_Res [get_bd_pins Res] [get_bd_pins util_vector_logic_3/Res]
  connect_bd_net -net xlconcat_0_dout [get_bd_pins util_vector_logic_0/Op2] [get_bd_pins xlconcat_0/dout]
  connect_bd_net -net xlconcat_1_dout [get_bd_pins util_vector_logic_1/Op2] [get_bd_pins xlconcat_1/dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: mux_y1y0
proc create_hier_cell_mux_y1y0 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_mux_y1y0() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins

  # Create pins
  create_bd_pin -dir O -from 10 -to 0 Res
  create_bd_pin -dir I -from 10 -to 0 i0
  create_bd_pin -dir I -from 10 -to 0 i1
  create_bd_pin -dir I -from 0 -to 0 sel

  # Create instance: util_vector_logic_0, and set properties
  set util_vector_logic_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_0 ]
  set_property -dict [ list \
   CONFIG.C_SIZE {11} \
 ] $util_vector_logic_0

  # Create instance: util_vector_logic_1, and set properties
  set util_vector_logic_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_1 ]
  set_property -dict [ list \
   CONFIG.C_SIZE {11} \
 ] $util_vector_logic_1

  # Create instance: util_vector_logic_2, and set properties
  set util_vector_logic_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_2 ]
  set_property -dict [ list \
   CONFIG.C_OPERATION {not} \
   CONFIG.C_SIZE {1} \
   CONFIG.LOGO_FILE {data/sym_notgate.png} \
 ] $util_vector_logic_2

  # Create instance: util_vector_logic_3, and set properties
  set util_vector_logic_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_3 ]
  set_property -dict [ list \
   CONFIG.C_OPERATION {or} \
   CONFIG.C_SIZE {11} \
   CONFIG.LOGO_FILE {data/sym_orgate.png} \
 ] $util_vector_logic_3

  # Create instance: xlconcat_0, and set properties
  set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]
  set_property -dict [ list \
   CONFIG.IN0_WIDTH {1} \
   CONFIG.IN10_WIDTH {1} \
   CONFIG.IN1_WIDTH {1} \
   CONFIG.IN2_WIDTH {1} \
   CONFIG.IN3_WIDTH {1} \
   CONFIG.IN4_WIDTH {1} \
   CONFIG.IN5_WIDTH {1} \
   CONFIG.IN6_WIDTH {1} \
   CONFIG.IN7_WIDTH {1} \
   CONFIG.IN8_WIDTH {1} \
   CONFIG.IN9_WIDTH {1} \
   CONFIG.NUM_PORTS {11} \
 ] $xlconcat_0

  # Create instance: xlconcat_1, and set properties
  set xlconcat_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_1 ]
  set_property -dict [ list \
   CONFIG.IN0_WIDTH {1} \
   CONFIG.IN10_WIDTH {1} \
   CONFIG.IN1_WIDTH {1} \
   CONFIG.IN2_WIDTH {1} \
   CONFIG.IN3_WIDTH {1} \
   CONFIG.IN4_WIDTH {1} \
   CONFIG.IN5_WIDTH {1} \
   CONFIG.IN6_WIDTH {1} \
   CONFIG.IN7_WIDTH {1} \
   CONFIG.IN8_WIDTH {1} \
   CONFIG.IN9_WIDTH {1} \
   CONFIG.NUM_PORTS {11} \
 ] $xlconcat_1

  # Create port connections
  connect_bd_net -net slice0_lsw [get_bd_pins i0] [get_bd_pins util_vector_logic_1/Op1]
  connect_bd_net -net slice1_msw [get_bd_pins i1] [get_bd_pins util_vector_logic_0/Op1]
  connect_bd_net -net sub_y2y1_S [get_bd_pins sel] [get_bd_pins util_vector_logic_2/Op1] [get_bd_pins xlconcat_0/In0] [get_bd_pins xlconcat_0/In1] [get_bd_pins xlconcat_0/In2] [get_bd_pins xlconcat_0/In3] [get_bd_pins xlconcat_0/In4] [get_bd_pins xlconcat_0/In5] [get_bd_pins xlconcat_0/In6] [get_bd_pins xlconcat_0/In7] [get_bd_pins xlconcat_0/In8] [get_bd_pins xlconcat_0/In9] [get_bd_pins xlconcat_0/In10]
  connect_bd_net -net util_vector_logic_0_Res [get_bd_pins util_vector_logic_0/Res] [get_bd_pins util_vector_logic_3/Op1]
  connect_bd_net -net util_vector_logic_1_Res [get_bd_pins util_vector_logic_1/Res] [get_bd_pins util_vector_logic_3/Op2]
  connect_bd_net -net util_vector_logic_2_Res [get_bd_pins util_vector_logic_2/Res] [get_bd_pins xlconcat_1/In0] [get_bd_pins xlconcat_1/In1] [get_bd_pins xlconcat_1/In2] [get_bd_pins xlconcat_1/In3] [get_bd_pins xlconcat_1/In4] [get_bd_pins xlconcat_1/In5] [get_bd_pins xlconcat_1/In6] [get_bd_pins xlconcat_1/In7] [get_bd_pins xlconcat_1/In8] [get_bd_pins xlconcat_1/In9] [get_bd_pins xlconcat_1/In10]
  connect_bd_net -net util_vector_logic_3_Res [get_bd_pins Res] [get_bd_pins util_vector_logic_3/Res]
  connect_bd_net -net xlconcat_0_dout [get_bd_pins util_vector_logic_0/Op2] [get_bd_pins xlconcat_0/dout]
  connect_bd_net -net xlconcat_1_dout [get_bd_pins util_vector_logic_1/Op2] [get_bd_pins xlconcat_1/dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: window
proc create_hier_cell_window { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_window() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins

  # Create pins
  create_bd_pin -dir I -type clk CLK
  create_bd_pin -dir I -from 23 -to 0 din
  create_bd_pin -dir O -from 0 -to 0 in2out
  create_bd_pin -dir O -from 0 -to 0 keep
  create_bd_pin -dir I last_in
  create_bd_pin -dir O -from 0 -to 0 last_out
  create_bd_pin -dir I -from 0 -to 0 user_in
  create_bd_pin -dir O -from 0 -to 0 user_out
  create_bd_pin -dir I -type ce valid_in
  create_bd_pin -dir O -from 10 -to 0 y0
  create_bd_pin -dir O -from 10 -to 0 y1
  create_bd_pin -dir O -from 11 -to 0 y1col
  create_bd_pin -dir O -from 10 -to 0 y2
  create_bd_pin -dir O -from 11 -to 0 y2col
  create_bd_pin -dir O -from 10 -to 0 y3

  # Create instance: control
  create_hier_cell_control $hier_obj control

  # Create instance: hcol, and set properties
  set hcol [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_counter_binary:12.0 hcol ]
  set_property -dict [ list \
   CONFIG.CE {true} \
   CONFIG.Fb_Latency_Configuration {Automatic} \
   CONFIG.Latency_Configuration {Automatic} \
   CONFIG.Output_Width {11} \
   CONFIG.SCLR {true} \
 ] $hcol

  # Create instance: o_0, and set properties
  set o_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 o_0 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
 ] $o_0

  # Create instance: o_1, and set properties
  set o_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 o_1 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {1} \
 ] $o_1

  # Create instance: slice0
  create_hier_cell_slice0 $hier_obj slice0

  # Create instance: slice1
  create_hier_cell_slice1 $hier_obj slice1

  # Create instance: tap_1_last, and set properties
  set tap_1_last [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 tap_1_last ]
  set_property -dict [ list \
   CONFIG.AsyncInitVal {0} \
   CONFIG.DefaultData {0} \
   CONFIG.Depth {1} \
   CONFIG.SyncInitVal {0} \
   CONFIG.Width {1} \
 ] $tap_1_last

  # Create instance: tap_1_user, and set properties
  set tap_1_user [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 tap_1_user ]
  set_property -dict [ list \
   CONFIG.AsyncInitVal {0} \
   CONFIG.DefaultData {0} \
   CONFIG.Depth {1} \
   CONFIG.SyncInitVal {0} \
   CONFIG.Width {1} \
 ] $tap_1_user

  # Create instance: tap_3_1_last, and set properties
  set tap_3_1_last [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 tap_3_1_last ]
  set_property -dict [ list \
   CONFIG.AsyncInitVal {0} \
   CONFIG.DefaultData {0} \
   CONFIG.Depth {4} \
   CONFIG.SyncInitVal {0} \
   CONFIG.Width {1} \
 ] $tap_3_1_last

  # Create instance: tap_3_1_valid, and set properties
  set tap_3_1_valid [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 tap_3_1_valid ]
  set_property -dict [ list \
   CONFIG.AsyncInitVal {0} \
   CONFIG.DefaultData {0} \
   CONFIG.Depth {4} \
   CONFIG.SyncInitVal {0} \
   CONFIG.Width {1} \
 ] $tap_3_1_valid

  # Create instance: xlconcat_0, and set properties
  set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]
  set_property -dict [ list \
   CONFIG.IN0_WIDTH {1} \
   CONFIG.IN1_WIDTH {11} \
 ] $xlconcat_0

  # Create instance: xlconcat_1, and set properties
  set xlconcat_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_1 ]
  set_property -dict [ list \
   CONFIG.IN0_WIDTH {1} \
   CONFIG.IN1_WIDTH {11} \
 ] $xlconcat_1

  # Create instance: y1y0, and set properties
  set y1y0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 y1y0 ]
  set_property -dict [ list \
   CONFIG.AsyncInitVal {000000000000000000000000} \
   CONFIG.CE {true} \
   CONFIG.DefaultData {000000000000000000000000} \
   CONFIG.Depth {1} \
   CONFIG.SyncInitVal {000000000000000000000000} \
   CONFIG.Width {24} \
 ] $y1y0

  # Create instance: y1y0_col, and set properties
  set y1y0_col [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 y1y0_col ]
  set_property -dict [ list \
   CONFIG.AsyncInitVal {00000000000} \
   CONFIG.CE {true} \
   CONFIG.DefaultData {00000000000} \
   CONFIG.Depth {1} \
   CONFIG.SyncInitVal {00000000000} \
   CONFIG.Width {11} \
 ] $y1y0_col

  # Create instance: y3y2, and set properties
  set y3y2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 y3y2 ]
  set_property -dict [ list \
   CONFIG.AsyncInitVal {000000000000000000000000} \
   CONFIG.CE {true} \
   CONFIG.DefaultData {000000000000000000000000} \
   CONFIG.Depth {1} \
   CONFIG.SyncInitVal {000000000000000000000000} \
   CONFIG.Width {24} \
 ] $y3y2

  # Create port connections
  connect_bd_net -net CLK_1 [get_bd_pins CLK] [get_bd_pins control/CLK] [get_bd_pins hcol/CLK] [get_bd_pins tap_1_last/CLK] [get_bd_pins tap_1_user/CLK] [get_bd_pins tap_3_1_last/CLK] [get_bd_pins tap_3_1_valid/CLK] [get_bd_pins y1y0/CLK] [get_bd_pins y1y0_col/CLK] [get_bd_pins y3y2/CLK]
  connect_bd_net -net D_1 [get_bd_pins din] [get_bd_pins y3y2/D]
  connect_bd_net -net D_1_1 [get_bd_pins user_in] [get_bd_pins tap_1_user/D]
  connect_bd_net -net Din_1 [get_bd_pins slice0/Din] [get_bd_pins y1y0/Q]
  connect_bd_net -net c_shift_ram_0_Q [get_bd_pins slice1/Din] [get_bd_pins y1y0/D] [get_bd_pins y3y2/Q]
  connect_bd_net -net c_shift_ram_0_Q2 [get_bd_pins hcol/CE] [get_bd_pins tap_3_1_valid/Q]
  connect_bd_net -net c_shift_ram_1_Q1 [get_bd_pins hcol/SCLR] [get_bd_pins tap_3_1_last/Q]
  connect_bd_net -net c_shift_ram_2_Q [get_bd_pins last_out] [get_bd_pins tap_1_last/Q]
  connect_bd_net -net control_in2out [get_bd_pins in2out] [get_bd_pins control/in2out]
  connect_bd_net -net control_keep [get_bd_pins keep] [get_bd_pins control/keep]
  connect_bd_net -net gnd_dout [get_bd_pins o_0/dout] [get_bd_pins xlconcat_0/In0]
  connect_bd_net -net hcol_Q [get_bd_pins hcol/Q] [get_bd_pins y1y0_col/D]
  connect_bd_net -net last_in_1 [get_bd_pins last_in] [get_bd_pins tap_1_last/D] [get_bd_pins tap_3_1_last/D]
  connect_bd_net -net slice0_lsw [get_bd_pins y0] [get_bd_pins slice0/lsw]
  connect_bd_net -net slice0_msnz [get_bd_pins control/y1_nz] [get_bd_pins slice0/msnz]
  connect_bd_net -net slice0_msw [get_bd_pins y1] [get_bd_pins slice0/msw]
  connect_bd_net -net slice1_lsnz [get_bd_pins control/y2_nz] [get_bd_pins slice1/lsnz]
  connect_bd_net -net slice1_lsw [get_bd_pins y2] [get_bd_pins slice1/lsw]
  connect_bd_net -net slice1_msw [get_bd_pins y3] [get_bd_pins slice1/msw]
  connect_bd_net -net tap_1_sof_Q [get_bd_pins user_out] [get_bd_pins tap_1_user/Q]
  connect_bd_net -net valid_in_1 [get_bd_pins valid_in] [get_bd_pins tap_3_1_valid/D] [get_bd_pins y1y0/CE] [get_bd_pins y1y0_col/CE] [get_bd_pins y3y2/CE]
  connect_bd_net -net vcc_dout_1 [get_bd_pins o_1/dout] [get_bd_pins xlconcat_1/In0]
  connect_bd_net -net xlconcat_0_dout [get_bd_pins y1col] [get_bd_pins xlconcat_0/dout]
  connect_bd_net -net xlconcat_1_dout [get_bd_pins y2col] [get_bd_pins xlconcat_1/dout]
  connect_bd_net -net y1y0_col_Q [get_bd_pins xlconcat_0/In1] [get_bd_pins xlconcat_1/In1] [get_bd_pins y1y0_col/Q]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: threshold
proc create_hier_cell_threshold { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_threshold() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins

  # Create pins
  create_bd_pin -dir I CLK
  create_bd_pin -dir I -from 21 -to 0 Din
  create_bd_pin -dir O -from 23 -to 0 dout
  create_bd_pin -dir I -from 0 -to 0 last_in
  create_bd_pin -dir O -from 0 -to 0 last_out
  create_bd_pin -dir I -from 9 -to 0 threshold
  create_bd_pin -dir I -from 0 -to 0 user_in
  create_bd_pin -dir O -from 0 -to 0 user_out
  create_bd_pin -dir I -from 0 -to 0 valid_in
  create_bd_pin -dir O -from 0 -to 0 valid_out

  # Create instance: pack, and set properties
  set pack [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 pack ]
  set_property -dict [ list \
   CONFIG.IN0_WIDTH {11} \
   CONFIG.IN1_WIDTH {1} \
   CONFIG.IN2_WIDTH {11} \
   CONFIG.IN3_WIDTH {1} \
   CONFIG.NUM_PORTS {4} \
 ] $pack

  # Create instance: slice
  create_hier_cell_slice $hier_obj slice

  # Create instance: tap_2
  create_hier_cell_tap_2 $hier_obj tap_2

  # Create instance: threshold0
  create_hier_cell_threshold0 $hier_obj threshold0

  # Create instance: threshold1
  create_hier_cell_threshold1 $hier_obj threshold1

  # Create port connections
  connect_bd_net -net CLK_1 [get_bd_pins CLK] [get_bd_pins tap_2/CLK] [get_bd_pins threshold0/CLK] [get_bd_pins threshold1/CLK]
  connect_bd_net -net Din_1 [get_bd_pins Din] [get_bd_pins slice/Din]
  connect_bd_net -net last_in_1 [get_bd_pins last_in] [get_bd_pins tap_2/last_in]
  connect_bd_net -net pack_dout [get_bd_pins dout] [get_bd_pins pack/dout]
  connect_bd_net -net slice_lsw [get_bd_pins slice/lsw] [get_bd_pins threshold0/sum]
  connect_bd_net -net slice_msw [get_bd_pins slice/msw] [get_bd_pins threshold1/sum]
  connect_bd_net -net sof_in_1 [get_bd_pins user_in] [get_bd_pins tap_2/user_in]
  connect_bd_net -net tap_2_last_Q [get_bd_pins last_out] [get_bd_pins tap_2/last_out]
  connect_bd_net -net tap_2_sof_Q [get_bd_pins user_out] [get_bd_pins tap_2/user_out]
  connect_bd_net -net tap_2_valid_Q [get_bd_pins valid_out] [get_bd_pins tap_2/valid_out]
  connect_bd_net -net threshold0_abs_value [get_bd_pins pack/In2] [get_bd_pins threshold1/abs_value]
  connect_bd_net -net threshold0_nz [get_bd_pins pack/In3] [get_bd_pins threshold1/nz]
  connect_bd_net -net threshold1_abs_value [get_bd_pins pack/In0] [get_bd_pins threshold0/abs_value]
  connect_bd_net -net threshold1_nz [get_bd_pins pack/In1] [get_bd_pins threshold0/nz]
  connect_bd_net -net threshold_1 [get_bd_pins threshold] [get_bd_pins threshold0/threshold] [get_bd_pins threshold1/threshold]
  connect_bd_net -net valid_in_1 [get_bd_pins valid_in] [get_bd_pins tap_2/valid_in]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: latch_max
proc create_hier_cell_latch_max { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_latch_max() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins

  # Create pins
  create_bd_pin -dir I -type clk CLK
  create_bd_pin -dir I -from 0 -to 0 in2out
  create_bd_pin -dir I -from 0 -to 0 keep
  create_bd_pin -dir I -from 0 -to 0 last_in
  create_bd_pin -dir O -from 0 -to 0 last_out
  create_bd_pin -dir O -from 10 -to 0 max
  create_bd_pin -dir O -from 10 -to 0 maxL
  create_bd_pin -dir O -from 10 -to 0 maxR
  create_bd_pin -dir O -from 11 -to 0 maxcol
  create_bd_pin -dir I -from 0 -to 0 user_in
  create_bd_pin -dir O -from 0 -to 0 user_out
  create_bd_pin -dir O -from 0 -to 0 valid_out
  create_bd_pin -dir I -from 10 -to 0 y0
  create_bd_pin -dir I -from 10 -to 0 y1
  create_bd_pin -dir I -from 11 -to 0 y1col
  create_bd_pin -dir I -from 10 -to 0 y2
  create_bd_pin -dir I -from 11 -to 0 y2col
  create_bd_pin -dir I -from 10 -to 0 y3

  # Create instance: mask_sel, and set properties
  set mask_sel [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 mask_sel ]
  set_property -dict [ list \
   CONFIG.C_SIZE {1} \
 ] $mask_sel

  # Create instance: max, and set properties
  set max [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 max ]
  set_property -dict [ list \
   CONFIG.AsyncInitVal {00000000000} \
   CONFIG.CE {false} \
   CONFIG.DefaultData {00000000000} \
   CONFIG.Depth {1} \
   CONFIG.SCLR {false} \
   CONFIG.SyncInitVal {00000000000} \
   CONFIG.Width {11} \
 ] $max

  # Create instance: maxL, and set properties
  set maxL [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 maxL ]
  set_property -dict [ list \
   CONFIG.AsyncInitVal {00000000000} \
   CONFIG.DefaultData {00000000000} \
   CONFIG.Depth {1} \
   CONFIG.SyncInitVal {00000000000} \
   CONFIG.Width {11} \
 ] $maxL

  # Create instance: maxR, and set properties
  set maxR [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 maxR ]
  set_property -dict [ list \
   CONFIG.AsyncInitVal {00000000000} \
   CONFIG.DefaultData {00000000000} \
   CONFIG.Depth {1} \
   CONFIG.SyncInitVal {00000000000} \
   CONFIG.Width {11} \
 ] $maxR

  # Create instance: maxcol, and set properties
  set maxcol [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 maxcol ]
  set_property -dict [ list \
   CONFIG.AsyncInitVal {000000000000} \
   CONFIG.DefaultData {000000000000} \
   CONFIG.Depth {1} \
   CONFIG.SyncInitVal {000000000000} \
   CONFIG.Width {12} \
 ] $maxcol

  # Create instance: mux_y1y0
  create_hier_cell_mux_y1y0 $hier_obj mux_y1y0

  # Create instance: mux_y2y1
  create_hier_cell_mux_y2y1 $hier_obj mux_y2y1

  # Create instance: mux_y3y2
  create_hier_cell_mux_y3y2 $hier_obj mux_y3y2

  # Create instance: mux_ycol
  create_hier_cell_mux_ycol $hier_obj mux_ycol

  # Create instance: mux_ymax
  create_hier_cell_mux_ymax $hier_obj mux_ymax

  # Create instance: mux_ymaxL
  create_hier_cell_mux_ymaxL $hier_obj mux_ymaxL

  # Create instance: mux_ymaxR
  create_hier_cell_mux_ymaxR $hier_obj mux_ymaxR

  # Create instance: mux_ymaxcol
  create_hier_cell_mux_ymaxcol $hier_obj mux_ymaxcol

  # Create instance: sub_y2y1, and set properties
  set sub_y2y1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_addsub:12.0 sub_y2y1 ]
  set_property -dict [ list \
   CONFIG.A_Type {Signed} \
   CONFIG.A_Width {11} \
   CONFIG.Add_Mode {Subtract} \
   CONFIG.B_Type {Signed} \
   CONFIG.B_Value {00000000000} \
   CONFIG.B_Width {11} \
   CONFIG.CE {false} \
   CONFIG.Latency {1} \
   CONFIG.Latency_Configuration {Automatic} \
   CONFIG.Out_Width {11} \
 ] $sub_y2y1

  # Create instance: sub_ymax, and set properties
  set sub_ymax [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_addsub:12.0 sub_ymax ]
  set_property -dict [ list \
   CONFIG.A_Type {Signed} \
   CONFIG.A_Width {11} \
   CONFIG.Add_Mode {Subtract} \
   CONFIG.B_Type {Signed} \
   CONFIG.B_Value {00000000000} \
   CONFIG.B_Width {11} \
   CONFIG.CE {false} \
   CONFIG.Latency {1} \
   CONFIG.Latency_Configuration {Automatic} \
   CONFIG.Out_Width {11} \
 ] $sub_ymax

  # Create instance: tap_2_in2out, and set properties
  set tap_2_in2out [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 tap_2_in2out ]
  set_property -dict [ list \
   CONFIG.AsyncInitVal {0} \
   CONFIG.DefaultData {0} \
   CONFIG.Depth {2} \
   CONFIG.SyncInitVal {0} \
   CONFIG.Width {1} \
 ] $tap_2_in2out

  # Create instance: tap_2_keep, and set properties
  set tap_2_keep [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 tap_2_keep ]
  set_property -dict [ list \
   CONFIG.AsyncInitVal {0} \
   CONFIG.DefaultData {0} \
   CONFIG.Depth {2} \
   CONFIG.SyncInitVal {0} \
   CONFIG.Width {1} \
 ] $tap_2_keep

  # Create instance: tap_2_last, and set properties
  set tap_2_last [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 tap_2_last ]
  set_property -dict [ list \
   CONFIG.AsyncInitVal {0} \
   CONFIG.DefaultData {0} \
   CONFIG.Depth {2} \
   CONFIG.SyncInitVal {0} \
   CONFIG.Width {1} \
 ] $tap_2_last

  # Create instance: tap_2_user, and set properties
  set tap_2_user [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 tap_2_user ]
  set_property -dict [ list \
   CONFIG.AsyncInitVal {0} \
   CONFIG.DefaultData {0} \
   CONFIG.Depth {2} \
   CONFIG.SyncInitVal {0} \
   CONFIG.Width {1} \
 ] $tap_2_user

  # Create instance: y, and set properties
  set y [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 y ]
  set_property -dict [ list \
   CONFIG.AsyncInitVal {00000000000} \
   CONFIG.DefaultData {00000000000} \
   CONFIG.Depth {1} \
   CONFIG.SyncInitVal {00000000000} \
   CONFIG.Width {11} \
 ] $y

  # Create instance: y0, and set properties
  set y0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 y0 ]
  set_property -dict [ list \
   CONFIG.AsyncInitVal {00000000000} \
   CONFIG.DefaultData {00000000000} \
   CONFIG.Depth {1} \
   CONFIG.SyncInitVal {00000000000} \
   CONFIG.Width {11} \
 ] $y0

  # Create instance: y1, and set properties
  set y1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 y1 ]
  set_property -dict [ list \
   CONFIG.AsyncInitVal {00000000000} \
   CONFIG.DefaultData {00000000000} \
   CONFIG.Depth {1} \
   CONFIG.SyncInitVal {00000000000} \
   CONFIG.Width {11} \
 ] $y1

  # Create instance: y1col, and set properties
  set y1col [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 y1col ]
  set_property -dict [ list \
   CONFIG.AsyncInitVal {000000000000} \
   CONFIG.DefaultData {000000000000} \
   CONFIG.Depth {1} \
   CONFIG.SyncInitVal {000000000000} \
   CONFIG.Width {12} \
 ] $y1col

  # Create instance: y2, and set properties
  set y2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 y2 ]
  set_property -dict [ list \
   CONFIG.AsyncInitVal {00000000000} \
   CONFIG.DefaultData {00000000000} \
   CONFIG.Depth {1} \
   CONFIG.SyncInitVal {00000000000} \
   CONFIG.Width {11} \
 ] $y2

  # Create instance: y2col, and set properties
  set y2col [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 y2col ]
  set_property -dict [ list \
   CONFIG.AsyncInitVal {000000000000} \
   CONFIG.DefaultData {000000000000} \
   CONFIG.Depth {1} \
   CONFIG.SyncInitVal {000000000000} \
   CONFIG.Width {12} \
 ] $y2col

  # Create instance: y2y1_n, and set properties
  set y2y1_n [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 y2y1_n ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {10} \
   CONFIG.DIN_TO {10} \
   CONFIG.DIN_WIDTH {11} \
   CONFIG.DOUT_WIDTH {1} \
 ] $y2y1_n

  # Create instance: y3, and set properties
  set y3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 y3 ]
  set_property -dict [ list \
   CONFIG.AsyncInitVal {00000000000} \
   CONFIG.DefaultData {00000000000} \
   CONFIG.Depth {1} \
   CONFIG.SyncInitVal {00000000000} \
   CONFIG.Width {11} \
 ] $y3

  # Create instance: yL_latch, and set properties
  set yL_latch [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 yL_latch ]
  set_property -dict [ list \
   CONFIG.AsyncInitVal {00000000000} \
   CONFIG.DefaultData {00000000000} \
   CONFIG.Depth {1} \
   CONFIG.SyncInitVal {00000000000} \
   CONFIG.Width {11} \
 ] $yL_latch

  # Create instance: yR_latch, and set properties
  set yR_latch [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 yR_latch ]
  set_property -dict [ list \
   CONFIG.AsyncInitVal {00000000000} \
   CONFIG.DefaultData {00000000000} \
   CONFIG.Depth {1} \
   CONFIG.SyncInitVal {00000000000} \
   CONFIG.Width {11} \
 ] $yR_latch

  # Create instance: ycol_latch, and set properties
  set ycol_latch [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 ycol_latch ]
  set_property -dict [ list \
   CONFIG.AsyncInitVal {000000000000} \
   CONFIG.DefaultData {000000000000} \
   CONFIG.Depth {1} \
   CONFIG.SyncInitVal {000000000000} \
   CONFIG.Width {12} \
 ] $ycol_latch

  # Create instance: ymax_n, and set properties
  set ymax_n [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 ymax_n ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {10} \
   CONFIG.DIN_TO {10} \
   CONFIG.DIN_WIDTH {11} \
   CONFIG.DOUT_WIDTH {1} \
 ] $ymax_n

  # Create port connections
  connect_bd_net -net CLK_1 [get_bd_pins CLK] [get_bd_pins max/CLK] [get_bd_pins maxL/CLK] [get_bd_pins maxR/CLK] [get_bd_pins maxcol/CLK] [get_bd_pins sub_y2y1/CLK] [get_bd_pins sub_ymax/CLK] [get_bd_pins tap_2_in2out/CLK] [get_bd_pins tap_2_keep/CLK] [get_bd_pins tap_2_last/CLK] [get_bd_pins tap_2_user/CLK] [get_bd_pins y/CLK] [get_bd_pins y0/CLK] [get_bd_pins y1/CLK] [get_bd_pins y1col/CLK] [get_bd_pins y2/CLK] [get_bd_pins y2col/CLK] [get_bd_pins y3/CLK] [get_bd_pins yL_latch/CLK] [get_bd_pins yR_latch/CLK] [get_bd_pins ycol_latch/CLK]
  connect_bd_net -net clr_1 [get_bd_pins keep] [get_bd_pins tap_2_keep/D]
  connect_bd_net -net i0_1 [get_bd_pins mux_y3y2/i0] [get_bd_pins y3/Q]
  connect_bd_net -net in2out_1 [get_bd_pins in2out] [get_bd_pins tap_2_in2out/D]
  connect_bd_net -net last_in_1 [get_bd_pins last_in] [get_bd_pins tap_2_last/D]
  connect_bd_net -net maxL_latch_Q [get_bd_pins maxL] [get_bd_pins maxL/Q] [get_bd_pins mux_ymaxL/i1]
  connect_bd_net -net maxR_latch_Q [get_bd_pins maxR] [get_bd_pins maxR/Q] [get_bd_pins mux_ymaxR/i1]
  connect_bd_net -net max_Q [get_bd_pins max] [get_bd_pins max/Q] [get_bd_pins mux_ymax/i1]
  connect_bd_net -net mux0_Res [get_bd_pins mux_y2y1/Res] [get_bd_pins sub_ymax/A] [get_bd_pins y/D]
  connect_bd_net -net mux_row_Res [get_bd_pins maxcol/D] [get_bd_pins mux_ymaxcol/Res]
  connect_bd_net -net mux_y1y0_Res [get_bd_pins mux_y1y0/Res] [get_bd_pins yL_latch/D]
  connect_bd_net -net mux_y3y2_Res [get_bd_pins mux_y3y2/Res] [get_bd_pins yR_latch/D]
  connect_bd_net -net mux_ycol_Res [get_bd_pins mux_ycol/Res] [get_bd_pins ycol_latch/D]
  connect_bd_net -net mux_ymaxL_Res [get_bd_pins maxL/D] [get_bd_pins mux_ymaxL/Res]
  connect_bd_net -net mux_ymaxR_Res [get_bd_pins maxR/D] [get_bd_pins mux_ymaxR/Res]
  connect_bd_net -net mux_ymax_Res [get_bd_pins max/D] [get_bd_pins mux_ymax/Res] [get_bd_pins sub_ymax/B]
  connect_bd_net -net row_Q [get_bd_pins maxcol] [get_bd_pins maxcol/Q] [get_bd_pins mux_ymaxcol/i1]
  connect_bd_net -net sof_in_1 [get_bd_pins user_in] [get_bd_pins tap_2_user/D]
  connect_bd_net -net sub_max_y_S [get_bd_pins sub_ymax/S] [get_bd_pins ymax_n/Din]
  connect_bd_net -net sub_y2y1_S [get_bd_pins mux_y1y0/sel] [get_bd_pins mux_y2y1/sel] [get_bd_pins mux_y3y2/sel] [get_bd_pins mux_ycol/sel] [get_bd_pins y2y1_n/Dout]
  connect_bd_net -net sub_y2y1_S1 [get_bd_pins sub_y2y1/S] [get_bd_pins y2y1_n/Din]
  connect_bd_net -net tap_2_clr_Q [get_bd_pins mask_sel/Op1] [get_bd_pins tap_2_keep/Q]
  connect_bd_net -net tap_2_last_Q [get_bd_pins last_out] [get_bd_pins tap_2_last/Q]
  connect_bd_net -net tap_2_sof_Q [get_bd_pins user_out] [get_bd_pins tap_2_user/Q]
  connect_bd_net -net tap_3_in2out_Q [get_bd_pins valid_out] [get_bd_pins tap_2_in2out/Q]
  connect_bd_net -net util_vector_logic_0_Res [get_bd_pins mask_sel/Res] [get_bd_pins mux_ymax/sel] [get_bd_pins mux_ymaxL/sel] [get_bd_pins mux_ymaxR/sel] [get_bd_pins mux_ymaxcol/sel]
  connect_bd_net -net window_y1 [get_bd_pins y1] [get_bd_pins sub_y2y1/B] [get_bd_pins y1/D]
  connect_bd_net -net window_y2 [get_bd_pins y2] [get_bd_pins sub_y2y1/A] [get_bd_pins y2/D]
  connect_bd_net -net y0_Q [get_bd_pins mux_y1y0/i1] [get_bd_pins y0/Q]
  connect_bd_net -net y1_Q [get_bd_pins mux_y1y0/i0] [get_bd_pins mux_y2y1/i1] [get_bd_pins y1/Q]
  connect_bd_net -net y1col_1 [get_bd_pins y1col] [get_bd_pins y1col/D]
  connect_bd_net -net y1col_Q [get_bd_pins mux_ycol/i1] [get_bd_pins y1col/Q]
  connect_bd_net -net y2_Q [get_bd_pins mux_y2y1/i0] [get_bd_pins mux_y3y2/i1] [get_bd_pins y2/Q]
  connect_bd_net -net y2col_1 [get_bd_pins y2col] [get_bd_pins y2col/D]
  connect_bd_net -net y2col_Q [get_bd_pins mux_ycol/i0] [get_bd_pins y2col/Q]
  connect_bd_net -net y3_1 [get_bd_pins y3] [get_bd_pins y3/D]
  connect_bd_net -net y4_1 [get_bd_pins y0] [get_bd_pins y0/D]
  connect_bd_net -net yL_latch_Q [get_bd_pins mux_ymaxL/i0] [get_bd_pins yL_latch/Q]
  connect_bd_net -net yR_latch_Q [get_bd_pins mux_ymaxR/i0] [get_bd_pins yR_latch/Q]
  connect_bd_net -net y_Q [get_bd_pins mux_ymax/i0] [get_bd_pins y/Q]
  connect_bd_net -net ycol_latch_Q [get_bd_pins mux_ymaxcol/i0] [get_bd_pins ycol_latch/Q]
  connect_bd_net -net ymax_n_Dout [get_bd_pins mask_sel/Op2] [get_bd_pins ymax_n/Dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: fit_parabola
proc create_hier_cell_fit_parabola { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_fit_parabola() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins

  # Create pins
  create_bd_pin -dir I -type clk CLK
  create_bd_pin -dir I -from 11 -to 0 col
  create_bd_pin -dir I -from 0 -to 0 last_in
  create_bd_pin -dir O -from 0 -to 0 last_out
  create_bd_pin -dir O -from 23 -to 0 spc
  create_bd_pin -dir I -from 0 -to 0 user_in
  create_bd_pin -dir O -from 0 -to 0 user_out
  create_bd_pin -dir I -from 0 -to 0 valid_in
  create_bd_pin -dir O -from 0 -to 0 valid_out
  create_bd_pin -dir I -from 10 -to 0 -type data y0
  create_bd_pin -dir I -from 10 -to 0 -type data y1
  create_bd_pin -dir I -from 10 -to 0 -type data y2

  # Create instance: den, and set properties
  set den [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_addsub:12.0 den ]
  set_property -dict [ list \
   CONFIG.A_Type {Signed} \
   CONFIG.A_Width {11} \
   CONFIG.B_Type {Signed} \
   CONFIG.B_Value {00000000000} \
   CONFIG.B_Width {11} \
   CONFIG.CE {false} \
   CONFIG.Latency {1} \
   CONFIG.Latency_Configuration {Automatic} \
   CONFIG.Out_Width {12} \
 ] $den

  # Create instance: div_11_11_over_12, and set properties
  set div_11_11_over_12 [ create_bd_cell -type ip -vlnv xilinx.com:ip:div_gen:5.1 div_11_11_over_12 ]
  set_property -dict [ list \
   CONFIG.divide_by_zero_detect {true} \
   CONFIG.dividend_and_quotient_width {22} \
   CONFIG.divisor_width {12} \
   CONFIG.fractional_width {12} \
   CONFIG.latency {26} \
   CONFIG.operand_sign {Signed} \
   CONFIG.remainder_type {Remainder} \
 ] $div_11_11_over_12

  # Create instance: num_11_11, and set properties
  set num_11_11 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 num_11_11 ]
  set_property -dict [ list \
   CONFIG.IN0_WIDTH {11} \
   CONFIG.IN1_WIDTH {11} \
   CONFIG.IN2_WIDTH {2} \
   CONFIG.NUM_PORTS {3} \
 ] $num_11_11

  # Create instance: offset_1_11, and set properties
  set offset_1_11 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 offset_1_11 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {28} \
   CONFIG.DIN_TO {17} \
   CONFIG.DIN_WIDTH {40} \
   CONFIG.DOUT_WIDTH {12} \
 ] $offset_1_11

  # Create instance: pad1, and set properties
  set pad1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 pad1 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
 ] $pad1

  # Create instance: pad2, and set properties
  set pad2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 pad2 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
   CONFIG.CONST_WIDTH {2} \
 ] $pad2

  # Create instance: pad4, and set properties
  set pad4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 pad4 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
   CONFIG.CONST_WIDTH {4} \
 ] $pad4

  # Create instance: pad11, and set properties
  set pad11 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 pad11 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
   CONFIG.CONST_WIDTH {11} \
 ] $pad11

  # Create instance: pad_col, and set properties
  set pad_col [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 pad_col ]
  set_property -dict [ list \
   CONFIG.IN0_WIDTH {11} \
   CONFIG.IN1_WIDTH {12} \
   CONFIG.IN2_WIDTH {1} \
   CONFIG.NUM_PORTS {3} \
 ] $pad_col

  # Create instance: pad_den, and set properties
  set pad_den [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 pad_den ]
  set_property -dict [ list \
   CONFIG.IN0_WIDTH {12} \
   CONFIG.IN1_WIDTH {4} \
 ] $pad_den

  # Create instance: spc, and set properties
  set spc [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_addsub:12.0 spc ]
  set_property -dict [ list \
   CONFIG.A_Type {Signed} \
   CONFIG.A_Width {12} \
   CONFIG.B_Type {Signed} \
   CONFIG.B_Value {000000000000000000000000} \
   CONFIG.B_Width {24} \
   CONFIG.Bypass {true} \
   CONFIG.Bypass_Sense {Active_High} \
   CONFIG.CE {false} \
   CONFIG.Latency {2} \
   CONFIG.Latency_Configuration {Automatic} \
   CONFIG.Out_Width {24} \
 ] $spc

  # Create instance: sub_y0y1, and set properties
  set sub_y0y1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_addsub:12.0 sub_y0y1 ]
  set_property -dict [ list \
   CONFIG.A_Type {Signed} \
   CONFIG.A_Width {11} \
   CONFIG.Add_Mode {Subtract} \
   CONFIG.B_Type {Signed} \
   CONFIG.B_Value {00000000000} \
   CONFIG.B_Width {11} \
   CONFIG.CE {false} \
   CONFIG.Latency {1} \
   CONFIG.Latency_Configuration {Automatic} \
   CONFIG.Out_Width {11} \
 ] $sub_y0y1

  # Create instance: sub_y0y2, and set properties
  set sub_y0y2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_addsub:12.0 sub_y0y2 ]
  set_property -dict [ list \
   CONFIG.A_Type {Signed} \
   CONFIG.A_Width {11} \
   CONFIG.Add_Mode {Subtract} \
   CONFIG.B_Type {Signed} \
   CONFIG.B_Value {00000000000} \
   CONFIG.B_Width {11} \
   CONFIG.CE {false} \
   CONFIG.Latency {1} \
   CONFIG.Latency_Configuration {Automatic} \
   CONFIG.Out_Width {11} \
 ] $sub_y0y2

  # Create instance: sub_y2y1, and set properties
  set sub_y2y1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_addsub:12.0 sub_y2y1 ]
  set_property -dict [ list \
   CONFIG.A_Type {Signed} \
   CONFIG.A_Width {11} \
   CONFIG.Add_Mode {Subtract} \
   CONFIG.B_Type {Signed} \
   CONFIG.B_Value {00000000000} \
   CONFIG.B_Width {11} \
   CONFIG.CE {false} \
   CONFIG.Latency {1} \
   CONFIG.Latency_Configuration {Automatic} \
   CONFIG.Out_Width {11} \
 ] $sub_y2y1

  # Create instance: tap_1_1_26_2, and set properties
  set tap_1_1_26_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 tap_1_1_26_2 ]
  set_property -dict [ list \
   CONFIG.AsyncInitVal {0} \
   CONFIG.DefaultData {0} \
   CONFIG.Depth {30} \
   CONFIG.SyncInitVal {0} \
   CONFIG.Width {1} \
 ] $tap_1_1_26_2

  # Create instance: tap_1_num, and set properties
  set tap_1_num [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 tap_1_num ]
  set_property -dict [ list \
   CONFIG.AsyncInitVal {00000000000} \
   CONFIG.DefaultData {00000000000} \
   CONFIG.Depth {1} \
   CONFIG.SyncInitVal {00000000000} \
   CONFIG.Width {11} \
 ] $tap_1_num

  # Create instance: tap_28_col, and set properties
  set tap_28_col [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 tap_28_col ]
  set_property -dict [ list \
   CONFIG.AsyncInitVal {000000000000} \
   CONFIG.DefaultData {000000000000} \
   CONFIG.Depth {28} \
   CONFIG.SyncInitVal {000000000000} \
   CONFIG.Width {12} \
 ] $tap_28_col

  # Create instance: tap_30_last, and set properties
  set tap_30_last [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 tap_30_last ]
  set_property -dict [ list \
   CONFIG.AsyncInitVal {0} \
   CONFIG.DefaultData {0} \
   CONFIG.Depth {30} \
   CONFIG.SyncInitVal {0} \
   CONFIG.Width {1} \
 ] $tap_30_last

  # Create instance: tap_30_user, and set properties
  set tap_30_user [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 tap_30_user ]
  set_property -dict [ list \
   CONFIG.AsyncInitVal {0} \
   CONFIG.DefaultData {0} \
   CONFIG.Depth {30} \
   CONFIG.SyncInitVal {0} \
   CONFIG.Width {1} \
 ] $tap_30_user

  # Create port connections
  connect_bd_net -net CLK_1 [get_bd_pins CLK] [get_bd_pins den/CLK] [get_bd_pins div_11_11_over_12/aclk] [get_bd_pins spc/CLK] [get_bd_pins sub_y0y1/CLK] [get_bd_pins sub_y0y2/CLK] [get_bd_pins sub_y2y1/CLK] [get_bd_pins tap_1_1_26_2/CLK] [get_bd_pins tap_1_num/CLK] [get_bd_pins tap_28_col/CLK] [get_bd_pins tap_30_last/CLK] [get_bd_pins tap_30_user/CLK]
  connect_bd_net -net col_1 [get_bd_pins col] [get_bd_pins tap_28_col/D]
  connect_bd_net -net den_S [get_bd_pins den/S] [get_bd_pins pad_den/In0]
  connect_bd_net -net div_11_11_over_12_m_axis_dout_tuser [get_bd_pins div_11_11_over_12/m_axis_dout_tuser] [get_bd_pins spc/BYPASS]
  connect_bd_net -net div_gen_0_m_axis_dout_tdata [get_bd_pins div_11_11_over_12/m_axis_dout_tdata] [get_bd_pins offset_1_11/Din]
  connect_bd_net -net last_in_1 [get_bd_pins last_in] [get_bd_pins tap_30_last/D]
  connect_bd_net -net num_11_11_dout [get_bd_pins div_11_11_over_12/s_axis_dividend_tdata] [get_bd_pins num_11_11/dout]
  connect_bd_net -net offset_1_11_Dout [get_bd_pins offset_1_11/Dout] [get_bd_pins spc/A]
  connect_bd_net -net pad2_dout [get_bd_pins num_11_11/In2] [get_bd_pins pad2/dout]
  connect_bd_net -net pad4_dout [get_bd_pins pad4/dout] [get_bd_pins pad_den/In1]
  connect_bd_net -net pad_col_dout [get_bd_pins pad_col/dout] [get_bd_pins spc/B]
  connect_bd_net -net slice0_lsw [get_bd_pins y1] [get_bd_pins sub_y0y1/B] [get_bd_pins sub_y2y1/B]
  connect_bd_net -net slice0_msw [get_bd_pins y0] [get_bd_pins sub_y0y1/A] [get_bd_pins sub_y0y2/A]
  connect_bd_net -net slice1_msw [get_bd_pins y2] [get_bd_pins sub_y0y2/B] [get_bd_pins sub_y2y1/A]
  connect_bd_net -net sof_in_1 [get_bd_pins user_in] [get_bd_pins tap_30_user/D]
  connect_bd_net -net spc_S [get_bd_pins spc] [get_bd_pins spc/S]
  connect_bd_net -net sub_y0y1_S [get_bd_pins den/A] [get_bd_pins sub_y0y1/S]
  connect_bd_net -net sub_y0y2_S [get_bd_pins sub_y0y2/S] [get_bd_pins tap_1_num/D]
  connect_bd_net -net sub_y2y1_S [get_bd_pins den/B] [get_bd_pins sub_y2y1/S]
  connect_bd_net -net tap_1_1_23_Q [get_bd_pins valid_out] [get_bd_pins tap_1_1_26_2/Q]
  connect_bd_net -net tap_1_num_Q [get_bd_pins num_11_11/In1] [get_bd_pins tap_1_num/Q]
  connect_bd_net -net tap_28_col_Q [get_bd_pins pad_col/In1] [get_bd_pins tap_28_col/Q]
  connect_bd_net -net tap_30_last1_Q [get_bd_pins user_out] [get_bd_pins tap_30_user/Q]
  connect_bd_net -net tap_30_last_Q [get_bd_pins last_out] [get_bd_pins tap_30_last/Q]
  connect_bd_net -net valid_in_1 [get_bd_pins valid_in] [get_bd_pins tap_1_1_26_2/D]
  connect_bd_net -net xlconcat_0_dout1 [get_bd_pins div_11_11_over_12/s_axis_divisor_tdata] [get_bd_pins pad_den/dout]
  connect_bd_net -net xlconstant_0_dout [get_bd_pins num_11_11/In0] [get_bd_pins pad11/dout] [get_bd_pins pad_col/In0]
  connect_bd_net -net xlconstant_0_dout1 [get_bd_pins pad1/dout] [get_bd_pins pad_col/In2]

  # Restore current instance
  current_bd_instance $oldCurInst
}


# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder
  variable design_name

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports

  # Create ports
  set CLK [ create_bd_port -dir I CLK ]
  set data_out [ create_bd_port -dir O -from 23 -to 0 data_out ]
  set eol_out [ create_bd_port -dir O -from 0 -to 0 eol_out ]
  set sof_out [ create_bd_port -dir O -from 0 -to 0 sof_out ]
  set tdata_in [ create_bd_port -dir I -from 21 -to 0 tdata_in ]
  set threshold [ create_bd_port -dir I -from 9 -to 0 threshold ]
  set tlast_in [ create_bd_port -dir I -from 0 -to 0 tlast_in ]
  set tready_in [ create_bd_port -dir O -from 0 -to 0 tready_in ]
  set tuser_in [ create_bd_port -dir I -from 0 -to 0 tuser_in ]
  set tvalid_in [ create_bd_port -dir I -from 0 -to 0 tvalid_in ]
  set valid_out [ create_bd_port -dir O -from 0 -to 0 valid_out ]

  # Create instance: fit_parabola
  create_hier_cell_fit_parabola [current_bd_instance .] fit_parabola

  # Create instance: latch_max
  create_hier_cell_latch_max [current_bd_instance .] latch_max

  # Create instance: o_1, and set properties
  set o_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 o_1 ]

  # Create instance: threshold
  create_hier_cell_threshold [current_bd_instance .] threshold

  # Create instance: window
  create_hier_cell_window [current_bd_instance .] window

  # Create port connections
  connect_bd_net -net CLK_1 [get_bd_ports CLK] [get_bd_pins fit_parabola/CLK] [get_bd_pins latch_max/CLK] [get_bd_pins threshold/CLK] [get_bd_pins window/CLK]
  connect_bd_net -net Din_1 [get_bd_ports tdata_in] [get_bd_pins threshold/Din]
  connect_bd_net -net edges_fsm_last_out [get_bd_ports eol_out] [get_bd_pins fit_parabola/last_out]
  connect_bd_net -net edges_fsm_spc [get_bd_ports data_out] [get_bd_pins fit_parabola/spc]
  connect_bd_net -net edges_fsm_user_out [get_bd_ports sof_out] [get_bd_pins fit_parabola/user_out]
  connect_bd_net -net edges_fsm_valid_out [get_bd_ports valid_out] [get_bd_pins fit_parabola/valid_out]
  connect_bd_net -net last_in_1 [get_bd_ports tlast_in] [get_bd_pins threshold/last_in]
  connect_bd_net -net latch_max_last_out [get_bd_pins fit_parabola/last_in] [get_bd_pins latch_max/last_out]
  connect_bd_net -net latch_max_maxcol [get_bd_pins fit_parabola/col] [get_bd_pins latch_max/maxcol]
  connect_bd_net -net o_1_dout [get_bd_ports tready_in] [get_bd_pins o_1/dout]
  connect_bd_net -net sof_in_1 [get_bd_pins fit_parabola/user_in] [get_bd_pins latch_max/user_out]
  connect_bd_net -net threshold_1 [get_bd_ports threshold] [get_bd_pins threshold/threshold]
  connect_bd_net -net threshold_dout [get_bd_pins threshold/dout] [get_bd_pins window/din]
  connect_bd_net -net threshold_last_out [get_bd_pins threshold/last_out] [get_bd_pins window/last_in]
  connect_bd_net -net threshold_sof_out [get_bd_pins threshold/user_out] [get_bd_pins window/user_in]
  connect_bd_net -net threshold_valid_out [get_bd_pins threshold/valid_out] [get_bd_pins window/valid_in]
  connect_bd_net -net user_in_1 [get_bd_ports tuser_in] [get_bd_pins threshold/user_in]
  connect_bd_net -net valid_in_1 [get_bd_ports tvalid_in] [get_bd_pins threshold/valid_in]
  connect_bd_net -net valid_in_2 [get_bd_pins fit_parabola/valid_in] [get_bd_pins latch_max/valid_out]
  connect_bd_net -net window_in2out [get_bd_pins latch_max/in2out] [get_bd_pins window/in2out]
  connect_bd_net -net window_keep [get_bd_pins latch_max/keep] [get_bd_pins window/keep]
  connect_bd_net -net window_last_out [get_bd_pins latch_max/last_in] [get_bd_pins window/last_out]
  connect_bd_net -net window_sof_out [get_bd_pins latch_max/user_in] [get_bd_pins window/user_out]
  connect_bd_net -net window_y0 [get_bd_pins latch_max/y0] [get_bd_pins window/y0]
  connect_bd_net -net window_y1 [get_bd_pins latch_max/y1] [get_bd_pins window/y1]
  connect_bd_net -net window_y1col [get_bd_pins latch_max/y1col] [get_bd_pins window/y1col]
  connect_bd_net -net window_y2 [get_bd_pins latch_max/y2] [get_bd_pins window/y2]
  connect_bd_net -net window_y3 [get_bd_pins latch_max/y3] [get_bd_pins window/y3]
  connect_bd_net -net y0_1 [get_bd_pins fit_parabola/y0] [get_bd_pins latch_max/maxL]
  connect_bd_net -net y1_1 [get_bd_pins fit_parabola/y1] [get_bd_pins latch_max/max]
  connect_bd_net -net y2_1 [get_bd_pins fit_parabola/y2] [get_bd_pins latch_max/maxR]
  connect_bd_net -net y2col_1 [get_bd_pins latch_max/y2col] [get_bd_pins window/y2col]

  # Create address segments


  # Restore current instance
  current_bd_instance $oldCurInst

  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


