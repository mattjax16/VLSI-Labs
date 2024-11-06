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

*define parameters
.param vdd = 5
*.param vdd = 1.05
.param l = 100n
.param trf = 6p *initial rise/fall time of the transient source
.param del = 1u 
.param pw = 1u
.param per = 2u

*source declaration
vvdd vdd 0 vdd   *syntax:vname pos_node neg_node voltage_value
vgnd gnd 0 0v


*transitors deceration
*NMOS
M1 vo vi gnd gnd n105 W=300n L=l 
*PMOS
M2 vo vi vdd vdd p105 W=300n L=l


** QUESTION 1 **
* Construct a CMOS inverter. The first part includes the Vin and some basic
* parameters are given in the HSPICE code at the end of this file. For both nmos and
* pmos, w=300n, L=100n.
* M1 d g gnd! b n105 W=300n L=100n
*syntax: Model_name Drain Gate Source Bulk Model (Width; Length; etc.)
* Use ‘6p’ for all the rise time and fall time of the input pulse.

*define analysis voltage
vinput vi gnd pulse 0 vdd 5u 0.5u 0.5u 4.5u 10u

*.tran 1p 6u
.tran 1p 40u
.measure tran outrise 
+trig v(vo) val='vdd*0.1' rise=trf
+targ v(vo) val='vdd*0.9' rise=trf

.measure tran outfall 
+trig v(vo) val='vdd*0.9' fall=trf
+targ v(vo) val='vdd*0.1' fall=trf

** QUESTION 2 **
* 2. Definitions of waveforms: (Example code is attached at the end of the assignment)
* 𝒕𝒑𝑯𝑳： 𝑑𝑒𝑙𝑎𝑦 𝑓𝑟𝑜𝑚 𝑖𝑛𝑝𝑢𝑡 50% 𝑡𝑜 𝑜𝑢𝑡𝑢𝑝𝑡 50% 𝑤ℎ𝑒𝑛 𝑜𝑢𝑡𝑝𝑢𝑡 𝑖𝑠 𝒇𝒂𝒍𝒍𝒊𝒏𝒈.
* 𝒕𝒑𝑳𝑯： 𝑑𝑒𝑙𝑎𝑦 𝑓𝑟𝑜𝑚 𝑖𝑛𝑝𝑢𝑡 50% 𝑡𝑜 𝑜𝑢𝑡𝑢𝑝𝑡 50% 𝑤ℎ𝑒𝑛 𝑜𝑢𝑡𝑝𝑢𝑡 𝑖𝑠 𝒓𝒊𝒔𝒊𝒏𝒈
* First read the definitions of the waveform. Then measure the rise time and fall time
* of the output signal and propagation delay (𝑡𝑝𝐻𝐿 & 𝑡𝑝𝐿𝐻). Both of the information is
* measured via the second rising/falling edge of input voltage. Take a screenshot of
* the measurement result in the .lis file and attach it in the report.

*define analysis voltage
vinput vi gnd pulse 0 vdd 5u 0.5u 0.5u 4.5u 10u

*.tran 1p 6u
.tran 1p 40u
.measure tran outrise 
+trig v(vo) val='vdd*0.5' rise=trf
+targ v(vo) val='vdd*0.5' rise=trf

.measure tran outfall 
+trig v(vo) val='vdd*0.5' fall=trf
+targ v(vo) val='vdd*0.5' fall=trf

** Question 3 **
* 3. Analyze the DC characteristic of the CMOS inverter (one graph):
* a. Set the Length of the NMOS and PMOS as a constant: 100n; 
*    Width of the NMOS as a constant: 300n.
* b. DC analysis the VIN (x axis) from 0 to 1.05v with a step of 0.01v
* c. Change the Beta ratio of the NMOS and PMOS by sweeping the 
*    Width of PMOS from 100n to 1000n with a step of 100n.
* d. View the VOUT (y axis) plot.

*************************************************************************************
*define analysis voltage
*vinput vi gnd pulse 0 vdd del trf trf pw per
* vinput vi gnd pulse 0 vdd 5u 0.5u 0.5u 4.5u 10u
*.tran 1p 6u
.tran 1p 40u
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


