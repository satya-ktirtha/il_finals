public class Game {
    private ArrayList<MouseListener> mouseListeners;
    private ArrayList<Renderable> renderables;
    
    private Renderer renderer;
    private EntityManager manager;
    
    private Cursor cursor;
    private Player player;
    private Weapon bigGun;
    private Grunt grunt1;
    
    private final int MAX_GRUNTS = 1;
    
    private int grunts;
    private int boss;
    
    private int timer;
    
    public Game() throws Exception {
        renderer = new Renderer();
        manager = new EntityManager(this);

        mouseListeners = new ArrayList<>();
        renderables = new ArrayList<>();
        
        grunts = 0;
        boss = 0;
        timer = 0;
        
        player = (Player) manager.create(new Player(new PVector(width / 2, height / 2)));
        cursor = (Cursor) manager.create(new Cursor(new PVector(width / 2, height / 2)));    
        bigGun = (Weapon) manager.create(new BigGun(new PVector(width / 2 - 100, height / 2 + 100)));
    }
    
    public void render() throws Exception {
        for(Renderable renderable : renderables)
            renderer.render(renderable);
    }
    
    public void update() throws Exception {
        for(Renderable renderable : renderables)
            if(renderable instanceof Entity)
                ((Entity) renderable).update();
                
        
        if(grunts < MAX_GRUNTS) {
            if(timer % 100 == 0) {
                int xWithinWidth = floor(random(0, 2));
                float x = xWithinWidth * random(0, width) + (1 - xWithinWidth) * (-20.0f + floor(random(0,2)) * (width + 20.0f));
                float y = (1 - xWithinWidth) * random(-20.0f, height + 20.0f) + (xWithinWidth) * (-100.0f + floor(random(0,2)) * height + 50.0f);
                
                manager.create(new Grunt(new PVector(x, y), false));
                
                grunts += 1;
                
                if(grunts == MAX_GRUNTS)
                    timer = 0;
            }
        } else if(timer % 1000 == 0 && boss == 0) {
            manager.create(new Grunt(new PVector(width + 50.0f, height / 2), true));
            
            boss += 1;
        }
        
        timer += 1;
    }
    
    public void removeEntity(Entity e) {
        renderables.remove(e);
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
    noStroke();
    textureMode(NORMAL);
    
    try {
        setupConstants();
        
        g = new Game();
    } catch(Exception e) {
        e.printStackTrace();
        exit();
    }
}

void draw() {
    if(isKeyDown(' '))
        return;
        
    background(200, 200, 200);

  
    try {
        g.render();
        g.update();
    } catch(Exception e) {
        e.printStackTrace();
        exit();
    }
}
