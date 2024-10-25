lab2 NMOS
* when we are the PMOS BODY should not be conneceted to gnd but to vdd

*Iibrary file
.lib '/usr/cots/synopsys/UniversityLibrary/SAED32_EDK/tech/hspice/saed32nm.lib' TT
.include '/usr/cots/synopsys/UniversityLibrary/SAED32_EDK/lib/stdcell_rvt/hspice/saed32nm_rvt.spf'

*post the results
.option post
.GLOBAL gnd vdd

* Global Temp param (25 C)
.param temp=25


*** NMOS Transistor ***
vgs g gnd 1.05
vds d gnd 1.05
vbs b gnd 0

* NMOS Transistor
.model n105 nmos level=54
M1 d g gnd b n105 W=300n L=100n


*syntax: Model_name Drain Gate Source Bulk Model (Width; Length; etc.)


* 1. Use the Ids Versus Vds graph (for fixed Vgs) to calculate the channel length 
* modulation coefficient (λ) (NMOS): 
* o Vgs: 1.05; Vds: [0,1.05] 
* o Hint: You can use your curve to solve λ. 
* o Use VLSI-transistor.pdf p.26 and p.28 as a reference
* Vds: [0,1.05] (NMOS)
* .dc vds 0 1.05 0.01
* WE will look at Ids and Vt (DC and Lv9) for q 1


* Calculate velocity saturation (𝒄𝒐𝒙 ∗ 𝝂𝒔𝒂𝒕) (NMOS):
* o Vgs: 1.05; Vds:1.05; vbs:0;
* o Use VLSI-transistor.pdf p.31 as a reference
* .dc vds 1.05 1.05 1.05 vgs 1.05 1.05 1.05


* 3. Print a set of Saturation Voltage (𝑽𝑫𝑺𝒂𝒕) (NMOS): 
* o Vgs: 0:0.2:1.05; Vds:1.05; vbs:0; 
* o  Probe and print Lv9 and Lv10 to help
* o Show the results in ‘.lis’ file.  
* o Manually plot the set of 𝑉𝐷𝑆𝑎𝑡 dots on the Ids versus Vds plot for different Vgs, we 
* did this plot in the lab 2 assignment, part 2. (use Measurement Tool -> Data(x,y) 
* in WaveView)
.dc vds 0 1.05 0.001 sweep vgs 0 1.05 0.21 



*** PROBING and PRINTING DIFFERENT VALUES ***

*probe transistor current (Ids) DC
.PROBE DC i(M1) 
.print DC i(M1)

*probe Channel Length (L) lv1
.PROBE lv1(M1)
.print lv1(M1)

*probe Channel Width (W) lv2
.PROBE lv2(M1)
.print lv2(M1)

*probe Area of the Drain Diode (AD) lv3
* .PROBE lv3(M1)
* .print lv3(M1)

*probe Area of the Source Diode (AS) lv4
*  .PROBE lv4(M1)

*probe voltage threshold (Vt) lv9
.PROBE lv9(M1)  
.print lv9(M1)

*probe (Velocity) Saturation Voltage (VDSAT or VSAT) lv10
.PROBE lv10(M1)
.print lv10(M1)

*probe Drain Diode Periphery (PD) lv11
* .PROBE lv12(M1)

*probe Source Diode Periphery (PS) lv12
* .PROBE lv12(M1)

.end