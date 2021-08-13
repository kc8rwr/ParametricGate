height = 92;
width = 244;

base_size = 75;
pipe_diameter = 18.5; // 19 = just slightly large, 18 too small
wall_thickness = 3.5;
bolt_diameter = 4;

u_bolt_diameter = 2;
u_bolt_spacing = 29.2;

$fn=360;
$deformation_fudge = 0.5;

center_angle = 2 * atan((height/2) / (width/2));
cross_angle = atan(width / height);

echo(concat("Center Angle: ", center_angle));
echo(concat("Cross Angle: ", cross_angle));

module corner(base_size = 25, pipe_diameter = 5, wall_thickness = 2, bolt_diameter = 4, angle = 70){
    difference(){

        linear_extrude(height = pipe_diameter + (2 * wall_thickness)){
            circle(d=base_size);
            difference(){
                square(base_size, center=true);
                square(base_size);
                translate([-base_size/2, -base_size/2]) circle(d=base_size);
            }
        }

        translate([0, (base_size/2) - (pipe_diameter/2) - wall_thickness,  wall_thickness + (pipe_diameter/2)])
            rotate([0, 270, 0]){
                cylinder(h=base_size, d=pipe_diameter);
                if (0 != $deformation_fudge)
                    translate([$deformation_fudge+pipe_diameter/4, 0, 0])
                        cylinder(h=base_size, d=pipe_diameter/2);
            }

        translate([(base_size/2) - (pipe_diameter/2) - wall_thickness, 0, wall_thickness + (pipe_diameter/2)])
            rotate([90, 0, 0]){
                cylinder(h=base_size, d=pipe_diameter);
                if (0 != $deformation_fudge)
                    translate([0, $deformation_fudge+pipe_diameter/4, 0])
                        cylinder(h=base_size, d=pipe_diameter/2);
            }

        translate([0, 0, wall_thickness + (pipe_diameter/2)])
            rotate([90, 0, -angle]){
                cylinder(h=base_size, d=pipe_diameter);
                if (0 != $deformation_fudge)
                    translate([0, $deformation_fudge+pipe_diameter/4, 0])
                        cylinder(h=base_size, d=pipe_diameter/2);
            }

        translate([(base_size/2)-(pipe_diameter/2)-wall_thickness, -base_size / 4, 0])
            translate([0, 0, -1])
                cylinder(h=pipe_diameter + (2*wall_thickness) + 2, d=bolt_diameter);

        translate([-(base_size/4) * sin(angle), -(base_size/4) * cos(angle), 0])
            translate([0, 0, -1])
                cylinder(h=pipe_diameter + (2*wall_thickness) + 2, d=bolt_diameter);
    
        translate([-base_size/4, (base_size/2) - (pipe_diameter/2) - wall_thickness, 0])
            translate([0, 0, -1])
                cylinder(h=pipe_diameter + (2*wall_thickness) + 2, d=bolt_diameter);
    }

}

module center(base_size, pipe_diameter, wall_thickness, bolt_diameter, angle){
    difference(){
        cylinder(d=base_size, h=pipe_diameter + (2*wall_thickness));
    
        for (a=[0, 180, angle, angle+180, (angle/2) + 90, (angle/2) + 270]){
            rotate([0, 0, a]){
                translate([-((base_size/2)+1), 0, (pipe_diameter/2)+wall_thickness]){
                    rotate([0, 90, 0]){
                        cylinder(h=base_size+2, d=pipe_diameter);
                        rotate([0, 90 , 0]) {
                            translate([-1*(base_size+2)/6, 0, -(wall_thickness + (pipe_diameter/2) + 1)]){
                                cylinder(d=bolt_diameter, h=2 + (2*wall_thickness) + pipe_diameter);
                            }
                        }
                        if (0 != $deformation_fudge)
                            translate([-($deformation_fudge+pipe_diameter/4), 0, 0])
                                cylinder(h=base_size+2, d=pipe_diameter/2);
                    }
                }
            }
        }
    }
}

module tee(base_size, pipe_diameter, wall_thickness, bolt_diameter){
    circle_d = pipe_diameter+(2*wall_thickness);
    difference(){
        linear_extrude(height=(2*wall_thickness)+pipe_diameter){
            hull(){
                circle(d=circle_d);
                translate([base_size - circle_d, 0]) circle(d=circle_d);
                translate([(base_size - circle_d)/2, -(base_size - circle_d)]) circle(d=circle_d);
            }
        }
        translate([-1-(circle_d/2), 0, wall_thickness + (pipe_diameter/2)]){
            rotate([0, 90, 0]){
                cylinder(h=base_size+2, d=pipe_diameter);
                if (0 != $deformation_fudge){
                    translate([-($deformation_fudge+pipe_diameter/4), 0, 0]){
                        cylinder(h=base_size+2, d=pipe_diameter/2);
                    }
                }
            }
        }
        translate([(base_size/2)-(circle_d/2), 0, wall_thickness + (pipe_diameter/2)]){
            rotate([90, 90, 0]){
                cylinder(h=base_size+2, d=pipe_diameter);
                if (0 != $deformation_fudge){
                    translate([-($deformation_fudge+pipe_diameter/4), 0, 0]){
                        cylinder(h=base_size+2, d=pipe_diameter/2);
                    }
                }
            }
        }
        translate([0, 0, -1]) cylinder(d=bolt_diameter, h=pipe_diameter+(2*wall_thickness)+2);
        translate([base_size - circle_d, 0, -1]) cylinder(d=bolt_diameter, h=pipe_diameter+(2*wall_thickness)+2);
        translate([(base_size - circle_d)/2, -(base_size - circle_d), -1]) cylinder(d=bolt_diameter, h=pipe_diameter+(2*wall_thickness)+2);
    }
}

module u_bolt_guide(pipe_diameter, wall_thickness, u_bolt_diameter, u_bolt_spacing){
    difference(){
        side = pipe_diameter + (2*wall_thickness);
								length = (2*wall_thickness) + u_bolt_spacing + u_bolt_diameter;
        cube([length, side, side]);
        translate([-1,  side/2, side/2])
            rotate([0, 90, 0]){
                cylinder(h=length+2, d=pipe_diameter);
                if (0 != $deformation_fudge)
                    translate([-($deformation_fudge+pipe_diameter/4), 0, 0])
                        cylinder(h=side+2, d=pipe_diameter/2);
            }
												
        for (x = [wall_thickness + (u_bolt_diameter/2), length - wall_thickness - (u_bolt_diameter/2)])
												translate([x, side/2, -1])
																cylinder(h=side+2, d=u_bolt_diameter);
    }
}

corner(base_size, pipe_diameter, wall_thickness, bolt_diameter, cross_angle);
translate([5 + base_size, 0, 0]) {
    center(base_size, pipe_diameter, wall_thickness, bolt_diameter, center_angle);
    translate([5 + (base_size/2), 0, 0]) {
        u_bolt_guide(pipe_diameter, wall_thickness, u_bolt_diameter, u_bolt_spacing);
    }
}
translate([-1.5 * base_size, base_size/4, 0]){
    tee(base_size, pipe_diameter, wall_thickness, bolt_diameter);
}
