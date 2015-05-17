package
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.TouchEvent;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	
	public class ZCardGame extends Sprite
	{
		
		private var mc:MC;
		public function ZCardGame()
		{
			super();
			if(stage)  ///多线程排除
			{
				// 支持 autoOrient
				stage.align = StageAlign.TOP_LEFT;
				stage.scaleMode = StageScaleMode.NO_SCALE;
				Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT; 
				initUI();
				addEvents();
			}
		}
		
		private function initUI():void
		{
			mc=new MC(); 
			addChild(mc);	
			mc.x=(stage.stageWidth-mc.width)*0.5;
			mc.y=(stage.stageHeight-mc.height)*0.5;
		}
		 
		private function addEvents():void
		{
			mc.addEventListener(TouchEvent.TOUCH_TAP,onTouchEvent);  ///类似MouseEvent.Click
			mc.addEventListener(TouchEvent.TOUCH_MOVE,onTouchEvent);  ///类似MouseMove   比
			mc.addEventListener(TouchEvent.TOUCH_BEGIN,onTouchEvent);  //// 类似MouseEvent.MouseDown
			mc.addEventListener(TouchEvent.TOUCH_END,onTouchEvent); //// 类似MouseEvent.MouseUp
		}
		/**
		 */		
		private function onTouchEvent(e:TouchEvent):void
		{
			trace(e.type);
		}
		
		
		
	}
}