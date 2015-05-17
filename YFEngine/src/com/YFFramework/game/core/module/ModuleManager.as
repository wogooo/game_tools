package com.YFFramework.game.core.module
{
	import com.YFFramework.core.center.face.IModule;
	import com.YFFramework.game.core.module.backpack.ModuleBackpack;
	import com.YFFramework.game.core.module.character.ModuleCharacter;
	import com.YFFramework.game.core.module.chat.ModuleChat;
	import com.YFFramework.game.core.module.forge.ModuleForge;
	import com.YFFramework.game.core.module.friends.ModuleFriends;
	import com.YFFramework.game.core.module.login.ModuleLogin;
	import com.YFFramework.game.core.module.mapScence.ModuleMapScence;
	import com.YFFramework.game.core.module.mount.controller.ModuleMount;
	import com.YFFramework.game.core.module.npc.controller.ModuleNPCTask;
	import com.YFFramework.game.core.module.pet.controller.ModulePet;
	import com.YFFramework.game.core.module.skill.ModuleSkill;
	import com.YFFramework.game.core.module.smallMap.controller.ModuleSmallMap;
	import com.YFFramework.game.core.module.task.controller.ModuleTask;

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
		/**人物面板
		 */ 
		public static var moduleCharacter:IModule;
		
		/**人物聊天模块 
		 */ 
		public static var moduleFriends:IModule;
		
		/**装备打造模块
		 */ 
		public static  var moduleForge:IModule;
		
		/**宠物模块
		 */		
		public static var modulePet:IModule;
		/**坐骑模块
		 */		
		public static var moduleMount:IModule;
		/** npc任务模块 
		 */		
		public static var moduleNPCTask:IModule;
		/**游戏小地图
		 */		
		public static var moduleSmallMap:IModule;
		
		public static var moduleTask:IModule;
		public function ModuleManager()
		{
		}
		
		public static  function initModule():void
		{
			moduleMapScence=new ModuleMapScence();
			moduleChat=new ModuleChat();
			moduleSkill=new ModuleSkill();
			moduleLogin=new ModuleLogin();
			moduleBackPack=new ModuleBackpack();
			moduleCharacter=new ModuleCharacter();
			moduleFriends=new ModuleFriends();
			moduleForge=new ModuleForge();
			modulePet=new ModulePet();
			moduleMount=new ModuleMount();
			moduleNPCTask=new ModuleNPCTask();
			moduleSmallMap=new ModuleSmallMap();
			moduleTask=new ModuleTask();
		}
	}
}