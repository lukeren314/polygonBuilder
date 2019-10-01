PFont font;
final int fontSize = 32;
boolean mouseClicked = false;
boolean mouseRight = false;

float frameX = 400;
float frameY = 0;
float frameW = 800;
float frameH = 800;
float pointsRadius = 15;
int saveMode = 0;
int saveCount = 0;


int drawMode = 0;
//0 - points
//1 - lines

int createMode = 0;
//0 - create
//1 - delete

int savedIndex = -1;
String message = "";
PImage testImage;
float testX = 0;
float testY = 0;

Button pointsButton;
Button linesButton;
Button resetButton;
Button saveButton;
Button loadButton;
Button testButton;
Button cornerButton;
Button createButton;
Button deleteButton;
ArrayList<Button> buttons = new ArrayList<Button>();
ArrayList<PVector> points = new ArrayList<PVector>();
ArrayList<float[]> lines = new ArrayList<float[]>();

boolean checkDuplicate(float x1,float y1,float x2,float y2){
  for(int i = 0; i < lines.size();i++){
    if((lines.get(i)[0] == x1 && lines.get(i)[1] == y1 && lines.get(i)[2] == x2 && lines.get(i)[3] == y2) || (lines.get(i)[0] == x2 && lines.get(i)[1] == y2 && lines.get(i)[2] == x1 && lines.get(i)[3] == y1)){
      return(false);  
    }
  }
  return(true);
}

void mousePressed(){
  if(mouseButton == LEFT){
    mouseClicked = true;
  }
  if(mouseButton == RIGHT){
    mouseRight = true;
  }
}
void mouseReleased(){
  if(mouseButton == LEFT){
    mouseClicked = false;
  }
  if(mouseButton == RIGHT){
    mouseRight = false;
  }
}
void setup(){
  size(1200,800);
  font = createFont("Georgia",32);
  textFont(font);
  textSize(fontSize);
  
  pointsButton = new Button("Points",15,15);
  linesButton = new Button("Lines",150,15);
  
  resetButton = new Button("Reset",15,115);
  cornerButton = new Button("Corner",150,115);
  
  saveButton = new Button("Save",15,215);
  loadButton = new Button("Load",150,215);
  
  testButton = new Button("Test",15,315);
  
  createButton = new Button("Create",15,415);
  deleteButton = new Button("Delete",150,415);
  
  buttons.add(pointsButton);
  buttons.add(linesButton);
  buttons.add(resetButton);
  buttons.add(cornerButton);
  buttons.add(saveButton);
  buttons.add(loadButton);
  buttons.add(testButton);
  buttons.add(createButton);
  buttons.add(deleteButton);
  //textAlign(CENTER,CENTER);
  
}

void draw(){
  background(255,255,255);
  line(frameX,frameY,frameX,height);
  textSize(32);
  text(message,150,515);
  if(drawMode == 0){
    text("*",5,15);  
  } else if(drawMode == 1){
    text("*",140,15);  
  }
  if(createMode == 0){
    text("*",5,415);  
  } else if(createMode == 1){
    text("*",140,415);  
  }
  if(testImage != null){
    image(testImage,testX+frameX,testY+frameY);
  }
  for(int i = 0; i < buttons.size();i++){
    buttons.get(i).update();
    buttons.get(i).show();
  }
  if(pointsButton.clicked){
    drawMode = 0;
    savedIndex = -1;
    pointsButton.clicked = false;
  }
  if(linesButton.clicked){
    drawMode = 1;
    linesButton.clicked = false;
  }
  if(resetButton.clicked){
    points = new ArrayList<PVector>();
    lines = new ArrayList<float[]>();
    savedIndex = -1;
    if(testImage != null){
      testX = frameX+frameW/2-testImage.width;
      testY = frameY+frameH/2-testImage.height;
    }
    resetButton.clicked = false;
  }
  if(saveButton.clicked){
    if(saveMode == 0){
      JSONArray vertices = new JSONArray();
      for(int i = 0; i < points.size();i++){
        JSONArray point = new JSONArray();
        point.setFloat(0,points.get(i).x);
        point.setFloat(1,points.get(i).y);
        vertices.setJSONArray(i,point);
      }
      saveJSONArray(vertices,"data/polygon"+saveCount+".json");
      saveCount++;
    } else if(saveMode == 1){
      JSONObject polygon = new JSONObject();
    
      JSONArray vertices = new JSONArray();
      for(int i = 0; i < points.size();i++){
        JSONArray point = new JSONArray();
        point.setFloat(0,points.get(i).x);
        point.setFloat(1,points.get(i).y);
        vertices.setJSONArray(i,point);
      }
      polygon.setJSONArray("vertices",vertices);
      JSONArray edges = new JSONArray();
      for(int i = 0; i < lines.size();i++){
        JSONArray line = new JSONArray();
        for(int j = 0; j < lines.get(i).length;j++){
          line.setFloat(j,lines.get(i)[j]);
        }
        edges.setJSONArray(i,line);
      }
      polygon.setJSONArray("edges",edges);
      saveJSONObject(polygon,"data/polygon"+saveCount+".json");
      saveCount++;
    }
    
    message = "Polygon Saved!";
    saveButton.clicked = false;
  }
  if(cornerButton.clicked){
    float minX = frameW;
    float minY = frameH;
    for(int i = 0; i < points.size();i++){
      if(points.get(i).x < minX){
        minX = points.get(i).x;
      }
      if(points.get(i).y < minY){
        minY = points.get(i).y;
      }
    }
    for(int i = 0; i < points.size();i++){
      points.get(i).x -= minX;
      points.get(i).y -= minY;
    }
    testX = 0;
    testY = 0;
    cornerButton.clicked = false;
  }
  if(loadButton.clicked){
    loadButton.clicked = false;
  }
  if(testButton.clicked){
    selectInput("Select a file to test","fileSelected");
    testButton.clicked = false;
  }
  if(createButton.clicked){
    createMode = 0;
    createButton.clicked = false;
  }
  if(deleteButton.clicked){
    createMode = 1;
    deleteButton.clicked = false;
  }
  for(int i = 0; i < points.size(); i++){
    circle(points.get(i).x+frameX,points.get(i).y+frameY,pointsRadius);
    textSize(10);
    text("("+points.get(i).x+","+points.get(i).y+")",points.get(i).x+10+frameX,points.get(i).y+10+frameY);
  }
  for(int i = 0; i < lines.size();i++){
    line(lines.get(i)[0]+frameX,lines.get(i)[1]+frameY,lines.get(i)[2]+frameX,lines.get(i)[3]+frameY);
  }
  
  if(mouseRight){
    savedIndex = -1;
  }
  if(mouseX > frameX && mouseX < width && mouseY > frameY && mouseY < height){
    if(mouseClicked){
      if(createMode == 0){
        if(drawMode == 0){
          points.add(new PVector(mouseX-frameX,mouseY-frameY));
        } else if(drawMode == 1){
          if(savedIndex > -1){
            for(int i = 0; i < points.size();i++){
              if(pow(mouseX-points.get(i).x-frameX,2)+pow(mouseY-points.get(i).y-frameY,2) < pow(pointsRadius,2)){
                if(savedIndex != i){
                  if(checkDuplicate(points.get(savedIndex).x,points.get(savedIndex).y,points.get(i).x,points.get(i).y)){
                    lines.add(new float[] {points.get(savedIndex).x,points.get(savedIndex).y,points.get(i).x,points.get(i).y});
                    savedIndex = -1;
                    message = "New Line!";
                } else{
                    message = "Duplicate Line!";
                  }
                } else{
                  message = "Point selected twice!";
                }
              }
            }
          } else{
            for(int i = 0; i < points.size();i++){
              if(pow(mouseX-points.get(i).x-frameX,2)+pow(mouseY-points.get(i).y-frameY,2) < pow(pointsRadius,2)){
                savedIndex = i;
                message = "("+points.get(i).x+","+points.get(i).y+")";
              }
            }
            
          }
        }
        
        
      }
    } else if(createMode == 1){
      for(int i = 0; i < points.size();i++){
        if(pow(mouseX-points.get(i).x-frameX,2)+pow(mouseY-points.get(i).y-frameY,2) < pow(pointsRadius,2)){
          for(int j = lines.size()-1; j >= 0; j--){
            if((lines.get(j)[0] == points.get(i).x && lines.get(j)[1] == points.get(i).y) || (lines.get(j)[2] == points.get(i).x && lines.get(j)[3] == points.get(i).y)){
              lines.remove(j);
            }
          }
          points.remove(i);
        }
      }
    }
    mouseClicked = false;
  }
  
  
}

void fileSelected(File selection){
  if(selection == null){
    message = "File not selected";
  } else{
    try{
      testImage = loadImage(selection.getName());
      testX = frameW/2-testImage.width;
      testY = frameH/2-testImage.height;
    } catch (Exception e){
      print(e);
    }
  }
}
