NMOS Transistor Simulations

*Iibrary file
.lib '/usr/cots/synopsys/UniversityLibrary/SAED32_EDK/tech/hspice/saed32nm.lib' TT
.include '/usr/cots/synopsys/UniversityLibrary/SAED32_EDK/lib/stdcell_rvt/hspice/saed32nm_rvt.spf'

*post the results
.option post
.GLOBAL gnd vdd

* Param for testing length
.param l_n=100
.param temp=27



* Voltage sources for NMOS
vgs g gnd 1.1
vbs b gnd 0
vds d gnd 1.1
* Uncomment Out below for length problem (un comment above for rest)
* vds d gnd 0.2




* NMOS Transistor
.model n105 nmos level=54
M1 d g gnd b n105 W=300n L=l_n

*syntax: Model_name Drain Gate Source Bulk Model (Width; Length; etc.)



vvdd vdd 0 1.1v
vgnd gnd 0 0v



* p1 Vgs: [0, 1.1]; Vds: 0: 0.2: 1.1 (NMOS)(min:step:max)
.dc vgs 0 1.1 0.01 sweep vds 0 1.1 0.2

* p2 Vgs: 0:0.2:1.1; Vds: [0,1.1] (NMOS)
* .dc vds 0 1.1 0.01 sweep vgs 0 1.1 0.2

* p3 Vgs: [0,1.1]; Vds: 1.1 (NMOS)
* .dc vgs 0 1.1 0.01 

* p4 Vgs: 1.1; Vds: 1.1; Vbs: [-1.1,1.1] (NMOS)
* .dc vbs -1.1 1.1 0.01 

*p5 Vds: [0, 1.1]; Vgs: 1.1 (NMOS)
* .dc vds 0 1.1 0.01 

*p6 Length: [50n,200n] Vds: 0.2
* .dc l_n 50n 200n 1n

*p7 Temp: [-55,125] Vds: 0.2
* .dc temp -55 125 1 

* Probe the drain current Ids for NMOS

*probe transistor current (Ids)
.PROBE DC i(M1) 

*probe voltage threshold (Vt)
.PROBE lv9(M1)  

.end