
# PlanAhead Launch Script for Post-Synthesis pin planning, created by Project Navigator

create_project -name Lab-2-PMIC -dir "C:/Users/Steven/Documents/School/ECE_428/Lab-2-Xilinx/Lab-2-PMIC/planAhead_run_1" -part xc6slx45csg324-3
set_property design_mode GateLvl [get_property srcset [current_run -impl]]
set_property edif_top_file "C:/Users/Steven/Documents/School/ECE_428/Lab-2-Xilinx/Lab-2-PMIC/pmic.ngc" [ get_property srcset [ current_run ] ]
add_files -norecurse { {C:/Users/Steven/Documents/School/ECE_428/Lab-2-Xilinx/Lab-2-PMIC} {ipcore_dir} }
set_param project.pinAheadLayout  yes
set_property target_constrs_file "pmic.ucf" [current_fileset -constrset]
add_files [list {pmic.ucf}] -fileset [get_property constrset [current_run]]
link_design
