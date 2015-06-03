package com.YFFramework.game.core.module.task.model
{
	public class Task_targetBasicVo
	{

		public var task_tag_id:int;
		public var tag_id:int;
		/**任务数量 或者是任务对话id 
		 */		
		public var tag_num:int;
		public var tag_type:int;
		public var desc:String;
		
		/**搜索类型
		 */		
		public var seach_type:int;
		/**客户端的搜索目标
		 */		
		public var seach_id:int;

		public function Task_targetBasicVo()
		{
		}
	}
}