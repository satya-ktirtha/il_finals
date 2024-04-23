class EntityManager {
    
    private Game game;
    private Player player = null;
    
    public EntityManager(Game game) {
        this.game = game;
        this.player = null;
    }
    
    public void onWeaponPickup(Weapon weapon) {
        this.game.removeEntity(weapon);
    }
    
    public Object create(Object obj) throws Exception {
        if(obj instanceof Player) {
            if(player != null) {
                throw new Exception("Player already exists");
            }
            
            this.player = (Player) obj;
            this.game.addForegroundRenderable((Renderable) obj);
            
            return this.player;
        }
        
        if(obj instanceof MouseListener) {
            this.game.addMouseListener((MouseListener) obj);
        }
        
        if(obj instanceof Renderable) {
            if(obj instanceof NonPlayer) {
                if(player == null) {
                    throw new Exception("Player must be created first");
                }

                ((NonPlayer) obj).setPlayer(this.player);
            }
            
            if(obj instanceof Weapon) {
                ((Weapon) obj).setEntityManager(this);
            }
                   
            if(obj instanceof Cursor) {
                this.game.addForegroundRenderable((Renderable) obj);

                return obj;
            }
            
            this.game.addBackgroundRenderable((Renderable) obj);
        }
        
        return obj;
    }
}
