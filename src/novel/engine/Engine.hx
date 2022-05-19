package novel.engine;

import openfl.display.StageScaleMode;
import novel.engine.factory.SceneBuilder;
import openfl.Lib;
import openfl.text.Font;
import openfl.events.Event;
import openfl.display.Shape;
import openfl.display.Sprite;
import novel.engine.Scene;

class Engine extends Sprite {
    static public var title:String;
    static public var playername:String;
    static public var assetPath:String;
    static public var defaultFontName:String;

    final BORDER_DEPTH:Float = 600;

    var sceneStack:Array<Scene>;
    var currentScene:Scene;

    public function new() {
        super();
        sceneStack = [];
        currentScene = null;

        title = "hxNovel-game";
        playername = "player";
        assetPath = "./";
        defaultFontName = "";

        Lib.current.stage.scaleMode = StageScaleMode.NO_SCALE;
        Lib.current.stage.addEventListener(Event.RESIZE, stageResize);
        addEventListener(Events.SCENE_COMPLETE, advance);
    }

    public function start() {
        Lib.current.addChild(this);
    }

    // Get a ref to the sceneStack constructed by the SceneBuilder
    public function finalize() {
        this.sceneStack = SceneBuilder.sceneStack;
        advance(null);
    }

    private function advance(e:Event) {
        if (sceneStack.length > 0) {
            var next = sceneStack.shift();
            var status = next.finalize();

            status.onComplete((_) -> {
                currentScene = next;

                if (numChildren > 0) {
                    for (i in 0...numChildren) {
                        removeChildAt(i);
                    }
                }

                addChild(currentScene);
                addChild(makeBorderMask());

                stageResize(null);
            });

            status.onError((error) -> {
                trace(error);
                throw "A scene has failed to load";
            });
        } else {
            #if debug
            Logger.debug("Scene stack complete");
            #end
        }
    }

    private function makeBorderMask() {
        var border_mask_width = currentScene.maxWidth;
        var border_mask_height = currentScene.maxHeight;
        var borderMask = new Sprite();

        borderMask.addChild(makeMask(0, border_mask_height, border_mask_width, BORDER_DEPTH));
        borderMask.addChild(makeMask(border_mask_width, 0, BORDER_DEPTH, border_mask_height));
        borderMask.addChild(makeMask(0, -BORDER_DEPTH, border_mask_width, BORDER_DEPTH));
        borderMask.addChild(makeMask(-BORDER_DEPTH, 0, BORDER_DEPTH, border_mask_height));

        return borderMask;
    }

    private function makeMask(x:Float, y:Float, width:Float, height:Float) {
        var mask = new Shape();
        mask.graphics.beginFill(0x000000, 1);
        mask.graphics.drawRect(x, y, width, height);
        mask.graphics.endFill();
        return mask;
    }

    /** Rescale and recenter the game window **/
    private function resize(newWidth:Int, newHeight:Int) {
        scaleX = 1;
        scaleY = 1;

        var currentScale = 1.0;
        var currentWidth = width;
        var currentHeight = height;

        // Restrict dimensions based on the scene if applicable
        if (currentScene != null) {
            if (currentScene.maxWidth != 0 && currentScene.maxHeight != 0) {
                currentWidth = currentScene.maxWidth;
                currentHeight = currentScene.maxHeight;
            }
        }

        var maxScaleX = newWidth / currentWidth;
        var maxScaleY = newHeight / currentHeight;

        if (maxScaleX < maxScaleY) {
            currentScale = maxScaleX;
        } else {
            currentScale = maxScaleY;
        }

        // Rescale
        scaleX = currentScale;
        scaleY = currentScale;

        // Recenter
        x = (newWidth - (currentWidth * currentScale)) / 2;
        y = (newHeight - (currentHeight * currentScale)) / 2;
    }

    /** Always scale w.r.t. the stage dimensions **/
    private function stageResize(_:Event) {
        resize(Lib.current.stage.stageWidth, Lib.current.stage.stageHeight);
    }
}
