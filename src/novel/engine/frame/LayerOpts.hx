package novel.engine.frame;

import novel.engine.enums.EffectType;

class LayerOpts {
    public var x:Float;    
    public var y:Float;
    public var effect:EffectType;
    public var effectOpts:Float; // TODO: Placeholder

    public function new(?x:Float, ?y:Float, ?effect:EffectType, ?effectOpts:Float) {
        this.x = (x == null) ? 0 : x;
        this.y = (y == null) ? 0 : y;
        this.effect = (effect == null) ? null : effect;
    }
}
