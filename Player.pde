interface InputCheck {
    void checkInput();
}

public class Player extends Entity implements Collision2D, NeedsManager {
    
    private class RunningState extends State {
        
        public RunningState(Player player) {
            super(new Animation(player, new String[] {
                                    "textures/player/player_run_1.png",
                                    "textures/player/player.png"
                                }, 60));
        }
    }
    
    private class IdleState extends State {
        
        public IdleState(Player player) {
            super(new Animation(player, new String[] {
                                    "textures/player/player_idle_1.png",
                                    "textures/player/player.png"
                                }, 120));
        }
    }
    
    private class DamageState extends State {
            
        public DamageState(Player player) {
            super(new Animation(player, new String[] {
                                    "textures/player/player_damage_1.png",
                                    "textures/player/player.png"
                                }, 5).repeat(2).once());
        }
    }
    
    private class PickUpAvailableState extends State implements InputCheck{
        
        private Player player;
        private Weapon weapon;
        
        public PickUpAvailableState(Player player, Weapon weapon) {
            super(null);
            
            this.player = player;
            this.weapon = weapon;
        }
        
        @Override
        public void checkInput() {
            if(this.player.getWeapon() != null)
                return;
            
            if(isKeyDown('E')) {
                this.player.pickup(this.weapon);
            }
        }
    }
    
    private abstract class Icon implements Renderable {
        
        private PVector position;
        
        public Icon(PVector position) {
            this.position = position;
        }
        
        public PVector getPosition() {
            return this.position;
        }
        
        public abstract void render();
    }
    
    public class DisarmedIcon extends Icon {
        
        private final float SIZE = 17.0f;
        
        public DisarmedIcon() {
            super(new PVector(0, -8.0f));
        }
        
        @Override
        public void render() {
            translate(getPosition().x, getPosition().y);
            beginShape();
            texture(disarmedIcon);
            scale(0.8f);
            vertex(-SIZE / 2, -SIZE / 2, 0.0f, 0.0f);
            vertex( SIZE / 2, -SIZE / 2, 1.0f, 0.0f);
            vertex( SIZE / 2,  SIZE / 2, 1.0f, 1.0f);
            vertex(-SIZE / 2,  SIZE / 2, 0.0f, 1.0f);
            endShape();
        }
    }
    
    public PVector velocity;
    public PVector acceleration;
    
    private float speed = 3.0f;
    private float health = 5.0f;
    private float disarmedTimer = 0.0f;
    private boolean disarmed = false;
    
    private final float SIZE = 16.0f;
    
    private Weapon weapon;
    private Icon icon;
    private EntityManager manager;
    
    private ArrayList<State> substates;
    
    public Player(PVector position) {
        super(position);
        
        this.velocity = new PVector();
        this.acceleration = new PVector();
        this.substates = new ArrayList<>();
        
        this.icon = null;
        this.weapon = null;
        this.manager = null;
        
        setHitbox(new Hitbox(getPosition(), SIZE * 1.6, SIZE * 2.4).withOffset(new PVector(0, 1.5f)));
        setState(new IdleState(this));
    }
    
    public float getSize() {
        return this.SIZE;
    }

    public void pickup(Weapon weapon) {
        this.weapon = weapon;
        weapon.grab();
    }
    
    public Weapon getWeapon() {
        return this.weapon;
    }
    
    public void setEntityManager(EntityManager manager) {
        this.manager = manager;
    }
    
    public void disarm() {
        if(this.weapon != null && !disarmed) {
            this.weapon.disable();
            
            this.disarmed = true;
            this.disarmedTimer = millis();
            
            this.icon = new DisarmedIcon();
        }
    }
    
    public void notifyWeaponPickup(Weapon weapon) {
        substates.add(new PickUpAvailableState(this, weapon));
    }
    
    public void takeDamage(PVector direction, float damage) {
        if(getState() instanceof DamageState)
            return;

        
        this.health -= damage;
        
        this.velocity = direction.copy().normalize();
        this.acceleration = this.velocity.copy().mult(2.0f);

        if(this.health <= 0.0f) {
            this.weapon = null;
            this.icon = null;
            this.manager.endGame();
        }

        setState(new DamageState(this).after(new IdleState(this)));
    }
    
    @Override
    public boolean collidesWith(Hitbox hitbox) {
        if(getState() instanceof DamageState)
            return false;
        
        return rectangleCollision(getHitbox(), hitbox);
    }
    
    @Override
    public void render() {
        translate(getPosition().x, getPosition().y);
        
        if(getRotation() == -PI) {
            flipY();
        } 
        beginShape();
        
        if(!getState().animate()) {
            if(getState().hasNext())
                setState(getState().getNext());
        }
        
        for(State state : substates) {
            if(state instanceof InputCheck)
                ((InputCheck) state).checkInput();
        }

        scale(3);
        
        if(this.health <= 0.0f)
            rotate(PI / 2);
            
        texture(getTexture());
        vertex(-SIZE / 2, -SIZE / 2, 0.0f, 0.0f);
        vertex( SIZE / 2, -SIZE / 2, 1.0f, 0.0f);
        vertex( SIZE / 2,  SIZE / 2, 1.0f, 1.0f);
        vertex(-SIZE / 2,  SIZE / 2, 0.0f, 1.0f);
        endShape();
        
        if(this.icon != null) {
            push();
            if(getRotation() == -PI)
                flipY();
            translate(this.icon.getPosition().x, this.icon.getPosition().y);
            this.icon.render();
            pop();
        }
    }
    
    @Override
    public void update() {
        if(getState() instanceof DamageState) {
            getPosition().add(this.velocity.add(this.acceleration));
            this.acceleration.mult(0.3);
                
            return;
        }
        
        if(disarmed) {
            if(millis() - this.disarmedTimer >= 3000) {
                this.disarmed = false;
                this.weapon.enable();
                this.icon = null;    
            }
        }
        
        PVector movement = new PVector();
        
        if(isKeyDown('W')) {
            movement.add(new PVector(0, -1.0f));
        }
        
        if(isKeyDown('A')) {
            movement.add(new PVector(-1.0f, 0));
        }
        
        if(isKeyDown('S')) {
            movement.add(new PVector(0, 1.0f));
        }
        
        if(isKeyDown('D')) {
            movement.add(new PVector(1.0f, 0));
        }
        
        this.velocity = movement.normalize().mult(speed);
        
        if(this.velocity.mag() != 0) {
            if(!(getState() instanceof RunningState)) {
                setState(new RunningState(this));
            }
        } else {
            if(getState() instanceof RunningState) {
                setState(new IdleState(this));
            }
        }
        
        getPosition().add(this.velocity);
    }
}
