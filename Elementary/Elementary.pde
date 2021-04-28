/*
 [x] Velocity, acceleration
 [x] Draw balls
 [x] Draw lines
 [x] Wall bounds
 [x] Torus bounds
 [x] Gravity, mass
 [ ] Styling
 */

Space space;

void setup() {
  size(300, 300);

  colorMode(RGB, 1.0);
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
  s.behaviors.add(new Attraction());
  s.boundsMode = 't';
  s.setup('b', 'b');
  return s;
}

Space space3() {
  frameRate(30);

  Space s = new Space(30);
  s.behaviors.add(new Attraction());
  s.boundsMode = 'w';
  s.setup('b', 'l');
  return s;
}
