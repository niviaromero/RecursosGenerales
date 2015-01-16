package player {
    import flash.display.Graphics;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.text.engine.FontLookup;
    import flash.text.engine.RenderingMode;
    import flash.utils.Dictionary;
    import flash.xml.XMLDocument;

    import flashx.textLayout.compose.TextFlowLine;
    import flashx.textLayout.conversion.TextConverter;
    import flashx.textLayout.elements.FlowElement;
    import flashx.textLayout.elements.FlowGroupElement;
    import flashx.textLayout.elements.ParagraphElement;
    import flashx.textLayout.elements.TextFlow;
    import flashx.textLayout.events.UpdateCompleteEvent;
    import flashx.textLayout.formats.TextLayoutFormat;
    import fl.text.TLFTextField;

    public class TextUtil {

		public function TextUtil() {
			// constructor code
		}

		public static function importText(textField:TLFTextField, text:String, fontSize=null, textAlign:String=""):void
		{
			if(text == null)
				text = "";
			if(text.indexOf("<TextFlow") != 0)
			{
				text = '<TextFlow whiteSpaceCollapse="preserve" version="2.0.0" xmlns="http://ns.adobe.com/textLayout/2008">'+text+'</TextFlow>';
			}
			var format:TextLayoutFormat = new TextLayoutFormat();
			format.fontLookup = FontLookup.EMBEDDED_CFF;
			//format.fontSize = 20;
			format.fontFamily = "Verdana";
			textField.textFlow.renderingMode = RenderingMode.CFF;
			textField.textFlow.invalidateAllFormats();
			textField.textFlow.hostFormat = format;

			textField.mouseChildren = textField.mouseEnabled = true;
			textField.embedFonts = true;


			var xml:XMLDocument = new XMLDocument(text);
			xml.ignoreWhite = true;
			var _text:String = xml.toString().replace(/[\t\r\n]/gm, "")
											.replace(/(  )+/gm, "")
											.replace(/fontFamily=\"[0-9a-zA-Z]+\"/gm, "")
											.replace(/fontLookup=\"[a-zA-Z]+\"/gm, "");
			if(textAlign!="")
			{
				_text = _text.replace(/textAlign=\"[a-zA-Z]+\"/gm, "");
			}
											//.replace(/textAlign=\"[a-zA-Z]+\"/gm, "");
											//trace(_text);
			if(fontSize!=null)
			{
				_text = _text.replace(/fontSize=\"[a-zA-Z0-9\.%]+\"/gm, "fontSize=\""+fontSize+"\"");
				//_text = _text.replace(/baselineShift=/gm, "fontSize=\""+fontSize*.8+"\" baselineShift=");
                //_text = _text.replace(/###TO_CHANGE###/gm, " fontSize=\""+fontSize+"\" ");
            }
            //trace(_text);

			textField.textFlow = TextConverter.importToFlow(_text, TextConverter.TEXT_LAYOUT_FORMAT);//todo: tfl


			//textField.textFlow.fontFamily = "Georgia";
			textField.textFlow.addEventListener(UpdateCompleteEvent.UPDATE_COMPLETE, refresh);
			refreshBullets(textField);
			textField.textFlow.hostFormat = format;

			textFieldByTextFlow[textField.textFlow] = textField;

			if(fontSize)
			{
                var tf:TextFlow = textField.textFlow;
                setFontSizeToBaselinePAragrapghs(tf, fontSize);
            }
			if(textAlign!="")
			{
				textField.textFlow.textAlign = textAlign;
			}
		}

        private static function setFontSizeToBaselinePAragrapghs(tf:FlowGroupElement, fontSize:*):void
        {
            for (var idx:int = 0; idx < tf.numChildren; idx++)
            {
                if (tf.getChildAt(idx))
                {
                    //trace("**************", tf.getChildAt(idx).baselineShift)
                    if (tf.getChildAt(idx).baselineShift != undefined &&
                            tf.getChildAt(idx).baselineShift != "0" &&
                            tf.getChildAt(idx).baselineShift != "0%")
                    {
                        tf.getChildAt(idx).fontSize = fontSize * .8;
                    }
                    else
                    {
                         tf.getChildAt(idx).fontSize = fontSize;
                    }
                    if(tf.getChildAt(idx) is FlowGroupElement)
                        setFontSizeToBaselinePAragrapghs(tf.getChildAt(idx) as FlowGroupElement, fontSize);
                }
            }
        }

        private static var textFieldByTextFlow:Dictionary = new Dictionary();

		private static function refresh(event):void
		{
			refreshBullets(textFieldByTextFlow[event.target]);
		}

		public static function refreshBullets(textField:TLFTextField):void
		{
			var bulletLayer:Sprite = textField.getChildByName("bulletSprite") as Sprite;
			if (!bulletLayer){
				bulletLayer = new Sprite();
				bulletLayer.name ="bulletSprite";
				textField.addChild(bulletLayer);
			}

			bulletLayer.graphics.clear();
			var lastP;
			for (var i:int=0; i<textField.textFlow.flowComposer.numLines; i++){
				//trace("...", i);
				var l:TextFlowLine = textField.textFlow.flowComposer.getLineAt(i);
				l.getTextLine(true);
				var p:ParagraphElement = l.paragraph as ParagraphElement;
				if (p && p.styleName == "bullet" && p != lastP){
					//trace("bullet");
					//p.get
				   // var tl:TextLine = p.getTextBlock().firstLine;
				   lastP = p;
					if(l){
						// draw's the bullet on the sprite canvas above the text lines
						var size:Number = getFontSize(p.getChildAt(0));
						var g:Graphics = bulletLayer.graphics;
						g.beginFill(0,1);
						g.drawCircle(l.x-8, l.y + l.height/2 - 2,2);
						g.endFill();
					}
				}
			}
		}

		private static function getFontSize(p:FlowElement) : Number {
			return p.computedFormat.fontSize;
		}

		public static function createTF(x, y, w, h):TLFTextField
		{
			var tf:TLFTextField = new TLFTextField();
			tf.textFlow.renderingMode = RenderingMode.CFF;
			tf.textFlow.fontLookup = FontLookup.EMBEDDED_CFF;
			tf.width = w;
			tf.selectable = false;
			tf.height = h;
			//tf.fontFamily = "Georgia";
			tf.x = x;
			tf.y = y;
			tf.embedFonts = true;
			//tf.textFlow = TextConverter.importToFlow(xml.toString(), TextConverter.TEXT_LAYOUT_FORMAT);
			return (tf);
		}

		private static var tf2s:Dictionary = new Dictionary();
		public static function show_hand_cursor(s, value):void
		{
			for (var x:Number = 0; x < s.numChildren; x++) {
				var a = s.getChildAt(x);
				if (a.hasOwnProperty("useHandCursor") == true) {
						a.useHandCursor = value;
					//}
				}
			}
		}
		public static function addScroll(s, maxW:Number = -1):void
		{
			show_hand_cursor(s, true);

			s.buttonMode = s.useHandCursor = true;
           s.addEventListener("scroll", onScroll);
			tf2s[s.scrollTarget] = s;

			//s.scrollTarget.
			s.scrollTarget.addEventListener(Event.ENTER_FRAME, onCompositionComplete);
			//if(s.maxScrollPosition == 0) s.visible = false;
			if(maxW >0)
			{
				maxes[s.scrollTarget] = maxW;
			}
         }

		private static var maxes:Dictionary = new Dictionary();
        public static var updateScroll:Boolean = true;
		private static function onCompositionComplete(event:Event):void
		{
			//tf2s[event.target].visible = event.target.height*event.target.scaleY > event.target.mask;
           try
           {
			   //trace(tf2s[event.target].visible);
               if(updateScroll)
               {
	              tf2s[event.target].visible = tf2s[event.target].maxScrollPosition > 0;

				if(maxes[event.target])
				{
					event.target.width = maxes[event.target];
					if(tf2s[event.target].visible)
						event.target.width -= tf2s[event.target].width+5;
				}
               }
			   else
			   {
				   tf2s[event.target].visible = true;
			   }

           }catch(e:*){}
		}
		public static function onScroll(event):void
		{
			var bs = event.target.scrollTarget.getChildByName("bulletSprite");
			if(bs) bs.y = -event.position;
		}
	}
}
