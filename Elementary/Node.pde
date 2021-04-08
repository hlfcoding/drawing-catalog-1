class Node {
  PVector p;
  PVector v;
  PVector a;
  float w, h;

  Node() {
    p = new PVector();
    v = new PVector();
    a = new PVector();
    w = 10;
    h = 10;
  }

  void draw() {
    ellipse(p.x, p.y, w, h);
  }

  void move(float friction) {
    v.add(a);
    p.add(v);
    PVector f = v.copy();
    f.normalize();
    f.mult(-1 * friction);
    a.add(f);
  }
  
  void bounce(char axis, float vLoss, float aLoss) {
    float vBounced = -(1 - vLoss);
    float aBounced = -(1 - aLoss);
    if (axis == 'x') {
      v.x *= vBounced;
      a.x *= aBounced;
    } else if (axis == 'y') {
      v.y *= vBounced;
      a.y *= aBounced;
    }
  }
}
