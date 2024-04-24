public class State {
    
    private Animation animation;
    private State after;
    
    public State(Animation animation) {
        this.animation = animation;
        
        this.after = null;
    }
    
    public Animation getAnimation() {
        return this.animation;
    }
    
    public State after(State after) {
        this.after = after;
    
        return this;
    }
    
    public boolean hasNext() {
        return this.after != null;
    }
    
    public State getNext() {
        return this.after;
    }
    
    public boolean animate() {
        if(this.animation == null)
            return false;
            
        if(this.animation.isDone)
            return false;
            
        this.animation.animate();
        
        return true;
    }
}
