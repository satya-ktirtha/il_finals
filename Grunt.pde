public class Grunt extends Enemy {
    
    private final float WIDTH = 32, HEIGHT = 32;
    
    private boolean isBoss = false;
    private float scanProgress = 0;
    private boolean fullyScanned = false;
    private boolean identified = false;
    
    public Grunt(PVector position, boolean isBoss) {
        super(position, 1.0f);
        
        setState(new MovingState(this, gruntWalking));
        setHitbox(new Hitbox(getPosition(), 20, 40).withOffset(new PVector(0, HEIGHT - HEIGHT / 1.5)));
        
        this.isBoss = isBoss;
        
        if(this.isBoss)
            setHitbox(new Hitbox(getPosition(), 40, 100).withOffset(new PVector(0, HEIGHT - HEIGHT / 4.5)));
    }

    @Override
    public void update() {
        super.update();
        
        if(this.isBoss) {
            
            if(this.fullyScanned) {
                arduinoPort.write("e," + str(100));
             
                if(arduinoPort.available() > 0) {
                    char deviceDone = arduinoPort.lastChar();
                    if(deviceDone == '1')
                        this.identified = true;
                    
                }
                
                return;
            }
            
            if(getCursor().collidesWith(getHitbox())) {
                if(scanProgress < 100.0f) {
                    scanProgress += 0.5f;
                }
                
                if(scanProgress >= 100.0f)
                    this.fullyScanned = true;
                
                //arduinoPort.write("e," + str(scanProgress));
                arduinoPort.write("scanning\n");
            } else {
                arduinoPort.write("not scanning\n");
                
                if(scanProgress > 0)
                    scanProgress -= 1.0f;
            }
        }
        
        //println(scanProgress);
    }
    
    @Override
    public void render() {
        translate(getPosition().x, getPosition().y);
        
        if(getRotation() == -PI) {
            flipY();
        } 
        beginShape();
        getState().animate();
        
        if(isBoss)
            scale(5);
        else
            scale(2);
            
        if(!identified)
            tint(255, 255, 255, 20);
        else
            tint(255, 255, 255, 255);
            
        texture(getTexture());
        vertex(-WIDTH / 2, -HEIGHT / 2, 0.0f, 0.0f);
        vertex( WIDTH / 2, -HEIGHT / 2, 1.0f, 0.0f);
        vertex( WIDTH / 2,  HEIGHT / 2, 1.0f, 1.0f);
        vertex(-WIDTH / 2,  HEIGHT / 2, 0.0f, 1.0f);
        endShape();
    }
}
