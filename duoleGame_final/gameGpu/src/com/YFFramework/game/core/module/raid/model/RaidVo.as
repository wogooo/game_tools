package com.YFFramework.game.core.module.raid.model
{
	/**副本的数据模型
	 * @version 1.0.0
	 * creation time：2013-5-27 下午5:44:11
	 */
	public class RaidVo{
		
		public var raidId:int;
		public var groupId:int;
		public var raidType:int;
		public var raidName:String;
		public var minLv:int;
		public var maxLv:int;
		public var timeId:int;
		public var energy:int;
		public var raidLimit:int;
		public var createTerm:String;
		public var nextRaidId:int;
		public var raidDesc:String;
		public var moneyStar:int;
		public var expStar:int;
		public var propsStar:int;
		public var activityId:int;
		public var rewardId:int;
		public var rewardShowId:int;
		public var duration:int;
		/**胜利条件*/
		public var win:String;
		/**进入场景的id 
		 */
		public var enter_map_id:int;
		
		/**离开副本后进入的场景id 
		 */
		public var exit_map_id:int;
		public var floor:int;
		public var totalFloor:int;
		public var deadTimes:int;
		
		public var raidNum:int;//已完成的副本次数；动态数据
		public var isCreated:Boolean;//副本是否已经被创建
		public var deadNum:int;//以死亡次数
		
		
		//剧情副本 只针对 单人 副本
		/**副本开始剧情 id  
		 */
		public var story_start_id:int;
		
		/**副本结束剧情id 
		 */
		public var story_end_id:int;

		
		
		
		public function RaidVo(){
		}
	}
}