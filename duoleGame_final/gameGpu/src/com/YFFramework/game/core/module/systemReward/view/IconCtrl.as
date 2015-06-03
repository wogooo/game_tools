package com.YFFramework.game.core.module.systemReward.view
{
	import com.YFFramework.game.core.global.util.UIPositionUtil;
	import com.YFFramework.game.ui.layer.LayerManager;
	import com.dolo.ui.controls.IconImage;
	import com.dolo.ui.tools.Xdis;
	
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.text.TextField;

	/***
	 *icon控制类
	 *@author ludingchang 时间：2013-9-6 下午4:39:06
	 */
	public class IconCtrl
	{

		private var _ui:Sprite;
		private var _icon:IconImage;
		private var _num_txt:TextField;
		public function IconCtrl(ui:Sprite)
		{
			_ui=ui;
			_icon=Xdis.getChild(ui,"icon_iconImage");
			_num_txt=Xdis.getTextChild(ui,"num_txt");
			_num_txt.text="x1";
			_num_txt.mouseEnabled=false;
			_num_txt.mouseWheelEnabled=false;
		}
		public function set url(v:String):void
		{
			_icon.url=v;
		}
		
		public function get num_txt():TextField
		{
			return _num_txt;
		}
		
		public function get icon():IconImage
		{
			return _icon;
		}
		
		public function set visible(v:Boolean):void
		{
			_ui.visible=v;
		}
		public function get visible():Boolean
		{
			return _ui.visible;
		}
		
		/**移除 数字*/
		public function hideNum():void
		{
			_num_txt.parent.removeChild(_num_txt);
		}
		
	}
}