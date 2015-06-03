package com.YFFramework.game.core.module.giftYellow.manager
{
	import com.YFFramework.game.core.global.DataCenter;
	import com.YFFramework.game.core.module.mapScence.world.model.type.TypeRole;
	import com.YFFramework.game.gameConfig.URLTool;

	/***
	 *黄钻相关API管理类
	 *@author ludingchang 时间：2013-12-6 下午3:34:14
	 */
	public class YellowAPIManager
	{
		/**充值黄钻的URL*/
		private static const OPEN_URL:String="http://pay.qq.com/qzone/index.shtml?aid=game";
		/**充值普通黄钻的参数*/
		private static const OPEN_API_PARAM:String=".op";
		/**充值年费黄钻的参数*/
		private static const OPEN_YEAR_API_PARAM:String=".yop&paytime=year";
		private static var _inst:YellowAPIManager;
		public static function get Instence():YellowAPIManager
		{
			return _inst||=new YellowAPIManager;
		}
		public function YellowAPIManager()
		{
		}
		
		
		/**用户的唯一ID*/
		public var openid:String="001";
		/**用户的密钥*/
		public var openkey:String="test_openkey";
		/**平台*/
		public var pf:String="pengyou";
		/**腾讯API用的pfkey*/
		public var pfkey:String="test_pfkey";
		
		
		/**黄钻等级*/
		public function get yellow_vip_lv():int
		{
			return DataCenter.Instance.roleSelfVo.roleDyVo.vipLevel;
		}
		/**年费黄钻*/
		public function get is_year_yellow():Boolean
		{
			return (DataCenter.Instance.roleSelfVo.roleDyVo.vipType==TypeRole.VIP_TYPE_YEAR);
		}
		
		
		/**腾讯分配的app id*/
		public const appid:String="1101119139";
		/**腾讯分配的app key*/
		public const appkey:String="EYiZceim6um32WNc";
		/**魔钻的图标url*/
		public var goods_url:String=URLTool.getCommonAssets("diamond.png");
		/**魔钻的ID*/
		public var goods_id:String="diamond";
		
		/**是否领取过新手礼包*/
		public var has_get_new_gift:Boolean;
		/**是否领取过每日礼包*/
		public var has_get_day_gift:Boolean;
		/**是否领取过年费的额外每日礼包*/
		public var has_get_year_day_gift:Boolean;
		
		/**是否有礼包*/
		public function hasGift():Boolean
		{
			if(yellow_vip_lv>0&&(!has_get_day_gift||!has_get_new_gift))
				return true;
			if(is_year_yellow&&!has_get_year_day_gift)
				return true;
			return false;
		}
		
		/**充值黄钻url*/
		public function getOpenApiUrl():String
		{
			return OPEN_URL+appid+OPEN_API_PARAM;
		}
		/**充值年费黄钻url*/
		public function getYearOpenApiUrl():String
		{
			return OPEN_URL+appid+OPEN_YEAR_API_PARAM;
		}
	}
}