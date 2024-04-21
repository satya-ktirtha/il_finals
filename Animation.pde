class Animation {
    private PImage[] images; 
    private int frame;
    private Entity entity;
    private int frameLength;
    private int timer;
    
    public Animation(Entity entity, String[] src, int frameLength) {
        images = new PImage[src.length];
        
        for(int i = 0; i < src.length; i++) {
            images[i] = loadImage(src[i]);
        }
        
        this.entity = entity;
        this.frameLength = frameLength;
        this.timer = 0;
    }
    
    public void animate() {
        if(timer == frameLength) {
            timer = 0;
            
            frame += 1;
            
            if(frame == images.length) 
                frame = 0;
        }
        
        this.entity.setTexture(images[frame]);
        
        timer += 1;
    }

}
