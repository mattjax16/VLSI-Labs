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
.param trf = 4p *initial rise/fall time of the transient source
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

* Making First Inverster
.subckt inv1 in out
* Not sure if for M1 should use vdd! or vdd or is it the same thing?
* M1 out in vdd vdd p105 W=600n L=100n
M1 out in vdd! vdd! p105 W=600n L=100n
M2 out in gnd gnd n105 W=300n L=100n
.ends

* Connect the first inverter to main input and output
XINV1 vi vo inv1


* Measure the input capacitance
.option CAPTAB=1







**** FROM EXAMPLE ****
* .model opt1 opt
* .param wp = OPTrange(400n, 200n, 1000n)



* .measure tran tphl trig v(vi) val='vdd*0.5' rise=2 targ v(vo) val='vdd*0.5' fall=2
* .measure tran tplh trig v(vi) val='vdd*0.5' fall=2 targ v(vo) val='vdd*0.5' rise=2
* .measure tran tpd param='tphl-tplh' goal=0

* .tran 1p '3*per' sweep optimize=OPTrange RESULTS=tpd MODEL=OPT1

.end


