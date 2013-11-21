//Nicholas Briganti
//Stelianos Kalogeridis

PFont f;

// Variable to store text currently being typed
int typing;

int indent = 25;
int xCount=0;

// Variable to store saved text when return is hit
int savedX;
int savedY;

int vXtyping;
int vX;
int vXLoc;


boolean Es=true;

int arrayPointer = 0;
int EPointer = 0;
int[] vertices = new int[1000];
int[] edges = new int[1000];
int numEdges = 0;
int numVerts = 0;

int mouseCount = 0;

boolean xInput = true;
boolean endInput;
boolean endEInput;

void setup() {
  size(640, 360);
  f = createFont("Arial", 14, true);
}

void draw() {
  background(138, 43, 226);

  // Set the font and fill for text
  textFont(f);
  fill(0);

  // Display everything
  if (endInput==false && endEInput==false) {
    VertexInput();
  }
  else if (endInput==true && endEInput==false) {
    EdgeInput();
  }
  else {
    if (mouseCount %2 == 0){
    PrintVertex();
    PrintEdges();
    }
    else
    DrawCircles();
  }
}

void PrintVertex() {
  ellipseMode(CENTER);
  int i =0;
  while(i<numVerts*2){
    ellipse(vertices[i], vertices[i+1],5,5);
    i+=2;
  }
  
}

void PrintEdges() {
  stroke(255, 255, 255);
  int i =0;
  while(i<numEdges*4){
    line(edges[i], edges[i+1], edges[i+2], edges[i+3]);
    i+=4;
  }
}

void DrawCircles(){
  ellipseMode(CENTER);
  stroke(255, 204, 0);
  fill(138, 43, 226);
  int i=0;
  while(i<numVerts*2){
    ellipse(vertices[i], vertices[i+1],200,200);
    i+=2;
  }
  
  
}
void VertexInput() {
  if (xInput==true && endInput==false) {
    text("Type the coordinatesvof the vertices for input graph between 0 and " + width + ". Enter '/' to end input.\nType X coordinent", indent, 40);
    text(typing, indent, 90);
    if (xCount>0) {
      text(savedX + " , " + savedY, indent, 150);
      text("Vertex " + xCount, indent, 130);
    }
    else {
      text("Vertex 1", indent, 130);
    }
  }
  else if (xInput==false && endInput==false) {
    text("Type the coordinates of the vertices for input graph between 0 and " + height + ".\nType Y coordinent", indent, 40);
    text(typing, indent, 90);
    if (xCount==0) {
      text(savedX + " , ", indent, 150);
      text("Vertex 1", indent, 130);
    }
    else {
      text(savedX + " , ", indent, 150);
      text("Vertex " + (xCount+1), indent, 130);
    }
  }
}

void EdgeInput() {
  if (Es==true) {
    text("Which vertex number is the start of the edge? (V1 to V" + (arrayPointer/2) + ")\nEnter '/' to end input.", indent, 40);
    text("V" + vXtyping, indent, 90);
  } 
  else {
    text("Which vertex number is the end of the edge which starts at V" + vX + "?", indent, 40);
    text("V" + vXtyping, indent, 90);
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
  else {
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
}

void saveVertex() {
  if (xInput==true) {
    if (typing>width) {
      typing=width;
    }
    savedX=typing;
    savedY=0;
    typing=0;
    vertices[arrayPointer] = savedX;
    arrayPointer++;
    xInput=false;
  }
  else {
    if (typing>height) {
      typing=height;
    }
    savedY=typing;
    vertices[arrayPointer] = height - savedY;
    typing=0;
    arrayPointer++;
    xCount++;
    numVerts++;
    xInput=true;
  }
}

void mousePressed(){
  mouseCount++;
}

void saveEdge() {
  if (Es==true) {
    vX=vXtyping;
    vXtyping=0;
    vXLoc = (vX*2) - 2;
    edges[EPointer]=vertices[vXLoc];
    edges[EPointer+1]=vertices[vXLoc+1];
    EPointer=EPointer+2;
    Es=false;
  }
  else {
    vX=vXtyping;
    vXtyping=0;
    vXLoc = (vX*2) - 2;
    edges[EPointer]=vertices[vXLoc];
    edges[EPointer+1]=vertices[vXLoc+1];
    EPointer=EPointer+2;
    numEdges++;
    Es=true;
  }
}

