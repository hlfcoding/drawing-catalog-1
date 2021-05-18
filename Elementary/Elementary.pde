/*
 [x] Velocity, acceleration
 [x] Draw balls
 [x] Draw lines
 [x] Wall bounds
 [x] Torus bounds
 [x] Gravity, mass
 [ ] Styling
 [ ] Field
 [ ] Flocking
 */

Space space;

void setup() {
  size(300, 300);

  colorMode(RGB, 1.0);
  pixelDensity(displayDensity());

  space = space4();
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
  Attraction b = new Attraction();
  b.delegate = new Space3Handlers();
  s.behaviors.add(b);
  s.boundsMode = 't';
  s.setup('b', 'l');
  return s;
}
class Space3Handlers implements AttractionDelegate {
  color strokeAttracted(float progressUntilOrbit) {
    float p = progressUntilOrbit;
    return color(sq(0.9 - p), abs(0.9 - p));
  }
}

Space space4() {
  Space s = new Space(10);
  NoiseField b = new NoiseField();
  //b.debug = true;
  s.behaviors.add(b);
  s.boundsMode = 't';
  s.setup('b', 'l');
  return s;
}
