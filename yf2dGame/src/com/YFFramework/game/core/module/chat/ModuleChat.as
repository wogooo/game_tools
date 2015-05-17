package com.YFFramework.game.core.module.chat
{
	import com.YFFramework.core.center.abs.module.AbsModule;
	import com.YFFramework.game.core.module.chat.view.ChatView;
	import com.YFFramework.game.core.scence.TypeScence;

	/**  2012-7-5
	 *	@author yefeng
	 */
	
	public class ModuleChat extends AbsModule
	{
		public function ModuleChat()
		{
			super();
			_belongScence=TypeScence.ScenceGameOn;
		}
		override public function show():void
		{
			var gameUiView:ChatView=new ChatView();
		}
		private function addEvents():void
		{
			
		}
		
		override public function dispose():void
		{
			
		}
	}
}