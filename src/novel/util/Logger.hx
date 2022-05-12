package novel.util;

/** Convenience methods for pretty-printed log statements **/
class Logger {
    static inline final INFO = "[ INFO     ] - ";
    static inline final WARN = "[ WARNING  ] - ";
    static inline final CRIT = "[ CRITICAL ] - ";
    static inline final DEBG = "[ DEBUG    ] - ";

    static inline public function print(v:Dynamic) {
        #if sys
        Sys.println(v);
        #else
        haxe.Log.trace(v, null);
        #end
    }

    static inline public function info(s:String) {
        print(INFO + s);
    }

    static inline public function warn(s:String) {
        print(WARN + s);
    }

    static inline public function crit(s:String) {
        print(CRIT + s);
    }

    static inline public function debug(s:String) {
        print(DEBG + s);
    }
}
