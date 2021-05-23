// V 1.2 Correction / hint from molotok3D, some minor fixes
// V 1.1- added opening helper and an optional separating wall

// Width (inner size, in mm)
wi=70;

// Length (inner size, in mm)
li=47;

// Height (inner size, in mm)
h=47;

// Radius of the Rounded Corners
r=3;

// Opening Help Gap
opening_help=true;	 // [true,false]

// Interior Divider (mm from on edge), 0 for none
separator=0;

// Show Components
showComponents=true; // [true,false]

// Render Cover
renderItems="both"; // [both,box,cover]

/* [Hidden] */
th=2;	// wall thickness

e=0.01;
ri=(r>th)?r-th:e;	// needed for the cover - needs to be larger than 0 for proper results
l=li-2*r;
w=wi-2*r;

// particle sensor dimenions
particle_width=50;
particle_depth=38;  // 45 with the space for the cable out the back
particle_height=21;
particle_fan_diameter=18;

/** core objects **/

module box(){
    
	difference(){
		translate([0,0,-th])hull(){
			for (i=[[-w/2,-l/2],[-w/2,l/2],[w/2,-l/2],[w/2,l/2]]){
				translate(i)cylinder(r=r+th,h=h+th,$fn=8*r);
			}
		}
		hull(){
			for (i=[[-w/2,-l/2],[-w/2,l/2,],[w/2,-l/2],[w/2,l/2]]){
				translate(i)cylinder(r=r,h=h+1,$fn=8*r);
			}
		}
		translate([-w/2,l/2+r,h-2])rotate([0,90,0])cylinder(d=1.2,h=w,$fn=12);
		translate([-w/2,-l/2-r,h-2])rotate([0,90,0])cylinder(d=1.2,h=w,$fn=12);
		translate([w/2+r,l/2,h-2])rotate([90,0,0])cylinder(d=1.2,h=l,$fn=12);
		translate([-w/2-r,l/2,h-2])rotate([90,0,0])cylinder(d=1.2,h=l,$fn=12);

		// if you need some adjustment for the opening helper size or position,
		// this is the right place
		if (opening_help)translate([w/2-10,l/2+13.5,h-1.8])cylinder(d=20,h=10,$fn=32);
	}
	
    /* generate supports for the internal components */
    
    // particle sensor holders
    translate([0,-l/2-2*th,0]) {
        translate([25.5,0,0]) cube([th,li+th,2.5*th]);
        translate([-27.5,0,0]) cube([th,li+th,2.5*th]);
    }
    translate([-w/2-2*th,15.5,0]) cube([wi+th,th,2.5*th]);

    // particle sensor top
    color("red")
    translate([-w/2-2*th,-23.5,particle_height+.25]) cube([wi+th,th,th]);

    // lower supports for the pi
    translate([-w/2-2*th,-l/2-th+1,particle_height])
        rotate([90,0,90]) prism(li-2*th,10,10);

    translate([w/2+2*th,l/2+1,particle_height])
        rotate([90,0,270]) prism(li-2*th,10,10);

    // pi holders
    translate([w/2-5,0,particle_height+10]) {
        translate([0,-19.5,0]) cube([8,th,2*th]);
        translate([0,13.5,0]) cube([8,th,2*th]);
        translate([5.5,0,0]) cube([1.25*th,1.25*th,2*th]);

        //spacer to match the spacing with the top
        //color("red") translate([0,-23.5,0]) cube([6,6,6]);
    }
    translate([-w/2-5,0,particle_height+10]) {
        translate([0,-19.5,0]) cube([8,th,2*th]);
        translate([0,13.5,0]) cube([8,th,2*th]);

        translate([1,-12,0]) cube([1.25*th,1.25*th,2*th]);
    }

    // TODO: delete once done
    if (separator>0){
		translate([separator-wi/2,-li/2-e,-e])difference(){
			cube([th,li+2*e,h]);
			translate([-e,-e,h-3])cube([th+2*e,2*th+2+2*e,5]);
			translate([-e,e+li-2*th-2,h-3])cube([th+2+2*e,2*th+2+2*e,5]);
		}
	}
}

module cover(w,r,l){

    translate([0,0,-th])hull(){
        for (i=[[-w/2,-l/2],[-w/2,l/2],[w/2,-l/2],[w/2,l/2]]){
            translate(i)cylinder(r=r+th,h=th,$fn=8*r);
        }
    }

	difference(){
		translate([0,0,-th])hull(){
			for (i=[[-w/2,-l/2],[-w/2,l/2],[w/2,-l/2],[w/2,l/2]]){
				translate(i)cylinder(r=r,h=th+3,$fn=8*r);
			}
		}
		hull(){
			for (i=[[-w/2,-l/2],[-w/2,l/2],[w/2,-l/2],[w/2,l/2]]){
				if (r>th){
					translate(i)cylinder(r=r-th,h=3+2,$fn=8*r);
				}else{
					translate(i)cylinder(r=e,h=3+2,$fn=8*r);
				}
			}
		}
	}
	translate([-w/2+1,l/2+r-0.2,2])rotate([0,90,0])cylinder(d=1.2,h=w-2,$fn=12);
	translate([-w/2+1,-l/2-r+0.2,2])rotate([0,90,0])cylinder(d=1.2,h=w-2,$fn=12);
	translate([w/2+r-0.2,l/2-1,2])rotate([90,0,0])cylinder(d=1.2,h=l-2,$fn=12);
	translate([-w/2-r+0.2,l/2-1,2])rotate([90,0,0])cylinder(d=1.2,h=l-2,$fn=12);

}

module prism(l, w, h){
   polyhedron(
       points=[[0,0,0], [l,0,0], [l,w,0], [0,w,0], [0,w,h], [l,w,h]],
       faces=[[0,1,2,3],[5,4,3,2],[0,4,5,1],[0,3,4],[5,2,1]]
       );
}

module vent_grid(x,y,z,rows,maxPerRow) {
    vent_size=5;
    vent_spacing=vent_size*2;
    translate([x,y,z]) {
        rotate([90,0,0]) {
            for (row = [0:rows-1]) {
                ventsInRow = row % 2 == 0 ? maxPerRow : maxPerRow-1;
                initialOffset = row %2 == 0 ? 0 : -vent_size;
                offset=row*vent_spacing;

                translate([initialOffset,-offset,0])
                    for(i = [0:ventsInRow])
                        translate([-(i*vent_spacing+th),0,0]) cylinder(d=vent_size, h=20,$fn=20);

            }
        }
    }
}

/** end core objects **/

/** derived objects **/

module box_raspi(){
    difference(){
        box();
        // align on the primary edge
        translate([0,-li/2-(2*th),0]) {
            // usb ports
            translate([wi/8-7,0,0])
                cube([28,10,h+th]);
            
            // hdmi
            translate([-wi/2+7,0,0])
                cube([16,10,h/2]);
        
        }
        
        // sd card
        translate([-wi/2-(2*th),-5,0])
            cube([10,14,7]);

    }
}

module raspi_cover_holder() {
    w=64;
    r=3;
    l=29;
    cover(w,r,l);
}

module top_hole() {
    x_opening=63;
    y_opening=28;

    translate([-w/2+5.5,-l/2+8.5,-20]) cube([x_opening-10,y_opening,100]);
    translate([-w/2+.5,-l/2+13,-20]) cube([x_opening,y_opening-10,100]);

    // translate([-w/2+.5+5,-l/2+.5,-20]) {
    //     cube([x_opening-10,y_opening,100]);
    //     //cube([wi-2*th-3,li-2*th-3,100]);
    // }

    // translate([-w/2+.5,-l/2+.5+5,-20])
    //     cube([x_opening,y_opening-10,100]);
}

/** derived objects **/

/** fit objects **/

module raspi() {
    raspi_width=65;
    raspi_depth=30;
    raspi_height=13;
    raspi_height_withscres=16;
    raspi_screw_diameter=4;
    raspi_screw_off_edge=2;
    
    cube([raspi_width,raspi_depth,raspi_height]);
    
    color("green") {
        
        // calculate x-y offset values
        offset1 = raspi_screw_off_edge+2;
        offset2 = raspi_depth-(offset1);
        offset3 = raspi_width-(offset1);
        
        screw_height=1.5;
        
        // top side screws
        translate([offset1,offset1,raspi_height]) {
            cylinder(h=screw_height,d=raspi_screw_diameter);
        }
        
        translate([offset1,offset2,raspi_height]) {
            cylinder(h=screw_height,d=raspi_screw_diameter);
        }
        
        translate([offset3,offset1,raspi_height]){
            cylinder(h=screw_height,d=raspi_screw_diameter);
        }
        
        translate([offset3,offset2,raspi_height]){
            cylinder(h=screw_height,d=raspi_screw_diameter);
        }
        
        // bottom side screws
        translate([offset1,offset1,-screw_height]) {
            cylinder(h=screw_height,d=raspi_screw_diameter);
        }
        
        translate([offset1,offset2,-screw_height]) {
            cylinder(h=screw_height,d=raspi_screw_diameter);
        }
        
        translate([offset3,offset1,-screw_height]){
            cylinder(h=screw_height,d=raspi_screw_diameter);
        }
        
        translate([offset3,offset2,-screw_height]){
            cylinder(h=screw_height,d=raspi_screw_diameter);
        }      
        
    }
    
}

module particle_sensor() {
    difference(){
        cube([particle_width,particle_depth, particle_height]);

        // hole that represents the fan intake
        translate([37,4,10])
            rotate([90,0,0]) 
                cylinder(d=particle_fan_diameter,h=5);
    }

    // cable sticks out starting at 9mm from the bottom and 8mm from the top
    // cable opening is 4mm high
    // cable needs 7mm out the back
    // opening is 17mm wide
    translate([27,particle_depth,9]) cube([17,7,4]);
}

/** end fit objects **/

/** command calls **/

if (renderItems == "both" || renderItems == "box")
    difference() {
        box();

        // particle sensor cut out
        translate([particle_fan_diameter/2+2,-20,particle_fan_diameter/2+2])
                rotate([90,0,0]) cylinder(d=particle_fan_diameter+2,h=10);

        // particle sensor, dot openings
        translate([-25,-30,particle_height-5]) cube([20,10,5]);

        // raspi -- usb ports
        translate([-2,-30,particle_height+10]) {
            cube([28,10,10]);
        }

        // raspi -- hdmi
        translate([-27.5,-30,particle_height+10]) {
            cube([15,10,8.5]);
        }

        // raspi -- sd card
        translate([-40,-8, particle_height+11]) {
            cube([10,15,5]);
        }

        // vent holes
        vent_grid(wi/3+4,30,particle_height+17,4,5);

        rotate([0,0,90])
        translate([17,-20,0])
        vent_grid(0,0,particle_height+17,4,3);

        rotate([0,0,90])
        translate([17,40,-10])
        vent_grid(0,0,particle_height+17,3,3);
    }

if (renderItems == "both" || renderItems == "cover")
    translate([0,li+3+2*th,0]) {
        difference() {
            cover(w,r,l);
            top_hole();
        }

        // difference() {
        //     translate([0,th,0]) raspi_cover_holder();
        //     top_hole();
        // }
    }

if (showComponents) {
    translate([-25,-23,0])
        %particle_sensor();

    translate([-33,-17,0]) {
        translate([0, 0, particle_height+11.5]) %raspi();
        translate([0, li+3+2*th+4, 0]) %raspi();
    }
}