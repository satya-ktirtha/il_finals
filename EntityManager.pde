class EntityManager {
    
    private Game game;
    private Player player = null;
    private Cursor cursor = null;
    
    public EntityManager(Game game) {
        this.game = game;
        this.player = null;
    }
    
    public void endGame() {
        this.player = null;
        this.cursor = null;
        
        this.game.endGame();
    }
    
    public void multEnemySpeed(float mult) {
        for(Entity entity : this.game.getEntities())
            if(entity instanceof Enemy)
                ((Enemy) entity).multSpeed(mult);
    }
    
    public void scaleEnemies(float mult) {
        for(Enemy enemy : getEnemies()) 
            enemy.setScaleMultiplier(mult);
    }
    
    public void onWeaponPickup(Weapon weapon) {
        this.game.removeEntity(weapon);
    }
    
    public void onShoot(Bullet bullet) {
        bullet.setEntityManager(this);
        this.game.addBackgroundRenderable((Bullet) bullet);
    }
    
    public void removeBullet(Bullet bullet) {
        this.game.removeLater(bullet);
    }
    
    public void removeEnemy(Enemy enemy) {
        this.game.removeLater(enemy);
    }
    
    public ArrayList<Enemy> getEnemies() {
        ArrayList<Enemy> result = new ArrayList<>();
        
        for(Entity entity : this.game.getEntities())
            if(entity instanceof Enemy)
                result.add((Enemy) entity);
        
        return result;
    }
    
    public Object create(Object obj) throws Exception {
        if(obj instanceof Player) {
            if(player != null) {
                throw new Exception("Player already exists");
            }
            
            this.player = (Player) obj;
            this.player.setEntityManager(this);
            this.game.addForegroundRenderable((Renderable) obj);
            
            return this.player;
        }
        
        if(obj instanceof Cursor) {
            this.cursor = (Cursor) obj;
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
            
            if(obj instanceof NeedsManager) {
                ((NeedsManager) obj).setEntityManager(this);
            }
                   
            if(obj instanceof Enemy) {
                ((Enemy) obj).setCursor(cursor);
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
