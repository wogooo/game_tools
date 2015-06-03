package com.YFFramework.game.core.module.rank.control
{
	/**
	 * by jina
	 * @version 1.0.0
	 * creation time：2013-6-18 上午9:53:14
	 * reform time:2013-11-18 ！惊人的巧合啊！
	 */
	import com.CMD.GameCmd;
	import com.YFFramework.core.center.abs.module.AbsModule;
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.game.core.global.DataCenter;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.module.ModuleManager;
	import com.YFFramework.game.core.module.character.view.CharacterWindow;
	import com.YFFramework.game.core.module.growTask.event.GrowTaskEvent;
	import com.YFFramework.game.core.module.notice.manager.NoticeManager;
	import com.YFFramework.game.core.module.notice.model.NoticeType;
	import com.YFFramework.game.core.module.pet.model.PetDyVo;
	import com.YFFramework.game.core.module.rank.data.OtherHeroDyVo;
	import com.YFFramework.game.core.module.rank.data.OtherHeroPetDyManager;
	import com.YFFramework.game.core.module.rank.data.RankDyManager;
	import com.YFFramework.game.core.module.rank.source.RankSource;
	import com.YFFramework.game.core.module.rank.view.RankRoleInfoWindow;
	import com.YFFramework.game.core.module.rank.view.RankWindow;
	import com.YFFramework.game.core.scence.TypeScence;
	import com.chat_cmd.ChatCmd;
	import com.dolo.ui.managers.UIManager;
	import com.msg.hero.COtherHeroInfo;
	import com.msg.hero.SOtherHeroInfo;
	import com.msg.pets.COtherPetInfo;
	import com.msg.pets.SOtherPetInfo;
	import com.msg.rank_pro.CRankPlayOrPetInfo;
	import com.msg.rank_pro.CRankRequest;
	import com.msg.rank_pro.SRankPlayOrPetInfo;
	import com.msg.rank_pro.SRankResp;
	import com.net.MsgPool;
	import com.net.NetEngine;
	import com.net.NetManager;
	
	import flash.utils.getTimer;
	
	public class RankModule extends AbsModule
	{
		//======================================================================
		//       public property
		//======================================================================
		
		//======================================================================
		//       private property
		//======================================================================
		private var _view:RankWindow;
		
		private var _lastTime:int=0;
		
		private var _chatOK:Boolean=false;
		
		private var _isRankRole:Boolean;
		//======================================================================
		//        constructor
		//======================================================================
		
		
		public function RankModule()
		{
			_belongScence=TypeScence.ScenceGameOn;
			_view=new RankWindow();

		}
		
		//======================================================================
		//        public function
		//======================================================================
		override public function init():void
		{
			addEvents();
		}
		
		/** 1.有没有超过十分钟；2.（在没有超时的情况下）没有数据；3.满足前两条，不请求
		 * @param type
		 */		
		public function rankReq(type:int):void
		{
			var now:int=getTimer();
			if(type >= RankSource.TITLE_ACTIVITY41)
				sendRankReqMsg(type);
			else if((now - _lastTime) >= RankSource.TEN_MIMUS)
			{
				_lastTime=now;
				sendRankReqMsg(type);		
			}
			else if(RankDyManager.instance.checkRankInfo(type) == false)
			{
				sendRankReqMsg(type);
			}
			else
				_view.showRankInfo(type);
		}
		
		/**
		 * 如果是排行数据，则需要十分钟只能有缓存就不请求；其他则实时查询
		 * @param playerId
		 * @param isRank fasle:其他查询；true：排行查询
		 */		
		public function otherPlayerReq(playerId:int,isRank:Boolean=false):void
		{
			_isRankRole=isRank;
			var now:int=getTimer();
			//如果请求的是自己的就不要向服务端请求了
			if(playerId == DataCenter.Instance.roleSelfVo.roleDyVo.dyId)
			{
				var win:CharacterWindow=ModuleManager.moduleCharacter.getCharacterWindow();
				win.open();
				UIManager.centerMultiWindows(_view,win,5);
			}
			else if((now - _lastTime) >= RankSource.TEN_MIMUS || OtherHeroPetDyManager.instance.getOtherCharacter(playerId) == null)
			{			
				if(isRank == false)
				{
					var msg:COtherHeroInfo=new COtherHeroInfo();
					msg.dyId=playerId;
					MsgPool.sendGameMsg(GameCmd.COtherHeroInfo,msg);
				}
				else
				{
					var rankMsg:CRankPlayOrPetInfo=new CRankPlayOrPetInfo();
					rankMsg.type=0;
					rankMsg.id=playerId;
					NetManager.chatSocket.sendMessage(ChatCmd.CRankPlayOrPetInfo,rankMsg);
				}
			}
			else
			{
				var vo:OtherHeroDyVo=OtherHeroPetDyManager.instance.getOtherCharacter(playerId);
				if(_isRankRole == false)
				{
					RankRoleInfoWindow.instance.updateCharacter(vo,true);
					RankRoleInfoWindow.instance.open();					
				}
				else
				{
					_view.showRoleDetail(vo);
				}
			}
		}
		
		public function otherPetReq(petId:int):void
		{
			if(OtherHeroPetDyManager.instance.getPet(petId) == null)
			{			
				var rankMsg:CRankPlayOrPetInfo=new CRankPlayOrPetInfo();
				rankMsg.type=1;
				rankMsg.id=petId;
				NetManager.chatSocket.sendMessage(ChatCmd.CRankPlayOrPetInfo,rankMsg);
			}
			else
			{
				var vo:PetDyVo=OtherHeroPetDyManager.instance.getPet(petId);
				_view.showPetDetail(vo);
			}
		}
		//======================================================================
		//        private function
		//======================================================================
		private function sendRankReqMsg(type:int):void
		{
			if(_chatOK)
			{
				var msg:CRankRequest=new CRankRequest();
				msg.rankType=type;
				NetManager.chatSocket.sendMessage(ChatCmd.CRankRequest,msg);
			}		
		}
		
		/**
		 * 客户端请求
		 */		
		private function addEvents():void
		{
			/****************************客户端请求******************************/
			//点击排行榜图标
			YFEventCenter.Instance.addEventListener(GlobalEvent.RankUIClick,openRank);			
			//只有这个发来_chatOK为真的消息才能请求
			YFEventCenter.Instance.addEventListener(GlobalEvent.ChatCheckOK,onChatOK);
			
			/****************************服务器返回******************************/
			//排行榜信息回复
			NetManager.chatSocket.addCallback(ChatCmd.SRankResp,SRankResp,rankResp);
			//其他玩家角色信息查询回复
			NetManager.gameSocket.addCallback(GameCmd.SOtherHeroInfo,SOtherHeroInfo,otherHeroInfoResp);
			//排行榜：其他玩家或宠物信息查询回复
			NetManager.chatSocket.addCallback(ChatCmd.SRankPlayOrPetInfo,SRankPlayOrPetInfo,rankOtherRoleORpetResp);
		}
		
		//======================================================================
		//        event handler
		//======================================================================
		private function openRank(e:YFEvent):void
		{
			UIManager.switchOpenClose(_view);
		}
		
		private function onChatOK(e:YFEvent):void
		{
			_chatOK=true;
			if(_view.isOpen)
			{
				_view.searchToServer();
				_view.searchDefaultFirstInfo();
			}
		}
		
		private function rankResp(msg:SRankResp):void
		{
			RankDyManager.instance.setRankInfo(msg.rankType,msg.rankList);
			if(_view.isOpen)
			{
				_view.showRankInfo(msg.rankType);
				_view.searchDefaultFirstInfo();
			}
			YFEventCenter.Instance.dispatchEventWith(GrowTaskEvent.activity_arena);
		}
		
		private function otherHeroInfoResp(msg:SOtherHeroInfo):void
		{
			if(msg.code == TypeProps.RSPMSG_FAIL)
			{
				NoticeManager.setNotice(NoticeType.Notice_id_1800);
			}
			else
			{
				OtherHeroPetDyManager.instance.setOtherHeroInfo(msg);
				var vo:OtherHeroDyVo=OtherHeroPetDyManager.instance.getOtherCharacter(msg.dyId);
				if(_isRankRole == false)
				{
					RankRoleInfoWindow.instance.updateCharacter(vo,true);
					RankRoleInfoWindow.instance.open();					
				}
				else
				{
					_view.showRoleDetail(vo);
				}
			}
		}
		
		private function rankOtherRoleORpetResp(msg:SRankPlayOrPetInfo):void
		{
			if(msg.hasPetInfo)
			{
				OtherHeroPetDyManager.instance.setOtherPetInfo(msg);
				var vo:PetDyVo=OtherHeroPetDyManager.instance.getPet(msg.petInfo.petId);
				_view.showPetDetail(vo);
			}
			else
			{
				OtherHeroPetDyManager.instance.rankOtherRole(msg);
				var hero:OtherHeroDyVo=OtherHeroPetDyManager.instance.getOtherCharacter(msg.characterId);//需要动态playerId
				_view.showRoleDetail(hero);
			}
		}
		//======================================================================
		//        getter&setter
		//======================================================================
		
		
	}
} 