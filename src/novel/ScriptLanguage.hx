package novel;

import novel.engine.Engine;
import novel.engine.frame.LayerOpts;
import novel.engine.factory.SceneBuilder;
import novel.engine.factory.FrameBuilder;

typedef SpriteOpts = LayerOpts;

class ScriptLanguage {
    /** Register the root path for all game assets **/
    private function assets(path:String) {
        Engine.assetPath = path;
    }

    /** Select the default text font **/
    private function font(name:String) {
        Engine.defaultFontName = name;
    }

    /** Set the game's main title **/
    private function title(name:String) {
        Engine.title = name;
    }

    /** Set the player's default name **/
    private function playername(name:String) {
        Engine.playername = name;
    }

    /** Register a character with the game **/
    private function character(id:String, pathspec:String, ?opts:LayerOpts) {
        return new FrameBuilder(id, pathspec, opts);
    }

    /** Start a new scene **/
    private function scene(name:String) {
        return new SceneBuilder();
    }

    /** Text said by the player **/
    // NOTE: These are handled differently than all other frames
    private function text(text:String) {
        new FrameBuilder("", "").text(text);
    }
}
