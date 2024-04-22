public abstract class NonPlayer extends Entity {
    
    private Player player;
    
    public NonPlayer(PVector position) {
        super(position);
    }
    
    public void setPlayer(Player player) {
        this.player = player;
    }
    
    public Player getPlayer() {
        return this.player;
    }
}
