package module.texteditor
{
import flash.display.Loader;
import flash.events.Event;
import flash.utils.ByteArray;

import flashx.textLayout.elements.InlineGraphicElement;

import module.texteditor.helper.EmbededImage;

public class EmbedImageFactory
{
    private var swf:InlineGraphicElement;
    private var ba:ByteArray;
    private var loader:Loader;
    private var _name:String;
    public function EmbedImageFactory()
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
        swf.source = new EmbededImage(event.target.content, ba, _name);
    }
}
}
