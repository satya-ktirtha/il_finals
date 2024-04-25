public class Grunt extends Enemy {
    
    private final float WIDTH = 32, HEIGHT = 32;
    
    private boolean isBoss = false;
    private float scanProgress = 0;
    private boolean fullyScanned = false;
    private boolean identified = false;
    
    public Grunt(PVector position, boolean isBoss) {
        super(position, 1.0f, isBoss ? 10.0f : 5.0f);
        
        setState(new MovingState(this, gruntWalking));
        setHitbox(new Hitbox(getPosition(), 20, 40).withOffset(new PVector(0, HEIGHT - HEIGHT / 1.5)));
        
        this.isBoss = isBoss;
        
        if(this.isBoss)
            setHitbox(new Hitbox(getPosition(), 40, 100).withOffset(new PVector(0, HEIGHT - HEIGHT / 4.5)));
    }

    public void takeDamage(PVector direction, float damage) {
        setState(new DamagedState(this, gruntWalking).after(new MovingState(this, gruntWalking)));
        
        super.takeDamage(direction.copy(), damage);
    }
    
    public boolean isBoss() {
        return this.isBoss;
    }

    @Override
    public boolean collidesWith(Hitbox hitbox) {
        if(!isBoss())
            return rectangleCollision(getHitbox(), hitbox);
        
        if(identified)
            return rectangleCollision(getHitbox(), hitbox);
        else 
            return false;
    }

    @Override
    public void update() {
        super.update();
        
        if(this.isBoss) {
            
            if(this.fullyScanned) {
                //arduinoPort.write("e," + str(100));
             
                //if(arduinoPort.available() > 0) {
                //    char deviceDone = arduinoPort.lastChar();
                //    if(deviceDone == '1')
                //        this.identified = true;
                //}
                this.identified = true;
                return;
            }
            
            if(getCursor().collidesWith(getHitbox())) {
                if(scanProgress < 100.0f) {
                    scanProgress += 0.5f;
                }
                
                if(scanProgress >= 100.0f)
                    this.fullyScanned = true;
                
                //arduinoPort.write("e," + str(scanProgress));
                //arduinoPort.write("scanning\n");
            } else {
                if(scanProgress > 0)
                    scanProgress -= 1.0f;
            }
        }
        
        //println(scanProgress);
    }
    
    @Override
    public void render() {
        super.render();
        
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
            
        if(isBoss()) {
            if(!identified)
                tint(255, 255, 255, 20);
            else
                tint(255, 255, 255, 255);
        } else
            tint(255, 255, 255, 255);
            
        texture(getTexture());
        vertex(-WIDTH / 2, -HEIGHT / 2, 0.0f, 0.0f);
        vertex( WIDTH / 2, -HEIGHT / 2, 1.0f, 0.0f);
        vertex( WIDTH / 2,  HEIGHT / 2, 1.0f, 1.0f);
        vertex(-WIDTH / 2,  HEIGHT / 2, 0.0f, 1.0f);
        endShape();
    }
}
