package com.YFFramework.game.core.module.story.model
{
	/***
	 *
	 *@author ludingchang 时间：2013-8-1 下午4:09:01
	 */
	public class TypeStory
	{
		/**旁白*/
		public static const StoryTypeText:int=1;
		/**动画 ,,包括文字对话动画*/
		public static const StoryTypeMovie:int=2;
		/**有头像自动弹出再自动消失的剧情*/
		public static const StoryTypeCloud:int=3;
		
		/**玩家自己
		 */
		public static const PlayType_Hero:int=0;
		/**NPC
		 */
		public static const PlayType_NPC:int=1;
		/** 怪物
		 */
		public static const PlayType_Monster:int=2;
		
		
		
		// 剧情 显示的地方
		/**  剧情在任务地方显示
		 * 以任务对话的形式显示
		 */
		public static const StoryPositionType_TaskDialog:int=1;
		
		/**剧情 在 副本开始时候显示
		 */		
		public static const StoryPositionType_RaidStart:int=2;

		/**剧情在副本结束的时候显示
		 */
		public static const StoryPositionType_RaidEnd:int=3;

		
		/**接受任务触发
		 */
		public static const StoryPositionType_AccecptTask:int=4;
		
		/**完成任务触发 
		 */
		public static const StoryPositionType_FinishTask:int=5;
		/**达到目标条件触发
		 */
		public static const StoryPositionType_ReachTask:int=6;



	}
}