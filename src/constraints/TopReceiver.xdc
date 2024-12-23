## Pmod Header JB
# # Sch name = JB1
# set_property PACKAGE_PIN A14 [get_ports {gyro_cs}]
#     set_property IOSTANDARD LVCMOS33 [get_ports {gyro_cs}]
# Sch name = JB2
set_property PACKAGE_PIN A16 [get_ports {bt2_rx}]
    set_property IOSTANDARD LVCMOS33 [get_ports {bt2_rx}]
# Sch name = JB3
set_property PACKAGE_PIN B15 [get_ports {bt2_tx}]
    set_property IOSTANDARD LVCMOS33 [get_ports {bt2_tx}]
# Sch name = JB4
set_property PACKAGE_PIN B16 [get_ports {bt2_cts}]
    set_property IOSTANDARD LVCMOS33 [get_ports {bt2_cts}]

## USB-RS232 Interface
set_property PACKAGE_PIN B18 [get_ports pc_rx]
    set_property IOSTANDARD LVCMOS33 [get_ports pc_rx]
set_property PACKAGE_PIN A18 [get_ports pc_tx]
    set_property IOSTANDARD LVCMOS33 [get_ports pc_tx]

## Don't Touch
set_property CONFIG_VOLTAGE 3.3 [current_design]
set_property CFGBVS VCCO [current_design]
