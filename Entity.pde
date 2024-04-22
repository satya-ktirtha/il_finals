public abstract class Entity implements Renderable {

    private PVector position;
    private float rotation;
    private PImage texture;
    private State currentState;

    public Entity(PVector position) {
        this.position = position;

        this.rotation = 0.0f;
        this.texture = null;
        this.currentState = null;
    }

    public PVector getPosition() {
        return this.position;
    }

    public float getRotation() {
        return this.rotation;
    }

    public void setRotation(float rotation) {
        this.rotation = rotation;
    }
    
    public void setTexture(PImage texture) {
        this.texture = texture;
    }
    
    public PImage getTexture() {
        return this.texture;
    }
    
    public void setState(State state) {
        this.currentState = state;
    }
    
    public State getState() {
        return this.currentState;
    }

    public abstract void update();
}
