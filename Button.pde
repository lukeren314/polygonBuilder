class Button{
  String label;
  int x;
  int y;
  int w; 
  int h;
  boolean clicked;
  Button(String label, int x, int y){
    this.label = label;
    this.x = x;
    this.y = y;
    this.w = int(textWidth(this.label));
    this.h = fontSize;
    //print(this.w,this.h);
    this.clicked = false;
  }
  void update(){
    if(mouseX > this.x && mouseX < this.x+this.w && mouseY > this.y && mouseY < this.y+this.h){
      if(mouseClicked){
        this.clicked = true;
        mouseClicked = false;
      }
    }
  }
  void show(){
    fill(0,0,0);
    //rect(this.x,this.y,this.w,this.h);
    //rect(this.x,this.y,this.w,this.h);
    textAlign(LEFT,TOP);
    text(this.label,this.x,this.y);
  }
}
