package com.YFFramework.game.core.module.task.model
{
	import com.msg.enumdef.TaskType;
	import com.msg.task.LoopTaskInf;

	public class TaskDyVo
	{
		
		/**可接列表
		 */
		public static const AbleList:int=1;
		
		/**当前列表
		 */
		public static const CurrentList:int=2;
		/**任务模板ID
		 */		
		public var taskID:int;
		/**任务目标数组
		 */		
		public var tagList:Vector.<TaskTagDyVo>;
		/**任务是否已完成
		 */		
		public var isFinish:Boolean = false;
//		//need remove
//		public var loopInf:LoopTaskInf;
		
		////  循环任务列表
		
		/**任务链id 
		 */		
		public var loopId:int=-1;
		/**任务链当前进度 
		 */		
		public var curProgress:int;
		/**任务链剩余次数
		 */		
		public var remainTimes:int;
		
		
		
		/**跑环任务 id 
		 */
		public var run_rings_id:int;
		/** 循环还可接次数(默认1) 剩余次数
		 */		
		public var run_remain:int;
		/**环任务当前第几环
		 */		
		public var run_Progress:int;


		private var _isSubmit:Boolean;
		
		/**可接列表 还是当前列表
		 */
		public var taskListType:int;
		
		/**值为 AbleList CurrentList   表示是在可接任务列表 还是当前任务列表
		 */		
		public function TaskDyVo(){
			tagList=new Vector.<TaskTagDyVo>();
			_isSubmit=false
		}
		
		
		
		/**是否处于提交状态   为 true 则表示 协议已经发送但是没有返回
		 */
		public function get isSubmit():Boolean
		{
			return _isSubmit;
		}

		/**
		 * @private
		 */
		public function set isSubmit(value:Boolean):void
		{
			_isSubmit = value;
		}

	}
}