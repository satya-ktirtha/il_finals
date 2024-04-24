interface InputCheck {
    void checkInput();
}

public class Player extends Entity implements Collision2D {
    
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
    
    public PVector velocity;
    public PVector acceleration;
    private float speed = 3.0f;
    private float health = 10.0f;
    
    private final float SIZE = 16.0f;
    
    private Weapon weapon;
    
    private ArrayList<State> substates;
    
    public Player(PVector position) {
        super(position);
        
        this.velocity = new PVector();
        this.acceleration = new PVector();
        this.substates = new ArrayList<>();
        
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
    
    public void notifyWeaponPickup(Weapon weapon) {
        substates.add(new PickUpAvailableState(this, weapon));
    }
    
    public void takeDamage(PVector direction, float damage) {
        if(getState() instanceof DamageState)
            return;
        
        this.health -= damage;
        
        this.velocity = direction.copy().normalize();
        this.acceleration = this.velocity.copy().mult(2.0f);
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
        
        texture(getTexture());
        vertex(-SIZE / 2, -SIZE / 2, 0.0f, 0.0f);
        vertex( SIZE / 2, -SIZE / 2, 1.0f, 0.0f);
        vertex( SIZE / 2,  SIZE / 2, 1.0f, 1.0f);
        vertex(-SIZE / 2,  SIZE / 2, 0.0f, 1.0f);
        endShape();
    }
    
    @Override
    public void update() {
        if(getState() instanceof DamageState) {
            getPosition().add(this.velocity.add(this.acceleration));
            this.acceleration.mult(0.3);
            return;
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
