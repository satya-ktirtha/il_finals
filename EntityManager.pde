class EntityManager {
    
    private Game game;
    
    public EntityManager(Game game) {
        this.game = game;
    }
    
    public Object create(Object obj) {
        if(obj instanceof MouseListener) {
            this.game.addMouseListener((MouseListener) obj);
        }
        
        if(obj instanceof Renderable) {
            this.game.addRenderable((Renderable) obj);
        }
        
        return obj;
    }
}
