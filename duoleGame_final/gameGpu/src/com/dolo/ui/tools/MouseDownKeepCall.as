package com.dolo.ui.tools
{
	import com.YFFramework.core.center.manager.update.UpdateManager;
	
	import flash.display.InteractiveObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;

	/**
	 * 辅助处理鼠标按下按钮连续执行某个函数 
	 * @author flashk
	 * 
	 */
	public class MouseDownKeepCall extends EventDispatcher
	{
		public static var downTime:int = 500;
		
		protected var _id:int;
		protected var _btn:InteractiveObject;
		protected var _fun:Function;
		protected var _frameSpace:int=1;
		protected var _count:int;
		
		/**
		 * 
		 * @param targetButton 要绑定的按钮，Sprite或者MC 
		 * @param callFunction 要调用的函数
		 * 
		 */
		public function MouseDownKeepCall(targetButton:InteractiveObject,callFunction:Function,frameSpace:int=1)
		{
			_btn = targetButton;
			_fun = callFunction;
			_frameSpace = frameSpace;
			_btn.addEventListener(MouseEvent.CLICK,addNum);
			_btn.addEventListener(MouseEvent.MOUSE_DOWN,upFrame);
		}
		
		public function addNum(event:MouseEvent=null):void
		{
			if(event != null) {
				clearTimeout(_id);
			}
			if(_fun != null) {
				_fun();
			}
			this.dispatchEvent(new Event(Event.CHANGE));
		}
		
		protected function upFrame(event:MouseEvent):void
		{
			_id = setTimeout(upFrameMain,downTime);
		}
		
		protected function upFrameMain():void
		{
			_count = 0;
//			_btn.addEventListener(Event.ENTER_FRAME,addByFrame);
			UpdateManager.Instance.framePer.regFunc(addByFrame);
			if(_btn.stage == null) return;
			_btn.stage.addEventListener(MouseEvent.MOUSE_UP,clearUpFrame);
		}
		
		protected function clearUpFrame(event:MouseEvent):void
		{
//			_btn.removeEventListener(Event.ENTER_FRAME,addByFrame);
			UpdateManager.Instance.framePer.delFunc(addByFrame);
			if(_btn.stage == null) return;
			_btn.stage.removeEventListener(MouseEvent.MOUSE_UP,clearUpFrame);
		}
		
		protected function addByFrame(event:Event=null):void
		{
			if(_count % _frameSpace == 0){
				if(_fun != null){
					_fun();
				}
				this.dispatchEvent(new Event(Event.CHANGE));
			}
			_count++;
		}
		
	}
}