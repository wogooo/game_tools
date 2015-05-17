package com.YFFramework.core.proxy
{
	import com.YFFramework.core.center.manager.ResizeManager;
	
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;

	/**
	 * author :夜枫 * 时间 ：Sep 17, 2011 3:52:39 PM
	 */
	public final class StageProxy
	{
		private static var _stageProxy:StageProxy;
		public var viewRect:Rectangle;
		public var stage:Stage;
		public var mouseUp:FuncArray;
		public var mouseDown:FuncArray;
		public function StageProxy()
		{
			ResizeManager.Instance.regFunc(updateViewPort);
			mouseUp=new FuncArray();
			mouseDown=new FuncArray();
		}
		private function addEvents():void
		{
			stage.addEventListener(MouseEvent.MOUSE_DOWN,onMouseEvent);
			stage.addEventListener(MouseEvent.MOUSE_UP,onMouseEvent);
		}
		private function onMouseEvent(e:MouseEvent):void
		{
			switch(e.type)
			{
				case MouseEvent.MOUSE_UP:
					mouseUp.trigger();
					break;
				case MouseEvent.MOUSE_DOWN:
					mouseDown.trigger();
					break;
			}
		}
		
		public static function get Instance():StageProxy
		{
			if(!_stageProxy) 
			{
				_stageProxy=new StageProxy();
			}
			return _stageProxy;
		}
		
		/** 使用时 需要先进行配置 需要调用这个函数
		 */		
		public function  configure(_stage:Stage):void
		{
			stage=_stage;
			_stage.align=StageAlign.TOP_LEFT;
			_stage.scaleMode=StageScaleMode.NO_SCALE;
			_stage.quality=StageQuality.LOW;
			updateViewPort();
			addEvents();
		}
		
		private function updateViewPort():void
		{
			viewRect=new Rectangle(0,0,stage.stageWidth,stage.stageHeight);
		}
	}
}