public class Pointer{
  private int x, y;
  private int r, g, b;
  private int radius;

  public int getterX(){ return this.x; }
  public int getterY(){ return this.y; }
  public int getterR(){ return this.r; }
  public int getterG(){ return this.g; }
  public int getterB(){ return this.b; }
  public int getterRadius(){ return this.radius; };
////////////////////////////////////////////////////
  public void setterX(int x){ this.x = x; }
  public void setterY(int y){ this.y = y; }
  public void setterR(int r){ if(r < 256 && r >= 0)this.r = r; }
  public void setterG(int g){ if(g < 256 && g >= 0)this.g = g; }
  public void setterB(int b){ if(b < 256 && b >= 0)this.b = b; }
  public void setterRadius(int radius) { this.radius = radius; }
////////////////////////////////////////////////////
  //引数x, yで表される座標との距離を計算
  public int distance(int x, int y){
    double dx, dy;
    dx = (this.x - x)*(this.x - x);
    dy = (this.y - y)*(this.y - y);
    return (int)Math.sqrt(dx + dy);
  }
  //スプレーしても色がすぐに変わらないようにするための関数
  public color scale(color c){
    int dr, dg, db;
    dr = this.r - (int)red(c);
    dg = this.g - (int)green(c);
    db = this.b - (int)blue(c);
    c = color(red(c)+dr/4, green(c)+dg/4, blue(c)+db/4);
    return c;
  }
  
  
  Pointer(int x, int y){
    this.x = x;
    this.y = y;
    this.r = this.g = this.b = this.radius = 0;    
  }
}
