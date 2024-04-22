public class Renderer {
    
    public void render(Renderable obj) {
        push();
        obj.render();
        pop();
        
        if(obj instanceof Player) {
            push();
            for(Weapon weapon : ((Player) obj).getWeapons())
                weapon.render();
            pop();
        }
    }
}
