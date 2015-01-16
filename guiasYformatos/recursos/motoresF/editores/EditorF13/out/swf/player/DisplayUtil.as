package player
{
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	
	public class DisplayUtil
	{
		public static const ALIGN_LEFT:String	= "alignLeft";
		public static const ALIGN_CENTER:String	= "alignCenter";
		public static const ALIGN_RIGHT:String	= "alignRight";
		public static const ALIGN_TOP:String	= "alignTop";
		public static const ALIGN_MIDDLE:String	= "alignMiddle";
		public static const ALIGN_BOTTOM:String	= "alignBottom";
		
		
		public static function resize( src:DisplayObject, width:Number, height:Number, fitInside:Boolean = true ):void
		{
			src.width = width;
			src.scaleY = src.scaleX;
			if ( ( src.height > height ) == fitInside )
			{
				src.height = height;
				src.scaleX = src.scaleY;
			}
		}
		
		public static function resizeAndCrop( src:DisplayObject, width:Number, height:Number, hAlign:String = ALIGN_CENTER, vAlign:String = ALIGN_MIDDLE ):void
		{
			src.scrollRect = null;
			resize( src, width, height, false );
			var ratio:Number = 1 / src.scaleX;
			src.scrollRect = new Rectangle(
				getAlignOffset( src.width, width, hAlign) * ratio,
				getAlignOffset( src.height, height, vAlign) * ratio,
				width * ratio,
				height * ratio
			);
		}
		
		private static function getAlignOffset( length:Number, targetLength:Number, alignType:String ):Number
		{
			var offset:Number = 0;
			switch ( alignType )
			{
				case ALIGN_LEFT:
				case ALIGN_TOP:
					break;
					
				case ALIGN_RIGHT:
				case ALIGN_BOTTOM:
					offset = length - targetLength;
					break;
					
				default:
					offset = ( length - targetLength ) * 0.5;
					break;
			}
			return offset;
		}
		

	}
}