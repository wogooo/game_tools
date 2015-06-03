package com.YFFramework.game.core.module.task.model
{
	/**任务目标DyVo
	 */	
	public class TaskTagDyVo{
		
		/**任务目标类型（装备||道具||怪物||对话） 
		 */
		public var tagType:int;
		/**任务目标ID（装备ID||道具ID||怪物ID||NPCID）
		 */		
		public var tagID:int;
		/**任务目标总数量 （装备数量||道具数量||怪物数量||对话为文本ID）
		 */		
		public var totalNum:int;
		/**任务目标当前数量 （装备数量||道具数量||怪物数量||对话完成为1） 
		 */		
		public var curNum:int;
		
		public function TaskTagDyVo(){	
		}

		public function get isFinish():Boolean{
			if(curNum >= totalNum) return true;
			return false;
		}
	}
}