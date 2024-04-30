public abstract class Enemy extends NonPlayer implements Collision2D, NeedsManager {
    
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
    
    private float scaleMultiplier;
    private float maxHealth;
    private float defaultSpeed;
    private float health;
    private float speed;
    private float touchDamage;
    
    private float prevNewMaxHealth;
    
    private PVector acceleration;
    private PVector velocity;

    private Cursor cursor;
    private EntityManager manager;
    
    public Enemy(PVector position, float defaultSpeed, float maxHealth) {
        super(position);
        
        this.velocity = new PVector();
        this.defaultSpeed = defaultSpeed;
        this.speed = this.defaultSpeed;
        this.maxHealth = maxHealth;
        this.prevNewMaxHealth = this.maxHealth;
        this.health = this.maxHealth;
        this.touchDamage = 1.0f;
        this.scaleMultiplier = 1.0f;
        
        this.cursor = null;
    }
    
    public void setEntityManager(EntityManager manager) {
        this.manager = manager;
    }
    
    public void setScaleMultiplier(float mult) {
        this.scaleMultiplier = mult;
        
        getHitbox().setScaleMultiplier(mult);
    }
    
    public float getScaleMultiplier() {
        return this.scaleMultiplier;
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
    
    public void multSpeed(float multiplier) {
        this.speed = this.defaultSpeed * multiplier;
        
        float newMaxHealth = floor(map(this.speed, this.defaultSpeed, this.defaultSpeed * 2.0f, this.maxHealth, 1));
        if(floor(abs(newMaxHealth - prevNewMaxHealth)) > 0) {
            this.health = newMaxHealth;
        }
        this.prevNewMaxHealth = newMaxHealth;
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
