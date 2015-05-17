package com.YFFramework.game.core.module.task.manager
{
	import flash.utils.Dictionary;

	/** 任务列表 具有 可接  已经 完成(等待提交) 和  正在进行的任务
	 * @author yefeng
	 *2012-11-28下午10:52:53
	 */
	public class TaskDyManager
	{
		
		/**已经完成的任务列表
		 */		
		public var _finishedDict:Dictionary;
		/**可以接受的任务列表
		 */		
		public var _canAcceptDict:Dictionary;
		/**正在进行的任务
		 */		
		public var _taskingDict:Dictionary;
		private static  var _instance:TaskDyManager;
		public function TaskDyManager()
		{
			_finishedDict=new Dictionary();
			_canAcceptDict=new Dictionary();
			_taskingDict=new Dictionary();
		}
		
		public static  function get Instance():TaskDyManager
		{
			if(_instance==null) _instance=new TaskDyManager();
			return _instance;
		}
		
		
		
	}
}