class Space {
  Node[] nodes;
  float friction;

  char boundsMode; // (w)all, (t)orus
  int neighborsCeil; // 0 to disable

  Space(int count) {
    nodes = new Node[count];
    friction = 1.0/5;
    boundsMode = 'w';
    neighborsCeil = 0;
  }

  void setup(char actMode, char drawMode) {
    for (int i = 0; i < nodes.length; i++) {
      Node n = new Node();
      if (actMode == 'n') {
        n.w = n.h = 3;
      }
      n.actMode = actMode;
      if (actMode == 'a') {
        actMode = 'n';
      }
      n.drawMode = drawMode;
      PVector r = PVector.random2D();
      n.p.set(abs(r.x) * width, abs(r.y) * height);
      nodes[i] = n;
    }
  }

  void draw() {
    for (Node n : nodes) {
      ArrayList<Node> neighbors = null;
      if (n.actMode == 'a') {
        neighbors = this.neighbors(n);
      }
      n.act(neighbors);
      n.move(friction);
      affect(n);
      n.draw();
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

  ArrayList<Node> neighbors(Node node) {
    ArrayList<Node> a = new ArrayList<Node>();
    for (Node n : nodes) {
      if (node == n) {
        continue;
      }
      a.add(n);
    }
    return a;
  }
}
