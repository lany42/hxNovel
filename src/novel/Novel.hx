package novel;

import novel.engine.Engine;
import novel.util.Logger;

class Novel {
    var engine:Engine;

    public function new() {
        Logger.info("Starting hxNovel");
        engine = new Engine();
    }

    public function readScript(script:()->Void) {
        script(); 
        engine.finalize();
    }

    public function start() {
        engine.start();
    }
}
