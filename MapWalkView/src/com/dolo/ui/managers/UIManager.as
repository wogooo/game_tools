package com.dolo.ui.managers
{	
	import com.YFFramework.core.ui.layer.LayerManager;
	import com.dolo.ui.controls.Window;
	import com.dolo.ui.tools.Align;
	import com.greensock.TweenLite;
	import flash.display.Sprite;
	import com.greensock.easing.Cubic;

	/**
	 * UI对象,窗口等的管理 
	 * @author flashk
	 * 
	 */
	public class UIManager
	{

		public static function popWindow(window:Sprite,align:String="center"):void
		{
			LayerManager.WindowLayer.addChild(window);
			Align.toCenter(window,false,Object(window).compoWidth,Object(window).compoHeight);
		}
		
		public static function switchOpenClose(window:Window,align:String="center"):void
		{
			window.switchOpenClose();
		}
		
		/**
		 * 将两个Window居中对齐 
		 * @param window1
		 * @param window2
		 * 
		 */
		public static function centerMultiWindows(window1:Window,window2:Window, gap:int = 0):void
		{
			var x1:int = 0;
			var x2:int = 0;
			x1 = int((UI.stage.stageWidth - window1.compoWidth - gap - window2.compoWidth) /2);
			x2 = int(x1 + window1.compoWidth + gap);
			window1.x = int((UI.stage.stageWidth - window1.compoWidth) /2);
			window1.y = int((UI.stage.stageHeight - window1.compoHeight) /2);
			window2.x = int((UI.stage.stageWidth - window2.compoWidth) /2);
			window2.y = int((UI.stage.stageHeight - window2.compoHeight) /2);
			window2.switchToTop();
			TweenLite.to(window1, 0.5, {x:x1,ease:Cubic.easeOut,alpha:1.0});
			TweenLite.to(window2, 0.5, {x:x2,ease:Cubic.easeOut,alpha:1.0});
		}
		
		/**
		 * 将一个窗口缓动移到中央 
		 * @param window
		 * 
		 */
		public static function tweenToCenter(window:Window):void
		{
			var x:int = int((UI.stage.stageWidth - window.compoWidth) /2);
			var y:int = int((UI.stage.stageHeight - window.compoHeight) /2);
			TweenLite.to(window, 0.5, {x:x,y:y,ease:Cubic.easeOut});
		}

	}
}