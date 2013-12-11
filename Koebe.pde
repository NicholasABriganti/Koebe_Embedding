//Nicholas Briganti
//Stelianos Kalogeridis

PFont f;
int typing;
int indent = 25;
int savedX;
int vXtyping;
int vX;
boolean Es=true;
vertex[] vertices = new vertex[0];
vertex vert;
vertex vert2;
halfEdge[] hEdge = new halfEdge[0];
halfEdge hE;
boolean endInput;
boolean endEInput;
boolean endVInInput=false;
vertex[] interiorV = new vertex[0];
vertex[] exteriorV;


void setup() {
  size(1280, 720);
  f = createFont("Arial", 14, true);
}

void draw() {
  background(16766720);
  textFont(f);
  fill(0);

  if (endInput==false && endEInput==false) {
    VertexInput();
  }
  else if (endInput==true && endEInput==false && endVInInput==false) {
    EdgeInput();
  }
  else if (endInput==true && endEInput==true && endVInInput==false) {
    InterInput();
  }
  else {
    drawCircles();
    drawFaces();
  }
}


void drawFaces() {
  for (int i =0; i<interiorV[0].faces.length;i++) {
    line(interiorV[0].faces[i].vertexList[0].x, interiorV[0].faces[i].vertexList[0].y, interiorV[0].faces[i].vertexList[1].x, interiorV[0].faces[i].vertexList[1].y);
    line(interiorV[0].faces[i].vertexList[1].x, interiorV[0].faces[i].vertexList[1].y, interiorV[0].faces[i].vertexList[2].x, interiorV[0].faces[i].vertexList[2].y);
    line(interiorV[0].faces[i].vertexList[2].x, interiorV[0].faces[i].vertexList[2].y, interiorV[0].faces[i].vertexList[0].x, interiorV[0].faces[i].vertexList[0].y);
  }
}


void drawCircles() {
  noLoop();
  ellipseMode(CENTER);
  stroke(255, 204, 0);
  fill(138, 43, 226);

  findFaces(interiorV);
  fixOtherFaces(interiorV[0].faces);
  text("Click the mouse to step through algorithm", indent, 20);



  for (int i=0; i<vertices.length; i++) {
    vertex temp = vertices[i];
    ellipse(temp.x, temp.y, 2*temp.r, 2*temp.r);
    println("drawing vertex "+ temp.id+ " at " +temp.x +","+ temp.y);
  }

  computeRadii();
}

void fixOtherFaces(Face[] face) {
  for (int i=0; i<=face.length;i++) {

    if (i==0) {

      vertex a = face[i].vertexList[0];
      vertex b = face[i].vertexList[1];
      vertex c = face[i].vertexList[2];
      println(a.id);
      println(b.id);
      println(c.id);
      float ab = a.r + b.r;
      float ca = b.r + c.r;
      float bc = c.r + a.r;

      float x = ((ab * ab) + (bc * bc) - (ca * ca)) / (2 * ab);
      face[i].vertexList[0].updateCoor(width/2, height/2);
      face[i].vertexList[1].updateCoor((width/2)+ab, height/2);
      face[i].vertexList[2].updateCoor((width/2)+x, (height/2) - sqrt((bc * bc) - (x * x)));
    }


    else if (i>0) {
      vertex v = vertices[0];
      vertex[] temp2 = new vertex[0];

      if (i==face.length) {
        v = face[1].vertexList[1];
        temp2 = (vertex[])append(temp2, face[1].vertexList[0]);
        temp2 = (vertex[])append(temp2, face[1].vertexList[2]);
      }
      else {
        vertex[] temp = face[i].vertexList;
        for (int k=0; k<temp.length;k++) {
          if (temp[k].vertexSet==true && temp[k].id != 5) {
            temp2 = (vertex[])append(temp2, temp[k]);
          }
          else if (temp[k].vertexSet==true && temp[k].id==5) {
            v = temp[k];
          }
          else {
            v = temp[k];
          }
        }
      }
      vertex a = temp2[0];
      vertex b = temp2[1];
      vertex c = v;

      println("fixing " + c.id);
      println(a.id);
      println(b.id);
      println(c.id);

      float ab = a.r + b.r;
      float ca = b.r + c.r;
      float bc = c.r + a.r;

      float d1 = (pow(ca, 2) - pow(bc, 2) + pow(ab, 2))/ (2*ab);
      float h = sqrt(pow(ca, 2) - pow(d1, 2));
      float x3 = a.x + (d1 * (b.x - a.x))/ ab;
      float y3 = a.y + (d1 * (b.y - a.y))/ ab;
      float interx1 = x3 + (h * (b.y - a.y)) / ab;
      float intery1 = y3 - (h * (b.x - a.x)) / ab;
      float interx2 = x3 - (h * (b.y - a.y)) / ab;
      float intery2 = y3 + (h * (b.x - a.x)) / ab;


      if (get((int)interx1, (int)intery1) == 16766720) {
        v.updateCoor(interx1, intery1);
      }
      else {
        v.updateCoor(interx2, intery2);
      }
    }
  }
}


void computeRadii() {
  for (int i=0; i<interiorV.length; i++) {
    float angleSum = interiorV[i].getAngleSum();
    text("Current Angle Sum = " + angleSum, indent, 40);
    if (6.283185 != angleSum) {
      float prediction = predictNextRadius(interiorV[i], angleSum);
      interiorV[i].r=prediction;
      for (int k =0; k<vertices.length; k++) {
        vertices[k].vertexSet=false;
      }
    }
  }
}



float predictNextRadius(vertex v, float angleSum) {
  int numPetals = v.faces.length;
  float beta = sin(angleSum / (2 * numPetals));
  float delta = sin(PI / numPetals);

  float newRadius = (beta / (1 - beta)) * v.r
    * ((1 - delta) / delta);
  return newRadius;
}


void findFaces(vertex[] vert) {
  int id=0;
  vertex v1;
  vertex v2;
  vertex v3;

  for (int i=0; i<vert.length; i++) {
    vertex[] temp = vert[i].neighbors;
    for (int j = 0; j<temp.length; j++) {
      vertex[] temp2 = temp[j].neighbors;
      for (int k= 0; k < temp2.length; k++) {
        for (int x=0; x<temp.length;x++) {
          if ((temp2[k] == temp[x])) {
            Face tempF = new Face(vert[i], temp[j], temp2[k], id); 
            if (vert[i].faceDoesExist(temp[j], temp2[k]) == false) {
              vert[i].addFace(tempF);
              id++;
            }
          }
        }
      }
    }
  }
}




void VertexInput() {
  text("Type the number of the vertices in the graph", indent, 40);
  text(typing, indent, 90);
}

void InterInput() {
  text("Input Interior vertex. Enter '/' to end.", indent, 40);
  text("V" + vXtyping, indent, 90);
}

void EdgeInput() {
  if (Es==true) {
    text("Which vertex number is the start of the edge? (V0 to V" + (vertices.length-1) + ")\nEnter '/' to end input.", indent, 40);
    text("V" + vXtyping + " ->", indent, 90);
  }

  else if (Es==false) {
    text("Which vertex number is the end of the edge which starts at V" + vX + "?", indent, 40);
    text("V" + vX + " -> V" + vXtyping, indent, 90);
  }
}


void keyPressed() {
  if (endInput==false) {
    if (key == '\n' ) {
      saveVertex();
      endInput=true;
    } 
    else if ((key >= '0' && key <= '9')) {
      typing = (typing*10) + (key-48);
    }
    else if (key== 8) {
      typing = typing/10;
    }
    else {
    }
  }
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
      saveInter();
    }
    else if ((key >= '0' && key <= '9')) {
      vXtyping = (vXtyping*10) + (key-48);
    }
    else if (key==8) {
      vXtyping = vXtyping/10;
    }
    else if (key =='/') {
      endVInInput=true;
    }
    else {
    }
  }
}

void mousePressed() {
  loop();
}

void saveVertex() {
  savedX=typing;
  typing=0;
  int counter = 0;
  while (counter<savedX) {
    vert = new vertex(counter);
    vertices = (vertex[])append(vertices, vert);
    counter++;
  }
}


void saveInter() {
  vX = vXtyping;
  vXtyping=0;
  vertices[vX].interior=true;
  vert = vertices[vX];
  float inrad = 50;
  vert.updateRadius(inrad);
  interiorV = (vertex[])append(interiorV, vert);
}

void saveEdge() {
  if (Es==true) {
    vX=vXtyping;
    vXtyping=0;
    vert = vertices[vX];
    Es = false;
  }
  else {
    vX = vXtyping;
    vXtyping=0;
    vert2 = vertices[vX];
    halfEdge hTemp = new halfEdge(vert, vert2);
    hEdge = (halfEdge[])append(hEdge, hTemp);
    vert.addNeighbor(vert2);
    vert2.addNeighbor(vert);
    Es = true;
  }
}

