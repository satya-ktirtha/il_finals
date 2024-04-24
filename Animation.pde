class Animation {
    private PImage[] images; 
    private int frame;
    private Entity entity;
    private int frameLength;
    private int timer;
    private boolean isDone;
    private boolean once;
    private int repeat;
    
    public Animation(Entity entity, String[] src, int frameLength) {
        this.images = new PImage[src.length];
        
        for(int i = 0; i < src.length; i++) {
            this.images[i] = loadImage(src[i]);
        }
        
        this.entity = entity;
        this.frameLength = frameLength;
        this.timer = 0;
        this.isDone = false;
        this.once = false;
        this.repeat = 0;
    }
    
    public Animation(Entity entity, PImage[] src, int frameLength) {
        this.images = src;
        
        this.entity = entity;
        this.frameLength = frameLength;
        this.timer = 0;
    }
    
    public Animation once() {
        this.once = true;
        
        return this;
    }
    
    public Animation repeat(int n) {
        this.repeat = n;
        
        return this;
    }
    
    public boolean isDone() {
        return this.isDone();
    }
    
    public void animate() {
        
        if(timer == frameLength) {
            timer = 0;
            
            frame += 1;
            
            if(frame == images.length && !once)
                frame = 0;
            else if(frame == images.length && once) {
                if(repeat > 0) {
                    repeat -= 1;
                    frame = 0;
                } else {
                    this.isDone = true;
                    
                    return;
                }
            }
        }
        
        this.entity.setTexture(images[frame]);
        
        timer += 1;
    }

}
