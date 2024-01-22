 
 public class HapticBox {
   PShape box;
   float startX;
   float startY;
   float endX;
   float endY;
   int nextID = 0;
   float boxCenterX;
   float boxCenterY;
   private int boxId;
   
   
   
   public HapticBox (float startX, float startY, float endX, float endY){
       this.startX = startX;
       this.startY = startY;
       this.endX = endX;
       this.endY = endY;
       boxCenterX = (endX - startX)*0.5;
       boxCenterY = (endY- startX)*0.5;
       boxId = nextID++;
       box = createShape(RECT, startX, startY, endX, endY);
       //box.setFill(color(0, 0, 0));
       box.setStroke(true);
      
   }
   
 }
