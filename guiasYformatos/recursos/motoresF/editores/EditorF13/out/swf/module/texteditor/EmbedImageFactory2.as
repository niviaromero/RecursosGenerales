package module.texteditor
{
import flash.display.Loader;
import flash.events.Event;
import flash.utils.ByteArray;

import flashx.textLayout.elements.InlineGraphicElement;

public class EmbedImageFactory2
{
    private var swf:InlineGraphicElement;
    private var ba:ByteArray;
    private var loader:Loader;
    private var _name:String;

    public function EmbedImageFactory2()
    {
    }

    public function createImageFromByteArray(ba:ByteArray, swf:InlineGraphicElement, name:String):void
    {
        this.swf = swf;
        this.ba = ba;
        this._name = name;
        loader = new Loader();
        loader.loadBytes(ba);
        loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete);
    }

    private function onComplete(event:Event):void
    {
        loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onComplete);
        swf.source = event.target.content;
    }
}
}
