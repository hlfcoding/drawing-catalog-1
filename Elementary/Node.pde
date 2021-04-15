class Node {
  PVector p, pPrev, pNext;
  PVector v;
  PVector a;
  int aCounter;

  float w, h;

  char actMode; // (b)rownian
  char drawMode; // (b)all, (l)ine

  Node() {
    p = new PVector();
    v = new PVector();
    a = new PVector();
    w = 10;
    h = 10;
    actMode = 'b';
    drawMode = 'b';
  }

  float bottom() {
    return p.y + ((drawMode == 'b') ? h/2 : 0);
  }
  float left() {
    return p.x - ((drawMode == 'b') ? w/2 : 0);
  }
  float right() {
    return p.x + ((drawMode == 'b') ? w/2 : 0);
  }
  float top() {
    return p.y - ((drawMode == 'b') ? h/2 : 0);
  }

  void draw() {
    if (drawMode == 'b') { // ball
      ellipse(p.x, p.y, w, h);
    } else if (drawMode == 'l') { // line
      line(p.x, p.y, pPrev.x, pPrev.y);
    }
    if (pNext != null) {
      p = pNext;
      pNext = null;
    }
  }

  void act() {
    if (actMode == 'b') {
      if (frameCount % round(frameRate) == 0) {
        PVector r = PVector.random2D();
        a.set(r);
        aCounter = round(frameRate/2);
      } else if (aCounter > 0) {
        PVector r = PVector.random2D().mult(0.3);
        a.add(r).limit(1);
        aCounter--;
      }
    }
  }

  void move(float friction) {
    if (aCounter > 0) {
      v.add(a);
    }
    pPrev = p.copy();
    p.add(v);
    PVector f = v.copy().mult(friction);
    v.sub(f);
  }

  // -

  void bounce(char axis, float pEdge, float vLoss, float aLoss) {
    float vBounced = -(1 - vLoss);
    float aBounced = -(1 - aLoss);
    if (axis == 'x') {
      p.x = pEdge - ((drawMode == 'b') ?
        ((pEdge == 0) ? -1 : 1) * w/2 : 0);
      v.x *= vBounced;
      a.x *= aBounced;
    } else if (axis == 'y') {
      p.y = pEdge - ((drawMode == 'b') ?
        ((pEdge == 0) ? -1 : 1) * h/2 : 0);
      v.y *= vBounced;
      a.y *= aBounced;
    }
  }

  void teleport(char axis, float pEdge) {
    pNext = p.copy();
    if (axis == 'x') {
      pNext.x = pEdge - ((drawMode == 'b') ?
        ((pEdge == 0) ? 1 : -1) * w/2 : 0);
    } else if (axis == 'y') {
      pNext.y = pEdge - ((drawMode == 'b') ?
        ((pEdge == 0) ? 1 : -1) * h/2 : 0);
    }
  }
}
