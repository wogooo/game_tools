package component
{
	import com.YFFramework.air.flex.DragUI;
	import com.YFFramework.core.proxy.StageProxy;
	
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	
	import mx.events.FlexEvent;

	/**
	 *  @author yefeng
	 *   @time:2012-4-5下午08:54:02
	 */
	public class BloodComponent extends DragUI
	{
		private var blood:Blood;
		public function BloodComponent()
		{
			super(false);
		}
		
		override public function dispose(e:FlexEvent=null):void
		{
			// TODO Auto Generated method stub
			super.dispose(e);
			blood=null;
		}
		
		public function addAction():void
		{
			StageProxy.Instance.stage.addEventListener(KeyboardEvent.KEY_DOWN,onkeyboardEvent);
			StageProxy.Instance.stage.addEventListener(KeyboardEvent.KEY_UP,onkeyboardEvent);
		}
		
		override protected function removeEvent():void
		{
			// TODO Auto Generated method stub
			super.removeEvent();
			StageProxy.Instance.stage.removeEventListener(KeyboardEvent.KEY_DOWN,onkeyboardEvent);
			StageProxy.Instance.stage.removeEventListener(KeyboardEvent.KEY_UP,onkeyboardEvent);

		}
		
		
		override protected function initUI():void
		{
			// TODO Auto Generated method stub
			super.initUI();
			blood=new Blood();
			addElement(blood);
			mouseChildren=false;
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
		
		
	}
}