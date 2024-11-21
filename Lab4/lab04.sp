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


*define parameters
** for transistors
.param vdd = 1.05


** for tranient analysis
.param trf = 6p *initial rise/fall time of the transient source
.param del = 2u *Defines the delay (del) before the pulse starts as 2 microsecond.
.param per = 10u *Defines the pulse width (pw) as 10 microsecond.
.param pw = 5u *Defines the period (per) of the pulse as 5 microseconds.

*define analysis voltage
vinput vi gnd pulse 0 vdd del trf trf pw per



**########### Question 1  Buffer Design ###########**
**#### A ####**
** Build an inverter as the first stage of your inverter chain (NMOS: 300n/100n;
** PMOS: 600n/100n). Measure the input Capacitance at the first stage. HSPICE
** command ‘.option CAPTAB=1’ can measure all the node capacitances. You need
** to find the measured input capacitances in the ‘.lis’ file (search for “capacitance”).
** Since for each inverter chain you will have multiple different CMOS, therefore it is
** suggested to write sub-circuits in the HSPICE file. An example (N = 2) is given
** below:
** .subckt inv1 in out
** M1 out in vdd! vdd! p105 W=600n L=100n
** M2 …
** .ends
** .subckt inv2 in out
** M1 …
** M2 …
** .ends
** XINV1 in out1 inv1
** XINV2 out1 out inv2

**** Generic Inverter Subcircuit
.subckt inverter in out vdd gnd W_p=600n W_n=300n
    M_p out in vdd vdd p105 W=W_p L=100n
    M_n out in gnd gnd n105 W=W_n L=100n
.ends inverter

*** COMMENT OUT FOR PART C  dont forget to use tran 30u
* * Connect the first inverter to main input and output
* XINV vi vo vdd gnd inverter W_p=600n W_n=300n


* Measure the input capacitance
.option CAPTAB=1

* * Run the simulation for 30u
* .tran 1p 30u


**#### B ####**
* Connect a load capacitance at the end of the output of the inverter chain. Make
* the capacitance value 64 times larger than the value you just measured in step a.
* Code: cload out gnd 150f
* (CapName) (Nodes) (Value)

* Parameters and Calculating Load Capacitance
.param c_input = 2.7379f 
.param c_load = (64 * c_input) ** 175.2256f Pre calculated

* Load Capacitance
* CLOAD vo gnd c_load

* * Run the simulation for 30u
* .tran 1p 30u


**#### C ####**
* Use the schematic in p.41 as a reference and construct four inverter chains for N
* (number of stages) from 1 to 4. For the rest stages, you need to set the CMOS
* parameters for inverters (except the first one) based on the total number of
* stages and the design rule learnt in class.

*** COMMENT OUT FOR EACH INVERTER CHAIN ****
* Define Scaling Factor for Transistor Widths
* Assuming each subsequent stage doubles the transistor widths
*: W_p=600n, W_n=300n for all stages then scaled by whatever factor specified
* * --- Inverter Chain for N=1 ---
* * Scales: 1
* XINV_1 vi vo vdd gnd inverter W_p=600n W_n=300n


* * --- Inverter Chain for N=2 ---
* * Scales: 1, 8
* XINV_1 vi out1 vdd gnd inverter W_p=600n W_n=300n * Scale = 1
* XINV_2 out1 vo vdd gnd inverter W_p=4800n W_n=2400n * Scale = 8


* * --- Inverter Chain for N=3 ---
* * Scales: 1, 4, 8
* XINV_1 vi out1 vdd gnd inverter W_p=600n W_n=300n * Scale = 1
* XINV_2 out1 out2 vdd gnd inverter W_p=2400n W_n=1200n * Scale = 4
* XINV_3 out2 vo vdd gnd inverter W_p=4800n W_n=2400n * Scale = 8


* * * --- Inverter Chain for N=4 ---
* * * Scales: 1, 2.8, 8, 22.6
* XINV_1 vi out1 vdd gnd inverter W_p=600n W_n=300n * Scale = 1
* XINV_2 out1 out2 vdd gnd inverter W_p=1680n W_n=840n * Scale = 2.8
* XINV_3 out2 out3 vdd gnd inverter W_p=4800n W_n=2400n * Scale = 8
* XINV_4 out3 vo vdd gnd inverter W_p=13560n W_n=6780n * Scale = 22.6


* * Load Capacitance
* CLOAD vo gnd c_load


**#### D ####**
* Measure the Delay (Tp) for each inverter chain (final output) and here you still
* need to measure both tpHL and tpLH in order to get the delay Tp. Draw a table
* similar to the one in p.40 in the VLSI-CMOS Inverter.pdf.

*** MEASURE BUFFERS FOR ALL INVERTER CHAINS
** For ODD use tpHL - tpLH for EVEN use tpHH - tpLL
** Chain 1 and Chain 3
* .measure tran tphl trig v(vi) val='vdd*0.5' rise=2 targ v(vo) val='vdd*0.5' fall=2 
* .measure tran tplh trig v(vi) val='vdd*0.5' fall=2 targ v(vo) val='vdd*0.5' rise=2
* .measure tran tp param='(tphl+tplh)/2' goal=0

* * ** Chain 2 and Chain 4
* .measure tran tphh trig v(vi) val='vdd*0.5' rise=2 targ v(vo) val='vdd*0.5' rise=2
* .measure tran tpll trig v(vi) val='vdd*0.5' fall=2 targ v(vo) val='vdd*0.5' fall=2
* .measure tran tp param='(tphh+tpll)/2' goal=0


** Running Sim
* .tran 1p '3*per' sweep optimize=OPTrange RESULTS=tp MODEL=OPT1




**########### Question 2 Optimizing PMOS Width in a CMOS Inverter for Balanced and Minimal Propagation Delays ###########**
* Construct a CMOS inverter. Make the width (300n) and length (100n) fixed for
* NMOS, and length (100n) fixed for PMOS. Using the HSPICE Optimization tool, find
* the width of the PMOS for each of the following requirements:
* a. Make 𝑡𝑝𝐿𝐻 − 𝑡𝑝𝐻𝐿 as close to zero as possible
* b. Have the smallest average propagation delay (hint: make (𝑡𝑝𝐿𝐻 + 𝑡𝑝𝐻𝐿)/2 as
* close to zero as possible)

* Making inverter to be optimized
XINV vi vo vdd gnd inverter W_p=wp W_n=300n

* Load Capacitance
CLOAD vo gnd c_load

* Optimization Model
.model opt1 opt
.param wp = OPTrange(400n, 200n, 1000n)


*** Part A: Optimize for tpLH - tpHL = 0
* .measure tran tphl trig v(vi) val='vdd*0.5' rise=2 targ v(vo) val='vdd*0.5' fall=2
* .measure tran tplh trig v(vi) val='vdd*0.5' fall=2 targ v(vo) val='vdd*0.5' rise=2
* .measure tran tpd param='tplh-tphl' goal=0
* .tran 1p '3*per' sweep optimize=optrange results=tpd model=OPT1 * Run optimization

*** Comment out Part A and uncomment Part B for second optimization
*** Part B: Optimize for minimum average delay tp = (tpHL + tpLH) / 2
.measure tran tphl trig v(vi) val='vdd*0.5' rise=2 targ v(vo) val='vdd*0.5' fall=2
.measure tran tplh trig v(vi) val='vdd*0.5' fall=2 targ v(vo) val='vdd*0.5' rise=2
.measure tran tp param='(tplh+tphl)/2' goal=0
.tran 1p '3*per' sweep optimize=optrange results=tp model=OPT1 * Run optimization



**########### Question 3 Optimizing PMOS Width in a CMOS Inverter for  Switching Threshold in a Balanced CMOS Inverter ###########**
* Use the same CMOS inverter setting in Problem 2. Use the HSPICE Optimization
* tool to find the width of the PMOS for the following requirement:
* a. Switching threshold (Vm) equals to half of Vdd. (Balanced Inverter)
* You will need to use a new measure command. An example is given below:
* .Dc vc 0 1.2 0.02 sweep optimize=optrange2 Results=wid Model=opt1
* .measure DC wid FIND V(2) WHEN V(1)='0.1*Vdd'
*Then you can run optimization on this measurement
*.MEASURE <DC|TRAN|AC> result FIND out_var1 WHEN out_var2 = out_var3
*+ <TD = val > < RISE = r | LAST > < FALL = f | LAST >
*+ <CROSS = c | LAST> <GOAL = val> <MINVAL = val> <WEIGHT = val>
*this command find the voltage value at node ‘2’ when the voltage value at node ‘1’
* equals *0.1*Vdd


* * Measure Switching Threshold (Vm) = Vdd/2
* .measure dc vm find v(vi) when v(vo)='0.5*vdd' goal='vdd/2'

* * DC sweep with optimization
* .dc vi 0 1.05 0.01 sweep optimize=OPTrange results=vm model=OPT1

.end
