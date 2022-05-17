package novel.engine.frame;

import openfl.display.Sprite;
import novel.util.Util;
import novel.engine.enums.EffectType;
import novel.engine.enums.FrameType;
import novel.engine.frame.LayerOpts;

class Frame extends Sprite {
    // Common to all Frames
    public var id:String;
    public var type:FrameType;

    // Sprite frames may contain layers of sprites 
    var layers:Array<Sprite>;
    var layerOpts:Array<LayerOpts>;

    // Effect frames target another frame and apply an effect
    var target:Sprite;
    var effect:EffectType;

    // Text frames display text in the text box

    public function new(id:String, type:FrameType) {
        super();
        this.id = id;
        this.type = type;
        this.layers = [];
        this.layerOpts = [];
        this.target = null;
        this.effect = null;
    }

    public function finalize() {
        switch (type) {
            case SPRITE: {
                for (idx => layer in layers) {
                    if (idx < layerOpts.length) {
                        var opts = layerOpts[idx];
                        layer.x = opts.x;
                        layer.y = opts.y;
                    }
                    addChild(layer);
                }
            };
            case EFFECT: {};
            case TEXT: {};
        }
    }

    public function play() {
        switch (type) {
            case SPRITE: {};
            case EFFECT: {};
            case TEXT: {};
        }
    }

    public function load(url:String) {
        return Util.loadBitmap(url, (bitmap) -> {
            bitmap.smoothing = true;
            var sprite = new Sprite();
            sprite.addChild(bitmap);
            layers.push(sprite);
        });
    }
}
