package com.YFFramework.game.core.module.growTask.source
{
	/**
	 * @version 1.0.0
	 * creation time：2013-7-16 上午10:19:58
	 */
	public class GrowTaskSource{
		
		public static const GROW_TASK_UNFINISH:int = 1;	//未完成成长任务
		public static const GROW_TASK_FINISHED:int = 2; //已完成成长任务
		public static const GROW_TASK_REWARDED:int = 3; //已领取成长任务
		
		/** 人物升级 */
		public static const GROW_TASK_TYPE_PLAYER_LV:int = 1;	
		/** 拥有宠物 */
		public static const GROW_TASK_TYPE_HAS_PET:int = 2;		
		/** 身上装备*/
		public static const GROW_TASK_TYPE_HERO_EQUIP:int = 3; 	
		/** 身上翅膀 */
		public static const GROW_TASK_TYPE_HERO_WING:int=4;		
		/** 好友数量 */
		public static const GROW_TASK_TYPE_FRIEND_NUM:int=5;	
		/** 拥有坐骑 */
		public static const GROW_TASK_TYPE_MOUNT:int=6;		
		/** 7身上宝石 */
		public static const GROW_TASK_TYPE_HERO_GEM:int=7;		
		/** 8角色的技能 */
		public static const GROW_TASK_TYPE_HERO_SKILL:int=8;		
		/** 9(例如勇者大乱斗)竞技活动 */
		public static const GROW_TASK_TYPE_ACTIVITY_ARENA:int=9;		
		/** 10加入公会（称号）*/
		public static const GROW_TASK_TYPE_GUILD:int=10;		
		/** 11金钱（称号） */
		public static const GROW_TASK_TYPE_GAME_MONEY:int=11;		
		/** 12角色的属性（称号） */
		public static const GROW_TASK_TYPE_HERO_ATTR:int=12;		
		/** 13魔族入侵活动（称号） */
		public static const GROW_TASK_TYPE_ACTIVITY_DEMON:int=13;		
		
		public function GrowTaskSource(){
		}
	}
} 