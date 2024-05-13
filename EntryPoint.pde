import processing.serial.*;

public class Game {
    private ArrayList<MouseListener> mouseListeners;
    private ArrayList<Renderable> renderables;
    private ArrayList<Renderable> objectsToRemove;
    
    private Renderer renderer;
    private EntityManager manager;
    
    private Cursor cursor;
    private Player player;
    private Weapon bigGun;
    
    private final int MAX_GRUNTS = 15;
    
    private float currentScaleMultiplier;
    private float currentSpeedMultiplier;
    private boolean hasEnded;
    private int grunts;
    private int boss;
    private int timer;
    
    public Game() throws Exception {
        this.renderer = new Renderer();
        this.manager = new EntityManager(this);

        this.mouseListeners = new ArrayList<>();
        this.renderables = new ArrayList<>();
        this.objectsToRemove = new ArrayList<>();
        
        this.grunts = 0;
        this.boss = 0;
        this.timer = 0;
        this.currentScaleMultiplier = 1.0f;
        this.currentSpeedMultiplier = 1.0f;
        
        this.player = (Player) manager.create(new Player(new PVector(width / 2, height / 2)));
        this.cursor = (Cursor) manager.create(new Cursor(new PVector(width / 2, height / 2)));    
        this.bigGun = (Weapon) manager.create(new BigGun(new PVector(random(width / 2 - 200.0f, width / 2 + 200.0f), random(height / 2 - 200.0f, height / 2 + 200.0f))));
    }
    
    public void removeLater(Entity entity) {
        objectsToRemove.add(entity);
    }
    
    public void render() throws Exception {
        for(Renderable renderable : renderables)
            renderer.render(renderable);
            
        if(hasEnded) {
            push();
            fill(100, 100, 100, 125);
            rect(0, 0, width, height);
            pop();
        }
    }
    
    public void update() throws Exception {
        if(hasEnded) {
            if(isKeyDown(' ')) {
                restart();
            }
            
            return;
        }
        
        if(arduinoPort.available() > 0) {
            String reading = arduinoPort.readStringUntil('\n');

            if(reading != null) {    
                String[] converted = reading.split(",");

                if(converted[0].equals("S")) {
                    this.manager.multEnemySpeed(float(converted[1]) / 100.0f);
                    this.currentSpeedMultiplier = float(converted[1]) / 100.0f;
                } else if(converted[0].equals("SI")) {
                    this.manager.scaleEnemies(float(converted[1]) / 100.0f);
                    this.currentScaleMultiplier = float(converted[1]) / 100.0f;
                } else if(converted[0].equals("D")) {
                    this.player.disarm();
                }
            }
        }
                
        for(Renderable renderable : renderables)
            if(renderable instanceof Entity)
                ((Entity) renderable).update();
                
        if(grunts < MAX_GRUNTS) {
            if(timer != 0 && timer % 100 == 0) {
                int xWithinWidth = floor(random(0, 2));
                float x = xWithinWidth * random(0, width) + (1 - xWithinWidth) * (-20.0f + floor(random(0,2)) * (width + 20.0f));
                float y = (1 - xWithinWidth) * random(-20.0f, height + 20.0f) + (xWithinWidth) * (-100.0f + floor(random(0,2)) * height + 100.0f);
                
                Grunt newGrunt = (Grunt) manager.create(new Grunt(new PVector(x, y), false));
                newGrunt.setScaleMultiplier(this.currentScaleMultiplier);
                newGrunt.multSpeed(this.currentSpeedMultiplier);
                
                grunts += 1;
            }
        } 
        if(timer != 0 && timer % 1000 == 0 && boss < 1) {
            Grunt newBoss = (Grunt) manager.create(new Grunt(new PVector(width + 50.0f, height / 2), true));
            newBoss.setScaleMultiplier(this.currentScaleMultiplier);
            newBoss.multSpeed(this.currentSpeedMultiplier);
            
            boss += 1;
        }
        
        for(Renderable toRemove : objectsToRemove) {
            if(toRemove instanceof Grunt) {
                if(((Grunt) toRemove).isBoss())
                    boss -=1;
                else
                    grunts -= 1;
            }
            removeEntity((Entity) toRemove);
        }
            
        objectsToRemove.clear();
        timer += 1;
    }
    
    public void endGame() {
        this.hasEnded = true;
    }
    
    public void restart() throws Exception {
        if(hasEnded) {
            this.grunts = 0;
            this.boss = 0;
            this.timer = 0;
            this.currentScaleMultiplier = 1.0f;
            this.currentSpeedMultiplier = 1.0f;
            
            this.renderables.clear();
            this.mouseListeners.clear();
            this.objectsToRemove.clear();
            
            this.player = (Player) manager.create(new Player(new PVector(width / 2, height / 2)));
            this.cursor = (Cursor) manager.create(new Cursor(new PVector(width / 2, height / 2)));    
            this.bigGun = (Weapon) manager.create(new BigGun(new PVector(random(width / 2 - 200.0f, width / 2 + 200.0f), random(height / 2 - 200.0f, height / 2 + 200.0f))));
            
            this.hasEnded = false;
        }
    }
    
    public ArrayList<Entity> getEntities() {
        ArrayList<Entity> entities = new ArrayList<>();
        
        for(Renderable renderable : renderables)
            if(renderable instanceof Entity)
                entities.add((Entity) renderable);
        
        return entities;
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
    
public Game g;

public Serial arduinoPort;

public boolean[] keys = new boolean[65535];
public int recentKeyReleased = '\0';

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
    size(1920, 1080, P2D);
    frameRate(144);
    noCursor();
    noFill();
    noStroke();
    textureMode(NORMAL);
    
    try {
        arduinoPort = new Serial(this, "COM7", 9600);
        setupConstants();
        
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
