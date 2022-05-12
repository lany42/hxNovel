package novel.engine;

import novel.util.Util;
import openfl.ui.Keyboard;
import openfl.events.KeyboardEvent;
import openfl.events.MouseEvent;
import openfl.events.Event;
import openfl.display.Shape;
import openfl.utils.Future;
import openfl.display.Sprite;
import novel.engine.Frame;

class Scene extends Sprite {
    public var maxWidth:Float;
    public var maxHeight:Float;

    // NOTE: Top-level blackout mask for fading the scene
    var curtains:Shape;

    // TODO: Placeholder for overlaid GUI sprites
    var ui:Sprite;

    // TODO: Placeholder for character sprite table
    var characters:Sprite;

    var background:Sprite;

    /** Frame stack for the scene, scene ends when empty **/
    var frameStack:Array<Frame>;

    /** All futures returned due to loading external resources (default behavior) **/
    var futures:Array<Future<Bool>>;

    public function new() {
        super();
        frameStack = [];
        futures = [];
        maxWidth = 0;
        maxHeight = 0;

        curtains = new Shape();
        ui = new Sprite();
        characters = new Sprite();
        background = new Sprite();

        mouseChildren = false;
        addEventListener(Events.NEXT_FRAME, play);
        interactable(true);
    }

    public function finalize() {
        return Util.allFutures(futures)
        .then((_) -> {
            addChild(background);
            maxHeight = background.height;
            maxWidth  = background.width;

            addChild(characters);
            addChild(ui);

            curtains.graphics.beginFill(0x000000, 1);
            curtains.graphics.drawRect(0, 0, maxWidth, maxHeight);
            curtains.graphics.endFill();

            addChild(curtains);

            // TODO: finalize frame logic

            play(null);
            return Future.withValue(true);
        });
    }

    private function interactable(b:Bool) {
        if (b) {
            addEventListener(MouseEvent.CLICK, play);
            addEventListener(KeyboardEvent.KEY_DOWN, kbWrapper);
        } else {
            removeEventListener(MouseEvent.CLICK, play);
            removeEventListener(KeyboardEvent.KEY_DOWN, kbWrapper);
        }
    }

    private function kbWrapper(e:KeyboardEvent) {
        if (e.keyCode == Keyboard.SPACE) {
            play(e);
        }
    }

    private function play(e:Event) {
        interactable(false);
        if (frameStack.length > 0) {
            var next = frameStack.shift();

            // TODO: frame logic

            interactable(true);
        } else {
            parent.dispatchEvent(new Events(Events.SCENE_COMPLETE));
        }
    }
}
