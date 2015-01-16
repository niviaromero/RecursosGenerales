package  {
import flash.display.MovieClip;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.net.URLLoader;
import flash.net.URLRequest;
import flash.utils.getDefinitionByName;

import player.MainMenu;

import player.Section;
import player.TextUtil;
import player.BigButton;
import com.greensock.TweenMax;

public class Player extends MovieClip{

		private const XML_PATH:String = "xml/datos.xml";
		public static var PREFIX:String = "../";
		public static var PREVIEW_MODE:Boolean = false;
		//public static const PREFIX:String = "";
		
		public function Player() {
			
			visible = false;
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}

        public function preview():void
        {
            TextUtil.updateScroll = false;
            PREVIEW_MODE = true;
        }
		private function onAddedToStage(event:Event):void
		{
            if(!PREVIEW_MODE)
            {
                if(stage.loaderInfo.parameters.hasOwnProperty("path"))
                {
                    PREFIX = stage.loaderInfo.parameters.path;
                }
                //stage.scaleMode = StageScaleMode.NO_SCALE;
                //stage.align = StageAlign.TOP_LEFT;

                loadXML();
            }
            else
            {
                parseXML();
            }
		}
		
		private function loadXML():void
		{
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, onLoadedXML);
			loader.load(new URLRequest(PREFIX + XML_PATH));
		}
		
		public var xml:XML;
    private var mainMenu:MainMenu;
		private function onLoadedXML(event:Event):void
		{
			xml = new XML(event.target.data);

            parseXML();
        }

    public function parseXML():void
    {
        trace("parseXML", mainMenu, xml)
        if(mainMenu)
        {
            removeChild(mainMenu);
            mainMenu = null;
            //return;
        }
		mainMenu = new MainMenu();
		addChild(mainMenu);
        mainMenu.go(xml);
        visible = true;
    }



	}
	
}
