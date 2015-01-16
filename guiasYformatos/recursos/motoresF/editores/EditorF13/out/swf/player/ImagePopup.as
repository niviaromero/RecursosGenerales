package  player{
	import flash.display.MovieClip;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.display.DisplayObject;
	import fl.text.TLFTextField;
	
	public class ImagePopup extends MovieClip{

		public var closeButton:SimpleButton;
		public var title:TLFTextField;
		
		public function ImagePopup() {
			closeButton.addEventListener(MouseEvent.CLICK, onClose);
		}
		public function addImage(img:DisplayObject, caption=""):void
		{
			//trace(img);
			var bdata:BitmapData = new BitmapData(img.width, img.height, false, 0xFFFFFF);
			bdata.draw(img, null, null, null, null, true);
			var bmp:Bitmap = new Bitmap(bdata, "auto", true);
			
			addChildAt(bmp, 1);
			DisplayUtil.resize(bmp, stage.stageWidth-150, stage.stageHeight-150);
			bmp.x = -bmp.width/2 + stage.stageWidth/2;
			bmp.y = -bmp.height/2 + stage.stageHeight/2;
			
			
			
			TextUtil.importText(title, caption, 20, "center");
			title.y = bmp.y + bmp.height + 10;
			title.x = bmp.x + bmp.width/2 - title.width/2;
		}
		
		private function onClose(event:MouseEvent):void
		{
			parent.removeChild(this);
		}

	}
	
}
