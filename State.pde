public class State {
    
    private Animation animation;
    
    public State(Animation animation) {
        this.animation = animation;
    }
    
    public Animation getAnimation() {
        return this.animation;
    }
    
    public void animate() {
        this.animation.animate();
    }
}
