package com.YFFramework.game.core.global
{
	import com.YFFramework.core.utils.common.ClassInstance;
	
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	import flash.ui.MouseCursorData;

	/**
	 * 鼠标样式统一管理
	 * 鼠标样式   flash类 只支持 32*32大小的图标   大于这个尺寸 的不可用
	 * 
	 * 样式参见 com.YFFramework.game.core.global.MouseStyle 
	 * @author Administrator
	 *   手势资源在 cursorUI.fla里面
	 */
	public class MouseManager
	{
		
		private static var _isInited:Boolean = false;
		
		public static function init():void
		{
			if(_isInited == true) return;
			_isInited = true;
			//注册鼠标样式
			///购买 图标
			regMouseData(["IconBuy"],MouseStyle.BUY);
			//出售图标
			regMouseData(["IconSell"],MouseStyle.SELL);
			//修理图标
			regMouseData(["IconFix"],MouseStyle.FIX);
			///默认光标
			regMouseData(["DefautMouseStyle"],MouseStyle.DEFAULT);
			//攻击光标
			regMouseData(["Mouse_attack"],MouseStyle.Attack,new Point(5,5));
			//拾取地上道具图标
			regMouseData(["Mouse_pick"],MouseStyle.Pick,new Point(13,15));
			//选中目标的图标  比如选中NPC 
			regMouseData(["Mouse_NPC_1","Mouse_NPC_2","Mouse_NPC_3"],MouseStyle.NPCMouse,new Point(16,13));
//			//交易图标
//			regMouseData("Mouse_trade",MouseStyle.Trade);
			resetToDefaultMouse();
			
			
			

		}
		/**  注册鼠标样式
		 * @param linkName    资源连接名称
		 * @param mouseStyle   鼠标样式
		 */		
		private static  function regMouseData(linkNameArr:Array,mouseStyle:String,hotSpot:Point=null):void
		{
			var md:MouseCursorData;
			var bds:Vector.<BitmapData>;
			md = new MouseCursorData();
			bds = new Vector.<BitmapData>();
			for each(var linkName:String in linkNameArr)
			{
				bds.push(ClassInstance.getInstance(linkName));
			}
			
			md.data = bds;
			if(hotSpot!=null)md.hotSpot=hotSpot;
			Mouse.registerCursor(mouseStyle,md);
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
			if(Mouse.cursor!=MouseCursor.AUTO)	Mouse.cursor = MouseCursor.AUTO;
//			Mouse.cursor = MouseStyle.DEFAULT;
		}
		
		
	}
}