public class Renderer {
    
    public void render(Renderable obj) {
        push();
        obj.render();
        pop();
    }
}
