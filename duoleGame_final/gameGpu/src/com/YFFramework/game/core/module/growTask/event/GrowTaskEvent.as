package com.YFFramework.game.core.module.growTask.event
{
	/**
	 * @version 1.0.0
	 * creation time：2013-7-16 下午1:28:20
	 */
	public class GrowTaskEvent{
		
		private static const Path:String="com.YFFramework.game.core.module.growTask.event.";
		
		public static const GrowTaskRewardReq:String=Path+"GrowTaskRewardReq";
		/** 拥有某等级某品质的宠物 */
		public static const PetChange:String=Path+"OwnPet";
		/** 装备各种数量的强化、品质升级 */
		public static const HasHeroEquip:String=Path+"HasHeroEqup";
		/** 现在坐骑改成进阶，所有每次坐骑进阶都要监听 */
		public static const MountChange:String=Path+"HasMount";
		/** 角色技能等级升级 */
		public static const heroSkill:String=Path+"heroSkillAttrs";
		/** 暂时为大乱斗积分 */
		public static const activity_arena:String=Path+"activity_arena"; 
		/** 加入公会 */
		public static const attend_guild:String=Path+"attend_guild";
		/** 游戏币：银锭、礼券 */
//		public static const game_money:String=Path+"game_money";
		/** 人物属性 */
		public static const hero_attr:String=Path+"hero_attr";
		/** 专指魔族入侵活动 */
//		public static const activity_demon:String=Path+"activity_demon";
		
//		public static const 
		public function GrowTaskEvent(){
		}
	}
} 