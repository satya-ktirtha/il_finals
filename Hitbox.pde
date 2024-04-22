public class Hitbox {
    
    private PVector position;
    private final float WIDTH, HEIGHT;
    
    public Hitbox(PVector position, float w, float h) {
        this.position = position;
        this.WIDTH = w;
        this.HEIGHT = h;
    }
    
    public PVector getPosition() {
        return this.position;
    }
    
    public float getWidth() {
        return this.WIDTH;
    }
    
    public float getHeight() {
        return this.HEIGHT;
    }
    
    public void render() {
        push();
        strokeWeight(1);
        stroke(255, 0, 0);
        translate(position.x, position.y);
        rect(0, 0, WIDTH, HEIGHT);
        pop();
    }
}
