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

M1 vo vi gnd gnd n105 W=300n L=l
M2 vo vi vdd vdd p105 W=p_w L=l

*define parameters
.param vdd = 1.05
*.param vdd = 1.05
.param l = 100n
.param trf = 6p *initial rise/fall time of the transient source
.param del = 1u 
.param pw = 1u
.param per = 2u
.param p_w = 300n

*define analysis voltage

*vinput vi gnd pulse 0 vdd del trf trf pw per
*vinput vi gnd pulse 0 vdd 5u 0.5u 0.5u 4.5u 10u

* Q1: Construct a CMOS inverter
*Use ‘6p’ for all the rise time and fall time of the input pulse

* vinput vi gnd pulse 0 vdd 5u trf trf 4.5u 10u

* .tran 1p 6u
* .tran 1p 20u
* .measure tran outrise 
* +trig v(vo) val='vdd*0.1' rise=trf
* +targ v(vo) val='vdd*0.9' rise=trf

* .measure tran outfall 
* +trig v(vo) val='vdd*0.9' fall=trf
* +targ v(vo) val='vdd*0.1' fall=trf


*Q2: Then measure the rise time and fall time of the output signal and propagation delay

vinput vi gnd pulse 0 vdd 5u trf trf 4.5u 10u

*.tran 1p 6u
.tran 1p 40u
.measure tran tphl 
+trig v(vi) val='vdd*0.5' rise=trf
+targ v(vo) val='vdd*0.5' fall=trf

.measure tran tplh 
+trig v(vi) val='vdd*0.5' fall=trf
+targ v(vo) val='vdd*0.5' rise=trf

*Q3: DC characteristic of the CMOS inverter
* Length of the NMOS and PMOS as a constant: 100n; 
* Width of the NMOS as a constant: 300n. 
* DC analysis the VIN (x axis) from 0 to 1.05v with a step of 0.01v
* sweeping the Width of PMOS from 100n to 1000n with a step of 100n
*vinput vi gnd pulse 0 vdd 5u trf trf 4.5u 10u
*.dc vinput 0 1.05 0.01 sweep p_w 100n 1000n 100n
*.PROBE vout



*.tran 1p 6u
*.tran 1p 40u
*.measure tran outrise 
*+trig v(vo) val='vdd*0.1' rise=2
*+targ v(vo) val='vdd*0.9' rise=2

*.measure tran outfall 
*+trig v(vo) val='vdd*0.9' fall=2
*+targ v(vo) val='vdd*0.1' fall=2

*.measure tran tphl 
*+trig v(vi) val='vdd*0.5' rise=2
*+targ v(vo) val='vdd*0.5' fall=2

*.measure tran tplh 
*+trig v(vi) val='vdd*0.5' fall=2
*+targ v(vo) val='vdd*0.5' rise=2

.end

