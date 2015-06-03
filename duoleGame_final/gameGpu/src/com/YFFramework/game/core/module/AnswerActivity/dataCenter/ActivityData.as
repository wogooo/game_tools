package com.YFFramework.game.core.module.AnswerActivity.dataCenter
{
	/**
	 * @author jina;
	 * @version 1.0.0
	 * creation time：2013-8-10 下午12:53:26
	 */
	public class ActivityData
	{

		/*************************以下是活动的type*****************************/
		/** 智者千虑 */
		public static const ACTIVITY_ANSWER:int=1;
		/** 魔族入侵 */
		public static const ACTIVITY_DEMON:int=3;
		/** 勇者大乱斗 */		
		public static const ACTIVITY_BRAVE:int=4;
		
		/*************************活动表里用到的枚举*****************************/
		/** 1天的毫秒数 */		
		public static const ONE_DAY_MILLISECONDS:int=86400000;
		/** 1秒的毫秒数 */		
		public static const MILLISECOND:int=1000;
		/** 1分钟的毫秒数 */		
		public static const ONE_MINUTE:int=60000;
		
		/** 0 */		
		public static const NO:int=0;
		/** 1 */
		public static const YES:int=1;
		
		/** 0 */
		public static const PART_NO_LIMITED:int=0;
		/** 1 */
		public static const PART_GUILD:int=1;
		
		/** 0 */
		public static const START:int=0;
		/** 1 */
		public static const CLOSE:int=1;

		/******************************答题活动专用*******************************/
		public static var rightAnswer:int=0;
		/** 开始活动时的毫秒数  **/		
		public static var answerStartTime:Number;
		
		public function ActivityData()
		{
		}

		
		
	}
} 