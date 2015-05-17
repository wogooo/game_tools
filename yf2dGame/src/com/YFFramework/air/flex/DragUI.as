package com.YFFramework.air.flex
{
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.proxy.StageProxy;
	
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	
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
			
			StageProxy.Instance.stage.removeEventListener(KeyboardEvent.KEY_DOWN,onkeyboardEvent);
			StageProxy.Instance.stage.removeEventListener(KeyboardEvent.KEY_UP,onkeyboardEvent);

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
		
		/**键盘事件
		 */		
		public function addkeyBoardAction():void
		{
			StageProxy.Instance.stage.addEventListener(KeyboardEvent.KEY_DOWN,onkeyboardEvent);
			StageProxy.Instance.stage.addEventListener(KeyboardEvent.KEY_UP,onkeyboardEvent);
		}
		private var shift:Boolean=false;
		private function onkeyboardEvent(e:KeyboardEvent):void
		{
			if(visible==false) return ;
			if(e.type==KeyboardEvent.KEY_DOWN)
			{
				if(e.keyCode==Keyboard.SHIFT) shift=true;
				var speed:int;
				if(shift) speed=10;
				else speed=1;
				
				switch(e.keyCode)
				{
					case Keyboard.UP:
						y -=speed;
						break;
					case Keyboard.DOWN:
						y +=speed;
						break;
					case Keyboard.LEFT:
						x -=speed;
						break;
					case Keyboard.RIGHT:
						x +=speed;
						break;
				}
			}
			else 
			{
				if(e.keyCode==Keyboard.SHIFT) shift=false;
			}
			
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