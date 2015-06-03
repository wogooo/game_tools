package com.YFFramework.game.core.module.system.data
{
	/***
	 *系统设置管理类
	 *@author ludingchang 时间：2013-7-10 下午1:37:53
	 */
	public class SystemConfigManager
	{	
		/** 1屏蔽特效
		 */		
		public static var shieldEff:Boolean;
		/** 是否屏蔽  false 表示不屏蔽 也就是 显示    true 表示不显示
		 */		
		public static var shieldHp:Boolean;
		/** 3隐藏其他玩家
		 */		
		public static var shieldOtherHero:Boolean;
		/** 4隐藏其他玩家宠物
		 */		
		public static var shieldOtherPet:Boolean;
		/** 5不选中宠物
		 */		
		public static var notSelectPet:Boolean;
		/** 6显示装备比较
		 */		
		public static var showCompare:Boolean;
		/** 7显示玩家称号
		 */		
		public static var showTitle:Boolean;
		/** 8拒绝切磋
		 */		
		public static var rejectPK:Boolean;
		/**9拒绝交易*/
		public static var rejectTrade:Boolean;
		/**10拒绝组队*/
		public static var rejectTeam:Boolean;
		/**11拒绝好友邀请*/
		public static var rejectFriend:Boolean;
		/**12拒绝所有私聊*/
		public static var rejectTalk:Boolean;
		/**13拒绝公会*/
		public static var rejectGuild:Boolean;
		/** 14显示又有掉落物品名称
		 */
		public static var showAllItemName:Boolean;
		/**是否开启背景音乐*/
		public static var enableBGM:Boolean;
		/**背景音乐大小*/
		public static var BGMValue:int;
		/**是否开启音效*/
		public static var enableSound:Boolean;
		/**音效大小*/
		public static var soundValue:int; 
		
		public function SystemConfigManager()
		{	
		}

	}
}