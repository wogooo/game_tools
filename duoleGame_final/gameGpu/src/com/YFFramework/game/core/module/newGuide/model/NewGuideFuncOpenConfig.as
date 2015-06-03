package com.YFFramework.game.core.module.newGuide.model
{
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.game.core.global.DataCenter;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.core.module.newGuide.manager.NewGuideManager;

	/**新手引导功能开启  按钮配置
	 * @author yefeng
	 * 2013 2013-12-10 下午4:19:45 
	 */
	public class NewGuideFuncOpenConfig
	{
		/**背包开启
		 */
		public static const BagOpen:int=1;
		
		/**宠物开启
		 */		
		public static const PetOpen:int=2;
		

		/**技能开启
		 */
		public static const SkillOpen:int=3;
		
		/**好友开启
		 */
		public static const FriendOpen:int=4;

		
		/**翅膀开启
		 */
		public static const WingOpen:int=5;
		
		/**坐骑开启
		 */
		public static const MountOpen:int=6;


		/**锻造开启
		 */
		public static const ForageOpen:int=7;
		
		/**商城开启
		 */
		public static const MallOpen:int=8;

		/**组队开启
		 */
		public static const TeamOpen:int=9;
		
		/**市场开启
		 */
		public static const MarkcketOpen:int=10;
		
		/**工会开启
		 */
		public static const GuildOpen:int=11;
		
		
		private static const Len:int=11;
		private static var _arr:Array=[];
		

		/**值 
		 */
		private static var guideValue:int;

		public function NewGuideFuncOpenConfig()
		{
		}
		
		/** value代表开启的顺序   1  代表 只开启一个 2 代表开启 2 个   3 代表开启3个  4  代表开启4个
		 * 
		 * 开启顺序   背包  宠物  技能    好友  翅膀 坐骑  锻造  商城  组队 市场 工会
		 */
		public static function initConfig(value:int):void
		{
			guideValue=value;
			for(var i:int=0;i<value;++i)
			{
				_arr[i]=1;
			}
			for(i=value;i<Len;++i)
			{
				_arr[i]=0;
			}
		}
		/**开启所有
		 */
		public static function initAllOpen():void
		{
			guideValue=NewGuideManager.MaxGuideLevel;
			initConfig(guideValue);
		}

		/**
		 * @param funcType 值 为  BagOpen   SkillOpen 等值
		 */
		public static function isOpen(funcType:int):Boolean
		{
//			if(DataCenter.Instance.roleSelfVo.roleDyVo.level<NewGuideManager.MaxGuideLevel)
//			{
			if(_arr.length==Len)
			{
				return _arr[funcType-1];
			}
//			}
			return true;
		}
		
		/**增加引导
		 */
		public static function IncreaseGuideValue():void
		{
			guideValue++;
			initConfig(guideValue);
			YFEventCenter.Instance.dispatchEventWith(GlobalEvent.NewFuncOpen);
		}
		/** 引导 guide 
		 */
		public static function getGuideValue():int
		{
			return guideValue
		}

		
		
	}
}