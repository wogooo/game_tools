package com.YFFramework.game.core.module.story.event
{
	/***
	 *
	 *@author ludingchang 时间：2013-8-1 下午4:03:34
	 */
	public class StoryEvent
	{
		private static const Path:String="com.YFFramework.game.core.module.story.event.";
		/**显示剧情*/
		public static const Show:String=Path+"Show";
		
		
		
		/**  进入副本的开始剧情结束
		 */
		public static const RaidStoryStartComplete:String=Path+"RaidStoryStartComplete";
		
		/**  副本打完的结束剧情结束
		 */
		public static const RaidStoryEndComplete:String=Path+"RaidStoryEndComplete";

		
		/**接受任务后触发的剧情
		 */
		public static const AcceptTaskStory:String=Path+"AcceptTaskStory";
		/**完成任务后触发的剧情
		 */		
		public static const FinishTaskStory:String=Path+"FinishTaskStory";
		/** 达到任务目标条件但是 没有提交时 触发
		 */
		public static const ReachTaskStory:String=Path+"ReachTaskStory";


	}
}