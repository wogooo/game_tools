package com.YFFramework.game.core.global.util
{
	import com.msg.enumdef.MoneyType;
	

	/**
	 * 货币类型库链接名 
	 * @author Administrator
	 * 
	 * com.dolo.ui.component.IconImage 的 linkage 属性
	 * 
	 * @see com.dolo.ui.component.IconImage
	 * 
	 * 
	 * 
	 */
	public class PriceType
	{
		/**
		 * 礼券 
		 */
		public static const GIFT_CERTIFICATE:String = "icon.GiftCertificate";
		/**
		 * 魔钻 
		 */
		public static const DIAMOND_CHARCOAL:String = "icon.DiamondCharcoal"
			
		/**
		 * 银币 
		 */
		public static const SILVE_IINGOT:String = "icon.SilveIingot";
		
		/**
		 * 银币（绑定） 
		 */
		public static const SILVE_IINGOT_BIND:String = "icon.SilveIingotBind";
		
		
		public static function getLinkageByMoneyType(type:int):String
		{
			var str:String;
			switch(type)
			{
				case MoneyType.MONEY_DIAMOND:
				{
					str = PriceType.DIAMOND_CHARCOAL;
					break;
				}
				case MoneyType.MONEY_COUPON:
				{
					str = PriceType.GIFT_CERTIFICATE;
					break;
				}
				case MoneyType.MONEY_SILVER:
				{
					str = PriceType.SILVE_IINGOT;
					break;
				}
				case MoneyType.MONEY_COUPON:
				{
					str = PriceType.SILVE_IINGOT_BIND;
					break;
				}
			}
			return str;
		}
	}
}