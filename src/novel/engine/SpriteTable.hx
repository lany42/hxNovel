package novel.engine;

import openfl.display.Sprite;
import novel.engine.frame.Frame;

class SpriteTable extends Sprite {
    static inline final SPRITE_BUFFER:Float = 10;
    
    var keys:Array<String>;
    var sprites:Map<String, Frame>;

    public function new() {
        super();
        keys = [];
        sprites = [];
    }

    public function recenter(bgWidth:Float, bgHeight:Float) {
        this.x = (bgWidth - this.width)/2;

        #if debug
        graphics.clear();
        graphics.beginFill(0x000000);
        graphics.drawRect(0, 0, width, height);
        graphics.endFill();
        #end
    }

    public function includes(id:String) {
        return keys.contains(id);
    }

    public function get(id:String) {
        return sprites[id];
    }

    public function addSprite(id:String, sprite:Frame) {
        if (keys.indexOf(id) == -1) {
            keys.push(id);
        }

        sprites[id] = sprite;
        positionSprites();

        addChild(sprites[id]);
    }

    public function replaceSprite(id:String, sprite:Frame) {
        if (keys.indexOf(id) > -1) {
            removeChild(sprites[id]);

            sprites[id] = sprite;
            addChild(sprites[id]);

            positionSprites();
        }
    }

    public function removeSprite(id:String) {
        if (keys.remove(id)) {
            removeChild(sprites[id]);

            sprites.remove(id);
            positionSprites();
        }
    }

    private function positionSprites() {
        var offset:Float = 0;
        for (id in keys) {
            var sprite = sprites[id];

            sprite.x = offset;
            offset += SPRITE_BUFFER + sprite.width;

            //if (sprite.y_shift != ShiftsY.NULL) {
            //    sprite.y = cast sprite.y_shift;
            //}
        }
    }
}
