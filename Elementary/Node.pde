class Node {
  PVector p, pPrev, pNext;
  PVector v;
  PVector a;
  float aCeil;
  int aCounter;

  float w, h;

  char actMode; // (b)rownian
  char drawMode; // (b)all, (l)ine

  Node() {
    p = new PVector();
    v = new PVector();
    a = new PVector();
    aCeil = 1;
    aCounter = 0;
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
      // Sometimes need to draw before updating position.
      p = pNext;
      pNext = null;
    }
  }

  void act() {
    if (actMode == 'b') {
      if (frameCount % round(frameRate) == 0) {
        PVector r = PVector.random2D().mult(aCeil);
        a.set(r);
        aCounter = round(frameRate/2);
      } else if (aCounter > 0) {
        PVector r = PVector.random2D().mult(aCeil/3);
        a.add(r).limit(1);
        aCounter--;
      }
    }
  }

  void move(float friction) {
    pPrev = p.copy();
    PVector anyA = (aCounter > 0) ? a : null;
    Physics.move(p, v, anyA, friction * aCeil);
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
