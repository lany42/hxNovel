package novel.engine.factory;

import novel.engine.frame.Frame;
import novel.engine.enums.EffectType;

using StringTools;

class FrameBuilder {
    var id:String;
    var pathspec:String;

    public function new(id:String, pathspec:String) {
        this.id = id;
        this.pathspec = Engine.assetPath + pathspec;
    }

    public function show(tags:String) {
        tags = tags.trim().replace(" ", "_");
        var img = pathspec.replace("*", tags);

        SceneBuilder._currentFrame = new Frame(this.id, SPRITE);
        var future = SceneBuilder._currentFrame.load(img);
        // TODO: Add frame and future to current scene
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

        SceneBuilder._currentFrame = new Frame(this.id, TEXT);
        // TODO: Add text to frame
        // TODO: Add frame to current scene
        return this;
    }
}
