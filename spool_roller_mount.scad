$fn = 32;
/*
basic dimensions
*/
//how thick to make the mount
cy_thickness = 20;
//how long
cx_length = 50;
//how high
cz_height = 50;

//do you want a step at the base for screwing down 1=yes, 0=no
c_need_support_step = 1;

/*
support step dimensions
*/
cy_support_width = 20;
//screw hole size in the base/step
c_support_hole_size = 6.5;
//how high the step support will be
cz_support_height = 10;
//screw hole postition from sides (centered)
cx_support_screw_pos = 20;
//screw hole postition from edge
cy_support_screw_pos = 7;
//how many screw holes
c_support_screw_count = 1;

c_support_screw_pos = (cx_length - (cx_support_screw_pos * 2)) / (c_support_screw_count - 1);

//the size of the shaft that holds the bearing
c_bearing_hole_size = 8.2;
//if you want a printed washer, set here, or 0 for none
c_bearing_washer_size = 11;
//how thick you want the washer to be
cy_bearing_washer_thickness = 2;
//how many bearing holes you want on mount
c_bearing_hole_count = 1;
//bearing hole position from the top (beaing will be centered on this)
c_bearing_hole_from_top = 12;
//bearing hole initial distance from the sides
cx_bearing_hole_pos = 16;

c_bearing_pos = (cx_length - (cx_bearing_hole_pos * 2)) / (c_bearing_hole_count - 1);

run = 1;

module create_bulk() {
    cube([cx_length, cy_thickness, cz_height]);  
}


module create_support() {
    translate([0, cy_thickness, 0])
        cube([cx_length, cy_support_width, cz_support_height]);
}


module create_support_screwhole(){
    if (c_support_screw_count > 1) {
    for (sh = [cx_support_screw_pos:c_support_screw_pos:c_support_screw_pos*c_support_screw_count])
        translate([sh, cy_thickness+cy_support_width-cy_support_screw_pos, -1] ) 
            cylinder(h = cz_support_height+2, r = c_support_hole_size/2);
    } else {
        translate([cx_length / 2, cy_thickness+cy_support_width-cy_support_screw_pos, -1] ) 
            cylinder(h = cz_support_height+2, r = c_support_hole_size/2);

    }
}


module create_bearing_holes() {
    if (c_bearing_hole_count > 1) {
    for (sh = [cx_bearing_hole_pos:c_bearing_pos:c_bearing_pos*c_bearing_hole_count])
        translate([sh, cy_thickness-cy_bearing_washer_thickness+5, cz_height-c_bearing_hole_from_top]) {
            rotate([90, 0, 0]) 
                cylinder(h = cy_thickness+cy_bearing_washer_thickness+5, r = c_bearing_hole_size/2);
        }
    } else {
        translate([cx_length / 2, cy_thickness-cy_bearing_washer_thickness+5, cz_height-c_bearing_hole_from_top]) {
            rotate([90, 0, 0]) 
                cylinder(h = cy_thickness+cy_bearing_washer_thickness+5, r = c_bearing_hole_size/2);
        }
    }
}


module create_bearing_washers() {
    if (c_bearing_hole_count > 1) {
    for (sh = [cx_bearing_hole_pos:c_bearing_pos:c_bearing_pos*c_bearing_hole_count])
        translate([sh, cy_thickness, cz_height-c_bearing_hole_from_top]) {
            rotate([90, 0, 0]) 
                cylinder(h = cy_thickness+cy_bearing_washer_thickness, r = c_bearing_washer_size/2);
        }
    } else {
        translate([cx_length / 2, cy_thickness, cz_height-c_bearing_hole_from_top]) {
            rotate([90, 0, 0]) 
                cylinder(h = cy_thickness+cy_bearing_washer_thickness, r = c_bearing_washer_size/2);
        }
    }
}


if (run == 1) {
    difference() {
        union() {
            create_bulk();
            if (c_need_support_step == 1) {
                create_support();
            }
            if (c_bearing_washer_size > 0) {
                create_bearing_washers();
            }
        }
        if (c_need_support_step == 1) {
            create_support_screwhole();
        }
        create_bearing_holes();
    }
}