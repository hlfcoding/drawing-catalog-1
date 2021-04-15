static class Physics {
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
