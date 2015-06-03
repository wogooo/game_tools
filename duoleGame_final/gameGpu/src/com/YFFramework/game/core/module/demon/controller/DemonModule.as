package com.YFFramework.game.core.module.demon.controller
{
	import com.CMD.GameCmd;
	import com.YFFramework.core.center.abs.module.AbsModule;
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.module.AnswerActivity.dataCenter.ActivityBasicManager;
	import com.YFFramework.game.core.module.demon.event.DemonEvent;
	import com.YFFramework.game.core.module.demon.manager.DemonManager;
	import com.YFFramework.game.core.module.demon.model.DemonSkillType;
	import com.YFFramework.game.core.module.demon.view.DemonMiniWindow;
	import com.YFFramework.game.core.module.demon.view.DemonSkillIconConainer;
	import com.YFFramework.game.core.module.demon.view.DemonWindow;
	import com.YFFramework.game.core.module.raid.manager.RaidManager;
	import com.YFFramework.game.core.module.task.view.TaskMiniPanel;
	import com.msg.actv.CDemonInvadeLevel;
	import com.msg.actv.CSignActivity;
	import com.msg.actv.SDemonInvadeLevel;
	import com.msg.actv.SFinishWave;
	import com.msg.actv.SGodessID;
	import com.msg.actv.SSignActivity;
	import com.msg.raid_pro.CEnterRaid;
	import com.net.MsgPool;

	/**
	 * @version 1.0.0
	 * creation time：2013-10-10 上午10:33:46
	 */
	public class DemonModule extends AbsModule{
		
		private var _demonSkillView:DemonSkillIconConainer;
		public function DemonModule(){
		}
		
		override public function init():void{
			addEvents();
			addSocketCallback();
		}
	
		private function addEvents():void{
			YFEventCenter.Instance.addEventListener(GlobalEvent.GameIn,onGameIn);					//进入游戏
			YFEventCenter.Instance.addEventListener(GlobalEvent.DemonUIClick,onDemonUIClick);		//请求魔族入侵信息
			YFEventCenter.Instance.addEventListener(DemonEvent.SignRaidActivity,signRaidActivity);	// 报名
			YFEventCenter.Instance.addEventListener(GlobalEvent.JoinedActivity,onSignActivity);		// 报名回复
			
			//成功进入魔神入侵副本
			YFEventCenter.Instance.addEventListener(DemonEvent.DemonRaid,onEnterDemonRaid);			//进入魔族入侵
			YFEventCenter.Instance.addEventListener(GlobalEvent.EnterDifferentMap,onEnterDifMap);	//进入不同的地图
			YFEventCenter.Instance.addEventListener(GlobalEvent.RoleInfoChange,onRoleInfoChange);	//人物属性改变
			
			YFEventCenter.Instance.addEventListener(DemonEvent.UseDaPaoSuccess,onRaidSkillEvent);   //使用魔神大炮
			YFEventCenter.Instance.addEventListener(DemonEvent.UseYueJingSuccess,onRaidSkillEvent); //使用月井
			
			YFEventCenter.Instance.addEventListener(GlobalEvent.ActivityTimesUpdate,onUpdateTimes); //进入次数更新
		}
		
		private function addSocketCallback():void{
			MsgPool.addCallBack(GameCmd.SDemonInvadeLevel,SDemonInvadeLevel,onDemonInvadeLevel);//魔族入侵信息回复
			MsgPool.addCallBack(GameCmd.SGodessID,SGodessID,onSGodessId);						//女神id回复
			MsgPool.addCallBack(GameCmd.SFinishWave,SFinishWave,onFinishWave);					//波数完成回复
		}
		
		/**人物血量改变
		 * @param e
		 */		
		private function onRoleInfoChange(e:YFEvent):void{
			DemonMiniWindow.Instance.updateHp();
		}
		
		/**使用副本成功
		 */
		private function onRaidSkillEvent(e:YFEvent):void{
			switch(e.type){
				case DemonEvent.UseDaPaoSuccess: //使用大炮
					if(_demonSkillView)_demonSkillView.updateContentView(DemonSkillType.DaPao);
					break;
				case DemonEvent.UseYueJingSuccess: //使用月井
					if(_demonSkillView)_demonSkillView.updateContentView(DemonSkillType.YueJing);
					break;
			}
		}
		/**进入不同场景
		 */
		private function onEnterDifMap(e:YFEvent):void
		{
			if(_demonSkillView)_demonSkillView.dispose();
			_demonSkillView=null;
		}
		/** 进入 魔族入侵
		 */
		private function onEnterDemonRaid(e:YFEvent):void{
			if(_demonSkillView)_demonSkillView.dispose();
			_demonSkillView=new DemonSkillIconConainer();
			_demonSkillView.show();
			RaidManager.demonFirstDead=true;
		}
		
		/**完成一波回复
		 * @param msg
		 */		
		private function onFinishWave(msg:SFinishWave):void{
			DemonManager.current_wave = msg.nextWave-1;
			DemonManager.next_wave_seconds=msg.nextWaveSeconds;
			DemonMiniWindow.Instance.updateWave();
			DemonMiniWindow.Instance.visible=true;
			TaskMiniPanel.getInstance().visible=false;
//			if(DemonManager.current_wave>DemonManager.highestLevelReached){
//				DemonManager.highestLevelReached = DemonManager.current_wave;
//				YFEventCenter.Instance.dispatchEventWith(DemonEvent.DemonLevelChange,DemonManager.highestLevelReached);
//			}
		}
		
		/** 女神id回复
		 * @param msg
		 */		
		private function onSGodessId(msg:SGodessID):void{
			DemonManager.goddessDyId = msg.godessId;
		}
		
		/**活动报名回复
		 * @param msg
		 */
		private function onSignActivity(e:YFEvent):void{
			if(int(e.param)==DemonWindow.activityType){
				var msg2:CEnterRaid = new CEnterRaid();
				msg2.raidId=ActivityBasicManager.Instance.getActivityBasicVoByType(DemonWindow.activityType).scene_id;
				msg2.param=DemonWindow.Instance._selectedIndex;
				YFEventCenter.Instance.dispatchEventWith(GlobalEvent.EnterRaidWONPC,msg2);
			}
		}
		
		/**魔族入侵报名
		 * @param e
		 */		
		private function signRaidActivity(e:YFEvent):void{
			MsgPool.sendGameMsg(GameCmd.CSignActivity,e.param as CSignActivity);
		}
		
		/**魔族入侵面板点击
		 * @param e
		 */		
		private function onDemonUIClick(e:YFEvent):void{
			DemonWindow.Instance.switchOpenClose();
			DemonWindow.Instance.updateView();
		}
		
		/** 服务器返回进入次数后，再刷新一次，防止一进入游戏就打开面板造成的数字显示不对 */
		private function onUpdateTimes(e:YFEvent):void
		{
			DemonWindow.Instance.updateView();
		}
		
		/**登陆游戏获取历史最高波数
		 * @param e
		 */		
		private function onGameIn(e:YFEvent):void{
			MsgPool.sendGameMsg(GameCmd.CDemonInvadeLevel,new CDemonInvadeLevel());
		}
		
		/** 魔族入侵历史最高纪录回复
		 * @param msg
		 */		
		private function onDemonInvadeLevel(msg:SDemonInvadeLevel):void{
			DemonWindow.Instance.setMaxTextField(String(msg.maxAccessLevel));
			DemonWindow.Instance.setLevelButtons(msg.maxAccessLevel);
			DemonManager.highestLevelReached = msg.maxAccessLevel;
//			trace("最高波次：",msg.maxAccessLevel)
			YFEventCenter.Instance.dispatchEventWith(DemonEvent.DemonLevelChange,msg.maxAccessLevel);
		}
	}
} 