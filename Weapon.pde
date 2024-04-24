public class Weapon extends NonPlayer {
    
    private class UngrabbedState extends State {
        public UngrabbedState() {
            super(null);
        }
    }
    
    private EntityManager manager;
    
    private final float WIDTH;
    private final float HEIGHT;
    private final float GRABBED_X, GRABBED_Y;
    
    private boolean grabbed = false;
    
    public Weapon(PVector position, float w, float h, String texture, float grabbedX, float grabbedY) {
        super(position);
        
        setTexture(loadImage("textures/weapons/" + texture));
        
        setState(new UngrabbedState());
        
        this.WIDTH = w;
        this.HEIGHT = h;
        this.GRABBED_X = grabbedX;
        this.GRABBED_Y = grabbedY;
        
        setHitbox(new Hitbox(getPosition(), this.WIDTH + 20.0f, this.HEIGHT).withOffset(new PVector(5.0f, 0.0f)));
        this.manager = null;
    }
    
    public void grab() {
        grabbed = true;
        
        this.manager.onWeaponPickup(this);
    }
    
    public void setEntityManager(EntityManager manager) {
        this.manager = manager;
    }
    
    @Override
    public void render() {
        if(!grabbed) {
            translate(getPosition().x, getPosition().y);
        } else {
            
            final float ANGLE = degrees(atan2(getPlayer().getPosition().y + GRABBED_Y - mouseY, getPlayer().getPosition().x + GRABBED_X - mouseX));
            
            if(ANGLE > 0 && ANGLE < 90 || ANGLE < 0 && ANGLE > -90) {
                getPosition().set(getPlayer().getPosition().x - GRABBED_X, getPlayer().getPosition().y + GRABBED_Y);
                translate(getPosition().x, getPosition().y);
                flipY();
                setRotation(-radians(ANGLE));
            } else {
                setRotation(radians(ANGLE) - PI);
                getPosition().set(getPlayer().getPosition().x + GRABBED_X, getPlayer().getPosition().y + GRABBED_Y);    
                translate(getPosition().x, getPosition().y);
            }
        }

        beginShape();
        texture(getTexture());
        rotate(getRotation());
        scale(1.5);
        vertex(-WIDTH / 2.5, -HEIGHT / 2, 0.0f, 0.0f);
        vertex( WIDTH / 1.5, -HEIGHT / 2, 1.0f, 0.0f);
        vertex( WIDTH / 1.5,  HEIGHT / 2, 1.0f, 1.0f);
        vertex(-WIDTH / 2.5,  HEIGHT / 2, 0.0f, 1.0f);
        endShape();
    }
    
    @Override
    public void update() {
        if(getPlayer().collidesWith(getHitbox()))
            getPlayer().notifyWeaponPickup(this);
    }
}
