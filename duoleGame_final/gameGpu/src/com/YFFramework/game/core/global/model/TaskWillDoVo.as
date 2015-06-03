package com.YFFramework.game.core.global.model
{
	/**任务 将要做的东西
	 * @author yefeng
	 * 2013 2013-5-27 下午1:22:41 
	 */
	public class TaskWillDoVo
	{
		/**npc动态id  该npcid  可能代表 npc  也可能代表 坐标点
		 */		
		public var npcDyId:int;
		/**目标静态id    为  -1 则表示没有 目标id     要进行操作的目标id 
		 */		
		public var seach_id:int = -1;
		/** 该属性 来自任务目标表 Task_targetBasicVo   操作类型//   类型    为  -1 则表示没有类型,  就是  tag_id 是一种什么类型 是装备 还是道具 还是  怪物   还是怪物区域 等等      其值在  TypeProps.TaskTargetType_
		 */		
		public var seach_type:int = -1;

		public function TaskWillDoVo()
		{
		}
		
		
	}
}