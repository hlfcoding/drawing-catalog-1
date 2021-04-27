static class Physics {
  static void attractToOrbit
    (PVector a2, PVector p1, float m1, PVector p2, float m2)
  {
    PVector f = PVector.sub(p1, p2);
    float dOrbit = sqrt(m1) * 4;
    float d = max(dOrbit, f.mag());
    float k = 10;
    f.normalize();
    f.mult(k * (m1 * m2) / sq(d)); // Effect of force.
    a2.add(f.div(m2));
  }

  static void move
    (PVector p, PVector v, PVector a, float friction)
  {
    if (a != null) {
      v.add(a);
    }
    PVector f = v.copy().mult(friction); // Effect of force.
    v.sub(f);
    p.add(v);
  }
}

boolean isNewSecond() {
  return frameCount % round(frameRate) == 0;
}
