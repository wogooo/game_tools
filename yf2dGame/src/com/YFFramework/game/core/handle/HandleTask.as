package com.YFFramework.game.core.handle
{
	import com.YFFramework.core.center.abs.handle.AbsHandle;
	import com.YFFramework.game.core.module.task.model.CMDTask;
	
	public class HandleTask extends AbsHandle
	{
		public function HandleTask()
		{
			super();
			_maxCMD=999;
			_minCMD=900;
		}
		override public function socketHandle(data:Object):Boolean
		{
			switch(data.cmd)
			{
				case CMDTask.S_RequestTask:
					
					return true;
					break;
			}
		}
		
	}
}