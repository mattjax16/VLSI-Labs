lab01pmos.sp 
 
*Iibrary file 
.lib '/usr/cots/synopsys/UniversityLibrary/SAED32_EDK/tech/hspice/saed32nm.lib'$ 
.include '/usr/cots/synopsys/UniversityLibrary/SAED32_EDK/lib/stdcell_rvt/hspic$ 
 

.option post 
.GLOBAL gnd vdd 
 

* --- PMOS--- 
 

 

vgs g gnd -1.1 
vds d gnd -1.1 
vbs b gnd 0 
 

 

.param l_n=100 
 

* PMOS Transistor 
.model p105 pmos level=54 
M1 d g gnd b p105 W=300n L=l_n 
 

*syntax: Model_name Drain Gate Source Bulk Model (Width; Length; etc.) 
 

 

vvdd vdd 0 1.1v 
vgnd gnd 0 0v 
 

* Sweep Vgs from 0 to 1.1V for different Vds 
 

.dc vds -1.1 0 0.01 sweep vgs -1.1 0 0.2 
*.dc vgs -1.1 0 0.01 sweep vds -1.1 0 0.2 
*.dc vgs -1.1 0 0.01 
*.dc vbs -1.1 1.1 0.1 *body effect 
*.dc vds -1.1 0 0.01 *DBIL 
*.dc l_n 50n 200n 1n 
* .dc temp -55 125 5 
*probe transistor current (Ids) 
.PROBE DC i(M1) 
 

*prbe voltage threshold (Vt) 
* .PROBE lv9(M1) 
.end 