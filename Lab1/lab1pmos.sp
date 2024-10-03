** THIS IS FROM ALIAH
* Combined NMOS and PMOS Ids vs Vgs for different Vds

*Iibrary file
.lib '/usr/cots/synopsys/UniversityLibrary/SAED32_EDK/tech/hspice/saed32nm.lib' TT
.include '/usr/cots/synopsys/UniversityLibrary/SAED32_EDK/lib/stdcell_rvt/hspice/saed32nm_rvt.spf'

*post the results
.option post
.GLOBAL gnd vdd

* --- NMOS Section ---

* Voltage sources for NMOS
vgs g gnd -1.1
vds d gnd -1.1
vbs b gnd 0




* PMOS Transistor
.model p105 pmos level=54
M1 d g gnd b p105 W=300n L=100n

*syntax: Model_name Drain Gate Source Bulk Model (Width; Length; etc.)



vvdd vdd 0 1.1v
vgnd gnd 0 0v

* Sweep Vgs from 0 to 1.1V for different Vds
* .dc vgs -1.1 0 0.02 
.dc vds -1.1 0 sweep vgs -1.1 0 0.2

* Probe the drain current Ids for NMOS

*probe transistor current (Ids)
.PROBE DC i(M1) 

*probe voltage threshold (Vt)
.PROBE lv9(M1)  

.end