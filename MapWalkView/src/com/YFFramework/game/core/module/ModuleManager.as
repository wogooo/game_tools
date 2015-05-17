package com.YFFramework.game.core.module
{
	import com.YFFramework.core.center.face.IModule;
	import com.YFFramework.game.core.module.bag.BagModule;
	import com.YFFramework.game.core.module.character.ModuleCharacter;
	import com.YFFramework.game.core.module.chat.ModuleChat;
	import com.YFFramework.game.core.module.forge.ForgeModule;
	import com.YFFramework.game.core.module.gameView.controller.ModuleGameView;
	import com.YFFramework.game.core.module.login.controller.ModuleLogin;
	import com.YFFramework.game.core.module.mapScence.ModuleMapScence;
	import com.YFFramework.game.core.module.mount.controller.ModuleMount;
	import com.YFFramework.game.core.module.npc.controller.ModuleNPCTask;
	import com.YFFramework.game.core.module.pet.controller.PetModule;
	import com.YFFramework.game.core.module.sceneUI.controller.ModuleSceneUI;
	import com.YFFramework.game.core.module.shop.ModuleShop;
	import com.YFFramework.game.core.module.skill.ModuleSkill;
	import com.YFFramework.game.core.module.smallMap.controller.ModuleSmallMap;
	import com.YFFramework.game.core.module.system.controller.ModuleSystem;
	import com.YFFramework.game.core.module.team.controller.TeamModule;

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
		
		/** 场景模块
		 */
		public static var moduleMapScence:IModule;
		/**主视图功能模块 
		 */
		public static var moduleChat:IModule;
		
		/** 技能面板模块
		 */
		public static var moduleSkill:IModule;
		/**背包模块
		 */		
		public static  var moduleBackPack:IModule;
		
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
		/**坐骑模块
		 */		
		public static var moduleMount:IModule;
		/** npc任务模块 
		 */		
		public static var moduleNPCTask:IModule;
		/**游戏小地图
		 */		
		public static var moduleSmallMap:IModule;
		/**
		 * 角色资料模块 
		 */
		public static var moduleCharacter:IModule;
		
		
		public static var moduleShop:ModuleShop;
		/**
		 * 背包模块 
		 */		
		public static var bagModule:BagModule;
		
		public static var forgetModule:ForgeModule;
		/** 场景层
		 */
		public static var moduleSceneUI:ModuleSceneUI;
		/**系统模块
		 */		
		public static var moduleSystem:ModuleSystem;

		
		public function ModuleManager()
		{
		}
		
		public static  function initModule():void
		{
			///界面模块比较特殊 ，需要在登录游戏后就要创建处理
			moduleGameView=new ModuleGameView();
			moduleLogin=new ModuleLogin();
			moduleMapScence=new ModuleMapScence();
			moduleChat=new ModuleChat();
//			moduleFriends=new ModuleFriends();
//			moduleForge=new ModuleForge();
			bagModule=new BagModule();
			petModule = new PetModule();
			teamModule = new TeamModule();
			moduleMount=new ModuleMount();
			moduleNPCTask=new ModuleNPCTask();
			moduleSmallMap=new ModuleSmallMap();
			moduleShop = new ModuleShop();
			moduleCharacter=new ModuleCharacter();
			moduleSkill=new ModuleSkill();
			forgetModule = new ForgeModule();
			moduleSceneUI=new ModuleSceneUI();
			
			moduleSystem=new ModuleSystem();
		}
	}
}