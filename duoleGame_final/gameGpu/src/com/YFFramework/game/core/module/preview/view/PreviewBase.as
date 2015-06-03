package com.YFFramework.game.core.module.preview.view
{
	import com.dolo.ui.controls.Window;
	import com.dolo.ui.tools.Xdis;
	
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	/***
	 *预览基类
	 *@author ludingchang 时间：2014-1-11 下午3:59:36
	 */
	public class PreviewBase extends Window
	{
		protected var _left:SimpleButton;
		protected var _right:SimpleButton;
		protected var ui:Sprite;
		public function PreviewBase(backgroundBgId:int=0)
		{
			super(backgroundBgId);
			ui=initByArgument(400,350,"All.preview");
			_left=Xdis.getChildAndAddClickEvent(onClick,ui,"left_btn");
			_right=Xdis.getChildAndAddClickEvent(onClick,ui,"right_btn");
		}
		
		protected function onClick(e:MouseEvent):void
		{
		}
	}
}