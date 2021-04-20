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
      b.setup(nodes);
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
}

interface GroupBehavior {
  void setup(Node[] nodes);
  void update(Node[] nodes);
}

class Attraction implements GroupBehavior {
  float odds;

  Attraction() {
    odds = 1.0/10;
  }

  void setup(Node[] nodes) {
    int quota = ceil(odds * nodes.length);
    for (Node n : nodes) {
      if (quota > 0) {
        n.actMode = 'a';
        quota--;
      } else {
        n.actMode = 'n';
        n.w = sqrt(n.w);
        n.h = sqrt(n.h);
      }
    }
  }

  void update(Node[] nodes) {
    // get attractors
    ArrayList<Node> attractors = new ArrayList<Node>();
    for (Node n : nodes) {
      if (n.actMode == 'a') {
        attractors.add(n);
      }
    }
    // get attractees
    ArrayList<Node> attractees = new ArrayList<Node>();
    for (Node n : nodes) {
      if (n.actMode == 'n') {
        attractees.add(n);
      }
    }
    // get neighbors per attractor
    for (Node nA : attractors) {
      ArrayList<Node> neighbors = attractees;
      // each attractor affects neighbors
      for (Node n : neighbors) {
        nA.aCounter = 1;
        Physics.attract(n.a, nA.p, nA.mass(), n.p, n.mass());
      }
    }
  }
}
