PMOS Transistor Simulations

*Iibrary file
.lib '/usr/cots/synopsys/UniversityLibrary/SAED32_EDK/tech/hspice/saed32nm.lib' TT
.include '/usr/cots/synopsys/UniversityLibrary/SAED32_EDK/lib/stdcell_rvt/hspice/saed32nm_rvt.spf'

*post the results
.option post
.GLOBAL gnd vdd

* Params for testing length and temp
* .param l_n=100
* .param temp=27



* Voltage sources for PMOS
vgs g gnd -1.1
vds d gnd -1.1
vbs b gnd 0

* Uncomment Out below for length problem (un comment above for rest)
* vds d gnd 0.2




* PMOS Transistor
.model p105 pmos level=54
M1 d g gnd b p105 W=300n L=100

*syntax: Model_name Drain Gate Source Bulk Model (Width; Length; etc.)



vvdd vdd 0 1.1v
vgnd gnd 0 0v

* p1 Vgs: [-1.1, 0]; Vds: -1.1: 0.2: 0 (PMOS)
.dc vgs -1.1 0 0.01 sweep vds -1.1 0 0.2

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

* Probe the drain current Ids for NMOS

*probe transistor current (Ids)
.PROBE DC i(M1) 

*probe voltage threshold (Vt)
* .PROBE lv9(M1)  

.end