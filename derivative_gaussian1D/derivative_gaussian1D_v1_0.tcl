
################################################################
# This is a generated script based on design: derivative_gaussian1D
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
# source derivative_gaussian1D_script.tcl

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
set design_name derivative_gaussian1D

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
xilinx.com:ip:xlslice:1.0\
xilinx.com:ip:c_shift_ram:12.0\
xilinx.com:ip:c_addsub:12.0\
xilinx.com:ip:mult_gen:12.0\
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


# Hierarchical cell: pad_u2s_1
proc create_hier_cell_pad_u2s_1_9 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_pad_u2s_1_9() - Empty argument(s)!"}
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
  create_bd_pin -dir I -from 7 -to 0 Din
  create_bd_pin -dir O -from 8 -to 0 dout

  # Create instance: xlconcat_0, and set properties
  set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]
  set_property -dict [ list \
   CONFIG.IN0_WIDTH {8} \
   CONFIG.IN1_WIDTH {1} \
 ] $xlconcat_0

  # Create instance: xlconstant_0, and set properties
  set xlconstant_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
 ] $xlconstant_0

  # Create port connections
  connect_bd_net -net xlconcat_0_dout [get_bd_pins dout] [get_bd_pins xlconcat_0/dout]
  connect_bd_net -net xlconstant_0_dout [get_bd_pins xlconcat_0/In1] [get_bd_pins xlconstant_0/dout]
  connect_bd_net -net y0_1 [get_bd_pins Din] [get_bd_pins xlconcat_0/In0]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: pad_u2s_0
proc create_hier_cell_pad_u2s_0_9 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_pad_u2s_0_9() - Empty argument(s)!"}
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
  create_bd_pin -dir I -from 7 -to 0 Din
  create_bd_pin -dir O -from 8 -to 0 dout

  # Create instance: xlconcat_0, and set properties
  set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]
  set_property -dict [ list \
   CONFIG.IN0_WIDTH {8} \
   CONFIG.IN1_WIDTH {1} \
 ] $xlconcat_0

  # Create instance: xlconstant_0, and set properties
  set xlconstant_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
 ] $xlconstant_0

  # Create port connections
  connect_bd_net -net xlconcat_0_dout [get_bd_pins dout] [get_bd_pins xlconcat_0/dout]
  connect_bd_net -net xlconstant_0_dout [get_bd_pins xlconcat_0/In1] [get_bd_pins xlconstant_0/dout]
  connect_bd_net -net y0_1 [get_bd_pins Din] [get_bd_pins xlconcat_0/In0]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: pad_u2s_1
proc create_hier_cell_pad_u2s_1_8 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_pad_u2s_1_8() - Empty argument(s)!"}
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
  create_bd_pin -dir I -from 7 -to 0 Din
  create_bd_pin -dir O -from 8 -to 0 dout

  # Create instance: xlconcat_0, and set properties
  set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]
  set_property -dict [ list \
   CONFIG.IN0_WIDTH {8} \
   CONFIG.IN1_WIDTH {1} \
 ] $xlconcat_0

  # Create instance: xlconstant_0, and set properties
  set xlconstant_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
 ] $xlconstant_0

  # Create port connections
  connect_bd_net -net xlconcat_0_dout [get_bd_pins dout] [get_bd_pins xlconcat_0/dout]
  connect_bd_net -net xlconstant_0_dout [get_bd_pins xlconcat_0/In1] [get_bd_pins xlconstant_0/dout]
  connect_bd_net -net y0_1 [get_bd_pins Din] [get_bd_pins xlconcat_0/In0]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: pad_u2s_0
proc create_hier_cell_pad_u2s_0_8 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_pad_u2s_0_8() - Empty argument(s)!"}
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
  create_bd_pin -dir I -from 7 -to 0 Din
  create_bd_pin -dir O -from 8 -to 0 dout

  # Create instance: xlconcat_0, and set properties
  set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]
  set_property -dict [ list \
   CONFIG.IN0_WIDTH {8} \
   CONFIG.IN1_WIDTH {1} \
 ] $xlconcat_0

  # Create instance: xlconstant_0, and set properties
  set xlconstant_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
 ] $xlconstant_0

  # Create port connections
  connect_bd_net -net xlconcat_0_dout [get_bd_pins dout] [get_bd_pins xlconcat_0/dout]
  connect_bd_net -net xlconstant_0_dout [get_bd_pins xlconcat_0/In1] [get_bd_pins xlconstant_0/dout]
  connect_bd_net -net y0_1 [get_bd_pins Din] [get_bd_pins xlconcat_0/In0]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: pad_u2s_1
proc create_hier_cell_pad_u2s_1_7 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_pad_u2s_1_7() - Empty argument(s)!"}
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
  create_bd_pin -dir I -from 7 -to 0 Din
  create_bd_pin -dir O -from 8 -to 0 dout

  # Create instance: xlconcat_0, and set properties
  set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]
  set_property -dict [ list \
   CONFIG.IN0_WIDTH {8} \
   CONFIG.IN1_WIDTH {1} \
 ] $xlconcat_0

  # Create instance: xlconstant_0, and set properties
  set xlconstant_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
 ] $xlconstant_0

  # Create port connections
  connect_bd_net -net xlconcat_0_dout [get_bd_pins dout] [get_bd_pins xlconcat_0/dout]
  connect_bd_net -net xlconstant_0_dout [get_bd_pins xlconcat_0/In1] [get_bd_pins xlconstant_0/dout]
  connect_bd_net -net y0_1 [get_bd_pins Din] [get_bd_pins xlconcat_0/In0]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: pad_u2s_0
proc create_hier_cell_pad_u2s_0_7 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_pad_u2s_0_7() - Empty argument(s)!"}
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
  create_bd_pin -dir I -from 7 -to 0 Din
  create_bd_pin -dir O -from 8 -to 0 dout

  # Create instance: xlconcat_0, and set properties
  set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]
  set_property -dict [ list \
   CONFIG.IN0_WIDTH {8} \
   CONFIG.IN1_WIDTH {1} \
 ] $xlconcat_0

  # Create instance: xlconstant_0, and set properties
  set xlconstant_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
 ] $xlconstant_0

  # Create port connections
  connect_bd_net -net xlconcat_0_dout [get_bd_pins dout] [get_bd_pins xlconcat_0/dout]
  connect_bd_net -net xlconstant_0_dout [get_bd_pins xlconcat_0/In1] [get_bd_pins xlconstant_0/dout]
  connect_bd_net -net y0_1 [get_bd_pins Din] [get_bd_pins xlconcat_0/In0]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: pad_u2s_1
proc create_hier_cell_pad_u2s_1_6 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_pad_u2s_1_6() - Empty argument(s)!"}
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
  create_bd_pin -dir I -from 7 -to 0 Din
  create_bd_pin -dir O -from 8 -to 0 dout

  # Create instance: xlconcat_0, and set properties
  set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]
  set_property -dict [ list \
   CONFIG.IN0_WIDTH {8} \
   CONFIG.IN1_WIDTH {1} \
 ] $xlconcat_0

  # Create instance: xlconstant_0, and set properties
  set xlconstant_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
 ] $xlconstant_0

  # Create port connections
  connect_bd_net -net xlconcat_0_dout [get_bd_pins dout] [get_bd_pins xlconcat_0/dout]
  connect_bd_net -net xlconstant_0_dout [get_bd_pins xlconcat_0/In1] [get_bd_pins xlconstant_0/dout]
  connect_bd_net -net y0_1 [get_bd_pins Din] [get_bd_pins xlconcat_0/In0]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: pad_u2s_0
proc create_hier_cell_pad_u2s_0_6 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_pad_u2s_0_6() - Empty argument(s)!"}
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
  create_bd_pin -dir I -from 7 -to 0 Din
  create_bd_pin -dir O -from 8 -to 0 dout

  # Create instance: xlconcat_0, and set properties
  set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]
  set_property -dict [ list \
   CONFIG.IN0_WIDTH {8} \
   CONFIG.IN1_WIDTH {1} \
 ] $xlconcat_0

  # Create instance: xlconstant_0, and set properties
  set xlconstant_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
 ] $xlconstant_0

  # Create port connections
  connect_bd_net -net xlconcat_0_dout [get_bd_pins dout] [get_bd_pins xlconcat_0/dout]
  connect_bd_net -net xlconstant_0_dout [get_bd_pins xlconcat_0/In1] [get_bd_pins xlconstant_0/dout]
  connect_bd_net -net y0_1 [get_bd_pins Din] [get_bd_pins xlconcat_0/In0]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: pad_u2s_1
proc create_hier_cell_pad_u2s_1_5 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_pad_u2s_1_5() - Empty argument(s)!"}
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
  create_bd_pin -dir I -from 7 -to 0 Din
  create_bd_pin -dir O -from 8 -to 0 dout

  # Create instance: xlconcat_0, and set properties
  set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]
  set_property -dict [ list \
   CONFIG.IN0_WIDTH {8} \
   CONFIG.IN1_WIDTH {1} \
 ] $xlconcat_0

  # Create instance: xlconstant_0, and set properties
  set xlconstant_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
 ] $xlconstant_0

  # Create port connections
  connect_bd_net -net xlconcat_0_dout [get_bd_pins dout] [get_bd_pins xlconcat_0/dout]
  connect_bd_net -net xlconstant_0_dout [get_bd_pins xlconcat_0/In1] [get_bd_pins xlconstant_0/dout]
  connect_bd_net -net y0_1 [get_bd_pins Din] [get_bd_pins xlconcat_0/In0]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: pad_u2s_0
proc create_hier_cell_pad_u2s_0_5 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_pad_u2s_0_5() - Empty argument(s)!"}
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
  create_bd_pin -dir I -from 7 -to 0 Din
  create_bd_pin -dir O -from 8 -to 0 dout

  # Create instance: xlconcat_0, and set properties
  set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]
  set_property -dict [ list \
   CONFIG.IN0_WIDTH {8} \
   CONFIG.IN1_WIDTH {1} \
 ] $xlconcat_0

  # Create instance: xlconstant_0, and set properties
  set xlconstant_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
 ] $xlconstant_0

  # Create port connections
  connect_bd_net -net xlconcat_0_dout [get_bd_pins dout] [get_bd_pins xlconcat_0/dout]
  connect_bd_net -net xlconstant_0_dout [get_bd_pins xlconcat_0/In1] [get_bd_pins xlconstant_0/dout]
  connect_bd_net -net y0_1 [get_bd_pins Din] [get_bd_pins xlconcat_0/In0]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: pad_u2s_1
proc create_hier_cell_pad_u2s_1_4 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_pad_u2s_1_4() - Empty argument(s)!"}
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
  create_bd_pin -dir I -from 7 -to 0 Din
  create_bd_pin -dir O -from 8 -to 0 dout

  # Create instance: xlconcat_0, and set properties
  set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]
  set_property -dict [ list \
   CONFIG.IN0_WIDTH {8} \
   CONFIG.IN1_WIDTH {1} \
 ] $xlconcat_0

  # Create instance: xlconstant_0, and set properties
  set xlconstant_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
 ] $xlconstant_0

  # Create port connections
  connect_bd_net -net xlconcat_0_dout [get_bd_pins dout] [get_bd_pins xlconcat_0/dout]
  connect_bd_net -net xlconstant_0_dout [get_bd_pins xlconcat_0/In1] [get_bd_pins xlconstant_0/dout]
  connect_bd_net -net y0_1 [get_bd_pins Din] [get_bd_pins xlconcat_0/In0]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: pad_u2s_0
proc create_hier_cell_pad_u2s_0_4 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_pad_u2s_0_4() - Empty argument(s)!"}
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
  create_bd_pin -dir I -from 7 -to 0 Din
  create_bd_pin -dir O -from 8 -to 0 dout

  # Create instance: xlconcat_0, and set properties
  set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]
  set_property -dict [ list \
   CONFIG.IN0_WIDTH {8} \
   CONFIG.IN1_WIDTH {1} \
 ] $xlconcat_0

  # Create instance: xlconstant_0, and set properties
  set xlconstant_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
 ] $xlconstant_0

  # Create port connections
  connect_bd_net -net xlconcat_0_dout [get_bd_pins dout] [get_bd_pins xlconcat_0/dout]
  connect_bd_net -net xlconstant_0_dout [get_bd_pins xlconcat_0/In1] [get_bd_pins xlconstant_0/dout]
  connect_bd_net -net y0_1 [get_bd_pins Din] [get_bd_pins xlconcat_0/In0]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: pad_u2s_1
proc create_hier_cell_pad_u2s_1_3 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_pad_u2s_1_3() - Empty argument(s)!"}
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
  create_bd_pin -dir I -from 7 -to 0 Din
  create_bd_pin -dir O -from 8 -to 0 dout

  # Create instance: xlconcat_0, and set properties
  set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]
  set_property -dict [ list \
   CONFIG.IN0_WIDTH {8} \
   CONFIG.IN1_WIDTH {1} \
 ] $xlconcat_0

  # Create instance: xlconstant_0, and set properties
  set xlconstant_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
 ] $xlconstant_0

  # Create port connections
  connect_bd_net -net xlconcat_0_dout [get_bd_pins dout] [get_bd_pins xlconcat_0/dout]
  connect_bd_net -net xlconstant_0_dout [get_bd_pins xlconcat_0/In1] [get_bd_pins xlconstant_0/dout]
  connect_bd_net -net y0_1 [get_bd_pins Din] [get_bd_pins xlconcat_0/In0]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: pad_u2s_0
proc create_hier_cell_pad_u2s_0_3 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_pad_u2s_0_3() - Empty argument(s)!"}
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
  create_bd_pin -dir I -from 7 -to 0 Din
  create_bd_pin -dir O -from 8 -to 0 dout

  # Create instance: xlconcat_0, and set properties
  set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]
  set_property -dict [ list \
   CONFIG.IN0_WIDTH {8} \
   CONFIG.IN1_WIDTH {1} \
 ] $xlconcat_0

  # Create instance: xlconstant_0, and set properties
  set xlconstant_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
 ] $xlconstant_0

  # Create port connections
  connect_bd_net -net xlconcat_0_dout [get_bd_pins dout] [get_bd_pins xlconcat_0/dout]
  connect_bd_net -net xlconstant_0_dout [get_bd_pins xlconcat_0/In1] [get_bd_pins xlconstant_0/dout]
  connect_bd_net -net y0_1 [get_bd_pins Din] [get_bd_pins xlconcat_0/In0]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: pad_u2s_1
proc create_hier_cell_pad_u2s_1_2 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_pad_u2s_1_2() - Empty argument(s)!"}
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
  create_bd_pin -dir I -from 7 -to 0 Din
  create_bd_pin -dir O -from 8 -to 0 dout

  # Create instance: xlconcat_0, and set properties
  set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]
  set_property -dict [ list \
   CONFIG.IN0_WIDTH {8} \
   CONFIG.IN1_WIDTH {1} \
 ] $xlconcat_0

  # Create instance: xlconstant_0, and set properties
  set xlconstant_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
 ] $xlconstant_0

  # Create port connections
  connect_bd_net -net xlconcat_0_dout [get_bd_pins dout] [get_bd_pins xlconcat_0/dout]
  connect_bd_net -net xlconstant_0_dout [get_bd_pins xlconcat_0/In1] [get_bd_pins xlconstant_0/dout]
  connect_bd_net -net y0_1 [get_bd_pins Din] [get_bd_pins xlconcat_0/In0]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: pad_u2s_0
proc create_hier_cell_pad_u2s_0_2 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_pad_u2s_0_2() - Empty argument(s)!"}
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
  create_bd_pin -dir I -from 7 -to 0 Din
  create_bd_pin -dir O -from 8 -to 0 dout

  # Create instance: xlconcat_0, and set properties
  set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]
  set_property -dict [ list \
   CONFIG.IN0_WIDTH {8} \
   CONFIG.IN1_WIDTH {1} \
 ] $xlconcat_0

  # Create instance: xlconstant_0, and set properties
  set xlconstant_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
 ] $xlconstant_0

  # Create port connections
  connect_bd_net -net xlconcat_0_dout [get_bd_pins dout] [get_bd_pins xlconcat_0/dout]
  connect_bd_net -net xlconstant_0_dout [get_bd_pins xlconcat_0/In1] [get_bd_pins xlconstant_0/dout]
  connect_bd_net -net y0_1 [get_bd_pins Din] [get_bd_pins xlconcat_0/In0]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: pad_u2s_1
proc create_hier_cell_pad_u2s_1_1 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_pad_u2s_1_1() - Empty argument(s)!"}
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
  create_bd_pin -dir I -from 7 -to 0 Din
  create_bd_pin -dir O -from 8 -to 0 dout

  # Create instance: xlconcat_0, and set properties
  set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]
  set_property -dict [ list \
   CONFIG.IN0_WIDTH {8} \
   CONFIG.IN1_WIDTH {1} \
 ] $xlconcat_0

  # Create instance: xlconstant_0, and set properties
  set xlconstant_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
 ] $xlconstant_0

  # Create port connections
  connect_bd_net -net xlconcat_0_dout [get_bd_pins dout] [get_bd_pins xlconcat_0/dout]
  connect_bd_net -net xlconstant_0_dout [get_bd_pins xlconcat_0/In1] [get_bd_pins xlconstant_0/dout]
  connect_bd_net -net y0_1 [get_bd_pins Din] [get_bd_pins xlconcat_0/In0]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: pad_u2s_0
proc create_hier_cell_pad_u2s_0_1 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_pad_u2s_0_1() - Empty argument(s)!"}
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
  create_bd_pin -dir I -from 7 -to 0 Din
  create_bd_pin -dir O -from 8 -to 0 dout

  # Create instance: xlconcat_0, and set properties
  set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]
  set_property -dict [ list \
   CONFIG.IN0_WIDTH {8} \
   CONFIG.IN1_WIDTH {1} \
 ] $xlconcat_0

  # Create instance: xlconstant_0, and set properties
  set xlconstant_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
 ] $xlconstant_0

  # Create port connections
  connect_bd_net -net xlconcat_0_dout [get_bd_pins dout] [get_bd_pins xlconcat_0/dout]
  connect_bd_net -net xlconstant_0_dout [get_bd_pins xlconcat_0/In1] [get_bd_pins xlconstant_0/dout]
  connect_bd_net -net y0_1 [get_bd_pins Din] [get_bd_pins xlconcat_0/In0]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: pad_u2s_1
proc create_hier_cell_pad_u2s_1 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_pad_u2s_1() - Empty argument(s)!"}
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
  create_bd_pin -dir I -from 7 -to 0 Din
  create_bd_pin -dir O -from 8 -to 0 dout

  # Create instance: xlconcat_0, and set properties
  set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]
  set_property -dict [ list \
   CONFIG.IN0_WIDTH {8} \
   CONFIG.IN1_WIDTH {1} \
 ] $xlconcat_0

  # Create instance: xlconstant_0, and set properties
  set xlconstant_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
 ] $xlconstant_0

  # Create port connections
  connect_bd_net -net xlconcat_0_dout [get_bd_pins dout] [get_bd_pins xlconcat_0/dout]
  connect_bd_net -net xlconstant_0_dout [get_bd_pins xlconcat_0/In1] [get_bd_pins xlconstant_0/dout]
  connect_bd_net -net y0_1 [get_bd_pins Din] [get_bd_pins xlconcat_0/In0]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: pad_u2s_0
proc create_hier_cell_pad_u2s_0 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_pad_u2s_0() - Empty argument(s)!"}
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
  create_bd_pin -dir I -from 7 -to 0 Din
  create_bd_pin -dir O -from 8 -to 0 dout

  # Create instance: xlconcat_0, and set properties
  set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]
  set_property -dict [ list \
   CONFIG.IN0_WIDTH {8} \
   CONFIG.IN1_WIDTH {1} \
 ] $xlconcat_0

  # Create instance: xlconstant_0, and set properties
  set xlconstant_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
 ] $xlconstant_0

  # Create port connections
  connect_bd_net -net xlconcat_0_dout [get_bd_pins dout] [get_bd_pins xlconcat_0/dout]
  connect_bd_net -net xlconstant_0_dout [get_bd_pins xlconcat_0/In1] [get_bd_pins xlconstant_0/dout]
  connect_bd_net -net y0_1 [get_bd_pins Din] [get_bd_pins xlconcat_0/In0]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: mul_sub_5
proc create_hier_cell_mul_sub_5_1 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_mul_sub_5_1() - Empty argument(s)!"}
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
  create_bd_pin -dir O -from 15 -to 0 sub5
  create_bd_pin -dir I -from 7 -to 0 -type data y0
  create_bd_pin -dir I -from 7 -to 0 -type data y12

  # Create instance: mul0, and set properties
  set mul0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:mult_gen:12.0 mul0 ]
  set_property -dict [ list \
   CONFIG.ConstValue {93} \
   CONFIG.MultType {Constant_Coefficient_Multiplier} \
   CONFIG.OutputWidthHigh {15} \
   CONFIG.PipeStages {2} \
   CONFIG.PortAType {Signed} \
   CONFIG.PortAWidth {9} \
 ] $mul0

  # Create instance: pad_u2s_0
  create_hier_cell_pad_u2s_0_9 $hier_obj pad_u2s_0

  # Create instance: pad_u2s_1
  create_hier_cell_pad_u2s_1_9 $hier_obj pad_u2s_1

  # Create instance: sub0, and set properties
  set sub0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_addsub:12.0 sub0 ]
  set_property -dict [ list \
   CONFIG.A_Type {Signed} \
   CONFIG.A_Width {9} \
   CONFIG.Add_Mode {Subtract} \
   CONFIG.B_Type {Signed} \
   CONFIG.B_Value {000000000} \
   CONFIG.B_Width {9} \
   CONFIG.CE {false} \
   CONFIG.Implementation {Fabric} \
   CONFIG.Latency {1} \
   CONFIG.Latency_Configuration {Automatic} \
   CONFIG.Out_Width {9} \
 ] $sub0

  # Create port connections
  connect_bd_net -net CLK_1 [get_bd_pins CLK] [get_bd_pins mul0/CLK] [get_bd_pins sub0/CLK]
  connect_bd_net -net mul0_P [get_bd_pins sub5] [get_bd_pins mul0/P]
  connect_bd_net -net pad_u2s_0_dout [get_bd_pins pad_u2s_0/dout] [get_bd_pins sub0/A]
  connect_bd_net -net pad_u2s_1_dout [get_bd_pins pad_u2s_1/dout] [get_bd_pins sub0/B]
  connect_bd_net -net sub0_S [get_bd_pins mul0/A] [get_bd_pins sub0/S]
  connect_bd_net -net y0_1 [get_bd_pins y0] [get_bd_pins pad_u2s_0/Din]
  connect_bd_net -net y12_1 [get_bd_pins y12] [get_bd_pins pad_u2s_1/Din]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: mul_sub_4
proc create_hier_cell_mul_sub_4_1 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_mul_sub_4_1() - Empty argument(s)!"}
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
  create_bd_pin -dir O -from 15 -to 0 sub4
  create_bd_pin -dir I -from 7 -to 0 -type data y4
  create_bd_pin -dir I -from 7 -to 0 -type data y8

  # Create instance: mul_128, and set properties
  set mul_128 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 mul_128 ]
  set_property -dict [ list \
   CONFIG.IN0_WIDTH {7} \
   CONFIG.IN1_WIDTH {9} \
 ] $mul_128

  # Create instance: pad_0, and set properties
  set pad_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 pad_0 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
   CONFIG.CONST_WIDTH {7} \
 ] $pad_0

  # Create instance: sub_4_8, and set properties
  set sub_4_8 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_addsub:12.0 sub_4_8 ]
  set_property -dict [ list \
   CONFIG.A_Type {Unsigned} \
   CONFIG.A_Width {8} \
   CONFIG.Add_Mode {Subtract} \
   CONFIG.B_Type {Unsigned} \
   CONFIG.B_Value {00000000} \
   CONFIG.B_Width {8} \
   CONFIG.CE {false} \
   CONFIG.Implementation {Fabric} \
   CONFIG.Latency {1} \
   CONFIG.Latency_Configuration {Automatic} \
   CONFIG.Out_Width {9} \
 ] $sub_4_8

  # Create instance: tap_2_sub_4_8, and set properties
  set tap_2_sub_4_8 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 tap_2_sub_4_8 ]
  set_property -dict [ list \
   CONFIG.AsyncInitVal {000000000} \
   CONFIG.DefaultData {000000000} \
   CONFIG.Depth {2} \
   CONFIG.SyncInitVal {000000000} \
   CONFIG.Width {9} \
 ] $tap_2_sub_4_8

  # Create port connections
  connect_bd_net -net CLK_1 [get_bd_pins CLK] [get_bd_pins sub_4_8/CLK] [get_bd_pins tap_2_sub_4_8/CLK]
  connect_bd_net -net mul_128_dout [get_bd_pins sub4] [get_bd_pins mul_128/dout]
  connect_bd_net -net sub_4_8_S [get_bd_pins sub_4_8/S] [get_bd_pins tap_2_sub_4_8/D]
  connect_bd_net -net tap_2_sub_4_8_Q [get_bd_pins mul_128/In1] [get_bd_pins tap_2_sub_4_8/Q]
  connect_bd_net -net xlconstant_0_dout [get_bd_pins mul_128/In0] [get_bd_pins pad_0/dout]
  connect_bd_net -net y4_1 [get_bd_pins y4] [get_bd_pins sub_4_8/A]
  connect_bd_net -net y8_1 [get_bd_pins y8] [get_bd_pins sub_4_8/B]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: mul_sub_3
proc create_hier_cell_mul_sub_3_1 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_mul_sub_3_1() - Empty argument(s)!"}
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
  create_bd_pin -dir O -from 15 -to 0 sub3
  create_bd_pin -dir I -from 7 -to 0 -type data y0
  create_bd_pin -dir I -from 7 -to 0 -type data y12

  # Create instance: mul0, and set properties
  set mul0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:mult_gen:12.0 mul0 ]
  set_property -dict [ list \
   CONFIG.ConstValue {103} \
   CONFIG.MultType {Constant_Coefficient_Multiplier} \
   CONFIG.OutputWidthHigh {15} \
   CONFIG.PipeStages {2} \
   CONFIG.PortAType {Signed} \
   CONFIG.PortAWidth {9} \
 ] $mul0

  # Create instance: pad_u2s_0
  create_hier_cell_pad_u2s_0_8 $hier_obj pad_u2s_0

  # Create instance: pad_u2s_1
  create_hier_cell_pad_u2s_1_8 $hier_obj pad_u2s_1

  # Create instance: sub0, and set properties
  set sub0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_addsub:12.0 sub0 ]
  set_property -dict [ list \
   CONFIG.A_Type {Signed} \
   CONFIG.A_Width {9} \
   CONFIG.Add_Mode {Subtract} \
   CONFIG.B_Type {Signed} \
   CONFIG.B_Value {000000000} \
   CONFIG.B_Width {9} \
   CONFIG.CE {false} \
   CONFIG.Implementation {Fabric} \
   CONFIG.Latency {1} \
   CONFIG.Latency_Configuration {Automatic} \
   CONFIG.Out_Width {9} \
 ] $sub0

  # Create port connections
  connect_bd_net -net CLK_1 [get_bd_pins CLK] [get_bd_pins mul0/CLK] [get_bd_pins sub0/CLK]
  connect_bd_net -net mul0_P [get_bd_pins sub3] [get_bd_pins mul0/P]
  connect_bd_net -net pad_u2s_0_dout [get_bd_pins pad_u2s_0/dout] [get_bd_pins sub0/A]
  connect_bd_net -net pad_u2s_1_dout [get_bd_pins pad_u2s_1/dout] [get_bd_pins sub0/B]
  connect_bd_net -net sub0_S [get_bd_pins mul0/A] [get_bd_pins sub0/S]
  connect_bd_net -net y0_1 [get_bd_pins y0] [get_bd_pins pad_u2s_0/Din]
  connect_bd_net -net y12_1 [get_bd_pins y12] [get_bd_pins pad_u2s_1/Din]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: mul_sub_2
proc create_hier_cell_mul_sub_2_1 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_mul_sub_2_1() - Empty argument(s)!"}
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
  create_bd_pin -dir O -from 14 -to 0 sub2
  create_bd_pin -dir I -from 7 -to 0 -type data y0
  create_bd_pin -dir I -from 7 -to 0 -type data y12

  # Create instance: mul0, and set properties
  set mul0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:mult_gen:12.0 mul0 ]
  set_property -dict [ list \
   CONFIG.ConstValue {57} \
   CONFIG.MultType {Constant_Coefficient_Multiplier} \
   CONFIG.OutputWidthHigh {14} \
   CONFIG.PipeStages {2} \
   CONFIG.PortAType {Signed} \
   CONFIG.PortAWidth {9} \
 ] $mul0

  # Create instance: pad_u2s_0
  create_hier_cell_pad_u2s_0_7 $hier_obj pad_u2s_0

  # Create instance: pad_u2s_1
  create_hier_cell_pad_u2s_1_7 $hier_obj pad_u2s_1

  # Create instance: sub0, and set properties
  set sub0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_addsub:12.0 sub0 ]
  set_property -dict [ list \
   CONFIG.A_Type {Signed} \
   CONFIG.A_Width {9} \
   CONFIG.Add_Mode {Subtract} \
   CONFIG.B_Type {Signed} \
   CONFIG.B_Value {000000000} \
   CONFIG.B_Width {9} \
   CONFIG.CE {false} \
   CONFIG.Implementation {Fabric} \
   CONFIG.Latency {1} \
   CONFIG.Latency_Configuration {Automatic} \
   CONFIG.Out_Width {9} \
 ] $sub0

  # Create port connections
  connect_bd_net -net CLK_1 [get_bd_pins CLK] [get_bd_pins mul0/CLK] [get_bd_pins sub0/CLK]
  connect_bd_net -net mul0_P [get_bd_pins sub2] [get_bd_pins mul0/P]
  connect_bd_net -net pad_u2s_1_dout [get_bd_pins pad_u2s_1/dout] [get_bd_pins sub0/B]
  connect_bd_net -net sub0_S [get_bd_pins mul0/A] [get_bd_pins sub0/S]
  connect_bd_net -net xlconcat_0_dout [get_bd_pins pad_u2s_0/dout] [get_bd_pins sub0/A]
  connect_bd_net -net y0_1 [get_bd_pins y0] [get_bd_pins pad_u2s_0/Din]
  connect_bd_net -net y12_1 [get_bd_pins y12] [get_bd_pins pad_u2s_1/Din]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: mul_sub_1
proc create_hier_cell_mul_sub_1_1 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_mul_sub_1_1() - Empty argument(s)!"}
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
  create_bd_pin -dir O -from 13 -to 0 sub1
  create_bd_pin -dir I -from 7 -to 0 -type data y0
  create_bd_pin -dir I -from 7 -to 0 -type data y12

  # Create instance: mul0, and set properties
  set mul0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:mult_gen:12.0 mul0 ]
  set_property -dict [ list \
   CONFIG.ConstValue {23} \
   CONFIG.MultType {Constant_Coefficient_Multiplier} \
   CONFIG.OutputWidthHigh {13} \
   CONFIG.PipeStages {2} \
   CONFIG.PortAType {Signed} \
   CONFIG.PortAWidth {9} \
 ] $mul0

  # Create instance: pad_u2s_0
  create_hier_cell_pad_u2s_0_6 $hier_obj pad_u2s_0

  # Create instance: pad_u2s_1
  create_hier_cell_pad_u2s_1_6 $hier_obj pad_u2s_1

  # Create instance: sub0, and set properties
  set sub0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_addsub:12.0 sub0 ]
  set_property -dict [ list \
   CONFIG.A_Type {Signed} \
   CONFIG.A_Width {9} \
   CONFIG.Add_Mode {Subtract} \
   CONFIG.B_Type {Signed} \
   CONFIG.B_Value {000000000} \
   CONFIG.B_Width {9} \
   CONFIG.CE {false} \
   CONFIG.Implementation {Fabric} \
   CONFIG.Latency {1} \
   CONFIG.Latency_Configuration {Automatic} \
   CONFIG.Out_Width {9} \
 ] $sub0

  # Create port connections
  connect_bd_net -net CLK_1 [get_bd_pins CLK] [get_bd_pins mul0/CLK] [get_bd_pins sub0/CLK]
  connect_bd_net -net mul0_P [get_bd_pins sub1] [get_bd_pins mul0/P]
  connect_bd_net -net pad_u2s_0_dout [get_bd_pins pad_u2s_0/dout] [get_bd_pins sub0/A]
  connect_bd_net -net pad_u2s_1_dout [get_bd_pins pad_u2s_1/dout] [get_bd_pins sub0/B]
  connect_bd_net -net sub0_S [get_bd_pins mul0/A] [get_bd_pins sub0/S]
  connect_bd_net -net y0_1 [get_bd_pins y0] [get_bd_pins pad_u2s_0/Din]
  connect_bd_net -net y12_1 [get_bd_pins y12] [get_bd_pins pad_u2s_1/Din]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: mul_sub_0
proc create_hier_cell_mul_sub_0_1 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_mul_sub_0_1() - Empty argument(s)!"}
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
  create_bd_pin -dir O -from 11 -to 0 sub0
  create_bd_pin -dir I -from 7 -to 0 -type data y0
  create_bd_pin -dir I -from 7 -to 0 -type data y12

  # Create instance: mul0, and set properties
  set mul0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:mult_gen:12.0 mul0 ]
  set_property -dict [ list \
   CONFIG.ConstValue {7} \
   CONFIG.MultType {Constant_Coefficient_Multiplier} \
   CONFIG.OutputWidthHigh {11} \
   CONFIG.PipeStages {2} \
   CONFIG.PortAType {Signed} \
   CONFIG.PortAWidth {9} \
 ] $mul0

  # Create instance: pad_u2s_0
  create_hier_cell_pad_u2s_0_5 $hier_obj pad_u2s_0

  # Create instance: pad_u2s_1
  create_hier_cell_pad_u2s_1_5 $hier_obj pad_u2s_1

  # Create instance: sub0, and set properties
  set sub0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_addsub:12.0 sub0 ]
  set_property -dict [ list \
   CONFIG.A_Type {Signed} \
   CONFIG.A_Width {9} \
   CONFIG.Add_Mode {Subtract} \
   CONFIG.B_Type {Signed} \
   CONFIG.B_Value {000000000} \
   CONFIG.B_Width {9} \
   CONFIG.CE {false} \
   CONFIG.Implementation {Fabric} \
   CONFIG.Latency {1} \
   CONFIG.Latency_Configuration {Automatic} \
   CONFIG.Out_Width {9} \
 ] $sub0

  # Create port connections
  connect_bd_net -net CLK_1 [get_bd_pins CLK] [get_bd_pins mul0/CLK] [get_bd_pins sub0/CLK]
  connect_bd_net -net mul0_P [get_bd_pins sub0] [get_bd_pins mul0/P]
  connect_bd_net -net pad_u2s_0_dout [get_bd_pins pad_u2s_0/dout] [get_bd_pins sub0/A]
  connect_bd_net -net pad_u2s_1_dout [get_bd_pins pad_u2s_1/dout] [get_bd_pins sub0/B]
  connect_bd_net -net sub0_S [get_bd_pins mul0/A] [get_bd_pins sub0/S]
  connect_bd_net -net y0_1 [get_bd_pins y0] [get_bd_pins pad_u2s_0/Din]
  connect_bd_net -net y12_1 [get_bd_pins y12] [get_bd_pins pad_u2s_1/Din]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: mul_sub_5
proc create_hier_cell_mul_sub_5 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_mul_sub_5() - Empty argument(s)!"}
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
  create_bd_pin -dir O -from 15 -to 0 sub5
  create_bd_pin -dir I -from 7 -to 0 -type data y0
  create_bd_pin -dir I -from 7 -to 0 -type data y12

  # Create instance: mul0, and set properties
  set mul0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:mult_gen:12.0 mul0 ]
  set_property -dict [ list \
   CONFIG.ConstValue {93} \
   CONFIG.MultType {Constant_Coefficient_Multiplier} \
   CONFIG.OutputWidthHigh {15} \
   CONFIG.PipeStages {2} \
   CONFIG.PortAType {Signed} \
   CONFIG.PortAWidth {9} \
 ] $mul0

  # Create instance: pad_u2s_0
  create_hier_cell_pad_u2s_0_4 $hier_obj pad_u2s_0

  # Create instance: pad_u2s_1
  create_hier_cell_pad_u2s_1_4 $hier_obj pad_u2s_1

  # Create instance: sub0, and set properties
  set sub0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_addsub:12.0 sub0 ]
  set_property -dict [ list \
   CONFIG.A_Type {Signed} \
   CONFIG.A_Width {9} \
   CONFIG.Add_Mode {Subtract} \
   CONFIG.B_Type {Signed} \
   CONFIG.B_Value {000000000} \
   CONFIG.B_Width {9} \
   CONFIG.CE {false} \
   CONFIG.Implementation {Fabric} \
   CONFIG.Latency {1} \
   CONFIG.Latency_Configuration {Automatic} \
   CONFIG.Out_Width {9} \
 ] $sub0

  # Create port connections
  connect_bd_net -net CLK_1 [get_bd_pins CLK] [get_bd_pins mul0/CLK] [get_bd_pins sub0/CLK]
  connect_bd_net -net mul0_P [get_bd_pins sub5] [get_bd_pins mul0/P]
  connect_bd_net -net pad_u2s_0_dout [get_bd_pins pad_u2s_0/dout] [get_bd_pins sub0/A]
  connect_bd_net -net pad_u2s_1_dout [get_bd_pins pad_u2s_1/dout] [get_bd_pins sub0/B]
  connect_bd_net -net sub0_S [get_bd_pins mul0/A] [get_bd_pins sub0/S]
  connect_bd_net -net y0_1 [get_bd_pins y0] [get_bd_pins pad_u2s_0/Din]
  connect_bd_net -net y12_1 [get_bd_pins y12] [get_bd_pins pad_u2s_1/Din]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: mul_sub_4
proc create_hier_cell_mul_sub_4 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_mul_sub_4() - Empty argument(s)!"}
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
  create_bd_pin -dir O -from 15 -to 0 sub4
  create_bd_pin -dir I -from 7 -to 0 -type data y4
  create_bd_pin -dir I -from 7 -to 0 -type data y8

  # Create instance: mul_128, and set properties
  set mul_128 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 mul_128 ]
  set_property -dict [ list \
   CONFIG.IN0_WIDTH {7} \
   CONFIG.IN1_WIDTH {9} \
 ] $mul_128

  # Create instance: pad_0, and set properties
  set pad_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 pad_0 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
   CONFIG.CONST_WIDTH {7} \
 ] $pad_0

  # Create instance: sub_4_8, and set properties
  set sub_4_8 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_addsub:12.0 sub_4_8 ]
  set_property -dict [ list \
   CONFIG.A_Type {Unsigned} \
   CONFIG.A_Width {8} \
   CONFIG.Add_Mode {Subtract} \
   CONFIG.B_Type {Unsigned} \
   CONFIG.B_Value {00000000} \
   CONFIG.B_Width {8} \
   CONFIG.CE {false} \
   CONFIG.Implementation {Fabric} \
   CONFIG.Latency {1} \
   CONFIG.Latency_Configuration {Automatic} \
   CONFIG.Out_Width {9} \
 ] $sub_4_8

  # Create instance: tap_2_sub_4_8, and set properties
  set tap_2_sub_4_8 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 tap_2_sub_4_8 ]
  set_property -dict [ list \
   CONFIG.AsyncInitVal {000000000} \
   CONFIG.DefaultData {000000000} \
   CONFIG.Depth {2} \
   CONFIG.SyncInitVal {000000000} \
   CONFIG.Width {9} \
 ] $tap_2_sub_4_8

  # Create port connections
  connect_bd_net -net CLK_1 [get_bd_pins CLK] [get_bd_pins sub_4_8/CLK] [get_bd_pins tap_2_sub_4_8/CLK]
  connect_bd_net -net mul_128_dout [get_bd_pins sub4] [get_bd_pins mul_128/dout]
  connect_bd_net -net sub_4_8_S [get_bd_pins sub_4_8/S] [get_bd_pins tap_2_sub_4_8/D]
  connect_bd_net -net tap_2_sub_4_8_Q [get_bd_pins mul_128/In1] [get_bd_pins tap_2_sub_4_8/Q]
  connect_bd_net -net xlconstant_0_dout [get_bd_pins mul_128/In0] [get_bd_pins pad_0/dout]
  connect_bd_net -net y4_1 [get_bd_pins y4] [get_bd_pins sub_4_8/A]
  connect_bd_net -net y8_1 [get_bd_pins y8] [get_bd_pins sub_4_8/B]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: mul_sub_3
proc create_hier_cell_mul_sub_3 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_mul_sub_3() - Empty argument(s)!"}
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
  create_bd_pin -dir O -from 15 -to 0 sub3
  create_bd_pin -dir I -from 7 -to 0 -type data y0
  create_bd_pin -dir I -from 7 -to 0 -type data y12

  # Create instance: mul0, and set properties
  set mul0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:mult_gen:12.0 mul0 ]
  set_property -dict [ list \
   CONFIG.ConstValue {103} \
   CONFIG.MultType {Constant_Coefficient_Multiplier} \
   CONFIG.OutputWidthHigh {15} \
   CONFIG.PipeStages {2} \
   CONFIG.PortAType {Signed} \
   CONFIG.PortAWidth {9} \
 ] $mul0

  # Create instance: pad_u2s_0
  create_hier_cell_pad_u2s_0_3 $hier_obj pad_u2s_0

  # Create instance: pad_u2s_1
  create_hier_cell_pad_u2s_1_3 $hier_obj pad_u2s_1

  # Create instance: sub0, and set properties
  set sub0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_addsub:12.0 sub0 ]
  set_property -dict [ list \
   CONFIG.A_Type {Signed} \
   CONFIG.A_Width {9} \
   CONFIG.Add_Mode {Subtract} \
   CONFIG.B_Type {Signed} \
   CONFIG.B_Value {000000000} \
   CONFIG.B_Width {9} \
   CONFIG.CE {false} \
   CONFIG.Implementation {Fabric} \
   CONFIG.Latency {1} \
   CONFIG.Latency_Configuration {Automatic} \
   CONFIG.Out_Width {9} \
 ] $sub0

  # Create port connections
  connect_bd_net -net CLK_1 [get_bd_pins CLK] [get_bd_pins mul0/CLK] [get_bd_pins sub0/CLK]
  connect_bd_net -net mul0_P [get_bd_pins sub3] [get_bd_pins mul0/P]
  connect_bd_net -net pad_u2s_0_dout [get_bd_pins pad_u2s_0/dout] [get_bd_pins sub0/A]
  connect_bd_net -net pad_u2s_1_dout [get_bd_pins pad_u2s_1/dout] [get_bd_pins sub0/B]
  connect_bd_net -net sub0_S [get_bd_pins mul0/A] [get_bd_pins sub0/S]
  connect_bd_net -net y0_1 [get_bd_pins y0] [get_bd_pins pad_u2s_0/Din]
  connect_bd_net -net y12_1 [get_bd_pins y12] [get_bd_pins pad_u2s_1/Din]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: mul_sub_2
proc create_hier_cell_mul_sub_2 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_mul_sub_2() - Empty argument(s)!"}
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
  create_bd_pin -dir O -from 14 -to 0 sub2
  create_bd_pin -dir I -from 7 -to 0 -type data y0
  create_bd_pin -dir I -from 7 -to 0 -type data y12

  # Create instance: mul0, and set properties
  set mul0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:mult_gen:12.0 mul0 ]
  set_property -dict [ list \
   CONFIG.ConstValue {57} \
   CONFIG.MultType {Constant_Coefficient_Multiplier} \
   CONFIG.OutputWidthHigh {14} \
   CONFIG.PipeStages {2} \
   CONFIG.PortAType {Signed} \
   CONFIG.PortAWidth {9} \
 ] $mul0

  # Create instance: pad_u2s_0
  create_hier_cell_pad_u2s_0_2 $hier_obj pad_u2s_0

  # Create instance: pad_u2s_1
  create_hier_cell_pad_u2s_1_2 $hier_obj pad_u2s_1

  # Create instance: sub0, and set properties
  set sub0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_addsub:12.0 sub0 ]
  set_property -dict [ list \
   CONFIG.A_Type {Signed} \
   CONFIG.A_Width {9} \
   CONFIG.Add_Mode {Subtract} \
   CONFIG.B_Type {Signed} \
   CONFIG.B_Value {000000000} \
   CONFIG.B_Width {9} \
   CONFIG.CE {false} \
   CONFIG.Implementation {Fabric} \
   CONFIG.Latency {1} \
   CONFIG.Latency_Configuration {Automatic} \
   CONFIG.Out_Width {9} \
 ] $sub0

  # Create port connections
  connect_bd_net -net CLK_1 [get_bd_pins CLK] [get_bd_pins mul0/CLK] [get_bd_pins sub0/CLK]
  connect_bd_net -net mul0_P [get_bd_pins sub2] [get_bd_pins mul0/P]
  connect_bd_net -net pad_u2s_1_dout [get_bd_pins pad_u2s_1/dout] [get_bd_pins sub0/B]
  connect_bd_net -net sub0_S [get_bd_pins mul0/A] [get_bd_pins sub0/S]
  connect_bd_net -net xlconcat_0_dout [get_bd_pins pad_u2s_0/dout] [get_bd_pins sub0/A]
  connect_bd_net -net y0_1 [get_bd_pins y0] [get_bd_pins pad_u2s_0/Din]
  connect_bd_net -net y12_1 [get_bd_pins y12] [get_bd_pins pad_u2s_1/Din]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: mul_sub_1
proc create_hier_cell_mul_sub_1 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_mul_sub_1() - Empty argument(s)!"}
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
  create_bd_pin -dir O -from 13 -to 0 sub1
  create_bd_pin -dir I -from 7 -to 0 -type data y0
  create_bd_pin -dir I -from 7 -to 0 -type data y12

  # Create instance: mul0, and set properties
  set mul0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:mult_gen:12.0 mul0 ]
  set_property -dict [ list \
   CONFIG.ConstValue {23} \
   CONFIG.MultType {Constant_Coefficient_Multiplier} \
   CONFIG.OutputWidthHigh {13} \
   CONFIG.PipeStages {2} \
   CONFIG.PortAType {Signed} \
   CONFIG.PortAWidth {9} \
 ] $mul0

  # Create instance: pad_u2s_0
  create_hier_cell_pad_u2s_0_1 $hier_obj pad_u2s_0

  # Create instance: pad_u2s_1
  create_hier_cell_pad_u2s_1_1 $hier_obj pad_u2s_1

  # Create instance: sub0, and set properties
  set sub0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_addsub:12.0 sub0 ]
  set_property -dict [ list \
   CONFIG.A_Type {Signed} \
   CONFIG.A_Width {9} \
   CONFIG.Add_Mode {Subtract} \
   CONFIG.B_Type {Signed} \
   CONFIG.B_Value {000000000} \
   CONFIG.B_Width {9} \
   CONFIG.CE {false} \
   CONFIG.Implementation {Fabric} \
   CONFIG.Latency {1} \
   CONFIG.Latency_Configuration {Automatic} \
   CONFIG.Out_Width {9} \
 ] $sub0

  # Create port connections
  connect_bd_net -net CLK_1 [get_bd_pins CLK] [get_bd_pins mul0/CLK] [get_bd_pins sub0/CLK]
  connect_bd_net -net mul0_P [get_bd_pins sub1] [get_bd_pins mul0/P]
  connect_bd_net -net pad_u2s_0_dout [get_bd_pins pad_u2s_0/dout] [get_bd_pins sub0/A]
  connect_bd_net -net pad_u2s_1_dout [get_bd_pins pad_u2s_1/dout] [get_bd_pins sub0/B]
  connect_bd_net -net sub0_S [get_bd_pins mul0/A] [get_bd_pins sub0/S]
  connect_bd_net -net y0_1 [get_bd_pins y0] [get_bd_pins pad_u2s_0/Din]
  connect_bd_net -net y12_1 [get_bd_pins y12] [get_bd_pins pad_u2s_1/Din]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: mul_sub_0
proc create_hier_cell_mul_sub_0 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_mul_sub_0() - Empty argument(s)!"}
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
  create_bd_pin -dir O -from 11 -to 0 sub0
  create_bd_pin -dir I -from 7 -to 0 -type data y0
  create_bd_pin -dir I -from 7 -to 0 -type data y12

  # Create instance: mul0, and set properties
  set mul0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:mult_gen:12.0 mul0 ]
  set_property -dict [ list \
   CONFIG.ConstValue {7} \
   CONFIG.MultType {Constant_Coefficient_Multiplier} \
   CONFIG.OutputWidthHigh {11} \
   CONFIG.PipeStages {2} \
   CONFIG.PortAType {Signed} \
   CONFIG.PortAWidth {9} \
 ] $mul0

  # Create instance: pad_u2s_0
  create_hier_cell_pad_u2s_0 $hier_obj pad_u2s_0

  # Create instance: pad_u2s_1
  create_hier_cell_pad_u2s_1 $hier_obj pad_u2s_1

  # Create instance: sub0, and set properties
  set sub0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_addsub:12.0 sub0 ]
  set_property -dict [ list \
   CONFIG.A_Type {Signed} \
   CONFIG.A_Width {9} \
   CONFIG.Add_Mode {Subtract} \
   CONFIG.B_Type {Signed} \
   CONFIG.B_Value {000000000} \
   CONFIG.B_Width {9} \
   CONFIG.CE {false} \
   CONFIG.Implementation {Fabric} \
   CONFIG.Latency {1} \
   CONFIG.Latency_Configuration {Automatic} \
   CONFIG.Out_Width {9} \
 ] $sub0

  # Create port connections
  connect_bd_net -net CLK_1 [get_bd_pins CLK] [get_bd_pins mul0/CLK] [get_bd_pins sub0/CLK]
  connect_bd_net -net mul0_P [get_bd_pins sub0] [get_bd_pins mul0/P]
  connect_bd_net -net pad_u2s_0_dout [get_bd_pins pad_u2s_0/dout] [get_bd_pins sub0/A]
  connect_bd_net -net pad_u2s_1_dout [get_bd_pins pad_u2s_1/dout] [get_bd_pins sub0/B]
  connect_bd_net -net sub0_S [get_bd_pins mul0/A] [get_bd_pins sub0/S]
  connect_bd_net -net y0_1 [get_bd_pins y0] [get_bd_pins pad_u2s_0/Din]
  connect_bd_net -net y12_1 [get_bd_pins y12] [get_bd_pins pad_u2s_1/Din]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: slice6
proc create_hier_cell_slice6 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_slice6() - Empty argument(s)!"}
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
  create_bd_pin -dir I -from 15 -to 0 Din
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
  connect_bd_net -net Din_1 [get_bd_pins Din] [get_bd_pins xlslice_0/Din] [get_bd_pins xlslice_1/Din]
  connect_bd_net -net xlslice_0_Dout [get_bd_pins lsb] [get_bd_pins xlslice_0/Dout]
  connect_bd_net -net xlslice_1_Dout [get_bd_pins msb] [get_bd_pins xlslice_1/Dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: slice5
proc create_hier_cell_slice5 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_slice5() - Empty argument(s)!"}
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
  create_bd_pin -dir I -from 15 -to 0 Din
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
  connect_bd_net -net Din_1 [get_bd_pins Din] [get_bd_pins xlslice_0/Din] [get_bd_pins xlslice_1/Din]
  connect_bd_net -net xlslice_0_Dout [get_bd_pins lsb] [get_bd_pins xlslice_0/Dout]
  connect_bd_net -net xlslice_1_Dout [get_bd_pins msb] [get_bd_pins xlslice_1/Dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: slice4
proc create_hier_cell_slice4 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_slice4() - Empty argument(s)!"}
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
  create_bd_pin -dir I -from 15 -to 0 Din
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
  connect_bd_net -net Din_1 [get_bd_pins Din] [get_bd_pins xlslice_0/Din] [get_bd_pins xlslice_1/Din]
  connect_bd_net -net xlslice_0_Dout [get_bd_pins lsb] [get_bd_pins xlslice_0/Dout]
  connect_bd_net -net xlslice_1_Dout [get_bd_pins msb] [get_bd_pins xlslice_1/Dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: slice3
proc create_hier_cell_slice3 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_slice3() - Empty argument(s)!"}
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
  create_bd_pin -dir I -from 15 -to 0 Din
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
  connect_bd_net -net Din_1 [get_bd_pins Din] [get_bd_pins xlslice_0/Din] [get_bd_pins xlslice_1/Din]
  connect_bd_net -net xlslice_0_Dout [get_bd_pins lsb] [get_bd_pins xlslice_0/Dout]
  connect_bd_net -net xlslice_1_Dout [get_bd_pins msb] [get_bd_pins xlslice_1/Dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: slice2
proc create_hier_cell_slice2 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_slice2() - Empty argument(s)!"}
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
  create_bd_pin -dir I -from 15 -to 0 Din
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
  connect_bd_net -net Din_1 [get_bd_pins Din] [get_bd_pins xlslice_0/Din] [get_bd_pins xlslice_1/Din]
  connect_bd_net -net xlslice_0_Dout [get_bd_pins lsb] [get_bd_pins xlslice_0/Dout]
  connect_bd_net -net xlslice_1_Dout [get_bd_pins msb] [get_bd_pins xlslice_1/Dout]

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
  create_bd_pin -dir I -from 15 -to 0 Din
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
  connect_bd_net -net Din_1 [get_bd_pins Din] [get_bd_pins xlslice_0/Din] [get_bd_pins xlslice_1/Din]
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
  create_bd_pin -dir I -from 15 -to 0 Din
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
  connect_bd_net -net Din_1 [get_bd_pins Din] [get_bd_pins xlslice_0/Din] [get_bd_pins xlslice_1/Din]
  connect_bd_net -net xlslice_0_Dout [get_bd_pins lsb] [get_bd_pins xlslice_0/Dout]
  connect_bd_net -net xlslice_1_Dout [get_bd_pins msb] [get_bd_pins xlslice_1/Dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: stage4_2
proc create_hier_cell_stage4_2_1 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_stage4_2_1() - Empty argument(s)!"}
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
  create_bd_pin -dir O -from 17 -to 0 sum
  create_bd_pin -dir I -from 14 -to 0 -type data sum1
  create_bd_pin -dir I -from 17 -to 0 -type data sum23

  # Create instance: c_addsub_4, and set properties
  set c_addsub_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_addsub:12.0 c_addsub_4 ]
  set_property -dict [ list \
   CONFIG.A_Type {Signed} \
   CONFIG.A_Width {15} \
   CONFIG.B_Type {Signed} \
   CONFIG.B_Value {000000000000000000} \
   CONFIG.B_Width {18} \
   CONFIG.CE {false} \
   CONFIG.Latency {2} \
   CONFIG.Latency_Configuration {Automatic} \
   CONFIG.Out_Width {18} \
 ] $c_addsub_4

  # Create port connections
  connect_bd_net -net CLK_1 [get_bd_pins CLK] [get_bd_pins c_addsub_4/CLK]
  connect_bd_net -net c_addsub_3_S [get_bd_pins sum23] [get_bd_pins c_addsub_4/B]
  connect_bd_net -net c_addsub_4_S [get_bd_pins sum] [get_bd_pins c_addsub_4/S]
  connect_bd_net -net tap_2_0_Q [get_bd_pins sum1] [get_bd_pins c_addsub_4/A]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: stage3_2
proc create_hier_cell_stage3_2_1 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_stage3_2_1() - Empty argument(s)!"}
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
  create_bd_pin -dir I -from 14 -to 0 -type data sum1
  create_bd_pin -dir O -from 14 -to 0 -type data sum1_d
  create_bd_pin -dir I -from 16 -to 0 -type data sum2
  create_bd_pin -dir I -from 16 -to 0 -type data sum3
  create_bd_pin -dir O -from 17 -to 0 -type data sum23

  # Create instance: c_addsub_3, and set properties
  set c_addsub_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_addsub:12.0 c_addsub_3 ]
  set_property -dict [ list \
   CONFIG.A_Type {Signed} \
   CONFIG.A_Width {17} \
   CONFIG.B_Type {Signed} \
   CONFIG.B_Value {00000000000000000} \
   CONFIG.B_Width {17} \
   CONFIG.CE {false} \
   CONFIG.Latency {2} \
   CONFIG.Latency_Configuration {Automatic} \
   CONFIG.Out_Width {18} \
 ] $c_addsub_3

  # Create instance: tap_2_0, and set properties
  set tap_2_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 tap_2_0 ]
  set_property -dict [ list \
   CONFIG.AsyncInitVal {000000000000000} \
   CONFIG.DefaultData {000000000000000} \
   CONFIG.Depth {2} \
   CONFIG.SyncInitVal {000000000000000} \
   CONFIG.Width {15} \
 ] $tap_2_0

  # Create port connections
  connect_bd_net -net CLK_1 [get_bd_pins CLK] [get_bd_pins c_addsub_3/CLK] [get_bd_pins tap_2_0/CLK]
  connect_bd_net -net c_addsub_0_S [get_bd_pins sum1] [get_bd_pins tap_2_0/D]
  connect_bd_net -net c_addsub_1_S [get_bd_pins sum2] [get_bd_pins c_addsub_3/A]
  connect_bd_net -net c_addsub_2_S [get_bd_pins sum3] [get_bd_pins c_addsub_3/B]
  connect_bd_net -net c_addsub_3_S [get_bd_pins sum23] [get_bd_pins c_addsub_3/S]
  connect_bd_net -net tap_2_0_Q [get_bd_pins sum1_d] [get_bd_pins tap_2_0/Q]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: stage2_2
proc create_hier_cell_stage2_2_1 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_stage2_2_1() - Empty argument(s)!"}
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
  create_bd_pin -dir I -from 11 -to 0 -type data sub0
  create_bd_pin -dir I -from 13 -to 0 -type data sub1
  create_bd_pin -dir I -from 14 -to 0 -type data sub2
  create_bd_pin -dir I -from 15 -to 0 -type data sub3
  create_bd_pin -dir I -from 15 -to 0 -type data sub4
  create_bd_pin -dir I -from 15 -to 0 -type data sub5
  create_bd_pin -dir O -from 14 -to 0 -type data sum1
  create_bd_pin -dir O -from 16 -to 0 -type data sum2
  create_bd_pin -dir O -from 16 -to 0 -type data sum3

  # Create instance: c_addsub_0, and set properties
  set c_addsub_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_addsub:12.0 c_addsub_0 ]
  set_property -dict [ list \
   CONFIG.A_Type {Signed} \
   CONFIG.A_Width {12} \
   CONFIG.B_Type {Signed} \
   CONFIG.B_Value {00000000000000} \
   CONFIG.B_Width {14} \
   CONFIG.CE {false} \
   CONFIG.Latency {2} \
   CONFIG.Latency_Configuration {Automatic} \
   CONFIG.Out_Width {15} \
 ] $c_addsub_0

  # Create instance: c_addsub_1, and set properties
  set c_addsub_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_addsub:12.0 c_addsub_1 ]
  set_property -dict [ list \
   CONFIG.A_Type {Signed} \
   CONFIG.A_Width {15} \
   CONFIG.B_Type {Signed} \
   CONFIG.B_Value {0000000000000000} \
   CONFIG.B_Width {16} \
   CONFIG.CE {false} \
   CONFIG.Latency {2} \
   CONFIG.Latency_Configuration {Automatic} \
   CONFIG.Out_Width {17} \
 ] $c_addsub_1

  # Create instance: c_addsub_2, and set properties
  set c_addsub_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_addsub:12.0 c_addsub_2 ]
  set_property -dict [ list \
   CONFIG.A_Type {Signed} \
   CONFIG.A_Width {16} \
   CONFIG.B_Type {Signed} \
   CONFIG.B_Value {0000000000000000} \
   CONFIG.B_Width {16} \
   CONFIG.CE {false} \
   CONFIG.Latency {2} \
   CONFIG.Latency_Configuration {Automatic} \
   CONFIG.Out_Width {17} \
 ] $c_addsub_2

  # Create port connections
  connect_bd_net -net CLK_1 [get_bd_pins CLK] [get_bd_pins c_addsub_0/CLK] [get_bd_pins c_addsub_1/CLK] [get_bd_pins c_addsub_2/CLK]
  connect_bd_net -net c_addsub_0_S [get_bd_pins sum1] [get_bd_pins c_addsub_0/S]
  connect_bd_net -net c_addsub_1_S [get_bd_pins sum2] [get_bd_pins c_addsub_1/S]
  connect_bd_net -net c_addsub_2_S [get_bd_pins sum3] [get_bd_pins c_addsub_2/S]
  connect_bd_net -net mul_sub0 [get_bd_pins sub0] [get_bd_pins c_addsub_0/A]
  connect_bd_net -net mul_sub1 [get_bd_pins sub1] [get_bd_pins c_addsub_0/B]
  connect_bd_net -net mul_sub2 [get_bd_pins sub2] [get_bd_pins c_addsub_1/A]
  connect_bd_net -net mul_sub3 [get_bd_pins sub3] [get_bd_pins c_addsub_1/B]
  connect_bd_net -net mul_sub4 [get_bd_pins sub5] [get_bd_pins c_addsub_2/B]
  connect_bd_net -net mul_sub5 [get_bd_pins sub4] [get_bd_pins c_addsub_2/A]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: stage1_3
proc create_hier_cell_stage1_3_1 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_stage1_3_1() - Empty argument(s)!"}
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
  create_bd_pin -dir O -from 11 -to 0 sub0
  create_bd_pin -dir O -from 13 -to 0 sub1
  create_bd_pin -dir O -from 14 -to 0 sub2
  create_bd_pin -dir O -from 15 -to 0 sub3
  create_bd_pin -dir O -from 15 -to 0 sub4
  create_bd_pin -dir O -from 15 -to 0 sub5
  create_bd_pin -dir I -from 7 -to 0 y0
  create_bd_pin -dir I -from 7 -to 0 y1
  create_bd_pin -dir I -from 7 -to 0 y2
  create_bd_pin -dir I -from 7 -to 0 y3
  create_bd_pin -dir I -from 7 -to 0 y4
  create_bd_pin -dir I -from 7 -to 0 y5
  create_bd_pin -dir I -from 7 -to 0 y6
  create_bd_pin -dir I -from 7 -to 0 y7
  create_bd_pin -dir I -from 7 -to 0 y8
  create_bd_pin -dir I -from 7 -to 0 y9
  create_bd_pin -dir I -from 7 -to 0 y10
  create_bd_pin -dir I -from 7 -to 0 y11
  create_bd_pin -dir I -from 7 -to 0 y12

  # Create instance: mul_sub_0
  create_hier_cell_mul_sub_0_1 $hier_obj mul_sub_0

  # Create instance: mul_sub_1
  create_hier_cell_mul_sub_1_1 $hier_obj mul_sub_1

  # Create instance: mul_sub_2
  create_hier_cell_mul_sub_2_1 $hier_obj mul_sub_2

  # Create instance: mul_sub_3
  create_hier_cell_mul_sub_3_1 $hier_obj mul_sub_3

  # Create instance: mul_sub_4
  create_hier_cell_mul_sub_4_1 $hier_obj mul_sub_4

  # Create instance: mul_sub_5
  create_hier_cell_mul_sub_5_1 $hier_obj mul_sub_5

  # Create port connections
  connect_bd_net -net CLK_1 [get_bd_pins CLK] [get_bd_pins mul_sub_0/CLK] [get_bd_pins mul_sub_1/CLK] [get_bd_pins mul_sub_2/CLK] [get_bd_pins mul_sub_3/CLK] [get_bd_pins mul_sub_4/CLK] [get_bd_pins mul_sub_5/CLK]
  connect_bd_net -net mul_sub_0_sub0 [get_bd_pins sub0] [get_bd_pins mul_sub_0/sub0]
  connect_bd_net -net mul_sub_1_sub1 [get_bd_pins sub1] [get_bd_pins mul_sub_1/sub1]
  connect_bd_net -net mul_sub_2_sub2 [get_bd_pins sub2] [get_bd_pins mul_sub_2/sub2]
  connect_bd_net -net mul_sub_3_sub3 [get_bd_pins sub3] [get_bd_pins mul_sub_3/sub3]
  connect_bd_net -net mul_sub_4_sub4 [get_bd_pins sub4] [get_bd_pins mul_sub_4/sub4]
  connect_bd_net -net mul_sub_5_sub5 [get_bd_pins sub5] [get_bd_pins mul_sub_5/sub5]
  connect_bd_net -net y0_1 [get_bd_pins y0] [get_bd_pins mul_sub_0/y0]
  connect_bd_net -net y10_1 [get_bd_pins y10] [get_bd_pins mul_sub_2/y12]
  connect_bd_net -net y11_1 [get_bd_pins y11] [get_bd_pins mul_sub_1/y12]
  connect_bd_net -net y12_1 [get_bd_pins y12] [get_bd_pins mul_sub_0/y12]
  connect_bd_net -net y1_1 [get_bd_pins y1] [get_bd_pins mul_sub_1/y0]
  connect_bd_net -net y2_1 [get_bd_pins y2] [get_bd_pins mul_sub_2/y0]
  connect_bd_net -net y3_1 [get_bd_pins y3] [get_bd_pins mul_sub_3/y0]
  connect_bd_net -net y4_1 [get_bd_pins y4] [get_bd_pins mul_sub_4/y4]
  connect_bd_net -net y5_1 [get_bd_pins y5] [get_bd_pins mul_sub_5/y0]
  connect_bd_net -net y7_1 [get_bd_pins y7] [get_bd_pins mul_sub_5/y12]
  connect_bd_net -net y8_1 [get_bd_pins y8] [get_bd_pins mul_sub_4/y8]
  connect_bd_net -net y9_1 [get_bd_pins y9] [get_bd_pins mul_sub_3/y12]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: stage4_2
proc create_hier_cell_stage4_2 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_stage4_2() - Empty argument(s)!"}
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
  create_bd_pin -dir O -from 17 -to 0 sum
  create_bd_pin -dir I -from 14 -to 0 -type data sum1
  create_bd_pin -dir I -from 17 -to 0 -type data sum23

  # Create instance: c_addsub_4, and set properties
  set c_addsub_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_addsub:12.0 c_addsub_4 ]
  set_property -dict [ list \
   CONFIG.A_Type {Signed} \
   CONFIG.A_Width {15} \
   CONFIG.B_Type {Signed} \
   CONFIG.B_Value {000000000000000000} \
   CONFIG.B_Width {18} \
   CONFIG.CE {false} \
   CONFIG.Latency {2} \
   CONFIG.Latency_Configuration {Automatic} \
   CONFIG.Out_Width {18} \
 ] $c_addsub_4

  # Create port connections
  connect_bd_net -net CLK_1 [get_bd_pins CLK] [get_bd_pins c_addsub_4/CLK]
  connect_bd_net -net c_addsub_3_S [get_bd_pins sum23] [get_bd_pins c_addsub_4/B]
  connect_bd_net -net c_addsub_4_S [get_bd_pins sum] [get_bd_pins c_addsub_4/S]
  connect_bd_net -net tap_2_0_Q [get_bd_pins sum1] [get_bd_pins c_addsub_4/A]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: stage3_2
proc create_hier_cell_stage3_2 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_stage3_2() - Empty argument(s)!"}
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
  create_bd_pin -dir I -from 14 -to 0 -type data sum1
  create_bd_pin -dir O -from 14 -to 0 -type data sum1_d
  create_bd_pin -dir I -from 16 -to 0 -type data sum2
  create_bd_pin -dir I -from 16 -to 0 -type data sum3
  create_bd_pin -dir O -from 17 -to 0 -type data sum23

  # Create instance: c_addsub_3, and set properties
  set c_addsub_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_addsub:12.0 c_addsub_3 ]
  set_property -dict [ list \
   CONFIG.A_Type {Signed} \
   CONFIG.A_Width {17} \
   CONFIG.B_Type {Signed} \
   CONFIG.B_Value {00000000000000000} \
   CONFIG.B_Width {17} \
   CONFIG.CE {false} \
   CONFIG.Latency {2} \
   CONFIG.Latency_Configuration {Automatic} \
   CONFIG.Out_Width {18} \
 ] $c_addsub_3

  # Create instance: tap_2_0, and set properties
  set tap_2_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 tap_2_0 ]
  set_property -dict [ list \
   CONFIG.AsyncInitVal {000000000000000} \
   CONFIG.DefaultData {000000000000000} \
   CONFIG.Depth {2} \
   CONFIG.SyncInitVal {000000000000000} \
   CONFIG.Width {15} \
 ] $tap_2_0

  # Create port connections
  connect_bd_net -net CLK_1 [get_bd_pins CLK] [get_bd_pins c_addsub_3/CLK] [get_bd_pins tap_2_0/CLK]
  connect_bd_net -net c_addsub_0_S [get_bd_pins sum1] [get_bd_pins tap_2_0/D]
  connect_bd_net -net c_addsub_1_S [get_bd_pins sum2] [get_bd_pins c_addsub_3/A]
  connect_bd_net -net c_addsub_2_S [get_bd_pins sum3] [get_bd_pins c_addsub_3/B]
  connect_bd_net -net c_addsub_3_S [get_bd_pins sum23] [get_bd_pins c_addsub_3/S]
  connect_bd_net -net tap_2_0_Q [get_bd_pins sum1_d] [get_bd_pins tap_2_0/Q]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: stage2_2
proc create_hier_cell_stage2_2 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_stage2_2() - Empty argument(s)!"}
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
  create_bd_pin -dir I -from 11 -to 0 -type data sub0
  create_bd_pin -dir I -from 13 -to 0 -type data sub1
  create_bd_pin -dir I -from 14 -to 0 -type data sub2
  create_bd_pin -dir I -from 15 -to 0 -type data sub3
  create_bd_pin -dir I -from 15 -to 0 -type data sub4
  create_bd_pin -dir I -from 15 -to 0 -type data sub5
  create_bd_pin -dir O -from 14 -to 0 -type data sum1
  create_bd_pin -dir O -from 16 -to 0 -type data sum2
  create_bd_pin -dir O -from 16 -to 0 -type data sum3

  # Create instance: c_addsub_0, and set properties
  set c_addsub_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_addsub:12.0 c_addsub_0 ]
  set_property -dict [ list \
   CONFIG.A_Type {Signed} \
   CONFIG.A_Width {12} \
   CONFIG.B_Type {Signed} \
   CONFIG.B_Value {00000000000000} \
   CONFIG.B_Width {14} \
   CONFIG.CE {false} \
   CONFIG.Latency {2} \
   CONFIG.Latency_Configuration {Automatic} \
   CONFIG.Out_Width {15} \
 ] $c_addsub_0

  # Create instance: c_addsub_1, and set properties
  set c_addsub_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_addsub:12.0 c_addsub_1 ]
  set_property -dict [ list \
   CONFIG.A_Type {Signed} \
   CONFIG.A_Width {15} \
   CONFIG.B_Type {Signed} \
   CONFIG.B_Value {0000000000000000} \
   CONFIG.B_Width {16} \
   CONFIG.CE {false} \
   CONFIG.Latency {2} \
   CONFIG.Latency_Configuration {Automatic} \
   CONFIG.Out_Width {17} \
 ] $c_addsub_1

  # Create instance: c_addsub_2, and set properties
  set c_addsub_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_addsub:12.0 c_addsub_2 ]
  set_property -dict [ list \
   CONFIG.A_Type {Signed} \
   CONFIG.A_Width {16} \
   CONFIG.B_Type {Signed} \
   CONFIG.B_Value {0000000000000000} \
   CONFIG.B_Width {16} \
   CONFIG.CE {false} \
   CONFIG.Latency {2} \
   CONFIG.Latency_Configuration {Automatic} \
   CONFIG.Out_Width {17} \
 ] $c_addsub_2

  # Create port connections
  connect_bd_net -net CLK_1 [get_bd_pins CLK] [get_bd_pins c_addsub_0/CLK] [get_bd_pins c_addsub_1/CLK] [get_bd_pins c_addsub_2/CLK]
  connect_bd_net -net c_addsub_0_S [get_bd_pins sum1] [get_bd_pins c_addsub_0/S]
  connect_bd_net -net c_addsub_1_S [get_bd_pins sum2] [get_bd_pins c_addsub_1/S]
  connect_bd_net -net c_addsub_2_S [get_bd_pins sum3] [get_bd_pins c_addsub_2/S]
  connect_bd_net -net mul_sub0 [get_bd_pins sub0] [get_bd_pins c_addsub_0/A]
  connect_bd_net -net mul_sub1 [get_bd_pins sub1] [get_bd_pins c_addsub_0/B]
  connect_bd_net -net mul_sub2 [get_bd_pins sub2] [get_bd_pins c_addsub_1/A]
  connect_bd_net -net mul_sub3 [get_bd_pins sub3] [get_bd_pins c_addsub_1/B]
  connect_bd_net -net mul_sub4 [get_bd_pins sub5] [get_bd_pins c_addsub_2/B]
  connect_bd_net -net mul_sub5 [get_bd_pins sub4] [get_bd_pins c_addsub_2/A]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: stage1_3
proc create_hier_cell_stage1_3 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_stage1_3() - Empty argument(s)!"}
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
  create_bd_pin -dir O -from 11 -to 0 sub0
  create_bd_pin -dir O -from 13 -to 0 sub1
  create_bd_pin -dir O -from 14 -to 0 sub2
  create_bd_pin -dir O -from 15 -to 0 sub3
  create_bd_pin -dir O -from 15 -to 0 sub4
  create_bd_pin -dir O -from 15 -to 0 sub5
  create_bd_pin -dir I -from 7 -to 0 y0
  create_bd_pin -dir I -from 7 -to 0 y1
  create_bd_pin -dir I -from 7 -to 0 y2
  create_bd_pin -dir I -from 7 -to 0 y3
  create_bd_pin -dir I -from 7 -to 0 y4
  create_bd_pin -dir I -from 7 -to 0 y5
  create_bd_pin -dir I -from 7 -to 0 y6
  create_bd_pin -dir I -from 7 -to 0 y7
  create_bd_pin -dir I -from 7 -to 0 y8
  create_bd_pin -dir I -from 7 -to 0 y9
  create_bd_pin -dir I -from 7 -to 0 y10
  create_bd_pin -dir I -from 7 -to 0 y11
  create_bd_pin -dir I -from 7 -to 0 y12

  # Create instance: mul_sub_0
  create_hier_cell_mul_sub_0 $hier_obj mul_sub_0

  # Create instance: mul_sub_1
  create_hier_cell_mul_sub_1 $hier_obj mul_sub_1

  # Create instance: mul_sub_2
  create_hier_cell_mul_sub_2 $hier_obj mul_sub_2

  # Create instance: mul_sub_3
  create_hier_cell_mul_sub_3 $hier_obj mul_sub_3

  # Create instance: mul_sub_4
  create_hier_cell_mul_sub_4 $hier_obj mul_sub_4

  # Create instance: mul_sub_5
  create_hier_cell_mul_sub_5 $hier_obj mul_sub_5

  # Create port connections
  connect_bd_net -net CLK_1 [get_bd_pins CLK] [get_bd_pins mul_sub_0/CLK] [get_bd_pins mul_sub_1/CLK] [get_bd_pins mul_sub_2/CLK] [get_bd_pins mul_sub_3/CLK] [get_bd_pins mul_sub_4/CLK] [get_bd_pins mul_sub_5/CLK]
  connect_bd_net -net mul_sub_0_sub0 [get_bd_pins sub0] [get_bd_pins mul_sub_0/sub0]
  connect_bd_net -net mul_sub_1_sub1 [get_bd_pins sub1] [get_bd_pins mul_sub_1/sub1]
  connect_bd_net -net mul_sub_2_sub2 [get_bd_pins sub2] [get_bd_pins mul_sub_2/sub2]
  connect_bd_net -net mul_sub_3_sub3 [get_bd_pins sub3] [get_bd_pins mul_sub_3/sub3]
  connect_bd_net -net mul_sub_4_sub4 [get_bd_pins sub4] [get_bd_pins mul_sub_4/sub4]
  connect_bd_net -net mul_sub_5_sub5 [get_bd_pins sub5] [get_bd_pins mul_sub_5/sub5]
  connect_bd_net -net y0_1 [get_bd_pins y0] [get_bd_pins mul_sub_0/y0]
  connect_bd_net -net y10_1 [get_bd_pins y10] [get_bd_pins mul_sub_2/y12]
  connect_bd_net -net y11_1 [get_bd_pins y11] [get_bd_pins mul_sub_1/y12]
  connect_bd_net -net y12_1 [get_bd_pins y12] [get_bd_pins mul_sub_0/y12]
  connect_bd_net -net y1_1 [get_bd_pins y1] [get_bd_pins mul_sub_1/y0]
  connect_bd_net -net y2_1 [get_bd_pins y2] [get_bd_pins mul_sub_2/y0]
  connect_bd_net -net y3_1 [get_bd_pins y3] [get_bd_pins mul_sub_3/y0]
  connect_bd_net -net y4_1 [get_bd_pins y4] [get_bd_pins mul_sub_4/y4]
  connect_bd_net -net y5_1 [get_bd_pins y5] [get_bd_pins mul_sub_5/y0]
  connect_bd_net -net y7_1 [get_bd_pins y7] [get_bd_pins mul_sub_5/y12]
  connect_bd_net -net y8_1 [get_bd_pins y8] [get_bd_pins mul_sub_4/y8]
  connect_bd_net -net y9_1 [get_bd_pins y9] [get_bd_pins mul_sub_3/y12]

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
  create_bd_pin -dir I CLK
  create_bd_pin -dir I -from 15 -to 0 din
  create_bd_pin -dir I last_in
  create_bd_pin -dir O -from 0 -to 0 last_out
  create_bd_pin -dir I -from 0 -to 0 user_in
  create_bd_pin -dir O -from 0 -to 0 user_out
  create_bd_pin -dir I valid_in
  create_bd_pin -dir O -from 0 -to 0 valid_out
  create_bd_pin -dir O -from 7 -to 0 y0
  create_bd_pin -dir O -from 7 -to 0 y1
  create_bd_pin -dir O -from 7 -to 0 y2
  create_bd_pin -dir O -from 7 -to 0 y3
  create_bd_pin -dir O -from 7 -to 0 y4
  create_bd_pin -dir O -from 7 -to 0 y5
  create_bd_pin -dir O -from 7 -to 0 y6
  create_bd_pin -dir O -from 7 -to 0 y7
  create_bd_pin -dir O -from 7 -to 0 y8
  create_bd_pin -dir O -from 7 -to 0 y9
  create_bd_pin -dir O -from 7 -to 0 y10
  create_bd_pin -dir O -from 7 -to 0 y11
  create_bd_pin -dir O -from 7 -to 0 y12
  create_bd_pin -dir O -from 7 -to 0 y13

  # Create instance: slice0
  create_hier_cell_slice0 $hier_obj slice0

  # Create instance: slice1
  create_hier_cell_slice1 $hier_obj slice1

  # Create instance: slice2
  create_hier_cell_slice2 $hier_obj slice2

  # Create instance: slice3
  create_hier_cell_slice3 $hier_obj slice3

  # Create instance: slice4
  create_hier_cell_slice4 $hier_obj slice4

  # Create instance: slice5
  create_hier_cell_slice5 $hier_obj slice5

  # Create instance: slice6
  create_hier_cell_slice6 $hier_obj slice6

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

  # Create instance: y11y10, and set properties
  set y11y10 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 y11y10 ]
  set_property -dict [ list \
   CONFIG.CE {true} \
   CONFIG.Depth {1} \
   CONFIG.Width {16} \
 ] $y11y10

  # Create instance: y13y12, and set properties
  set y13y12 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 y13y12 ]
  set_property -dict [ list \
   CONFIG.CE {true} \
   CONFIG.Depth {1} \
   CONFIG.Width {16} \
 ] $y13y12

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

  # Create instance: y5y4, and set properties
  set y5y4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 y5y4 ]
  set_property -dict [ list \
   CONFIG.CE {true} \
   CONFIG.Depth {1} \
   CONFIG.Width {16} \
 ] $y5y4

  # Create instance: y7y6, and set properties
  set y7y6 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 y7y6 ]
  set_property -dict [ list \
   CONFIG.CE {true} \
   CONFIG.Depth {1} \
   CONFIG.Width {16} \
 ] $y7y6

  # Create instance: y9y8, and set properties
  set y9y8 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 y9y8 ]
  set_property -dict [ list \
   CONFIG.CE {true} \
   CONFIG.Depth {1} \
   CONFIG.Width {16} \
 ] $y9y8

  # Create port connections
  connect_bd_net -net CE_1 [get_bd_pins valid_in] [get_bd_pins tap_1_valid/D] [get_bd_pins y11y10/CE] [get_bd_pins y13y12/CE] [get_bd_pins y1y0/CE] [get_bd_pins y3y2/CE] [get_bd_pins y5y4/CE] [get_bd_pins y7y6/CE] [get_bd_pins y9y8/CE]
  connect_bd_net -net CLK_1 [get_bd_pins CLK] [get_bd_pins tap_1_last/CLK] [get_bd_pins tap_1_user/CLK] [get_bd_pins tap_1_valid/CLK] [get_bd_pins y11y10/CLK] [get_bd_pins y13y12/CLK] [get_bd_pins y1y0/CLK] [get_bd_pins y3y2/CLK] [get_bd_pins y5y4/CLK] [get_bd_pins y7y6/CLK] [get_bd_pins y9y8/CLK]
  connect_bd_net -net D_1 [get_bd_pins din] [get_bd_pins y13y12/D]
  connect_bd_net -net Din_1 [get_bd_pins slice6/Din] [get_bd_pins y1y0/Q]
  connect_bd_net -net last_in_1 [get_bd_pins last_in] [get_bd_pins tap_1_last/D]
  connect_bd_net -net slice0_lsb [get_bd_pins y12] [get_bd_pins slice0/lsb]
  connect_bd_net -net slice0_msb [get_bd_pins y13] [get_bd_pins slice0/msb]
  connect_bd_net -net slice1_lsb [get_bd_pins y10] [get_bd_pins slice1/lsb]
  connect_bd_net -net slice1_msb [get_bd_pins y11] [get_bd_pins slice1/msb]
  connect_bd_net -net slice2_lsb [get_bd_pins y8] [get_bd_pins slice2/lsb]
  connect_bd_net -net slice2_msb [get_bd_pins y9] [get_bd_pins slice2/msb]
  connect_bd_net -net slice3_lsb [get_bd_pins y6] [get_bd_pins slice3/lsb]
  connect_bd_net -net slice3_msb [get_bd_pins y7] [get_bd_pins slice3/msb]
  connect_bd_net -net slice4_lsb [get_bd_pins y4] [get_bd_pins slice4/lsb]
  connect_bd_net -net slice4_msb [get_bd_pins y5] [get_bd_pins slice4/msb]
  connect_bd_net -net slice5_lsb [get_bd_pins y2] [get_bd_pins slice5/lsb]
  connect_bd_net -net slice5_msb [get_bd_pins y3] [get_bd_pins slice5/msb]
  connect_bd_net -net slice6_lsb [get_bd_pins y0] [get_bd_pins slice6/lsb]
  connect_bd_net -net slice6_msb [get_bd_pins y1] [get_bd_pins slice6/msb]
  connect_bd_net -net tap_1_last_Q [get_bd_pins last_out] [get_bd_pins tap_1_last/Q]
  connect_bd_net -net tap_1_user_Q [get_bd_pins user_out] [get_bd_pins tap_1_user/Q]
  connect_bd_net -net tap_1_valid_Q [get_bd_pins valid_out] [get_bd_pins tap_1_valid/Q]
  connect_bd_net -net user_in_1 [get_bd_pins user_in] [get_bd_pins tap_1_user/D]
  connect_bd_net -net y0y1_Q [get_bd_pins slice0/Din] [get_bd_pins y11y10/D] [get_bd_pins y13y12/Q]
  connect_bd_net -net y10y11_Q [get_bd_pins slice5/Din] [get_bd_pins y1y0/D] [get_bd_pins y3y2/Q]
  connect_bd_net -net y2y3_Q [get_bd_pins slice1/Din] [get_bd_pins y11y10/Q] [get_bd_pins y9y8/D]
  connect_bd_net -net y4y5_Q [get_bd_pins slice2/Din] [get_bd_pins y7y6/D] [get_bd_pins y9y8/Q]
  connect_bd_net -net y6y7_Q [get_bd_pins slice3/Din] [get_bd_pins y5y4/D] [get_bd_pins y7y6/Q]
  connect_bd_net -net y8y9_Q [get_bd_pins slice4/Din] [get_bd_pins y3y2/D] [get_bd_pins y5y4/Q]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: tap_9
proc create_hier_cell_tap_9 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_tap_9() - Empty argument(s)!"}
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

  # Create instance: tap_9_last, and set properties
  set tap_9_last [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 tap_9_last ]
  set_property -dict [ list \
   CONFIG.AsyncInitVal {0} \
   CONFIG.DefaultData {0} \
   CONFIG.Depth {9} \
   CONFIG.ShiftRegType {Fixed_Length} \
   CONFIG.SyncInitVal {0} \
   CONFIG.Width {1} \
 ] $tap_9_last

  # Create instance: tap_9_user, and set properties
  set tap_9_user [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 tap_9_user ]
  set_property -dict [ list \
   CONFIG.AsyncInitVal {0} \
   CONFIG.DefaultData {0} \
   CONFIG.Depth {9} \
   CONFIG.ShiftRegType {Fixed_Length} \
   CONFIG.SyncInitVal {0} \
   CONFIG.Width {1} \
 ] $tap_9_user

  # Create instance: tap_9_valid, and set properties
  set tap_9_valid [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 tap_9_valid ]
  set_property -dict [ list \
   CONFIG.AsyncInitVal {0} \
   CONFIG.DefaultData {0} \
   CONFIG.Depth {9} \
   CONFIG.ShiftRegType {Fixed_Length} \
   CONFIG.SyncInitVal {0} \
   CONFIG.Width {1} \
 ] $tap_9_valid

  # Create port connections
  connect_bd_net -net CLK_1 [get_bd_pins CLK] [get_bd_pins tap_9_last/CLK] [get_bd_pins tap_9_user/CLK] [get_bd_pins tap_9_valid/CLK]
  connect_bd_net -net tap_9_last_Q [get_bd_pins last_out] [get_bd_pins tap_9_last/Q]
  connect_bd_net -net tap_9_user_Q [get_bd_pins user_out] [get_bd_pins tap_9_user/Q]
  connect_bd_net -net tap_9_valid_Q [get_bd_pins valid_out] [get_bd_pins tap_9_valid/Q]
  connect_bd_net -net window_last_out [get_bd_pins last_in] [get_bd_pins tap_9_last/D]
  connect_bd_net -net window_user_out [get_bd_pins user_in] [get_bd_pins tap_9_user/D]
  connect_bd_net -net window_valid_out [get_bd_pins valid_in] [get_bd_pins tap_9_valid/D]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: dgfilter1
proc create_hier_cell_dgfilter1 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_dgfilter1() - Empty argument(s)!"}
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
  create_bd_pin -dir O -from 10 -to 0 sum
  create_bd_pin -dir I -from 7 -to 0 y0
  create_bd_pin -dir I -from 7 -to 0 y1
  create_bd_pin -dir I -from 7 -to 0 y2
  create_bd_pin -dir I -from 7 -to 0 y3
  create_bd_pin -dir I -from 7 -to 0 y4
  create_bd_pin -dir I -from 7 -to 0 y5
  create_bd_pin -dir I -from 7 -to 0 y6
  create_bd_pin -dir I -from 7 -to 0 y7
  create_bd_pin -dir I -from 7 -to 0 y8
  create_bd_pin -dir I -from 7 -to 0 y9
  create_bd_pin -dir I -from 7 -to 0 y10
  create_bd_pin -dir I -from 7 -to 0 y11
  create_bd_pin -dir I -from 7 -to 0 y12

  # Create instance: int_bits, and set properties
  set int_bits [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 int_bits ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {17} \
   CONFIG.DIN_TO {7} \
   CONFIG.DIN_WIDTH {18} \
   CONFIG.DOUT_WIDTH {11} \
 ] $int_bits

  # Create instance: stage1_3
  create_hier_cell_stage1_3_1 $hier_obj stage1_3

  # Create instance: stage2_2
  create_hier_cell_stage2_2_1 $hier_obj stage2_2

  # Create instance: stage3_2
  create_hier_cell_stage3_2_1 $hier_obj stage3_2

  # Create instance: stage4_2
  create_hier_cell_stage4_2_1 $hier_obj stage4_2

  # Create port connections
  connect_bd_net -net CLK_1 [get_bd_pins CLK] [get_bd_pins stage1_3/CLK] [get_bd_pins stage2_2/CLK] [get_bd_pins stage3_2/CLK] [get_bd_pins stage4_2/CLK]
  connect_bd_net -net c_addsub_0_S [get_bd_pins stage2_2/sum1] [get_bd_pins stage3_2/sum1]
  connect_bd_net -net c_addsub_1_S [get_bd_pins stage2_2/sum2] [get_bd_pins stage3_2/sum2]
  connect_bd_net -net c_addsub_2_S [get_bd_pins stage2_2/sum3] [get_bd_pins stage3_2/sum3]
  connect_bd_net -net c_addsub_3_S [get_bd_pins stage3_2/sum23] [get_bd_pins stage4_2/sum23]
  connect_bd_net -net int_bits_Dout [get_bd_pins sum] [get_bd_pins int_bits/Dout]
  connect_bd_net -net mul_sub0 [get_bd_pins stage1_3/sub0] [get_bd_pins stage2_2/sub0]
  connect_bd_net -net mul_sub1 [get_bd_pins stage1_3/sub1] [get_bd_pins stage2_2/sub1]
  connect_bd_net -net mul_sub2 [get_bd_pins stage1_3/sub2] [get_bd_pins stage2_2/sub2]
  connect_bd_net -net mul_sub3 [get_bd_pins stage1_3/sub3] [get_bd_pins stage2_2/sub3]
  connect_bd_net -net stage1_3_sub4 [get_bd_pins stage1_3/sub4] [get_bd_pins stage2_2/sub4]
  connect_bd_net -net stage1_3_sub5 [get_bd_pins stage1_3/sub5] [get_bd_pins stage2_2/sub5]
  connect_bd_net -net stage4_2_sum [get_bd_pins int_bits/Din] [get_bd_pins stage4_2/sum]
  connect_bd_net -net tap_2_0_Q [get_bd_pins stage3_2/sum1_d] [get_bd_pins stage4_2/sum1]
  connect_bd_net -net y0_1 [get_bd_pins y0] [get_bd_pins stage1_3/y0]
  connect_bd_net -net y10_1 [get_bd_pins y10] [get_bd_pins stage1_3/y10]
  connect_bd_net -net y11_1 [get_bd_pins y11] [get_bd_pins stage1_3/y11]
  connect_bd_net -net y12_1 [get_bd_pins y12] [get_bd_pins stage1_3/y12]
  connect_bd_net -net y1_1 [get_bd_pins y1] [get_bd_pins stage1_3/y1]
  connect_bd_net -net y2_1 [get_bd_pins y2] [get_bd_pins stage1_3/y2]
  connect_bd_net -net y3_1 [get_bd_pins y3] [get_bd_pins stage1_3/y3]
  connect_bd_net -net y4_1 [get_bd_pins y4] [get_bd_pins stage1_3/y4]
  connect_bd_net -net y5_1 [get_bd_pins y5] [get_bd_pins stage1_3/y5]
  connect_bd_net -net y6_1 [get_bd_pins y6] [get_bd_pins stage1_3/y6]
  connect_bd_net -net y7_1 [get_bd_pins y7] [get_bd_pins stage1_3/y7]
  connect_bd_net -net y8_1 [get_bd_pins y8] [get_bd_pins stage1_3/y8]
  connect_bd_net -net y9_1 [get_bd_pins y9] [get_bd_pins stage1_3/y9]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: dgfilter0
proc create_hier_cell_dgfilter0 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_dgfilter0() - Empty argument(s)!"}
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
  create_bd_pin -dir O -from 10 -to 0 sum
  create_bd_pin -dir I -from 7 -to 0 y0
  create_bd_pin -dir I -from 7 -to 0 y1
  create_bd_pin -dir I -from 7 -to 0 y2
  create_bd_pin -dir I -from 7 -to 0 y3
  create_bd_pin -dir I -from 7 -to 0 y4
  create_bd_pin -dir I -from 7 -to 0 y5
  create_bd_pin -dir I -from 7 -to 0 y6
  create_bd_pin -dir I -from 7 -to 0 y7
  create_bd_pin -dir I -from 7 -to 0 y8
  create_bd_pin -dir I -from 7 -to 0 y9
  create_bd_pin -dir I -from 7 -to 0 y10
  create_bd_pin -dir I -from 7 -to 0 y11
  create_bd_pin -dir I -from 7 -to 0 y12

  # Create instance: int_bits, and set properties
  set int_bits [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 int_bits ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {17} \
   CONFIG.DIN_TO {7} \
   CONFIG.DIN_WIDTH {18} \
   CONFIG.DOUT_WIDTH {11} \
 ] $int_bits

  # Create instance: stage1_3
  create_hier_cell_stage1_3 $hier_obj stage1_3

  # Create instance: stage2_2
  create_hier_cell_stage2_2 $hier_obj stage2_2

  # Create instance: stage3_2
  create_hier_cell_stage3_2 $hier_obj stage3_2

  # Create instance: stage4_2
  create_hier_cell_stage4_2 $hier_obj stage4_2

  # Create port connections
  connect_bd_net -net CLK_1 [get_bd_pins CLK] [get_bd_pins stage1_3/CLK] [get_bd_pins stage2_2/CLK] [get_bd_pins stage3_2/CLK] [get_bd_pins stage4_2/CLK]
  connect_bd_net -net c_addsub_0_S [get_bd_pins stage2_2/sum1] [get_bd_pins stage3_2/sum1]
  connect_bd_net -net c_addsub_1_S [get_bd_pins stage2_2/sum2] [get_bd_pins stage3_2/sum2]
  connect_bd_net -net c_addsub_2_S [get_bd_pins stage2_2/sum3] [get_bd_pins stage3_2/sum3]
  connect_bd_net -net c_addsub_3_S [get_bd_pins stage3_2/sum23] [get_bd_pins stage4_2/sum23]
  connect_bd_net -net int_bits_Dout [get_bd_pins sum] [get_bd_pins int_bits/Dout]
  connect_bd_net -net mul_sub0 [get_bd_pins stage1_3/sub0] [get_bd_pins stage2_2/sub0]
  connect_bd_net -net mul_sub1 [get_bd_pins stage1_3/sub1] [get_bd_pins stage2_2/sub1]
  connect_bd_net -net mul_sub2 [get_bd_pins stage1_3/sub2] [get_bd_pins stage2_2/sub2]
  connect_bd_net -net mul_sub3 [get_bd_pins stage1_3/sub3] [get_bd_pins stage2_2/sub3]
  connect_bd_net -net stage1_3_sub4 [get_bd_pins stage1_3/sub4] [get_bd_pins stage2_2/sub4]
  connect_bd_net -net stage1_3_sub5 [get_bd_pins stage1_3/sub5] [get_bd_pins stage2_2/sub5]
  connect_bd_net -net stage4_2_sum [get_bd_pins int_bits/Din] [get_bd_pins stage4_2/sum]
  connect_bd_net -net tap_2_0_Q [get_bd_pins stage3_2/sum1_d] [get_bd_pins stage4_2/sum1]
  connect_bd_net -net y0_1 [get_bd_pins y0] [get_bd_pins stage1_3/y0]
  connect_bd_net -net y10_1 [get_bd_pins y10] [get_bd_pins stage1_3/y10]
  connect_bd_net -net y11_1 [get_bd_pins y11] [get_bd_pins stage1_3/y11]
  connect_bd_net -net y12_1 [get_bd_pins y12] [get_bd_pins stage1_3/y12]
  connect_bd_net -net y1_1 [get_bd_pins y1] [get_bd_pins stage1_3/y1]
  connect_bd_net -net y2_1 [get_bd_pins y2] [get_bd_pins stage1_3/y2]
  connect_bd_net -net y3_1 [get_bd_pins y3] [get_bd_pins stage1_3/y3]
  connect_bd_net -net y4_1 [get_bd_pins y4] [get_bd_pins stage1_3/y4]
  connect_bd_net -net y5_1 [get_bd_pins y5] [get_bd_pins stage1_3/y5]
  connect_bd_net -net y6_1 [get_bd_pins y6] [get_bd_pins stage1_3/y6]
  connect_bd_net -net y7_1 [get_bd_pins y7] [get_bd_pins stage1_3/y7]
  connect_bd_net -net y8_1 [get_bd_pins y8] [get_bd_pins stage1_3/y8]
  connect_bd_net -net y9_1 [get_bd_pins y9] [get_bd_pins stage1_3/y9]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: dg_filter
proc create_hier_cell_dg_filter { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_dg_filter() - Empty argument(s)!"}
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
  create_bd_pin -dir O -from 21 -to 0 dout
  create_bd_pin -dir I last_in
  create_bd_pin -dir O -from 0 -to 0 last_out
  create_bd_pin -dir I -from 0 -to 0 user_in
  create_bd_pin -dir O -from 0 -to 0 user_out
  create_bd_pin -dir I valid_in
  create_bd_pin -dir O -from 0 -to 0 valid_out

  # Create instance: dgfilter0
  create_hier_cell_dgfilter0 $hier_obj dgfilter0

  # Create instance: dgfilter1
  create_hier_cell_dgfilter1 $hier_obj dgfilter1

  # Create instance: pack, and set properties
  set pack [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 pack ]
  set_property -dict [ list \
   CONFIG.IN0_WIDTH {11} \
   CONFIG.IN1_WIDTH {11} \
 ] $pack

  # Create instance: tap_9
  create_hier_cell_tap_9 $hier_obj tap_9

  # Create instance: window
  create_hier_cell_window $hier_obj window

  # Create port connections
  connect_bd_net -net CLK_1 [get_bd_pins CLK] [get_bd_pins dgfilter0/CLK] [get_bd_pins dgfilter1/CLK] [get_bd_pins tap_9/CLK] [get_bd_pins window/CLK]
  connect_bd_net -net dgfilter0_sum [get_bd_pins dgfilter0/sum] [get_bd_pins pack/In0]
  connect_bd_net -net dgfilter1_sum [get_bd_pins dgfilter1/sum] [get_bd_pins pack/In1]
  connect_bd_net -net last_in_1 [get_bd_pins last_in] [get_bd_pins window/last_in]
  connect_bd_net -net median_dout [get_bd_pins din] [get_bd_pins window/din]
  connect_bd_net -net median_valid_out [get_bd_pins valid_in] [get_bd_pins window/valid_in]
  connect_bd_net -net pack_dout [get_bd_pins dout] [get_bd_pins pack/dout]
  connect_bd_net -net tap_9_last_Q [get_bd_pins last_out] [get_bd_pins tap_9/last_out]
  connect_bd_net -net tap_9_user_Q [get_bd_pins user_out] [get_bd_pins tap_9/user_out]
  connect_bd_net -net tap_9_valid_Q [get_bd_pins valid_out] [get_bd_pins tap_9/valid_out]
  connect_bd_net -net user_in_1 [get_bd_pins user_in] [get_bd_pins window/user_in]
  connect_bd_net -net window_last_out [get_bd_pins tap_9/last_in] [get_bd_pins window/last_out]
  connect_bd_net -net window_user_out [get_bd_pins tap_9/user_in] [get_bd_pins window/user_out]
  connect_bd_net -net window_valid_out [get_bd_pins tap_9/valid_in] [get_bd_pins window/valid_out]
  connect_bd_net -net window_y0 [get_bd_pins dgfilter0/y0] [get_bd_pins window/y0]
  connect_bd_net -net window_y1 [get_bd_pins dgfilter0/y1] [get_bd_pins dgfilter1/y0] [get_bd_pins window/y1]
  connect_bd_net -net window_y2 [get_bd_pins dgfilter0/y2] [get_bd_pins dgfilter1/y1] [get_bd_pins window/y2]
  connect_bd_net -net window_y3 [get_bd_pins dgfilter0/y3] [get_bd_pins dgfilter1/y2] [get_bd_pins window/y3]
  connect_bd_net -net window_y4 [get_bd_pins dgfilter0/y4] [get_bd_pins dgfilter1/y3] [get_bd_pins window/y4]
  connect_bd_net -net window_y5 [get_bd_pins dgfilter0/y5] [get_bd_pins dgfilter1/y4] [get_bd_pins window/y5]
  connect_bd_net -net window_y6 [get_bd_pins dgfilter0/y6] [get_bd_pins dgfilter1/y5] [get_bd_pins window/y6]
  connect_bd_net -net window_y7 [get_bd_pins dgfilter0/y7] [get_bd_pins dgfilter1/y6] [get_bd_pins window/y7]
  connect_bd_net -net window_y8 [get_bd_pins dgfilter0/y8] [get_bd_pins dgfilter1/y7] [get_bd_pins window/y8]
  connect_bd_net -net window_y9 [get_bd_pins dgfilter0/y9] [get_bd_pins dgfilter1/y8] [get_bd_pins window/y9]
  connect_bd_net -net window_y10 [get_bd_pins dgfilter0/y10] [get_bd_pins dgfilter1/y9] [get_bd_pins window/y10]
  connect_bd_net -net window_y11 [get_bd_pins dgfilter0/y11] [get_bd_pins dgfilter1/y10] [get_bd_pins window/y11]
  connect_bd_net -net window_y12 [get_bd_pins dgfilter0/y12] [get_bd_pins dgfilter1/y11] [get_bd_pins window/y12]
  connect_bd_net -net y12_1 [get_bd_pins dgfilter1/y12] [get_bd_pins window/y13]

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
  set tdata_out [ create_bd_port -dir O -from 21 -to 0 tdata_out ]
  set tlast_in [ create_bd_port -dir I tlast_in ]
  set tlast_out [ create_bd_port -dir O -from 0 -to 0 tlast_out ]
  set tready_in [ create_bd_port -dir O -from 0 -to 0 tready_in ]
  set tready_out [ create_bd_port -dir I tready_out ]
  set tuser_in [ create_bd_port -dir I -from 0 -to 0 tuser_in ]
  set tuser_out [ create_bd_port -dir O -from 0 -to 0 tuser_out ]
  set tvalid_in [ create_bd_port -dir I tvalid_in ]
  set tvalid_out [ create_bd_port -dir O -from 0 -to 0 tvalid_out ]

  # Create instance: dg_filter
  create_hier_cell_dg_filter [current_bd_instance .] dg_filter

  # Create instance: o_1, and set properties
  set o_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 o_1 ]

  # Create port connections
  connect_bd_net -net CLK_1 [get_bd_ports CLK] [get_bd_pins dg_filter/CLK]
  connect_bd_net -net dg_filter_dout [get_bd_ports tdata_out] [get_bd_pins dg_filter/dout]
  connect_bd_net -net dg_filter_last_out [get_bd_ports tlast_out] [get_bd_pins dg_filter/last_out]
  connect_bd_net -net dg_filter_user_out [get_bd_ports tuser_out] [get_bd_pins dg_filter/user_out]
  connect_bd_net -net dg_filter_valid_out [get_bd_ports tvalid_out] [get_bd_pins dg_filter/valid_out]
  connect_bd_net -net din_1 [get_bd_ports tdata_in] [get_bd_pins dg_filter/din]
  connect_bd_net -net last_in_1 [get_bd_ports tlast_in] [get_bd_pins dg_filter/last_in]
  connect_bd_net -net o_1_dout [get_bd_ports tready_in] [get_bd_pins o_1/dout]
  connect_bd_net -net user_in_1 [get_bd_ports tuser_in] [get_bd_pins dg_filter/user_in]
  connect_bd_net -net valid_in_1 [get_bd_ports tvalid_in] [get_bd_pins dg_filter/valid_in]

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


