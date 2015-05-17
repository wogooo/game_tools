package com.YFFramework.game.core.module.task.model
{
	/**@author yefeng
	 *2012-11-28下午10:50:21
	 */
	public class TaskUtil
	{
		
		/**可以接受的任务
		 */		
		public static const State_CanAccept:int=1;
		/**正在进行的任务，就是正在做的任务 还没有完成
		 */		
		public static const State_Tasking:int=2;
		/**已经完成的任务  待  提交
		 */		
		public static const State_Finished:int=3;
		
		////任务  字体颜色的设置
		/**  任务目的地   
		 */		
		public static const Color_TaskDestination:String="#00FFFF";
		/**任务目标
		 */		
		public static const Color_TaskTarget:String="00FF00";
		public function TaskUtil()
		{
		}
	}
}