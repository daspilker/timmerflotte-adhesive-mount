// TIMMERFLOTTE adhesive mount
// Round disc that sticks onto tiles, with a mushroom-head pin that replaces
// the screw for the keyhole slot on the back of the sensor.
//
// Printing: disc flat on the bed, pin pointing up. No supports needed
// (the underside of the head has a 45° chamfer). Use PETG or ASA for bathrooms.
//
// Copyright (c) 2026 Daniel A. Spilker
// SPDX-License-Identifier: CC-BY-4.0

// ---- Dimensions to measure on your sensor -----------------------------------
// Distance from the centre of the sensor to where the screw head sits when
// the sensor is hung (top end of the narrow slot).
// Positive = above the centre.
keyhole_offset = 22.5;   // mm  <-- MEASURE
head_d         = 6.0;   // mm  head diameter, < wide part of the keyhole
shank_d        = 3.4;   // mm  shank diameter, < width of the narrow slot
standoff       = 2.5;   // mm  gap from disc to underside of head (wall thickness at slot + clearance)
head_h         = 1.2;   // mm  head height (cylindrical part)

// ---- Disc ------------------------------------------------------------------
disc_d   = 60;    // mm
disc_h   = 2.4;   // mm
edge_chamfer = 0.8;
mark     = true;  // small notch on the top edge as an alignment aid

$fn = 128;

module disc() {
    difference() {
        hull() {
            cylinder(d = disc_d, h = disc_h - edge_chamfer);
            cylinder(d = disc_d - 2*edge_chamfer, h = disc_h);
        }
        if (mark)
            translate([0, disc_d/2, disc_h - 0.6])
                rotate([0, 0, 45]) cube([3, 3, 2], center = true);
    }
}

module pin() {
    chamfer = (head_d - shank_d) / 2;          // 45° chamfer under the head
    translate([0, keyhole_offset, disc_h]) {
        translate([0, 0, -0.01])                 // overlap into the disc
            cylinder(d = shank_d, h = standoff + 0.02);
        translate([0, 0, standoff - 0.01])
            cylinder(d1 = shank_d, d2 = head_d, h = chamfer);
        translate([0, 0, standoff + chamfer - 0.02])
            cylinder(d = head_d, h = head_h);
    }
}

union() { disc(); pin(); }
