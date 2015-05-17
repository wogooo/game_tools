package com.YFFramework.game.core.module.login.controller
{
	import com.CMD.GameCmd;
	import com.YFFramework.core.center.abs.module.AbsModule;
	import com.YFFramework.core.center.manager.ScenceManager;
	import com.YFFramework.core.debug.print;
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.world.model.RoleDyVo;
	import com.YFFramework.core.world.model.type.TypeRole;
	import com.YFFramework.game.core.global.DataCenter;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.core.global.manager.CharacterDyManager;
	import com.YFFramework.game.core.module.login.events.LoginEvent;
	import com.YFFramework.game.core.module.login.view.LoginView;
	import com.YFFramework.game.core.scence.ScenceInitManager;
	import com.YFFramework.game.core.scence.TypeScence;
	import com.msg.enumdef.RspMsg;
	import com.msg.login.CCheckName;
	import com.msg.login.CCreateHeroInfo;
	import com.msg.login.CLogin;
	import com.msg.login.SCheckName;
	import com.msg.login.SLogin;
	import com.net.MsgPool;
	import com.net.NetManager;
	
	/**2012-8-2 下午12:43:29
	 *@author yefeng
	 */
	public class ModuleLogin extends AbsModule
	{
		private var _loginView:LoginView;
		public function ModuleLogin()
		{
			super();
			_belongScence=TypeScence.ScenceLogin;
		}
		override public function init():void
		{
			addEvents();
			addSocketCallback();
			initUI();
		}
		
		private function initUI():void
		{
			_loginView=new LoginView();
			_loginView.popUp();
			_loginView.centerWindow();
		}
		private function addEvents():void
		{
			//发送socket 数据
			//开始登录
			YFEventCenter.Instance.addEventListener(LoginEvent.C_CheckLogin,onSendSocket);
			///创建角色
			YFEventCenter.Instance.addEventListener(LoginEvent.C_CreateHero,onSendSocket);
			/**检测名称
			 */ 
			YFEventCenter.Instance.addEventListener(LoginEvent.C_CheckName,onSendSocket);

			
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
			if(sLogin.code==RspMsg.RSPMSG_FAIL)_loginView.showCreateHeroUI();
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
//				DataCenter.Instance.roleSelfVo.maxExp=sLogin.playerInfo.maxExp;
				DataCenter.Instance.roleSelfVo.roleDyVo.level=sLogin.playerInfo.level;
				DataCenter.Instance.roleSelfVo.roleDyVo=roledyVo;
				DataCenter.Instance.roleSelfVo.diamond=sLogin.playerInfo.diamond;
				DataCenter.Instance.roleSelfVo.coupon=sLogin.playerInfo.coupon;
				DataCenter.Instance.roleSelfVo.silver=sLogin.playerInfo.silver;
				DataCenter.Instance.roleSelfVo.note=sLogin.playerInfo.note;
				
				///公会
				CharacterDyManager.Instance.unionName=sLogin.playerInfo.sociaty;
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
				CharacterDyManager.Instance.title=sLogin.playerInfo.title;
					
				
				
				
				ScenceManager.Instance.enterScence(ScenceInitManager.GameOn);
				YFEventCenter.Instance.dispatchEventWith(GlobalEvent.GameIn);
				
//				YFEventCenter.Instance.
				
			}
		}
		/**检测名次的返回
		 */ 
		private function checkNameCallback(s:SCheckName):void
		{
			if(s.code==RspMsg.RSPMSG_SUCCESS) ///名称可用
			{
				_loginView._createHeroUI.updateNameCanUse(true);
			}
			else  //名称不可用
			{
				_loginView._createHeroUI.updateNameCanUse(false);
			}
		}
		
		override public function dispose():void
		{
			super.dispose();
			_loginView.dispose();
			_loginView=null;
		}
		/**发送socket 数据
		 */		
		private function onSendSocket(e:YFEvent):void
		{
			var data:Object=e.param;
			switch(e.type)
			{
				case LoginEvent.C_CheckLogin: ///开始登录游戏
					var str:String=data.toString();
					var cLogin:CLogin=new CLogin();
					print(this,"网站id:"+str);
					cLogin.countId=str;
					MsgPool.sendGameMsg(GameCmd.CLogin,cLogin);				
					break;
				case LoginEvent.C_CreateHero:  ///创建角色
					var cCreateHeroInfo:CCreateHeroInfo=new CCreateHeroInfo();
					cCreateHeroInfo.sex=data.sex;
					cCreateHeroInfo.name=data.name;
					MsgPool.sendGameMsg(GameCmd.CCreateHeroInfo,cCreateHeroInfo);
					break;
				case LoginEvent.C_CheckName: //检测名称
					var checkName:String=data.toString();
					print(this,"checkName:"+checkName);
					var cCheckName:CCheckName=new CCheckName();
					cCheckName.name=checkName;
					MsgPool.sendGameMsg(GameCmd.CCheckName,cCheckName);
					break;
			}
		}
		/**接受socket 返回回来的数据
		 */		
		private function onRevSocket(e:YFEvent):void
		{
			switch(e.type)
			{
			}
		}

	}
}