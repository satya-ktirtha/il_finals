public class Player extends Entity {
    
    private class RunningState extends State {
        
        public RunningState() {
            super(runningAnimation);
        }
    }
    
    private class IdleState extends State {
        
        public IdleState() {
            super(idleAnimation);
        }
    }
    
    public PVector velocity;
    private float speed = 3.0f;
    private final float SIZE = 16.0f;
    
    private ArrayList<Weapon> weapons;
    
    private Hitbox hitbox;
    
    private Animation runningAnimation = new Animation(this, new String[] {
                                    "textures/player/player_run_1.png",
                                    "textures/player/player.png"
                                }, 60);
    private Animation idleAnimation = new Animation(this, new String[] {
                                    "textures/player/player_idle_1.png",
                                    "textures/player/player.png"
                                }, 120);
    
    public Player(PVector position) {
        super(position);
        
        this.weapons = new ArrayList<>();
        this.velocity = new PVector();
        this.hitbox = new Hitbox(new PVector(-SIZE / 2 + 5, - SIZE / 2 + 1), SIZE / 2 - 1, SIZE - 1);
        
        setState(new IdleState());
    }
    
    public ArrayList<Weapon> getWeapons() {
        return this.weapons;
    }
    
    public float getSize() {
        return this.SIZE;
    }
    
    public Hitbox getHitbox() {
        return this.hitbox;
    }
    
    @Override
    public void render() {
        translate(getPosition().x, getPosition().y);
        //rotateY(getRotation());
        
        if(getRotation() == -PI) {
            scale(-3, 3);
        } else {
            scale(3);
        }
        beginShape();
        getState().animate();
        texture(getTexture());
        vertex(-SIZE / 2, -SIZE / 2, 0.0f, 0.0f);
        vertex( SIZE / 2, -SIZE / 2, 1.0f, 0.0f);
        vertex( SIZE / 2,  SIZE / 2, 1.0f, 1.0f);
        vertex(-SIZE / 2,  SIZE / 2, 0.0f, 1.0f);
        endShape();
        this.hitbox.render();
    }
    
    @Override
    public void update() {
        
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
                setState(new RunningState());
            }
        } else {
            if(getState() instanceof RunningState) {
                setState(new IdleState());
            }
        }
        
        getPosition().add(this.velocity);
    }
}
