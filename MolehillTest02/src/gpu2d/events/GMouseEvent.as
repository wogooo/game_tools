package gpu2d.events
{
	import gpu2d.display.GDisplayObject;

	/**
	 * author :夜枫
	 * 时间 ：2011-11-13 下午12:20:09
	 */
	public final class GMouseEvent extends GEvent
	{
		public static const MOUSE_DOWN:String="mouseDown";
		public static const MOUSE_UP:String="mouseUp";
		public static const MOUSE_OVER:String="mouseOver";
		public static const MOUSE_OUT:String="mouseOut";
		public static const CLICK:String="click";
		public static const MOUSE_MOVE:String="mouseMove";
		
		public var handler:GDisplayObject;
		public var localX:Number;
		public var localY:Number;
		public var stageX:Number;
		public var stageY:Number;
		public function GMouseEvent(type:String,handler:GDisplayObject=null, bubbles:Boolean=true,localX:Number=0,localY:Number=0)
		{
			super(type, bubbles);
			this.handler=handler;
			this.localX=localX;
			this.localY=localY;
		}
	}
}