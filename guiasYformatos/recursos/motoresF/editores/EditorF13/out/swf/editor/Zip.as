package editor
{
import flash.events.Event;
import flash.net.URLLoader;
import flash.net.URLLoaderDataFormat;
import flash.net.URLRequest;
import flash.utils.ByteArray;
import flash.utils.ByteArray;
import flash.utils.ByteArray;
import flash.utils.Dictionary;
import flash.utils.IDataInput;

import nochump.util.zip.ZipEntry;
import nochump.util.zip.ZipFile;
import nochump.util.zip.ZipOutput;

public class Zip
{
    private static var instance:Zip;
    private var model:Model = Model.getInstance();
    private var entries:Array;
    private var byteArrays:Array;


    public var imagesForSave:Dictionary = new Dictionary();

    private var filesToInclude = ["js/swfobject.js", "swf/player.swf", /*"swf/textLayout_2.0.0.232.swz",*/ "player.html", "editor.html", "swf/editor.swf",
	];
	
    public var basicFiles:Dictionary = new Dictionary();

    public function Zip()
    {
    }

    public function loadFilesToInclude():void
    {
        if (filesToInclude.length == 0)
        {
            Model.getInstance().allFilesReady = true;
            return;
        }
        trace("loading: ", filesToInclude[filesToInclude.length - 1]);
        var loader:URLLoader = new URLLoader();
        loader.dataFormat = URLLoaderDataFormat.BINARY;
        loader.addEventListener(Event.COMPLETE, onComplete);
        loader.load(new URLRequest(filesToInclude[filesToInclude.length - 1]));
    }

    private function onComplete(event:Event):void
    {
        var name:String = filesToInclude.pop();
        trace("loaded:", name);
        var data:ByteArray = new ByteArray();
        data.writeBytes(event.target.data);
        basicFiles[name] = data;

        loadFilesToInclude();
    }

    public static function getInstance():Zip
    {
        instance ||= new Zip();
        return instance;
    }

    public function parseZip(data:ByteArray):void
    {
        entries = [];
        byteArrays = [];
        var loadedData:IDataInput = data;
        var zipFile:ZipFile = new ZipFile(loadedData);
        for (var i:int = 0; i < zipFile.entries.length; i++)
        {
            var entry:ZipEntry = zipFile.entries[i];
            trace(entry.name);
            // extract the entry's data from the zip
            var data:ByteArray = zipFile.getInput(entry);
            byteArrays[entry.name] = data;
            if (entry.name == "xml/datos.xml")
            {
                var xml:XML = new XML(data.toString());
                model.xml = xml;
            }
            else
            {
                entries.push(entry);
            }

            if (entry.name.indexOf("medias/") == 0)
            {
                imagesForSave[entry.name] = data;
            }
            //trace(data.toString());
        }
    }

    public function makeZip():ByteArray
    {
        var zipOut:ZipOutput = new ZipOutput();

        //old files
        /*
        for each(var old:ZipEntry in entries)
        {
            if (old.name.charAt(old.name.length - 1) != "/")
            {
                var ba:ByteArray = new ByteArray();
                ba.writeBytes(byteArrays[old.name]);
                addFile(zipOut, old.name, ba);
            }
        }*/

        //images
        for (var imageName:String in imagesForSave)
        {
            addFile(zipOut, imageName, imagesForSave[imageName]);
        }

        //basic files
        for (var fileName:String in basicFiles)
        {
            addFile(zipOut, fileName, basicFiles[fileName]);
        }

        model.xml.@copy = Editor.COPY;
        model.xml.@version = Editor.VERSION;
        
        //xml
        var fileData:ByteArray = new ByteArray();
        fileData.writeUTFBytes(model.xml);
        addFile(zipOut, "xml/datos.xml", fileData);


        zipOut.finish();
        return zipOut.byteArray;
    }

    private function addFile(zipOut:ZipOutput, fileName:String, fileData:ByteArray):void
    {
	  if (fileName.lastIndexOf("/") == fileName.length - 1)
        {
            return;
        }
        var ze:ZipEntry = new ZipEntry(fileName);
        zipOut.putNextEntry(ze);
        zipOut.write(fileData);
        zipOut.closeEntry();
    }


}
}
