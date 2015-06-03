package com.YFFramework.game.core.global.model
{
	/**处理npc 和任务 间的数据传递@author yefeng
	 * 2013 2013-5-11 下午2:49:47 
	 */
	public class TaskNPCHandleVo
	{
		/**npc 动态id
		 */
		public var npcDyId:int;
		public var taskId:int;
		/**循环任务id 有的话就>0
		 */		
		public var loopId:int;
		
		/**跑环任务 id  有的话就>0
		 */
		public var run_rings_id:int;
		public function TaskNPCHandleVo()
		{
		}
	}
}