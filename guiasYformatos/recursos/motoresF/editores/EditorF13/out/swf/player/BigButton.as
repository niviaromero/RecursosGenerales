package player{
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.events.MouseEvent;
	import com.greensock.TweenMax;
	import flash.text.TextFieldAutoSize;
	import flash.events.Event;
	import flash.text.TextFormat;
	
	public class BigButton extends MovieClip{

		public var tf:TextField;
		public var selectable:Boolean = false;
		
		private var _selected:Boolean;
		
		public function BigButton() {
			mouseChildren = false;
			useHandCursor = buttonMode = true;
			stop();
			addEventListener(MouseEvent.ROLL_OVER, over);
			addEventListener(MouseEvent.ROLL_OUT, out);
			addEventListener(MouseEvent.MOUSE_DOWN, onDown);
			addEventListener(MouseEvent.CLICK, onClick);
			
			
		}
		private function onDown(e):void
		{
			//if(!selectable || !selected)
			//{
				gotoAndStop(3);
			
				TweenMax.to(tf, 0, {tint: 0xFFFFFF});
				stage.addEventListener(MouseEvent.MOUSE_UP, onUp);
			//}
		}
		
		private function onUp(e):void
		{
			//if(!selectable || !selected)
			//{
				
				stage.removeEventListener(MouseEvent.MOUSE_UP, onUp);
				gotoAndStop(selected ? 2:1);
			
				TweenMax.to(tf, 0, {tint: 0x0000});
			//}
		}
		
		public function set label(t:String):void
		{
			tf.text = t;
			var format:TextFormat = tf.getTextFormat();
			format.bold = true;
			tf.setTextFormat(format);
		}
		
		private function over(e):void
		{
			if(!selectable || !selected)
			{
				gotoAndStop(2);
			
				//TweenMax.to(tf, 0, {tint: 0xFFFFFF});
			}
		}
		
		private function out(e):void
		{
			if(!selectable || !selected)
			{
				gotoAndStop(1);
				TweenMax.to(tf, 0, {tint: 0x000000});
			}
		}

		private function onClick(event):void
		{
			if(!selected)
			{
				dispatchEvent(new Event(Event.CHANGE, true));
			
				selected = !selected;
			}
		}
		
		public function set selected(value:Boolean):void
		{
			if(value)
			{
				TweenMax.to(tf, 0, {tint: 0x000000});
				gotoAndStop(2);
			}
			else
			{
				TweenMax.to(tf, 0, {tint: 0x000000});
				gotoAndStop(1);
			}
			_selected = value;
		}
		
		public function get selected():Boolean
		{
			return _selected;
		}

	}
	
}
