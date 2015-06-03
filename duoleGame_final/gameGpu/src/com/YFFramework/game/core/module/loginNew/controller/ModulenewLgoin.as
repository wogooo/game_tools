package com.YFFramework.game.core.module.loginNew.controller
{
	import com.CMD.GameCmd;
	import com.YFFramework.core.center.manager.update.TimeOut;
	import com.YFFramework.core.debug.print;
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.game.core.global.DataCenter;
	import com.YFFramework.game.core.global.TimeManager;
	import com.YFFramework.game.core.global.manager.CharacterDyManager;
	import com.YFFramework.game.core.module.growTask.event.GrowTaskEvent;
	import com.YFFramework.game.core.module.guild.manager.GuildInfoManager;
	import com.YFFramework.game.core.module.login.manager.ChatConnnection;
	import com.YFFramework.game.core.module.loginNew.events.LoginNewEvent;
	import com.YFFramework.game.core.module.loginNew.model.RegisterDyVo;
	import com.YFFramework.game.core.module.loginNew.view.RegisterView;
	import com.YFFramework.game.core.module.mapScence.world.model.RoleDyVo;
	import com.YFFramework.game.core.module.mapScence.world.model.type.TypeRole;
	import com.YFFramework.game.core.module.newGuide.manager.NewGuideManager;
	import com.YFFramework.game.core.module.newGuide.model.NewGuideFuncOpenConfig;
	import com.YFFramework.game.gameConfig.ConfigManager;
	import com.msg.enumdef.RspMsg;
	import com.msg.login.CCheckName;
	import com.msg.login.CCreateHeroInfo;
	import com.msg.login.CLogin;
	import com.msg.login.SCheckName;
	import com.msg.login.SLogin;
	import com.net.MsgPool;
	import com.net.NetManager;

	/**@author yefeng
	 * 2013 2013-8-20 上午10:15:54 
	 */
	public class ModulenewLgoin
	{
		public function ModulenewLgoin()
		{
			addEvents();
			addSocketCallback();
			print(this,"new module");
		}
		private function addEvents():void
		{
			
			//进行登录验证
			YFEventCenter.Instance.addEventListener(LoginNewEvent.BeginConnectSocket,sendLogin);
			//开始检查名称
			YFEventCenter.Instance.addEventListener(LoginNewEvent.C_CheckName,onSendSocket);
			
			YFEventCenter.Instance.addEventListener(LoginNewEvent.C_CreateHero,onSendSocket);

		}
		private function onSendSocket(e:YFEvent):void
		{
			var data:Object=e.param;
			switch(e.type)
			{
				case LoginNewEvent.C_CreateHero:  ///创建角色
					var registerDyVo:RegisterDyVo=e.param as RegisterDyVo;
					var cCreateHeroInfo:CCreateHeroInfo=new CCreateHeroInfo();
					cCreateHeroInfo.sex=registerDyVo.sex;
					cCreateHeroInfo.name=registerDyVo.name;
					MsgPool.sendGameMsg(GameCmd.CCreateHeroInfo,cCreateHeroInfo);
					break;
				case LoginNewEvent.C_CheckName: //检测名称
					var checkName:String=data.toString();
					print(this,"checkName:"+checkName);
					var cCheckName:CCheckName=new CCheckName();
					cCheckName.name=checkName;
					MsgPool.sendGameMsg(GameCmd.CCheckName,cCheckName);
					break;
			}
		}
		
		/**开始进行登录
		 */		
		private function sendLogin(e:YFEvent=null):void
		{
			if(ConfigManager.Instance.webId!="")
			{
				var cLogin:CLogin=new CLogin();
				print(this,"网站id:"+ConfigManager.Instance.webId,"key:"+ConfigManager.Instance.keyId);
				cLogin.countId=ConfigManager.Instance.webId;
				cLogin.userKey=ConfigManager.Instance.keyId;
				MsgPool.sendGameMsg(GameCmd.CLogin,cLogin);				
			}
		}
		private function addSocketCallback():void
		{
			///需要创建角色的侦听
			NetManager.gameSocket.addCallback(GameCmd.SLogin,SLogin,createHeroCallback);
			///检测名称的返回
			NetManager.gameSocket.addCallback(GameCmd.SCheckName,SCheckName,checkNameCallback);
			
		}
		/**能够创建角色
		 */		
		private function createHeroCallback(sLogin:SLogin):void
		{
			if(sLogin.code==RspMsg.RSPMSG_FAIL)
			{
//				YFEventCenter.Instance.dispatchEventWith(LoginNewEvent.ShowRegister);
				RegisterView.Instance.loadIt();
			}
			else
			{
				var roledyVo:RoleDyVo=new RoleDyVo();
				roledyVo.state=TypeRole.State_Normal;
				roledyVo.bigCatergory=TypeRole.BigCategory_Player;
				roledyVo.dyId=sLogin.playerInfo.dyId;
				roledyVo.roleName=sLogin.playerInfo.name;
				roledyVo.sex=sLogin.playerInfo.sex;
				DataCenter.Instance.roleSelfVo.roleDyVo=roledyVo; ///设置数据
				DataCenter.Instance.roleSelfVo.roleDyVo.career=sLogin.playerInfo.career;
				DataCenter.Instance.roleSelfVo.roleDyVo.hp=sLogin.playerInfo.hp;
				DataCenter.Instance.roleSelfVo.roleDyVo.maxHp=sLogin.playerInfo.maxHp;
				DataCenter.Instance.roleSelfVo.exp=sLogin.playerInfo.exp;
				//				DataCenter.Instance.roleSelfVo.roleDyVo.bigCatergory=TypeRole.BigCategory_Player;
				//				DataCenter.Instance.roleSelfVo.maxExp=sLogin.playerInfo.maxExp;
				DataCenter.Instance.roleSelfVo.roleDyVo.level=sLogin.playerInfo.level;
				DataCenter.Instance.roleSelfVo.diamond=sLogin.playerInfo.diamond;
				DataCenter.Instance.roleSelfVo.coupon=sLogin.playerInfo.coupon;
				
				trace("游戏币！！！！")
				if(sLogin.playerInfo.silver != 0)
					trace("ModulenewLogin123行，没有银币这个货币！")
//				DataCenter.Instance.roleSelfVo.silver=sLogin.playerInfo.silver;
				DataCenter.Instance.roleSelfVo.note=sLogin.playerInfo.note;
				DataCenter.Instance.roleSelfVo.pkMode=sLogin.playerInfo.fightMode;
				DataCenter.Instance.roleSelfVo.roleDyVo.vipLevel=sLogin.playerInfo.vipLevel;
				DataCenter.Instance.roleSelfVo.roleDyVo.vipType=sLogin.playerInfo.vipType;
				//游戏内部 vip
				DataCenter.Instance.roleSelfVo.roleDyVo.gameVip=sLogin.playerInfo.gameVip

				NewGuideFuncOpenConfig.initConfig(sLogin.playerInfo.funcOpen);
				if(DataCenter.Instance.roleSelfVo.roleDyVo.level>=NewGuideManager.MaxGuideLevel) ///大于新手阶段 所有功能全部开启
				{
					NewGuideFuncOpenConfig.initAllOpen()
				}
				///公会
				CharacterDyManager.Instance.unionName=sLogin.playerInfo.sociaty;
				if(CharacterDyManager.Instance.unionName&&CharacterDyManager.Instance.unionName!="")
					GuildInfoManager.Instence.hasGuild=true;
				else
					GuildInfoManager.Instence.hasGuild=false;
				
				// 活力
				CharacterDyManager.Instance.energy=sLogin.playerInfo.energy;
				// pk值
				CharacterDyManager.Instance.pkValue=sLogin.playerInfo.pkValue;
				// 阅历
				CharacterDyManager.Instance.yueli=sLogin.playerInfo.seeValue;
				///潜力
				CharacterDyManager.Instance.potential=sLogin.playerInfo.potential;
				// 荣誉值
				CharacterDyManager.Instance.honour=sLogin.playerInfo.honour;
				// 称号
//				CharacterDyManager.Instance.title=sLogin.playerInfo.title;
				//设置 时间
				TimeManager.initSeverLoginTime(sLogin.serverTime);
				///设置 聊天服务器登录口令
				DataCenter.Instance.passPort=sLogin.passPort;
				
//				ScenceManager.Instance.enterScence(ScenceInitManager.GameOn);
//				YFEventCenter.Instance.dispatchEventWith(GlobalEvent.GameIn);
				///初始化聊天服务器
				var timeOut:TimeOut=new TimeOut(4000,initChatSocket);
				timeOut.start();
				//				initChatSocket();
				
				RegisterView.Instance.loginCompleteCall();
			}
		}
		/**初始化聊天服务器
		 */		
		private function initChatSocket(obj:Object=null):void
		{
			var chatConnection:ChatConnnection=new ChatConnnection();
			chatConnection.connect();
		}
		
		/** 检测名次的返回  */ 
		private function checkNameCallback(s:SCheckName):void
		{
			if(s.code==RspMsg.RSPMSG_SUCCESS) ///名称可用
			{
				RegisterView.Instance.updateNameCanUse(true);
			}
			else  //名称不可用
			{
				RegisterView.Instance.updateNameCanUse(false);
			}
			DataCenter.Instance.isFresh=true;
		}
		
		public function dispose():void
		{
			YFEventCenter.Instance.removeEventListener(LoginNewEvent.BeginConnectSocket,sendLogin);
			//开始检查名称
			YFEventCenter.Instance.removeEventListener(LoginNewEvent.C_CheckName,onSendSocket);
			RegisterView.Instance.dispose();
		}

	}
}