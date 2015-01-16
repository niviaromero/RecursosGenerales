package module.texteditor.helper
{
import editor.Zip;

import flash.display.DisplayObject;
import flash.display.MovieClip;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.utils.ByteArray;
import flash.utils.Dictionary;

import mx.core.FlexGlobals;

public class EmbededImage extends MovieClip
{
    private static var i:uint = 0;
    private var _border:Sprite;
    public static var byteArrays:Array;
    private var ii:int;

    public static var cache:Dictionary
    private var _name:String;

    // [Embed("/module/texteditor/assets/swf.gif")]
    // public static var swf:Class;

    public function EmbededImage(clip:DisplayObject, ba:ByteArray, __name:String = null)
    {
        if (!__name)
        {
            ii = i;
            i++;
            _name = "medias/" + ii + ".swf"
        }
        else
        {
            _name = __name;
        }
        super();
        addChild(clip);
        mouseChildren = false;
        border.visible = true;
        Zip.getInstance().imagesForSave[toString()] = ba;

        addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
    }

    private function onAddedToStage(event:Event):void
    {
        FlexGlobals.topLevelApplication.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
    }

    private function onMouseDown(event:MouseEvent):void
    {
        if (event.target == this)
        {
            // border.visible = false;
        }
        else
        {
            border.visible = false;
        }
    }

    private function get border():Sprite
    {
        return _border || createBorder();
    }

    private function createBorder():Sprite
    {
        _border = new Sprite();
        _border.graphics.clear();
        _border.graphics.lineStyle(1, 0, .5);
        _border.graphics.beginFill(0x00FFFF, 0);
        _border.graphics.drawRect(0, 0, width, height);
        _border.graphics.endFill();
//        var _swf = new swf();
//        _swf.x = 2;
//        _swf.y = 2;
//        _border.addChild(_swf);
        addChild(_border);
        return _border;
    }


    override public function get width():Number
    {
        return super.width < 20 ? 20 : super.width;
    }

    override public function get height():Number
    {
        return super.height < 20 ? 20 : super.height;
    }

    override public function toString():String
    {
        return _name;
    }
}
}