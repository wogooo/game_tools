package com.YFFramework.game.core.handle
{
	/**@author yefeng
	 *2012-5-14下午11:17:01
	 */
	import com.YFFramework.core.center.abs.handle.AbsHandle;
	import com.YFFramework.core.debug.Log;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.game.core.module.login.events.LoginEvent;
	import com.YFFramework.game.core.module.login.model.proto.CMDLogin;
	import com.YFFramework.game.core.module.login.model.LoginVo;
	
	import flash.utils.ByteArray;
	
	public class HandleLogin extends AbsHandle
	{
		public function HandleLogin()
		{
			super();
			_maxCMD=99;
			_minCMD=50
		}
		
		override public function socketHandle(data:Object):Boolean
		{
			switch(data.cmd)
			{
				case CMDLogin.S_LOGIN:
					var loginVo:LoginVo=new LoginVo();
					loginVo.sex=data.info.sex;
					loginVo.carrer=data.info.carrer;
					loginVo.name=data.info.name;
					loginVo.dyId=data.info.clientId;
					loginVo.level=data.info.level;
					loginVo.clothBasicId=data.info.clothBasicId;
					loginVo.weaponBasicId=data.info.weaponBasicId;

					loginVo.hp=data.info.hp;
					loginVo.maxHp=data.info.maxHp;
					loginVo.exp=data.info.exp;
					loginVo.maxExp=data.info.maxExp;
//					loginVo.mapId=data.info.mapId;
//					loginVo.mapX=data.info.roleDyVo.mapX;
//					loginVo.mapY=data.info.roleDyVo.mapY;

					YFEventCenter.Instance.dispatchEventWith(LoginEvent.S_Login,loginVo);
					return true;
					break;
				
				
				
			}
			return false;
		}
		
		
		
		
	}
}