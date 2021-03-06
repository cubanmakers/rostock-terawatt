use <functions.scad>;

width = 80;
height = 24;
bearing_hole_id = 15.1;

offset = 25;
cutout = 13;
middle = 2*offset - width/2;

module lm8uu_mount(d, h) {
  union() {
    difference() {
      intersection() {
        cylinder(r=bearing_hole_id / 2 + 2, h=h, center=true);
        translate([0, -8, 0]) cube([19, 13, h+1], center=true);
      }
      cylinder(r=d/2, h=h+1, center=true);
    }
  }
}

module acetal_bushing_mount(d, h) {
  union() {
    difference() {
      hull() {
        cylinder(r=bearing_hole_id / 2 + 2, h=h, center=true);
        translate([0, bearing_hole_id - 3, 0]) cube([bearing_hole_id * 5 / 6, 10, h], center=true);
      }
      cylinder(r=d/2, h=h+1, center=true);
      // cutout support bracket
      translate([0, bearing_hole_id - 3.5, 0]) cube([4, 12, h+1], center=true);
      translate([0, bearing_hole_id - 3, 7])
      // cutout screw holes
      rotate([0, 90, 0]) cylinder(r=1.55, h=80, center=true, $fn=12);
      translate([0, bearing_hole_id - 3, -7])
      rotate([0, 90, 0]) cylinder(r=1.55, h=80, center=true, $fn=12);
      // washer cutouts to keep screws parallel
      translate([bearing_hole_id * 5 / 12 + 1, bearing_hole_id - 3, 7])
      rotate([0, 90, 0]) cylinder(r=3.5, h=2, center=true, $fn=12);
      translate([bearing_hole_id * 5 / 12 + 1, bearing_hole_id - 3, -7])
      rotate([0, 90, 0]) cylinder(r=3.5, h=2, center=true, $fn=12);
      // captured nut holes
      translate([bearing_hole_id - bearing_hole_id * 4 / 3 - 3, bearing_hole_id - 3, 7])
      rotate([0, 90, 0]) cylinder(r=3.3, h=6, center=true, $fn=6);
      translate([bearing_hole_id - bearing_hole_id * 4 / 3 - 3, bearing_hole_id - 3, -7])
      rotate([0, 90, 0]) cylinder(r=3.3, h=6, center=true, $fn=6);
    }
  }
}

module belt_mount() {
  difference() {
    union() {
      difference() {
        translate([8, 2, 0]) cube([4, 13, height], center=true);
        for (z = [-3.5, 3.5])
          translate([8, 5, z])
            cube([5, 13, 3], center=true);
      }
      for (y = [1.5, 5, 8.5]) {
        translate([8, y, 0]) cube([4, 1.2, height], center=true);
      }
    }
  }
}

module carriage(acetal = false) {
  union() {
    for (x = [-30, 30]) {
      translate([x, 0, 0])
        if (acetal) {
          acetal_bushing_mount(d=bearing_hole_id, h=24);
        } else {
          lm8uu_mount(d=bearing_hole_id, h=24);
        }
    }
  }
  belt_mount();
  difference() {
    union() {
      translate([0, -5.6, 0])
        cube([50, 5, height], center=true);
      translate([0, -28, -height/2+4])
        parallel_joints(width, cutout, offset, true, true, 28);
    }
    // Screw hole for adjustable top endstop.
    translate([15, -16, -height/2+4])
      cylinder(r=1.5, h=20, center=true, $fn=12);
    for (x = [-30, 30]) {
      translate([x, 0, 0])
        cylinder(r=8, h=height+1, center=true);
        if (!acetal) {
        // Zip tie tunnels.
        for (z = [-height/2+4, height/2-4])
        translate([x, 0, z])
          cylinder(r=13, h=3, center=true);
         }
    }
  }
}

translate([0, 0, height/2]) carriage(acetal = true);

// Uncomment the following lines to check endstop alignment.
// use <idler_end.scad>;
// translate([0, 0, -20]) rotate([180, 0, 0]) idler_end();
