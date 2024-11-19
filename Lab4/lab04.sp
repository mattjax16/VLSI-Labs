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
* Stage 1: W_p=600n, W_n=300n
* Stage 2: W_p=1200n, W_n=600n
* Stage 3: W_p=2400n, W_n=1200n
* Stage 4: W_p=4800n, W_n=2400n
** This assumption is wrong i need to go back and calc **

* Generic Inverter Subcircuit
.subckt inverter in out vdd gnd W_p=600n W_n=300n
    M_p out in vdd vdd p105 W=W_p L=100n
    M_n out in gnd gnd n105 W=W_n L=100n
.ends inverter



* --- Inverter Chain for N=1 ---
* Output Node: out1
XINV1_1 vi out1 vdd gnd inverter W_p=600n W_n=300n
* Load Capacitance
CLOAD1 out1 gnd c_load

* --- Inverter Chain for N=2 ---
* Output Nodes: out2
XINV2_1 vi mid1 vdd gnd inverter W_p=600n W_n=300n
XINV2_2 mid1 out2 vdd gnd inverter W_p=1200n W_n=600n
* Load Capacitance
CLOAD2 out2 gnd c_load

* --- Inverter Chain for N=3 ---
* Output Nodes: out3
XINV3_1 vi mid2 vdd gnd inverter W_p=600n W_n=300n
XINV3_2 mid2 mid3 vdd gnd inverter W_p=1200n W_n=600n
XINV3_3 mid3 out3 vdd gnd inverter W_p=2400n W_n=1200n
* Load Capacitance
CLOAD3 out3 gnd c_load

* --- Inverter Chain for N=4 ---
* Output Nodes: out4
XINV4_1 vi mid4 vdd gnd inverter W_p=600n W_n=300n
XINV4_2 mid4 mid5 vdd gnd inverter W_p=1200n W_n=600n
XINV4_3 mid5 mid6 vdd gnd inverter W_p=2400n W_n=1200n
XINV4_4 mid6 out4 vdd gnd inverter W_p=4800n W_n=2400n
* Load Capacitance
CLOAD4 out4 gnd c_load


* Run the simulation for 30u
.tran 1p 30u


**** FROM EXAMPLE ****
* .model opt1 opt
* .param wp = OPTrange(400n, 200n, 1000n)



* .measure tran tphl trig v(vi) val='vdd*0.5' rise=2 targ v(vo) val='vdd*0.5' fall=2
* .measure tran tplh trig v(vi) val='vdd*0.5' fall=2 targ v(vo) val='vdd*0.5' rise=2
* .measure tran tpd param='tphl-tplh' goal=0

* .tran 1p '3*per' sweep optimize=OPTrange RESULTS=tpd MODEL=OPT1

.end


