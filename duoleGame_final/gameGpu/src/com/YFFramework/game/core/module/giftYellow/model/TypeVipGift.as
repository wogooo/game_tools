package com.YFFramework.game.core.module.giftYellow.model
{
	import com.msg.vip_gift_pack.GiftPackType;

	/***
	 *黄钻礼包类型定义
	 *@author ludingchang 时间：2013-12-9 下午1:39:57
	 */
	public class TypeVipGift
	{
		/**新手礼包*/
		public static const NEW_PLAYER_GIFT:int=GiftPackType.NOVICE_PACK;
		/**每日礼包*/
		public static const DAY_GIFT:int=GiftPackType.EVERYDAY_PACK;
		/**年费黄钻额外的每日礼包*/
		public static const YEAR_DAY_GIFT:int=GiftPackType.NOBLE_PACK;
	
		public static function getVIPGiftName(type:int):String
		{
			switch(type)
			{
				case NEW_PLAYER_GIFT: return "新手礼包";
				case DAY_GIFT: return "每日礼包";
				case YEAR_DAY_GIFT: return "年费黄钻每日礼包";
			}
			return "礼包类型错误："+type;
		}
		
	}
}