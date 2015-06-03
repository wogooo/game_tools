package com.YFFramework.game.core.module.npc.model
{
	/** 窗口传递数据 vo
	 * @author yefeng
	 * 2013 2013-5-10 下午5:39:21 
	 */
	public class NPCTaskWindowVo
	{
		/**npc 动态id  也就是位置id 
		 */		
		public var npcDyId:int;
		/** npc静态id 
		 */		
		public var npcBasicId:int;
		
		/**  任务id 
		 */		
		public var taskId:int;
		/**循环任务id 没有循环任务则为-1
		 */		
		public var loopId:int;
		/**跑环任务id  没有则为-1
		 */		
		public var run_rings_id:int;

		
		
		/**该任务的状态  任务状态在TaskState
		 */		
		public var state:int;
		/**该任务的品质
		 */		
		public var quality:int;
		public function NPCTaskWindowVo()
		{
		}
	}
}