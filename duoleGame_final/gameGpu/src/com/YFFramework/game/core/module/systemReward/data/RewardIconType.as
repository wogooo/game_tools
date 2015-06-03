package com.YFFramework.game.core.module.systemReward.data
{
	import com.YFFramework.game.core.module.task.enum.RewardTypes;

	/***
	 *钱类型的道具的图标
	 *@author ludingchang 时间：2013-9-5 下午4:18:33
	 */
	public class RewardIconType
	{
		/**硬币的图标*/
		public static const SILVER_ICON:int=900001;
		/**银锭的图标*/
		public static const NOTE_ICON:int=900002;
		/**经验图标*/
		public static const EXP_ICON:int=900003;
		/**礼券图标*/
		public static const COUPON_ICON:int=900004;
		/**魔钻图标*/
		public static const DIAMOND_ICON:int=900005;
		/**阅历图标*/
		public static const SEE_ICON:int=900006;
		/**贡献图标*/
		public static const CONTRIBUTION_ICON:int=900007;
		/**称号图标*/
		public static const TITLE_ICON:int=900008;
		
		
		/**
		 *根据<code>ReWardTypes</code>中定义的物品类型得到对应的物品的图标ID，道具和 装备有自己独立的图标ID，
		 * @param type 奖励类型
		 * @return 该类型奖励的图标ID，错误返回-1
		 * 
		 */		
		public static function getIconByReWardType(type:int):int
		{
			switch(type)
			{
				case RewardTypes.EXP: return EXP_ICON;
				case RewardTypes.COUPON: return COUPON_ICON;
				case RewardTypes.SILVER: return SILVER_ICON;
				case RewardTypes.NOTE: return NOTE_ICON;
				case RewardTypes.DIAMOND: return DIAMOND_ICON;
				case RewardTypes.SEE: return SEE_ICON;
				case RewardTypes.CONTRIBUTION: return CONTRIBUTION_ICON;
				case RewardTypes.TITLE: return TITLE_ICON;
			}
			return -1;
		}
	}
}