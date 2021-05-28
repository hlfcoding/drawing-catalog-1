class Space {
  Node[] nodes;
  float friction;

  ArrayList<GroupBehavior> behaviors;
  char boundsMode; // (w)all, (t)orus

  Space(int count) {
    nodes = new Node[count];
    friction = 1.0/5;
    behaviors = new ArrayList<GroupBehavior>();
    boundsMode = 'w';
  }

  void setup(char actMode, char drawMode) {
    for (int i = 0; i < nodes.length; i++) {
      Node n = new Node();
      n.actMode = actMode;
      n.drawMode = drawMode;
      n.p.set(randomVectorNear(width/2, height/2));
      nodes[i] = n;
    }
    for (GroupBehavior b : behaviors) {
      b.setup(nodes, boundsMode);
    }
  }

  void draw() {
    for (GroupBehavior b : behaviors) {
      b.update(nodes);
    }
    for (Node n : nodes) {
      n.act();
      n.move(friction);
      affect(n);
      pushStyle();
      for (GroupBehavior b : behaviors) {
        b.style(n);
      }
      n.draw();
      popStyle();
    }
  }

  void affect(Node n) {
    float left = 0, right = width, top = 0, bottom = height;
    if (boundsMode == 'w') {
      float vLoss = 1.0/10, aLoss = 1.0/10;
      if (n.left() < left && n.v.x < 0) {
        n.bounce('x', left, vLoss, aLoss);
      } else if (n.right() > right && n.v.x > 0) {
        n.bounce('x', right, vLoss, aLoss);
      }
      if (n.top() < top && n.v.y < 0) {
        n.bounce('y', top, vLoss, aLoss);
      } else if (n.bottom() > bottom && n.v.y > 0) {
        n.bounce('y', bottom, vLoss, aLoss);
      }
    } else if (boundsMode == 't') {
      if (n.right() < left) {
        n.teleport('x', right);
      } else if (n.left() > right) {
        n.teleport('x', left);
      }
      if (n.bottom() < top) {
        n.teleport('y', bottom);
      } else if (n.top() > bottom) {
        n.teleport('y', top);
      }
    }
  }
}

int nodeIds = 0;

class Node {
  int id;

  PVector p, pPrev, pNext;
  PVector v;
  PVector a;
  float aCeil;

  int energyFrames;
  int energyFramesPerAction;
  int framesPerAction;
  private int framesUntilAction;

  float w, h;

  char actMode; // (b)rownian, (n)one
  char drawMode; // (b)all, (l)ine

  Node() {
    id = nodeIds++;
    p = new PVector();
    v = new PVector();
    a = new PVector();
    aCeil = 1;
    energyFrames = 0;
    energyFramesPerAction = secondsOfFrames(0.5);
    framesPerAction = secondsOfFrames(1);
    framesUntilAction = 0;
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
  float mass() { // AKA influence.
    float density = 1;
    return w * h * density;
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
      if (framesUntilAction == 0) {
        framesUntilAction = framesPerAction;
        PVector r = PVector.random2D().mult(aCeil);
        a.set(r);
        energyFrames = energyFramesPerAction;
      } else {
        framesUntilAction--;
        if (energyFrames > 0) {
          PVector r = PVector.random2D().mult(aCeil/3);
          a.add(r).limit(1);
          energyFrames--;
        }
      }
    } else if (actMode == 'n') {
      if (energyFrames > 0) {
        energyFrames--;
      }
    }
  }

  void move(float friction) {
    pPrev = p.copy();
    PVector anyA = (energyFrames > 0) ? a : null;
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
