public boolean rectangleCollision(Hitbox h1, Hitbox h2) {
    float xl = h1.getPosition().x - h1.getWidth() / 2;
    float xr = h1.getPosition().x + h1.getWidth() / 2;
    float yt = h1.getPosition().y - h1.getHeight() / 2;
    float yb = h1.getPosition().y + h1.getHeight() / 2;
    
    float pxl = h2.getPosition().x - h2.getWidth() / 2;
    float pxr = h2.getPosition().x + h2.getWidth() / 2;
    float pyt = h2.getPosition().y - h2.getHeight() / 2;
    float pyb = h2.getPosition().y + h2.getHeight() / 2;

    return !(pxl >= xr || pxr <= xl || pyt >= yb || pyb <= yt);
}

public boolean pointRectangleCollision(PVector point, Hitbox h) {
    float px = point.x;
    float py = point.y;
    
    float hw = h.getWidth();
    float hh = h.getHeight();
    float hx = h.getPosition().x;
    float hy = h.getPosition().y;
    
    return px < hx + hw / 2 && px > hx - hw / 2 && py > hy - hh / 2 && py < hy + hh / 2;
}

interface Collision2D {
    boolean collidesWith(Hitbox hitbox);
}
