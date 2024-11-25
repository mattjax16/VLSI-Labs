Inverter

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
vvdd vdd 0 vdd   *syntax:vname pos_node neg_node voltage_value
vgnd gnd 0 0v

.param vdd = 1.05
.param l = 100n

M1 vo vi gnd gnd n105 W=300n L=l
M2 vo vi vdd vdd p105 W=wp L=l

.param trf = 4p
.param del = 2u 
.param per = 10u
.param pw = 5u

*define analysis voltage
vinput vi gnd pulse 0 vdd del trf trf pw per

.model opt1 opt
.param wp = OPTrange(400n, 200n, 1000n)



.measure tran tphl trig v(vi) val='vdd*0.5' rise=2 targ v(vo) val='vdd*0.5' fall=2
.measure tran tplh trig v(vi) val='vdd*0.5' fall=2 targ v(vo) val='vdd*0.5' rise=2
.measure tran tpd param='tphl-tplh' goal=0

.tran 1p '3*per' sweep optimize=OPTrange RESULTS=tpd MODEL=OPT1

.end


