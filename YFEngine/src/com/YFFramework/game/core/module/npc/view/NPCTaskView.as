package com.YFFramework.game.core.module.npc.view
{
	import com.YFFramework.core.debug.print;
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.core.module.npc.manager.NPCBasicManager;
	import com.YFFramework.game.core.module.npc.model.NPCBasicVo;
	
	import flash.utils.Dictionary;

	/**npc 处理
	 * 2012-10-24 下午2:30:52
	 *@author yefeng
	 */
	public class NPCTaskView
	{
		
		private var _windowDict:Dictionary;
		public function NPCTaskView()
		{
			initUI();
			addEvents();
		}
		/** UI初始化
		 */		
		private function initUI():void
		{
			_windowDict=new Dictionary();
		}
		/**事件侦听
		 */		
		private function addEvents():void
		{
			YFEventCenter.Instance.addEventListener(GlobalEvent.NPCClicker,onNPCClick);
		}
		/** npc click点击 触发事件 弹出相应的窗口
		 */		
		private function onNPCClick(e:YFEvent):void
		{
			var basicId:int=int(e.param);
			var npcBasicVo:NPCBasicVo=NPCBasicManager.Instance.getNPCBasicVo(basicId);
			////一个npc对应一个窗口
			print(this,"进行npc窗口响应...，点击的npc为"+npcBasicVo.id);	
			
			var npcChatWindow:NPCChatWindow;
			if(_windowDict[basicId])npcChatWindow=_windowDict[basicId];
			else
			{
				npcChatWindow=new NPCChatWindow();
				_windowDict[basicId]=npcChatWindow;
			}
			npcChatWindow.setText(basicId);
			npcChatWindow.popUp();
			npcChatWindow.centerWindow();
		}
			
		
		
	}
}