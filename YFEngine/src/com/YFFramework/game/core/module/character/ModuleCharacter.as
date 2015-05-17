package com.YFFramework.game.core.module.character
{
	/**人物模块
	 * @author yefeng
	 *2012-8-21下午9:53:06
	 */
	import com.YFFramework.core.center.abs.module.AbsModule;
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.net.socket.YFSocket;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.core.module.character.events.CharacterEvent;
	import com.YFFramework.game.core.module.character.model.CMDCharacter;
	import com.YFFramework.game.core.module.character.model.PutOffEquipVo;
	import com.YFFramework.game.core.module.character.view.CharacterWindow;
	import com.YFFramework.game.core.scence.TypeScence;
	
	public class ModuleCharacter extends AbsModule
	{	
	
		private var _characterWindow:CharacterWindow;
		public function ModuleCharacter()
		{
			super();
			_belongScence=TypeScence.ScenceGameOn;
		}
		
		override public function show():void
		{
			_characterWindow=new CharacterWindow();
			addEvents();
		}
		private function addEvents():void
		{
			///打开人物面板
			YFEventCenter.Instance.addEventListener(GlobalEvent.CharacterUIClick,onCharacterClick);
			
			
			////socket 发送
			YFEventCenter.Instance.addEventListener(GlobalEvent.GameIn,onSendSocket);
			/// 客户端请求 脱下装备
			YFEventCenter.Instance.addEventListener(CharacterEvent.C_PutOffEquip,onSendSocket);
			
			
			/////socket 接收
			
			/////服务端返回
			YFEventCenter.Instance.addEventListener(CharacterEvent.S_PutOffEquip,onRevSocket);
			
		}
		protected function onCharacterClick(e:YFEvent):void
		{
			_characterWindow.toggle();
		}
		/**客户端发送socket给服务端
		 */		
		private function onSendSocket(e:YFEvent):void
		{
			switch(e.type)
			{
				case GlobalEvent.GameIn:
					///发送请求装备列表
					YFSocket.Instance.sendMessage(CMDCharacter.C_RequestCharacterList);
					break;
				case CharacterEvent.C_PutOffEquip:
					//客户端请求脱下装备
					var dyId:String=String(e.param);
					var putOffEquipVo:PutOffEquipVo=new PutOffEquipVo();
					putOffEquipVo.dyId=dyId;
					YFSocket.Instance.sendMessage(CMDCharacter.C_PutOffEquip,putOffEquipVo);
					break;
				
				
			}
		}
		/**处理服务端返回的socket信息
		 */		
		private function onRevSocket(e:YFEvent):void
		{
			switch(e.type)
			{
				case CharacterEvent.S_PutOffEquip:
					///脱下装备
					var dyId:String=String(e.param);
					
					break;
			}
		}
			
			
	}
}