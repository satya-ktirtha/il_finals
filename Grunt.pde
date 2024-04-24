public class Grunt extends Enemy {
    
    private final float WIDTH = 32, HEIGHT = 32;
    private boolean isBoss = false;
    
    public Grunt(PVector position, boolean isBoss) {
        super(position, 1.0f);
        
        setState(new MovingState(this, gruntWalking));
        setHitbox(new Hitbox(getPosition(), 20, 40).withOffset(new PVector(0, HEIGHT - HEIGHT / 1.5)));
        
        this.isBoss = isBoss;
        
        if(this.isBoss)
            setHitbox(new Hitbox(getPosition(), 40, 100).withOffset(new PVector(0, HEIGHT - HEIGHT / 4.5)));
    }

    @Override
    public void update() {
        super.update();
    }
    
    @Override
    public void render() {
        translate(getPosition().x, getPosition().y);
        
        if(getRotation() == -PI) {
            flipY();
        } 
        beginShape();
        getState().animate();
        
        if(isBoss)
            scale(5);
        else
            scale(2);
        texture(getTexture());
        vertex(-WIDTH / 2, -HEIGHT / 2, 0.0f, 0.0f);
        vertex( WIDTH / 2, -HEIGHT / 2, 1.0f, 0.0f);
        vertex( WIDTH / 2,  HEIGHT / 2, 1.0f, 1.0f);
        vertex(-WIDTH / 2,  HEIGHT / 2, 0.0f, 1.0f);
        endShape();
    }
}
