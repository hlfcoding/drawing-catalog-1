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
}
