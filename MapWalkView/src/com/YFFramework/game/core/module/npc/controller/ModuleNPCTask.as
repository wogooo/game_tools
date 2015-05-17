package com.YFFramework.game.core.module.npc.controller
{
	import com.YFFramework.core.center.abs.module.AbsModule;
	import com.YFFramework.game.core.module.npc.view.NPCTaskView;
	import com.YFFramework.game.core.scence.TypeScence;
	
	/**npc 任务相关模块
	 * 2012-10-24 下午2:28:22
	 *@author yefeng
	 */
	public class ModuleNPCTask extends AbsModule
	{
		private var _npcView:NPCTaskView;
		public function ModuleNPCTask()
		{
			super();
			_belongScence=TypeScence.ScenceGameOn;
		}
		override public function init():void
		{
			_npcView=new NPCTaskView();
			addEvents();
		}
		private function addEvents():void
		{
			
		}
		
		
	}
}