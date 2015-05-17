package com.YFFramework.game.core.module.gameView.view
{
	import com.YFFramework.core.center.manager.keyboard.KeyBoardItem;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.ui.abs.GameWindow;
	import com.YFFramework.core.ui.layer.LayerManager;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	
	import flash.ui.Keyboard;
	import flash.utils.getTimer;

	/** 游戏中所有的全局的 键盘响应都在该类中实例化
	 * @author yefeng
	 *2012-8-11下午2:45:23
	 */
	public class KeyboardInit
	{
		
		/**当前时间
		 */ 
		private var _currentTime:Number;
		private static const SpaceCD:int=1000;///1秒按一次
		public function KeyboardInit()
		{
			_currentTime=getTimer();
			intAllKeyboard();
		}
		private function intAllKeyboard():void
		{
			var escKeyItem:KeyBoardItem=new KeyBoardItem(Keyboard.ESCAPE,escFunc);///按下esc键盘后响应
			////初始化   1 --9 键盘 
			var keyItem1:KeyBoardItem=new KeyBoardItem(Keyboard.NUMBER_1,onkeyDown);
			var keyItem2:KeyBoardItem=new KeyBoardItem(Keyboard.NUMBER_2,onkeyDown);
			var keyItem3:KeyBoardItem=new KeyBoardItem(Keyboard.NUMBER_3,onkeyDown);
			var keyItem4:KeyBoardItem=new KeyBoardItem(Keyboard.NUMBER_4,onkeyDown);
			var keyItem5:KeyBoardItem=new KeyBoardItem(Keyboard.NUMBER_5,onkeyDown);
			var keyItem6:KeyBoardItem=new KeyBoardItem(Keyboard.NUMBER_6,onkeyDown);
			var keyItem7:KeyBoardItem=new KeyBoardItem(Keyboard.NUMBER_7,onkeyDown);
			var keyItem8:KeyBoardItem=new KeyBoardItem(Keyboard.NUMBER_8,onkeyDown);
			var keyItem9:KeyBoardItem=new KeyBoardItem(Keyboard.NUMBER_9,onkeyDown);
			var keyItem0:KeyBoardItem=new KeyBoardItem(Keyboard.NUMBER_0,onkeyDown);
			//空格键 
			var keyItemSpace:KeyBoardItem=new KeyBoardItem(Keyboard.SPACE,onkeyDown);
			
		}
		
		private function onkeyDown(keyCode:int):void
		{
			switch(keyCode)
			{
				case Keyboard.NUMBER_1:
					YFEventCenter.Instance.dispatchEventWith(GlobalEvent.KeyDownNum_1);
					break;
				case Keyboard.NUMBER_2:
					YFEventCenter.Instance.dispatchEventWith(GlobalEvent.KeyDownNum_2);
					break;
				case Keyboard.NUMBER_3:
					YFEventCenter.Instance.dispatchEventWith(GlobalEvent.KeyDownNum_3);
					break;
				case Keyboard.NUMBER_4:
					YFEventCenter.Instance.dispatchEventWith(GlobalEvent.KeyDownNum_4);
					break;
				case Keyboard.NUMBER_5:
					YFEventCenter.Instance.dispatchEventWith(GlobalEvent.KeyDownNum_5);
					break;
				case Keyboard.NUMBER_6:
					YFEventCenter.Instance.dispatchEventWith(GlobalEvent.KeyDownNum_6);
					break;
				case Keyboard.NUMBER_7:
					YFEventCenter.Instance.dispatchEventWith(GlobalEvent.KeyDownNum_7);
					break;
				case Keyboard.NUMBER_8:
					YFEventCenter.Instance.dispatchEventWith(GlobalEvent.KeyDownNum_8);
					break;
				case Keyboard.NUMBER_9:
					YFEventCenter.Instance.dispatchEventWith(GlobalEvent.KeyDownNum_9);
					break;
				case Keyboard.NUMBER_0:
					YFEventCenter.Instance.dispatchEventWith(GlobalEvent.KeyDownNum_0);
					break;
				case Keyboard.SPACE://空格键
					if(getTimer()-_currentTime>=SpaceCD)
					{
						YFEventCenter.Instance.dispatchEventWith(GlobalEvent.KeyDownSpace);
						_currentTime=getTimer();
					}
					break;
			}
		}
		
		
		private function escFunc(keyCode:int):void
		{
			var len:int=LayerManager.WindowLayer.numChildren;
			if(len>0) 
			{
				var window:GameWindow=LayerManager.WindowLayer.getChildAt(len-1) as GameWindow;
				window.popBack();
			}
		}
	}
}