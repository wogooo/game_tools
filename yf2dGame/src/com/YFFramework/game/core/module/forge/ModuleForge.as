package com.YFFramework.game.core.module.forge
{
	/**@author yefeng
	 *2012-8-21下午10:24:33
	 */
	import com.YFFramework.core.center.abs.module.AbsModule;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.core.module.forge.view.ForgeWindow;
	import com.YFFramework.game.core.scence.TypeScence;
	
	public class ModuleForge extends AbsModule
	{
		protected var _forgeWindow:ForgeWindow
		public function ModuleForge()
		{
			_belongScence=TypeScence.ScenceGameOn;
		}
		
		override public function show():void
		{
			_forgeWindow=new ForgeWindow();
			addEvents();
		}
		private function addEvents():void
		{
			YFEventCenter.Instance.addEventListener(GlobalEvent.ForgeUIClick,onForgeClick);
		}
		private function onForgeClick(e:YFEvent):void
		{
			_forgeWindow.toggle();
		}
		
	}
}