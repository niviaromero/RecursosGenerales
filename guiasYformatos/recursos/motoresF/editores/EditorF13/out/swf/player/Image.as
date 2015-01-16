﻿package player{	import flash.display.MovieClip;	import flash.display.Loader;	import flash.events.Event;	import flash.display.DisplayObject;	import flash.net.URLRequest;	import flash.display.Bitmap;	import flash.display.BitmapData;	import fl.text.TLFTextField;	import flash.display.Sprite;		public class Image extends MovieClip {		public var bg:DisplayObject;		public var _w:Number;		public var _h:Number;		public var border:Boolean = false;		protected var image:DisplayObject;		public var xml;				public function Image() {			bg = numChildren > 0 ? getChildAt(0) : null;			if(bg)				bg.visible = false;		}		public function load(xml):void		{			this.xml = xml;			var loader:Loader = new Loader();			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoaded);			trace("loading: ", xml.@path, !Player.PREVIEW_MODE, xml.@path != undefined, xml.@path is String, xml.@path.length >0);            if(!Player.PREVIEW_MODE && xml.@path != undefined)			    loader.load(new URLRequest(Player.PREFIX + xml.@path));		}				private function onLoaded(event:Event):void		{			var image = event.target.loader.content;			var bmpData:BitmapData = new BitmapData(image.width, image.height, true, 0x00FFFFFF);			bmpData.draw(image, null, null, null, null, true);			var bmp:Bitmap = new Bitmap(bmpData, "auto", true);			this.image = new Bitmap(bmpData.clone(), "auto", true);			DisplayUtil.resizeAndCrop(bmp, w, h);			//resizeMe(bmp, w, h, true);			//trace(w, h);			center(bmp, bg);			addChildAt(bmp, 0);						if(border)			{				var b:Sprite = new Sprite();				b.graphics.beginFill(0,0);				b.graphics.lineStyle(1,0);				b.graphics.drawRect(0,0,w,h);				b.graphics.endFill();				b.mouseEnabled = false;				addChild(b);				b.x = bmp.x;				b.y = bmp.y;			}			dispatchEvent(new Event(Event.COMPLETE, true));		}		private function resizeMe(mc:DisplayObject, maxW:Number, maxH:Number=0, constrainProportions:Boolean=true):void		{			var _mask			maxH = maxH == 0 ? maxW : maxH;			mc.width = maxW;			mc.height = maxH;			if (constrainProportions) {				mc.scaleX < mc.scaleY ? mc.scaleY = mc.scaleX : mc.scaleX = mc.scaleY;			}		}		private function resizeMe2(mc:DisplayObject, maxW:Number, maxH:Number=0, constrainProportions:Boolean=true):void		{			maxH = maxH == 0 ? maxW : maxH;			mc.width = maxW;			mc.height = maxH;			if (constrainProportions) {				mc.scaleX < mc.scaleY ? mc.scaleY = mc.scaleX : mc.scaleX = mc.scaleY;			}		}		private function center(mc:DisplayObject, bg:DisplayObject):void		{			if(!bg) return;			mc.x = bg.x;// + bg.width/2 - mc.width/2;			mc.y = bg.y;// + bg.height/2 - mc.height/2;		}		private function get w():Number		{			if(bg)				return bg.width;			return _w;		}		private function get h():Number		{			if(bg)				return bg.height;			return _h;		}	}	}