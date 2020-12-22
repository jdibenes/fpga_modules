
################################################################
# This is a generated script based on design: median_filter1D
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
# source median_filter1D_script.tcl

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
set design_name median_filter1D

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
xilinx.com:ip:xlconcat:2.1\
xilinx.com:ip:util_vector_logic:2.0\
xilinx.com:ip:xlslice:1.0\
xilinx.com:ip:util_reduced_logic:2.0\
xilinx.com:ip:c_shift_ram:12.0\
xilinx.com:ip:c_addsub:12.0\
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
  create_bd_pin -dir I -from 15 -to 0 din
  create_bd_pin -dir O -from 7 -to 0 lsb
  create_bd_pin -dir O -from 7 -to 0 msb

  # Create instance: xlslice_0, and set properties
  set xlslice_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_0 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {7} \
   CONFIG.DIN_TO {0} \
   CONFIG.DIN_WIDTH {16} \
   CONFIG.DOUT_WIDTH {8} \
 ] $xlslice_0

  # Create instance: xlslice_1, and set properties
  set xlslice_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_1 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {15} \
   CONFIG.DIN_TO {8} \
   CONFIG.DIN_WIDTH {16} \
   CONFIG.DOUT_WIDTH {8} \
 ] $xlslice_1

  # Create port connections
  connect_bd_net -net din_1 [get_bd_pins din] [get_bd_pins xlslice_0/Din] [get_bd_pins xlslice_1/Din]
  connect_bd_net -net xlslice_0_Dout [get_bd_pins lsb] [get_bd_pins xlslice_0/Dout]
  connect_bd_net -net xlslice_1_Dout [get_bd_pins msb] [get_bd_pins xlslice_1/Dout]

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
  create_bd_pin -dir I -from 15 -to 0 din
  create_bd_pin -dir O -from 7 -to 0 lsb
  create_bd_pin -dir O -from 7 -to 0 msb

  # Create instance: xlslice_0, and set properties
  set xlslice_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_0 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {7} \
   CONFIG.DIN_TO {0} \
   CONFIG.DIN_WIDTH {16} \
   CONFIG.DOUT_WIDTH {8} \
 ] $xlslice_0

  # Create instance: xlslice_1, and set properties
  set xlslice_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_1 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {15} \
   CONFIG.DIN_TO {8} \
   CONFIG.DIN_WIDTH {16} \
   CONFIG.DOUT_WIDTH {8} \
 ] $xlslice_1

  # Create port connections
  connect_bd_net -net din_1 [get_bd_pins din] [get_bd_pins xlslice_0/Din] [get_bd_pins xlslice_1/Din]
  connect_bd_net -net xlslice_0_Dout [get_bd_pins lsb] [get_bd_pins xlslice_0/Dout]
  connect_bd_net -net xlslice_1_Dout [get_bd_pins msb] [get_bd_pins xlslice_1/Dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: upad3
proc create_hier_cell_upad3 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_upad3() - Empty argument(s)!"}
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
  create_bd_pin -dir O -from 8 -to 0 sout
  create_bd_pin -dir I -from 7 -to 0 uin

  # Create instance: gnd, and set properties
  set gnd [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 gnd ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
 ] $gnd

  # Create instance: pad, and set properties
  set pad [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 pad ]
  set_property -dict [ list \
   CONFIG.IN0_WIDTH {8} \
   CONFIG.IN1_WIDTH {1} \
 ] $pad

  # Create port connections
  connect_bd_net -net In0_1 [get_bd_pins uin] [get_bd_pins pad/In0]
  connect_bd_net -net xlconcat_0_dout [get_bd_pins sout] [get_bd_pins pad/dout]
  connect_bd_net -net xlconstant_0_dout [get_bd_pins gnd/dout] [get_bd_pins pad/In1]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: upad2
proc create_hier_cell_upad2 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_upad2() - Empty argument(s)!"}
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
  create_bd_pin -dir O -from 8 -to 0 sout
  create_bd_pin -dir I -from 7 -to 0 uin

  # Create instance: gnd, and set properties
  set gnd [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 gnd ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
 ] $gnd

  # Create instance: pad, and set properties
  set pad [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 pad ]
  set_property -dict [ list \
   CONFIG.IN0_WIDTH {8} \
   CONFIG.IN1_WIDTH {1} \
 ] $pad

  # Create port connections
  connect_bd_net -net In0_1 [get_bd_pins uin] [get_bd_pins pad/In0]
  connect_bd_net -net xlconcat_0_dout [get_bd_pins sout] [get_bd_pins pad/dout]
  connect_bd_net -net xlconstant_0_dout [get_bd_pins gnd/dout] [get_bd_pins pad/In1]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: upad1
proc create_hier_cell_upad1 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_upad1() - Empty argument(s)!"}
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
  create_bd_pin -dir O -from 8 -to 0 sout
  create_bd_pin -dir I -from 7 -to 0 uin

  # Create instance: gnd, and set properties
  set gnd [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 gnd ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
 ] $gnd

  # Create instance: pad, and set properties
  set pad [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 pad ]
  set_property -dict [ list \
   CONFIG.IN0_WIDTH {8} \
   CONFIG.IN1_WIDTH {1} \
 ] $pad

  # Create port connections
  connect_bd_net -net In0_1 [get_bd_pins uin] [get_bd_pins pad/In0]
  connect_bd_net -net xlconcat_0_dout [get_bd_pins sout] [get_bd_pins pad/dout]
  connect_bd_net -net xlconstant_0_dout [get_bd_pins gnd/dout] [get_bd_pins pad/In1]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: upad0
proc create_hier_cell_upad0 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_upad0() - Empty argument(s)!"}
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
  create_bd_pin -dir O -from 8 -to 0 sout
  create_bd_pin -dir I -from 7 -to 0 uin

  # Create instance: gnd, and set properties
  set gnd [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 gnd ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
 ] $gnd

  # Create instance: pad, and set properties
  set pad [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 pad ]
  set_property -dict [ list \
   CONFIG.IN0_WIDTH {8} \
   CONFIG.IN1_WIDTH {1} \
 ] $pad

  # Create port connections
  connect_bd_net -net In0_1 [get_bd_pins uin] [get_bd_pins pad/In0]
  connect_bd_net -net xlconcat_0_dout [get_bd_pins sout] [get_bd_pins pad/dout]
  connect_bd_net -net xlconstant_0_dout [get_bd_pins gnd/dout] [get_bd_pins pad/In1]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: tap_1
proc create_hier_cell_tap_1 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_tap_1() - Empty argument(s)!"}
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
  create_bd_pin -dir I -from 0 -to 0 last_in
  create_bd_pin -dir O -from 0 -to 0 last_out
  create_bd_pin -dir I -from 0 -to 0 user_in
  create_bd_pin -dir O -from 0 -to 0 user_out
  create_bd_pin -dir I -from 0 -to 0 valid_in
  create_bd_pin -dir O -from 0 -to 0 valid_out
  create_bd_pin -dir I -from 7 -to 0 -type data y0
  create_bd_pin -dir O -from 7 -to 0 -type data y0_d
  create_bd_pin -dir I -from 7 -to 0 -type data y1
  create_bd_pin -dir O -from 7 -to 0 -type data y1_d
  create_bd_pin -dir I -from 7 -to 0 -type data y2
  create_bd_pin -dir O -from 7 -to 0 -type data y2_d
  create_bd_pin -dir I -from 7 -to 0 -type data y3
  create_bd_pin -dir O -from 7 -to 0 -type data y3_d

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

  # Create instance: tap_1_valid, and set properties
  set tap_1_valid [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 tap_1_valid ]
  set_property -dict [ list \
   CONFIG.AsyncInitVal {0} \
   CONFIG.DefaultData {0} \
   CONFIG.Depth {1} \
   CONFIG.SyncInitVal {0} \
   CONFIG.Width {1} \
 ] $tap_1_valid

  # Create instance: tap_1_y0, and set properties
  set tap_1_y0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 tap_1_y0 ]
  set_property -dict [ list \
   CONFIG.AsyncInitVal {00000000} \
   CONFIG.DefaultData {00000000} \
   CONFIG.Depth {1} \
   CONFIG.SyncInitVal {00000000} \
   CONFIG.Width {8} \
 ] $tap_1_y0

  # Create instance: tap_1_y1, and set properties
  set tap_1_y1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 tap_1_y1 ]
  set_property -dict [ list \
   CONFIG.AsyncInitVal {00000000} \
   CONFIG.DefaultData {00000000} \
   CONFIG.Depth {1} \
   CONFIG.SyncInitVal {00000000} \
   CONFIG.Width {8} \
 ] $tap_1_y1

  # Create instance: tap_1_y2, and set properties
  set tap_1_y2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 tap_1_y2 ]
  set_property -dict [ list \
   CONFIG.AsyncInitVal {00000000} \
   CONFIG.DefaultData {00000000} \
   CONFIG.Depth {1} \
   CONFIG.SyncInitVal {00000000} \
   CONFIG.Width {8} \
 ] $tap_1_y2

  # Create instance: tap_1_y3, and set properties
  set tap_1_y3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 tap_1_y3 ]
  set_property -dict [ list \
   CONFIG.AsyncInitVal {00000000} \
   CONFIG.DefaultData {00000000} \
   CONFIG.Depth {1} \
   CONFIG.SyncInitVal {00000000} \
   CONFIG.Width {8} \
 ] $tap_1_y3

  # Create port connections
  connect_bd_net -net Net [get_bd_pins CLK] [get_bd_pins tap_1_last/CLK] [get_bd_pins tap_1_user/CLK] [get_bd_pins tap_1_valid/CLK] [get_bd_pins tap_1_y0/CLK] [get_bd_pins tap_1_y1/CLK] [get_bd_pins tap_1_y2/CLK] [get_bd_pins tap_1_y3/CLK]
  connect_bd_net -net last_in_1 [get_bd_pins last_in] [get_bd_pins tap_1_last/D]
  connect_bd_net -net tap_1_last_Q [get_bd_pins last_out] [get_bd_pins tap_1_last/Q]
  connect_bd_net -net tap_1_user_Q [get_bd_pins user_out] [get_bd_pins tap_1_user/Q]
  connect_bd_net -net tap_1_valid_Q [get_bd_pins valid_out] [get_bd_pins tap_1_valid/Q]
  connect_bd_net -net tap_1_y0_Q [get_bd_pins y0_d] [get_bd_pins tap_1_y0/Q]
  connect_bd_net -net tap_1_y1_Q [get_bd_pins y1_d] [get_bd_pins tap_1_y1/Q]
  connect_bd_net -net tap_1_y2_Q [get_bd_pins y2_d] [get_bd_pins tap_1_y2/Q]
  connect_bd_net -net tap_1_y3_Q [get_bd_pins y3_d] [get_bd_pins tap_1_y3/Q]
  connect_bd_net -net uin_1 [get_bd_pins y0] [get_bd_pins tap_1_y0/D]
  connect_bd_net -net uin_2 [get_bd_pins y1] [get_bd_pins tap_1_y1/D]
  connect_bd_net -net uin_3 [get_bd_pins y2] [get_bd_pins tap_1_y2/D]
  connect_bd_net -net uin_4 [get_bd_pins y3] [get_bd_pins tap_1_y3/D]
  connect_bd_net -net user_in_1 [get_bd_pins user_in] [get_bd_pins tap_1_user/D]
  connect_bd_net -net valid_in_1 [get_bd_pins valid_in] [get_bd_pins tap_1_valid/D]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: cmp_y3y2_n
proc create_hier_cell_cmp_y3y2_n { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_cmp_y3y2_n() - Empty argument(s)!"}
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
  create_bd_pin -dir I -from 8 -to 0 -type data A
  create_bd_pin -dir I -from 8 -to 0 -type data B
  create_bd_pin -dir I -type clk CLK
  create_bd_pin -dir O -from 0 -to 0 n

  # Create instance: cmp_y3y2, and set properties
  set cmp_y3y2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_addsub:12.0 cmp_y3y2 ]
  set_property -dict [ list \
   CONFIG.A_Type {Signed} \
   CONFIG.A_Width {9} \
   CONFIG.Add_Mode {Subtract} \
   CONFIG.B_Type {Signed} \
   CONFIG.B_Value {000000000} \
   CONFIG.B_Width {9} \
   CONFIG.CE {false} \
   CONFIG.Latency {1} \
   CONFIG.Latency_Configuration {Automatic} \
   CONFIG.Out_Width {9} \
 ] $cmp_y3y2

  # Create instance: nbit_y3y2, and set properties
  set nbit_y3y2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 nbit_y3y2 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {8} \
   CONFIG.DIN_TO {8} \
   CONFIG.DIN_WIDTH {9} \
   CONFIG.DOUT_WIDTH {1} \
 ] $nbit_y3y2

  # Create port connections
  connect_bd_net -net Net [get_bd_pins CLK] [get_bd_pins cmp_y3y2/CLK]
  connect_bd_net -net cmp2_S [get_bd_pins cmp_y3y2/S] [get_bd_pins nbit_y3y2/Din]
  connect_bd_net -net nbit_y3y2_Dout [get_bd_pins n] [get_bd_pins nbit_y3y2/Dout]
  connect_bd_net -net upad2_sout [get_bd_pins B] [get_bd_pins cmp_y3y2/B]
  connect_bd_net -net upad3_sout [get_bd_pins A] [get_bd_pins cmp_y3y2/A]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: cmp_y3y1_n
proc create_hier_cell_cmp_y3y1_n { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_cmp_y3y1_n() - Empty argument(s)!"}
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
  create_bd_pin -dir I -from 8 -to 0 -type data A
  create_bd_pin -dir I -from 8 -to 0 -type data B
  create_bd_pin -dir I -type clk CLK
  create_bd_pin -dir O -from 0 -to 0 n

  # Create instance: cmp_y3y1, and set properties
  set cmp_y3y1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_addsub:12.0 cmp_y3y1 ]
  set_property -dict [ list \
   CONFIG.A_Type {Signed} \
   CONFIG.A_Width {9} \
   CONFIG.Add_Mode {Subtract} \
   CONFIG.B_Type {Signed} \
   CONFIG.B_Value {000000000} \
   CONFIG.B_Width {9} \
   CONFIG.CE {false} \
   CONFIG.Latency {1} \
   CONFIG.Latency_Configuration {Automatic} \
   CONFIG.Out_Width {9} \
 ] $cmp_y3y1

  # Create instance: nbit_y3y1, and set properties
  set nbit_y3y1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 nbit_y3y1 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {8} \
   CONFIG.DIN_TO {8} \
   CONFIG.DIN_WIDTH {9} \
   CONFIG.DOUT_WIDTH {1} \
 ] $nbit_y3y1

  # Create port connections
  connect_bd_net -net Net [get_bd_pins CLK] [get_bd_pins cmp_y3y1/CLK]
  connect_bd_net -net cmp_y3y1_S [get_bd_pins cmp_y3y1/S] [get_bd_pins nbit_y3y1/Din]
  connect_bd_net -net nbit_y3y1_Dout [get_bd_pins n] [get_bd_pins nbit_y3y1/Dout]
  connect_bd_net -net upad1_sout [get_bd_pins B] [get_bd_pins cmp_y3y1/B]
  connect_bd_net -net upad3_sout [get_bd_pins A] [get_bd_pins cmp_y3y1/A]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: cmp_y2y1_n
proc create_hier_cell_cmp_y2y1_n { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_cmp_y2y1_n() - Empty argument(s)!"}
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
  create_bd_pin -dir I -from 8 -to 0 -type data A
  create_bd_pin -dir I -from 8 -to 0 -type data B
  create_bd_pin -dir I -type clk CLK
  create_bd_pin -dir O -from 0 -to 0 n

  # Create instance: cmp_y2y1, and set properties
  set cmp_y2y1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_addsub:12.0 cmp_y2y1 ]
  set_property -dict [ list \
   CONFIG.A_Type {Signed} \
   CONFIG.A_Width {9} \
   CONFIG.Add_Mode {Subtract} \
   CONFIG.B_Type {Signed} \
   CONFIG.B_Value {000000000} \
   CONFIG.B_Width {9} \
   CONFIG.CE {false} \
   CONFIG.Latency {1} \
   CONFIG.Latency_Configuration {Automatic} \
   CONFIG.Out_Width {9} \
 ] $cmp_y2y1

  # Create instance: nbit_y2y1, and set properties
  set nbit_y2y1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 nbit_y2y1 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {8} \
   CONFIG.DIN_TO {8} \
   CONFIG.DIN_WIDTH {9} \
   CONFIG.DOUT_WIDTH {1} \
 ] $nbit_y2y1

  # Create port connections
  connect_bd_net -net Net [get_bd_pins CLK] [get_bd_pins cmp_y2y1/CLK]
  connect_bd_net -net cmp1_S [get_bd_pins cmp_y2y1/S] [get_bd_pins nbit_y2y1/Din]
  connect_bd_net -net nbit_y2y1_Dout [get_bd_pins n] [get_bd_pins nbit_y2y1/Dout]
  connect_bd_net -net upad1_sout [get_bd_pins B] [get_bd_pins cmp_y2y1/B]
  connect_bd_net -net upad2_sout [get_bd_pins A] [get_bd_pins cmp_y2y1/A]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: cmp_y2y0_n
proc create_hier_cell_cmp_y2y0_n { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_cmp_y2y0_n() - Empty argument(s)!"}
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
  create_bd_pin -dir I -from 8 -to 0 -type data A
  create_bd_pin -dir I -from 8 -to 0 -type data B
  create_bd_pin -dir I -type clk CLK
  create_bd_pin -dir O -from 0 -to 0 n

  # Create instance: cmp_y2y0, and set properties
  set cmp_y2y0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_addsub:12.0 cmp_y2y0 ]
  set_property -dict [ list \
   CONFIG.A_Type {Signed} \
   CONFIG.A_Width {9} \
   CONFIG.Add_Mode {Subtract} \
   CONFIG.B_Type {Signed} \
   CONFIG.B_Value {000000000} \
   CONFIG.B_Width {9} \
   CONFIG.CE {false} \
   CONFIG.Latency {1} \
   CONFIG.Latency_Configuration {Automatic} \
   CONFIG.Out_Width {9} \
 ] $cmp_y2y0

  # Create instance: nbit_y2y0, and set properties
  set nbit_y2y0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 nbit_y2y0 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {8} \
   CONFIG.DIN_TO {8} \
   CONFIG.DIN_WIDTH {9} \
   CONFIG.DOUT_WIDTH {1} \
 ] $nbit_y2y0

  # Create port connections
  connect_bd_net -net Net [get_bd_pins CLK] [get_bd_pins cmp_y2y0/CLK]
  connect_bd_net -net cmp_y2y0_S [get_bd_pins cmp_y2y0/S] [get_bd_pins nbit_y2y0/Din]
  connect_bd_net -net nbit_y2y0_Dout [get_bd_pins n] [get_bd_pins nbit_y2y0/Dout]
  connect_bd_net -net upad0_sout [get_bd_pins B] [get_bd_pins cmp_y2y0/B]
  connect_bd_net -net upad2_sout [get_bd_pins A] [get_bd_pins cmp_y2y0/A]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: cmp_y1y0_n
proc create_hier_cell_cmp_y1y0_n { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_cmp_y1y0_n() - Empty argument(s)!"}
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
  create_bd_pin -dir I -from 8 -to 0 -type data A
  create_bd_pin -dir I -from 8 -to 0 -type data B
  create_bd_pin -dir I -type clk CLK
  create_bd_pin -dir O -from 0 -to 0 n

  # Create instance: cmp_y1y0, and set properties
  set cmp_y1y0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_addsub:12.0 cmp_y1y0 ]
  set_property -dict [ list \
   CONFIG.A_Type {Signed} \
   CONFIG.A_Width {9} \
   CONFIG.Add_Mode {Subtract} \
   CONFIG.B_Type {Signed} \
   CONFIG.B_Value {000000000} \
   CONFIG.B_Width {9} \
   CONFIG.CE {false} \
   CONFIG.Latency {1} \
   CONFIG.Latency_Configuration {Automatic} \
   CONFIG.Out_Width {9} \
 ] $cmp_y1y0

  # Create instance: nbit_y1y0, and set properties
  set nbit_y1y0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 nbit_y1y0 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {8} \
   CONFIG.DIN_TO {8} \
   CONFIG.DIN_WIDTH {9} \
   CONFIG.DOUT_WIDTH {1} \
 ] $nbit_y1y0

  # Create port connections
  connect_bd_net -net Net [get_bd_pins CLK] [get_bd_pins cmp_y1y0/CLK]
  connect_bd_net -net cmp0_S [get_bd_pins cmp_y1y0/S] [get_bd_pins nbit_y1y0/Din]
  connect_bd_net -net nbit_y1y0_Dout [get_bd_pins n] [get_bd_pins nbit_y1y0/Dout]
  connect_bd_net -net upad0_sout [get_bd_pins B] [get_bd_pins cmp_y1y0/B]
  connect_bd_net -net upad1_sout [get_bd_pins A] [get_bd_pins cmp_y1y0/A]

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
  create_bd_pin -dir I -from 15 -to 0 -type data din
  create_bd_pin -dir I last_in
  create_bd_pin -dir O -from 0 -to 0 last_out
  create_bd_pin -dir I user_in
  create_bd_pin -dir O -from 0 -to 0 user_out
  create_bd_pin -dir I -type ce valid_in
  create_bd_pin -dir O -from 0 -to 0 valid_out
  create_bd_pin -dir O -from 7 -to 0 y0
  create_bd_pin -dir O -from 7 -to 0 y1
  create_bd_pin -dir O -from 7 -to 0 y2
  create_bd_pin -dir O -from 7 -to 0 y3

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

  # Create instance: tap_1_valid, and set properties
  set tap_1_valid [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 tap_1_valid ]
  set_property -dict [ list \
   CONFIG.AsyncInitVal {0} \
   CONFIG.DefaultData {0} \
   CONFIG.Depth {1} \
   CONFIG.SyncInitVal {0} \
   CONFIG.Width {1} \
 ] $tap_1_valid

  # Create instance: y1y0, and set properties
  set y1y0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 y1y0 ]
  set_property -dict [ list \
   CONFIG.CE {true} \
   CONFIG.Depth {1} \
   CONFIG.Width {16} \
 ] $y1y0

  # Create instance: y3y2, and set properties
  set y3y2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 y3y2 ]
  set_property -dict [ list \
   CONFIG.CE {true} \
   CONFIG.Depth {1} \
   CONFIG.Width {16} \
 ] $y3y2

  # Create port connections
  connect_bd_net -net CE_1 [get_bd_pins valid_in] [get_bd_pins tap_1_valid/D] [get_bd_pins y1y0/CE] [get_bd_pins y3y2/CE]
  connect_bd_net -net D_1 [get_bd_pins din] [get_bd_pins y3y2/D]
  connect_bd_net -net Net [get_bd_pins CLK] [get_bd_pins tap_1_last/CLK] [get_bd_pins tap_1_user/CLK] [get_bd_pins tap_1_valid/CLK] [get_bd_pins y1y0/CLK] [get_bd_pins y3y2/CLK]
  connect_bd_net -net din_1 [get_bd_pins slice0/din] [get_bd_pins y1y0/Q]
  connect_bd_net -net last_in_1 [get_bd_pins last_in] [get_bd_pins tap_1_last/D]
  connect_bd_net -net slice0_lsb [get_bd_pins y0] [get_bd_pins slice0/lsb]
  connect_bd_net -net slice0_msb [get_bd_pins y1] [get_bd_pins slice0/msb]
  connect_bd_net -net slice1_lsb [get_bd_pins y2] [get_bd_pins slice1/lsb]
  connect_bd_net -net slice1_msb [get_bd_pins y3] [get_bd_pins slice1/msb]
  connect_bd_net -net tap_1_last_Q [get_bd_pins last_out] [get_bd_pins tap_1_last/Q]
  connect_bd_net -net tap_1_user_Q [get_bd_pins user_out] [get_bd_pins tap_1_user/Q]
  connect_bd_net -net tap_1_valid_Q [get_bd_pins valid_out] [get_bd_pins tap_1_valid/Q]
  connect_bd_net -net user_in_1 [get_bd_pins user_in] [get_bd_pins tap_1_user/D]
  connect_bd_net -net y0y1_Q [get_bd_pins slice1/din] [get_bd_pins y1y0/D] [get_bd_pins y3y2/Q]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: sel1
proc create_hier_cell_sel1 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_sel1() - Empty argument(s)!"}
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
  create_bd_pin -dir I -from 0 -to 0 x0
  create_bd_pin -dir I -from 0 -to 0 x1
  create_bd_pin -dir I -from 0 -to 0 x2
  create_bd_pin -dir O -from 0 -to 0 y0_sel
  create_bd_pin -dir O -from 0 -to 0 y1_sel
  create_bd_pin -dir O -from 0 -to 0 y2_sel

  # Create instance: nx, and set properties
  set nx [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 nx ]
  set_property -dict [ list \
   CONFIG.C_OPERATION {not} \
   CONFIG.C_SIZE {3} \
   CONFIG.LOGO_FILE {data/sym_notgate.png} \
 ] $nx

  # Create instance: nx0, and set properties
  set nx0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 nx0 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {0} \
   CONFIG.DIN_TO {0} \
   CONFIG.DIN_WIDTH {3} \
 ] $nx0

  # Create instance: nx1, and set properties
  set nx1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 nx1 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {1} \
   CONFIG.DIN_TO {1} \
   CONFIG.DIN_WIDTH {3} \
   CONFIG.DOUT_WIDTH {1} \
 ] $nx1

  # Create instance: nx2, and set properties
  set nx2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 nx2 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {2} \
   CONFIG.DIN_TO {2} \
   CONFIG.DIN_WIDTH {3} \
   CONFIG.DOUT_WIDTH {1} \
 ] $nx2

  # Create instance: x, and set properties
  set x [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 x ]
  set_property -dict [ list \
   CONFIG.IN0_WIDTH {1} \
   CONFIG.IN1_WIDTH {1} \
   CONFIG.IN2_WIDTH {1} \
   CONFIG.NUM_PORTS {3} \
 ] $x

  # Create instance: y0_group_A, and set properties
  set y0_group_A [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 y0_group_A ]
  set_property -dict [ list \
   CONFIG.IN0_WIDTH {1} \
   CONFIG.IN1_WIDTH {1} \
   CONFIG.IN2_WIDTH {1} \
   CONFIG.NUM_PORTS {3} \
 ] $y0_group_A

  # Create instance: y0_group_B, and set properties
  set y0_group_B [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 y0_group_B ]
  set_property -dict [ list \
   CONFIG.IN0_WIDTH {1} \
   CONFIG.IN1_WIDTH {1} \
   CONFIG.IN2_WIDTH {1} \
   CONFIG.NUM_PORTS {3} \
 ] $y0_group_B

  # Create instance: y0_sel, and set properties
  set y0_sel [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 y0_sel ]
  set_property -dict [ list \
   CONFIG.C_OPERATION {or} \
   CONFIG.C_SIZE {1} \
   CONFIG.LOGO_FILE {data/sym_orgate.png} \
 ] $y0_sel

  # Create instance: y0_sel_A, and set properties
  set y0_sel_A [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_reduced_logic:2.0 y0_sel_A ]
  set_property -dict [ list \
   CONFIG.C_SIZE {3} \
 ] $y0_sel_A

  # Create instance: y0_sel_B, and set properties
  set y0_sel_B [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_reduced_logic:2.0 y0_sel_B ]
  set_property -dict [ list \
   CONFIG.C_SIZE {3} \
 ] $y0_sel_B

  # Create instance: y1_sel, and set properties
  set y1_sel [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 y1_sel ]
  set_property -dict [ list \
   CONFIG.C_OPERATION {or} \
   CONFIG.C_SIZE {1} \
   CONFIG.LOGO_FILE {data/sym_orgate.png} \
 ] $y1_sel

  # Create instance: y1_sel_A, and set properties
  set y1_sel_A [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_reduced_logic:2.0 y1_sel_A ]
  set_property -dict [ list \
   CONFIG.C_SIZE {3} \
 ] $y1_sel_A

  # Create instance: y1_sel_B, and set properties
  set y1_sel_B [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_reduced_logic:2.0 y1_sel_B ]
  set_property -dict [ list \
   CONFIG.C_SIZE {3} \
 ] $y1_sel_B

  # Create instance: y2_group_A, and set properties
  set y2_group_A [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 y2_group_A ]
  set_property -dict [ list \
   CONFIG.IN0_WIDTH {1} \
   CONFIG.IN1_WIDTH {1} \
   CONFIG.IN2_WIDTH {1} \
   CONFIG.NUM_PORTS {3} \
 ] $y2_group_A

  # Create instance: y2_group_B, and set properties
  set y2_group_B [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 y2_group_B ]
  set_property -dict [ list \
   CONFIG.IN0_WIDTH {1} \
   CONFIG.IN1_WIDTH {1} \
   CONFIG.IN2_WIDTH {1} \
   CONFIG.NUM_PORTS {3} \
 ] $y2_group_B

  # Create instance: y2_sel, and set properties
  set y2_sel [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 y2_sel ]
  set_property -dict [ list \
   CONFIG.C_OPERATION {or} \
   CONFIG.C_SIZE {1} \
   CONFIG.LOGO_FILE {data/sym_orgate.png} \
 ] $y2_sel

  # Create instance: y2_sel_A, and set properties
  set y2_sel_A [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_reduced_logic:2.0 y2_sel_A ]
  set_property -dict [ list \
   CONFIG.C_SIZE {3} \
 ] $y2_sel_A

  # Create instance: y2_sel_B, and set properties
  set y2_sel_B [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_reduced_logic:2.0 y2_sel_B ]
  set_property -dict [ list \
   CONFIG.C_SIZE {3} \
 ] $y2_sel_B

  # Create port connections
  connect_bd_net -net nx0_Dout [get_bd_pins nx0/Dout] [get_bd_pins y0_group_B/In0] [get_bd_pins y2_group_B/In0]
  connect_bd_net -net nx1_Dout [get_bd_pins nx1/Dout] [get_bd_pins y0_group_A/In1] [get_bd_pins y2_group_B/In1]
  connect_bd_net -net nx2_Dout [get_bd_pins nx2/Dout] [get_bd_pins y0_group_A/In2] [get_bd_pins y2_group_A/In2]
  connect_bd_net -net util_reduced_logic_0_Res [get_bd_pins y1_sel/Op1] [get_bd_pins y1_sel_A/Res]
  connect_bd_net -net util_reduced_logic_1_Res [get_bd_pins y1_sel/Op2] [get_bd_pins y1_sel_B/Res]
  connect_bd_net -net util_reduced_logic_2_Res [get_bd_pins y0_sel/Op1] [get_bd_pins y0_sel_A/Res]
  connect_bd_net -net util_reduced_logic_3_Res [get_bd_pins y0_sel/Op2] [get_bd_pins y0_sel_B/Res]
  connect_bd_net -net util_reduced_logic_4_Res [get_bd_pins y2_sel/Op1] [get_bd_pins y2_sel_A/Res]
  connect_bd_net -net util_reduced_logic_5_Res [get_bd_pins y2_sel/Op2] [get_bd_pins y2_sel_B/Res]
  connect_bd_net -net util_vector_logic_0_Res [get_bd_pins nx/Res] [get_bd_pins nx0/Din] [get_bd_pins nx1/Din] [get_bd_pins nx2/Din] [get_bd_pins y1_sel_A/Op1]
  connect_bd_net -net util_vector_logic_1_Res [get_bd_pins y1_sel] [get_bd_pins y1_sel/Res]
  connect_bd_net -net util_vector_logic_2_Res [get_bd_pins y0_sel] [get_bd_pins y0_sel/Res]
  connect_bd_net -net util_vector_logic_3_Res [get_bd_pins y2_sel] [get_bd_pins y2_sel/Res]
  connect_bd_net -net x0_1 [get_bd_pins x0] [get_bd_pins x/In0] [get_bd_pins y0_group_A/In0] [get_bd_pins y2_group_A/In0]
  connect_bd_net -net x1_1 [get_bd_pins x1] [get_bd_pins x/In1] [get_bd_pins y0_group_B/In1] [get_bd_pins y2_group_A/In1]
  connect_bd_net -net x2_1 [get_bd_pins x2] [get_bd_pins x/In2] [get_bd_pins y0_group_B/In2] [get_bd_pins y2_group_B/In2]
  connect_bd_net -net xlconcat_0_dout [get_bd_pins nx/Op1] [get_bd_pins x/dout] [get_bd_pins y1_sel_B/Op1]
  connect_bd_net -net xlconcat_1_dout [get_bd_pins y0_group_A/dout] [get_bd_pins y0_sel_A/Op1]
  connect_bd_net -net xlconcat_2_dout [get_bd_pins y0_group_B/dout] [get_bd_pins y0_sel_B/Op1]
  connect_bd_net -net xlconcat_3_dout [get_bd_pins y2_group_A/dout] [get_bd_pins y2_sel_A/Op1]
  connect_bd_net -net xlconcat_4_dout [get_bd_pins y2_group_B/dout] [get_bd_pins y2_sel_B/Op1]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: sel0
proc create_hier_cell_sel0 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_sel0() - Empty argument(s)!"}
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
  create_bd_pin -dir I -from 0 -to 0 x0
  create_bd_pin -dir I -from 0 -to 0 x1
  create_bd_pin -dir I -from 0 -to 0 x2
  create_bd_pin -dir O -from 0 -to 0 y0_sel
  create_bd_pin -dir O -from 0 -to 0 y1_sel
  create_bd_pin -dir O -from 0 -to 0 y2_sel

  # Create instance: nx, and set properties
  set nx [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 nx ]
  set_property -dict [ list \
   CONFIG.C_OPERATION {not} \
   CONFIG.C_SIZE {3} \
   CONFIG.LOGO_FILE {data/sym_notgate.png} \
 ] $nx

  # Create instance: nx0, and set properties
  set nx0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 nx0 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {0} \
   CONFIG.DIN_TO {0} \
   CONFIG.DIN_WIDTH {3} \
 ] $nx0

  # Create instance: nx1, and set properties
  set nx1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 nx1 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {1} \
   CONFIG.DIN_TO {1} \
   CONFIG.DIN_WIDTH {3} \
   CONFIG.DOUT_WIDTH {1} \
 ] $nx1

  # Create instance: nx2, and set properties
  set nx2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 nx2 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {2} \
   CONFIG.DIN_TO {2} \
   CONFIG.DIN_WIDTH {3} \
   CONFIG.DOUT_WIDTH {1} \
 ] $nx2

  # Create instance: x, and set properties
  set x [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 x ]
  set_property -dict [ list \
   CONFIG.IN0_WIDTH {1} \
   CONFIG.IN1_WIDTH {1} \
   CONFIG.IN2_WIDTH {1} \
   CONFIG.NUM_PORTS {3} \
 ] $x

  # Create instance: y0_group_A, and set properties
  set y0_group_A [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 y0_group_A ]
  set_property -dict [ list \
   CONFIG.IN0_WIDTH {1} \
   CONFIG.IN1_WIDTH {1} \
   CONFIG.IN2_WIDTH {1} \
   CONFIG.NUM_PORTS {3} \
 ] $y0_group_A

  # Create instance: y0_group_B, and set properties
  set y0_group_B [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 y0_group_B ]
  set_property -dict [ list \
   CONFIG.IN0_WIDTH {1} \
   CONFIG.IN1_WIDTH {1} \
   CONFIG.IN2_WIDTH {1} \
   CONFIG.NUM_PORTS {3} \
 ] $y0_group_B

  # Create instance: y0_sel, and set properties
  set y0_sel [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 y0_sel ]
  set_property -dict [ list \
   CONFIG.C_OPERATION {or} \
   CONFIG.C_SIZE {1} \
   CONFIG.LOGO_FILE {data/sym_orgate.png} \
 ] $y0_sel

  # Create instance: y0_sel_A, and set properties
  set y0_sel_A [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_reduced_logic:2.0 y0_sel_A ]
  set_property -dict [ list \
   CONFIG.C_SIZE {3} \
 ] $y0_sel_A

  # Create instance: y0_sel_B, and set properties
  set y0_sel_B [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_reduced_logic:2.0 y0_sel_B ]
  set_property -dict [ list \
   CONFIG.C_SIZE {3} \
 ] $y0_sel_B

  # Create instance: y1_sel, and set properties
  set y1_sel [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 y1_sel ]
  set_property -dict [ list \
   CONFIG.C_OPERATION {or} \
   CONFIG.C_SIZE {1} \
   CONFIG.LOGO_FILE {data/sym_orgate.png} \
 ] $y1_sel

  # Create instance: y1_sel_A, and set properties
  set y1_sel_A [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_reduced_logic:2.0 y1_sel_A ]
  set_property -dict [ list \
   CONFIG.C_SIZE {3} \
 ] $y1_sel_A

  # Create instance: y1_sel_B, and set properties
  set y1_sel_B [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_reduced_logic:2.0 y1_sel_B ]
  set_property -dict [ list \
   CONFIG.C_SIZE {3} \
 ] $y1_sel_B

  # Create instance: y2_group_A, and set properties
  set y2_group_A [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 y2_group_A ]
  set_property -dict [ list \
   CONFIG.IN0_WIDTH {1} \
   CONFIG.IN1_WIDTH {1} \
   CONFIG.IN2_WIDTH {1} \
   CONFIG.NUM_PORTS {3} \
 ] $y2_group_A

  # Create instance: y2_group_B, and set properties
  set y2_group_B [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 y2_group_B ]
  set_property -dict [ list \
   CONFIG.IN0_WIDTH {1} \
   CONFIG.IN1_WIDTH {1} \
   CONFIG.IN2_WIDTH {1} \
   CONFIG.NUM_PORTS {3} \
 ] $y2_group_B

  # Create instance: y2_sel, and set properties
  set y2_sel [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 y2_sel ]
  set_property -dict [ list \
   CONFIG.C_OPERATION {or} \
   CONFIG.C_SIZE {1} \
   CONFIG.LOGO_FILE {data/sym_orgate.png} \
 ] $y2_sel

  # Create instance: y2_sel_A, and set properties
  set y2_sel_A [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_reduced_logic:2.0 y2_sel_A ]
  set_property -dict [ list \
   CONFIG.C_SIZE {3} \
 ] $y2_sel_A

  # Create instance: y2_sel_B, and set properties
  set y2_sel_B [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_reduced_logic:2.0 y2_sel_B ]
  set_property -dict [ list \
   CONFIG.C_SIZE {3} \
 ] $y2_sel_B

  # Create port connections
  connect_bd_net -net nx0_Dout [get_bd_pins nx0/Dout] [get_bd_pins y0_group_B/In0] [get_bd_pins y2_group_B/In0]
  connect_bd_net -net nx1_Dout [get_bd_pins nx1/Dout] [get_bd_pins y0_group_A/In1] [get_bd_pins y2_group_B/In1]
  connect_bd_net -net nx2_Dout [get_bd_pins nx2/Dout] [get_bd_pins y0_group_A/In2] [get_bd_pins y2_group_A/In2]
  connect_bd_net -net util_reduced_logic_0_Res [get_bd_pins y1_sel/Op1] [get_bd_pins y1_sel_A/Res]
  connect_bd_net -net util_reduced_logic_1_Res [get_bd_pins y1_sel/Op2] [get_bd_pins y1_sel_B/Res]
  connect_bd_net -net util_reduced_logic_2_Res [get_bd_pins y0_sel/Op1] [get_bd_pins y0_sel_A/Res]
  connect_bd_net -net util_reduced_logic_3_Res [get_bd_pins y0_sel/Op2] [get_bd_pins y0_sel_B/Res]
  connect_bd_net -net util_reduced_logic_4_Res [get_bd_pins y2_sel/Op1] [get_bd_pins y2_sel_A/Res]
  connect_bd_net -net util_reduced_logic_5_Res [get_bd_pins y2_sel/Op2] [get_bd_pins y2_sel_B/Res]
  connect_bd_net -net util_vector_logic_0_Res [get_bd_pins nx/Res] [get_bd_pins nx0/Din] [get_bd_pins nx1/Din] [get_bd_pins nx2/Din] [get_bd_pins y1_sel_A/Op1]
  connect_bd_net -net util_vector_logic_1_Res [get_bd_pins y1_sel] [get_bd_pins y1_sel/Res]
  connect_bd_net -net util_vector_logic_2_Res [get_bd_pins y0_sel] [get_bd_pins y0_sel/Res]
  connect_bd_net -net util_vector_logic_3_Res [get_bd_pins y2_sel] [get_bd_pins y2_sel/Res]
  connect_bd_net -net x0_1 [get_bd_pins x0] [get_bd_pins x/In0] [get_bd_pins y0_group_A/In0] [get_bd_pins y2_group_A/In0]
  connect_bd_net -net x1_1 [get_bd_pins x1] [get_bd_pins x/In1] [get_bd_pins y0_group_B/In1] [get_bd_pins y2_group_A/In1]
  connect_bd_net -net x2_1 [get_bd_pins x2] [get_bd_pins x/In2] [get_bd_pins y0_group_B/In2] [get_bd_pins y2_group_B/In2]
  connect_bd_net -net xlconcat_0_dout [get_bd_pins nx/Op1] [get_bd_pins x/dout] [get_bd_pins y1_sel_B/Op1]
  connect_bd_net -net xlconcat_1_dout [get_bd_pins y0_group_A/dout] [get_bd_pins y0_sel_A/Op1]
  connect_bd_net -net xlconcat_2_dout [get_bd_pins y0_group_B/dout] [get_bd_pins y0_sel_B/Op1]
  connect_bd_net -net xlconcat_3_dout [get_bd_pins y2_group_A/dout] [get_bd_pins y2_sel_A/Op1]
  connect_bd_net -net xlconcat_4_dout [get_bd_pins y2_group_B/dout] [get_bd_pins y2_sel_B/Op1]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: mux1
proc create_hier_cell_mux1 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_mux1() - Empty argument(s)!"}
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
  create_bd_pin -dir O -from 7 -to 0 p1
  create_bd_pin -dir I -from 7 -to 0 y0
  create_bd_pin -dir I -from 0 -to 0 y0_sel
  create_bd_pin -dir I -from 7 -to 0 y1
  create_bd_pin -dir I -from 0 -to 0 y1_sel
  create_bd_pin -dir I -from 7 -to 0 y2
  create_bd_pin -dir I -from 0 -to 0 y2_sel

  # Create instance: or_01, and set properties
  set or_01 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 or_01 ]
  set_property -dict [ list \
   CONFIG.C_OPERATION {or} \
   CONFIG.LOGO_FILE {data/sym_orgate.png} \
 ] $or_01

  # Create instance: or_012, and set properties
  set or_012 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 or_012 ]
  set_property -dict [ list \
   CONFIG.C_OPERATION {or} \
   CONFIG.LOGO_FILE {data/sym_orgate.png} \
 ] $or_012

  # Create instance: y1_1, and set properties
  set y1_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 y1_1 ]

  # Create instance: y1_1_mask, and set properties
  set y1_1_mask [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 y1_1_mask ]
  set_property -dict [ list \
   CONFIG.IN0_WIDTH {1} \
   CONFIG.IN1_WIDTH {1} \
   CONFIG.IN2_WIDTH {1} \
   CONFIG.IN3_WIDTH {1} \
   CONFIG.IN4_WIDTH {1} \
   CONFIG.IN5_WIDTH {1} \
   CONFIG.IN6_WIDTH {1} \
   CONFIG.IN7_WIDTH {1} \
   CONFIG.NUM_PORTS {8} \
 ] $y1_1_mask

  # Create instance: y2_1, and set properties
  set y2_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 y2_1 ]

  # Create instance: y2_1_mask, and set properties
  set y2_1_mask [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 y2_1_mask ]
  set_property -dict [ list \
   CONFIG.IN0_WIDTH {1} \
   CONFIG.IN1_WIDTH {1} \
   CONFIG.IN2_WIDTH {1} \
   CONFIG.IN3_WIDTH {1} \
   CONFIG.IN4_WIDTH {1} \
   CONFIG.IN5_WIDTH {1} \
   CONFIG.IN6_WIDTH {1} \
   CONFIG.IN7_WIDTH {1} \
   CONFIG.NUM_PORTS {8} \
 ] $y2_1_mask

  # Create instance: y3_1, and set properties
  set y3_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 y3_1 ]

  # Create instance: y3_1_mask, and set properties
  set y3_1_mask [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 y3_1_mask ]
  set_property -dict [ list \
   CONFIG.IN0_WIDTH {1} \
   CONFIG.IN1_WIDTH {1} \
   CONFIG.IN2_WIDTH {1} \
   CONFIG.IN3_WIDTH {1} \
   CONFIG.IN4_WIDTH {1} \
   CONFIG.IN5_WIDTH {1} \
   CONFIG.IN6_WIDTH {1} \
   CONFIG.IN7_WIDTH {1} \
   CONFIG.NUM_PORTS {8} \
 ] $y3_1_mask

  # Create port connections
  connect_bd_net -net i0_2 [get_bd_pins or_01/Op1] [get_bd_pins y1_1/Res]
  connect_bd_net -net i1_2 [get_bd_pins or_01/Op2] [get_bd_pins y2_1/Res]
  connect_bd_net -net i2_2 [get_bd_pins or_012/Op2] [get_bd_pins y3_1/Res]
  connect_bd_net -net mux_sel_y1_1_sel [get_bd_pins y0_sel] [get_bd_pins y1_1_mask/In0] [get_bd_pins y1_1_mask/In1] [get_bd_pins y1_1_mask/In2] [get_bd_pins y1_1_mask/In3] [get_bd_pins y1_1_mask/In4] [get_bd_pins y1_1_mask/In5] [get_bd_pins y1_1_mask/In6] [get_bd_pins y1_1_mask/In7]
  connect_bd_net -net mux_sel_y2_1_sel [get_bd_pins y1_sel] [get_bd_pins y2_1_mask/In0] [get_bd_pins y2_1_mask/In1] [get_bd_pins y2_1_mask/In2] [get_bd_pins y2_1_mask/In3] [get_bd_pins y2_1_mask/In4] [get_bd_pins y2_1_mask/In5] [get_bd_pins y2_1_mask/In6] [get_bd_pins y2_1_mask/In7]
  connect_bd_net -net mux_sel_y3_1_sel [get_bd_pins y2_sel] [get_bd_pins y3_1_mask/In0] [get_bd_pins y3_1_mask/In1] [get_bd_pins y3_1_mask/In2] [get_bd_pins y3_1_mask/In3] [get_bd_pins y3_1_mask/In4] [get_bd_pins y3_1_mask/In5] [get_bd_pins y3_1_mask/In6] [get_bd_pins y3_1_mask/In7]
  connect_bd_net -net or3_1_o [get_bd_pins p1] [get_bd_pins or_012/Res]
  connect_bd_net -net tap_2_y1_Q [get_bd_pins y0] [get_bd_pins y1_1/Op1]
  connect_bd_net -net tap_2_y2_Q [get_bd_pins y1] [get_bd_pins y2_1/Op1]
  connect_bd_net -net tap_2_y3_Q [get_bd_pins y2] [get_bd_pins y3_1/Op1]
  connect_bd_net -net util_vector_logic_0_Res_1 [get_bd_pins or_01/Res] [get_bd_pins or_012/Op1]
  connect_bd_net -net y1_1_mask_dout [get_bd_pins y1_1/Op2] [get_bd_pins y1_1_mask/dout]
  connect_bd_net -net y2_1_mask_dout [get_bd_pins y2_1/Op2] [get_bd_pins y2_1_mask/dout]
  connect_bd_net -net y3_1_mask_dout [get_bd_pins y3_1/Op2] [get_bd_pins y3_1_mask/dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: mux0
proc create_hier_cell_mux0 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_mux0() - Empty argument(s)!"}
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
  create_bd_pin -dir O -from 7 -to 0 p0
  create_bd_pin -dir I -from 7 -to 0 y0
  create_bd_pin -dir I -from 0 -to 0 y0_sel
  create_bd_pin -dir I -from 7 -to 0 y1
  create_bd_pin -dir I -from 0 -to 0 y1_sel
  create_bd_pin -dir I -from 7 -to 0 y2
  create_bd_pin -dir I -from 0 -to 0 y2_sel

  # Create instance: or_01, and set properties
  set or_01 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 or_01 ]
  set_property -dict [ list \
   CONFIG.C_OPERATION {or} \
   CONFIG.LOGO_FILE {data/sym_orgate.png} \
 ] $or_01

  # Create instance: or_012, and set properties
  set or_012 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 or_012 ]
  set_property -dict [ list \
   CONFIG.C_OPERATION {or} \
   CONFIG.LOGO_FILE {data/sym_orgate.png} \
 ] $or_012

  # Create instance: y0_0, and set properties
  set y0_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 y0_0 ]

  # Create instance: y0_0_mask, and set properties
  set y0_0_mask [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 y0_0_mask ]
  set_property -dict [ list \
   CONFIG.IN0_WIDTH {1} \
   CONFIG.IN1_WIDTH {1} \
   CONFIG.IN2_WIDTH {1} \
   CONFIG.IN3_WIDTH {1} \
   CONFIG.IN4_WIDTH {1} \
   CONFIG.IN5_WIDTH {1} \
   CONFIG.IN6_WIDTH {1} \
   CONFIG.IN7_WIDTH {1} \
   CONFIG.NUM_PORTS {8} \
 ] $y0_0_mask

  # Create instance: y1_0, and set properties
  set y1_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 y1_0 ]

  # Create instance: y1_0_mask, and set properties
  set y1_0_mask [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 y1_0_mask ]
  set_property -dict [ list \
   CONFIG.IN0_WIDTH {1} \
   CONFIG.IN1_WIDTH {1} \
   CONFIG.IN2_WIDTH {1} \
   CONFIG.IN3_WIDTH {1} \
   CONFIG.IN4_WIDTH {1} \
   CONFIG.IN5_WIDTH {1} \
   CONFIG.IN6_WIDTH {1} \
   CONFIG.IN7_WIDTH {1} \
   CONFIG.NUM_PORTS {8} \
 ] $y1_0_mask

  # Create instance: y2_0, and set properties
  set y2_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 y2_0 ]

  # Create instance: y2_0_mask, and set properties
  set y2_0_mask [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 y2_0_mask ]
  set_property -dict [ list \
   CONFIG.IN0_WIDTH {1} \
   CONFIG.IN1_WIDTH {1} \
   CONFIG.IN2_WIDTH {1} \
   CONFIG.IN3_WIDTH {1} \
   CONFIG.IN4_WIDTH {1} \
   CONFIG.IN5_WIDTH {1} \
   CONFIG.IN6_WIDTH {1} \
   CONFIG.IN7_WIDTH {1} \
   CONFIG.NUM_PORTS {8} \
 ] $y2_0_mask

  # Create port connections
  connect_bd_net -net i0_1 [get_bd_pins or_01/Op1] [get_bd_pins y0_0/Res]
  connect_bd_net -net i1_1 [get_bd_pins or_01/Op2] [get_bd_pins y1_0/Res]
  connect_bd_net -net i2_1 [get_bd_pins or_012/Op2] [get_bd_pins y2_0/Res]
  connect_bd_net -net mux_sel_y0_0_sel [get_bd_pins y0_sel] [get_bd_pins y0_0_mask/In0] [get_bd_pins y0_0_mask/In1] [get_bd_pins y0_0_mask/In2] [get_bd_pins y0_0_mask/In3] [get_bd_pins y0_0_mask/In4] [get_bd_pins y0_0_mask/In5] [get_bd_pins y0_0_mask/In6] [get_bd_pins y0_0_mask/In7]
  connect_bd_net -net mux_sel_y1_0_sel [get_bd_pins y1_sel] [get_bd_pins y1_0_mask/In0] [get_bd_pins y1_0_mask/In1] [get_bd_pins y1_0_mask/In2] [get_bd_pins y1_0_mask/In3] [get_bd_pins y1_0_mask/In4] [get_bd_pins y1_0_mask/In5] [get_bd_pins y1_0_mask/In6] [get_bd_pins y1_0_mask/In7]
  connect_bd_net -net mux_sel_y2_0_sel [get_bd_pins y2_sel] [get_bd_pins y2_0_mask/In0] [get_bd_pins y2_0_mask/In1] [get_bd_pins y2_0_mask/In2] [get_bd_pins y2_0_mask/In3] [get_bd_pins y2_0_mask/In4] [get_bd_pins y2_0_mask/In5] [get_bd_pins y2_0_mask/In6] [get_bd_pins y2_0_mask/In7]
  connect_bd_net -net or3_0_o [get_bd_pins p0] [get_bd_pins or_012/Res]
  connect_bd_net -net tap_2_y0_Q [get_bd_pins y0] [get_bd_pins y0_0/Op1]
  connect_bd_net -net tap_2_y1_Q [get_bd_pins y1] [get_bd_pins y1_0/Op1]
  connect_bd_net -net tap_2_y2_Q [get_bd_pins y2] [get_bd_pins y2_0/Op1]
  connect_bd_net -net util_vector_logic_0_Res [get_bd_pins or_01/Res] [get_bd_pins or_012/Op1]
  connect_bd_net -net y0_0_mask_dout [get_bd_pins y0_0/Op2] [get_bd_pins y0_0_mask/dout]
  connect_bd_net -net y1_0_mask_dout [get_bd_pins y1_0/Op2] [get_bd_pins y1_0_mask/dout]
  connect_bd_net -net y2_0_mask_dout [get_bd_pins y2_0/Op2] [get_bd_pins y2_0_mask/dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: cmp
proc create_hier_cell_cmp { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_cmp() - Empty argument(s)!"}
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
  create_bd_pin -dir I -from 0 -to 0 last_in
  create_bd_pin -dir O -from 0 -to 0 last_out
  create_bd_pin -dir I -from 0 -to 0 user_in
  create_bd_pin -dir O -from 0 -to 0 user_out
  create_bd_pin -dir I -from 0 -to 0 valid_in
  create_bd_pin -dir O -from 0 -to 0 valid_out
  create_bd_pin -dir I -from 7 -to 0 y0
  create_bd_pin -dir O -from 7 -to 0 y0_d
  create_bd_pin -dir I -from 7 -to 0 y1
  create_bd_pin -dir O -from 7 -to 0 y1_d
  create_bd_pin -dir O -from 0 -to 0 y1y0_n
  create_bd_pin -dir I -from 7 -to 0 y2
  create_bd_pin -dir O -from 7 -to 0 y2_d
  create_bd_pin -dir O -from 0 -to 0 y2y0_n
  create_bd_pin -dir O -from 0 -to 0 y2y1_n
  create_bd_pin -dir I -from 7 -to 0 y3
  create_bd_pin -dir O -from 7 -to 0 y3_d
  create_bd_pin -dir O -from 0 -to 0 y3y1_n
  create_bd_pin -dir O -from 0 -to 0 y3y2_n

  # Create instance: cmp_y1y0_n
  create_hier_cell_cmp_y1y0_n $hier_obj cmp_y1y0_n

  # Create instance: cmp_y2y0_n
  create_hier_cell_cmp_y2y0_n $hier_obj cmp_y2y0_n

  # Create instance: cmp_y2y1_n
  create_hier_cell_cmp_y2y1_n $hier_obj cmp_y2y1_n

  # Create instance: cmp_y3y1_n
  create_hier_cell_cmp_y3y1_n $hier_obj cmp_y3y1_n

  # Create instance: cmp_y3y2_n
  create_hier_cell_cmp_y3y2_n $hier_obj cmp_y3y2_n

  # Create instance: tap_1
  create_hier_cell_tap_1 $hier_obj tap_1

  # Create instance: upad0
  create_hier_cell_upad0 $hier_obj upad0

  # Create instance: upad1
  create_hier_cell_upad1 $hier_obj upad1

  # Create instance: upad2
  create_hier_cell_upad2 $hier_obj upad2

  # Create instance: upad3
  create_hier_cell_upad3 $hier_obj upad3

  # Create port connections
  connect_bd_net -net Net [get_bd_pins CLK] [get_bd_pins cmp_y1y0_n/CLK] [get_bd_pins cmp_y2y0_n/CLK] [get_bd_pins cmp_y2y1_n/CLK] [get_bd_pins cmp_y3y1_n/CLK] [get_bd_pins cmp_y3y2_n/CLK] [get_bd_pins tap_1/CLK]
  connect_bd_net -net cmp_y1y0_n_n [get_bd_pins y1y0_n] [get_bd_pins cmp_y1y0_n/n]
  connect_bd_net -net cmp_y2y0_n_n [get_bd_pins y2y0_n] [get_bd_pins cmp_y2y0_n/n]
  connect_bd_net -net cmp_y2y1_n_n [get_bd_pins y2y1_n] [get_bd_pins cmp_y2y1_n/n]
  connect_bd_net -net cmp_y3y1_n_n [get_bd_pins y3y1_n] [get_bd_pins cmp_y3y1_n/n]
  connect_bd_net -net cmp_y3y2_n_n [get_bd_pins y3y2_n] [get_bd_pins cmp_y3y2_n/n]
  connect_bd_net -net last_in_1 [get_bd_pins last_in] [get_bd_pins tap_1/last_in]
  connect_bd_net -net tap_1_last_out [get_bd_pins last_out] [get_bd_pins tap_1/last_out]
  connect_bd_net -net tap_1_user_out [get_bd_pins user_out] [get_bd_pins tap_1/user_out]
  connect_bd_net -net tap_1_valid_out [get_bd_pins valid_out] [get_bd_pins tap_1/valid_out]
  connect_bd_net -net tap_1_y0_Q [get_bd_pins y0_d] [get_bd_pins tap_1/y0_d]
  connect_bd_net -net tap_1_y1_Q [get_bd_pins y1_d] [get_bd_pins tap_1/y1_d]
  connect_bd_net -net tap_1_y2_Q [get_bd_pins y2_d] [get_bd_pins tap_1/y2_d]
  connect_bd_net -net tap_1_y3_Q [get_bd_pins y3_d] [get_bd_pins tap_1/y3_d]
  connect_bd_net -net uin_1 [get_bd_pins y0] [get_bd_pins tap_1/y0] [get_bd_pins upad0/uin]
  connect_bd_net -net uin_2 [get_bd_pins y1] [get_bd_pins tap_1/y1] [get_bd_pins upad1/uin]
  connect_bd_net -net uin_3 [get_bd_pins y2] [get_bd_pins tap_1/y2] [get_bd_pins upad2/uin]
  connect_bd_net -net uin_4 [get_bd_pins y3] [get_bd_pins tap_1/y3] [get_bd_pins upad3/uin]
  connect_bd_net -net upad0_sout [get_bd_pins cmp_y1y0_n/B] [get_bd_pins cmp_y2y0_n/B] [get_bd_pins upad0/sout]
  connect_bd_net -net upad1_sout [get_bd_pins cmp_y1y0_n/A] [get_bd_pins cmp_y2y1_n/B] [get_bd_pins cmp_y3y1_n/B] [get_bd_pins upad1/sout]
  connect_bd_net -net upad2_sout [get_bd_pins cmp_y2y0_n/A] [get_bd_pins cmp_y2y1_n/A] [get_bd_pins cmp_y3y2_n/B] [get_bd_pins upad2/sout]
  connect_bd_net -net upad3_sout [get_bd_pins cmp_y3y1_n/A] [get_bd_pins cmp_y3y2_n/A] [get_bd_pins upad3/sout]
  connect_bd_net -net user_in_1 [get_bd_pins user_in] [get_bd_pins tap_1/user_in]
  connect_bd_net -net valid_in_1 [get_bd_pins valid_in] [get_bd_pins tap_1/valid_in]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: median_filter
proc create_hier_cell_median_filter { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_median_filter() - Empty argument(s)!"}
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
  create_bd_pin -dir I -from 15 -to 0 din
  create_bd_pin -dir O -from 15 -to 0 dout
  create_bd_pin -dir I last_in
  create_bd_pin -dir O -from 0 -to 0 last_out
  create_bd_pin -dir I user_in
  create_bd_pin -dir O -from 0 -to 0 user_out
  create_bd_pin -dir I valid_in
  create_bd_pin -dir O -from 0 -to 0 valid_out

  # Create instance: cmp
  create_hier_cell_cmp $hier_obj cmp

  # Create instance: mux0
  create_hier_cell_mux0 $hier_obj mux0

  # Create instance: mux1
  create_hier_cell_mux1 $hier_obj mux1

  # Create instance: pack, and set properties
  set pack [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 pack ]
  set_property -dict [ list \
   CONFIG.IN0_WIDTH {8} \
   CONFIG.IN1_WIDTH {8} \
 ] $pack

  # Create instance: sel0
  create_hier_cell_sel0 $hier_obj sel0

  # Create instance: sel1
  create_hier_cell_sel1 $hier_obj sel1

  # Create instance: window
  create_hier_cell_window $hier_obj window

  # Create port connections
  connect_bd_net -net CE_1 [get_bd_pins valid_in] [get_bd_pins window/valid_in]
  connect_bd_net -net D_1 [get_bd_pins din] [get_bd_pins window/din]
  connect_bd_net -net Net [get_bd_pins CLK] [get_bd_pins cmp/CLK] [get_bd_pins window/CLK]
  connect_bd_net -net cmp_last_out [get_bd_pins last_out] [get_bd_pins cmp/last_out]
  connect_bd_net -net cmp_user_out [get_bd_pins user_out] [get_bd_pins cmp/user_out]
  connect_bd_net -net cmp_valid_out [get_bd_pins valid_out] [get_bd_pins cmp/valid_out]
  connect_bd_net -net cmp_y1y0_n_n [get_bd_pins cmp/y1y0_n] [get_bd_pins sel0/x0]
  connect_bd_net -net cmp_y2y0_n_n [get_bd_pins cmp/y2y0_n] [get_bd_pins sel0/x1]
  connect_bd_net -net cmp_y2y1_n_n [get_bd_pins cmp/y2y1_n] [get_bd_pins sel0/x2] [get_bd_pins sel1/x0]
  connect_bd_net -net last_1 [get_bd_pins last_in] [get_bd_pins window/last_in]
  connect_bd_net -net mux0_p0 [get_bd_pins mux0/p0] [get_bd_pins pack/In0]
  connect_bd_net -net mux1_p1 [get_bd_pins mux1/p1] [get_bd_pins pack/In1]
  connect_bd_net -net mux_sel_y0_0_sel [get_bd_pins mux0/y0_sel] [get_bd_pins sel0/y0_sel]
  connect_bd_net -net mux_sel_y1_0_sel [get_bd_pins mux0/y1_sel] [get_bd_pins sel0/y1_sel]
  connect_bd_net -net mux_sel_y2_0_sel [get_bd_pins mux0/y2_sel] [get_bd_pins sel0/y2_sel]
  connect_bd_net -net pack_dout [get_bd_pins dout] [get_bd_pins pack/dout]
  connect_bd_net -net sel1_y0_sel [get_bd_pins mux1/y0_sel] [get_bd_pins sel1/y0_sel]
  connect_bd_net -net sel1_y1_sel [get_bd_pins mux1/y1_sel] [get_bd_pins sel1/y1_sel]
  connect_bd_net -net sel1_y2_sel [get_bd_pins mux1/y2_sel] [get_bd_pins sel1/y2_sel]
  connect_bd_net -net stage1_1_y0_d [get_bd_pins cmp/y0_d] [get_bd_pins mux0/y0]
  connect_bd_net -net stage1_1_y1_d [get_bd_pins cmp/y1_d] [get_bd_pins mux0/y1] [get_bd_pins mux1/y0]
  connect_bd_net -net stage1_1_y2_d [get_bd_pins cmp/y2_d] [get_bd_pins mux0/y2] [get_bd_pins mux1/y1]
  connect_bd_net -net stage1_1_y3_d [get_bd_pins cmp/y3_d] [get_bd_pins mux1/y2]
  connect_bd_net -net uin_1 [get_bd_pins cmp/y0] [get_bd_pins window/y0]
  connect_bd_net -net uin_2 [get_bd_pins cmp/y1] [get_bd_pins window/y1]
  connect_bd_net -net uin_3 [get_bd_pins cmp/y2] [get_bd_pins window/y2]
  connect_bd_net -net uin_4 [get_bd_pins cmp/y3] [get_bd_pins window/y3]
  connect_bd_net -net user_in_1 [get_bd_pins user_in] [get_bd_pins window/user_in]
  connect_bd_net -net window_last_out [get_bd_pins cmp/last_in] [get_bd_pins window/last_out]
  connect_bd_net -net window_user_out [get_bd_pins cmp/user_in] [get_bd_pins window/user_out]
  connect_bd_net -net window_valid_out [get_bd_pins cmp/valid_in] [get_bd_pins window/valid_out]
  connect_bd_net -net x1_1 [get_bd_pins cmp/y3y1_n] [get_bd_pins sel1/x1]
  connect_bd_net -net x2_1 [get_bd_pins cmp/y3y2_n] [get_bd_pins sel1/x2]

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
  set tdata_in [ create_bd_port -dir I -from 15 -to 0 tdata_in ]
  set tdata_out [ create_bd_port -dir O -from 15 -to 0 tdata_out ]
  set tlast_in [ create_bd_port -dir I tlast_in ]
  set tlast_out [ create_bd_port -dir O -from 0 -to 0 tlast_out ]
  set tready_in [ create_bd_port -dir O -from 0 -to 0 tready_in ]
  set tready_out [ create_bd_port -dir I tready_out ]
  set tuser_in [ create_bd_port -dir I tuser_in ]
  set tuser_out [ create_bd_port -dir O -from 0 -to 0 tuser_out ]
  set tvalid_in [ create_bd_port -dir I tvalid_in ]
  set tvalid_out [ create_bd_port -dir O -from 0 -to 0 tvalid_out ]

  # Create instance: median_filter
  create_hier_cell_median_filter [current_bd_instance .] median_filter

  # Create instance: o_1, and set properties
  set o_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 o_1 ]

  # Create port connections
  connect_bd_net -net CLK_1 [get_bd_ports CLK] [get_bd_pins median_filter/CLK]
  connect_bd_net -net din_1 [get_bd_ports tdata_in] [get_bd_pins median_filter/din]
  connect_bd_net -net last_in_1 [get_bd_ports tlast_in] [get_bd_pins median_filter/last_in]
  connect_bd_net -net median_filter_dout [get_bd_ports tdata_out] [get_bd_pins median_filter/dout]
  connect_bd_net -net median_filter_last_out [get_bd_ports tlast_out] [get_bd_pins median_filter/last_out]
  connect_bd_net -net median_filter_user_out [get_bd_ports tuser_out] [get_bd_pins median_filter/user_out]
  connect_bd_net -net median_filter_valid_out [get_bd_ports tvalid_out] [get_bd_pins median_filter/valid_out]
  connect_bd_net -net o_1_dout [get_bd_ports tready_in] [get_bd_pins o_1/dout]
  connect_bd_net -net user_in_1 [get_bd_ports tuser_in] [get_bd_pins median_filter/user_in]
  connect_bd_net -net valid_in_1 [get_bd_ports tvalid_in] [get_bd_pins median_filter/valid_in]

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


