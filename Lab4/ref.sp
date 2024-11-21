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

*M1 vo vi gnd gnd n105 W=300n L=l
*M2 vo vi vdd vdd p105 W=wp L=l

*Q1 Part A: input capacitance @ first stage
* inverter
*M1 vo vi gnd gnd n105 W=300n L=l
*M2 vo vi vdd vdd p105 W=600n L=l

.param trf = 6p
.param del = 2u 
.param per = 10u
.param pw = 5u


*Q1: part C
.subckt inv1 in out
M1 out in vdd vdd p105 W=600n L=100n 
M2 out in gnd gnd n105 W=300n L=100n 
.ends inv1

* times 8, or times 4, or times 2.8
.subckt inv2 in out 
M1 out in vdd vdd p105 W=1680n L=100n
M2 out in gnd gnd n105 W=840n L=100n
.ends inv2

*times 16, or times 8
.subckt inv3 in out
M1 out in vdd vdd p105 W=4800n L=100n 
M2 out in gnd gnd n105 W=2400n L=100n 
.ends inv3 

*times 22.6
.subckt inv4 in out 
M1 out in vdd vdd p105 W=13560n L=100n 
M2 out in gnd gnd n105 W=6780n L=100n 
.ends inv4

XINV1 vi vo1 inv1
XINV2 vo1 vo2 inv2
XINV3 vo2 vo3 inv3
XINV4 vo3 vo inv4

*define analysis voltage
vinput vi gnd pulse 0 vdd del trf trf pw per


*Q1: Part B: 
cload vo gnd 175.2256f

.model opt1 opt
.param wp = OPTrange(400n, 200n, 1000n)

.option CAPTAB=1

* EVEN BUFFERS --> tpHH - tpLL 
.measure tran tphh trig v(vi) val='vdd*0.5' rise=2 targ v(vo) val='vdd*0.5' rise=2
.measure tran tpll trig v(vi) val='vdd*0.5' fall=2 targ v(vo) val='vdd*0.5' fall=2
.measure tran tpd param='tphh-tpll' goal=0

* ODD buffers
*.measure tran tphl trig v(vi) val='vdd*0.5' rise=2 targ v(vo) val='vdd*0.5' fall=2
*.measure tran tplh trig v(vi) val='vdd*0.5' fall=2 targ v(vo) val='vdd*0.5' rise=2
*.measure tran tpd param='tphl-tplh' goal=0

.tran 1p '3*per' sweep optimize=OPTrange RESULTS=tpd MODEL=OPT1

.end

