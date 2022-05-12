package novel.engine;

import openfl.events.EventType;
import openfl.events.Event;

/** Use this class to define any custom engine events **/
class Events extends Event {
    static public var INIT_COMPLETE:EventType<Events> = "init_complete";
    static public var SCENE_COMPLETE:EventType<Events> = "scene_complete";
    static public var NEXT_FRAME:EventType<Events> = "next_frame";

    public function new(type:String, bubbles:Bool = false, cancelable:Bool = false) {
        super(type, bubbles, cancelable);
    }

    override public function clone():Events {
        return new Events(type, bubbles, cancelable);
    }
}
