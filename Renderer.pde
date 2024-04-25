public class Renderer {
    
    public void render(Renderable obj) {
        push();
        obj.render();
        pop();
        
        push();
        if(obj instanceof Player) {
            ((Player) obj).getHitbox().render();
        }
        if(obj instanceof Enemy) {
            ((Enemy) obj).getHitbox().render();
        }
        if(obj instanceof Weapon) {
            ((Weapon) obj).getHitbox().render();
        }
        if(obj instanceof Bullet) {
            ((Bullet) obj).getHitbox().render();
        }
        pop();
        
        if(obj instanceof Player) {
            push();
            if(((Player) obj).getWeapon() != null)
                ((Player) obj).getWeapon().render();
            pop();
        }
    }
}
