public abstract class Entity implements Renderable {

    private PVector position;
    private float rotation;
    private PImage texture;

    public Entity(PVector position) {
        this.position = position;

        this.rotation = 0.0f;
        this.texture = null;
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

    public abstract void update();
}
