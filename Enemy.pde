public abstract class Enemy extends NonPlayer implements Collision2D {
    
    protected class MovingState extends State {
        public MovingState(Enemy enemy, PImage[] animation) {
            super(new Animation(enemy, animation, 60));
        }
    }
    
    protected class DamagedState extends State {
        public DamagedState(Enemy enemy, PImage[] animation) {
            super(new Animation(enemy, animation, 5).once());
        }
    }
    
    private float health;
    private PVector velocity;
    private float speed;
    private PVector acceleration;
    private float touchDamage = 1.0f;
    private Cursor cursor;
    
    private EntityManager manager;
    
    public Enemy(PVector position, float speed, float health) {
        super(position);
        
        this.velocity = new PVector();
        this.speed = speed;
        this.health = health;
        
        this.cursor = null;
    }
    
    public void setEntityManager(EntityManager manager) {
        this.manager = manager;
    }
    
    public void takeDamage(PVector direction, float damage) {
        this.health -= damage;
        
        this.velocity = direction.copy().normalize();
        this.acceleration = this.velocity.copy().mult(1.0f);
    }
    
    public void setCursor(Cursor cursor) {
        this.cursor = cursor;
    }
    
    public Cursor getCursor() {
        return this.cursor;
    }
    
    @Override
    public void render() {
        if(!getState().animate()) {
            if(this.health == 0) {
                this.manager.removeEnemy(this);
                return;
            }
            if(getState().hasNext())
                setState(getState().getNext());
        }
    }
    
    @Override
    public void update() {
        if(getState() instanceof DamagedState) {
            getPosition().add(this.velocity.add(this.acceleration));
            this.acceleration.mult(0.05);

            return;
        }
        
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
    
    public abstract boolean collidesWith(Hitbox hitbox);
}
