package com.YFFramework.game.core.module.DivinePulses.controller
{
	import com.CMD.GameCmd;
	import com.YFFramework.core.center.abs.module.AbsModule;
	import com.YFFramework.core.debug.print;
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.core.module.DivinePulses.event.DivinePulseEvent;
	import com.YFFramework.game.core.module.DivinePulses.manager.DivinePulseManager;
	import com.YFFramework.game.core.module.DivinePulses.manager.Divine_pulseBasicManager;
	import com.YFFramework.game.core.module.DivinePulses.model.Divine_pulseBasicVo;
	import com.YFFramework.game.core.module.DivinePulses.view.DivinePulseWindow;
	import com.YFFramework.game.core.module.notice.manager.NoticeManager;
	import com.YFFramework.game.core.module.notice.model.NoticeType;
	import com.msg.divine_pulse_pro.CDivinePulseInfoReq;
	import com.msg.divine_pulse_pro.SDivinePulseInfoRsp;
	import com.msg.divine_pulse_pro.SDivinePulseRsp;
	import com.msg.enumdef.RspMsg;
	import com.net.MsgPool;
	
	/***
	 *天命神脉
	 *@author ludingchang 时间：2013-11-12 下午12:03:14
	 */
	public class ModuleDivinePulse extends AbsModule
	{
		private var _divinePulseWind:DivinePulseWindow;
		public function ModuleDivinePulse()
		{
			super();
			_divinePulseWind=new DivinePulseWindow;

		}
		override public function init():void
		{
			addEvent();
			addSocketEvent();
		}
		
		private function addSocketEvent():void
		{
			// TODO 接受网络消息
			MsgPool.addCallBack(GameCmd.SUpdateDivinePulseRsp,SDivinePulseRsp,reDivinePulse);
			MsgPool.addCallBack(GameCmd.SDivinePulseInfoRsp,SDivinePulseInfoRsp,reDivineInfo);
		}
		
		private function reDivineInfo(msg:SDivinePulseInfoRsp):void
		{
			DivinePulseManager.Instence.learnedPulse(msg.gold);
			DivinePulseManager.Instence.learnedPulse(msg.wood);
			DivinePulseManager.Instence.learnedPulse(msg.water);
			DivinePulseManager.Instence.learnedPulse(msg.fire);
			DivinePulseManager.Instence.learnedPulse(msg.earth);
			DivinePulseManager.Instence.learnedPulse(msg.light);
			DivinePulseManager.Instence.learnedPulse(msg.dark);
			DivinePulseManager.Instence.updateCurrentSelected();
		}
		
		private function reDivinePulse(msg:SDivinePulseRsp):void
		{
			if(msg.rsp==RspMsg.RSPMSG_SUCCESS)
			{
				DivinePulseManager.Instence.learnedPulse(msg.divinePulseId);
				DivinePulseManager.Instence.updateCurrentSelected();
				_divinePulseWind.update();
			}
			else
			{
				print(this,msg);
				var vo:Divine_pulseBasicVo=Divine_pulseBasicManager.Instance.getDivinePulseVoById(msg.divinePulseId);
				NoticeManager.setNotice(NoticeType.Notice_id_2100,-1,vo.name,vo.lv);
			}
		}
		
		private function addEvent():void
		{
			// TODO 接受本地消息
			YFEventCenter.Instance.addEventListener(GlobalEvent.DivinePulseClick,onUIClick);
			YFEventCenter.Instance.addEventListener(DivinePulseEvent.DivinePulseUpdate,updateView);
			YFEventCenter.Instance.addEventListener(GlobalEvent.GameIn,onGameIn);
			
			YFEventCenter.Instance.addEventListener(GlobalEvent.BagChange,updateView);
			YFEventCenter.Instance.addEventListener(GlobalEvent.MoneyChange,updateView);
		}
		
		private function onGameIn(e:YFEvent):void
		{
			YFEventCenter.Instance.removeEventListener(GlobalEvent.GameIn,onGameIn);
			// 发送请求数据协议
			var msg:CDivinePulseInfoReq=new CDivinePulseInfoReq;
			MsgPool.sendGameMsg(GameCmd.CDivinePulseInfoReq,msg);
		}
		
		private function updateView(e:YFEvent):void
		{
			_divinePulseWind.update();
		}
		
		private function onUIClick(e:YFEvent):void
		{
			// TODO 开关界面
			_divinePulseWind.switchOpenClose();
		}
	}
}