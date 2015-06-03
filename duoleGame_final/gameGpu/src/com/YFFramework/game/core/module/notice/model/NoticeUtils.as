package com.YFFramework.game.core.module.notice.model
{
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.module.notice.manager.NoticeBasicManager;

	/**
	 * 找notice表里的常量
	 * @version 1.0.0
	 * creation time：2013-8-28 上午9:36:23
	 */
	public class NoticeUtils{
		
		public static function getMoneyTypeStr(moneyType:int):String{
			switch(moneyType){
				case TypeProps.MONEY_COUPON:
					return NoticeBasicManager.Instance.getNoticeBasicVo(NoticeType.Notice_id_100003).noticeContent;
				case TypeProps.MONEY_DIAMOND:
					return NoticeBasicManager.Instance.getNoticeBasicVo(NoticeType.Notice_id_100002).noticeContent;
				case TypeProps.MONEY_NOTE:
					return NoticeBasicManager.Instance.getNoticeBasicVo(NoticeType.Notice_id_100001).noticeContent;
				case TypeProps.MONEY_SILVER:
					return NoticeBasicManager.Instance.getNoticeBasicVo(NoticeType.Notice_id_100000).noticeContent;
				case TypeProps.MONEY_GUILD_CONTRIBUTION:
					return NoticeBasicManager.Instance.getNoticeBasicVo(NoticeType.Notice_id_100072).noticeContent;
			}
			return 'money type err:'+moneyType;
		}
		
		public static function getStr(noticeId:int):String{
			return NoticeBasicManager.Instance.getNoticeBasicVo(noticeId).noticeContent;
		}
		
		/**把文本转换成带颜色参数；例如道具、装备、宠物、坐骑、时装、翅膀； 
		 * @param txt		文本内容
		 * @param color		文本颜色
		 * @return 
		 */		
		public static function setColorText(txt:String,quality:int):String{
			return "{"+txt+"|#"+TypeProps.getQualityColor(quality)+"}";
		}
	}
} 