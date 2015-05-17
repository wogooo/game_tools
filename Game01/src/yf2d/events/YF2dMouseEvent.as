package yf2d.events
{
	import yf2d.display.DisplayObject2D;
	
	/**
	 * author :夜枫
	 * 时间 ：2011-11-13 下午12:20:09
	 */
	public final class YF2dMouseEvent extends YF2dEvent
	{
		private static const Path:String="yf2d.events.";
		public static const MOUSE_DOWN:String=Path+"mouseDown";
		public static const MOUSE_UP:String=Path+"mouseUp";
		public static const MOUSE_OVER:String=Path+"mouseOver";
		public static const MOUSE_OUT:String=Path+"mouseOut";
		public static const CLICK:String=Path+"click";
		public static const MOUSE_MOVE:String=Path+"mouseMove";
		
		public var handler:DisplayObject2D;
		public var localX:Number;
		public var localY:Number;
		public var stageX:Number;
		public var stageY:Number;
		public function YF2dMouseEvent(type:String,handler:DisplayObject2D=null, bubbles:Boolean=true,localX:Number=0,localY:Number=0)
		{
			super(type, bubbles);
			this.handler=handler;
			this.localX=localX;
			this.localY=localY;
		}
	}
}