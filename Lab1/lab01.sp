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
vgs_nmos ng gnd 1.1
vds_nmos nd gnd 0
vbs_nmos nb gnd 0
vgs_pmos pg gnd -1.1
vds_pmos pd gnd 0
vbs_pmos pb gnd 0



* NMOS Transistor
.model n105 nmos level=54
.model p105 pmos level=54
M1 nd ng gnd nb n105 W=300n L=100n
M2 pd pg gnd pb p105 W=300n L=100n
*syntax: Model_name Drain Gate Source Bulk Model (Width; Length; etc.)



vvdd vdd 0 1.05v
vgnd gnd 0 0v

* Sweep Vgs from 0 to 1.1V for different Vds
.dc vgs_nmos 0 1.1 0.02 sweep vds_nmos 0 1.1 0.2

* Probe the drain current Ids for NMOS

*probe transistor current (Ids)
.PROBE DC i(M1) 

*probe voltage threshold (Vt)
.PROBE lv9(M1)  

* --- PMOS Section ---
* NOTE: doesnt work

* PMOS Transistor
*.model p105 pmos level=54
*M2 pd pg vdd vdd p105 W=300n L=100n
*syntax: Model_name Drain Gate Source Bulk Model (Width; Length; etc.)

* Voltage sources for PMOS
*vgs_pmos pg vdd 0
*vds_pmos pd vdd 0

* Sweep Vgs from -1.1V to 0V for different Vds
*.dc vgs_pmos -1.1 0 0.05 sweep vds_pmos -1.1 0 0.2

* Probe the drain current Ids for PMOS
*.PROBE DC i(M2)

.end