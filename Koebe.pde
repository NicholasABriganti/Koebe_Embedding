//Nicholas Briganti
//Stelianos Kalogeridis

PFont f;
// Variable to store text currently being typed
int typing;
int indent = 25;
// Variable to store saved text when return is hit
int savedX;
int savedY;
int vXtyping;
int vX;
boolean Es=true;
boolean Fs=true;
boolean Fm=false;
int arrayPointer = 0;
int EPointer = 0;
int FPointer = 0;
vertex[] vertices = new vertex[7];
vertex vert;
vertex vert2;
vertex vert3;
halfEdge[] hEdge = new halfEdge[12];
halfEdge hE;
int numEdges = 12;
int numVerts = 7;
int mouseCount = 0;
boolean xInput = true;
boolean endInput;
boolean endEInput;
boolean endFInput=false;
boolean colorOK;
float distance, radii;
float[] randoms = new float[100];
float r;
color colorTest; 
vertex[] circleList;
Face[] faces = new Face[0];
vertex[] interiorV;
vertex[] exteriorV;

void setup() {
  size(1280, 720);
  f = createFont("Arial", 14, true);
  for (int i =0; i<100; i++)
    randoms[i]=  random(.5, 400);
}

void draw() {
  background(255, 215, 0);
  r = random(.5, 400);

  // Set the font and fill for text
  textFont(f);
  fill(0);
/*
  // Display everything
  if (endInput==false && endEInput==false) {
    VertexInput();
  }
  else if (endInput==true && endEInput==false && endFInput==false) {
    EdgeInput();
  }
  else if (endInput==true && endEInput==true && endFInput==false) {
    FaceInput();
  }
  else {
    */
    if (mouseCount %3 == 0) {
//      DrawVertex();
      DrawEdge();
    }
    else if (mouseCount %3 == 1)
      DrawCircles();
    else {
      DrawCircles();
//      DrawVertex();
      DrawEdge();
    }
  }

/*
void DrawVertex() {
  int i=0;
  ellipseMode(CENTER);
  while (i<numVerts) {
    vert = vertices[i];
    ellipse(vert.x, vert.y, 5, 5);
    i++;
  }
}
*/

void DrawEdge() {
  stroke(255, 255, 255);
  int i =0;
  while (i<numEdges) {
    hE=hEdge[i];
    line(hE.origin.x, hE.origin.y, hE.dest.x, hE.dest.y);
    i++;
  }
}

void DrawCircles() {
  noLoop();
  ellipseMode(CENTER);
  stroke(255, 204, 0);
  fill(138, 43, 226);
  makeCircles();

  for (int i=0; i < interiorV.length; i++) {
    ellipse(interiorV[i].x, interiorV[i].y, interiorV[i].r, interiorV[i].r);
  }
  for (int i=0; i < exteriorV.length; i++) {
    ellipse(exteriorV[i].x, exteriorV[i].y, exteriorV[i].r, exteriorV[i].r);
  }
}


void makeCircles() {
  //  noLoop();
  //  faces = findFaces(vertices);
  println(faces.length);
  for (int k=0; k<faces.length; k++) {
    println("faces equals " + faces[k].vertexList[0].x);
  }


  circleList = new vertex[numVerts];

  for (int h = 0; h < numVerts; h++) {
    circleList[h] = new vertex(vertices[h].x, vertices[h].y, randoms[h]);
    //   circleList[h] = new vertex(vertices[h].x, vertices[h].y, 300);
  }
  IntVertices();
  while (!isPacked ()) {
    for (int i=0; i<interiorV.length; i++) {
      vertex ver = interiorV[i];
      ver.updateRadii(computeRadii(ver));
    }
  }
}

void IntVertices() {
  interiorV = new vertex[0];
  exteriorV = new vertex[0];


  for (int i = 0; i<circleList.length; i++) {
    //   circleList[i].addFaces(findFaces(circleList[i]));
    //   float x = circleList[i].getAngleSum();
    float x = getAngleSum(circleList[i]);
    println("angle " + x);
    circleList[i].updateAngleSum(x);
    if (circleList[i].interior) {
      interiorV = (vertex[])append(interiorV, circleList[i]);
      println("int");
      println(circleList[i].x);
      println(circleList[i].y);
    }
    else {
      exteriorV = (vertex[])append(exteriorV, circleList[i]);
      println("ext");
      println(circleList[i].x);
      println(circleList[i].y);
    }
  }
}

public float computeRadii(vertex v) {
  //FOR EVERY *INTERIOR* VERTEX
  float prediction = 0;
  for ( int i=0; i<interiorV.length; i++) {
    // 1.COMPUTE THE INTERIOR ANGLE SUM USING THE LAW OF COSINES
    //  v.addFaces(findFaces(v));
    float angleSum = getAngleSum(v);

    // 2.ADJUST THE RADIUS TO DECREASE THE DIFFERENCE
    if (TWO_PI != angleSum) {
      prediction = predictNextRadius(v, angleSum);

      //      v.r =prediction;
    }
  }
  return prediction;
}


public boolean isPacked() {
  float error = .01;
  for (vertex v : interiorV) {
    if (abs(TWO_PI - v.angle) > error) {
      return false;
    }
  }
  return true;
}


float predictNextRadius(vertex v, float angleSum) {
  //USE THE UNIFORM NEIGHBOR MODEL TO PREDICT NEXT RADIUS VALUE
  int numPetals = faces.length;
  float beta = sin(angleSum / (2 * numPetals));
  float delta = sin(PI / numPetals);

  float newRadius = (beta / (1 - beta)) * v.r
    * ((1 - delta) / delta);
  return newRadius;
}

public float getAngleSum(vertex v) {
  float angleSum = 0;
  for (int i =0; i<faces.length; i++) {                        
    angleSum += faces[i].getAngle(v);
  }
  return angleSum;
}

void mousePressed() {
  mouseCount++;
  loop();
}

/*
Face[] findFaces(vertex[] vert) {
  int i=0;
  while (vert[i] != null) {
    vertex[] temp = vert[i].neighbors;
    for (int j = 0; j<temp.length; j++) {
      vertex[] temp2 = temp[j].neighbors;
      for (int k= 0; k < temp2.length; k++) {
        if ((temp2[k].x == temp[j].x) && (temp2[k].y == temp[j].y)) {
          Face tempF = new Face(vert[i], temp[j], temp2[k]); 
          faces = (Face[])append(faces, tempF);
        }
      }
    }
    i++;
  }
  return faces;
}

Face[] findFaces(vertex vert) {
  vertex[] temp = vert.neighbors;
  for (int j = 0; j<temp.length; j++) {
    vertex[] temp2 = temp[j].neighbors;
    for (int k= 0; k < temp2.length; k++) {
      if ((temp2[k].x == temp[j].x) && (temp2[k].y == temp[j].y)) {
        Face tempF = new Face(vert, temp[j], temp2[k]);

        faces = (Face[])append(faces, tempF);
      }
    }
  }
  return faces;
}

*/



/*
void VertexInput() {
  if (xInput==true && endInput==false) {
    text("Type the coordinates of the vertices for input graph between 0 and " + width + ". Enter '/' to end input.\nType X coordinate", indent, 40);
    text(typing + " , " + " ", indent, 90);
  }
  else if (xInput==false && endInput==false) {
    text("Type the coordinates of the vertices for input graph between 0 and " + height + ".\nType Y coordinate", indent, 40);
    text(savedX + " , " + typing, indent, 90);
  }
}

void FaceInput() {
  if (Fs==true && Fm==false) {
    if (vXtyping == 0) {
      text("Input First vertex of Face", indent, 40);
      text("V_ ", indent, 90);
    }
    else {
      text("Input First vertex of Face", indent, 40);
      text("V" + vXtyping, indent, 90);
    }
  }
  if (Fs==false && Fm==true) {
    if (vXtyping == 0) {
      text("Input Second vertex of Face", indent, 40);
      text("V_ ", indent, 90);
    }
    else {
      text("Input Second vertex of Face", indent, 40);
      text("V" + vXtyping, indent, 90);
    }
  }
  else if (Fs==false && Fm==false) {
    if (vXtyping == 0) {
      text("Input Third vertex of Face", indent, 40);
      text("V_ ", indent, 90);
    }
    else {
      text("Input Third vertex of Face", indent, 40);
      text("V" + vXtyping, indent, 90);
    }
  }
}

void EdgeInput() {
  if (Es==true) {
    if (numEdges==0) {
      if (vXtyping == 0) {
        text("Which vertex number is the start of the edge? (V1 to V" + (arrayPointer) + ")\nEnter '/' to end input.", indent, 40);
        text("V_ " + " ->", indent, 90);
      }
      else {
        text("Which vertex number is the start of the edge? (V1 to V" + (arrayPointer) + ")\nEnter '/' to end input.", indent, 40);
        text("V" + vXtyping + " ->", indent, 90);
      }
    }
    else if (numEdges>0) { 
      if (vXtyping == 0) {
        text("Which vertex number is the start of the edge? (V1 to V" + (arrayPointer) + ")\nEnter '/' to end input.", indent, 40);
        text("V_ "  + " ->", indent, 90);
        text("Saved Edge: (" + vert.x + ", " + (height - vert.y) + ") -> (" + vert2.x + ", " + (height - vert2.y) + ")", indent, 130);
      }
      else {
        text("Which vertex number is the start of the edge? (V1 to V" + (arrayPointer) + ")\nEnter '/' to end input.", indent, 40);
        text("V" + vXtyping + " ->", indent, 90);
        text("Saved Edge: (" + vert.x + ", " + (height - vert.y) + ") -> (" + vert2.x + ", " + (height - vert2.y) + ")", indent, 130);
      }
    }
  }
  else if (Es==false) {
    if (vXtyping==0) {
      text("Which vertex number is the end of the edge which starts at V" + vX + "?", indent, 40);
      text("V" + vX + " -> V_", indent, 90);
      text("New Edge: (" + vert.x + ", " + (height - vert.y) + ") -> ( , )", indent, 130);
    }
    else {
      text("Which vertex number is the end of the edge which starts at V" + vX + "?", indent, 40);
      text("V" + vX + " -> V" + vXtyping, indent, 90);
      text("New Edge: (" + vert.x + ", " + (height - vert.y) + ") -> ( , )", indent, 130);
    }
  }
}




void keyPressed() {
  // If the return key is pressed, save the String and clear it
  if (endInput==false) {
    if (key == '\n' ) {
      saveVertex();
    } 
    else if ((key >= '0' && key <= '9')) {      // Handles proper numeric key inputs
      typing = (typing*10) + (key-48);
    }
    else if (key== 8) {      // Handles the backspace key to delete previous input
      typing = typing/10;
    }
    else if (key =='/') {  // Handles input to end Vertex input
      if (xInput==false) {
      }
      else {
        endInput=true;
      }
    }
    else {      // Handles all other key inputs
    }
  }

  //Input for Edges
  else if (endEInput==false && endInput==true) {
    if (key == '\n' ) {
      saveEdge();
    }
    else if ((key >= '0' && key <= '9')) {
      vXtyping = (vXtyping*10) + (key-48);
    }
    else if (key==8) {
      vXtyping = vXtyping/10;
    }
    else if (key =='/') {
      if (Es==false) {
      }
      else {
        endEInput=true;
      }
    }
    else {
    }
  }
  else {
    if (key == '\n' ) {
      saveFace();
    }
    else if ((key >= '0' && key <= '9')) {
      vXtyping = (vXtyping*10) + (key-48);
    }
    else if (key==8) {
      vXtyping = vXtyping/10;
    }
    else if (key =='/') {
      if (Fs==false) {
      }
      else {
        endFInput=true;
      }
    }
    else {
    }
  }
}

void saveVertex() {
  if (xInput==true) {
    if (typing>width) {
      typing=width;
    }
    savedX=typing;
    typing=0;
    xInput=false;
  }
  else {
    if (typing>height) {
      typing=height;
    }
    savedY=typing;
    vert =  new vertex(savedX, (height-savedY));
    vertices[arrayPointer] = vert;
    typing=0;
    arrayPointer++;
    numVerts++;
    xInput=true;
  }
}
*/


/*
void saveFace() {
  if (Fs==true && Fm==false) {
    vX=vXtyping;
    vXtyping=0;
    vert = vertices[vX-1];
    Fs = false;
    Fm = true;
  }
  else if (Fs==false && Fm==true) {
    vX = vXtyping;
    vXtyping=0;
    vert2 = vertices[vX-1];
    Fm=false;
  }
  else {
    vX = vXtyping;
    vXtyping=0;
    vert3 = vertices[vX-1];
    Face tempf = new Face(vert, vert2, vert3);
    vert.addFace(tempf);
    //    vert2.addFace(tempf);
    //    vert3.addFace(tempf);
    faces= (Face[])append(faces, tempf);
    FPointer++;
    Fs= true;
  }
}

void saveEdge() {
  if (Es==true) {
    vX=vXtyping;
    vXtyping=0;
    vert = vertices[vX-1];
    Es = false;
  }
  else {
    vX = vXtyping;
    vXtyping=0;
    vert2 = vertices[vX-1];
    hEdge[EPointer] = new halfEdge(vert, vert2);
    vert.addNeighbor(vert2);
    vert2.addNeighbor(vert);
    EPointer++;
    numEdges++;
    Es= true;
  }
}
*/

