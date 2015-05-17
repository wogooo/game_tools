package com.YFFramework.game.core.scence
{
	/**游戏中的场景
	 * 
	 * @author yefeng
	 *2012-4-20下午11:27:01
	 */
	import com.YFFramework.core.center.abs.scence.AbsScence;
	import com.YFFramework.game.core.module.ModuleManager;
	import com.YFFramework.game.core.module.pet.controller.ModulePet;
	
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
			ModuleManager.moduleMapScence.show();
			ModuleManager.moduleChat.show();
			ModuleManager.moduleSkill.show();
			ModuleManager.moduleBackPack.show();
			ModuleManager.moduleCharacter.show();
			ModuleManager.moduleFriends.show();
			ModuleManager.moduleForge.show();
			ModuleManager.modulePet.show();
			ModuleManager.moduleMount.show();
			ModuleManager.moduleNPCTask.show();
			ModuleManager.moduleSmallMap.show();
			ModuleManager.moduleTask.show();
			
		}
		/** 释放各个模块引用  内存释放已经在各自内部主动进行
		 */		
		override protected function removeScenceUI():void
		{
			ModuleManager.moduleMapScence=null;
			ModuleManager.moduleChat=null;
			ModuleManager.moduleSkill=null;
			ModuleManager.moduleBackPack=null;
			ModuleManager.moduleCharacter=null;
			ModuleManager.moduleFriends=null;
			ModuleManager.moduleForge=null;
			ModuleManager.modulePet=null;
			ModuleManager.moduleMount=null;
			ModuleManager.moduleNPCTask=null;
			ModuleManager.moduleSmallMap=null;
			ModuleManager.moduleTask=null;
		}
		
	}
}