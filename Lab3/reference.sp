
*library file
.lib '/usr/cots/synopsys/UniversityLibrary/SAED32_EDK/tech/hspice/saed32nm.lib' TT
.include '/usr/cots/synopsys/UniversityLibrary/SAED32_EDK/lib/stdcell_rvt/hspice/saed32nm_rvt.spf'
*post the results
.option post
.global vdd gnd
*define model
.model n105 nmos level=54
.model p105 pmos level=54
*source declaration
vvdd vdd 0 vdd *syntax:vname pos_node neg_node voltage_value
vgnd gnd 0 0v
M1 vo vi gnd gnd n105 W=300n L=l
M2 vo vi vdd vdd p105 W=300n L=l
*define parameters
.param vdd = 1.05
.param l = 100n
.param trf = 6p *initial rise/fall time of the transient source
.param del = 1u
.param pw = 1u
.param per = 2u
*define analysis voltage
vinput vi gnd pulse 0 vdd del trf trf pw per
.tran 1p 6u
.measure tran outrise
+trig v(vo) val='vdd*0.1' rise=2
+targ v(vo) val='vdd*0.9' rise=2
.measure tran outfall
+trig v(vo) val='vdd*0.9' fall=2
+targ v(vo) val='vdd*0.1' fall=2
.measure tran tphl
+trig v(vi) val='vdd*0.5' rise=2
+targ v(vo) val='vdd*0.5' fall=2
.measure tran tplh
+trig v(vi) val='vdd*0.5' fall=2
+targ v(vo) val='vdd*0.5' rise=2
.end