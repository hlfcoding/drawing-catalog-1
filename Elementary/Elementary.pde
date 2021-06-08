/*
 [x] Velocity, acceleration
 [x] Draw balls
 [x] Draw lines
 [x] Wall bounds
 [x] Torus bounds
 [x] Gravity
 [/] Mass
 [/] Styling
 [/] Field
 [ ] Flocking
 */

/*
 min V: 0.5, max V: 2
 periodic A: 0.2 per frame until max V, again when at min V
 friction: constant 0.1 decay on V, must be less than A
 [/] NoiseField
 [ ] Brownian
 [ ] Attraction
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
  s.setup('b', 'b', 'e');
  return s;
}

Space space2() {
  Space s = new Space(2);
  s.behaviors.add(new Attraction());
  s.boundsMode = 't';
  s.setup('b', 'b', 'e');
  return s;
}

Space space3() {
  frameRate(30);

  Space s = new Space(100);
  Attraction b = new Attraction();
  b.delegate = new Space3Handlers();
  b.stopIfClose = true;
  s.behaviors.add(b);
  s.boundsMode = 't';
  s.setup('b', 'l', 'e');
  return s;
}
class Space3Handlers implements AttractionDelegate {
  color strokeAttracted(float progressUntilOrbit) {
    float darkerIfFurther = 1 - progressUntilOrbit;
    float darkened = sq(darkerIfFurther);
    float dampened = darkened / 2;
    return color(dampened);
  }
}

Space space4() {
  Space s = new Space(100);
  NoiseField b = new NoiseField();
  //b.debug = true;
  s.behaviors.add(b);
  s.boundsMode = 't';
  s.friction = 0.1;
  s.setup('n', 'l', 'l');
  return s;
}
