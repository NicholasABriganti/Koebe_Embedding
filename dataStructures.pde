public class vertex {

  float x;
  float y;
  float r;
  int id;
  vertex[] neighbors;
  Face[] faces;
  boolean interior;
  float angle;
  

  public vertex(int vertX, int vertY) {
    this.x = vertX;
    this.y = vertY;
    this.angle=0;
    neighbors = new vertex[0];
    faces = new Face[0];
    interior = false;
  }

  public vertex(float x, float y, float r) {
    this.x = x;
    this.y = y;
    this.r = r;
    this.angle=0;
    neighbors = new vertex[0];
    interior = false;
    faces = new Face[0];
    ellipse(x, y, r, r);
  }
  
  public vertex(int id, float r) {
    this.r = r;
    this.angle=0;
    this.id = id;
    neighbors = new vertex[0];
    interior = false;
    faces = new Face[0];
    ellipse(x, y, r, r);
  }

  void addNeighbor(vertex v) {
    vertex[] temp = (vertex[])append(neighbors, v);
    neighbors=temp;
  }

  void updateAngleSum(float x) {
    float error = .01;
    angle=0;
    angle += x;
    if (TWO_PI - angle < error)
      this.interior=true;
  }

  void updateRadii(float rad) {
    this.r=rad;
  }

  void addFace(Face f) {
    faces = (Face[])append(faces, f);
  }

  public float getAngleSum() {
    float angleSum = 5;
    for (Face face: faces) {                        
      angleSum += faces[1].getAngle(this);
    }
    return angleSum;
  }

  void display() {
    fill(0);
    ellipse(x, y, 8, 8);
  }
}

public class halfEdge {
  vertex origin;
  vertex dest;
  halfEdge prev;
  halfEdge next;
  halfEdge twin;

  public halfEdge() {
  }

  public halfEdge( int x1, int y1, int x2, int y2) {
    origin = new vertex(x1, y1);
    dest = new vertex(x2, y2);

    this.display();
  } 

  public halfEdge( vertex start, vertex end) {
    origin = start;
    dest = end;

    this.display();
  }
  void display() {
    fill(0);
    line(origin.x, origin.y, dest.x, dest.y);
    ellipse(origin.x, origin.y, 10, 10);
    ellipse(dest.x, dest.y, 10, 10);
  }
}



public class Face {
  int idNumber;
  vertex[] vertexList = new vertex[3];

  public Face(vertex v1, vertex v2, vertex v3) {  
    vertexList[0] = v1;
    vertexList[1] = v2;
    vertexList[2] = v3;
  }

  public float getAngle(vertex center) {
    vertex[] temp = new vertex[0];
    for (int i=0; i<vertexList.length; i++) {
      if (vertexList[i]!=center)
        temp = (vertex[])append(temp, vertexList[i]);
    }
    println(temp.length);
    println(temp);

    float sideC = dist(center.x, center.y, temp[0].x, temp[0].y);
    float sideB = dist(center.x, center.y, temp[1].x, temp[1].y);
    float sideA = dist(temp[0].x, temp[0].y, temp[1].x, temp[1].y);

    float num = pow(sideB, 2) + pow(sideC, 2) - pow(sideA, 2);
    float den = 2 * sideB * sideC;

    return acos(num/den);
  }
}

