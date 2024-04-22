public class Game {
    private ArrayList<MouseListener> mouseListeners;
    private ArrayList<Renderable> renderables;
    
    private Renderer renderer;
    private EntityManager manager;
    
    private Cursor cursor;
    private Player player;
    private Weapon bigGun;
    
    public Game() throws Exception {
        renderer = new Renderer();
        manager = new EntityManager(this);

        mouseListeners = new ArrayList<>();
        renderables = new ArrayList<>();
        
        
        player = (Player) manager.create(new Player(new PVector(width / 2, height / 2)));
        cursor = (Cursor) manager.create(new Cursor(new PVector(width / 2, height / 2)));    
        bigGun = (Weapon) manager.create(new Weapon(new PVector(100, 100, -1), 30, 12, "big.png"));
    }
    
    public void render() throws Exception {
        for(Renderable renderable : renderables)
            renderer.render(renderable);
    }
    
    public void update() throws Exception {
        for(Renderable renderable : renderables)
            if(renderable instanceof Entity)
                ((Entity) renderable).update();
    }
    
    public void onMouseClicked(PVector mousePos) {
        for(MouseListener listener : mouseListeners) 
            listener.onMouseClicked(mousePos);
    }
    
    public void addMouseListener(MouseListener mouseListener) {
        this.mouseListeners.add(mouseListener);
    }
    
    public void onMouseMoved(PVector mousePos) {
        for(MouseListener listener : mouseListeners)
            listener.onMouseMoved(mousePos);
    }

    public void addBackgroundRenderable(Renderable renderable) {
        this.renderables.add(0, renderable);
    }
    
    public void addForegroundRenderable(Renderable renderable) {
        this.renderables.add(renderable);
    }
}
    
Game g;
boolean[] keys = new boolean[65535];
int recentKeyReleased = '\0';

void mouseClicked() {
    g.onMouseClicked(new PVector(mouseX, mouseY));
}

void mouseMoved() {
    g.onMouseMoved(new PVector(mouseX, mouseY));
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
    size(1280, 720, P2D);
    frameRate(144);
    noCursor();
    noFill();
    //noStroke();
    textureMode(NORMAL);
    
    try {
        g = new Game();
    } catch(Exception e) {
        e.printStackTrace();
        exit();
    }
}

void draw() {
    background(200, 200, 200);
  
    try {
        g.render();
        g.update();
    } catch(Exception e) {
        e.printStackTrace();
        exit();
    }
}
