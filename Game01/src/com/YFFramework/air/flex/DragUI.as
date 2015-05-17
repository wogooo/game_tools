package com.YFFramework.air.flex
{
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.proxy.StageProxy;
	
	import flash.events.MouseEvent;
	
	import mx.events.FlexEvent;

	/**
	 *  @author yefeng
	 *   @time:2012-4-5下午08:58:15
	 */
	public class DragUI extends FlexUI
	{
		private var _isRemoveDrag:Boolean;
		private static var isInit:Boolean=false;
		public function DragUI(autoRemove:Boolean=false)
		{
			super(autoRemove);
			if(isInit==false&&StageProxy.Instance.stage==null)	 YFEventCenter.Instance.addEventListener("stageInit",addEvents0);
			else addEvents0();
			buttonMode=true;
		}
		private function addEvents0(e:YFEvent=null):void
		{
			isInit=true;
			_isRemoveDrag=false;
			YFEventCenter.Instance.removeEventListener("stageInit",addEvents0);
			starDrag();
		}
		private function removeEvents0():void
		{	_isRemoveDrag=true;
			removeEventListener(MouseEvent.MOUSE_DOWN,onMouseEvent);
			StageProxy.Instance.stage.removeEventListener(MouseEvent.MOUSE_UP,onMouseEvent);
		}
		private function onMouseEvent(e:MouseEvent):void
		{
			switch(e.type)
			{
				case MouseEvent.MOUSE_DOWN:
					startDrag();
					break;
				case MouseEvent.MOUSE_UP:
					stopDrag();
					break;
			}
		}
		
		public function  removeDrag():void
		{
			removeEvents0();
			buttonMode=false;
		}
		
		public function starDrag():void
		{
			buttonMode=true;
			addEventListener(MouseEvent.MOUSE_DOWN,onMouseEvent);
			StageProxy.Instance.stage.addEventListener(MouseEvent.MOUSE_UP,onMouseEvent);
		}
		override public function dispose(e:FlexEvent=null):void
		{
			super.dispose();
			if(!_isRemoveDrag)	removeEvents0();
		}

	
		
	}
}