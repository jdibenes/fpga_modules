
################################################################
# This is a generated script based on design: rgb2y
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
# source rgb2y_script.tcl

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
set design_name rgb2y

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
xilinx.com:ip:xlconcat:2.1\
xilinx.com:ip:xlslice:1.0\
xilinx.com:ip:xlconstant:1.1\
xilinx.com:ip:c_shift_ram:12.0\
xilinx.com:ip:util_vector_logic:2.0\
xilinx.com:ip:util_reduced_logic:2.0\
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


# Hierarchical cell: shr_R
proc create_hier_cell_shr_R_1 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_shr_R_1() - Empty argument(s)!"}
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
  create_bd_pin -dir I -from 7 -to 0 R
  create_bd_pin -dir O -from 7 -to 0 r1_4_0
  create_bd_pin -dir O -from 7 -to 0 r2_1_0
  create_bd_pin -dir O -from 7 -to 0 r3_0_0

  # Create port connections
  connect_bd_net -net R_1 [get_bd_pins R] [get_bd_pins r1_4_0] [get_bd_pins r2_1_0] [get_bd_pins r3_0_0]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: shr_G
proc create_hier_cell_shr_G_1 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_shr_G_1() - Empty argument(s)!"}
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
  create_bd_pin -dir I -from 7 -to 0 G
  create_bd_pin -dir O -from 7 -to 0 g1_5_0
  create_bd_pin -dir O -from 7 -to 0 g2_2_0
  create_bd_pin -dir O -from 7 -to 0 g3_0_0
  create_bd_pin -dir O -from 7 -to 0 g4

  # Create port connections
  connect_bd_net -net G_1 [get_bd_pins G] [get_bd_pins g1_5_0] [get_bd_pins g2_2_0] [get_bd_pins g3_0_0] [get_bd_pins g4]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: shr_B
proc create_hier_cell_shr_B_1 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_shr_B_1() - Empty argument(s)!"}
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
  create_bd_pin -dir I -from 7 -to 0 B
  create_bd_pin -dir O -from 7 -to 0 b1_2_0
  create_bd_pin -dir O -from 7 -to 0 b2_1_0
  create_bd_pin -dir O -from 7 -to 0 b3_0_0
  create_bd_pin -dir O -from 7 -to 0 b4

  # Create port connections
  connect_bd_net -net B_1 [get_bd_pins B] [get_bd_pins b1_2_0] [get_bd_pins b2_1_0] [get_bd_pins b3_0_0] [get_bd_pins b4]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: shr_R
proc create_hier_cell_shr_R { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_shr_R() - Empty argument(s)!"}
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
  create_bd_pin -dir I -from 7 -to 0 R
  create_bd_pin -dir O -from 7 -to 0 r1_4_0
  create_bd_pin -dir O -from 7 -to 0 r2_1_0
  create_bd_pin -dir O -from 7 -to 0 r3_0_0

  # Create port connections
  connect_bd_net -net R_1 [get_bd_pins R] [get_bd_pins r1_4_0] [get_bd_pins r2_1_0] [get_bd_pins r3_0_0]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: shr_G
proc create_hier_cell_shr_G { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_shr_G() - Empty argument(s)!"}
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
  create_bd_pin -dir I -from 7 -to 0 G
  create_bd_pin -dir O -from 7 -to 0 g1_5_0
  create_bd_pin -dir O -from 7 -to 0 g2_2_0
  create_bd_pin -dir O -from 7 -to 0 g3_0_0
  create_bd_pin -dir O -from 7 -to 0 g4

  # Create port connections
  connect_bd_net -net G_1 [get_bd_pins G] [get_bd_pins g1_5_0] [get_bd_pins g2_2_0] [get_bd_pins g3_0_0] [get_bd_pins g4]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: shr_B
proc create_hier_cell_shr_B { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_shr_B() - Empty argument(s)!"}
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
  create_bd_pin -dir I -from 7 -to 0 B
  create_bd_pin -dir O -from 7 -to 0 b1_2_0
  create_bd_pin -dir O -from 7 -to 0 b2_1_0
  create_bd_pin -dir O -from 7 -to 0 b3_0_0
  create_bd_pin -dir O -from 7 -to 0 b4

  # Create port connections
  connect_bd_net -net B_1 [get_bd_pins B] [get_bd_pins b1_2_0] [get_bd_pins b2_1_0] [get_bd_pins b3_0_0] [get_bd_pins b4]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: stage4_1
proc create_hier_cell_stage4_1_1 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_stage4_1_1() - Empty argument(s)!"}
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
  create_bd_pin -dir I -from 5 -to 0 -type data B
  create_bd_pin -dir I -type clk CLK
  create_bd_pin -dir I -type data C_IN
  create_bd_pin -dir O -from 8 -to 0 -type data S

  # Create instance: reduce_1FE_5_0, and set properties
  set reduce_1FE_5_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_addsub:12.0 reduce_1FE_5_0 ]
  set_property -dict [ list \
   CONFIG.A_Type {Unsigned} \
   CONFIG.A_Width {9} \
   CONFIG.B_Type {Unsigned} \
   CONFIG.B_Value {000000} \
   CONFIG.B_Width {6} \
   CONFIG.CE {false} \
   CONFIG.C_In {true} \
   CONFIG.Latency {1} \
   CONFIG.Latency_Configuration {Automatic} \
   CONFIG.Out_Width {9} \
 ] $reduce_1FE_5_0

  # Create port connections
  connect_bd_net -net CLK_1 [get_bd_pins CLK] [get_bd_pins reduce_1FE_5_0/CLK]
  connect_bd_net -net ls_5_3_carry_Res [get_bd_pins C_IN] [get_bd_pins reduce_1FE_5_0/C_IN]
  connect_bd_net -net path_3F_5_0_b_Dout [get_bd_pins B] [get_bd_pins reduce_1FE_5_0/B]
  connect_bd_net -net reduce_1FE_5_0_S [get_bd_pins S] [get_bd_pins reduce_1FE_5_0/S]
  connect_bd_net -net tap_1_5_0_Q [get_bd_pins A] [get_bd_pins reduce_1FE_5_0/A]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: stage3_1
proc create_hier_cell_stage3_1_1 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_stage3_1_1() - Empty argument(s)!"}
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
  create_bd_pin -dir I -from 9 -to 0 -type data B
  create_bd_pin -dir I -type clk CLK
  create_bd_pin -dir I -type data C_IN
  create_bd_pin -dir I -from 2 -to 0 -type data D
  create_bd_pin -dir I -from 8 -to 0 -type data D1
  create_bd_pin -dir O -from 2 -to 0 -type data Q
  create_bd_pin -dir O -from 8 -to 0 -type data Q1
  create_bd_pin -dir O -from 9 -to 0 -type data S

  # Create instance: reduce_3FC_1_0, and set properties
  set reduce_3FC_1_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_addsub:12.0 reduce_3FC_1_0 ]
  set_property -dict [ list \
   CONFIG.A_Type {Unsigned} \
   CONFIG.A_Width {9} \
   CONFIG.B_Type {Unsigned} \
   CONFIG.B_Value {0000000000} \
   CONFIG.B_Width {10} \
   CONFIG.CE {false} \
   CONFIG.C_In {true} \
   CONFIG.Latency {1} \
   CONFIG.Latency_Configuration {Automatic} \
   CONFIG.Out_Width {10} \
 ] $reduce_3FC_1_0

  # Create instance: tap_1_5_0, and set properties
  set tap_1_5_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 tap_1_5_0 ]
  set_property -dict [ list \
   CONFIG.AsyncInitVal {000000000} \
   CONFIG.DefaultData {000000000} \
   CONFIG.Depth {1} \
   CONFIG.SyncInitVal {000000000} \
   CONFIG.Width {9} \
 ] $tap_1_5_0

  # Create instance: tap_1_ls_5_3_b, and set properties
  set tap_1_ls_5_3_b [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 tap_1_ls_5_3_b ]
  set_property -dict [ list \
   CONFIG.AsyncInitVal {000} \
   CONFIG.DefaultData {000} \
   CONFIG.Depth {1} \
   CONFIG.SyncInitVal {000} \
   CONFIG.Width {3} \
 ] $tap_1_ls_5_3_b

  # Create port connections
  connect_bd_net -net CLK_1 [get_bd_pins CLK] [get_bd_pins reduce_3FC_1_0/CLK] [get_bd_pins tap_1_5_0/CLK] [get_bd_pins tap_1_ls_5_3_b/CLK]
  connect_bd_net -net ls_5_carry1_Res [get_bd_pins C_IN] [get_bd_pins reduce_3FC_1_0/C_IN]
  connect_bd_net -net path_17E_1_0_Dout [get_bd_pins A] [get_bd_pins reduce_3FC_1_0/A]
  connect_bd_net -net path_3FC_1_0_S [get_bd_pins S] [get_bd_pins reduce_3FC_1_0/S]
  connect_bd_net -net reduce_1BE_5_0_S [get_bd_pins D1] [get_bd_pins tap_1_5_0/D]
  connect_bd_net -net reduce_27D_1_0_S [get_bd_pins B] [get_bd_pins reduce_3FC_1_0/B]
  connect_bd_net -net tap_1_5_0_Q [get_bd_pins Q1] [get_bd_pins tap_1_5_0/Q]
  connect_bd_net -net tap_1_ls_5_3_Q [get_bd_pins D] [get_bd_pins tap_1_ls_5_3_b/D]
  connect_bd_net -net tap_1_ls_5_3_b_Q [get_bd_pins Q] [get_bd_pins tap_1_ls_5_3_b/Q]

  # Restore current instance
  current_bd_instance $oldCurInst
}

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
  create_bd_pin -dir I -from 6 -to 0 -type data A
  create_bd_pin -dir I -from 8 -to 0 -type data A1
  create_bd_pin -dir I -from 7 -to 0 -type data A2
  create_bd_pin -dir I -from 8 -to 0 -type data B
  create_bd_pin -dir I -from 5 -to 0 -type data B1
  create_bd_pin -dir I -from 8 -to 0 -type data B2
  create_bd_pin -dir I -type clk CLK
  create_bd_pin -dir I -type data C_IN
  create_bd_pin -dir I -from 1 -to 0 -type data D
  create_bd_pin -dir I -from 2 -to 0 -type data D1
  create_bd_pin -dir O -from 1 -to 0 -type data Q
  create_bd_pin -dir O -from 2 -to 0 -type data Q1
  create_bd_pin -dir O -from 9 -to 0 -type data S
  create_bd_pin -dir O -from 8 -to 0 -type data S1
  create_bd_pin -dir O -from 9 -to 0 -type data S2

  # Create instance: reduce_1BE_5_0, and set properties
  set reduce_1BE_5_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_addsub:12.0 reduce_1BE_5_0 ]
  set_property -dict [ list \
   CONFIG.A_Type {Unsigned} \
   CONFIG.A_Width {9} \
   CONFIG.B_Type {Unsigned} \
   CONFIG.B_Value {000000} \
   CONFIG.B_Width {6} \
   CONFIG.CE {false} \
   CONFIG.C_In {true} \
   CONFIG.Latency {1} \
   CONFIG.Latency_Configuration {Automatic} \
   CONFIG.Out_Width {9} \
 ] $reduce_1BE_5_0

  # Create instance: reduce_27D_1_0, and set properties
  set reduce_27D_1_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_addsub:12.0 reduce_27D_1_0 ]
  set_property -dict [ list \
   CONFIG.A_Type {Unsigned} \
   CONFIG.A_Width {7} \
   CONFIG.B_Type {Unsigned} \
   CONFIG.B_Value {000000000} \
   CONFIG.B_Width {9} \
   CONFIG.CE {false} \
   CONFIG.Latency {1} \
   CONFIG.Latency_Configuration {Automatic} \
   CONFIG.Out_Width {10} \
 ] $reduce_27D_1_0

  # Create instance: reduce_2FD_0_0, and set properties
  set reduce_2FD_0_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_addsub:12.0 reduce_2FD_0_0 ]
  set_property -dict [ list \
   CONFIG.A_Type {Unsigned} \
   CONFIG.A_Width {8} \
   CONFIG.B_Type {Unsigned} \
   CONFIG.B_Value {000000000} \
   CONFIG.B_Width {9} \
   CONFIG.CE {false} \
   CONFIG.Latency {1} \
   CONFIG.Latency_Configuration {Automatic} \
   CONFIG.Out_Width {10} \
 ] $reduce_2FD_0_0

  # Create instance: tap_1_ls_1_0, and set properties
  set tap_1_ls_1_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 tap_1_ls_1_0 ]
  set_property -dict [ list \
   CONFIG.AsyncInitVal {00} \
   CONFIG.DefaultData {00} \
   CONFIG.Depth {1} \
   CONFIG.SyncInitVal {00} \
   CONFIG.Width {2} \
 ] $tap_1_ls_1_0

  # Create instance: tap_1_ls_5_3, and set properties
  set tap_1_ls_5_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 tap_1_ls_5_3 ]
  set_property -dict [ list \
   CONFIG.AsyncInitVal {000} \
   CONFIG.DefaultData {000} \
   CONFIG.Depth {1} \
   CONFIG.SyncInitVal {000} \
   CONFIG.Width {3} \
 ] $tap_1_ls_5_3

  # Create port connections
  connect_bd_net -net CLK_1 [get_bd_pins CLK] [get_bd_pins reduce_1BE_5_0/CLK] [get_bd_pins reduce_27D_1_0/CLK] [get_bd_pins reduce_2FD_0_0/CLK] [get_bd_pins tap_1_ls_1_0/CLK] [get_bd_pins tap_1_ls_5_3/CLK]
  connect_bd_net -net path_0_0_S [get_bd_pins B2] [get_bd_pins reduce_2FD_0_0/B]
  connect_bd_net -net path_17E_4_0_S [get_bd_pins A1] [get_bd_pins reduce_1BE_5_0/A]
  connect_bd_net -net path_1FE_1_0_S [get_bd_pins B] [get_bd_pins reduce_27D_1_0/B]
  connect_bd_net -net path_2_0_ls_5_3_sum_dout [get_bd_pins D1] [get_bd_pins tap_1_ls_5_3/D]
  connect_bd_net -net path_2_0_ls_5_4_Dout [get_bd_pins B1] [get_bd_pins reduce_1BE_5_0/B]
  connect_bd_net -net path_7F_Dout [get_bd_pins A] [get_bd_pins reduce_27D_1_0/A]
  connect_bd_net -net path_ls_1_0_Dout [get_bd_pins D] [get_bd_pins tap_1_ls_1_0/D]
  connect_bd_net -net reduce_1BE_5_0_S [get_bd_pins S1] [get_bd_pins reduce_1BE_5_0/S]
  connect_bd_net -net reduce_27D_1_0_S [get_bd_pins S] [get_bd_pins reduce_27D_1_0/S]
  connect_bd_net -net reduce_2FD_0_0_S [get_bd_pins S2] [get_bd_pins reduce_2FD_0_0/S]
  connect_bd_net -net tap_1_g3_0_0_Q [get_bd_pins A2] [get_bd_pins reduce_2FD_0_0/A]
  connect_bd_net -net tap_1_ls_1_0_Q [get_bd_pins Q] [get_bd_pins tap_1_ls_1_0/Q]
  connect_bd_net -net tap_1_ls_5_3_Q [get_bd_pins Q1] [get_bd_pins tap_1_ls_5_3/Q]
  connect_bd_net -net util_vector_logic_0_Res [get_bd_pins C_IN] [get_bd_pins reduce_1BE_5_0/C_IN]

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
  create_bd_pin -dir I -from 7 -to 0 -type data A
  create_bd_pin -dir I -from 7 -to 0 -type data A1
  create_bd_pin -dir I -from 7 -to 0 -type data A2
  create_bd_pin -dir I -from 7 -to 0 -type data A3
  create_bd_pin -dir I -from 7 -to 0 -type data A4
  create_bd_pin -dir I -from 7 -to 0 -type data B
  create_bd_pin -dir I -from 7 -to 0 -type data B1
  create_bd_pin -dir I -from 7 -to 0 -type data B2
  create_bd_pin -dir I -from 7 -to 0 -type data B3
  create_bd_pin -dir I -from 6 -to 0 -type data B4
  create_bd_pin -dir I -type clk CLK
  create_bd_pin -dir I -from 7 -to 0 -type data D
  create_bd_pin -dir I -from 0 -to 0 -type data D1
  create_bd_pin -dir O -from 7 -to 0 -type data Q
  create_bd_pin -dir O -from 0 -to 0 -type data Q1
  create_bd_pin -dir O -from 8 -to 0 -type data S
  create_bd_pin -dir O -from 8 -to 0 -type data S1
  create_bd_pin -dir O -from 8 -to 0 -type data S2
  create_bd_pin -dir O -from 8 -to 0 -type data S3
  create_bd_pin -dir O -from 8 -to 0 -type data S4

  # Create instance: path_17E_5_0, and set properties
  set path_17E_5_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_addsub:12.0 path_17E_5_0 ]
  set_property -dict [ list \
   CONFIG.A_Type {Unsigned} \
   CONFIG.A_Width {8} \
   CONFIG.B_Type {Unsigned} \
   CONFIG.B_Value {0000000} \
   CONFIG.B_Width {7} \
   CONFIG.CE {false} \
   CONFIG.Latency {1} \
   CONFIG.Latency_Configuration {Automatic} \
   CONFIG.Out_Width {9} \
 ] $path_17E_5_0

  # Create instance: path_1FE, and set properties
  set path_1FE [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_addsub:12.0 path_1FE ]
  set_property -dict [ list \
   CONFIG.A_Type {Unsigned} \
   CONFIG.A_Width {8} \
   CONFIG.B_Type {Unsigned} \
   CONFIG.B_Value {00000000} \
   CONFIG.B_Width {8} \
   CONFIG.CE {false} \
   CONFIG.Latency {1} \
   CONFIG.Latency_Configuration {Automatic} \
   CONFIG.Out_Width {9} \
 ] $path_1FE

  # Create instance: path_1FE_0_0, and set properties
  set path_1FE_0_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_addsub:12.0 path_1FE_0_0 ]
  set_property -dict [ list \
   CONFIG.A_Type {Unsigned} \
   CONFIG.A_Width {8} \
   CONFIG.B_Type {Unsigned} \
   CONFIG.B_Value {00000000} \
   CONFIG.B_Width {8} \
   CONFIG.CE {false} \
   CONFIG.Latency {1} \
   CONFIG.Latency_Configuration {Automatic} \
   CONFIG.Out_Width {9} \
 ] $path_1FE_0_0

  # Create instance: path_1FE_1_0, and set properties
  set path_1FE_1_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_addsub:12.0 path_1FE_1_0 ]
  set_property -dict [ list \
   CONFIG.A_Type {Unsigned} \
   CONFIG.A_Width {8} \
   CONFIG.B_Type {Unsigned} \
   CONFIG.B_Value {00000000} \
   CONFIG.B_Width {8} \
   CONFIG.CE {false} \
   CONFIG.Latency {1} \
   CONFIG.Latency_Configuration {Automatic} \
   CONFIG.Out_Width {9} \
 ] $path_1FE_1_0

  # Create instance: path_1FE_2_0, and set properties
  set path_1FE_2_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_addsub:12.0 path_1FE_2_0 ]
  set_property -dict [ list \
   CONFIG.A_Type {Unsigned} \
   CONFIG.A_Width {8} \
   CONFIG.B_Type {Unsigned} \
   CONFIG.B_Value {00000000} \
   CONFIG.B_Width {8} \
   CONFIG.CE {false} \
   CONFIG.Latency {1} \
   CONFIG.Latency_Configuration {Automatic} \
   CONFIG.Out_Width {9} \
 ] $path_1FE_2_0

  # Create instance: tap_1_g3_0_0, and set properties
  set tap_1_g3_0_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 tap_1_g3_0_0 ]
  set_property -dict [ list \
   CONFIG.AsyncInitVal {00000000} \
   CONFIG.DefaultData {00000000} \
   CONFIG.Depth {1} \
   CONFIG.SyncInitVal {00000000} \
   CONFIG.Width {8} \
 ] $tap_1_g3_0_0

  # Create instance: tap_1_ls_5_5, and set properties
  set tap_1_ls_5_5 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 tap_1_ls_5_5 ]
  set_property -dict [ list \
   CONFIG.AsyncInitVal {0} \
   CONFIG.DefaultData {0} \
   CONFIG.Depth {1} \
   CONFIG.SyncInitVal {0} \
   CONFIG.Width {1} \
 ] $tap_1_ls_5_5

  # Create port connections
  connect_bd_net -net CLK_1 [get_bd_pins CLK] [get_bd_pins path_17E_5_0/CLK] [get_bd_pins path_1FE/CLK] [get_bd_pins path_1FE_0_0/CLK] [get_bd_pins path_1FE_1_0/CLK] [get_bd_pins path_1FE_2_0/CLK] [get_bd_pins tap_1_g3_0_0/CLK] [get_bd_pins tap_1_ls_5_5/CLK]
  connect_bd_net -net path_0_0_S [get_bd_pins S3] [get_bd_pins path_1FE_0_0/S]
  connect_bd_net -net path_17E_4_0_S [get_bd_pins S4] [get_bd_pins path_17E_5_0/S]
  connect_bd_net -net path_1FE_1_0_S [get_bd_pins S] [get_bd_pins path_1FE_1_0/S]
  connect_bd_net -net path_1FE_2_0_S [get_bd_pins S2] [get_bd_pins path_1FE_2_0/S]
  connect_bd_net -net path_1FE_S [get_bd_pins S1] [get_bd_pins path_1FE/S]
  connect_bd_net -net shr_B_b1_2_0 [get_bd_pins B2] [get_bd_pins path_1FE_2_0/B]
  connect_bd_net -net shr_B_b2_1_0 [get_bd_pins A] [get_bd_pins path_1FE_1_0/A]
  connect_bd_net -net shr_B_b3_0_0 [get_bd_pins A3] [get_bd_pins path_1FE_0_0/A]
  connect_bd_net -net shr_B_b4 [get_bd_pins B1] [get_bd_pins path_1FE/B]
  connect_bd_net -net shr_G_g1_5_0 [get_bd_pins A4] [get_bd_pins path_17E_5_0/A]
  connect_bd_net -net shr_G_g2_2_0 [get_bd_pins A2] [get_bd_pins path_1FE_2_0/A]
  connect_bd_net -net shr_G_g3_0_0 [get_bd_pins D] [get_bd_pins tap_1_g3_0_0/D]
  connect_bd_net -net shr_G_g4 [get_bd_pins A1] [get_bd_pins path_1FE/A]
  connect_bd_net -net shr_R_r2_1_0 [get_bd_pins B] [get_bd_pins path_1FE_1_0/B]
  connect_bd_net -net shr_R_r3_0_0 [get_bd_pins B3] [get_bd_pins path_1FE_0_0/B]
  connect_bd_net -net tap_1_g3_0_0_Q [get_bd_pins Q] [get_bd_pins tap_1_g3_0_0/Q]
  connect_bd_net -net tap_1_ls_5_Q [get_bd_pins Q1] [get_bd_pins tap_1_ls_5_5/Q]
  connect_bd_net -net xlslice_0_Dout [get_bd_pins D1] [get_bd_pins tap_1_ls_5_5/D]
  connect_bd_net -net xlslice_1_Dout [get_bd_pins B4] [get_bd_pins path_17E_5_0/B]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: asynci1
proc create_hier_cell_asynci1_1 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_asynci1_1() - Empty argument(s)!"}
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
  create_bd_pin -dir O -from 6 -to 0 Dout
  create_bd_pin -dir O -from 0 -to 0 Dout1
  create_bd_pin -dir I -from 23 -to 0 RBG
  create_bd_pin -dir O -from 7 -to 0 b1_2_0
  create_bd_pin -dir O -from 7 -to 0 b2_1_0
  create_bd_pin -dir O -from 7 -to 0 b3_0_0
  create_bd_pin -dir O -from 7 -to 0 b4
  create_bd_pin -dir O -from 7 -to 0 g1_5_0
  create_bd_pin -dir O -from 7 -to 0 g2_2_0
  create_bd_pin -dir O -from 7 -to 0 g3_0_0
  create_bd_pin -dir O -from 7 -to 0 g4
  create_bd_pin -dir O -from 7 -to 0 r2_1_0
  create_bd_pin -dir O -from 7 -to 0 r3_0_0

  # Create instance: B, and set properties
  set B [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 B ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {15} \
   CONFIG.DIN_TO {8} \
   CONFIG.DIN_WIDTH {24} \
   CONFIG.DOUT_WIDTH {8} \
 ] $B

  # Create instance: G, and set properties
  set G [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 G ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {7} \
   CONFIG.DIN_TO {0} \
   CONFIG.DIN_WIDTH {24} \
   CONFIG.DOUT_WIDTH {8} \
 ] $G

  # Create instance: R, and set properties
  set R [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 R ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {23} \
   CONFIG.DIN_TO {16} \
   CONFIG.DIN_WIDTH {24} \
   CONFIG.DOUT_WIDTH {8} \
 ] $R

  # Create instance: path_4_0_ls_5_5, and set properties
  set path_4_0_ls_5_5 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 path_4_0_ls_5_5 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {0} \
   CONFIG.DIN_TO {0} \
   CONFIG.DIN_WIDTH {8} \
 ] $path_4_0_ls_5_5

  # Create instance: path_7F_5_0, and set properties
  set path_7F_5_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 path_7F_5_0 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {7} \
   CONFIG.DIN_TO {1} \
   CONFIG.DIN_WIDTH {8} \
   CONFIG.DOUT_WIDTH {7} \
 ] $path_7F_5_0

  # Create instance: shr_B
  create_hier_cell_shr_B_1 $hier_obj shr_B

  # Create instance: shr_G
  create_hier_cell_shr_G_1 $hier_obj shr_G

  # Create instance: shr_R
  create_hier_cell_shr_R_1 $hier_obj shr_R

  # Create port connections
  connect_bd_net -net B_1 [get_bd_pins B/Dout] [get_bd_pins shr_B/B]
  connect_bd_net -net G_Dout [get_bd_pins G/Dout] [get_bd_pins shr_G/G]
  connect_bd_net -net RBG_1 [get_bd_pins RBG] [get_bd_pins B/Din] [get_bd_pins G/Din] [get_bd_pins R/Din]
  connect_bd_net -net R_1 [get_bd_pins R/Dout] [get_bd_pins shr_R/R]
  connect_bd_net -net shr_B_b1_2_0 [get_bd_pins b1_2_0] [get_bd_pins shr_B/b1_2_0]
  connect_bd_net -net shr_B_b2_1_0 [get_bd_pins b2_1_0] [get_bd_pins shr_B/b2_1_0]
  connect_bd_net -net shr_B_b3_0_0 [get_bd_pins b3_0_0] [get_bd_pins shr_B/b3_0_0]
  connect_bd_net -net shr_B_b4 [get_bd_pins b4] [get_bd_pins shr_B/b4]
  connect_bd_net -net shr_G_g1_5_0 [get_bd_pins g1_5_0] [get_bd_pins shr_G/g1_5_0]
  connect_bd_net -net shr_G_g2_2_0 [get_bd_pins g2_2_0] [get_bd_pins shr_G/g2_2_0]
  connect_bd_net -net shr_G_g3_0_0 [get_bd_pins g3_0_0] [get_bd_pins shr_G/g3_0_0]
  connect_bd_net -net shr_G_g4 [get_bd_pins g4] [get_bd_pins shr_G/g4]
  connect_bd_net -net shr_R_r1_4_0 [get_bd_pins path_4_0_ls_5_5/Din] [get_bd_pins path_7F_5_0/Din] [get_bd_pins shr_R/r1_4_0]
  connect_bd_net -net shr_R_r2_1_0 [get_bd_pins r2_1_0] [get_bd_pins shr_R/r2_1_0]
  connect_bd_net -net shr_R_r3_0_0 [get_bd_pins r3_0_0] [get_bd_pins shr_R/r3_0_0]
  connect_bd_net -net xlslice_0_Dout [get_bd_pins Dout1] [get_bd_pins path_4_0_ls_5_5/Dout]
  connect_bd_net -net xlslice_1_Dout [get_bd_pins Dout] [get_bd_pins path_7F_5_0/Dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: async4o
proc create_hier_cell_async4o_1 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_async4o_1() - Empty argument(s)!"}
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
  create_bd_pin -dir I -from 8 -to 0 Din
  create_bd_pin -dir O -from 7 -to 0 y

  # Create instance: lsb, and set properties
  set lsb [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 lsb ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {0} \
   CONFIG.DIN_TO {0} \
   CONFIG.DIN_WIDTH {8} \
   CONFIG.DOUT_WIDTH {1} \
 ] $lsb

  # Create instance: msb, and set properties
  set msb [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 msb ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {7} \
   CONFIG.DIN_TO {1} \
   CONFIG.DIN_WIDTH {8} \
   CONFIG.DOUT_WIDTH {7} \
 ] $msb

  # Create instance: onehalf, and set properties
  set onehalf [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 onehalf ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {0} \
   CONFIG.DIN_TO {0} \
   CONFIG.DIN_WIDTH {9} \
 ] $onehalf

  # Create instance: path_FF_6_0, and set properties
  set path_FF_6_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 path_FF_6_0 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {8} \
   CONFIG.DIN_TO {1} \
   CONFIG.DIN_WIDTH {9} \
   CONFIG.DOUT_WIDTH {8} \
 ] $path_FF_6_0

  # Create instance: round, and set properties
  set round [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 round ]
  set_property -dict [ list \
   CONFIG.C_OPERATION {or} \
   CONFIG.C_SIZE {1} \
   CONFIG.LOGO_FILE {data/sym_orgate.png} \
 ] $round

  # Create instance: y, and set properties
  set y [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 y ]
  set_property -dict [ list \
   CONFIG.IN0_WIDTH {1} \
   CONFIG.IN1_WIDTH {7} \
 ] $y

  # Create port connections
  connect_bd_net -net lsb_Dout [get_bd_pins onehalf/Dout] [get_bd_pins round/Op1]
  connect_bd_net -net lsb_Dout1 [get_bd_pins lsb/Dout] [get_bd_pins round/Op2]
  connect_bd_net -net msb_Dout [get_bd_pins msb/Dout] [get_bd_pins y/In1]
  connect_bd_net -net path_FF_6_0_Dout [get_bd_pins lsb/Din] [get_bd_pins msb/Din] [get_bd_pins path_FF_6_0/Dout]
  connect_bd_net -net reduce_1FE_5_0_S [get_bd_pins Din] [get_bd_pins onehalf/Din] [get_bd_pins path_FF_6_0/Din]
  connect_bd_net -net round_Res [get_bd_pins round/Res] [get_bd_pins y/In0]
  connect_bd_net -net y_dout [get_bd_pins y] [get_bd_pins y/dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: async34
proc create_hier_cell_async34_1 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_async34_1() - Empty argument(s)!"}
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
  create_bd_pin -dir I -from 9 -to 0 Din
  create_bd_pin -dir O -from 5 -to 0 Dout
  create_bd_pin -dir I -from 2 -to 0 Op1
  create_bd_pin -dir O Res

  # Create instance: a0_and_b0, and set properties
  set a0_and_b0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 a0_and_b0 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {0} \
   CONFIG.DIN_TO {0} \
   CONFIG.DIN_WIDTH {3} \
 ] $a0_and_b0

  # Create instance: a1_and_b1, and set properties
  set a1_and_b1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 a1_and_b1 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {1} \
   CONFIG.DIN_TO {1} \
   CONFIG.DIN_WIDTH {3} \
 ] $a1_and_b1

  # Create instance: a1_xor_b1, and set properties
  set a1_xor_b1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 a1_xor_b1 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {0} \
   CONFIG.DIN_TO {0} \
   CONFIG.DIN_WIDTH {2} \
 ] $a1_xor_b1

  # Create instance: a2_and_b2, and set properties
  set a2_and_b2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 a2_and_b2 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {2} \
   CONFIG.DIN_TO {2} \
   CONFIG.DIN_WIDTH {3} \
 ] $a2_and_b2

  # Create instance: a2_xor_b2, and set properties
  set a2_xor_b2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 a2_xor_b2 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {1} \
   CONFIG.DIN_TO {1} \
   CONFIG.DIN_WIDTH {2} \
 ] $a2_xor_b2

  # Create instance: a_and_b, and set properties
  set a_and_b [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 a_and_b ]
  set_property -dict [ list \
   CONFIG.C_SIZE {3} \
 ] $a_and_b

  # Create instance: a_xor_b, and set properties
  set a_xor_b [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 a_xor_b ]
  set_property -dict [ list \
   CONFIG.C_OPERATION {xor} \
   CONFIG.C_SIZE {2} \
   CONFIG.LOGO_FILE {data/sym_xorgate.png} \
 ] $a_xor_b

  # Create instance: carry_0_1, and set properties
  set carry_0_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 carry_0_1 ]
  set_property -dict [ list \
   CONFIG.C_SIZE {1} \
 ] $carry_0_1

  # Create instance: carry_0_2, and set properties
  set carry_0_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 carry_0_2 ]
  set_property -dict [ list \
   CONFIG.C_SIZE {1} \
 ] $carry_0_2

  # Create instance: carry_1_2, and set properties
  set carry_1_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 carry_1_2 ]
  set_property -dict [ list \
   CONFIG.C_SIZE {1} \
 ] $carry_1_2

  # Create instance: carry_3_bit, and set properties
  set carry_3_bit [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 carry_3_bit ]
  set_property -dict [ list \
   CONFIG.IN0_WIDTH {1} \
   CONFIG.IN1_WIDTH {1} \
   CONFIG.IN2_WIDTH {1} \
   CONFIG.NUM_PORTS {3} \
 ] $carry_3_bit

  # Create instance: ls_5_3_carry, and set properties
  set ls_5_3_carry [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_reduced_logic:2.0 ls_5_3_carry ]
  set_property -dict [ list \
   CONFIG.C_OPERATION {or} \
   CONFIG.C_SIZE {3} \
   CONFIG.LOGO_FILE {data/sym_orgate.png} \
 ] $ls_5_3_carry

  # Create instance: path_1_0_ls_5_3, and set properties
  set path_1_0_ls_5_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 path_1_0_ls_5_3 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {3} \
   CONFIG.DIN_TO {1} \
   CONFIG.DIN_WIDTH {10} \
   CONFIG.DOUT_WIDTH {3} \
 ] $path_1_0_ls_5_3

  # Create instance: path_3F_5_0_b, and set properties
  set path_3F_5_0_b [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 path_3F_5_0_b ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {9} \
   CONFIG.DIN_TO {4} \
   CONFIG.DIN_WIDTH {10} \
   CONFIG.DOUT_WIDTH {6} \
 ] $path_3F_5_0_b

  # Create instance: path_5_4_a, and set properties
  set path_5_4_a [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 path_5_4_a ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {2} \
   CONFIG.DIN_TO {1} \
   CONFIG.DIN_WIDTH {3} \
   CONFIG.DOUT_WIDTH {2} \
 ] $path_5_4_a

  # Create instance: path_5_4_b, and set properties
  set path_5_4_b [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 path_5_4_b ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {2} \
   CONFIG.DIN_TO {1} \
   CONFIG.DIN_WIDTH {3} \
   CONFIG.DOUT_WIDTH {2} \
 ] $path_5_4_b

  # Create port connections
  connect_bd_net -net a0_and_b0_Dout [get_bd_pins a0_and_b0/Dout] [get_bd_pins carry_0_1/Op2]
  connect_bd_net -net a1_and_b1_Dout [get_bd_pins a1_and_b1/Dout] [get_bd_pins carry_1_2/Op1]
  connect_bd_net -net a1_xor_b1_Dout [get_bd_pins a1_xor_b1/Dout] [get_bd_pins carry_0_1/Op1]
  connect_bd_net -net a2_xor_b2_Dout [get_bd_pins a2_xor_b2/Dout] [get_bd_pins carry_0_2/Op1] [get_bd_pins carry_1_2/Op2]
  connect_bd_net -net carry_1_2_Res [get_bd_pins carry_0_2/Res] [get_bd_pins carry_3_bit/In2]
  connect_bd_net -net carry_from_2_Res [get_bd_pins carry_0_1/Res] [get_bd_pins carry_0_2/Op2]
  connect_bd_net -net ls_5_3_carry_Res [get_bd_pins Res] [get_bd_pins ls_5_3_carry/Res]
  connect_bd_net -net path_1_0_ls_5_3_Dout [get_bd_pins a_and_b/Op2] [get_bd_pins path_1_0_ls_5_3/Dout] [get_bd_pins path_5_4_a/Din]
  connect_bd_net -net path_3FC_1_0_S [get_bd_pins Din] [get_bd_pins path_1_0_ls_5_3/Din] [get_bd_pins path_3F_5_0_b/Din]
  connect_bd_net -net path_3F_5_0_b_Dout [get_bd_pins Dout] [get_bd_pins path_3F_5_0_b/Dout]
  connect_bd_net -net path_5_4_a_Dout [get_bd_pins a_xor_b/Op2] [get_bd_pins path_5_4_a/Dout]
  connect_bd_net -net path_5_4_b_Dout [get_bd_pins a_xor_b/Op1] [get_bd_pins path_5_4_b/Dout]
  connect_bd_net -net tap_1_ls_5_3_b_Q [get_bd_pins Op1] [get_bd_pins a_and_b/Op1] [get_bd_pins path_5_4_b/Din]
  connect_bd_net -net util_vector_logic_0_Res1 [get_bd_pins a0_and_b0/Din] [get_bd_pins a1_and_b1/Din] [get_bd_pins a2_and_b2/Din] [get_bd_pins a_and_b/Res]
  connect_bd_net -net util_vector_logic_1_Res1 [get_bd_pins a1_xor_b1/Din] [get_bd_pins a2_xor_b2/Din] [get_bd_pins a_xor_b/Res]
  connect_bd_net -net util_vector_logic_2_Res [get_bd_pins carry_1_2/Res] [get_bd_pins carry_3_bit/In1]
  connect_bd_net -net xlconcat_0_dout [get_bd_pins carry_3_bit/dout] [get_bd_pins ls_5_3_carry/Op1]
  connect_bd_net -net xlslice_0_Dout3 [get_bd_pins a2_and_b2/Dout] [get_bd_pins carry_3_bit/In0]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: async23
proc create_hier_cell_async23_1 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_async23_1() - Empty argument(s)!"}
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
  create_bd_pin -dir I -from 9 -to 0 Din
  create_bd_pin -dir I -from 1 -to 0 Din1
  create_bd_pin -dir O -from 8 -to 0 Dout
  create_bd_pin -dir O -from 0 -to 0 Res

  # Create instance: ls_1_carry, and set properties
  set ls_1_carry [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 ls_1_carry ]
  set_property -dict [ list \
   CONFIG.C_SIZE {1} \
 ] $ls_1_carry

  # Create instance: path_0_0_ls_1_1, and set properties
  set path_0_0_ls_1_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 path_0_0_ls_1_1 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {0} \
   CONFIG.DIN_TO {0} \
   CONFIG.DIN_WIDTH {10} \
   CONFIG.DOUT_WIDTH {1} \
 ] $path_0_0_ls_1_1

  # Create instance: path_17E_1_0, and set properties
  set path_17E_1_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 path_17E_1_0 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {9} \
   CONFIG.DIN_TO {1} \
   CONFIG.DIN_WIDTH {10} \
   CONFIG.DOUT_WIDTH {9} \
 ] $path_17E_1_0

  # Create instance: path_1_0_ls_1_1, and set properties
  set path_1_0_ls_1_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 path_1_0_ls_1_1 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {1} \
   CONFIG.DIN_TO {1} \
   CONFIG.DIN_WIDTH {2} \
   CONFIG.DOUT_WIDTH {1} \
 ] $path_1_0_ls_1_1

  # Create port connections
  connect_bd_net -net ls_5_carry1_Res [get_bd_pins Res] [get_bd_pins ls_1_carry/Res]
  connect_bd_net -net path_0_0_ls_1_Dout [get_bd_pins ls_1_carry/Op1] [get_bd_pins path_0_0_ls_1_1/Dout]
  connect_bd_net -net path_17E_1_0_Dout [get_bd_pins Dout] [get_bd_pins path_17E_1_0/Dout]
  connect_bd_net -net reduce_2FD_0_0_S [get_bd_pins Din] [get_bd_pins path_0_0_ls_1_1/Din] [get_bd_pins path_17E_1_0/Din]
  connect_bd_net -net tap_1_ls_1_0_Q [get_bd_pins Din1] [get_bd_pins path_1_0_ls_1_1/Din]
  connect_bd_net -net xlslice_0_Dout2 [get_bd_pins ls_1_carry/Op2] [get_bd_pins path_1_0_ls_1_1/Dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: async12
proc create_hier_cell_async12_1 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_async12_1() - Empty argument(s)!"}
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
  create_bd_pin -dir I -from 8 -to 0 Din
  create_bd_pin -dir I -from 8 -to 0 Din1
  create_bd_pin -dir O -from 6 -to 0 Dout
  create_bd_pin -dir O -from 5 -to 0 Dout1
  create_bd_pin -dir O -from 1 -to 0 Dout2
  create_bd_pin -dir I -from 0 -to 0 Op1
  create_bd_pin -dir O -from 0 -to 0 Res
  create_bd_pin -dir O -from 2 -to 0 dout3

  # Create instance: ls_5_carry, and set properties
  set ls_5_carry [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 ls_5_carry ]
  set_property -dict [ list \
   CONFIG.C_SIZE {1} \
 ] $ls_5_carry

  # Create instance: ls_5_sum, and set properties
  set ls_5_sum [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 ls_5_sum ]
  set_property -dict [ list \
   CONFIG.C_OPERATION {xor} \
   CONFIG.C_SIZE {1} \
   CONFIG.LOGO_FILE {data/sym_xorgate.png} \
 ] $ls_5_sum

  # Create instance: path_2_0_ls_4_3, and set properties
  set path_2_0_ls_4_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 path_2_0_ls_4_3 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {1} \
   CONFIG.DIN_TO {0} \
   CONFIG.DIN_WIDTH {3} \
   CONFIG.DOUT_WIDTH {2} \
 ] $path_2_0_ls_4_3

  # Create instance: path_2_0_ls_5_3, and set properties
  set path_2_0_ls_5_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 path_2_0_ls_5_3 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {2} \
   CONFIG.DIN_TO {0} \
   CONFIG.DIN_WIDTH {9} \
   CONFIG.DOUT_WIDTH {3} \
 ] $path_2_0_ls_5_3

  # Create instance: path_2_0_ls_5_3_sum, and set properties
  set path_2_0_ls_5_3_sum [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 path_2_0_ls_5_3_sum ]
  set_property -dict [ list \
   CONFIG.IN0_WIDTH {2} \
   CONFIG.IN1_WIDTH {1} \
 ] $path_2_0_ls_5_3_sum

  # Create instance: path_2_0_ls_5_5, and set properties
  set path_2_0_ls_5_5 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 path_2_0_ls_5_5 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {2} \
   CONFIG.DIN_TO {2} \
   CONFIG.DIN_WIDTH {3} \
   CONFIG.DOUT_WIDTH {1} \
 ] $path_2_0_ls_5_5

  # Create instance: path_3F_5_0, and set properties
  set path_3F_5_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 path_3F_5_0 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {8} \
   CONFIG.DIN_TO {3} \
   CONFIG.DIN_WIDTH {9} \
   CONFIG.DOUT_WIDTH {6} \
 ] $path_3F_5_0

  # Create instance: path_7F_1_0, and set properties
  set path_7F_1_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 path_7F_1_0 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {8} \
   CONFIG.DIN_TO {2} \
   CONFIG.DIN_WIDTH {9} \
   CONFIG.DOUT_WIDTH {7} \
 ] $path_7F_1_0

  # Create instance: path_ls_1_0, and set properties
  set path_ls_1_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 path_ls_1_0 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {1} \
   CONFIG.DIN_TO {0} \
   CONFIG.DIN_WIDTH {9} \
   CONFIG.DOUT_WIDTH {2} \
 ] $path_ls_1_0

  # Create port connections
  connect_bd_net -net path_1FE_2_0_S [get_bd_pins Din1] [get_bd_pins path_2_0_ls_5_3/Din] [get_bd_pins path_3F_5_0/Din]
  connect_bd_net -net path_1FE_S [get_bd_pins Din] [get_bd_pins path_7F_1_0/Din] [get_bd_pins path_ls_1_0/Din]
  connect_bd_net -net path_2_0_ls_4_3_Dout [get_bd_pins path_2_0_ls_4_3/Dout] [get_bd_pins path_2_0_ls_5_3_sum/In0]
  connect_bd_net -net path_2_0_ls_5_3_Dout [get_bd_pins path_2_0_ls_4_3/Din] [get_bd_pins path_2_0_ls_5_3/Dout] [get_bd_pins path_2_0_ls_5_5/Din]
  connect_bd_net -net path_2_0_ls_5_3_sum_dout [get_bd_pins dout3] [get_bd_pins path_2_0_ls_5_3_sum/dout]
  connect_bd_net -net path_2_0_ls_5_4_Dout [get_bd_pins Dout1] [get_bd_pins path_3F_5_0/Dout]
  connect_bd_net -net path_7F_Dout [get_bd_pins Dout] [get_bd_pins path_7F_1_0/Dout]
  connect_bd_net -net path_ls_1_0_Dout [get_bd_pins Dout2] [get_bd_pins path_ls_1_0/Dout]
  connect_bd_net -net tap_1_ls_5_Q [get_bd_pins Op1] [get_bd_pins ls_5_carry/Op1] [get_bd_pins ls_5_sum/Op1]
  connect_bd_net -net util_vector_logic_0_Res [get_bd_pins Res] [get_bd_pins ls_5_carry/Res]
  connect_bd_net -net util_vector_logic_1_Res [get_bd_pins ls_5_sum/Res] [get_bd_pins path_2_0_ls_5_3_sum/In1]
  connect_bd_net -net xlslice_0_Dout1 [get_bd_pins ls_5_carry/Op2] [get_bd_pins ls_5_sum/Op2] [get_bd_pins path_2_0_ls_5_5/Dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: stage4_1
proc create_hier_cell_stage4_1 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_stage4_1() - Empty argument(s)!"}
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
  create_bd_pin -dir I -from 5 -to 0 -type data B
  create_bd_pin -dir I -type clk CLK
  create_bd_pin -dir I -type data C_IN
  create_bd_pin -dir O -from 8 -to 0 -type data S

  # Create instance: reduce_1FE_5_0, and set properties
  set reduce_1FE_5_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_addsub:12.0 reduce_1FE_5_0 ]
  set_property -dict [ list \
   CONFIG.A_Type {Unsigned} \
   CONFIG.A_Width {9} \
   CONFIG.B_Type {Unsigned} \
   CONFIG.B_Value {000000} \
   CONFIG.B_Width {6} \
   CONFIG.CE {false} \
   CONFIG.C_In {true} \
   CONFIG.Latency {1} \
   CONFIG.Latency_Configuration {Automatic} \
   CONFIG.Out_Width {9} \
 ] $reduce_1FE_5_0

  # Create port connections
  connect_bd_net -net CLK_1 [get_bd_pins CLK] [get_bd_pins reduce_1FE_5_0/CLK]
  connect_bd_net -net ls_5_3_carry_Res [get_bd_pins C_IN] [get_bd_pins reduce_1FE_5_0/C_IN]
  connect_bd_net -net path_3F_5_0_b_Dout [get_bd_pins B] [get_bd_pins reduce_1FE_5_0/B]
  connect_bd_net -net reduce_1FE_5_0_S [get_bd_pins S] [get_bd_pins reduce_1FE_5_0/S]
  connect_bd_net -net tap_1_5_0_Q [get_bd_pins A] [get_bd_pins reduce_1FE_5_0/A]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: stage3_1
proc create_hier_cell_stage3_1 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_stage3_1() - Empty argument(s)!"}
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
  create_bd_pin -dir I -from 9 -to 0 -type data B
  create_bd_pin -dir I -type clk CLK
  create_bd_pin -dir I -type data C_IN
  create_bd_pin -dir I -from 2 -to 0 -type data D
  create_bd_pin -dir I -from 8 -to 0 -type data D1
  create_bd_pin -dir O -from 2 -to 0 -type data Q
  create_bd_pin -dir O -from 8 -to 0 -type data Q1
  create_bd_pin -dir O -from 9 -to 0 -type data S

  # Create instance: reduce_3FC_1_0, and set properties
  set reduce_3FC_1_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_addsub:12.0 reduce_3FC_1_0 ]
  set_property -dict [ list \
   CONFIG.A_Type {Unsigned} \
   CONFIG.A_Width {9} \
   CONFIG.B_Type {Unsigned} \
   CONFIG.B_Value {0000000000} \
   CONFIG.B_Width {10} \
   CONFIG.CE {false} \
   CONFIG.C_In {true} \
   CONFIG.Latency {1} \
   CONFIG.Latency_Configuration {Automatic} \
   CONFIG.Out_Width {10} \
 ] $reduce_3FC_1_0

  # Create instance: tap_1_5_0, and set properties
  set tap_1_5_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 tap_1_5_0 ]
  set_property -dict [ list \
   CONFIG.AsyncInitVal {000000000} \
   CONFIG.DefaultData {000000000} \
   CONFIG.Depth {1} \
   CONFIG.SyncInitVal {000000000} \
   CONFIG.Width {9} \
 ] $tap_1_5_0

  # Create instance: tap_1_ls_5_3_b, and set properties
  set tap_1_ls_5_3_b [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 tap_1_ls_5_3_b ]
  set_property -dict [ list \
   CONFIG.AsyncInitVal {000} \
   CONFIG.DefaultData {000} \
   CONFIG.Depth {1} \
   CONFIG.SyncInitVal {000} \
   CONFIG.Width {3} \
 ] $tap_1_ls_5_3_b

  # Create port connections
  connect_bd_net -net CLK_1 [get_bd_pins CLK] [get_bd_pins reduce_3FC_1_0/CLK] [get_bd_pins tap_1_5_0/CLK] [get_bd_pins tap_1_ls_5_3_b/CLK]
  connect_bd_net -net ls_5_carry1_Res [get_bd_pins C_IN] [get_bd_pins reduce_3FC_1_0/C_IN]
  connect_bd_net -net path_17E_1_0_Dout [get_bd_pins A] [get_bd_pins reduce_3FC_1_0/A]
  connect_bd_net -net path_3FC_1_0_S [get_bd_pins S] [get_bd_pins reduce_3FC_1_0/S]
  connect_bd_net -net reduce_1BE_5_0_S [get_bd_pins D1] [get_bd_pins tap_1_5_0/D]
  connect_bd_net -net reduce_27D_1_0_S [get_bd_pins B] [get_bd_pins reduce_3FC_1_0/B]
  connect_bd_net -net tap_1_5_0_Q [get_bd_pins Q1] [get_bd_pins tap_1_5_0/Q]
  connect_bd_net -net tap_1_ls_5_3_Q [get_bd_pins D] [get_bd_pins tap_1_ls_5_3_b/D]
  connect_bd_net -net tap_1_ls_5_3_b_Q [get_bd_pins Q] [get_bd_pins tap_1_ls_5_3_b/Q]

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
  create_bd_pin -dir I -from 6 -to 0 -type data A
  create_bd_pin -dir I -from 8 -to 0 -type data A1
  create_bd_pin -dir I -from 7 -to 0 -type data A2
  create_bd_pin -dir I -from 8 -to 0 -type data B
  create_bd_pin -dir I -from 5 -to 0 -type data B1
  create_bd_pin -dir I -from 8 -to 0 -type data B2
  create_bd_pin -dir I -type clk CLK
  create_bd_pin -dir I -type data C_IN
  create_bd_pin -dir I -from 1 -to 0 -type data D
  create_bd_pin -dir I -from 2 -to 0 -type data D1
  create_bd_pin -dir O -from 1 -to 0 -type data Q
  create_bd_pin -dir O -from 2 -to 0 -type data Q1
  create_bd_pin -dir O -from 9 -to 0 -type data S
  create_bd_pin -dir O -from 8 -to 0 -type data S1
  create_bd_pin -dir O -from 9 -to 0 -type data S2

  # Create instance: reduce_1BE_5_0, and set properties
  set reduce_1BE_5_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_addsub:12.0 reduce_1BE_5_0 ]
  set_property -dict [ list \
   CONFIG.A_Type {Unsigned} \
   CONFIG.A_Width {9} \
   CONFIG.B_Type {Unsigned} \
   CONFIG.B_Value {000000} \
   CONFIG.B_Width {6} \
   CONFIG.CE {false} \
   CONFIG.C_In {true} \
   CONFIG.Latency {1} \
   CONFIG.Latency_Configuration {Automatic} \
   CONFIG.Out_Width {9} \
 ] $reduce_1BE_5_0

  # Create instance: reduce_27D_1_0, and set properties
  set reduce_27D_1_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_addsub:12.0 reduce_27D_1_0 ]
  set_property -dict [ list \
   CONFIG.A_Type {Unsigned} \
   CONFIG.A_Width {7} \
   CONFIG.B_Type {Unsigned} \
   CONFIG.B_Value {000000000} \
   CONFIG.B_Width {9} \
   CONFIG.CE {false} \
   CONFIG.Latency {1} \
   CONFIG.Latency_Configuration {Automatic} \
   CONFIG.Out_Width {10} \
 ] $reduce_27D_1_0

  # Create instance: reduce_2FD_0_0, and set properties
  set reduce_2FD_0_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_addsub:12.0 reduce_2FD_0_0 ]
  set_property -dict [ list \
   CONFIG.A_Type {Unsigned} \
   CONFIG.A_Width {8} \
   CONFIG.B_Type {Unsigned} \
   CONFIG.B_Value {000000000} \
   CONFIG.B_Width {9} \
   CONFIG.CE {false} \
   CONFIG.Latency {1} \
   CONFIG.Latency_Configuration {Automatic} \
   CONFIG.Out_Width {10} \
 ] $reduce_2FD_0_0

  # Create instance: tap_1_ls_1_0, and set properties
  set tap_1_ls_1_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 tap_1_ls_1_0 ]
  set_property -dict [ list \
   CONFIG.AsyncInitVal {00} \
   CONFIG.DefaultData {00} \
   CONFIG.Depth {1} \
   CONFIG.SyncInitVal {00} \
   CONFIG.Width {2} \
 ] $tap_1_ls_1_0

  # Create instance: tap_1_ls_5_3, and set properties
  set tap_1_ls_5_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 tap_1_ls_5_3 ]
  set_property -dict [ list \
   CONFIG.AsyncInitVal {000} \
   CONFIG.DefaultData {000} \
   CONFIG.Depth {1} \
   CONFIG.SyncInitVal {000} \
   CONFIG.Width {3} \
 ] $tap_1_ls_5_3

  # Create port connections
  connect_bd_net -net CLK_1 [get_bd_pins CLK] [get_bd_pins reduce_1BE_5_0/CLK] [get_bd_pins reduce_27D_1_0/CLK] [get_bd_pins reduce_2FD_0_0/CLK] [get_bd_pins tap_1_ls_1_0/CLK] [get_bd_pins tap_1_ls_5_3/CLK]
  connect_bd_net -net path_0_0_S [get_bd_pins B2] [get_bd_pins reduce_2FD_0_0/B]
  connect_bd_net -net path_17E_4_0_S [get_bd_pins A1] [get_bd_pins reduce_1BE_5_0/A]
  connect_bd_net -net path_1FE_1_0_S [get_bd_pins B] [get_bd_pins reduce_27D_1_0/B]
  connect_bd_net -net path_2_0_ls_5_3_sum_dout [get_bd_pins D1] [get_bd_pins tap_1_ls_5_3/D]
  connect_bd_net -net path_2_0_ls_5_4_Dout [get_bd_pins B1] [get_bd_pins reduce_1BE_5_0/B]
  connect_bd_net -net path_7F_Dout [get_bd_pins A] [get_bd_pins reduce_27D_1_0/A]
  connect_bd_net -net path_ls_1_0_Dout [get_bd_pins D] [get_bd_pins tap_1_ls_1_0/D]
  connect_bd_net -net reduce_1BE_5_0_S [get_bd_pins S1] [get_bd_pins reduce_1BE_5_0/S]
  connect_bd_net -net reduce_27D_1_0_S [get_bd_pins S] [get_bd_pins reduce_27D_1_0/S]
  connect_bd_net -net reduce_2FD_0_0_S [get_bd_pins S2] [get_bd_pins reduce_2FD_0_0/S]
  connect_bd_net -net tap_1_g3_0_0_Q [get_bd_pins A2] [get_bd_pins reduce_2FD_0_0/A]
  connect_bd_net -net tap_1_ls_1_0_Q [get_bd_pins Q] [get_bd_pins tap_1_ls_1_0/Q]
  connect_bd_net -net tap_1_ls_5_3_Q [get_bd_pins Q1] [get_bd_pins tap_1_ls_5_3/Q]
  connect_bd_net -net util_vector_logic_0_Res [get_bd_pins C_IN] [get_bd_pins reduce_1BE_5_0/C_IN]

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
  create_bd_pin -dir I -from 7 -to 0 -type data A
  create_bd_pin -dir I -from 7 -to 0 -type data A1
  create_bd_pin -dir I -from 7 -to 0 -type data A2
  create_bd_pin -dir I -from 7 -to 0 -type data A3
  create_bd_pin -dir I -from 7 -to 0 -type data A4
  create_bd_pin -dir I -from 7 -to 0 -type data B
  create_bd_pin -dir I -from 7 -to 0 -type data B1
  create_bd_pin -dir I -from 7 -to 0 -type data B2
  create_bd_pin -dir I -from 7 -to 0 -type data B3
  create_bd_pin -dir I -from 6 -to 0 -type data B4
  create_bd_pin -dir I -type clk CLK
  create_bd_pin -dir I -from 7 -to 0 -type data D
  create_bd_pin -dir I -from 0 -to 0 -type data D1
  create_bd_pin -dir O -from 7 -to 0 -type data Q
  create_bd_pin -dir O -from 0 -to 0 -type data Q1
  create_bd_pin -dir O -from 8 -to 0 -type data S
  create_bd_pin -dir O -from 8 -to 0 -type data S1
  create_bd_pin -dir O -from 8 -to 0 -type data S2
  create_bd_pin -dir O -from 8 -to 0 -type data S3
  create_bd_pin -dir O -from 8 -to 0 -type data S4

  # Create instance: path_17E_5_0, and set properties
  set path_17E_5_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_addsub:12.0 path_17E_5_0 ]
  set_property -dict [ list \
   CONFIG.A_Type {Unsigned} \
   CONFIG.A_Width {8} \
   CONFIG.B_Type {Unsigned} \
   CONFIG.B_Value {0000000} \
   CONFIG.B_Width {7} \
   CONFIG.CE {false} \
   CONFIG.Latency {1} \
   CONFIG.Latency_Configuration {Automatic} \
   CONFIG.Out_Width {9} \
 ] $path_17E_5_0

  # Create instance: path_1FE, and set properties
  set path_1FE [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_addsub:12.0 path_1FE ]
  set_property -dict [ list \
   CONFIG.A_Type {Unsigned} \
   CONFIG.A_Width {8} \
   CONFIG.B_Type {Unsigned} \
   CONFIG.B_Value {00000000} \
   CONFIG.B_Width {8} \
   CONFIG.CE {false} \
   CONFIG.Latency {1} \
   CONFIG.Latency_Configuration {Automatic} \
   CONFIG.Out_Width {9} \
 ] $path_1FE

  # Create instance: path_1FE_0_0, and set properties
  set path_1FE_0_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_addsub:12.0 path_1FE_0_0 ]
  set_property -dict [ list \
   CONFIG.A_Type {Unsigned} \
   CONFIG.A_Width {8} \
   CONFIG.B_Type {Unsigned} \
   CONFIG.B_Value {00000000} \
   CONFIG.B_Width {8} \
   CONFIG.CE {false} \
   CONFIG.Latency {1} \
   CONFIG.Latency_Configuration {Automatic} \
   CONFIG.Out_Width {9} \
 ] $path_1FE_0_0

  # Create instance: path_1FE_1_0, and set properties
  set path_1FE_1_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_addsub:12.0 path_1FE_1_0 ]
  set_property -dict [ list \
   CONFIG.A_Type {Unsigned} \
   CONFIG.A_Width {8} \
   CONFIG.B_Type {Unsigned} \
   CONFIG.B_Value {00000000} \
   CONFIG.B_Width {8} \
   CONFIG.CE {false} \
   CONFIG.Latency {1} \
   CONFIG.Latency_Configuration {Automatic} \
   CONFIG.Out_Width {9} \
 ] $path_1FE_1_0

  # Create instance: path_1FE_2_0, and set properties
  set path_1FE_2_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_addsub:12.0 path_1FE_2_0 ]
  set_property -dict [ list \
   CONFIG.A_Type {Unsigned} \
   CONFIG.A_Width {8} \
   CONFIG.B_Type {Unsigned} \
   CONFIG.B_Value {00000000} \
   CONFIG.B_Width {8} \
   CONFIG.CE {false} \
   CONFIG.Latency {1} \
   CONFIG.Latency_Configuration {Automatic} \
   CONFIG.Out_Width {9} \
 ] $path_1FE_2_0

  # Create instance: tap_1_g3_0_0, and set properties
  set tap_1_g3_0_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 tap_1_g3_0_0 ]
  set_property -dict [ list \
   CONFIG.AsyncInitVal {00000000} \
   CONFIG.DefaultData {00000000} \
   CONFIG.Depth {1} \
   CONFIG.SyncInitVal {00000000} \
   CONFIG.Width {8} \
 ] $tap_1_g3_0_0

  # Create instance: tap_1_ls_5_5, and set properties
  set tap_1_ls_5_5 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 tap_1_ls_5_5 ]
  set_property -dict [ list \
   CONFIG.AsyncInitVal {0} \
   CONFIG.DefaultData {0} \
   CONFIG.Depth {1} \
   CONFIG.SyncInitVal {0} \
   CONFIG.Width {1} \
 ] $tap_1_ls_5_5

  # Create port connections
  connect_bd_net -net CLK_1 [get_bd_pins CLK] [get_bd_pins path_17E_5_0/CLK] [get_bd_pins path_1FE/CLK] [get_bd_pins path_1FE_0_0/CLK] [get_bd_pins path_1FE_1_0/CLK] [get_bd_pins path_1FE_2_0/CLK] [get_bd_pins tap_1_g3_0_0/CLK] [get_bd_pins tap_1_ls_5_5/CLK]
  connect_bd_net -net path_0_0_S [get_bd_pins S3] [get_bd_pins path_1FE_0_0/S]
  connect_bd_net -net path_17E_4_0_S [get_bd_pins S4] [get_bd_pins path_17E_5_0/S]
  connect_bd_net -net path_1FE_1_0_S [get_bd_pins S] [get_bd_pins path_1FE_1_0/S]
  connect_bd_net -net path_1FE_2_0_S [get_bd_pins S2] [get_bd_pins path_1FE_2_0/S]
  connect_bd_net -net path_1FE_S [get_bd_pins S1] [get_bd_pins path_1FE/S]
  connect_bd_net -net shr_B_b1_2_0 [get_bd_pins B2] [get_bd_pins path_1FE_2_0/B]
  connect_bd_net -net shr_B_b2_1_0 [get_bd_pins A] [get_bd_pins path_1FE_1_0/A]
  connect_bd_net -net shr_B_b3_0_0 [get_bd_pins A3] [get_bd_pins path_1FE_0_0/A]
  connect_bd_net -net shr_B_b4 [get_bd_pins B1] [get_bd_pins path_1FE/B]
  connect_bd_net -net shr_G_g1_5_0 [get_bd_pins A4] [get_bd_pins path_17E_5_0/A]
  connect_bd_net -net shr_G_g2_2_0 [get_bd_pins A2] [get_bd_pins path_1FE_2_0/A]
  connect_bd_net -net shr_G_g3_0_0 [get_bd_pins D] [get_bd_pins tap_1_g3_0_0/D]
  connect_bd_net -net shr_G_g4 [get_bd_pins A1] [get_bd_pins path_1FE/A]
  connect_bd_net -net shr_R_r2_1_0 [get_bd_pins B] [get_bd_pins path_1FE_1_0/B]
  connect_bd_net -net shr_R_r3_0_0 [get_bd_pins B3] [get_bd_pins path_1FE_0_0/B]
  connect_bd_net -net tap_1_g3_0_0_Q [get_bd_pins Q] [get_bd_pins tap_1_g3_0_0/Q]
  connect_bd_net -net tap_1_ls_5_Q [get_bd_pins Q1] [get_bd_pins tap_1_ls_5_5/Q]
  connect_bd_net -net xlslice_0_Dout [get_bd_pins D1] [get_bd_pins tap_1_ls_5_5/D]
  connect_bd_net -net xlslice_1_Dout [get_bd_pins B4] [get_bd_pins path_17E_5_0/B]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: asynci1
proc create_hier_cell_asynci1 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_asynci1() - Empty argument(s)!"}
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
  create_bd_pin -dir O -from 6 -to 0 Dout
  create_bd_pin -dir O -from 0 -to 0 Dout1
  create_bd_pin -dir I -from 23 -to 0 RBG
  create_bd_pin -dir O -from 7 -to 0 b1_2_0
  create_bd_pin -dir O -from 7 -to 0 b2_1_0
  create_bd_pin -dir O -from 7 -to 0 b3_0_0
  create_bd_pin -dir O -from 7 -to 0 b4
  create_bd_pin -dir O -from 7 -to 0 g1_5_0
  create_bd_pin -dir O -from 7 -to 0 g2_2_0
  create_bd_pin -dir O -from 7 -to 0 g3_0_0
  create_bd_pin -dir O -from 7 -to 0 g4
  create_bd_pin -dir O -from 7 -to 0 r2_1_0
  create_bd_pin -dir O -from 7 -to 0 r3_0_0

  # Create instance: B, and set properties
  set B [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 B ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {15} \
   CONFIG.DIN_TO {8} \
   CONFIG.DIN_WIDTH {24} \
   CONFIG.DOUT_WIDTH {8} \
 ] $B

  # Create instance: G, and set properties
  set G [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 G ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {7} \
   CONFIG.DIN_TO {0} \
   CONFIG.DIN_WIDTH {24} \
   CONFIG.DOUT_WIDTH {8} \
 ] $G

  # Create instance: R, and set properties
  set R [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 R ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {23} \
   CONFIG.DIN_TO {16} \
   CONFIG.DIN_WIDTH {24} \
   CONFIG.DOUT_WIDTH {8} \
 ] $R

  # Create instance: path_4_0_ls_5_5, and set properties
  set path_4_0_ls_5_5 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 path_4_0_ls_5_5 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {0} \
   CONFIG.DIN_TO {0} \
   CONFIG.DIN_WIDTH {8} \
 ] $path_4_0_ls_5_5

  # Create instance: path_7F_5_0, and set properties
  set path_7F_5_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 path_7F_5_0 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {7} \
   CONFIG.DIN_TO {1} \
   CONFIG.DIN_WIDTH {8} \
   CONFIG.DOUT_WIDTH {7} \
 ] $path_7F_5_0

  # Create instance: shr_B
  create_hier_cell_shr_B $hier_obj shr_B

  # Create instance: shr_G
  create_hier_cell_shr_G $hier_obj shr_G

  # Create instance: shr_R
  create_hier_cell_shr_R $hier_obj shr_R

  # Create port connections
  connect_bd_net -net B_1 [get_bd_pins B/Dout] [get_bd_pins shr_B/B]
  connect_bd_net -net G_Dout [get_bd_pins G/Dout] [get_bd_pins shr_G/G]
  connect_bd_net -net RBG_1 [get_bd_pins RBG] [get_bd_pins B/Din] [get_bd_pins G/Din] [get_bd_pins R/Din]
  connect_bd_net -net R_1 [get_bd_pins R/Dout] [get_bd_pins shr_R/R]
  connect_bd_net -net shr_B_b1_2_0 [get_bd_pins b1_2_0] [get_bd_pins shr_B/b1_2_0]
  connect_bd_net -net shr_B_b2_1_0 [get_bd_pins b2_1_0] [get_bd_pins shr_B/b2_1_0]
  connect_bd_net -net shr_B_b3_0_0 [get_bd_pins b3_0_0] [get_bd_pins shr_B/b3_0_0]
  connect_bd_net -net shr_B_b4 [get_bd_pins b4] [get_bd_pins shr_B/b4]
  connect_bd_net -net shr_G_g1_5_0 [get_bd_pins g1_5_0] [get_bd_pins shr_G/g1_5_0]
  connect_bd_net -net shr_G_g2_2_0 [get_bd_pins g2_2_0] [get_bd_pins shr_G/g2_2_0]
  connect_bd_net -net shr_G_g3_0_0 [get_bd_pins g3_0_0] [get_bd_pins shr_G/g3_0_0]
  connect_bd_net -net shr_G_g4 [get_bd_pins g4] [get_bd_pins shr_G/g4]
  connect_bd_net -net shr_R_r1_4_0 [get_bd_pins path_4_0_ls_5_5/Din] [get_bd_pins path_7F_5_0/Din] [get_bd_pins shr_R/r1_4_0]
  connect_bd_net -net shr_R_r2_1_0 [get_bd_pins r2_1_0] [get_bd_pins shr_R/r2_1_0]
  connect_bd_net -net shr_R_r3_0_0 [get_bd_pins r3_0_0] [get_bd_pins shr_R/r3_0_0]
  connect_bd_net -net xlslice_0_Dout [get_bd_pins Dout1] [get_bd_pins path_4_0_ls_5_5/Dout]
  connect_bd_net -net xlslice_1_Dout [get_bd_pins Dout] [get_bd_pins path_7F_5_0/Dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: async4o
proc create_hier_cell_async4o { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_async4o() - Empty argument(s)!"}
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
  create_bd_pin -dir I -from 8 -to 0 Din
  create_bd_pin -dir O -from 7 -to 0 y

  # Create instance: lsb, and set properties
  set lsb [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 lsb ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {0} \
   CONFIG.DIN_TO {0} \
   CONFIG.DIN_WIDTH {8} \
   CONFIG.DOUT_WIDTH {1} \
 ] $lsb

  # Create instance: msb, and set properties
  set msb [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 msb ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {7} \
   CONFIG.DIN_TO {1} \
   CONFIG.DIN_WIDTH {8} \
   CONFIG.DOUT_WIDTH {7} \
 ] $msb

  # Create instance: onehalf, and set properties
  set onehalf [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 onehalf ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {0} \
   CONFIG.DIN_TO {0} \
   CONFIG.DIN_WIDTH {9} \
 ] $onehalf

  # Create instance: path_FF_6_0, and set properties
  set path_FF_6_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 path_FF_6_0 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {8} \
   CONFIG.DIN_TO {1} \
   CONFIG.DIN_WIDTH {9} \
   CONFIG.DOUT_WIDTH {8} \
 ] $path_FF_6_0

  # Create instance: round, and set properties
  set round [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 round ]
  set_property -dict [ list \
   CONFIG.C_OPERATION {or} \
   CONFIG.C_SIZE {1} \
   CONFIG.LOGO_FILE {data/sym_orgate.png} \
 ] $round

  # Create instance: y, and set properties
  set y [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 y ]
  set_property -dict [ list \
   CONFIG.IN0_WIDTH {1} \
   CONFIG.IN1_WIDTH {7} \
 ] $y

  # Create port connections
  connect_bd_net -net lsb_Dout [get_bd_pins onehalf/Dout] [get_bd_pins round/Op1]
  connect_bd_net -net lsb_Dout1 [get_bd_pins lsb/Dout] [get_bd_pins round/Op2]
  connect_bd_net -net msb_Dout [get_bd_pins msb/Dout] [get_bd_pins y/In1]
  connect_bd_net -net path_FF_6_0_Dout [get_bd_pins lsb/Din] [get_bd_pins msb/Din] [get_bd_pins path_FF_6_0/Dout]
  connect_bd_net -net reduce_1FE_5_0_S [get_bd_pins Din] [get_bd_pins onehalf/Din] [get_bd_pins path_FF_6_0/Din]
  connect_bd_net -net round_Res [get_bd_pins round/Res] [get_bd_pins y/In0]
  connect_bd_net -net y_dout [get_bd_pins y] [get_bd_pins y/dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: async34
proc create_hier_cell_async34 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_async34() - Empty argument(s)!"}
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
  create_bd_pin -dir I -from 9 -to 0 Din
  create_bd_pin -dir O -from 5 -to 0 Dout
  create_bd_pin -dir I -from 2 -to 0 Op1
  create_bd_pin -dir O Res

  # Create instance: a0_and_b0, and set properties
  set a0_and_b0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 a0_and_b0 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {0} \
   CONFIG.DIN_TO {0} \
   CONFIG.DIN_WIDTH {3} \
 ] $a0_and_b0

  # Create instance: a1_and_b1, and set properties
  set a1_and_b1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 a1_and_b1 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {1} \
   CONFIG.DIN_TO {1} \
   CONFIG.DIN_WIDTH {3} \
 ] $a1_and_b1

  # Create instance: a1_xor_b1, and set properties
  set a1_xor_b1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 a1_xor_b1 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {0} \
   CONFIG.DIN_TO {0} \
   CONFIG.DIN_WIDTH {2} \
 ] $a1_xor_b1

  # Create instance: a2_and_b2, and set properties
  set a2_and_b2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 a2_and_b2 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {2} \
   CONFIG.DIN_TO {2} \
   CONFIG.DIN_WIDTH {3} \
 ] $a2_and_b2

  # Create instance: a2_xor_b2, and set properties
  set a2_xor_b2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 a2_xor_b2 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {1} \
   CONFIG.DIN_TO {1} \
   CONFIG.DIN_WIDTH {2} \
 ] $a2_xor_b2

  # Create instance: a_and_b, and set properties
  set a_and_b [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 a_and_b ]
  set_property -dict [ list \
   CONFIG.C_SIZE {3} \
 ] $a_and_b

  # Create instance: a_xor_b, and set properties
  set a_xor_b [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 a_xor_b ]
  set_property -dict [ list \
   CONFIG.C_OPERATION {xor} \
   CONFIG.C_SIZE {2} \
   CONFIG.LOGO_FILE {data/sym_xorgate.png} \
 ] $a_xor_b

  # Create instance: carry_0_1, and set properties
  set carry_0_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 carry_0_1 ]
  set_property -dict [ list \
   CONFIG.C_SIZE {1} \
 ] $carry_0_1

  # Create instance: carry_0_2, and set properties
  set carry_0_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 carry_0_2 ]
  set_property -dict [ list \
   CONFIG.C_SIZE {1} \
 ] $carry_0_2

  # Create instance: carry_1_2, and set properties
  set carry_1_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 carry_1_2 ]
  set_property -dict [ list \
   CONFIG.C_SIZE {1} \
 ] $carry_1_2

  # Create instance: carry_3_bit, and set properties
  set carry_3_bit [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 carry_3_bit ]
  set_property -dict [ list \
   CONFIG.IN0_WIDTH {1} \
   CONFIG.IN1_WIDTH {1} \
   CONFIG.IN2_WIDTH {1} \
   CONFIG.NUM_PORTS {3} \
 ] $carry_3_bit

  # Create instance: ls_5_3_carry, and set properties
  set ls_5_3_carry [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_reduced_logic:2.0 ls_5_3_carry ]
  set_property -dict [ list \
   CONFIG.C_OPERATION {or} \
   CONFIG.C_SIZE {3} \
   CONFIG.LOGO_FILE {data/sym_orgate.png} \
 ] $ls_5_3_carry

  # Create instance: path_1_0_ls_5_3, and set properties
  set path_1_0_ls_5_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 path_1_0_ls_5_3 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {3} \
   CONFIG.DIN_TO {1} \
   CONFIG.DIN_WIDTH {10} \
   CONFIG.DOUT_WIDTH {3} \
 ] $path_1_0_ls_5_3

  # Create instance: path_3F_5_0_b, and set properties
  set path_3F_5_0_b [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 path_3F_5_0_b ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {9} \
   CONFIG.DIN_TO {4} \
   CONFIG.DIN_WIDTH {10} \
   CONFIG.DOUT_WIDTH {6} \
 ] $path_3F_5_0_b

  # Create instance: path_5_4_a, and set properties
  set path_5_4_a [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 path_5_4_a ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {2} \
   CONFIG.DIN_TO {1} \
   CONFIG.DIN_WIDTH {3} \
   CONFIG.DOUT_WIDTH {2} \
 ] $path_5_4_a

  # Create instance: path_5_4_b, and set properties
  set path_5_4_b [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 path_5_4_b ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {2} \
   CONFIG.DIN_TO {1} \
   CONFIG.DIN_WIDTH {3} \
   CONFIG.DOUT_WIDTH {2} \
 ] $path_5_4_b

  # Create port connections
  connect_bd_net -net a0_and_b0_Dout [get_bd_pins a0_and_b0/Dout] [get_bd_pins carry_0_1/Op2]
  connect_bd_net -net a1_and_b1_Dout [get_bd_pins a1_and_b1/Dout] [get_bd_pins carry_1_2/Op1]
  connect_bd_net -net a1_xor_b1_Dout [get_bd_pins a1_xor_b1/Dout] [get_bd_pins carry_0_1/Op1]
  connect_bd_net -net a2_xor_b2_Dout [get_bd_pins a2_xor_b2/Dout] [get_bd_pins carry_0_2/Op1] [get_bd_pins carry_1_2/Op2]
  connect_bd_net -net carry_1_2_Res [get_bd_pins carry_0_2/Res] [get_bd_pins carry_3_bit/In2]
  connect_bd_net -net carry_from_2_Res [get_bd_pins carry_0_1/Res] [get_bd_pins carry_0_2/Op2]
  connect_bd_net -net ls_5_3_carry_Res [get_bd_pins Res] [get_bd_pins ls_5_3_carry/Res]
  connect_bd_net -net path_1_0_ls_5_3_Dout [get_bd_pins a_and_b/Op2] [get_bd_pins path_1_0_ls_5_3/Dout] [get_bd_pins path_5_4_a/Din]
  connect_bd_net -net path_3FC_1_0_S [get_bd_pins Din] [get_bd_pins path_1_0_ls_5_3/Din] [get_bd_pins path_3F_5_0_b/Din]
  connect_bd_net -net path_3F_5_0_b_Dout [get_bd_pins Dout] [get_bd_pins path_3F_5_0_b/Dout]
  connect_bd_net -net path_5_4_a_Dout [get_bd_pins a_xor_b/Op2] [get_bd_pins path_5_4_a/Dout]
  connect_bd_net -net path_5_4_b_Dout [get_bd_pins a_xor_b/Op1] [get_bd_pins path_5_4_b/Dout]
  connect_bd_net -net tap_1_ls_5_3_b_Q [get_bd_pins Op1] [get_bd_pins a_and_b/Op1] [get_bd_pins path_5_4_b/Din]
  connect_bd_net -net util_vector_logic_0_Res1 [get_bd_pins a0_and_b0/Din] [get_bd_pins a1_and_b1/Din] [get_bd_pins a2_and_b2/Din] [get_bd_pins a_and_b/Res]
  connect_bd_net -net util_vector_logic_1_Res1 [get_bd_pins a1_xor_b1/Din] [get_bd_pins a2_xor_b2/Din] [get_bd_pins a_xor_b/Res]
  connect_bd_net -net util_vector_logic_2_Res [get_bd_pins carry_1_2/Res] [get_bd_pins carry_3_bit/In1]
  connect_bd_net -net xlconcat_0_dout [get_bd_pins carry_3_bit/dout] [get_bd_pins ls_5_3_carry/Op1]
  connect_bd_net -net xlslice_0_Dout3 [get_bd_pins a2_and_b2/Dout] [get_bd_pins carry_3_bit/In0]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: async23
proc create_hier_cell_async23 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_async23() - Empty argument(s)!"}
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
  create_bd_pin -dir I -from 9 -to 0 Din
  create_bd_pin -dir I -from 1 -to 0 Din1
  create_bd_pin -dir O -from 8 -to 0 Dout
  create_bd_pin -dir O -from 0 -to 0 Res

  # Create instance: ls_1_carry, and set properties
  set ls_1_carry [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 ls_1_carry ]
  set_property -dict [ list \
   CONFIG.C_SIZE {1} \
 ] $ls_1_carry

  # Create instance: path_0_0_ls_1_1, and set properties
  set path_0_0_ls_1_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 path_0_0_ls_1_1 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {0} \
   CONFIG.DIN_TO {0} \
   CONFIG.DIN_WIDTH {10} \
   CONFIG.DOUT_WIDTH {1} \
 ] $path_0_0_ls_1_1

  # Create instance: path_17E_1_0, and set properties
  set path_17E_1_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 path_17E_1_0 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {9} \
   CONFIG.DIN_TO {1} \
   CONFIG.DIN_WIDTH {10} \
   CONFIG.DOUT_WIDTH {9} \
 ] $path_17E_1_0

  # Create instance: path_1_0_ls_1_1, and set properties
  set path_1_0_ls_1_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 path_1_0_ls_1_1 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {1} \
   CONFIG.DIN_TO {1} \
   CONFIG.DIN_WIDTH {2} \
   CONFIG.DOUT_WIDTH {1} \
 ] $path_1_0_ls_1_1

  # Create port connections
  connect_bd_net -net ls_5_carry1_Res [get_bd_pins Res] [get_bd_pins ls_1_carry/Res]
  connect_bd_net -net path_0_0_ls_1_Dout [get_bd_pins ls_1_carry/Op1] [get_bd_pins path_0_0_ls_1_1/Dout]
  connect_bd_net -net path_17E_1_0_Dout [get_bd_pins Dout] [get_bd_pins path_17E_1_0/Dout]
  connect_bd_net -net reduce_2FD_0_0_S [get_bd_pins Din] [get_bd_pins path_0_0_ls_1_1/Din] [get_bd_pins path_17E_1_0/Din]
  connect_bd_net -net tap_1_ls_1_0_Q [get_bd_pins Din1] [get_bd_pins path_1_0_ls_1_1/Din]
  connect_bd_net -net xlslice_0_Dout2 [get_bd_pins ls_1_carry/Op2] [get_bd_pins path_1_0_ls_1_1/Dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: async12
proc create_hier_cell_async12 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_async12() - Empty argument(s)!"}
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
  create_bd_pin -dir I -from 8 -to 0 Din
  create_bd_pin -dir I -from 8 -to 0 Din1
  create_bd_pin -dir O -from 6 -to 0 Dout
  create_bd_pin -dir O -from 5 -to 0 Dout1
  create_bd_pin -dir O -from 1 -to 0 Dout2
  create_bd_pin -dir I -from 0 -to 0 Op1
  create_bd_pin -dir O -from 0 -to 0 Res
  create_bd_pin -dir O -from 2 -to 0 dout3

  # Create instance: ls_5_carry, and set properties
  set ls_5_carry [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 ls_5_carry ]
  set_property -dict [ list \
   CONFIG.C_SIZE {1} \
 ] $ls_5_carry

  # Create instance: ls_5_sum, and set properties
  set ls_5_sum [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 ls_5_sum ]
  set_property -dict [ list \
   CONFIG.C_OPERATION {xor} \
   CONFIG.C_SIZE {1} \
   CONFIG.LOGO_FILE {data/sym_xorgate.png} \
 ] $ls_5_sum

  # Create instance: path_2_0_ls_4_3, and set properties
  set path_2_0_ls_4_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 path_2_0_ls_4_3 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {1} \
   CONFIG.DIN_TO {0} \
   CONFIG.DIN_WIDTH {3} \
   CONFIG.DOUT_WIDTH {2} \
 ] $path_2_0_ls_4_3

  # Create instance: path_2_0_ls_5_3, and set properties
  set path_2_0_ls_5_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 path_2_0_ls_5_3 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {2} \
   CONFIG.DIN_TO {0} \
   CONFIG.DIN_WIDTH {9} \
   CONFIG.DOUT_WIDTH {3} \
 ] $path_2_0_ls_5_3

  # Create instance: path_2_0_ls_5_3_sum, and set properties
  set path_2_0_ls_5_3_sum [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 path_2_0_ls_5_3_sum ]
  set_property -dict [ list \
   CONFIG.IN0_WIDTH {2} \
   CONFIG.IN1_WIDTH {1} \
 ] $path_2_0_ls_5_3_sum

  # Create instance: path_2_0_ls_5_5, and set properties
  set path_2_0_ls_5_5 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 path_2_0_ls_5_5 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {2} \
   CONFIG.DIN_TO {2} \
   CONFIG.DIN_WIDTH {3} \
   CONFIG.DOUT_WIDTH {1} \
 ] $path_2_0_ls_5_5

  # Create instance: path_3F_5_0, and set properties
  set path_3F_5_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 path_3F_5_0 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {8} \
   CONFIG.DIN_TO {3} \
   CONFIG.DIN_WIDTH {9} \
   CONFIG.DOUT_WIDTH {6} \
 ] $path_3F_5_0

  # Create instance: path_7F_1_0, and set properties
  set path_7F_1_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 path_7F_1_0 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {8} \
   CONFIG.DIN_TO {2} \
   CONFIG.DIN_WIDTH {9} \
   CONFIG.DOUT_WIDTH {7} \
 ] $path_7F_1_0

  # Create instance: path_ls_1_0, and set properties
  set path_ls_1_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 path_ls_1_0 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {1} \
   CONFIG.DIN_TO {0} \
   CONFIG.DIN_WIDTH {9} \
   CONFIG.DOUT_WIDTH {2} \
 ] $path_ls_1_0

  # Create port connections
  connect_bd_net -net path_1FE_2_0_S [get_bd_pins Din1] [get_bd_pins path_2_0_ls_5_3/Din] [get_bd_pins path_3F_5_0/Din]
  connect_bd_net -net path_1FE_S [get_bd_pins Din] [get_bd_pins path_7F_1_0/Din] [get_bd_pins path_ls_1_0/Din]
  connect_bd_net -net path_2_0_ls_4_3_Dout [get_bd_pins path_2_0_ls_4_3/Dout] [get_bd_pins path_2_0_ls_5_3_sum/In0]
  connect_bd_net -net path_2_0_ls_5_3_Dout [get_bd_pins path_2_0_ls_4_3/Din] [get_bd_pins path_2_0_ls_5_3/Dout] [get_bd_pins path_2_0_ls_5_5/Din]
  connect_bd_net -net path_2_0_ls_5_3_sum_dout [get_bd_pins dout3] [get_bd_pins path_2_0_ls_5_3_sum/dout]
  connect_bd_net -net path_2_0_ls_5_4_Dout [get_bd_pins Dout1] [get_bd_pins path_3F_5_0/Dout]
  connect_bd_net -net path_7F_Dout [get_bd_pins Dout] [get_bd_pins path_7F_1_0/Dout]
  connect_bd_net -net path_ls_1_0_Dout [get_bd_pins Dout2] [get_bd_pins path_ls_1_0/Dout]
  connect_bd_net -net tap_1_ls_5_Q [get_bd_pins Op1] [get_bd_pins ls_5_carry/Op1] [get_bd_pins ls_5_sum/Op1]
  connect_bd_net -net util_vector_logic_0_Res [get_bd_pins Res] [get_bd_pins ls_5_carry/Res]
  connect_bd_net -net util_vector_logic_1_Res [get_bd_pins ls_5_sum/Res] [get_bd_pins path_2_0_ls_5_3_sum/In1]
  connect_bd_net -net xlslice_0_Dout1 [get_bd_pins ls_5_carry/Op2] [get_bd_pins ls_5_sum/Op2] [get_bd_pins path_2_0_ls_5_5/Dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: timing
proc create_hier_cell_timing { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_timing() - Empty argument(s)!"}
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
  create_bd_pin -dir I -from 0 -to 0 -type data tlast_in
  create_bd_pin -dir O -from 0 -to 0 -type data tlast_out
  create_bd_pin -dir O -from 0 -to 0 tready_in
  create_bd_pin -dir I -from 0 -to 0 -type data tuser_in
  create_bd_pin -dir O -from 0 -to 0 -type data tuser_out
  create_bd_pin -dir I -from 0 -to 0 -type data tvalid_in
  create_bd_pin -dir O -from 0 -to 0 -type data tvalid_out

  # Create instance: o_1, and set properties
  set o_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 o_1 ]

  # Create instance: tap_4_last, and set properties
  set tap_4_last [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 tap_4_last ]
  set_property -dict [ list \
   CONFIG.AsyncInitVal {0} \
   CONFIG.DefaultData {0} \
   CONFIG.Depth {4} \
   CONFIG.SyncInitVal {0} \
   CONFIG.Width {1} \
 ] $tap_4_last

  # Create instance: tap_4_user, and set properties
  set tap_4_user [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 tap_4_user ]
  set_property -dict [ list \
   CONFIG.AsyncInitVal {0} \
   CONFIG.DefaultData {0} \
   CONFIG.Depth {4} \
   CONFIG.SyncInitVal {0} \
   CONFIG.Width {1} \
 ] $tap_4_user

  # Create instance: tap_4_valid, and set properties
  set tap_4_valid [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 tap_4_valid ]
  set_property -dict [ list \
   CONFIG.AsyncInitVal {0} \
   CONFIG.DefaultData {0} \
   CONFIG.Depth {4} \
   CONFIG.SyncInitVal {0} \
   CONFIG.Width {1} \
 ] $tap_4_valid

  # Create port connections
  connect_bd_net -net CLK_1 [get_bd_pins CLK] [get_bd_pins tap_4_last/CLK] [get_bd_pins tap_4_user/CLK] [get_bd_pins tap_4_valid/CLK]
  connect_bd_net -net tap_4_last_Q [get_bd_pins tlast_out] [get_bd_pins tap_4_last/Q]
  connect_bd_net -net tap_4_user_Q [get_bd_pins tuser_out] [get_bd_pins tap_4_user/Q]
  connect_bd_net -net tap_4_valid_Q [get_bd_pins tvalid_out] [get_bd_pins tap_4_valid/Q]
  connect_bd_net -net tlast_in_1 [get_bd_pins tlast_in] [get_bd_pins tap_4_last/D]
  connect_bd_net -net tuser_in_1 [get_bd_pins tuser_in] [get_bd_pins tap_4_user/D]
  connect_bd_net -net tvalid_in_1 [get_bd_pins tvalid_in] [get_bd_pins tap_4_valid/D]
  connect_bd_net -net xlconstant_0_dout [get_bd_pins tready_in] [get_bd_pins o_1/dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: split
proc create_hier_cell_split { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_split() - Empty argument(s)!"}
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
  create_bd_pin -dir O -from 23 -to 0 Dout0
  create_bd_pin -dir O -from 23 -to 0 Dout1
  create_bd_pin -dir I -from 47 -to 0 tdata_in

  # Create instance: xlslice_0, and set properties
  set xlslice_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_0 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {23} \
   CONFIG.DIN_TO {0} \
   CONFIG.DIN_WIDTH {48} \
   CONFIG.DOUT_WIDTH {24} \
 ] $xlslice_0

  # Create instance: xlslice_1, and set properties
  set xlslice_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_1 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {47} \
   CONFIG.DIN_TO {24} \
   CONFIG.DIN_WIDTH {48} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_1

  # Create port connections
  connect_bd_net -net tdata_in_1 [get_bd_pins tdata_in] [get_bd_pins xlslice_0/Din] [get_bd_pins xlslice_1/Din]
  connect_bd_net -net xlslice_0_Dout [get_bd_pins Dout0] [get_bd_pins xlslice_0/Dout]
  connect_bd_net -net xlslice_1_Dout [get_bd_pins Dout1] [get_bd_pins xlslice_1/Dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: rgb2y_1
proc create_hier_cell_rgb2y_1 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_rgb2y_1() - Empty argument(s)!"}
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
  create_bd_pin -dir I -from 23 -to 0 RBG
  create_bd_pin -dir O -from 7 -to 0 y

  # Create instance: async12
  create_hier_cell_async12_1 $hier_obj async12

  # Create instance: async23
  create_hier_cell_async23_1 $hier_obj async23

  # Create instance: async34
  create_hier_cell_async34_1 $hier_obj async34

  # Create instance: async4o
  create_hier_cell_async4o_1 $hier_obj async4o

  # Create instance: asynci1
  create_hier_cell_asynci1_1 $hier_obj asynci1

  # Create instance: stage1_1
  create_hier_cell_stage1_1_1 $hier_obj stage1_1

  # Create instance: stage2_1
  create_hier_cell_stage2_1_1 $hier_obj stage2_1

  # Create instance: stage3_1
  create_hier_cell_stage3_1_1 $hier_obj stage3_1

  # Create instance: stage4_1
  create_hier_cell_stage4_1_1 $hier_obj stage4_1

  # Create port connections
  connect_bd_net -net CLK_1 [get_bd_pins CLK] [get_bd_pins stage1_1/CLK] [get_bd_pins stage2_1/CLK] [get_bd_pins stage3_1/CLK] [get_bd_pins stage4_1/CLK]
  connect_bd_net -net RBG_1 [get_bd_pins RBG] [get_bd_pins asynci1/RBG]
  connect_bd_net -net ls_5_3_carry_Res [get_bd_pins async34/Res] [get_bd_pins stage4_1/C_IN]
  connect_bd_net -net ls_5_carry1_Res [get_bd_pins async23/Res] [get_bd_pins stage3_1/C_IN]
  connect_bd_net -net path_0_0_S [get_bd_pins stage1_1/S3] [get_bd_pins stage2_1/B2]
  connect_bd_net -net path_17E_1_0_Dout [get_bd_pins async23/Dout] [get_bd_pins stage3_1/A]
  connect_bd_net -net path_17E_4_0_S [get_bd_pins stage1_1/S4] [get_bd_pins stage2_1/A1]
  connect_bd_net -net path_1FE_1_0_S [get_bd_pins stage1_1/S] [get_bd_pins stage2_1/B]
  connect_bd_net -net path_1FE_2_0_S [get_bd_pins async12/Din1] [get_bd_pins stage1_1/S2]
  connect_bd_net -net path_1FE_S [get_bd_pins async12/Din] [get_bd_pins stage1_1/S1]
  connect_bd_net -net path_2_0_ls_5_3_sum_dout [get_bd_pins async12/dout3] [get_bd_pins stage2_1/D1]
  connect_bd_net -net path_2_0_ls_5_4_Dout [get_bd_pins async12/Dout1] [get_bd_pins stage2_1/B1]
  connect_bd_net -net path_3FC_1_0_S [get_bd_pins async34/Din] [get_bd_pins stage3_1/S]
  connect_bd_net -net path_3F_5_0_b_Dout [get_bd_pins async34/Dout] [get_bd_pins stage4_1/B]
  connect_bd_net -net path_7F_Dout [get_bd_pins async12/Dout] [get_bd_pins stage2_1/A]
  connect_bd_net -net path_ls_1_0_Dout [get_bd_pins async12/Dout2] [get_bd_pins stage2_1/D]
  connect_bd_net -net reduce_1BE_5_0_S [get_bd_pins stage2_1/S1] [get_bd_pins stage3_1/D1]
  connect_bd_net -net reduce_1FE_5_0_S [get_bd_pins async4o/Din] [get_bd_pins stage4_1/S]
  connect_bd_net -net reduce_27D_1_0_S [get_bd_pins stage2_1/S] [get_bd_pins stage3_1/B]
  connect_bd_net -net reduce_2FD_0_0_S [get_bd_pins async23/Din] [get_bd_pins stage2_1/S2]
  connect_bd_net -net shr_B_b1_2_0 [get_bd_pins asynci1/b1_2_0] [get_bd_pins stage1_1/B2]
  connect_bd_net -net shr_B_b2_1_0 [get_bd_pins asynci1/b2_1_0] [get_bd_pins stage1_1/A]
  connect_bd_net -net shr_B_b3_0_0 [get_bd_pins asynci1/b3_0_0] [get_bd_pins stage1_1/A3]
  connect_bd_net -net shr_B_b4 [get_bd_pins asynci1/b4] [get_bd_pins stage1_1/B1]
  connect_bd_net -net shr_G_g1_5_0 [get_bd_pins asynci1/g1_5_0] [get_bd_pins stage1_1/A4]
  connect_bd_net -net shr_G_g2_2_0 [get_bd_pins asynci1/g2_2_0] [get_bd_pins stage1_1/A2]
  connect_bd_net -net shr_G_g3_0_0 [get_bd_pins asynci1/g3_0_0] [get_bd_pins stage1_1/D]
  connect_bd_net -net shr_G_g4 [get_bd_pins asynci1/g4] [get_bd_pins stage1_1/A1]
  connect_bd_net -net shr_R_r2_1_0 [get_bd_pins asynci1/r2_1_0] [get_bd_pins stage1_1/B]
  connect_bd_net -net shr_R_r3_0_0 [get_bd_pins asynci1/r3_0_0] [get_bd_pins stage1_1/B3]
  connect_bd_net -net tap_1_5_0_Q [get_bd_pins stage3_1/Q1] [get_bd_pins stage4_1/A]
  connect_bd_net -net tap_1_g3_0_0_Q [get_bd_pins stage1_1/Q] [get_bd_pins stage2_1/A2]
  connect_bd_net -net tap_1_ls_1_0_Q [get_bd_pins async23/Din1] [get_bd_pins stage2_1/Q]
  connect_bd_net -net tap_1_ls_5_3_Q [get_bd_pins stage2_1/Q1] [get_bd_pins stage3_1/D]
  connect_bd_net -net tap_1_ls_5_3_b_Q [get_bd_pins async34/Op1] [get_bd_pins stage3_1/Q]
  connect_bd_net -net tap_1_ls_5_Q [get_bd_pins async12/Op1] [get_bd_pins stage1_1/Q1]
  connect_bd_net -net util_vector_logic_0_Res [get_bd_pins async12/Res] [get_bd_pins stage2_1/C_IN]
  connect_bd_net -net xlslice_0_Dout [get_bd_pins asynci1/Dout1] [get_bd_pins stage1_1/D1]
  connect_bd_net -net xlslice_1_Dout [get_bd_pins asynci1/Dout] [get_bd_pins stage1_1/B4]
  connect_bd_net -net y_dout [get_bd_pins y] [get_bd_pins async4o/y]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: rgb2y
proc create_hier_cell_rgb2y_1 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_rgb2y_1() - Empty argument(s)!"}
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
  create_bd_pin -dir I -from 23 -to 0 RBG
  create_bd_pin -dir O -from 7 -to 0 y

  # Create instance: async12
  create_hier_cell_async12 $hier_obj async12

  # Create instance: async23
  create_hier_cell_async23 $hier_obj async23

  # Create instance: async34
  create_hier_cell_async34 $hier_obj async34

  # Create instance: async4o
  create_hier_cell_async4o $hier_obj async4o

  # Create instance: asynci1
  create_hier_cell_asynci1 $hier_obj asynci1

  # Create instance: stage1_1
  create_hier_cell_stage1_1 $hier_obj stage1_1

  # Create instance: stage2_1
  create_hier_cell_stage2_1 $hier_obj stage2_1

  # Create instance: stage3_1
  create_hier_cell_stage3_1 $hier_obj stage3_1

  # Create instance: stage4_1
  create_hier_cell_stage4_1 $hier_obj stage4_1

  # Create port connections
  connect_bd_net -net CLK_1 [get_bd_pins CLK] [get_bd_pins stage1_1/CLK] [get_bd_pins stage2_1/CLK] [get_bd_pins stage3_1/CLK] [get_bd_pins stage4_1/CLK]
  connect_bd_net -net RBG_1 [get_bd_pins RBG] [get_bd_pins asynci1/RBG]
  connect_bd_net -net ls_5_3_carry_Res [get_bd_pins async34/Res] [get_bd_pins stage4_1/C_IN]
  connect_bd_net -net ls_5_carry1_Res [get_bd_pins async23/Res] [get_bd_pins stage3_1/C_IN]
  connect_bd_net -net path_0_0_S [get_bd_pins stage1_1/S3] [get_bd_pins stage2_1/B2]
  connect_bd_net -net path_17E_1_0_Dout [get_bd_pins async23/Dout] [get_bd_pins stage3_1/A]
  connect_bd_net -net path_17E_4_0_S [get_bd_pins stage1_1/S4] [get_bd_pins stage2_1/A1]
  connect_bd_net -net path_1FE_1_0_S [get_bd_pins stage1_1/S] [get_bd_pins stage2_1/B]
  connect_bd_net -net path_1FE_2_0_S [get_bd_pins async12/Din1] [get_bd_pins stage1_1/S2]
  connect_bd_net -net path_1FE_S [get_bd_pins async12/Din] [get_bd_pins stage1_1/S1]
  connect_bd_net -net path_2_0_ls_5_3_sum_dout [get_bd_pins async12/dout3] [get_bd_pins stage2_1/D1]
  connect_bd_net -net path_2_0_ls_5_4_Dout [get_bd_pins async12/Dout1] [get_bd_pins stage2_1/B1]
  connect_bd_net -net path_3FC_1_0_S [get_bd_pins async34/Din] [get_bd_pins stage3_1/S]
  connect_bd_net -net path_3F_5_0_b_Dout [get_bd_pins async34/Dout] [get_bd_pins stage4_1/B]
  connect_bd_net -net path_7F_Dout [get_bd_pins async12/Dout] [get_bd_pins stage2_1/A]
  connect_bd_net -net path_ls_1_0_Dout [get_bd_pins async12/Dout2] [get_bd_pins stage2_1/D]
  connect_bd_net -net reduce_1BE_5_0_S [get_bd_pins stage2_1/S1] [get_bd_pins stage3_1/D1]
  connect_bd_net -net reduce_1FE_5_0_S [get_bd_pins async4o/Din] [get_bd_pins stage4_1/S]
  connect_bd_net -net reduce_27D_1_0_S [get_bd_pins stage2_1/S] [get_bd_pins stage3_1/B]
  connect_bd_net -net reduce_2FD_0_0_S [get_bd_pins async23/Din] [get_bd_pins stage2_1/S2]
  connect_bd_net -net shr_B_b1_2_0 [get_bd_pins asynci1/b1_2_0] [get_bd_pins stage1_1/B2]
  connect_bd_net -net shr_B_b2_1_0 [get_bd_pins asynci1/b2_1_0] [get_bd_pins stage1_1/A]
  connect_bd_net -net shr_B_b3_0_0 [get_bd_pins asynci1/b3_0_0] [get_bd_pins stage1_1/A3]
  connect_bd_net -net shr_B_b4 [get_bd_pins asynci1/b4] [get_bd_pins stage1_1/B1]
  connect_bd_net -net shr_G_g1_5_0 [get_bd_pins asynci1/g1_5_0] [get_bd_pins stage1_1/A4]
  connect_bd_net -net shr_G_g2_2_0 [get_bd_pins asynci1/g2_2_0] [get_bd_pins stage1_1/A2]
  connect_bd_net -net shr_G_g3_0_0 [get_bd_pins asynci1/g3_0_0] [get_bd_pins stage1_1/D]
  connect_bd_net -net shr_G_g4 [get_bd_pins asynci1/g4] [get_bd_pins stage1_1/A1]
  connect_bd_net -net shr_R_r2_1_0 [get_bd_pins asynci1/r2_1_0] [get_bd_pins stage1_1/B]
  connect_bd_net -net shr_R_r3_0_0 [get_bd_pins asynci1/r3_0_0] [get_bd_pins stage1_1/B3]
  connect_bd_net -net tap_1_5_0_Q [get_bd_pins stage3_1/Q1] [get_bd_pins stage4_1/A]
  connect_bd_net -net tap_1_g3_0_0_Q [get_bd_pins stage1_1/Q] [get_bd_pins stage2_1/A2]
  connect_bd_net -net tap_1_ls_1_0_Q [get_bd_pins async23/Din1] [get_bd_pins stage2_1/Q]
  connect_bd_net -net tap_1_ls_5_3_Q [get_bd_pins stage2_1/Q1] [get_bd_pins stage3_1/D]
  connect_bd_net -net tap_1_ls_5_3_b_Q [get_bd_pins async34/Op1] [get_bd_pins stage3_1/Q]
  connect_bd_net -net tap_1_ls_5_Q [get_bd_pins async12/Op1] [get_bd_pins stage1_1/Q1]
  connect_bd_net -net util_vector_logic_0_Res [get_bd_pins async12/Res] [get_bd_pins stage2_1/C_IN]
  connect_bd_net -net xlslice_0_Dout [get_bd_pins asynci1/Dout1] [get_bd_pins stage1_1/D1]
  connect_bd_net -net xlslice_1_Dout [get_bd_pins asynci1/Dout] [get_bd_pins stage1_1/B4]
  connect_bd_net -net y_dout [get_bd_pins y] [get_bd_pins async4o/y]

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
  set CLK [ create_bd_port -dir I -type clk CLK ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {300000000} \
 ] $CLK
  set tdata_in [ create_bd_port -dir I -from 47 -to 0 tdata_in ]
  set tdata_out [ create_bd_port -dir O -from 15 -to 0 tdata_out ]
  set tlast_in [ create_bd_port -dir I -from 0 -to 0 -type data tlast_in ]
  set tlast_out [ create_bd_port -dir O -from 0 -to 0 -type data tlast_out ]
  set tready_in [ create_bd_port -dir O -from 0 -to 0 tready_in ]
  set tready_out [ create_bd_port -dir I tready_out ]
  set tuser_in [ create_bd_port -dir I -from 0 -to 0 -type data tuser_in ]
  set tuser_out [ create_bd_port -dir O -from 0 -to 0 -type data tuser_out ]
  set tvalid_in [ create_bd_port -dir I -from 0 -to 0 -type data tvalid_in ]
  set tvalid_out [ create_bd_port -dir O -from 0 -to 0 -type data tvalid_out ]

  # Create instance: pack, and set properties
  set pack [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 pack ]
  set_property -dict [ list \
   CONFIG.IN0_WIDTH {8} \
   CONFIG.IN1_WIDTH {8} \
 ] $pack

  # Create instance: rgb2y
  create_hier_cell_rgb2y_1 [current_bd_instance .] rgb2y

  # Create instance: rgb2y_1
  create_hier_cell_rgb2y_1 [current_bd_instance .] rgb2y_1

  # Create instance: split
  create_hier_cell_split [current_bd_instance .] split

  # Create instance: timing
  create_hier_cell_timing [current_bd_instance .] timing

  # Create port connections
  connect_bd_net -net CLK_1 [get_bd_ports CLK] [get_bd_pins rgb2y/CLK] [get_bd_pins rgb2y_1/CLK] [get_bd_pins timing/CLK]
  connect_bd_net -net RBG_1 [get_bd_pins rgb2y/RBG] [get_bd_pins split/Dout0]
  connect_bd_net -net rgb2y_y [get_bd_pins pack/In0] [get_bd_pins rgb2y/y]
  connect_bd_net -net rgb2y_y1 [get_bd_pins pack/In1] [get_bd_pins rgb2y_1/y]
  connect_bd_net -net split_Dout1 [get_bd_pins rgb2y_1/RBG] [get_bd_pins split/Dout1]
  connect_bd_net -net tap_4_last_Q [get_bd_ports tlast_out] [get_bd_pins timing/tlast_out]
  connect_bd_net -net tap_4_user_Q [get_bd_ports tuser_out] [get_bd_pins timing/tuser_out]
  connect_bd_net -net tap_4_valid_Q [get_bd_ports tvalid_out] [get_bd_pins timing/tvalid_out]
  connect_bd_net -net tdata_in_1 [get_bd_ports tdata_in] [get_bd_pins split/tdata_in]
  connect_bd_net -net tlast_in_1 [get_bd_ports tlast_in] [get_bd_pins timing/tlast_in]
  connect_bd_net -net tuser_in_1 [get_bd_ports tuser_in] [get_bd_pins timing/tuser_in]
  connect_bd_net -net tvalid_in_1 [get_bd_ports tvalid_in] [get_bd_pins timing/tvalid_in]
  connect_bd_net -net xlconcat_0_dout [get_bd_ports tdata_out] [get_bd_pins pack/dout]
  connect_bd_net -net xlconstant_0_dout [get_bd_ports tready_in] [get_bd_pins timing/tready_in]

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


