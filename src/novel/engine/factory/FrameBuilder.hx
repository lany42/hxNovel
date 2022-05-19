package novel.engine.factory;

import novel.engine.frame.Frame;
import novel.engine.frame.LayerOpts;
import novel.engine.enums.EffectType;

using StringTools;

class FrameBuilder {
    var id:String;
    var pathspec:String;
    var defaultOpts:LayerOpts;

    public function new(id:String, pathspec:String, ?opts:LayerOpts) {
        this.id = id;
        this.pathspec = Engine.assetPath + pathspec;
        this.defaultOpts = null;
        if (opts != null)
            this.defaultOpts = opts;
    }

    public function show(tags:String) {
        tags = tags.trim().replace(" ", "_");
        var img = pathspec.replace("*", tags);

        SceneBuilder._currentFrame = new Frame(this.id, SPRITE);
        var future = SceneBuilder._currentFrame.loadSprite(img, defaultOpts);
        SceneBuilder._currentScene.addFrame(SceneBuilder._currentFrame, future);
        return this;
    }

    public function effect(name:EffectType) {
        SceneBuilder._currentFrame = new Frame(this.id, EFFECT);
        // TODO: Add effct to frame
        // TODO: Add frame to current scene
        return this;
    }

    public function text(text:String, ?name:String) {
        text = ~/\s+/g.replace(text, " ").trim();
        text = ~/~player~/g.replace(text, Engine.playername);

        var font = Engine.assetPath + Engine.defaultFontName;

        SceneBuilder._currentFrame = new Frame(this.id, TEXT);
        var future = SceneBuilder._currentFrame.loadText(font, text, name);
        SceneBuilder._currentScene.addFrame(SceneBuilder._currentFrame, future);
        return this;
    }
}
