lab2

*Iibrary file
.lib '/usr/cots/synopsys/UniversityLibrary/SAED32_EDK/tech/hspice/saed32nm.lib' TT
.include '/usr/cots/synopsys/UniversityLibrary/SAED32_EDK/lib/stdcell_rvt/hspice/saed32nm_rvt.spf'

*post the results
.option post
.GLOBAL gnd vdd

* Global Temp param (25 C)
.param temp=25


*syntax: Model_name Drain Gate Source Bulk Model (Width; Length; etc.)


* 1. Use the Ids Versus Vds graph (for fixed Vgs) to calculate the channel length 
* modulation coefficient (λ) (NMOS): 
* o Vgs: 1.05; Vds: [0,1.05] 
* o Hint: You can use your curve to solve λ. 
* o Use VLSI-transistor.pdf p.26 and p.28 as a reference
* Voltage sources for PMOS
vgs g gnd 1.05
vds d gnd 1.05
vbs b gnd 0

* NMOS Transistor
.model n105 nmos level=54
M1 d g gnd b n105 W=300n L=100n

 * p1 Vgs: 1.05; Vds: [0,1.05] (NMOS)
.dc vgs -1.1 0 0.01 sweep vds 0 1.05 0.5

* p2 Vgs: -1.1:0.2:0; Vds: [-1.1,0] (PMOS)
* .dc vds -1.1 0 0.01 sweep vgs -1.1 0 0.2 

* p3 Vgs: [-1.1:0]; Vds: -1.1(PMOS)
* .dc vgs -1.1 0 0.01 

* p4 Vgs: -1.1; Vds: -1.1; Vbs: [-1.1,1.1] (PMOS)
* .dc vbs -1.1 1.1 0.01 

*p5 Vds: [-1.1,0]; Vgs: -1.1(PMOS)
* .dc vds -1.1 0 0.01

*p6 Length: [50n,200n] Vds: 0.2
* .dc l_n 50n 200n 1n

*p7 Temp: [-55,125] Vds: 0.2
* .dc temp -55 125 1 




*** PROBING and PRINTING DIFFERENT VALUES ***

*probe transistor current (Ids) DC
* .PROBE DC i(M1) 
* .print DC i(M1)

*probe Channel Length (L) lv1
.PROBE lv1(M1)
.print lv1(M1)

*probe Channel Width (W) lv2
* .PROBE lv2(M1)

*probe Area of the Drain Diode (AD) lv3
* .PROBE lv3(M1)

*probe Area of the Source Diode (AS) lv4
* .PROBE lv4(M1)

*probe voltage threshold (Vt) lv9
.PROBE lv9(M1)  

*probe (Velocity) Saturation Voltage (VDSAT) lv10
* .PROBE lv10(M1)v

*probe Drain Diode Periphery (PD) lv11
* .PROBE lv11(M1)v

*probe Source Diode Periphery (PS) lv12
* .PROBE lv11(M1)v

.end