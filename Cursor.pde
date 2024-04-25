public class Cursor extends NonPlayer implements MouseListener, Collision2D {
    
    private final float SIZE = 16.0f;
    
    public Cursor(PVector position) {
        super(position);
        
        setTexture(loadImage("textures/misc/cursor.png"));
    }

    @Override
    public boolean collidesWith(Hitbox hitbox) {
        return pointRectangleCollision(getPosition(), hitbox);    
    }

    @Override
    public void render() {
        translate(getPosition().x, getPosition().y);
        beginShape();
        scale(2);
        texture(getTexture());
        vertex(-SIZE / 2, -SIZE / 2, 0.0f, 0.0f);
        vertex( SIZE / 2, -SIZE / 2, 1.0f, 0.0f);
        vertex( SIZE / 2,  SIZE / 2, 1.0f, 1.0f);
        vertex(-SIZE / 2,  SIZE / 2, 0.0f, 1.0f);
        endShape();
    }
    
    @Override
    public void update() {
        this.getPosition().set(new PVector(mouseX, mouseY));
        
        final float ANGLE = degrees(atan2(getPlayer().getPosition().y - getPosition().y, getPlayer().getPosition().x - getPosition().x));
        
        if(ANGLE > 0 && ANGLE < 90 || ANGLE < 0 && ANGLE > -90)
            getPlayer().setRotation(-PI);
        else
            getPlayer().setRotation(0);            
    }    
    
    @Override
    public void onMouseClicked(PVector mousePos) {
        
    }
    @Override
    public void onMouseReleased(PVector mousePos) {
    }
    @Override
    public void onMousePressed(PVector mousePos) {
    }
    @Override
    public void onMouseMoved(PVector mousePos) {
        getPosition().set(mousePos);
    }
}
