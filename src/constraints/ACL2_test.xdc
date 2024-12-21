## This file is a general .xdc for the Basys3 rev B board
## To use it in a project:
## - uncomment the lines corresponding to used pins
##   (if you are using the editor in Vivado, you can select lines and hit "Ctrl + /" to comment/uncomment.)
## - rename the used ports (in each line, after get_ports) according to the top level signal names in the project

# Clock signal
set_property PACKAGE_PIN W5 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]
create_clock -period 10.000 -name sys_clk_pin -waveform {0.000 5.000} -add [get_ports clk]

# Switches
# set_property PACKAGE_PIN V17 [get_ports {sw[0]}]
#     set_property IOSTANDARD LVCMOS33 [get_ports {sw[0]}]
# set_property PACKAGE_PIN V16 [get_ports {sw[1]}]
#     set_property IOSTANDARD LVCMOS33 [get_ports {sw[1]}]
# set_property PACKAGE_PIN W16 [get_ports {sw[2]}]
#    set_property IOSTANDARD LVCMOS33 [get_ports {sw[2]}]
# set_property PACKAGE_PIN W17 [get_ports {sw[3]}]
#    set_property IOSTANDARD LVCMOS33 [get_ports {sw[3]}]
# set_property PACKAGE_PIN W15 [get_ports {sw[4]}]
#    set_property IOSTANDARD LVCMOS33 [get_ports {sw[4]}]
# set_property PACKAGE_PIN V15 [get_ports {sw[5]}]
#    set_property IOSTANDARD LVCMOS33 [get_ports {sw[5]}]
# set_property PACKAGE_PIN W14 [get_ports {sw[6]}]
#    set_property IOSTANDARD LVCMOS33 [get_ports {sw[6]}]
# set_property PACKAGE_PIN W13 [get_ports {sw[7]}]
#    set_property IOSTANDARD LVCMOS33 [get_ports {sw[7]}]
# set_property PACKAGE_PIN V2 [get_ports {sw[8]}]
#    set_property IOSTANDARD LVCMOS33 [get_ports {sw[8]}]
# set_property PACKAGE_PIN T3 [get_ports {sw[9]}]
#    set_property IOSTANDARD LVCMOS33 [get_ports {sw[9]}]
# set_property PACKAGE_PIN T2 [get_ports {sw[10]}]
#    set_property IOSTANDARD LVCMOS33 [get_ports {sw[10]}]
# set_property PACKAGE_PIN R3 [get_ports {sw[11]}]
#    set_property IOSTANDARD LVCMOS33 [get_ports {sw[11]}]
# set_property PACKAGE_PIN W2 [get_ports {sw[12]}]
#    set_property IOSTANDARD LVCMOS33 [get_ports {sw[12]}]
set_property PACKAGE_PIN U1 [get_ports {sw[0]}]
   set_property IOSTANDARD LVCMOS33 [get_ports {sw[0]}]
set_property PACKAGE_PIN T1 [get_ports {sw[1]}]
   set_property IOSTANDARD LVCMOS33 [get_ports {sw[1]}]
set_property PACKAGE_PIN R2 [get_ports {sw[2]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {sw[2]}]


# LEDs
set_property PACKAGE_PIN U16 [get_ports {LED[0]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {LED[0]}]
set_property PACKAGE_PIN E19 [get_ports {LED[1]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {LED[1]}]
set_property PACKAGE_PIN U19 [get_ports {LED[2]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {LED[2]}]
set_property PACKAGE_PIN V19 [get_ports {LED[3]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {LED[3]}]
set_property PACKAGE_PIN W18 [get_ports {LED[4]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {LED[4]}]
set_property PACKAGE_PIN U15 [get_ports {LED[5]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {LED[5]}]
set_property PACKAGE_PIN U14 [get_ports {LED[6]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {LED[6]}]
set_property PACKAGE_PIN V14 [get_ports {LED[7]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {LED[7]}]
set_property PACKAGE_PIN V13 [get_ports {LED[8]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {LED[8]}]
set_property PACKAGE_PIN V3 [get_ports {LED[9]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {LED[9]}]
set_property PACKAGE_PIN W3 [get_ports {LED[10]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {LED[10]}]
set_property PACKAGE_PIN U3 [get_ports {LED[11]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {LED[11]}]
# set_property PACKAGE_PIN P3 [get_ports {LED[12]}]
#    set_property IOSTANDARD LVCMOS33 [get_ports {LED[12]}]
# set_property PACKAGE_PIN N3 [get_ports {LED[13]}]
#    set_property IOSTANDARD LVCMOS33 [get_ports {LED[13]}]
# set_property PACKAGE_PIN P1 [get_ports {LED[14]}]
#    set_property IOSTANDARD LVCMOS33 [get_ports {LED[14]}]
# set_property PACKAGE_PIN L1 [get_ports {LED[15]}]
#    set_property IOSTANDARD LVCMOS33 [get_ports {LED[15]}]

# 7 segment display
#  set_property PACKAGE_PIN W7 [get_ports {DISPLAY[0]}]
#     set_property IOSTANDARD LVCMOS33 [get_ports {DISPLAY[0]}]
#  set_property PACKAGE_PIN W6 [get_ports {DISPLAY[1]}]
#     set_property IOSTANDARD LVCMOS33 [get_ports {DISPLAY[1]}]
#  set_property PACKAGE_PIN U8 [get_ports {DISPLAY[2]}]
#     set_property IOSTANDARD LVCMOS33 [get_ports {DISPLAY[2]}]
#  set_property PACKAGE_PIN V8 [get_ports {DISPLAY[3]}]
#     set_property IOSTANDARD LVCMOS33 [get_ports {DISPLAY[3]}]
#  set_property PACKAGE_PIN U5 [get_ports {DISPLAY[4]}]
#     set_property IOSTANDARD LVCMOS33 [get_ports {DISPLAY[4]}]
#  set_property PACKAGE_PIN V5 [get_ports {DISPLAY[5]}]
#     set_property IOSTANDARD LVCMOS33 [get_ports {DISPLAY[5]}]
#  set_property PACKAGE_PIN U7 [get_ports {DISPLAY[6]}]
#     set_property IOSTANDARD LVCMOS33 [get_ports {DISPLAY[6]}]

# set_property PACKAGE_PIN V7 [get_ports dp]
#    set_property IOSTANDARD LVCMOS33 [get_ports dp]

#  set_property PACKAGE_PIN U2 [get_ports {DIGIT[0]}]
#     set_property IOSTANDARD LVCMOS33 [get_ports {DIGIT[0]}]
#  set_property PACKAGE_PIN U4 [get_ports {DIGIT[1]}]
#     set_property IOSTANDARD LVCMOS33 [get_ports {DIGIT[1]}]
#  set_property PACKAGE_PIN V4 [get_ports {DIGIT[2]}]
#     set_property IOSTANDARD LVCMOS33 [get_ports {DIGIT[2]}]
#  set_property PACKAGE_PIN W4 [get_ports {DIGIT[3]}]
#     set_property IOSTANDARD LVCMOS33 [get_ports {DIGIT[3]}]
#===========================================
# 7 segment display
#  set_property PACKAGE_PIN W7 [get_ports {DISPLAY[0]}]
#     set_property IOSTANDARD LVCMOS33 [get_ports {DISPLAY[0]}]
#  set_property PACKAGE_PIN W6 [get_ports {DISPLAY[1]}]
#     set_property IOSTANDARD LVCMOS33 [get_ports {DISPLAY[1]}]
#  set_property PACKAGE_PIN U8 [get_ports {DISPLAY[2]}]
#     set_property IOSTANDARD LVCMOS33 [get_ports {DISPLAY[2]}]
#  set_property PACKAGE_PIN V8 [get_ports {DISPLAY[3]}]
#     set_property IOSTANDARD LVCMOS33 [get_ports {DISPLAY[3]}]
#  set_property PACKAGE_PIN U5 [get_ports {DISPLAY[4]}]
#     set_property IOSTANDARD LVCMOS33 [get_ports {DISPLAY[4]}]
#  set_property PACKAGE_PIN V5 [get_ports {DISPLAY[5]}]
#     set_property IOSTANDARD LVCMOS33 [get_ports {DISPLAY[5]}]
#  set_property PACKAGE_PIN U7 [get_ports {DISPLAY[6]}]
#     set_property IOSTANDARD LVCMOS33 [get_ports {DISPLAY[6]}]

# set_property PACKAGE_PIN V7 [get_ports dp]
#    set_property IOSTANDARD LVCMOS33 [get_ports dp]
#
#  set_property PACKAGE_PIN U2 [get_ports {DIGIT[0]}]
#     set_property IOSTANDARD LVCMOS33 [get_ports {DIGIT[0]}]
#  set_property PACKAGE_PIN U4 [get_ports {DIGIT[1]}]
#     set_property IOSTANDARD LVCMOS33 [get_ports {DIGIT[1]}]
#  set_property PACKAGE_PIN V4 [get_ports {DIGIT[2]}]
#     set_property IOSTANDARD LVCMOS33 [get_ports {DIGIT[2]}]
#  set_property PACKAGE_PIN W4 [get_ports {DIGIT[3]}]
#     set_property IOSTANDARD LVCMOS33 [get_ports {DIGIT[3]}]
#=============================================


# Buttons
set_property PACKAGE_PIN U18 [get_ports rst]
    set_property IOSTANDARD LVCMOS33 [get_ports rst]
# set_property PACKAGE_PIN T18 [get_ports btn_up]
#    set_property IOSTANDARD LVCMOS33 [get_ports btn_up]
# set_property PACKAGE_PIN W19 [get_ports btnL]
#    set_property IOSTANDARD LVCMOS33 [get_ports btnL]
# set_property PACKAGE_PIN T17 [get_ports btnR]
#    set_property IOSTANDARD LVCMOS33 [get_ports btnR]
# set_property PACKAGE_PIN U17 [get_ports btn_down]
#    set_property IOSTANDARD LVCMOS33 [get_ports btn_down]



## Pmod Header JA
# Sch name = JA1
set_property PACKAGE_PIN J1 [get_ports {cs}]
    set_property IOSTANDARD LVCMOS33 [get_ports {cs}]
# Sch name = JA2
set_property PACKAGE_PIN L2 [get_ports {mosi}]
    set_property IOSTANDARD LVCMOS33 [get_ports {mosi}]
# Sch name = JA3
set_property PACKAGE_PIN J2 [get_ports {miso}]
    set_property IOSTANDARD LVCMOS33 [get_ports {miso}]
# Sch name = JA4
set_property PACKAGE_PIN G2 [get_ports {sclk}]
    set_property IOSTANDARD LVCMOS33 [get_ports {sclk}]
# Sch name = JA7
set_property PACKAGE_PIN H1 [get_ports {int1}]
    set_property IOSTANDARD LVCMOS33 [get_ports {int1}]
# Sch name = JA8
set_property PACKAGE_PIN K2 [get_ports {int2}]
    set_property IOSTANDARD LVCMOS33 [get_ports {int2}]
## Sch name = JA9
# set_property PACKAGE_PIN H2 [get_ports {PWM_1}]
#    set_property IOSTANDARD LVCMOS33 [get_ports {PWM_1}]
## Sch name = JA10
# set_property PACKAGE_PIN G3 [get_ports {sw0}]
#    set_property IOSTANDARD LVCMOS33 [get_ports {sw0}]



## Pmod Header JB
## Sch name = JB1
# set_property PACKAGE_PIN A14 [get_ports {sonic_trig[0]}]
#    set_property IOSTANDARD LVCMOS33 [get_ports {sonic_trig[0]}]
## Sch name = JB2
# set_property PACKAGE_PIN A16 [get_ports {sonic_echo[0]}]
#    set_property IOSTANDARD LVCMOS33 [get_ports {sonic_echo[0]}]
## Sch name = JB3
# set_property PACKAGE_PIN B15 [get_ports {sonic_trig}]
#     set_property IOSTANDARD LVCMOS33 [get_ports {sonic_trig}]
## Sch name = JB4
# set_property PACKAGE_PIN B16 [get_ports {sonic_echo}]
#     set_property IOSTANDARD LVCMOS33 [get_ports {sonic_echo}]
## Sch name = JB7
# set_property PACKAGE_PIN A15 [get_ports {motor_cw[0]}]
#    set_property IOSTANDARD LVCMOS33 [get_ports {motor_cw[0]}]
# Sch name = JB8
# set_property PACKAGE_PIN A17 [get_ports {track_r}]
#     set_property IOSTANDARD LVCMOS33 [get_ports {track_r}]
## Sch name = JB9
# set_property PACKAGE_PIN C15 [get_ports {track_c}]
#     set_property IOSTANDARD LVCMOS33 [get_ports {track_c}]
## Sch name = JB10
# set_property PACKAGE_PIN C16 [get_ports {track_l}]
#     set_property IOSTANDARD LVCMOS33 [get_ports {track_l}]



## Pmod Header JC
## Sch name = JC1
# set_property PACKAGE_PIN K17 [get_ports {JC[0]}]
#    set_property IOSTANDARD LVCMOS33 [get_ports {JC[0]}]
## Sch name = JC2
# set_property PACKAGE_PIN M18 [get_ports {JC[1]}]
#    set_property IOSTANDARD LVCMOS33 [get_ports {JC[1]}]
## Sch name = JC3
# set_property PACKAGE_PIN N17 [get_ports {JC[2]}]
#    set_property IOSTANDARD LVCMOS33 [get_ports {JC[2]}]
## Sch name = JC4
# set_property PACKAGE_PIN P18 [get_ports {JC[3]}]
#    set_property IOSTANDARD LVCMOS33 [get_ports {JC[3]}]
## Sch name = JC7
# set_property PACKAGE_PIN L17 [get_ports {JC[4]}]
#    set_property IOSTANDARD LVCMOS33 [get_ports {JC[4]}]
## Sch name = JC8
# set_property PACKAGE_PIN M19 [get_ports {JC[5]}]
#    set_property IOSTANDARD LVCMOS33 [get_ports {JC[5]}]
## Sch name = JC9
# set_property PACKAGE_PIN P17 [get_ports {JC[6]}]
#    set_property IOSTANDARD LVCMOS33 [get_ports {JC[6]}]
## Sch name = JC10
# set_property PACKAGE_PIN R18 [get_ports {JC[7]}]
#    set_property IOSTANDARD LVCMOS33 [get_ports {JC[7]}]


## Pmod Header JXADC
## Sch name = XA1_P
# set_property PACKAGE_PIN J3 [get_ports {JXADC[0]}]
#    set_property IOSTANDARD LVCMOS33 [get_ports {JXADC[0]}]
## Sch name = XA2_P
# set_property PACKAGE_PIN L3 [get_ports {JXADC[1]}]
#    set_property IOSTANDARD LVCMOS33 [get_ports {JXADC[1]}]
## Sch name = XA3_P
# set_property PACKAGE_PIN M2 [get_ports {ble_tx}]
#    set_property IOSTANDARD LVCMOS33 [get_ports {ble_tx}]
## Sch name = XA4_P
# set_property PACKAGE_PIN N2 [get_ports {ble_rx}]
#   set_property IOSTANDARD LVCMOS33 [get_ports {ble_rx}]
#   set_property PULLUP true [get_ports ble_rx]
## Sch name = XA1_N
# set_property PACKAGE_PIN K3 [get_ports {JXADC[4]}]
#    set_property IOSTANDARD LVCMOS33 [get_ports {JXADC[4]}]
## Sch name = XA2_N
# set_property PACKAGE_PIN M3 [get_ports {JXADC[5]}]
#    set_property IOSTANDARD LVCMOS33 [get_ports {JXADC[5]}]
## Sch name = XA3_N
# set_property PACKAGE_PIN M1 [get_ports {JXADC[6]}]
#    set_property IOSTANDARD LVCMOS33 [get_ports {JXADC[6]}]
## Sch name = XA4_N
# set_property PACKAGE_PIN N1 [get_ports {JXADC[7]}]
#    set_property IOSTANDARD LVCMOS33 [get_ports {JXADC[7]}]

## Don't Touch
# set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]
# set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 4 [current_design]
# set_property CONFIG_MODE SPIx4 [current_design]
# set_property BITSTREAM.CONFIG.CONFIGRATE 33 [current_design]

## where 3.3 is the voltage provided to configuration bank 0
set_property CONFIG_VOLTAGE 3.3 [current_design]
## where value1 is either VCCO(for Vdd=3.3) or GND(for Vdd=1.8)
set_property CFGBVS VCCO [current_design]

#set_property PACKAGE_PIN V16 [get_ports speed]
#set_property IOSTANDARD LVCMOS33 [get_ports speed]
#set_property PACKAGE_PIN V16 [get_ports dir]
#set_property IOSTANDARD LVCMOS33 [get_ports dir]
#set_property PACKAGE_PIN V17 [get_ports en]
#set_property IOSTANDARD LVCMOS33 [get_ports en]
#set_property PACKAGE_PIN W16 [get_ports rst]
#set_property IOSTANDARD LVCMOS33 [get_ports rst]



