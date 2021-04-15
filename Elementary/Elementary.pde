/*
 [x] Velocity, acceleration
 [x] Draw balls
 [x] Draw lines
 [x] Wall bounds
 [x] Torus bounds
 [ ] Gravity, mass
 */

Space space = new Space(1);

void setup() {
  size(300, 300);
  pixelDensity(displayDensity());

  space.setup();
}

void draw() {
  space.draw();
}
