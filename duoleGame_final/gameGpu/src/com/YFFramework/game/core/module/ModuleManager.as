package com.YFFramework.game.core.module
{
	import com.YFFramework.core.center.face.IModule;
	import com.YFFramework.game.core.module.AnswerActivity.AnswerActivityModule;
	import com.YFFramework.game.core.module.DivinePulses.controller.ModuleDivinePulse;
	import com.YFFramework.game.core.module.GMtool.controller.ModuleGMTool;
	import com.YFFramework.game.core.module.activity.controller.ModuleActivity;
	import com.YFFramework.game.core.module.arena.ArenaModule;
	import com.YFFramework.game.core.module.autoSetting.controller.AutoModule;
	import com.YFFramework.game.core.module.bag.BagModule;
	import com.YFFramework.game.core.module.blackShop.BlackShopModule;
	import com.YFFramework.game.core.module.brave.BraveActivityModule;
	import com.YFFramework.game.core.module.character.ModuleCharacter;
	import com.YFFramework.game.core.module.chat.controller.ModuleChat;
	import com.YFFramework.game.core.module.demon.controller.DemonModule;
	import com.YFFramework.game.core.module.exchange.controller.ModuleExchange;
	import com.YFFramework.game.core.module.feed.controller.ModuleFeed;
	import com.YFFramework.game.core.module.forge.ForgeModule;
	import com.YFFramework.game.core.module.gameView.controller.ModuleGameView;
	import com.YFFramework.game.core.module.gift.controller.ModuleGift;
	import com.YFFramework.game.core.module.giftYellow.controller.ModuleGiftYellow;
	import com.YFFramework.game.core.module.growTask.controller.GrowTaskModule;
	import com.YFFramework.game.core.module.guild.controller.ModuleGuild;
	import com.YFFramework.game.core.module.im.controller.ModuleIM;
	import com.YFFramework.game.core.module.login.controller.ModuleLogin;
	import com.YFFramework.game.core.module.mall.controller.MallModule;
	import com.YFFramework.game.core.module.mapScence.ModuleMapScence;
	import com.YFFramework.game.core.module.market.MarketModule;
	import com.YFFramework.game.core.module.mount.controller.MountModule;
	import com.YFFramework.game.core.module.newGuide.controller.ModuleNewGuide;
	import com.YFFramework.game.core.module.npc.controller.ModuleNPC;
	import com.YFFramework.game.core.module.onlineReward.controller.ModuleOnlineReward;
	import com.YFFramework.game.core.module.pet.controller.PetModule;
	import com.YFFramework.game.core.module.pk.controller.ModulePK;
	import com.YFFramework.game.core.module.raid.controller.RaidModule;
	import com.YFFramework.game.core.module.rank.control.RankModule;
	import com.YFFramework.game.core.module.sceneUI.controller.ModuleSceneUI;
	import com.YFFramework.game.core.module.shop.controller.ModuleShop;
	import com.YFFramework.game.core.module.skill.controller.ModuleNewSkill;
	import com.YFFramework.game.core.module.smallMap.controller.ModuleSmallMap;
	import com.YFFramework.game.core.module.story.controller.ModuleStory;
	import com.YFFramework.game.core.module.system.controller.SystemModule;
	import com.YFFramework.game.core.module.systemReward.controller.ModuleSystemReward;
	import com.YFFramework.game.core.module.task.controller.TaskModule;
	import com.YFFramework.game.core.module.team.controller.TeamModule;
	import com.YFFramework.game.core.module.trade.controller.TradeModule;
	import com.YFFramework.game.core.module.wing.controller.WingModule;

	/**
	 * 模块管理中心
	 * @author yefeng
	 *2012-4-21下午7:02:49
	 */
	public class ModuleManager
	{
		/**登陆模块
		 */		
		public static var moduleLogin:IModule;
		
		/**  主界面 模块
		 */		
		public static var moduleGameView:IModule;
		/** 挂机模块
		 */		
		public static var autoModule:IModule;
		/** 魔族入侵模块
		 */		
		public static var demonModule:DemonModule;
		/** 场景模块
		 */
		public static var moduleMapScence:IModule;
		/**主视图功能模块 
		 */
		public static var moduleChat:IModule;
		
		/** 技能面板模块
		 */
		public static var moduleSkill:IModule;
		
		/**人物聊天模块 
		 */ 
		public static var moduleFriends:IModule;
		
		/**装备打造模块
		 */ 
		public static  var moduleForge:IModule;
		
		/**宠物模块
		 */		
		public static var petModule:IModule;
		/**组队模块
		 */		
		public static var teamModule:IModule;
		/**翅膀模块
		 */		
		public static var wingModule:WingModule;
		/**坐骑模块
		 */		
		public static var mountModule:IModule;
		/**交易模块
		 */		
		public static var tradeModule:TradeModule;
		/**副本模块
		 */		
		public static var raidModule:IModule;
		/**养成任务模块
		 */		
		public static var growTaskModule:GrowTaskModule;
		/** npc任务模块 
		 */		
		public static var moduleNPC:ModuleNPC;
		/**游戏小地图
		 */		
		public static var moduleSmallMap:IModule;
		/**
		 * 角色资料模块 
		 */
		public static var moduleCharacter:ModuleCharacter;
		
		/**
		 * 商店模块 
		 */		
		public static var moduleShop:ModuleShop;
		/**
		 * 背包模块 
		 */		
		public static var bagModule:BagModule;
		/**
		 *商城模块 
		 */		
		public static var mallModule:MallModule;
		
		/**
		 * 锻造模块 
		 */
		public static var forgetModule:ForgeModule;

		/**
		 * 任务系统 
		 */
		public static var taskModule:TaskModule;
		/** 场景层
		 */
		public static var moduleSceneUI:ModuleSceneUI;
		/**系统模块
		 */		
		public static var moduleSystem:SystemModule;
		/**游戏剧情模块
		 */		
		public static var moduleStory:ModuleStory;
		/** pk模块
		 */		
		public static var modulePK:ModulePK;
		/**市场模块 
		 */		
		public static var marketModule:MarketModule;
		/**排行榜 
		 */		
		public static var rankModule:RankModule;
		/**聊天模块
		 */		
		public static var moduleIM:ModuleIM;
		
		/**新手 引导
		 */		
		public static var moduleNewGuide:ModuleNewGuide;
		
		/** 活动  */		
		public static var moduleActivity:ModuleActivity;
		
		/**公会 */		
		public static var moduleGuild:IModule;
		/**兑换*/
		public static var moduleExchange:IModule;
		/**系统奖励*/
		public static var moduleSystemReward:IModule;
		/**礼包*/
		public static var moduleGift:IModule;
		/**在线奖励*/
		public static var moduleOnlineReward:IModule;
		
		/**智者千虑答题活动 */		
		public static var answerActivityModule:AnswerActivityModule;
		/** 勇者大乱斗活动 */		
		public static var braveActivityModule:BraveActivityModule;
		
		/** 黑市商店表 */		
		public static var blackShopModule:BlackShopModule;
		/** 竞技场控制模块 */		
		public static var arenaModule:ArenaModule;
		/**天命神脉*/
		public static var divinePulseModule:IModule;
		/**feed分享*/
		public static var feedModule:IModule;
		/**黄钻礼包*/
		public static var giftYellowModule:IModule;
		
		/**GM工具*/
		public static var gmModule:IModule;
		public function ModuleManager()
		{
		}
		
		public static  function initModule():void
		{
			autoModule = new AutoModule();
			///界面模块比较特殊 ，需要在登录游戏后就要创建处理
			moduleGameView=new ModuleGameView();
			moduleLogin=new ModuleLogin();
			moduleMapScence=new ModuleMapScence();
			moduleChat=new ModuleChat();
			moduleIM = new ModuleIM();
			bagModule=new BagModule();
			mallModule=new MallModule();
			petModule = new PetModule();
			teamModule = new TeamModule();
			mountModule = new MountModule();
			tradeModule = new TradeModule();
			raidModule = new RaidModule();
			moduleNPC=new ModuleNPC();
			moduleSmallMap=new ModuleSmallMap();
			moduleShop = new ModuleShop();
			moduleCharacter=new ModuleCharacter();
			moduleSkill=new ModuleNewSkill();
			wingModule = new WingModule();
			
			forgetModule = new ForgeModule();
			moduleSceneUI=new ModuleSceneUI();
			taskModule = new TaskModule();
			moduleSystem=new SystemModule();
			moduleStory=new ModuleStory();	
			modulePK=new ModulePK();
			marketModule=new MarketModule();
			rankModule=new RankModule();
			moduleNewGuide=new ModuleNewGuide();
			moduleActivity=new ModuleActivity();
			moduleGuild=new ModuleGuild();
			growTaskModule = new GrowTaskModule();
			moduleExchange=new ModuleExchange();
			moduleSystemReward =new ModuleSystemReward();
			answerActivityModule = new AnswerActivityModule();
			braveActivityModule= new BraveActivityModule();
			moduleGift=new ModuleGift();
			moduleOnlineReward =new ModuleOnlineReward();
			blackShopModule = new BlackShopModule();
			demonModule = new DemonModule();
			arenaModule=new ArenaModule();
			gmModule=new ModuleGMTool();
			divinePulseModule=new ModuleDivinePulse();
			feedModule=new ModuleFeed();
			giftYellowModule=new ModuleGiftYellow();
		}
		
	}
}