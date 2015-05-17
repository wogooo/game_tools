package yf2d.events
{
	import com.YFFramework.core.event.YFEvent;
	

	/**
	 * author :夜枫
	 * 时间 ：2011-11-13 下午12:20:09
	 */
	public final class YFMouseEvent extends YFEvent
	{
		public static const MOUSE_DOWN:String="mouseDown";
		public static const MOUSE_UP:String="mouseUp";
		public static const MOUSE_OVER:String="mouseOver";
		public static const MOUSE_OUT:String="mouseOut";
		public static const CLICK:String="click";
		public static const MOUSE_MOVE:String="mouseMove";
		
		public var localX:Number;
		public var localY:Number;
		public var stageX:Number;
		public var stageY:Number;
		
		public function YFMouseEvent(type:String,param:Object=null)
		{
			super(type,param);
		}

		
//		override internal static function fromPool(type:String, param:Object=null):YFEvent
//		{
//			if (_eventPool.length) return (_eventPool.pop()).reset(type, param);
//			else return new YFMouseEvent(type, param);
//		}
//		
//		/** @private */
//		override internal static function toPool(event:YFEvent):void
//		{
//			event._param = event._target = null;
//			event._type=null;
//			_eventPool.push(event);
//		}
//		
//		/** @private */
//		override internal function reset(type:String, param:Object=null):YFEvent
//		{
//			_type = type;
//			_param = param;
//			_target = null;
//			return this;
//		}
		
		
		
	}
}