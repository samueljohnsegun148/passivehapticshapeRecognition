 
 public class HapticLine {
   PShape line;
   float startX;
   float startY;
   float endX;
   float endY;
   public HapticLine (float startX, float startY, float endX, float endY){
     this.startX = startX;
       this.startY = startY;
       this.endX = endX;
       this.endY = endY;
     line = createShape(LINE, startX, startY, endX, endY);
     //box.setFill(color(0, 0, 0));
     line.setStroke(true);
     //shape(box, 50, 50); 
     
   }
  
 }
