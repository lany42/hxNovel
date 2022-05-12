package novel.engine;

import motion.Actuate;
import motion.easing.Quad;
import openfl.display.DisplayObject;

typedef AnimOpts = {
    var ?duration   : Float;
    var ?delay      : Float;
    var ?repeats    : Int;
    var ?alpha      : Float;
    var ?y_travel   : Float;
    var ?x_travel   :Float;
}

typedef AnimFunc = (DisplayObject, ?AnimOpts) -> Void;

enum Effects {
    FADE_IN;
    FADE_OUT;
    SLIDE;
    BOUNCE;
    OSCILLATE;
}

// TODO: Rework, possibly break out
class Animations {
    //static public function getAnimation(sfx:Effects):AnimFunc {
    //}

    static public function getDefaultOpts(sfx:Effects):AnimOpts {
        var defaults:AnimOpts = {
            duration: 1,
            delay: 0,
            repeats: 1,
            alpha: 1,
            y_travel: 0,
            x_travel: 0
        };

        // TODO: Set default opts per type

        return defaults;
    }

    static public function checkOpts(e:Effects, ?opts:AnimOpts) {
        var defaults = getDefaultOpts(e);

        if (opts != null) {
            if (opts.delay != null)
                defaults.delay = opts.delay;

            if (opts.duration != null)
                defaults.duration = opts.duration;

            if (opts.repeats != null)
                defaults.repeats = opts.repeats;

            if(opts.y_travel != null)
                defaults.y_travel = opts.y_travel;

            if (opts.x_travel != null)
                defaults.x_travel = opts.x_travel;
        }

        return defaults;
    }

    static public function fadeIn(obj:DisplayObject, ?opts:AnimOpts) {
        opts = checkOpts(FADE_IN, opts);

        obj.alpha = 0;
        var tween = Actuate.tween(obj, opts.duration, {alpha: 1});
        #if sys
        tween.autoVisible(false);
        #end

        if (opts.delay > 0)
            tween.delay(opts.delay);
    }

    static public function fadeOut(obj:DisplayObject, ?opts:AnimOpts) {
        opts = checkOpts(FADE_OUT, opts);

        obj.alpha = 1;
        var tween = Actuate.tween(obj, opts.duration, {alpha: 0});
        #if sys
        tween.autoVisible(false);
        #end

        if (opts.delay > 0)
            tween.delay(opts.delay);
    }

    static public function bounce(obj:DisplayObject, ?opts:AnimOpts) {
        opts = checkOpts(BOUNCE, opts);
        var duration = opts.duration;
        var repeats = (opts.repeats > -1) ? (opts.repeats * 2) - 1 : -1;

        var tween = Actuate.tween(obj, duration, {y:-60}).reflect().repeat(repeats).ease(Quad.easeOut);

        if (opts.delay > 0)
            tween.delay(opts.delay);
    }

    static public function slide(obj:DisplayObject, ?opts:AnimOpts) {
        opts = checkOpts(SLIDE, opts);

        var tween = Actuate.tween(obj, opts.duration, {x: obj.x + opts.x_travel, y: obj.y + opts.y_travel}).ease(Quad.easeInOut);

        if (opts.delay > 0)
            tween.delay(opts.delay);
    }

    static inline public function y_oscillate(e:Effects, obj:DisplayObject, ?opts:AnimOpts) {
        opts = checkOpts(e, opts);
        var start_y = obj.y;

        var tween = Actuate.tween(obj, opts.duration, {y: start_y + opts.y_travel}).reflect().repeat().ease(Quad.easeInOut);

        if (opts.delay > 0)
            tween.delay(opts.delay);
    }

    static public function osccilate(obj:DisplayObject, ?opts:AnimOpts) {
        y_oscillate(OSCILLATE, obj, opts);
    }
}
