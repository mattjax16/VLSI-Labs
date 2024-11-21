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
* .param l = 100n

* M1 vo vi gnd gnd n105 W=300n L=l
* M2 vo vi vdd vdd p105 W=wp L=l


** for tranient analysis
.param trf = 6p *initial rise/fall time of the transient source
.param del = 2u *Defines the delay (del) before the pulse starts as 2 microsecond.
.param per = 10u *Defines the pulse width (pw) as 10 microsecond.
.param pw = 5u *Defines the period (per) of the pulse as 5 microseconds.

*define analysis voltage
vinput vi gnd pulse 0 vdd del trf trf pw per



**########### Question 1  Buffer Design###########**
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

** #### COMMENT OUT FOR C #### **
* * Making First Inverster
* .subckt inv1 in out
* * Not sure if for M1 should use vdd! or vdd or is it the same thing gives different 
* *result gussing it is wrong because doesnt match pdf
* * M1 out in vdd! vdd! p105 W=600n L=100n
* M1 out in vdd vdd p105 W=600n L=100n
* M2 out in gnd gnd n105 W=300n L=100n
* .ends

* * Connect the first inverter to main input and output
* XINV1 in out inv1


* Measure the input capacitance
.option CAPTAB=1
*** .PRINT CAP (all) ** Prob dont need prints all capacitance

* * Run the simulation for 30u
* .tran 1p 30u


**#### B ####**
* Connect a load capacitance at the end of the output of the inverter chain. Make
* the capacitance value 64 times larger than the value you just measured in step a.
* Code: cload out gnd 150f
* (CapName) (Nodes) (Value)

* Parameters and Calculating Load Capacitance
.param c_input = 2.7379f ** NOT sure wetheer to use 2.738E-15 or 2.7379f
.param c_load = (64 * c_input)

* Making Load Capacitance
* CLOAD out gnd c_load
* CLOAD out gnd 175.2256f * Pre calculated

* * Run the simulation for 30u
* .tran 1p 30u


**#### C ####**
* Use the schematic in p.41 as a reference and construct four inverter chains for N
* (number of stages) from 1 to 4. For the rest stages, you need to set the CMOS
* parameters for inverters (except the first one) based on the total number of
* stages and the design rule learnt in class.

* Define Scaling Factor for Transistor Widths
* Assuming each subsequent stage doubles the transistor widths
*: W_p=600n, W_n=300n for all stages then scaled by whatever factor specified


* Generic Inverter Subcircuit
.subckt inverter in out vdd gnd W_p=600n W_n=300n
    M_p out in vdd vdd p105 W=W_p L=100n
    M_n out in gnd gnd n105 W=W_n L=100n
.ends inverter



* --- Inverter Chain for N=1 ---
* Scales: 1
* Output Node: out1
XINV1_1 vi out1 vdd gnd inverter W_p=600n W_n=300n
* Load Capacitance
CLOAD1 out1 gnd c_load

* --- Inverter Chain for N=2 ---
* Scales: 1, 8
* Output Nodes: out2
XINV2_1 vi mid1 vdd gnd inverter W_p=600n W_n=300n * Scale = 1
XINV2_2 mid1 out2 vdd gnd inverter W_p=4800n W_n=2400n * Scale = 8
* Load Capacitance
CLOAD2 out2 gnd c_load

* --- Inverter Chain for N=3 ---
* Scales: 1, 4, 8
* Output Nodes: out3
XINV3_1 vi mid2 vdd gnd inverter W_p=600n W_n=300n * Scale = 1
XINV3_2 mid2 mid3 vdd gnd inverter W_p=2400n W_n=1200n * Scale = 4
XINV3_3 mid3 out3 vdd gnd inverter W_p=4800n W_n=2400n * Scale = 8
* Load Capacitance
CLOAD3 out3 gnd c_load

* --- Inverter Chain for N=4 ---
* Scales: 1, 2.8, 8, 22.6
* Output Nodes: out4
XINV4_1 vi mid4 vdd gnd inverter W_p=600n W_n=300n * Scale = 1
XINV4_2 mid4 mid5 vdd gnd inverter W_p=1680n W_n=840n * Scale = 2.8
XINV4_3 mid5 mid6 vdd gnd inverter W_p=4800n W_n=2400n * Scale = 8
XINV4_4 mid6 out4 vdd gnd inverter W_p=13560n W_n=6780n * Scale = 22.6
* Load Capacitance
CLOAD4 out4 gnd c_load


* Run the simulation for 30u
* .tran 1p 30u


*** MEASURE BUFFERS FOR ALL INVERTER CHAINS
** For ODD use tpHL - tpLH for EVEN use tpHH - tpLL
** Chain 1
.measure tran tphl_1 trig v(vi) val='vdd*0.5' rise=2 targ v(out1) val='vdd*0.5' fall=2 
.measure tran tplh_1 trig v(vi) val='vdd*0.5' fall=2 targ v(out1) val='vdd*0.5' rise=2
.measure tran tpd_1 param='tphl_1-tplh_1' goal=0
.measure tran tp_1 param='(tphl_1+tplh_1)/2' goal=0

** Chain 2
.measure tran tphh_2 trig v(vi) val='vdd*0.5' rise=2 targ v(out2) val='vdd*0.5' rise=2
.measure tran tpll_2 trig v(vi) val='vdd*0.5' fall=2 targ v(out2) val='vdd*0.5' fall=2
.measure tran tpd_2 param='tphh_2-tpll_2' goal=0
.measure tran tp_2 param='(tphh_2+tpll_2)/2' goal=0

** Chain 3
.measure tran tphl_3 trig v(vi) val='vdd*0.5' rise=2 targ v(out3) val='vdd*0.5' fall=2
.measure tran tplh_3 trig v(vi) val='vdd*0.5' fall=2 targ v(out3) val='vdd*0.5' rise=2
.measure tran tpd_3 param='tphl_3-tplh_3' goal=0
.measure tran tp_3 param='(tphl_3+tplh_3)/2' goal=0

** Chain 4
.measure tran tphh_4 trig v(vi) val='vdd*0.5' rise=2 targ v(out4) val='vdd*0.5' rise=2
.measure tran tpll_4 trig v(vi) val='vdd*0.5' fall=2 targ v(out4) val='vdd*0.5' fall=2
.measure tran tpd_4 param='tphh_4-tpll_4' goal=0
.measure tran tp_4 param='(tphh_4+tpll_4)/2' goal=0




**** Running Sim ****
.model opt1 opt
.param wp = OPTrange(400n, 200n, 1000n)

.tran 1p '3*per' sweep optimize=OPTrange RESULTS=tpd_1,tpd_2,tpd_3,tpd_4 MODEL=OPT1
* .tran 1p '3*per' sweep optimize=OPTrange RESULTS=tp_1,tp_2,tp_3,tp_4 MODEL=OPT1

.end


