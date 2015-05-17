package com.YFFramework.game.core.module.task.model
{
	import com.YFFramework.core.text.HTMLUtil;

	/** 任务中的某一小步
	 */	
	public class TaskStepBasicVo
	{
		/**步骤模型，1.对话 ， 2.打怪 3.采集， 4.打怪收集 5.运镖任务 6.劫镖任务  7. 护送任务 
		 */
		public var stepType:int;
		/** 第几步骤
		 */		
		public var stepId:int;
		/**1.可接 2. 进行中，3 完成
		 */		
		public var state:int;
		/**npc 说的话
		 */		
		public var npcTalk:String;
		/**npc 回复的话
		 */		
		public var playTalk:String;
		
		// 引导层用

		/**数据 x
		 */		
		public var relativeX:int;
		/**数据 y
		 */		
		public var relativeY:int;
		/**相关联的id 
		 */		
		public var relativeId:int;
		
		
		/**引导信息    游戏右边的引导信息
		 */		
		public var guide0:String;  ///前往  、 去
		public var guide1:String;  ///夕阳镇   
		public var guide2:String;//// 找  //  击杀  
		public var guide3:String;///npc   或者  怪物
		public function TaskStepBasicVo()
		{
		}
		/**获取引导信息
		 */		
		public function get guideInfo():String
		{
			var str:String=guide0;
			str +=HTMLUtil.setFont(guide1,TaskUtil.Color_TaskDestination,true,true);
			str +=guide2;
			str +=HTMLUtil.setFont(guide3,TaskUtil.Color_TaskTarget,true,true);
			return str;
		}
		
		
	}
}