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
    private float speed = 1.5f;
    
    private final float SIZE = 16.0f;

    private State currentState;
    
    private Animation runningAnimation = new Animation(this, new String[] {
                                    "textures/player/player_run_1.png",
                                    "textures/player/player.png"
                                }, 60);
    private Animation idleAnimation = new Animation(this, new String[] {
                                    "textures/player/player.png",
                                    "textures/player/player_idle_1.png"
                                }, 120);
    
    public Player(PVector position) {
        super(position);
        
        this.velocity = new PVector();
        setTexture(loadImage("player.png"));
        
        currentState = new IdleState();
    }
    
    @Override
    public void render() {
        translate(getPosition().x, getPosition().y, getPosition().z);
        rotateY(getRotation());
        noStroke();
        scale(3);
        textureMode(NORMAL);
        beginShape();
        currentState.animate();
        texture(getTexture());
        vertex(-SIZE / 2, -SIZE / 2, 0.0f, 0.0f, 0.0f);
        vertex( SIZE / 2, -SIZE / 2, 0.0f, 1.0f, 0.0f);
        vertex( SIZE / 2,  SIZE / 2, 0.0f, 1.0f, 1.0f);
        vertex(-SIZE / 2,  SIZE / 2, 0.0f, 0.0f, 1.0f);
        endShape();
    }
    
    @Override
    public void update() {
        
        PVector movement = new PVector();
        
        if(isKeyDown('W')) {
            movement.add(new PVector(0, -1.0f));
        }
        
        if(isKeyDown('A')) {
            setRotation(-PI);
            movement.add(new PVector(-1.0f, 0));
        }
        
        if(isKeyDown('S')) {
            movement.add(new PVector(0, 1.0f));
        }
        
        if(isKeyDown('D')) {
            setRotation(0);
            movement.add(new PVector(1.0f, 0));
        }
        
        this.velocity = movement.normalize().mult(speed);
        
        if(this.velocity.mag() != 0) {
            if(!(currentState instanceof RunningState)) {
                currentState = new RunningState();
            }
        } else {
            if(currentState instanceof RunningState) {
                currentState = new IdleState();
            }
        }
        
        getPosition().add(this.velocity);
    }
}
