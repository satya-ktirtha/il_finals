public class Cursor extends Entity implements MouseListener {
    
    public Cursor(PVector position) {
        super(position);
    }

    @Override
    public void render() {
        circle(getPosition().x, getPosition().y, 10);
    }
    
    @Override
    public void update() {
        this.getPosition().set(new PVector(mouseX, mouseY));
    }    
    
    @Override
    public void onMouseClicked(PVector mousePos) {
        if(mousePos.x > width / 2 && mousePos.y > height / 2)
            println("good");
    }
    @Override
    public void onMouseReleased(PVector mousePos) {
    }
    @Override
    public void onMousePressed(PVector mousePos) {
    }
}
