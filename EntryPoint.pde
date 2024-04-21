public class Game {
    private ArrayList<MouseListener> mouseListeners;
    private ArrayList<Renderable> renderables;
    
    private Renderer renderer;
    private EntityManager manager;
    
    private Cursor cursor;
    private Player player;
    
    public Game() {
        renderer = new Renderer();
        manager = new EntityManager(this);

        mouseListeners = new ArrayList<>();
        renderables = new ArrayList<>();
        
        cursor = (Cursor) manager.create(new Cursor(new PVector(width / 2, height / 2)));
        player = (Player) manager.create(new Player(new PVector(width / 2, height / 2)));             
    }
    
    public void render() {
        for(Renderable renderable : renderables) {
            renderer.render(renderable);
        }
    }
    
    public void update() {
        cursor.update();
        player.update();
    }
    
    public void onMouseClicked(PVector mousePos) {
        for(MouseListener listener : mouseListeners) 
            listener.onMouseClicked(mousePos);
    }
    
    public void addMouseListener(MouseListener mouseListener) {
        this.mouseListeners.add(mouseListener);
    }
    
    public void addRenderable(Renderable renderable) {
        this.renderables.add(renderable);
    }
}
    
Game g;
boolean[] keys = new boolean[65535];
int recentKeyReleased = '\0';

void mouseClicked() {
    g.onMouseClicked(new PVector(mouseX, mouseY));
}

void keyPressed() {
    keys[keyCode] = true;
}

void keyReleased() {
    keys[keyCode] = false;
    recentKeyReleased = keyCode;
}

boolean isKeyDown(char k) {
    return keys[k];
}

void setup() {
    size(1280, 720, P3D);
    background(255, 255, 255);
    
    frameRate(144);
    noCursor();
    
    g = new Game();
}

void draw() {
    background(255, 255, 255);
    
    g.render();
    g.update();
}
