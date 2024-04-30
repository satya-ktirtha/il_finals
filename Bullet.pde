public class Bullet extends NonPlayer implements NeedsManager {

    private final float WIDTH, HEIGHT;
    private PVector velocity, acceleration; 
    private float speed;
    private boolean fromPlayer;
    private float maxVelocity;
    private float damage;
    
    private EntityManager manager;
    
    public Bullet(PVector startingPosition, PVector velocity, float speed, float acceleration, boolean fromPlayer, String texture, float w, float h, float maxVelocity, float damage) {
        super(startingPosition);
        
        this.WIDTH = w;
        this.HEIGHT = w;
        this.velocity = velocity.normalize();
        this.speed = speed;
        this.acceleration = this.velocity.mult(acceleration);
        this.maxVelocity = maxVelocity;
        this.damage = damage;
        
        setTexture(loadImage(texture));
    }
    
    public void setEntityManager(EntityManager manager) {
        this.manager = manager;
    }
    
    public boolean isFromPlayer() {
        return this.fromPlayer;
    }
    
    @Override
    public void render() {
        beginShape();
        translate(getPosition().x, getPosition().y);
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
        if(getPosition().x >= width + this.WIDTH / 2.0f || getPosition().x <= 0 - this.WIDTH / 2.0f ||
           getPosition().y >= height + this.HEIGHT / 2.0f || getPosition().y <= 0 - this.HEIGHT / 2.0f) {
            this.manager.removeBullet(this);
            return;
        }
         
        ArrayList<Enemy> enemies = this.manager.getEnemies();
        for(Enemy enemy : enemies)
            if(enemy.collidesWith(getHitbox())) {
                this.manager.removeBullet(this);
                enemy.takeDamage(this.velocity.copy(), this.damage);
                return;
            }
                
        if(this.velocity.mag() < maxVelocity)
            getPosition().add(this.velocity.mult(speed).add(this.acceleration));
        else
            getPosition().add(this.velocity.mult(speed));
    }
}
