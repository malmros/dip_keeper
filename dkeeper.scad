// dkeeper
// Mark K Malmros 12June2013
// for FireFly project
// revised: 2 top level modules - dkeeper & dkeeper_basic
// uncomment one or the other
// "parameters"



// simple_keeper_02.scad >> dkeeper
// Mark K Malmros 26 June 2013
// for FireFly project

// "parameters"

dia = 9.5; // tubing ID = keeper diameter
len = 12.5; // keeper length 
w_dip = 7.1;
// width of DIP package (nominal 6.34) increased to accommodate folded pins
l_dip = 9.4; // length of DIP package (nominal 9.34)
d_dip = 3.5; // thickness of DIP package (nominal 3.34)
d_wire = 0.8; // lead wire "diameter" as square holes; increase to 0.8 mm ?
bevel = 15; // angle of edge bevel in degrees

// module library

module half_dip(){
difference() {
cube(size=[d_dip/2,w_dip,l_dip], center=true);
// bevel dip cavity 15 degrees 4 sides
translate([d_dip/4, w_dip/2 , -l_dip/2]) rotate(90 + bevel) cube(size=[d_dip/4,d_dip/2/cos(bevel),l_dip], center=false);
mirror([0,1,0])
translate([d_dip/4, w_dip/2 , -l_dip/2])  rotate(90 + bevel) cube(size=[d_dip/4,d_dip/2/cos(bevel),l_dip], center=false);
translate([d_dip/4, -w_dip/2, -l_dip/2] )  rotate([0,180 + bevel,0]) cube(size=[d_dip/2/cos(bevel),w_dip,d_dip/4], center=false);
mirror([0,0,1])
translate([d_dip/4, -w_dip/2, -l_dip/2] )  rotate([0,180 + bevel,0]) cube(size=[d_dip/2/cos(bevel),w_dip,d_dip/4], center=false);
}
}

module bisected_cylinder(){
	difference(){
		cylinder(h = len, r= dia/2, center = true);
		// bisect cylinder
		translate([(dia/2)/2,0,0])cube(size=[dia/2, dia, len], center=true);
		translate([-(d_dip/2)/2, 0, 0]) half_dip(); 
				}
						}

module lead_traces() {
		translate([-(d_dip/2 + (d_wire *2) -0.01),1.5,-len/2])cube(size=[d_wire *2 ,d_wire,len *1.05]);
		mirror([0,1,0])translate([-(d_dip/2 + (d_wire * 2) - 0.01),1.5,-len/2])cube(size=[d_wire *2 ,d_wire,len *1.05]);
				}

// top level object code modules

module dkeeper_basic() {
	difference() // lead traces
		{
	difference() // bisected cylinder
		{
		bisected_cylinder();
		}
		lead_traces();
		}
			}

// dkeeper_basic();


module dkeeper_basic_trim() {  // trimmed half cylinder face
	difference() {
		dkeeper_basic();
		cube(size=[d_wire/2,dia,len], center=true);
				}
						}

translate([0,0,dia/2])mirror([0,0,1])rotate([0,90,0])dkeeper_basic_trim();
