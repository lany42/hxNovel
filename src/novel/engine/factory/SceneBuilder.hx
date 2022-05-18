package novel.engine.factory;

import novel.engine.Engine;
import novel.engine.Scene;
import novel.engine.frame.Frame;

class SceneBuilder {
    static public var _currentScene:Scene;
    static public var _currentFrame:Frame;
    static public var sceneStack:Array<Scene>;

    static var INITIALIZED:Bool = false;

    public function new() {
        if (!INITIALIZED) {
            _init();
            INITIALIZED = true;
        }
        _currentScene = new Scene();
        sceneStack.push(_currentScene);
    }

    public function background(path:String) {
        _currentScene.setBackground(Engine.assetPath + path);
    }

    private function _init() {
        sceneStack = [];
        _currentScene = null;
        _currentFrame = null;
    }
}
