public class Hitbox {
    
    private PVector position;
    private PVector offset;
    private final float WIDTH, HEIGHT;
    
    public Hitbox(PVector position, float w, float h) {
        this.position = position;
        this.WIDTH = w;
        this.HEIGHT = h;
        
        this.offset = new PVector();
    }
    
    public float getWidth() {
        return this.WIDTH;
    }
    
    public float getHeight() {
        return this.HEIGHT;
    }
    
    public float getX() {
        return position.copy().x + offset.x;
    }
    
    public float getY() {
        return position.copy().y + offset.y;
    }
    
    public PVector getPosition() {
        return position.copy().add(offset);
    }
    
    public Hitbox withOffset(PVector offset) {
        this.offset = offset;
        
        return this;
    }
    
    public void render() {
        push();
        translate(getX(), getY());
        strokeWeight(1);
        stroke(255, 0, 0);
        rectMode(CENTER);
        rect(0, 0, WIDTH, HEIGHT);
        pop();
    }
}
