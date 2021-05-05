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

class Attraction implements GroupBehavior, PhysicalContext {
  float torOdds;
  ArrayList<Node> tors;
  ArrayList<Node> tees;
  HashMap<Integer, ArrayList<Node>> tions;

  float aFriction;
  float vTerminal;

  char boundsMode;

  Attraction() {
    torOdds = 1.0/10;
    tors = new ArrayList<Node>();
    tees = new ArrayList<Node>();
    tions = new HashMap<Integer, ArrayList<Node>>();
    aFriction = 0.1;
    vTerminal = 0;
  }

  void setup(Node[] nodes, char boundsMode) {
    this.boundsMode = boundsMode;
    int quota = ceil(torOdds * nodes.length);
    for (Node n : nodes) {
      if (quota > 0) {
        tors.add(n);
        quota--;
      } else {
        tees.add(n);
        n.actMode = 'n';
        n.w = sqrt(n.w);
        n.h = sqrt(n.h);
        if (vTerminal == 0) {
          vTerminal = n.w;
        }
      }
    }
  }

  void update(Node[] nodes) {
    for (Node tor : tors) {
      ArrayList<Node> neighbors = tions.get(tor.id);
      if (neighbors == null || isNewSecond()) {
        float field = attractorField(tor);
        neighbors = new ArrayList<Node>();
        for (Node tee : tees) {
          if (dist(tor.p, tee.p) <= field) {
            neighbors.add(tee);
          }
        }
        tions.put(tor.id, neighbors);
      }
      for (Node n : neighbors) {
        n.energyFrames = secondsOfFrames(1);
        n.a.mult(1.0 - aFriction);
        Physics.attractToOrbit(n.a, tor.p, tor.mass(), n.p, n.mass(), this);
        n.v.limit(vTerminal);
      }
    }
  }

  private float attractorField(Node tor) {
    return tor.mass();
  }

  void style(Node node) {
    if (node.drawMode == 'l') {
      if (tees.contains(node)) {
        Node tee = node;
        Node tor = attractor(tee);
        if (tor == null) {
          stroke(0, 0);
        } else {
          float p = Physics.progressUntilOrbit(tor.p, tor.mass(), tee.p, this);
          stroke(sq(0.9 - p), abs(0.9 - p));
        }
      } else if (tors.contains(node)) {
        stroke(0, 0.05);
      }
    }
  }

  private Node attractor(Node tee) {
    for (Node tor : tors) {
      ArrayList<Node> tees = tions.get(tor.id);
      if (tees.contains(tee)) {
        return tor;
      }
    }
    return null;
  }

  float dist(PVector p1, PVector p2) {
    return p1.dist(normalPosition(p2, p1));
  }

  PVector normalPosition(PVector pOf, PVector pTo) {
    if (boundsMode != 't') {
      return pOf;
    }
    // TODO: Optimize.
    PVector[] candidates = {
      pOf, 
      pOf.copy().add(width, 0), 
      pOf.copy().add(-width, 0), 
      pOf.copy().add(0, height), 
      pOf.copy().add(0, -height), 
      pOf.copy().add(width, height), 
      pOf.copy().add(-width, height), 
      pOf.copy().add(width, -height), 
      pOf.copy().add(-width, -height)
    };
    PVector result = null;
    for (PVector c : candidates) {
      if (result == null || c.dist(pTo) < result.dist(pTo)) {
        result = c;
      }
    }
    return result;
  }
}
