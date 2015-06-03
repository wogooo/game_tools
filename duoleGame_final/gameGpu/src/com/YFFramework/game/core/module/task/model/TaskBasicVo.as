package com.YFFramework.game.core.module.task.model
{
	public class TaskBasicVo
	{
		
		/** 勿删  循环任务id     非配置表字段  
		 */		
		public var loopID:int = -1;
		/**跑环任务 id
		 */		
		public var run_rings_id:int = -1;

		
		
		
		
		/** 主线 还是支线   还是循环  值在 TypeTask
		 */		
		public var task_type:int;
		
		public var pre_task:int;
		public var task_reward_id:int;
		public var reward_script:int;
		public var complete_dialog:String;
		public var accept_dialog:String;
		public var recv_npc_id:int;
		public var highest_lv:int;
		public var submit_desc:String;
		public var lowest_lv:int;
		public var sub_npc_id:int;
		public var accept_desc:String;
		public var task_id:int;
		public var recv_need_script:int;
		public var undone_dialog:String;
		/**任务目标id
		 */		
		public var task_tag_id:int;
		public var sub_need_script:int;
		public var quality:int;
		public var can_give_up:int;
		
		/**任务名称   在右边新手引导显示
		 */		
		public var name:String;
		
		/**任务 具体描述  和  任务名称类似  是任务名称的具体描述
		 */
		public var description:String;
		/**经验，金钱，道具星数 
		 */		
		public var moneyStar:int;
		public var expStar:int;
		public var propsStar:int;

		/**Task_targetBasicVo 
		 */		
		public var targetArr:Array;
		
		/**接受任务后播放的剧情
		 */
		public var rev_story_id:int;
		
		/**完成任务后播放的剧情
		 */
		public var sub_story_id:int;

		
		/**达到目标条件 时候触发的剧情
		 */
		public var reach_story_id:int;
		
		
		public function TaskBasicVo(){
			targetArr=new Array();
		}
	}
}