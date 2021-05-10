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
      PVector r = PVector.random2D();
      n.p.set(abs(r.x) * width, abs(r.y) * height);
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

interface GroupBehavior {
  void setup(Node[] nodes, char boundsMode);
  void update(Node[] nodes);

  void style(Node node);
}
