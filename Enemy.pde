public abstract class Enemy extends NonPlayer {
    
    protected class MovingState extends State {
        public MovingState(Enemy enemy, PImage[] animation) {
            super(new Animation(enemy, animation, 60));
        }
    }
    
    private PVector velocity;
    private float speed;
    private float touchDamage = 1.0f;
    
    public Enemy(PVector position, float speed) {
        super(position);
        
        this.velocity = new PVector();
        this.speed = speed;
    }
    
    @Override
    public void update() {
        
        if(getState() instanceof MovingState) {
            final float ANGLE = degrees(atan2(-getPlayer().getPosition().y + getPosition().y, -getPlayer().getPosition().x + getPosition().x));
        
            if(ANGLE > 0 && ANGLE < 90 || ANGLE < 0 && ANGLE > -90)
                setRotation(-PI);
            else
                setRotation(0); 
            
            this.velocity = getPlayer().getPosition().copy().sub(getPosition()).normalize().mult(this.speed);
            
            getPosition().add(this.velocity);
        }
        
        if(getPlayer().collidesWith(getHitbox()))
            getPlayer().takeDamage(this.velocity, touchDamage);
    }
}
