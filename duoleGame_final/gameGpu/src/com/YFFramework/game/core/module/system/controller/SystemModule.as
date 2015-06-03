package com.YFFramework.game.core.module.system.controller
{
	/**@author yefeng
	 * 2013 2013-4-11 下午5:39:55 
	 */
	import com.CMD.GameCmd;
	import com.YFFramework.core.center.abs.module.AbsModule;
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.game.core.global.DataCenter;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.core.module.system.data.SystemConfigManager;
	import com.YFFramework.game.core.module.system.event.SystemEvent;
	import com.YFFramework.game.core.module.system.view.SystemWindow;
	import com.YFFramework.game.core.scence.TypeScence;
	import com.YFFramework.game.ui.sound.SoundBgManager;
	import com.msg.sys.CSystemConfigRead;
	import com.msg.sys.CSystemConfigSave;
	import com.msg.sys.SSystemConfigRead;
	import com.msg.sys.SystemConfig;
	import com.net.MsgPool;

	/** 游戏系统设定模块
	 */	
	public class SystemModule extends AbsModule
	{
		private var _systemWindow:SystemWindow;
		
		public function SystemModule()
		{
			super();
			_belongScence=TypeScence.ScenceGameOn;
			_systemWindow=new SystemWindow();

		}
		
		override public function init():void
		{
			addEvents();
			addSocketEvent();
		}
		
		/**发送服务器
		 */		
		private function addEvents():void
		{
			YFEventCenter.Instance.addEventListener(GlobalEvent.GameIn,onGameIn);
			YFEventCenter.Instance.addEventListener(GlobalEvent.EnterDifferentMap,enterDifferentMap);//切换场景播放音乐
			YFEventCenter.Instance.addEventListener(GlobalEvent.SystemUIClick,openSystem);//打开关闭界面
			
			YFEventCenter.Instance.addEventListener(SystemEvent.Save,saveSystemConfig);//保存设置
			
			YFEventCenter.Instance.addEventListener(GlobalEvent.BGMMute,bgmControl);
		}
		
		private function addSocketEvent():void
		{
			MsgPool.addCallBack(GameCmd.SSystemConfigRead,SSystemConfigRead,readSystemConfig);
		}
		
		private function onGameIn(e:YFEvent):void
		{
			var msg:CSystemConfigRead=new CSystemConfigRead();
			MsgPool.sendGameMsg(GameCmd.CSystemConfigRead,msg);
		}
		
		private function enterDifferentMap(e:YFEvent=null):void
		{
			SoundBgManager.Instance.initData(DataCenter.Instance.mapSceneBasicVo.soundArr);
			SoundBgManager.Instance.play();
		}
		
		private function openSystem(e:YFEvent):void
		{
			_systemWindow.switchOpenClose();
		}
		
		/**
		 *保存设置 
		 * @param e
		 */		
		private function saveSystemConfig(e:YFEvent=null):void
		{
			var msg:CSystemConfigSave=new CSystemConfigSave();
			msg.config=new SystemConfig();
			msg.config.shieldEff=SystemConfigManager.shieldEff;
			msg.config.shieldHp=SystemConfigManager.shieldHp;
			msg.config.shieldOtherHero=SystemConfigManager.shieldOtherHero;
			msg.config.shieldOtherPet=SystemConfigManager.shieldOtherPet;
			msg.config.notSelectPet=SystemConfigManager.notSelectPet;
			msg.config.showCompare=SystemConfigManager.showCompare;
			msg.config.rejectPk=SystemConfigManager.rejectPK;
			msg.config.rejectTrade=SystemConfigManager.rejectTrade;
			msg.config.rejectTalk=SystemConfigManager.rejectTalk;
			msg.config.rejectFriend=SystemConfigManager.rejectFriend;
			msg.config.rejectTeam=SystemConfigManager.rejectTeam;
			msg.config.rejectGuild=SystemConfigManager.rejectGuild;
			msg.config.showTitle=SystemConfigManager.showTitle;
			msg.config.showItemName=SystemConfigManager.showAllItemName;
			msg.config.enableBgm=SystemConfigManager.enableBGM;
			msg.config.enableSound=SystemConfigManager.enableSound;
			msg.config.bgmValue=SystemConfigManager.BGMValue;
			msg.config.soundValue=SystemConfigManager.soundValue;
			
			MsgPool.sendGameMsg(GameCmd.CSystemConfigSave,msg);
		
			YFEventCenter.Instance.dispatchEventWith(SystemEvent.SystemConfigChange);
			
		}
		
		private function bgmControl(e:YFEvent):void
		{
			saveSystemConfig();
			_systemWindow.updateSetting();
		}
		
		private function readSystemConfig(msg:SSystemConfigRead):void
		{
			SystemConfigManager.shieldEff=msg.config.shieldEff;
			SystemConfigManager.shieldHp=msg.config.shieldHp;
			SystemConfigManager.shieldOtherHero=msg.config.shieldOtherHero;
			SystemConfigManager.shieldOtherPet=msg.config.shieldOtherPet;
			SystemConfigManager.notSelectPet=msg.config.notSelectPet;
			
			SystemConfigManager.rejectFriend=msg.config.rejectFriend;
			SystemConfigManager.rejectGuild=msg.config.rejectGuild;
			SystemConfigManager.rejectPK=msg.config.rejectPk;
			SystemConfigManager.rejectTalk=msg.config.rejectTalk;
			SystemConfigManager.rejectTeam=msg.config.rejectTeam;
			SystemConfigManager.rejectTrade=msg.config.rejectTrade;	
			SystemConfigManager.showCompare=msg.config.showCompare;
			
			SystemConfigManager.showTitle=msg.config.showTitle;
			SystemConfigManager.showAllItemName=msg.config.showItemName;
			
			SystemConfigManager.BGMValue=msg.config.bgmValue;
			SystemConfigManager.enableBGM=msg.config.enableBgm;
			
			SystemConfigManager.enableSound=msg.config.enableSound;
			SystemConfigManager.soundValue=msg.config.soundValue;	
			
			_systemWindow.updateSetting();
			
			YFEventCenter.Instance.dispatchEventWith(GlobalEvent.BGMControl);
			YFEventCenter.Instance.dispatchEventWith(SystemEvent.SystemConfigChange);
		}
		
	}
}