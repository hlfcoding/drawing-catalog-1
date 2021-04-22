static class Physics {
  static void attract
    (PVector a2, PVector p1, float m1, PVector p2, float m2)
  {
    PVector f = PVector.sub(p1, p2);
    float d = constrain(f.mag(), 40, 80); // TODO
    float k = 1;
    f.normalize();
    f.mult((k * m1 * m2) / sq(d));
    a2.mult(0.6).add(f);
  }

  static void move
    (PVector p, PVector v, PVector a, float friction)
  {
    if (a != null) {
      v.add(a);
    }
    PVector f = v.copy().mult(friction);
    v.sub(f);
    p.add(v);
  }
}
