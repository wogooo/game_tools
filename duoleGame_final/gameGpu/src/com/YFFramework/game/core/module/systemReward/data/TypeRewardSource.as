package com.YFFramework.game.core.module.systemReward.data
{
	/***
	 *系统礼包来源类型
	 *@author ludingchang 时间：2013-9-5 下午3:00:43
	 */
	public class TypeRewardSource
	{
		/**答题（智者千虑）*/
		public static const Question:int=0;
		/**任务*/
		public static const Task:int=1;
		/**补偿发放*/
		public static const Compensation:int=2;
		//////////////////////////////////////////////////////////下面的还没用到
		/**副本*/
		public static const Copy:int=3;
		/**活动*/
		public static const Activity:int=4;
		
		/**
		 *去奖励类型的中文名字 
		 * @param type 奖励类型
		 * @return 
		 * 
		 */		
		public static function getRewardTypeName(type:int):String
		{
			switch(type)
			{
				case Activity: return "活动奖励";
				case Task: return "任务奖励";
				case Question: return "答题奖励";
				case Copy: return "副本奖励";
			}
			return "";
		}
		
		
		public function TypeRewardSource()
		{
		}
	}
}