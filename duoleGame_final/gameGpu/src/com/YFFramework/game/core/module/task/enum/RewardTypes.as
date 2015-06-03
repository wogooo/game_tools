package com.YFFramework.game.core.module.task.enum
{
	import com.YFFramework.game.core.module.notice.model.NoticeType;
	import com.YFFramework.game.core.module.notice.model.NoticeUtils;
	import com.dolo.lang.LangBasic;

	/**  任务 奖励类型
	 */	
	public class RewardTypes
	{
		/**装备
		 */		
		public static const EQUIP:int = 1;
		/**道具
		 */		
		public static const PROPS:int = 2;
		/**经验
		 */		
		public static const EXP:int = 3;
		/**礼券
		 */		
		public static const COUPON:int = 4;
		/**银币
		 **/	
		public static const SILVER:int = 5;
		/**银锭
		 */		
		public static const NOTE:int = 6;
		/**魔钻*/
		public static const DIAMOND:int = 7;
		/**阅历*/
		public static const SEE:int = 8;
		/**贡献*/
		public static const CONTRIBUTION:int = 9;
		/**称号*/
		public static const TITLE:int = 10;
		
		
		
		public static function getTypeStr(type:int):String
		{
			var str:String="";
			switch(type)
			{
				case EQUIP:
					str=NoticeUtils.getStr(NoticeType.Notice_id_100065);
					break;
				case PROPS:
					str=NoticeUtils.getStr(NoticeType.Notice_id_100066);
					break;
				case EXP:
					str=NoticeUtils.getStr(NoticeType.Notice_id_100061);
					break;
				case COUPON:
					str=NoticeUtils.getStr(NoticeType.Notice_id_100003);
					break;
				case SILVER:
					str=NoticeUtils.getStr(NoticeType.Notice_id_100000);
					break;
				case NOTE:
					str=NoticeUtils.getStr(NoticeType.Notice_id_100001);
					break;
				case DIAMOND:
					str=NoticeUtils.getStr(NoticeType.Notice_id_100002);
					break;
				case SEE:
					str=NoticeUtils.getStr(NoticeType.Notice_id_100067);
					break;
				case CONTRIBUTION:
					str=LangBasic.contribution;
					break;
				case TITLE:
					str=LangBasic.title;
					break;
			}
			return str;
		}
	}
}