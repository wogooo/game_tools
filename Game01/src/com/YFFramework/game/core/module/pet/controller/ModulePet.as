package com.YFFramework.game.core.module.pet.controller
{
	/**@author yefeng
	 *2012-8-21下午10:24:33
	 */
	import com.YFFramework.core.center.abs.module.AbsModule;
	import com.YFFramework.core.debug.print;
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.net.socket.YFSocket;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.core.module.pet.events.PetEvent;
	import com.YFFramework.game.core.module.pet.manager.PetDyManager;
	import com.YFFramework.game.core.module.pet.model.CMDPet;
	import com.YFFramework.game.core.module.pet.model.PetCallBackVo;
	import com.YFFramework.game.core.module.pet.model.PetPlayResultVo;
	import com.YFFramework.game.core.module.pet.model.PetPlayVo;
	import com.YFFramework.game.core.module.pet.view.PetWindow;
	import com.YFFramework.game.core.scence.TypeScence;
	
	public class ModulePet extends AbsModule
	{
		protected var _petWindow:PetWindow;
		
		/**是否已经请求了宠物
		 */ 
		private var _isRequest:Boolean;
		public function ModulePet()
		{
			_belongScence=TypeScence.ScenceGameOn;
			_isRequest=false;
		}
		
		override public function show():void
		{
			_petWindow=new PetWindow();
			addEvents();
		}
		private function addEvents():void
		{
			/// 单击 打开宠物面板
			YFEventCenter.Instance.addEventListener(GlobalEvent.PetUIClick,onPetUIClick);
			////socket 发送 
			///请求宠物出战
			YFEventCenter.Instance.addEventListener(PetEvent.C_PetPlay,onSendSocket);
			///宠物收回
			YFEventCenter.Instance.addEventListener(PetEvent.C_PetCallBack,onSendSocket);
			
			
			/// socket 返回
			///进入游戏   请求宠物列表
			YFEventCenter.Instance.addEventListener(GlobalEvent.GameIn,onSocketEvent);
			///服务端返回宠物列表
			YFEventCenter.Instance.addEventListener(PetEvent.S_RequestPetList,onSocketEvent);
			//服务端返回宠物出战
			YFEventCenter.Instance.addEventListener(PetEvent.S_PetPlay,onSocketEvent);
			///宠物成功收回			
			YFEventCenter.Instance.addEventListener(PetEvent.S_PetCallBack,onSocketEvent);

		}
		
		private function onPetUIClick(e:YFEvent):void
		{
			_petWindow.petListWindow.toggle();
		}
		
		/**请求宠物列表
		 */		
		private function requestPetList():void
		{
			if(_isRequest==false)
			{
				_isRequest=true;
				YFSocket.Instance.sendMessage(CMDPet.C_RequestPetList);
			}
		}
		/** 客户端发送socket 消息
		 */		
		private function onSendSocket(e:YFEvent):void
		{
			switch(e.type)
			{
				case PetEvent.C_PetPlay:
					//宠物出战
					var petPlayVo:PetPlayVo=e.param as PetPlayVo;
					YFSocket.Instance.sendMessage(CMDPet.C_PetPlay,petPlayVo);
					break;
				case PetEvent.C_PetCallBack:
					///宠物收回
					var petCallBackVo:PetCallBackVo=e.param as PetCallBackVo;
					YFSocket.Instance.sendMessage(CMDPet.C_PetCallBack,petCallBackVo);
					break;
			
			}
		}
		
		/** 服务端返回数据
		 */		
		private function onSocketEvent(e:YFEvent):void
		{
			switch(e.type)
			{
				case GlobalEvent.GameIn:
					///进入游戏
					YFEventCenter.Instance.removeEventListener(GlobalEvent.GameIn,onSocketEvent);
					///进入游戏  请求宠物列表
					requestPetList();
					break;
				
				/// 服务端返回宠物列表
				case PetEvent.S_RequestPetList:
					var petArr:Array=e.param as Array;
					//更新宠物数据
					PetDyManager.Instance.cachePetList(petArr);
					///更细宠物ui
					_petWindow.petListWindow.updatePetListView();
					break;
				
				case PetEvent.S_PetPlay:
					///服务端返回宠物出战
					var petPlayResultVo:PetPlayResultVo=e.param as PetPlayResultVo;
					///数据更新
					PetDyManager.Instance.setPetPlay(petPlayResultVo.dyId); 
					///ui更新
					_petWindow.petListWindow.updatePetPlay(petPlayResultVo.dyId,true);
					print(this,"出战宠物:"+petPlayResultVo.dyId);
					////增加战斗力  ...
					YFEventCenter.Instance.dispatchEventWith(GlobalEvent.PetPlay,petPlayResultVo);////场景模块进行处理
					break;
				
				case PetEvent.S_PetCallBack:
					//服务端返回收回宠物
					var callBackPetDyId:String=String(e.param);
					///数据更新
					PetDyManager.Instance.callBackPet(callBackPetDyId);
					_petWindow.petListWindow.updatePetPlay(callBackPetDyId,false);
					break;
			}
		}
		
	}
}