package com.YFFramework.game.core.module.mount.controller
{
	import com.YFFramework.core.center.abs.module.AbsModule;
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.core.global.manager.MountDyManager;
	import com.YFFramework.game.core.module.mount.events.MountEvent;
	import com.YFFramework.game.core.module.mount.model.MountListVo;
	import com.YFFramework.game.core.scence.TypeScence;
	
	/**2012-10-26 下午2:48:29
	 *@author yefeng
	 */
	public class ModuleMount extends AbsModule
	{
		public function ModuleMount()
		{
			_belongScence=TypeScence.ScenceGameOn;
		}
		override public function init():void
		{
			addEvents();
		}

		private function addEvents():void
		{
			
			YFEventCenter.Instance.addEventListener(GlobalEvent.GameIn,requestMount);

			YFEventCenter.Instance.addEventListener(MountEvent.S_RequestMountList,onSocketEvent);
		}
		
		private function requestMount(e:YFEvent):void
		{
		//	YFSocket.Instance.sendMessage(CMDMount.C_RequestMountList);
		}
		
		private function onSocketEvent(e:YFEvent):void
		{
			switch(e.type)
			{
				case MountEvent.S_RequestMountList:
					var mountListVo:MountListVo=e.param as MountListVo;
					MountDyManager.Instance.cacheData(mountListVo.mountArr);
					break;
			}
		}
			
	}
}