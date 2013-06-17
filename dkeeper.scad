// dkeeper
// Mark K Malmros 12June2013
// for FireFly project
// revised: 2 top level modules - dkeeper & dkeeper_basic
// uncomment one or the other
// "parameters"

dia = 9.525; // tubing ID = keeper diameter
len = 12.4; // keeper length (nominal 12.35)
w_dip = 6.4; // width of DIP package (nominal 6.34)
l_dip = 9.4; // length of DIP package (nominal 9.34)
d_dip = 3.4; // thickness of DIP package (nominal 3.34)
d_wire = 0.4; // lead wire "diameter" as square holes
pin_dia = 0.50; // diameter of "round" wire transverse pin holes (to dip pins)
d_pin = 0.31; // depth of pin relief ("dip pad")
w_pin = (dia/2 - w_dip/2)*1.08; // lateral width of "dip pad" based on DIP & keeper widths
w_ipin = 1.8; // width of inner pin relief
w_opin = 1.3; // width of end pin relief ("dip pad")

// module library

module half_dip(){  
	difference()
		{	cube(size=[d_dip/2,w_dip,l_dip], center=true);
		// bevel dip cavity 15 degrees from vertical
			translate([0, d_dip,0])rotate(105)cube(size=[d_dip/4,w_dip/2,9.35], center=true);
			mirror([0,1,0])translate([0, d_dip,0])rotate(105)cube(size=[d_dip/4,w_dip/2,9.35], center=true);
		};
				 }

module dip_ipad(){  
		cube(size=[d_pin, w_pin, w_ipin],center=true);  // * 1.05 to oversize for sufficient removal by difference
		}

module dip_opad(){
		cube(size=[d_pin, w_pin , w_opin],center=true);
		}

module pin_relief(){
	translate([-(d_pin/2 -0.01),(dia/2) - w_pin/2 , .475 + (w_ipin/2) ])dip_ipad();
	mirror([0,0,1])translate([-(d_pin/2 -0.01),(dia/2) - w_pin/2 , .475 + (w_ipin/2)])dip_ipad();
	translate([-(d_pin/2 -0.01),(dia/2) - w_pin/2 ,w_pin *2 + w_opin/4])dip_opad();
	mirror([0,0,1])translate([-(d_pin/2 -0.01),(dia/2) - w_pin/2 , w_pin *2 + w_opin/4])dip_opad();
					}
module reliefs(){
	pin_relief();
	mirror([0,1,0])pin_relief();
				}

module pin_trace(){
	translate([0,4.7625,(0.475 + 0.89)])
	rotate(a=[90,90,90]) 
	cylinder(h = 12.7, r= 0.25, center = true);

	translate([0,4.7625,(0.475 + 0.89 + 1.78 + 0.475)])
	rotate(a=[90,90,90]) 
	cylinder(h = 12.7, r=0.25, center = true);
					}

module pin_traces() {
		pin_trace();
		mirror([0,0,1])pin_trace();
					}	
module pins()	{
		pin_traces();
		mirror([0,1,0])pin_traces();
				}	

module lead_traces() {
		translate([-(d_dip/2 + (d_wire *2) -0.01),1.5,-len/2])cube(size=[d_wire *2 ,d_wire,len *1.05]);
		mirror([0,1,0])translate([-(d_dip/2 + (d_wire * 2) - 0.01),1.5,-len/2])cube(size=[d_wire *2 ,d_wire,len *1.05]);
				}


// top level object code

module dkeeper() {

	difference() // pin holes trasverse to dip pins
		{
	difference() // dip pin reliefs
		{
	difference() // lead traces
		{
	difference() // bisected cylinder
		{
			cylinder(h = len, r= dia/2, center = true);
			// bisect cylinder
			translate([(dia/2)/2,0,0])cube(size=[dia/2, dia, len], center=true);
			translate([-(d_dip/2)/2, 0, 0])half_dip(); 
		}
		lead_traces();
		}
		reliefs();
		}
		pins();
		}
			}

// dkeeper();

module dkeeper_basic() {

	difference() // dip pin reliefs
		{
	difference() // lead traces
		{
	difference() // bisected cylinder
		{
			cylinder(h = len, r= dia/2, center = true);
			// bisect cylinder
			translate([(dia/2)/2,0,0])cube(size=[dia/2, dia, len], center=true);
			translate([-(d_dip/2)/2, 0, 0])half_dip(); 
		}
		lead_traces();
		}
		reliefs();
		}
			}

module dkeeper_basic_mod() {
	difference(){
	dkeeper_basic();

	translate([0, dia/2 - d_wire, 0])cube(size=[d_wire,d_wire *2,len *1.05], center = true);
	mirror([0,1,0])translate([0, dia/2 - d_wire, 0])cube(size=[d_wire,d_wire *2,len *1.05], center = true);
}
							}

dkeeper_basic_mod();
// mirror([1,0,0])dkeeper_basic_mod();
