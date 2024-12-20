Inverter

*library file
.lib '/usr/cots/synopsys/UniversityLibrary/SAED32_EDK/tech/hspice/saed32nm.lib' TT
.include '/usr/cots/synopsys/UniversityLibrary/SAED32_EDK/lib/stdcell_rvt/hspice/saed32nm_rvt.spf'

*post the results
.option post * Comment out for q5 and 6
.global vdd gnd

*define model
.model n105 nmos level=54
.model p105 pmos level=54

*source declaration
vvdd vdd 0 vdd   *syntax:vname pos_node neg_node voltage_value
vgnd gnd 0 0v

*define parameters
** for transistors
.param vdd = 1.05 *Define the voltage value of Vdd as 1.05V.
.param l = 100n *Set the Length of the NMOS and PMOS as a constant: 100n
.param w_p = 300n *Defines the width of the PMOS transistor as 300n.
.param w_n = 300n *Defines the width of the NMOS transistor as 300n.

** for tranient analysis
.param trf = 6p *initial rise/fall time of the transient source
.param del = 1u *Defines the delay (del) before the pulse starts as 1 microsecond.
.param pw = 1u *Defines the pulse width (pw) as 1 microsecond.
.param per = 2u *Defines the period (per) of the pulse as 2 microseconds.

*MN
M1 vo vi gnd gnd n105 W=w_n L=l *Define the NMOS transistor with the given parameters.
* MP
M2 vo vi vdd vdd p105 W=w_p L=l *Define the PMOS transistor with the given parameters.



* First we will make the balance load inverters. The PMOS width is 600n.
* The NMOS width is 300n. The length of both transistors is 100n.
* Balance Load Inverter 1
M3 load_1_out vo gnd gnd n105 W=300n L=100n
M4 load_1_out vo vdd vdd p105 W=600n L=100n

* Balance Load Inverter 2
M5 load_2_out vo gnd gnd n105 W=300n L=100n
M6 load_2_out vo vdd vdd p105 W=600n L=100n

**########### Question 1 ###########**
* Construct a CMOS inverter. The first part includes the Vin and some basic
* parameters are given in the HSPICE code at the end of this file. For both nmos and
* pmos, w=300n, L=100n.
* M1 d g gnd! b n105 W=300n L=100n
*syntax: Model_name Drain Gate Source Bulk Model (Width; Length; etc.)
* Use ‘6p’ (trf) for all the rise time and fall time of the input pulse.

* define analysis voltage
vinput vi gnd pulse 0 vdd del trf trf pw per

**########### Question 2 ###########**
* 2. Definitions of waveforms: (Example code is attached at the end of the assignment)
* 𝒕𝒑𝑯𝑳： 𝑑𝑒𝑙𝑎𝑦 𝑓𝑟𝑜𝑚 𝑖𝑛𝑝𝑢𝑡 50% 𝑡𝑜 𝑜𝑢𝑡𝑢𝑝𝑡 50% 𝑤ℎ𝑒𝑛 𝑜𝑢𝑡𝑝𝑢𝑡 𝑖𝑠 𝒇𝒂𝒍𝒍𝒊𝒏𝒈.
* 𝒕𝒑𝑳𝑯： 𝑑𝑒𝑙𝑎𝑦 𝑓𝑟𝑜𝑚 𝑖𝑛𝑝𝑢𝑡 50% 𝑡𝑜 𝑜𝑢𝑡𝑢𝑝𝑡 50% 𝑤ℎ𝑒𝑛 𝑜𝑢𝑡𝑝𝑢𝑡 𝑖𝑠 𝒓𝒊𝒔𝒊𝒏𝒈
* First read the definitions of the waveform. Then measure the rise time and fall time
* of the output signal and propagation delay (𝑡𝑝𝐻𝐿 & 𝑡𝑝𝐿𝐻). Both of the information is
* measured via the second rising/falling edge of input voltage. Take a screenshot of
* the measurement result in the .lis file and attach it in the report.

*define analysis voltage
* vinput vi gnd pulse 0 vdd del trf trf pw per

* .tran 1p 6u
* .measure tran outrise 
* +trig v(vo) val='vdd*0.1' rise=2
* +targ v(vo) val='vdd*0.9' rise=2

* .measure tran outfall 
* +trig v(vo) val='vdd*0.9' fall=2
* +targ v(vo) val='vdd*0.1' fall=2

* .measure tran tphl 
* +trig v(vi) val='vdd*0.5' rise=2
* +targ v(vo) val='vdd*0.5' fall=2

* .measure tran tplh 
* +trig v(vi) val='vdd*0.5' fall=2
* +targ v(vo) val='vdd*0.5' rise=2


**########### Question 3 ###########**
* 3. Analyze the DC characteristic of the CMOS inverter (one graph):
* a. Set the Length of the NMOS and PMOS as a constant: 100n; 
*    Width of the NMOS as a constant: 300n.
* b. DC analysis the VIN (x axis) from 0 to 1.05v with a step of 0.01v
* c. Change the Beta ratio of the NMOS and PMOS by sweeping the 
*    Width of PMOS from 100n to 1000n with a step of 100n.
* d. View the VOUT (y axis) plot.
**NOTE lines in graph are for increasing width as you go from left to right**

* *define analysis voltage
*  vinput vi gnd pulse 0 vdd del trf trf pw per
* .dc vinput 0 1.05 0.01 sweep w_p 100n 1000n 100n
* .PROBE vout
* .print v(vo) w_p sweep_vin=vinput





**########### Question 4 ###########**
* Use the measurement tool (shown below) and the graph in problem 3 to find the 
* closest Width value of the PMOS that has the Switching Threshold closest to half 
* of the Vdd (Vdd/2). We will use this balanced inverter for the following tasks. 

* *define analysis voltage
*  vinput vi gnd pulse 0 vdd del trf trf pw per
* .dc vinput 0 1.05 0.01 sweep w_p 100n 1000n 100n
* .print v(vo) w_p sweep_vin=vinput



**########### Question 5 ###########**
* Set the Width of the PMOS to be the value you found in part 4.In this part, you are
* required to discover one of the characteristics of the CMOS inverter: delay(Tp) as a
* function of Vdd. Now set the Width of the PMOS to be the value you found in part 4.
* Use the HSPICE .alter command to change the value of the parameter ‘vdd’ so that
* the supply voltage will change: 0.5:0.1:1.05
* ** The Width I found was 600n
* .param w_p = 600n

* * * * define analysis voltage
* vinput vi gnd pulse 0 vdd del trf trf pw per

* * *start to use .alter to run the hspice code multiple times
* * ** Measuring on the second rising and falling edge like in q2**
* * ** 1
* .alter
* .param vdd = 0.5
* .tran 1p 6u
* .measure tran tphl 
* +trig v(vi) val='vdd*0.5' rise=2
* +targ v(vo) val='vdd*0.5' fall=2
* .measure tran tplh 
* +trig v(vi) val='vdd*0.5' fall=2
* +targ v(vo) val='vdd*0.5' rise=2

* ** 2
* .alter
* .param vdd = 0.6
* .tran 1p 6u
* .measure tran tphl 
* +trig v(vi) val='vdd*0.5' rise=2
* +targ v(vo) val='vdd*0.5' fall=2
* .measure tran tplh 
* +trig v(vi) val='vdd*0.5' fall=2
* +targ v(vo) val='vdd*0.5' rise=2

* ** 3
* .alter
* .param vdd = 0.7
* .tran 1p 6u
* .measure tran tphl 
* +trig v(vi) val='vdd*0.5' rise=2
* +targ v(vo) val='vdd*0.5' fall=2
* .measure tran tplh 
* +trig v(vi) val='vdd*0.5' fall=2
* +targ v(vo) val='vdd*0.5' rise=2

* ** 4
* .alter
* .param vdd = 0.8
* .tran 1p 6u
* .measure tran tphl 
* +trig v(vi) val='vdd*0.5' rise=2
* +targ v(vo) val='vdd*0.5' fall=2
* .measure tran tplh 
* +trig v(vi) val='vdd*0.5' fall=2
* +targ v(vo) val='vdd*0.5' rise=2

* ** 5
* .alter
* .param vdd = 0.9
* .tran 1p 6u
* .measure tran tphl 
* +trig v(vi) val='vdd*0.5' rise=2
* +targ v(vo) val='vdd*0.5' fall=2
* .measure tran tplh 
* +trig v(vi) val='vdd*0.5' fall=2
* +targ v(vo) val='vdd*0.5' rise=2

* ** 6
* .alter
* .param vdd = 1.05
* .tran 1p 6u
* .measure tran tphl 
* +trig v(vi) val='vdd*0.5' rise=2
* +targ v(vo) val='vdd*0.5' fall=2
* .measure tran tplh 
* +trig v(vi) val='vdd*0.5' fall=2
* +targ v(vo) val='vdd*0.5' rise=2


**########### Question 6 ###########**
* In this part, you are required to plot the device sizing versus delay Tp, similar to the
* graph that is on the p.30 in the VLSI-CMOS inverter.pdf. Similar to part 5, where you
* need to measure Tp with different Vdd, here you need to measure Tp with different
* size of CMOS inverter:
* 1:1:6 multiples of the width (both nmos and pmos) in the balanced inverter you
* obtained in part 3.
* Also, keep the length fixed and connect the output of the balanced inverter to a load
* (two balanced inverters which are exactly the same as you obtained in part 4) (see
* the schematic below). Also, similar to the part 5, you need to .alter command. Then,
* use appropriate tool to plot the data (Width being X axis, and Tp being Y axis). 
* ** The Width I found was 600n
.param w_p = 600n



* * * * define analysis voltage
vinput vi gnd pulse 0 vdd del trf trf pw per

* *start to use .alter to run the hspice code multiple times
* ** Measuring on the second rising and falling edge like in q2**
* ** 1
.alter
.param w_n = 300n
.param w_p = 600n
.tran 1p 6u
.measure tran tphl 
+trig v(vi) val='vdd*0.5' rise=2
+targ v(vo) val='vdd*0.5' fall=2
.measure tran tplh 
+trig v(vi) val='vdd*0.5' fall=2
+targ v(vo) val='vdd*0.5' rise=2

** 2
.alter
.param w_n = 600n
.param w_p = 1200n
.tran 1p 6u
.measure tran tphl 
+trig v(vi) val='vdd*0.5' rise=2
+targ v(vo) val='vdd*0.5' fall=2
.measure tran tplh 
+trig v(vi) val='vdd*0.5' fall=2
+targ v(vo) val='vdd*0.5' rise=2

** 3
.alter
.param w_n = 900n
.param w_p = 1800n
.tran 1p 6u
.measure tran tphl 
+trig v(vi) val='vdd*0.5' rise=2
+targ v(vo) val='vdd*0.5' fall=2
.measure tran tplh 
+trig v(vi) val='vdd*0.5' fall=2
+targ v(vo) val='vdd*0.5' rise=2

** 4
.alter
.param w_n = 1200n
.param w_p = 2400n
.tran 1p 6u
.measure tran tphl 
+trig v(vi) val='vdd*0.5' rise=2
+targ v(vo) val='vdd*0.5' fall=2
.measure tran tplh 
+trig v(vi) val='vdd*0.5' fall=2
+targ v(vo) val='vdd*0.5' rise=2

** 5
.alter
.param w_n = 1500n
.param w_p = 3000n
.tran 1p 6u
.measure tran tphl 
+trig v(vi) val='vdd*0.5' rise=2
+targ v(vo) val='vdd*0.5' fall=2
.measure tran tplh 
+trig v(vi) val='vdd*0.5' fall=2
+targ v(vo) val='vdd*0.5' rise=2

** 6
.alter
.param w_n = 1800n
.param w_p = 3600n
.tran 1p 6u
.measure tran tphl 
+trig v(vi) val='vdd*0.5' rise=2
+targ v(vo) val='vdd*0.5' fall=2
.measure tran tplh 
+trig v(vi) val='vdd*0.5' fall=2
+targ v(vo) val='vdd*0.5' rise=2




.end


