/*
 [x] Velocity, acceleration
 [x] Draw balls
 [ ] Draw lines
 [x] Wall bounds
 [ ] Torus bounds
 [ ] Gravity, mass
 */

Space space = new Space(1);

void setup() {
  size(300, 300);

  space.setup();
}

void draw() {
  space.draw();
}
