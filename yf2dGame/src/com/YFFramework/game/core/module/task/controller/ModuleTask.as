package com.YFFramework.game.core.module.task.controller
{
	import com.YFFramework.core.center.abs.module.AbsModule;
	import com.YFFramework.core.debug.print;
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.net.socket.YFSocket;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.core.module.task.model.CMDTask;
	import com.YFFramework.game.core.scence.TypeScence;
	
	public class ModuleTask extends AbsModule
	{
		public function ModuleTask()
		{
			super();
			_belongScence=TypeScence.ScenceGameOn;
		}
		override public function show():void
		{
			addEvents();
		}
		
		private function addEvents():void
		{
			YFEventCenter.Instance.addEventListener(GlobalEvent.GameIn,onSocketEvent);
		}
		
		private function onSocketEvent(e:YFEvent):void
		{
			switch(e.type)
			{
				case GlobalEvent.GameIn:
					///进入游戏
					print(this,"任务模块进入");
					YFSocket.Instance.sendMessage(CMDTask.S_RequestTask);
					break;
			}
		}
		

	}
}