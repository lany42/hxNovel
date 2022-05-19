package novel.engine;

import novel.ui.UserInterface;
import novel.util.Logger;
import openfl.ui.Keyboard;
import openfl.events.KeyboardEvent;
import openfl.events.MouseEvent;
import openfl.events.Event;
import openfl.display.Shape;
import openfl.utils.Future;
import openfl.display.Sprite;
import novel.util.Util;
import novel.engine.frame.Frame;

class Scene extends Sprite {
    public var maxWidth:Float;
    public var maxHeight:Float;

    // TODO: Placeholder for overlaid GUI sprites
    var ui:UserInterface;

    // NOTE: blackout mask for fading the scene
    var curtains:Shape;

    var characters:SpriteTable;

    var background:Sprite;

    /** Frame stack for the scene, scene ends when empty **/
    var frameStack:Array<Frame>;

    /** All futures returned due to loading external resources (default behavior) **/
    var futures:Array<Future<Bool>>;

    // TODO: implement lazy construction of scenes by caching init commands
    // var initCmds:Array<Command>;

    public function new() {
        super();
        frameStack = [];
        futures = [];
        maxWidth = 0;
        maxHeight = 0;

        curtains = new Shape();
        ui = new UserInterface();
        characters = new SpriteTable();
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

            curtains.graphics.beginFill(0x000000, 1);
            curtains.graphics.drawRect(0, 0, maxWidth, maxHeight);
            curtains.graphics.endFill();
            curtains.alpha = 0;
            addChild(curtains);

            ui.finalize(maxWidth, maxHeight);
            addChild(ui);

            for (frame in frameStack) {
                frame.finalize(ui);
            }

            play(null);
            return Future.withValue(true);
        });
    }

    public function setBackground(path:String) {
        var future = Util.loadBitmap(path,
            (bitmap) -> {
                bitmap.smoothing = true;
                background.addChild(bitmap);
            }
        );
        futures.push(future);
    }

    public function addFrame(frame:Frame, ?future:Future<Bool>) {
        frameStack.push(frame);
        if (future != null) {
            futures.push(future);
        }
    }

    private function interactable(b:Bool) {
        if (b) {
            addEventListener(MouseEvent.CLICK, play);
            //addEventListener(KeyboardEvent.KEY_DOWN, kbWrapper);
        } else {
            removeEventListener(MouseEvent.CLICK, play);
            //removeEventListener(KeyboardEvent.KEY_DOWN, kbWrapper);
        }
    }

    // FIXME: Keyboard events don't bubble down like MouseEvents
    //private function kbWrapper(e:KeyboardEvent) {
    //    Logger.debug("KB key pressed");
    //    trace(e.charCode);
    //    trace(e.keyCode);
    //    if (e.keyCode == Keyboard.SPACE) {
    //        Logger.debug("Advancing scene on SPACE key");
    //        play(e);
    //    }
    //}

    private function play(e:Event) {
        interactable(false);
        if (frameStack.length > 0) {
            var next = frameStack.shift();
            Logger.debug('Playing frame ID: ${next.id}, Type: ${next.type}');

            switch (next.type) {
                case SPRITE: {
                    updateSpriteTable(next);
                };
                case EFFECT: {};
                case TEXT: {
                    showText(next);
                };
            }

            interactable(true);
        } else {
            Logger.debug("Scene complete, notifying Engine");
            parent.dispatchEvent(new Events(Events.SCENE_COMPLETE));
        }
    }

    private function updateSpriteTable(frame:Frame) {
        if (characters.includes(frame.id)) {
            characters.replaceSprite(frame.id, frame);
        } else {
            characters.addSprite(frame.id, frame);
            characters.recenter(maxWidth, maxHeight);
        }
    }

    private function showText(frame:Frame) {
        if (ui.numChildren > 0) {
            ui.textBox.removeChildAt(0);
        }
        ui.textBox.addChild(frame);
    }
}
