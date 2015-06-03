package com.YFFramework.game.core.scence
{
	/**游戏中的场景
	 * 
	 * @author yefeng
	 *2012-4-20下午11:27:01
	 */
	import com.YFFramework.core.center.abs.scence.AbsScence;
	import com.YFFramework.game.core.module.ModuleManager;
	import com.YFFramework.game.gameConfig.ConfigManager;
	import com.YFFramework.game.gameConfig.TypePlatform;
	
	public class ScenceGameOn extends AbsScence
	{
		public function ScenceGameOn()
		{
			super(TypeScence.ScenceGameOn);
		}
		
		/**初始化各个模块ui 
		 */		
		override public function enterScence():void
		{
			var pf:String=ConfigManager.Instance.platform;
			ModuleManager.moduleGameView.init();
			ModuleManager.moduleMapScence.init();
			ModuleManager.autoModule.init();
			ModuleManager.bagModule.init();
			ModuleManager.mallModule.init();
			ModuleManager.moduleNPC.init();
			ModuleManager.moduleSmallMap.init();
			ModuleManager.moduleShop.init();
			ModuleManager.moduleCharacter.init();
			ModuleManager.moduleSkill.init();
			ModuleManager.petModule.init();
			ModuleManager.forgetModule.init();
			ModuleManager.teamModule.init();
			ModuleManager.mountModule.init();
			ModuleManager.tradeModule.init();
			ModuleManager.raidModule.init();
			ModuleManager.moduleSceneUI.init();
			ModuleManager.moduleSystem.init();
			ModuleManager.moduleStory.init();
			ModuleManager.taskModule.init();
			ModuleManager.modulePK.init();
			ModuleManager.marketModule.init();
			ModuleManager.rankModule.init();
			ModuleManager.moduleChat.init();
			ModuleManager.moduleIM.init();
			ModuleManager.moduleNewGuide.init();
			ModuleManager.moduleActivity.init();
			ModuleManager.moduleGuild.init();
			ModuleManager.growTaskModule.init();
			ModuleManager.answerActivityModule.init();
			ModuleManager.braveActivityModule.init();
			ModuleManager.moduleSystemReward.init();
			ModuleManager.moduleExchange.init();
			ModuleManager.moduleGift.init();
			ModuleManager.moduleOnlineReward.init();
			ModuleManager.blackShopModule.init();
			ModuleManager.wingModule.init();
			ModuleManager.demonModule.init();
			ModuleManager.arenaModule.init();
			ModuleManager.gmModule.init();
			ModuleManager.divinePulseModule.init();
			if(pf==TypePlatform.PF_pengyou||pf==TypePlatform.PF_qzone)
			{
				ModuleManager.feedModule.init();
				ModuleManager.giftYellowModule.init();
			}
		}
		/** 释放各个模块引用  内存释放已经在各自内部主动进行
		 */		
		override protected function removeScenceUI():void
		{
			ModuleManager.moduleGameView=null;
			ModuleManager.moduleMapScence=null;
			ModuleManager.moduleChat=null;
			ModuleManager.moduleSkill=null;
			ModuleManager.moduleFriends=null;
			ModuleManager.moduleForge=null;
			ModuleManager.mountModule=null;
			ModuleManager.moduleNPC=null;
			ModuleManager.moduleSmallMap=null;
			
			ModuleManager.growTaskModule=null;
			ModuleManager.petModule=null;
			ModuleManager.teamModule=null;
			ModuleManager.bagModule=null;
			ModuleManager.moduleSceneUI=null;
			ModuleManager.moduleSystem=null;
			ModuleManager.mallModule=null;
			ModuleManager.tradeModule=null;
			ModuleManager.moduleStory=null;
			ModuleManager.taskModule=null;
			ModuleManager.modulePK=null;
			ModuleManager.marketModule=null;
			ModuleManager.rankModule=null;
			ModuleManager.raidModule=null;
			ModuleManager.moduleNewGuide=null;
			ModuleManager.autoModule=null;
			ModuleManager.moduleActivity=null;
			ModuleManager.moduleGuild=null;
			ModuleManager.answerActivityModule=null;
			ModuleManager.moduleSystemReward=null;
			ModuleManager.moduleExchange=null;
			ModuleManager.moduleGift=null;
			ModuleManager.moduleOnlineReward=null;
			ModuleManager.blackShopModule=null;
			ModuleManager.wingModule=null;
			ModuleManager.demonModule=null;
			ModuleManager.braveActivityModule=null;
			ModuleManager.arenaModule=null;
			ModuleManager.gmModule=null;
			ModuleManager.divinePulseModule=null;
			ModuleManager.feedModule=null;
			ModuleManager.giftYellowModule=null;
		}
		
	}
}