package novel.ui;

import openfl.text.Font;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.display.Sprite;

class TextBox extends Sprite {
    static inline public final DEFAULT_FONT_SIZE:Int = 36;
    static inline public final DFEAULT_BORDER_BUFFER:Float = 10;

    final DEFAULT_WIDTH = 0.80;
    final DEFAULT_HEIGHT = 0.15;

    public function new() {
        super();
    }

    public function finalize(maxWidth:Float, maxHeight:Float) {
        graphics.beginFill(0x000000, 0.5);
        graphics.drawRect(0, 0,
            DEFAULT_WIDTH * maxWidth,
            DEFAULT_HEIGHT * maxHeight
        );
        graphics.endFill();

        x = (maxWidth - width) / 2;
        y = (maxHeight - height);
    }

    static public function makeTextField(font:Font) {
        var format = new TextFormat(font.fontName, DEFAULT_FONT_SIZE, 0xFFFFFF);
        var text = new TextField();
        text.defaultTextFormat = format;
        text.selectable = false;
        return text;
    }
}
