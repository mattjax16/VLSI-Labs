Inverter

*library file
.lib '/usr/cots/synopsys/UniversityLibrary/SAED32_EDK/tech/hspice/saed32nm.lib' TT
.include '/usr/cots/synopsys/UniversityLibrary/SAED32_EDK/lib/stdcell_rvt/hspice/saed32nm_rvt.spf'

*post the results
.option post
.GLOBAL gnd vdd

vgs g gnd 1.05
vds d gnd 1.05
vbs b gnd 0

.model n105 nmos level=54

M1 d g gnd b n105 W=300n L=100n
*syntax: Model_name Drain Gate Source Bulk Model (Width; Length; etc.)


vvdd vdd 0 1.05v
vgnd gnd 0 0v
      
.dc vds 0 1.05 0.01 sweep vgs 0 1.05 0.2         *Ids vs Vds

.dc vdstest 0 1.05 0.01 sweep vgs 0 1.05 0.2





.PROBE DC i(M1)                              *probe transistor current (Ids)
.PROBE lv9(M1)                                *probe threshold voltage  (Vt)
.end