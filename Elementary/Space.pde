class Space {
  Node[] nodes;
  float friction;

  Space(int count) {
    nodes = new Node[count];
    friction = 0.1;
  }

  void setup() {
    Node n = new Node();
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
    float nLeft = n.p.x - n.w/2, nRight = n.p.x + n.w/2;
    float nTop = n.p.y - n.h/2, nBottom = n.p.y + n.h/2;
    float left = 0, right = width, top = 0, bottom = height;
    float vLoss = 0.2, aLoss = 0.1;
    if (nLeft < left && n.v.x < 0) {
      n.p.x = n.w/2;
      n.bounce('x', vLoss, aLoss);
    } else if (nRight > right && n.v.x > 0) {
      n.p.x = width - n.w/2;
      n.bounce('x', vLoss, aLoss);
    }
    if (nTop < top && n.v.y < 0) {
      n.p.y = n.h/2;
      n.bounce('y', vLoss, aLoss);
    } else if (nBottom > bottom && n.v.y > 0) {
      n.p.y = height - n.h/2;
      n.bounce('y', vLoss, aLoss);
    }
  }
}
