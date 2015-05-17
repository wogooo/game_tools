package com.YFFramework.game.core.global
{
	import com.YFFramework.core.utils.common.ClassInstance;
	
	import flash.display.BitmapData;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	import flash.ui.MouseCursorData;

	/**
	 * 鼠标样式统一管理
	 * 
	 * 样式参见 com.YFFramework.game.core.global.MouseStyle 
	 * @author Administrator
	 * 
	 */
	public class MouseManager
	{
		
		private static var _isInited:Boolean = false;
		
		public static function init():void
		{
			if(_isInited == true) return;
			_isInited = true;
			
			//注册鼠标样式
			var md:MouseCursorData;
			var bds:Vector.<BitmapData>;
			
			md = new MouseCursorData();
			bds = new Vector.<BitmapData>();
			bds.push(ClassInstance.getInstance("IconBuy"));
			md.data = bds;
			Mouse.registerCursor(MouseStyle.BUY,md);
			
			md = new MouseCursorData();
			bds = new Vector.<BitmapData>();
			bds.push(ClassInstance.getInstance("IconSell"));
			md.data = bds;
			Mouse.registerCursor(MouseStyle.SELL,md);
			
			md = new MouseCursorData();
			bds = new Vector.<BitmapData>();
			bds.push(ClassInstance.getInstance("IconFix"));
			md.data = bds;
			Mouse.registerCursor(MouseStyle.FIX,md);
			
			md = new MouseCursorData();
			bds = new Vector.<BitmapData>();
			bds.push(ClassInstance.getInstance("DefautMouseStyle"));
			md.data = bds;
			Mouse.registerCursor(MouseStyle.DEFAULT,md);
			
			resetToDefaultMouse();
		}
		
		/**
		 * 样式参见 com.YFFramework.game.core.global.MouseStyle  
		 * @param style
		 * 
		 */
		public static function changeMouse(style:String):void
		{
			Mouse.cursor = style;
		}
		
		/**
		 * 将鼠标设回默认鼠标 
		 * 
		 */
		public static function resetToDefaultMouse():void
		{
//			Mouse.cursor = MouseCursor.AUTO;
			Mouse.cursor = MouseStyle.DEFAULT;
		}
	}
}