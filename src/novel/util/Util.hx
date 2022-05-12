package novel.util;

import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.utils.Future;

class Util {
    /** Accept a list of futures and return a Future with their values **/
    static public function allFutures<T>(futures:Array<Future<T>>):Future<Array<T>> {
        var data:Array<T> = [];

        var current = futures[0];
        for (idx in 1...futures.length) {
            current = current.then((value) -> {
                data.push(value);
                return futures[idx];
            });
        }
        return current.then((value) -> {
            data.push(value);
            return Future.withValue(data);
        });
    }

    static public function loadBitmaps(urls:Array<String>, cb:Array<Bitmap> -> Void):Future<Bool> {
        var futures = [for (url in urls) fetchBitmap(url)];
        return allFutures(futures)
        .then((bitmaps) -> {
            cb(bitmaps);
            return Future.withValue(true);
        });
    }

    static public function loadBitmap(url:String, cb:Bitmap -> Void):Future<Bool> {
        return fetchBitmap(url)
        .then((bitmap) -> {
            cb(bitmap);
            return Future.withValue(true);
        });
    }

    static public function fetchBitmap(url:String):Future<Bitmap> {
        return BitmapData.loadFromFile(url)
        .then((data) -> {
            return Future.withValue(new Bitmap(data));
        })
        .onError((_) -> {
            throw 'Failed to load url: ${url}';
        });
    }
}
