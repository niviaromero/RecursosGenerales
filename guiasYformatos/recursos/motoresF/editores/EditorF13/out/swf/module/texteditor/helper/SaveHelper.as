package module.texteditor.helper
{
import flash.external.ExternalInterface;
import flash.utils.ByteArray;

public class SaveHelper
{
    public function SaveHelper()
    {
    }

    public static function saveText(textFlowString:String):void
    {
        var xml:XML = new XML(textFlowString);
        var images:XMLList = xml..@source;

        var byteArrays:Array = [];
        for each(var node:XML in images)
        {
            if (node.parent().name().localName == "img")
            {
                var source:String = node.parent().@source;
                if (source.indexOf("[EmbedImage") > -1)
                {
                    var nr:String = source.substring(source.indexOf("(") + 1, source.indexOf(")"));
                    var i:int = parseInt(nr);
                    node.parent().@source = "content/embeded_" + i + ".swf";
                    byteArrays.push(i);
                }
            }
        }

        ExternalInterface.call("onEditorSaveXML", "text.xml", xml.toXMLString());
        for each(var j:int in byteArrays)
        {
            ExternalInterface.call("onEditorSaveByteArray", "content/embeded_" + j + ".swf", EmbededImage.byteArrays[j]);
        }


    }

    public static function saveImage(source:ByteArray):void
    {
        ExternalInterface.call("onEditorSaveByteArray", "content/image.png", source);
    }
}
}
