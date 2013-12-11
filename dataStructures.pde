public class vertex {

  float x;
  float y;
  float r;
  int id;
  vertex[] neighbors;
  Face[] faces;
  boolean interior;
  boolean vertexSet;
  float angle;


  public vertex(int ident) {
    this.id=ident;
    //this.r=random(10, 100);
    this.r = 100;
    this.angle=0;
    neighbors = new vertex[0];
    faces = new Face[0];
    interior = false;
    vertexSet = false;
  }

  void updateCoor(float vertx, float verty) {
    this.x = vertx;
    this.y = verty;
    this.vertexSet=true;
  }

  void addNeighbor(vertex v) {
    vertex[] temp = (vertex[])append(neighbors, v);
    this.neighbors=temp;
  }

  void updateAngleSum(float x) {
    float error = .01;
    angle=0;
    angle += x;
    if (TWO_PI - angle < error)
      this.interior=true;
  }

  void updateRadius(float rad) {
    this.r=rad;
  }

  void addFace(Face f) {
    faces = (Face[])append(faces, f);
  }

  public float getAngleSum() {
    float angleSum = 0;
    for (int i =0; i<this.faces.length; i++) {                        
      angleSum += this.faces[i].getAngle(this);
    }
    return angleSum;
  }

  public boolean faceDoesExist(vertex a, vertex b) {
    int x=0;
    while (x < this.faces.length) {
      Face tempFace = this.faces[x];
      vertex[] vList = tempFace.vertexList;
      if ( vList[1]==a && vList[2]==b)
        return true;
      if ( vList[1]==b && vList[2]==a)
        return true;
      x++;
    }
    return false;
  }

  void display() {
    fill(0);
    ellipse(x, y, 8, 8);
  }
}



public class halfEdge {
  vertex origin;
  vertex dest;

  public halfEdge() {
  }
  /*
  public halfEdge( int x1, int y1, int x2, int y2) {
   origin = new vertex(x1, y1);
   dest = new vertex(x2, y2);
   } 
   */
  public halfEdge( vertex start, vertex end) {
    origin = start;
    dest = end;
  }
}



public class Face {
  int idNumber;
  vertex[] vertexList = new vertex[3];
  boolean exists;

  public Face(vertex v1, vertex v2, vertex v3, int id) {  
    vertexList[0] = v1;
    vertexList[1] = v2;
    vertexList[2] = v3;
    this.idNumber=id;
  }

  public float getAngle(vertex center) {
    float[] temp = new float[0];
    for (int i =0; i<vertexList.length; i++) {
      if (vertexList[i]!=center)
        temp = append(temp, vertexList[i].r);
    }

    float radiusA = temp[0];
    float radiusB = temp[1];

    float num = pow(center.r + radiusA, 2) 
      + pow(center.r+ radiusB, 2) 
        - pow(radiusA + radiusB, 2);
    float den = 2*(center.r + radiusA)*(center.r + radiusB);

    return acos(num/den);
  }
}

