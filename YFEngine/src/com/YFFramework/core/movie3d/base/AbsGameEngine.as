package com.YFFramework.core.movie3d.base
{
	/**@author yefeng
	 *2013-3-25下午9:26:42
	 */
	import com.YFFramework.core.center.manager.ResizeManager;
	import com.YFFramework.core.center.manager.update.UpdateManager;
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.movie3d.core.YFEngine;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	public class AbsGameEngine extends Sprite
	{
		public function AbsGameEngine()
		{
			init();
		}
		
		/**
		 * Global initialise function
		 */
		private function init():void
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			YFEngine.Instance.addEventListener(YFEngine.CompleteInit,initComplete);
			YFEngine.Instance.start(this,stage);
		}
		/**子类覆盖
		 */		
		protected function initComplete(e:YFEvent=null):void
		{
			initLiteners();
		}
		private function initLiteners():void
		{
			stage.addEventListener(Event.RESIZE,onResize);
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		private function onResize(e:Event=null):void
		{
			ResizeManager.Instance.resize();///摄像机投影需要
		}
		private function onEnterFrame(event : Event) : void 
		{
			UpdateManager.Instance.update();
			YFEngine.Instance.render();
		}

		
		
		
		
		
		
		
		
		
		
		
		
		
		
	}
}