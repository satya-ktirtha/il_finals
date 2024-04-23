public class Renderer {
    
    public void render(Renderable obj) {
        push();
        obj.render();
        pop();
        
        if(obj instanceof Player) {
            push();
            if(((Player) obj).getWeapon() != null)
                ((Player) obj).getWeapon().render();
            pop();
        }
    }
}
