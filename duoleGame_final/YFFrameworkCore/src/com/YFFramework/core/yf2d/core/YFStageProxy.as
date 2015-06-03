package com.YFFramework.core.yf2d.core
{
	import flash.display.Stage;
	import flash.events.Event;

	/**@author yefeng
	 * 2013 2013-8-30 上午10:30:09 
	 */
	public class YFStageProxy
	{
		/**渲染 范围的 最大 最小值
		 */		
		public var minX:int;
		public var maxX:int;
		
		public var minY:int;
		public var maxY:int;

		/**
		 *  512 *512的地表  注册点在中心  力量上只需要 256  考虑震频  给他400
		 */		
		private static  const Len:int=400;
	
		private static var _instance:YFStageProxy;
		public var stage:Stage;
		public function YFStageProxy()
		{	
			
			minX=-Len;
			minY=-Len;
		}
		
		public static function get Instance():YFStageProxy
		{
			if(!_instance)_instance=new YFStageProxy();
			return _instance;
		}
		
		public function initStage(stage:Stage):void
		{
			this.stage=stage;
			stage.addEventListener(Event.RESIZE,onResize);
			onResize();
		}
		private function onResize(e:Event=null):void
		{
			maxX=stage.stageWidth+Len;
			maxY=stage.stageWidth+Len;
		}
		
	}
}