public class BananaBullet extends Bullet {
    public BananaBullet(PVector startingPosition, PVector velocity, boolean fromPlayer, float damage) {
        super(startingPosition, velocity, 1.0f, 1.0f, fromPlayer, "textures/misc/bullet.png", 12, 12, 3.0f, damage);
        
        setHitbox(new Hitbox(startingPosition, 12, 12));
    }
}
