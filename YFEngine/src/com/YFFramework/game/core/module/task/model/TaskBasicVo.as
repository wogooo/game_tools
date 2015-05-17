package com.YFFramework.game.core.module.task.model
{
	/**任务列表
	 * 2012-11-20 下午6:01:29
	 *@author yefeng
	 */
	public class TaskBasicVo
	{
		/** 任务id 
		 */
		public var taskId:int;  
		/**任务名称
		 */
		public var taskName:String;
		/**类型 任务类型  主线还是支线  1  主线 2 支线  3 循环
		 */
		public var type:int;
	
		/**前置任务id 
		 */
		public var preTaskId:int;
		/** 总步数 
		 */		
		public var totalStep:int;
		/**接受该任务需要的最小等级
		 */
		public var minLevel:int;
		/**接受该任务需要的最大等级
		 */
		public var maxLevel:int;
		/**任务完成后的奖励经验
		 */
		public var exp:int;
		/**任务完成后的奖励金币
		 */
		public var gold:int;
		
		/** 奖励的物品列表  内部存放的是 物品静态id 
		 */
		public var goodsIdArr:Array;
		
		/**任务步数
		 */		
		public var stepArr:Vector.<TaskStepBasicVo>;
		
		public function TaskBasicVo()
		{
		}
		
	}
}