interface GroupBehavior {
  void setup(Node[] nodes, char boundsMode);
  void update(Node[] nodes);

  void style(Node node);
}

interface AttractionDelegate {
  color strokeAttracted(float progressUntilOrbit);
}

class Attraction implements GroupBehavior, PhysicalContext {
  float attractorOdds;
  private ArrayList<Node> tors;
  private ArrayList<Node> tees;
  private HashMap<Integer, ArrayList<Node>> tions;

  float aFriction;
  float vTerminal;

  char boundsMode;

  color strokeAttractor;
  color strokeUnattracted;

  AttractionDelegate delegate;

  Attraction() {
    attractorOdds = 1.0/10;
    tors = new ArrayList<Node>();
    tees = new ArrayList<Node>();
    tions = new HashMap<Integer, ArrayList<Node>>();
    aFriction = 0.1;
    vTerminal = 0;
    strokeAttractor = color(0, 0.05);
    strokeUnattracted = color(0, 0);
    delegate = null;
  }

  void setup(Node[] nodes, char boundsMode) {
    this.boundsMode = boundsMode;
    int quota = ceil(attractorOdds * nodes.length);
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
          stroke(strokeUnattracted);
        } else if (delegate != null) {
          float p = Physics.progressUntilOrbit(tor.p, tor.mass(), tee.p, this);
          stroke(delegate.strokeAttracted(p));
        }
      } else if (tors.contains(node)) {
        stroke(strokeAttractor);
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

class NoiseField implements GroupBehavior {
  float[][] cells;

  boolean debug;
  int resolution;

  NoiseField() {
    debug = false;
    resolution = 20;
  }

  void setup(Node[] nodes, char boundsMode) {
    int res = resolution;
    int cols = width / res;
    int rows = height / res;
    cells = new float[rows][cols];
    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        float x = c * res;
        float y = r * res;
        float n = noise(x, y);
        cells[r][c] = n;
        if (debug) {
          drawUnitVector(r, c);
        }
      }
    }
  }

  private void drawUnitVector(int row, int col) {
    int res = resolution;
    float x = col * res;
    float y = row * res;
    float offset = res / 2.0;
    float noise = cells[row][col];
    pushMatrix();
    translate(x + offset, y + offset);
    rotate(TWO_PI * noise);
    line(-offset, 0, offset, 0);
    popMatrix();
  }

  void update(Node[] nodes) {
    if (!isNewSecond()) {
      return;
    }
    for (Node n : nodes) {
      int res = resolution;
      int col = floor(n.p.x / res);
      int row = floor(n.p.y / res);
      float noise = cells[row][col];
      PVector f = PVector.fromAngle(TWO_PI * noise);
      n.a.add(f);
      n.energyFrames = secondsOfFrames(0.5);
    }
  }

  void style(Node node) {
  }
}
