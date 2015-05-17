package com.YFFramework.game.core.module.chat.view
{
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.core.module.chat.events.ChatEvent;

	/** 
	 * 处理界面场景 的按钮等等一系列的东西
	 *  2012-7-5
	 *	@author yefeng
	 */
	public class ChatView
	{
		public function ChatView()
		{
			initUI();
			addEvents();
		}
		
		protected function initUI():void
		{
			
		}
		
		protected function addEvents():void
		{
			YFEventCenter.Instance.addEventListener(ChatEvent.Charge,onMainViewEvent);
		}
		private function onMainViewEvent(e:YFEvent):void
		{
			switch(e.type)
			{
				case ChatEvent.Charge:
						//充值 
					YFEventCenter.Instance.dispatchEventWith(GlobalEvent.ScenceShake);
					break;
				
			}
		}
				
	}
}