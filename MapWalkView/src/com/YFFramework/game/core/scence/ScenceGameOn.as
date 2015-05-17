package com.YFFramework.game.core.scence
{
	/**游戏中的场景
	 * 
	 * @author yefeng
	 *2012-4-20下午11:27:01
	 */
	import com.YFFramework.core.center.abs.scence.AbsScence;
	import com.YFFramework.game.core.module.ModuleManager;
	
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
			ModuleManager.moduleGameView.init();
			ModuleManager.bagModule.init();
			ModuleManager.moduleMapScence.init();
			ModuleManager.moduleNPCTask.init();
			ModuleManager.moduleSmallMap.init();
			ModuleManager.moduleShop.init();
			ModuleManager.moduleCharacter.init();
			ModuleManager.moduleSkill.init();
			ModuleManager.petModule.init();
			ModuleManager.forgetModule.init();
			ModuleManager.teamModule.init();
			ModuleManager.moduleSceneUI.init();
			ModuleManager.moduleSystem.init();
			
		}
		/** 释放各个模块引用  内存释放已经在各自内部主动进行
		 */		
		override protected function removeScenceUI():void
		{
			ModuleManager.moduleGameView=null;
			ModuleManager.moduleMapScence=null;
			ModuleManager.moduleChat=null;
			ModuleManager.moduleSkill=null;
			ModuleManager.moduleBackPack=null;
			ModuleManager.moduleFriends=null;
			ModuleManager.moduleForge=null;
			ModuleManager.moduleMount=null;
			ModuleManager.moduleNPCTask=null;
			ModuleManager.moduleSmallMap=null;
			
			ModuleManager.petModule=null;
			ModuleManager.teamModule=null;
			ModuleManager.bagModule=null;
			ModuleManager.moduleSceneUI=null;
			ModuleManager.moduleSystem=null;
		}
		
	}
}