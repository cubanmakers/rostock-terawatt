use <joint.scad>;

l = 250;
h = 7;
r = h/2 / cos(30);

// Wipe nozzle after long travel moves.
module collar() {
	difference() {
		cube([4, 20, h], center=true);
		cube([2, 18, h+1], center=true);
		rotate([0, 90]) rotate([0, 0, 30])
			cylinder(r=5, h=5, center=true, $fn=6);
	}
}

// Small hollow cube.
module cubicle() {
	difference() {
		cube([6, 6, h], center=true);
		cube([4, 4, h+1], center=true);
	}
}

rotate([0, 0, 45]) {
	// Nozzle wipers.
	translate([l/2+2, 0, 0]) cubicle();
	translate([-l/2-2, 0, 0]) cubicle();
	translate([l/2-25, 0, 0]) collar();
	translate([-l/2+25, 0, 0]) collar();
	// Rod with two Y shaped rod ends.
	union() {
		translate([-l/2, 0, 0]) jaws();
		translate([l/2, 0, 0]) rotate([0, 0, 180]) jaws();
		rotate([0, 90]) rotate([0, 0, 30])
			cylinder(r=r, h=l-18, center=true, $fn=6);
	}
}

// Print platform.
bed = 8*25.4; // 8x8 inches.
% translate([0, 0, -h/2-1]) cube([bed, bed, 2], center=true);