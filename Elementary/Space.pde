class Space {
  Node[] nodes;
  float friction;

  Space(int count) {
    nodes = new Node[count];
    friction = 0.1;
  }

  void setup() {
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
    float vLoss = 0.2, aLoss = 0.1;
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
  }
}
