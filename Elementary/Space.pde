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
      n.draw();
    }
  }
}
