package com.YFFramework.game.core.module.task.model
{

	public class TaskStateVO{
		
		public var state:int;
		public var vo:TaskBasicVo;
		/**任务目标数组
		 */		
		public var tagList:Vector.<TaskTagDyVo>;
		public function TaskStateVO(){
		}
	}
}