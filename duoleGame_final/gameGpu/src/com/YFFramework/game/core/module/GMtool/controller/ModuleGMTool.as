package com.YFFramework.game.core.module.GMtool.controller
{
	import com.YFFramework.core.center.abs.module.AbsModule;
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.core.module.GMtool.Event.GMToolEvent;
	import com.YFFramework.game.core.module.GMtool.view.GMToolWindow;

	/***
	 *GM工具模块
	 *@author ludingchang 时间：2013-11-8 下午3:46:41
	 */
	public class ModuleGMTool extends AbsModule
	{
		private var _GMWind:GMToolWindow;
		public function ModuleGMTool()
		{
			super();
			_GMWind=new GMToolWindow();

		}
		override public function init():void
		{
			
			YFEventCenter.Instance.addEventListener(GlobalEvent.GMToolOpen,onGMopen);
		}
		
		private function onGMopen(e:YFEvent):void
		{
			_GMWind.open();
		}
	}
}