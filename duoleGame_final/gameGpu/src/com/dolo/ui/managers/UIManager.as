package com.dolo.ui.managers
{	
	import com.YFFramework.core.center.manager.update.UpdateManager;
	import com.YFFramework.game.ui.layer.LayerManager;
	import com.dolo.ui.controls.Panel;
	import com.dolo.ui.controls.UIComponent;
	import com.dolo.ui.controls.Window;
	import com.dolo.ui.tools.Align;
	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.setTimeout;

	/**
	 * UI对象,窗口等的管理 
	 * @author flashk
	 * 
	 */
	public class UIManager
	{

		private static var intWindows:Array = [];
		
		/** 窗口居中专用
		 * @param window
		 */		
		public static function popUpWindowToCenter(window:UIComponent):void
		{
			LayerManager.WindowLayer.addChild(window);
			Align.toCenter(window,false,window.compoWidth,window.compoHeight);
		}
		
		/**
		 * 固定窗口在右下角
		 * @param window
		 * @param offsetX 窗口距离右下角的偏移值
		 * @param offsetY 窗口距离右下角的偏移值
		 */		
		public static function popUpWindowToRightBotton(window:Sprite,offsetX:Number=0,offsetY:Number=0):void
		{
			LayerManager.WindowLayer.addChild(window);
			LayerManager.WindowLayer.mouseEnabled = false;
			if(offsetX == 0)
				offsetX=window.width;
			if(offsetY == 0)
				offsetY=window.height;
			Align.toRightBottom(window,false,offsetX,offsetY);
		}
		
		public static function removeWindow(window:Sprite):void
		{
			if(window.parent)
				LayerManager.WindowLayer.removeChild(window);
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
		public static function centerMultiWindows(window1:Window,window2:Window, gap:int = 0,whichIsTop:Window = null):void
		{
			var x1:int = 0;
			var x2:int = 0;
			var y1:int = 0;
			var y2:int = 0;
			x1 = int((UI.stage.stageWidth - window1.compoWidth - gap - window2.compoWidth) /2);
			x2 = int(x1 + window1.compoWidth + gap);
			y1 = int((UI.stage.stageHeight - window1.compoHeight) /2);
			y2 = int((UI.stage.stageHeight - window2.compoHeight) /2);
			if(Math.abs(x1-window1.x)>0 || Math.abs(y1-window1.y) > 20){
				window1.x = int((UI.stage.stageWidth - window1.compoWidth) /2);
			}
			if(Math.abs(x2-window2.x)>0 || Math.abs(y2-window2.y) > 20){
				window2.x = int((UI.stage.stageWidth - window2.compoWidth) /2);
			}
			window1.y = y1;
			window2.y = y2;
			window2.switchToTop();
			TweenLite.to(window1, 0.5, {x:x1,ease:Cubic.easeOut,alpha:1.0});
			TweenLite.to(window2, 0.5, {x:x2,ease:Cubic.easeOut,alpha:1.0});
			startIntWindows(0.5, window1,window2);
			if(whichIsTop){
				whichIsTop.setToTop();
			}
		}
		
		private static function startIntWindows(time:Number,...args):void
		{
			intWindows = args;
			UI.stage.addEventListener(Event.RENDER,checkIntWindow);
//			UI.stage.addEventListener(Event.ENTER_FRAME,stageInva);
			UpdateManager.Instance.framePer.regFunc(stageInva);
			setTimeout(stopIntWindow,time*1000+500);
			UI.stage.invalidate();
		}
		
		private static function stageInva(event:Event=null):void
		{
			UI.stage.invalidate();
		}
		private static function stopIntWindow():void
		{
			UI.stage.removeEventListener(Event.RENDER,checkIntWindow);
//			UI.stage.removeEventListener(Event.ENTER_FRAME,stageInva);
			UpdateManager.Instance.framePer.delFunc(stageInva);
		}
		
		protected static function checkIntWindow(event:Event):void
		{
			if(intWindows){
				var len:int = intWindows.length;
				for (var i:int=0;i<len;i++){
					DisplayObject(intWindows[i]).x = Math.round(DisplayObject(intWindows[i]).x);
					DisplayObject(intWindows[i]).y = Math.round(DisplayObject(intWindows[i]).y);
				}
			}
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
			startIntWindows(0.5, window);
		}

	}
}