package novel.engine.frame;

import novel.ui.UserInterface;
import novel.ui.TextBox;
import openfl.text.TextField;
import openfl.text.Font;
import openfl.display.Sprite;
import novel.util.Util;
import novel.engine.enums.EffectType;
import novel.engine.enums.FrameType;
import novel.engine.frame.LayerOpts;

class Frame extends Sprite {
    // Common to all Frames
    public var id:String;
    public var type:FrameType;

    // Sprite frames may contain layers of sprites 
    var layers:Array<Sprite>;

    // Effect frames target another frame and apply an effect
    var target:Sprite;
    var effect:EffectType;

    // Text frames display text in the text box
    var nameField:TextField;
    var textField:TextField;

    public function new(id:String, type:FrameType) {
        super();
        this.id = id;
        this.type = type;
        this.layers = [];
        this.target = null;
        this.effect = null;
        this.nameField = null;
        this.textField = null;
    }

    public function finalize(ui:UserInterface) {
        switch (type) {
            case SPRITE: {
                for (idx => layer in layers) {
                    addChild(layer);
                }
            };
            case EFFECT: {
            };
            case TEXT: {
                nameField.width = ui.textBox.width - (TextBox.DFEAULT_BORDER_BUFFER * 2);
                nameField.height = 40;

                textField.width = ui.textBox.width - (TextBox.DFEAULT_BORDER_BUFFER * 2);
                textField.height = ui.textBox.height - nameField.height;

                nameField.x = TextBox.DFEAULT_BORDER_BUFFER;
                textField.x = TextBox.DFEAULT_BORDER_BUFFER;
                textField.y = nameField.height;

                textField.multiline = true;
                textField.wordWrap = true;

                addChild(nameField);
                addChild(textField);
            };
        }
    }

    public function play() {
        switch (type) {
            case SPRITE: {};
            case EFFECT: {};
            case TEXT: {};
        }
    }

    public function loadSprite(url:String, ?opts:LayerOpts) {
        return Util.loadBitmap(url, (bitmap) -> {
            bitmap.smoothing = true;
            var sprite = new Sprite();
            sprite.addChild(bitmap);

            // Apply default opts to the sprite
            if (opts.x != null) {
                sprite.x = opts.x;
            }

            if (opts.y != null) {
                sprite.y = opts.y;
            }

            if (opts.scale != null) {
                sprite.scaleX = opts.scale;
                sprite.scaleY = sprite.scaleX;
            }

            layers.push(sprite);
        });
    }

    public function loadText(fontUrl:String, text:String, ?name:String) {
        return Util.loadFont(fontUrl, (font) -> {
            nameField = TextBox.makeTextField(font);
            textField = TextBox.makeTextField(font);

            if (name != null) {
                nameField.text = name;
            } else {
                nameField.text = id.charAt(0).toUpperCase() + id.substr(1);
            }
            textField.text = text;
        });
    }
}
