dsa
 

*library file 
.lib '/usr/cots/synopsys/UniversityLibrary/SAED32_EDK/tech/hspice/saed32nm.lib'$ 
.include '/usr/cots/synopsys/UniversityLibrary/SAED32_EDK/lib/stdcell_rvt/hspic$ 
 

*post the results 
.option post 
.GLOBAL gnd vdd 
 

vgs g gnd 1.1 
vds d gnd 0.2 
vbs b gnd 0 
.param l_n =20 
.model n105 nmos level=54 
 

M1 d g gnd b n105 W=300n L=100n 
*M1 d g gnd b n105 W=300n L=l_n 
 

*syntax: Model_name Drain Gate Source Bulk Model (Width; Length; etc.) 
 

vvdd vdd 0 1.1v 
vgnd gnd 0 0v 
 

 

*.dc vgs 0 1.1 0.01 sweep vds 0 1.1 0.2 
.dc vds 0 1.1 0.01 sweep vgs 0 1.1 0.2         
*.dc vbs -1.1 1.1 0.1 
*.dc vds 0 1.1 0.2 
*.dc l_n 20n 100n 1n 
*.dc temp -55 125 5 
 

.PROBE DC i(M1)                              
*.PROBE lv9(M1)                                *probe threshold voltage  (Vt) 
.end 