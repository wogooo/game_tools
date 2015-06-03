package com.YFFramework.game.core.module.AnswerActivity.dataCenter
{
	/**枚举字段统一填写在  TypeActivity里
	 */
	public class ActivityBasicVo
	{
		/** 活动id */		
		public var active_id:int;
		
		/** 活动类型：一个活动会有多个id，但一个类型 */		
		public var active_type:int;
		
		/** 活动名称 */
		public var active_name:String;
		
		/** 活动图标  */		
		public var icon_id:int;
		
		/** 图标显示等级（人物等级必须大于等于这个等级） */		
		public var icon_level:int;
		
		/**场景类型：0->无；1->安全地图；2->野外地图;3 副本地图;4 竞技场地图
		 */
		public var scene_type:int;
		
		/** 场景id ,与 scene_type对应 (如：如果是竞技场地图，这个值等于竞技场表里的arena_id)*/		
		public var scene_id:int;
		
		/** 活动等级下限 */		
		public var min_level:int;
		
		/** 活动等级上限 */		
		public var max_level:int;
		
		/** 世界等级 */		
		public var world_level:int;
		
		/** 参与方式：1->系统；2->NPC（没有0的情况,通过什么方式进入活动）*/		
		public var part_type:int;
		
		/** 用户身份条件：0->不限；1->公会 */		
		public var identity:int;
		
		/** vip条件 */		
		public var vip_cond:int;
		
		/** 公会条件索引 */		
		public var guild_cond_id:int;
		
		/** 消耗道具模板id */		
		public var item_id:int;
		
		/** 消耗道具数量 */		
		public var item_number:int;
		
		/** NPC id */		
		public var npc_id:int;
		
		/** NPC对话id */		
		public var dialog_id:int;
		
		/** 公告文本id */		
		public var notice_id:int;
		
		/** 开始播放公告时间（秒） */		
		public var start_notice_time:int;
		
		/** 公告播放间隔（秒） */		
		public var notice_interval:int;
		
		/** 参与次数限制  */		
		public var limit_times:int;
		
		/** 限制周期（仅需服务端判断，告诉客户端已经参与了几次） */		
		public var limit_type:int;
		
		/** 是否周期活动：1->是；0->不是 */	
		public var is_cycle:int;
		
		/** 周期天数 */		
		public var cycle_days:int;
		
		/** 开启日期（年月日：20130807） */		
		public var open_date:String;
		
		/** 日开启次数 */		
		public var open_times:int;
		
		/** 是否规律开启：1->是；0->不是 */		
		public var is_regular:int;
		
		/** 日开启间隔(从一次活动的开始到下一次活动开始算起) */		
		public var open_interval:int;
		
		/** 提前报名时间(秒):开始时间-提前报名时间（差值）=提前报名开始时间*/		
		public var sign_time:int;
		
		/** 报名持续时间 (秒)：从开始报名经过的时间，不能超过整个活动的持续时间*/		
		public var sign_continue_time:Number;
		
		/** 准备时间（秒）(没用的字段) */		
		public var ready_time:int;
		
		/** 活动持续时间（秒） */		
		public var continue_time:int;
		
		/** 开始时间1（规律开启的话，只用判断这一个时间） */		
		public var start_time1:String;
		
		/** 开始时间2（不规律开启要判断） */		
		public var start_time2:String;
		
		/** 开始时间3（不规律开启要判断） */
		public var start_time3:String;
		
		/** 开始时间4（不规律开启要判断） */
		public var start_time4:String;
		
		/** 开始时间5（不规律开启要判断） */
		public var start_time5:String;
		
		/** 额外参与次数 */		
		public var extra_times:int;
		
		/** 额外vip条件 */		
		public var extra_vip_cond:int;
		
		/** 额外消耗道具id */
		public var extra_item_id:int;
		
		/** 额外消耗道具数量 */
		public var extra_item_number:int;
		
		/** 额外的金钱类型 */
		public var extra_money_type:int;
		
		/** 额外的金钱数量 */
		public var extra_money:int;
		
		/** 奖励id */
		public var reward_id:int;
		/** 时间描述*/		
		public var time_desc:String;
		/**活动描述 
		 */		
		public var activity_desc:String;	
		/**金钱星数 
		 */
		public var money_star:int;
		/**经验星数 
		 */
		public var exp_star:int;
		/**道具星数 
		 */
		public var props_star:int;
		public function ActivityBasicVo()
		{
		}
	}
}