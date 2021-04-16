/*
 [x] Velocity, acceleration
 [x] Draw balls
 [x] Draw lines
 [x] Wall bounds
 [x] Torus bounds
 [ ] Gravity, mass
 */

Space space;

void setup() {
  size(300, 300);
  pixelDensity(displayDensity());

  space = space2();
}

void draw() {
  space.draw();
}

Space space1() {
  Space s = new Space(1);
  s.boundsMode = 't';
  s.setup('b', 'b');
  return s;
}

Space space2() {
  Space s = new Space(2);
  s.boundsMode = 't';
  s.setup('a', 'b');
  return s;
}
