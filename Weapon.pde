public class Weapon extends NonPlayer {
    
    private class UngrabbedState extends State {
        public UngrabbedState() {
            super(null);
        }
    }
    
    private final float WIDTH;
    private final float HEIGHT;
    
    public Weapon(PVector position, float w, float h, String texture) {
        super(position);
        
        setTexture(loadImage("textures/weapons/" + texture));
        
        setState(new UngrabbedState());
        
        this.WIDTH = w;
        this.HEIGHT = h;
    }
    
    @Override
    public void render() {
        translate(getPosition().x, getPosition().y);
        beginShape();
        scale(1.5);
        texture(getTexture());
        vertex(-WIDTH / 2, -HEIGHT / 2, 0.0f, 0.0f);
        vertex( WIDTH / 2, -HEIGHT / 2, 1.0f, 0.0f);
        vertex( WIDTH / 2,  HEIGHT / 2, 1.0f, 1.0f);
        vertex(-WIDTH / 2,  HEIGHT / 2, 0.0f, 1.0f);
        endShape();
    }
    
    @Override
    public void update() {
        float x = getPosition().x;
        float y = getPosition().y;
        float w2 = WIDTH;
        float h2 = HEIGHT;
        float px = getPlayer().getHitbox().getPosition().x;
        float py = getPlayer().getHitbox().getPosition().y;
        float pw2 = getPlayer().getHitbox().getWidth();
        float ph2 = getPlayer().getHitbox().getHeight();
        
        if(px + pw2 >= x && px <= x + w2 && py + ph2 >= y && py <= y + h2)
            println("Collided with player");
        else
            println("Not collided with player");
    }
}
