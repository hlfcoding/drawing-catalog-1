class Space {
  Node[] nodes;
  float friction;

  char boundsMode; // (w)all, (t)orus

  Space(int count) {
    nodes = new Node[count];
    friction = 0.2;
    boundsMode = 'w';
  }

  void setup() {
    boundsMode = 't';
    Node n = new Node();
    n.drawMode = 'b';
    PVector r = PVector.random2D();
    n.p.set(abs(r.x) * width, abs(r.y) * height);
    nodes[0] = n;
  }

  void draw() {
    for (Node n : nodes) {
      if (frameCount % round(frameRate) == 0) {
        PVector r = PVector.random2D();
        n.a.set(r);
      }
      n.move(friction);
      affect(n);
      n.draw();
    }
  }

  void affect(Node n) {
    float left = 0, right = width, top = 0, bottom = height;
    if (boundsMode == 'w') {
      float vLoss = 0.1, aLoss = 0.1;
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
