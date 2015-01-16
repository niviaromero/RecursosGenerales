package module.texteditor.helper
{
import flash.display.DisplayObject;
import flash.display.Loader;
import flash.display.LoaderInfo;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.net.FileFilter;
import flash.net.FileReference;
import flash.utils.ByteArray;

import flashx.textLayout.edit.IEditManager;
import flashx.textLayout.edit.SelectionState;

import spark.components.RichEditableText;

public class SWFHelper extends EventDispatcher
{
    private var fileReference:FileReference;
    private var richEditableText:RichEditableText;
    
    public function SWFHelper()
    {
    }
        public function browse(richEditableText:RichEditableText):void
        {
            this.richEditableText = richEditableText;
            fileReference = new FileReference();
            fileReference.addEventListener(Event.SELECT, onSelect);
            fileReference.browse([new FileFilter("SWF or Image File", "*.swf;*.png;*.gif")]);

        }

        private function onComplete(event:Event):void
        {
            var data:ByteArray = fileReference.data;

            var mLoader:Loader = new Loader();
            mLoader.loadBytes(data);
            mLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoaderComplete);
        }

        private function onLoaderComplete(event:Event):void
        {
            var clip:DisplayObject = LoaderInfo(event.target).loader.content;

            var slate:SelectionState = new SelectionState(
                    richEditableText.textFlow,
                    richEditableText.selectionAnchorPosition >=0 ? richEditableText.selectionAnchorPosition : richEditableText.text.length,
                    richEditableText.selectionAnchorPosition >=0 ? richEditableText.selectionActivePosition : richEditableText.text.length
            );
            var e = new EmbededImage(clip, fileReference.data);
            IEditManager(richEditableText.textFlow.interactionManager).insertInlineGraphic(e, e.width , e.height, null, slate);
            richEditableText.textFlow.flowComposer.updateAllControllers();
        }

        private function onSelect(event:Event):void
        {
            fileReference.addEventListener(IOErrorEvent.IO_ERROR, onFileLoadError);
            fileReference.addEventListener(ProgressEvent.PROGRESS, progressHandler);
            fileReference.addEventListener(Event.COMPLETE, onComplete);
            fileReference.load();
        }

        private function onFileLoadError(event:IOErrorEvent):void
        {
            //trace("error")
        }

        private function progressHandler(event:ProgressEvent):void
        {
           //trace(event.bytesLoaded / event.bytesTotal);
        }
}
}