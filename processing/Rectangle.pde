class Rectangle{
  float x;
  float y;
  float width;
  float height;
  
  Rectangle(){}
  
  Rectangle(float xx, float yy, float w, float h){
    Set(xx,yy,w,h);
  }
  
  void Set(float xx, float yy, float w, float h){
    x=xx;
    y=yy;
    this.width=w;
    this.height = h;
  }
  
  void Draw(){
    rect(x,y,this.width, this.height);
  }
  
  float GetMaxX(){
    return (x+width);
  }
  
  float GetMaxY(){
    return (y+height);
  }
  
  boolean IsInside(float px, float py){
    return (px>=x && px<=GetMaxX() && py>=y && py<=GetMaxY());
  }
}
