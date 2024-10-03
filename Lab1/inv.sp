Inverter

*hspice -i inv.sp -o inv.lis

*library file
.lib '/usr/cots/synopsys/UniversityLibrary/SAED32_EDK/tech/hspice/saed32nm.lib' TT
.include '/usr/cots/synopsys/UniversityLibrary/SAED32_EDK/lib/stdcell_rvt/hspice/saed32nm_rvt.spf'

*post the results
.option post




*global nodes
.global vdd gnd


*define model
.model n105 nmos level=54
.model p105 pmos level=54

*source declaration(syntax:vname pos_node neg_node voltage_value)
vvdd vdd 0 vdd
vgnd gnd 0 0
vin in gnd

*define circuit connection
*tranname drain gate source body modulename W L
* TODO question how to choose W and L
.SUBCKT inv0 vi vo
M1 vo vi gnd gnd n105 W=200n L=100n 
M2 vo vi vdd vdd p105 W=300n L=100n
* .PRINT DC V(vin) V(vo)
* TODO ask if above print line is optinal seems to be
.ENDS

* TODO why is there inv0
xinv0 in out inv0


*define parameters
.param vdd=1.05

* Run a DC test on source ‘vin’scan it from 0 to vdd with the step length of 0.01
*define analysis voltage
.dc vin 0 vdd 0.01


.end
