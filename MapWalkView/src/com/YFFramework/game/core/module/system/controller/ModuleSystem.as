package com.YFFramework.game.core.module.system.controller
{
	/**@author yefeng
	 * 2013 2013-4-11 下午5:39:55 
	 */
	import com.YFFramework.core.center.abs.module.AbsModule;
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.sound.SoundBgManager;
	import com.YFFramework.game.core.global.DataCenter;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.core.scence.ScenceGameOn;
	import com.YFFramework.game.core.scence.TypeScence;

	/** 游戏系统设定模块
	 */	
	public class ModuleSystem extends AbsModule
	{
		public function ModuleSystem()
		{
			super();
			_belongScence=TypeScence.ScenceGameOn;
		}
		override public function init():void
		{
			addEvents();
		}
		/**添加事件
		 */		
		private function addEvents():void
		{
			//切换场景
			YFEventCenter.Instance.addEventListener(GlobalEvent.MapChange,onGloableEvent);
		}
		private function onGloableEvent(e:YFEvent):void
		{
			switch(e.type)
			{
				case GlobalEvent.MapChange:
					//切换场景  初始化场景音乐
					SoundBgManager.Instance.initData(DataCenter.Instance.mapSceneBasicVo.soundArr);
					SoundBgManager.Instance.play();
					break;
			}
		}
	}
}