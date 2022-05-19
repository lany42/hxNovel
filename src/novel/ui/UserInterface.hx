package novel.ui;

import openfl.display.Sprite;

// TODO: Expand this class to hold all UI elements
class UserInterface extends Sprite {
    public var textBox:TextBox;

    public function new() {
        super();
        textBox = new TextBox();
    }

    public function finalize(maxWidth:Float, maxHeight:Float) {
        textBox.finalize(maxWidth, maxHeight);
        addChild(textBox);
    }
}
