public class Cursor extends NonPlayer implements MouseListener {
    
    public Cursor(PVector position) {
        super(position);
    }

    @Override
    public void render() {
        translate(getPosition().x, getPosition().y);
        circle(0, 0, 10);
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
