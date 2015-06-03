package com.YFFramework.game.core.module.onlineReward.controller
{
	import com.CMD.GameCmd;
	import com.YFFramework.core.center.abs.module.AbsModule;
	import com.YFFramework.core.debug.print;
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.core.global.manager.EquipBasicManager;
	import com.YFFramework.game.core.global.manager.PropsBasicManager;
	import com.YFFramework.game.core.global.model.EquipBasicVo;
	import com.YFFramework.game.core.global.model.PropsBasicVo;
	import com.YFFramework.game.core.global.util.UIPositionUtil;
	import com.YFFramework.game.core.global.view.ui.MoveIconsView;
	import com.YFFramework.game.core.module.activity.manager.ActiveRewardBasicManager;
	import com.YFFramework.game.core.module.activity.model.ActiveRewardBasicVo;
	import com.YFFramework.game.core.module.notice.manager.NoticeManager;
	import com.YFFramework.game.core.module.notice.model.NoticeType;
	import com.YFFramework.game.core.module.onlineReward.event.OnlineRewardEvent;
	import com.YFFramework.game.core.module.onlineReward.manager.OnlineRewardBasicManager;
	import com.YFFramework.game.core.module.onlineReward.model.OnlineRewardBasicVo;
	import com.YFFramework.game.core.module.onlineReward.view.OnlineRewardCtrl;
	import com.YFFramework.game.core.module.systemReward.data.RewardIconType;
	import com.YFFramework.game.core.module.task.enum.RewardTypes;
	import com.YFFramework.game.gameConfig.URLTool;
	import com.msg.enumdef.RspMsg;
	import com.msg.online_reward.CCanReceiveOlRewardReq;
	import com.msg.online_reward.CCurRewardReq;
	import com.msg.online_reward.CGiveOlRewardReq;
	import com.msg.online_reward.SCanReceiveOlRewardRsp;
	import com.msg.online_reward.SCurRewardRsp;
	import com.msg.online_reward.SGiveOlRewardRsp;
	import com.msg.online_reward.SResetOlRewardRsp;
	import com.net.MsgPool;
	
	import flash.display.MovieClip;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	/***
	 *
	 *@author ludingchang 时间：2013-9-11 上午10:30:04
	 */
	public class ModuleOnlineReward extends AbsModule
	{
		private var _onlineRewardCtrl:OnlineRewardCtrl;
		private var _timer:Timer;
		private var _clicking:Boolean=false;//是否是用户点击发送的请求
		public function ModuleOnlineReward()
		{
			super();
		}
		override public function init():void
		{
			addEvent();
			addSocketevent();
			_timer=new Timer(1000);
			_timer.addEventListener(TimerEvent.TIMER,updateTime);
			_timer.addEventListener(TimerEvent.TIMER_COMPLETE,onTimeComp);
			var msg:CCurRewardReq=new CCurRewardReq;
			MsgPool.sendGameMsg(GameCmd.CCurRewardReq,msg);
		}
		
		protected function updateTime(event:TimerEvent):void
		{
			OnlineRewardBasicManager.Instance.remainTime--;
			_onlineRewardCtrl.update();
		}
		
		protected function onTimeComp(event:TimerEvent):void
		{
			_timer.reset();
			askCanReceive();
		}
		
		/**请求是否可以领取*/
		private function askCanReceive():void
		{
			var msg:CCanReceiveOlRewardReq=new CCanReceiveOlRewardReq;
			MsgPool.sendGameMsg(GameCmd.CCanReceiveOlRewardReq,msg);
		}
		
		/**开始下一个计时,接受到领取成功后调用*/
		private function goTimer():void
		{
			var vo:OnlineRewardBasicVo=OnlineRewardBasicManager.Instance.getNextOnlineRewardBasicVo();
			if(vo)
			{
				var nextTime:int=vo.time*60;
				_timer.repeatCount=nextTime;
				OnlineRewardBasicManager.Instance.remainTime=nextTime;
				_timer.start();
				_onlineRewardCtrl.show();
			}
		}
		
		private function addEvent():void
		{
			YFEventCenter.Instance.addEventListener(GlobalEvent.OnlineRewardInit,initUI);//初始化UI
			YFEventCenter.Instance.addEventListener(OnlineRewardEvent.GetOnlineReward,getOnlineReward);//用户点击领取按钮
		}
		
		/**领取在线奖励*/
		private function getOnlineReward(e:YFEvent):void
		{
			_clicking=true;
			askCanReceive();//领取前先验证
		}
		
		private function sendGetMsg():void
		{
			// TODO 向服务器发送领取奖励的消息
			var msg:CGiveOlRewardReq=new CGiveOlRewardReq;
			msg.id=OnlineRewardBasicManager.Instance.getCurrentOnlineRewardBasicVo().id;
			MsgPool.sendGameMsg(GameCmd.CGiveOlRewardReq,msg);
		}
		
		private function initUI(e:YFEvent):void
		{
			// TODO 初始化UI，
			_onlineRewardCtrl=new OnlineRewardCtrl(e.param as MovieClip);
			
		}
		
		private function addSocketevent():void
		{
			MsgPool.addCallBack(GameCmd.SCurRewardRsp,SCurRewardRsp,reScurRewardRsp);//查询状态
			MsgPool.addCallBack(GameCmd.SCanReceiveOlRewardRsp,SCanReceiveOlRewardRsp,reScanReceiveOlRewardRsp);//修改状态
			MsgPool.addCallBack(GameCmd.SGiveOlRewardRsp,SGiveOlRewardRsp,reSGiveOlRewardRsp);//领取
			MsgPool.addCallBack(GameCmd.SResetOlRewardRsp,SResetOlRewardRsp,reSresetOlRewardRsp);//重置
		}
		
		private function reSresetOlRewardRsp(msg:SResetOlRewardRsp):void
		{
			if(msg.flag==RspMsg.RSPMSG_SUCCESS)
			{
				print("在线奖励时间重置成功");
				OnlineRewardBasicManager.Instance.current_index=1;
				startCurrentTimer();
			}
			else
				print("在线奖励时间重置失败");
			
		}
		
		private function reSGiveOlRewardRsp(msg:SGiveOlRewardRsp):void
		{
			if(msg.flag==RspMsg.RSPMSG_SUCCESS)
			{
				NoticeManager.setNotice(NoticeType.Notice_id_1901);
				var rewardID:int=OnlineRewardBasicManager.Instance.getCurrentOnlineRewardBasicVo().reward_id;
				var rewardVos:Vector.<ActiveRewardBasicVo>=ActiveRewardBasicManager.Instance.getActive_rewardBasicVo(rewardID);
				var moveIcons:MoveIconsView=new MoveIconsView;
				for(var i:int=rewardVos.length-1;i>=0;i--)
				{
					var reVo:ActiveRewardBasicVo=rewardVos[i];
					switch(reVo.reward_type)
					{
						case RewardTypes.EQUIP:
							var eqVo:EquipBasicVo=EquipBasicManager.Instance.getEquipBasicVo(reVo.reward_id);
							moveIcons.add(URLTool.getGoodsIcon(eqVo.icon_id));
							break;
						case RewardTypes.PROPS:
							var ppVo:PropsBasicVo=PropsBasicManager.Instance.getPropsBasicVo(reVo.reward_id);
							moveIcons.add(URLTool.getGoodsIcon(ppVo.icon_id));
							break;
						default:
							moveIcons.add(URLTool.getGoodsIcon(RewardIconType.getIconByReWardType(reVo.reward_type)));
							break;
					}
				}
				moveIcons.moveToBag(_onlineRewardCtrl.getPostion());
				if(OnlineRewardBasicManager.Instance.isLastOne)
				{
					_onlineRewardCtrl.hide();
				}
				else
					goTimer();
			}
			else
//				if(msg.flag==RspMsg.RSPMSG_PACK_FULL || msg.flag==RspMsg.RSPMSG_PACKAGE_FULL)//背包已满，领取失败
				NoticeManager.setNotice(NoticeType.Notice_id_1900);
		}
		
		private function reScanReceiveOlRewardRsp(msg:SCanReceiveOlRewardRsp):void
		{
			if(msg.flag==0)//不可领取
			{
				print("在线礼包==客户端时间快于服务端时间，不可领取");
			}
			else//可领取
			{
				print("在线礼包==可领取");
				if(_clicking)
				{
					sendGetMsg();
				}
				else
				{
					_onlineRewardCtrl.showEff();
				}
			}
			_clicking=false;
		}
		
		private function reScurRewardRsp(msg:SCurRewardRsp):void
		{
			OnlineRewardBasicManager.Instance.current_index=msg.id;
			if(msg.flag==0)//不能领取
			{
				startCurrentTimer();
			}
			else
			{
				OnlineRewardBasicManager.Instance.remainTime=0;
				_onlineRewardCtrl.update();
				_onlineRewardCtrl.showEff();
			}
		}
		/**开始本轮计时*/
		private function startCurrentTimer():void
		{
			var vo:OnlineRewardBasicVo=OnlineRewardBasicManager.Instance.getCurrentOnlineRewardBasicVo();
			if(vo)
			{
				var nextTime:int=vo.time*60;
				_timer.repeatCount=nextTime;
				OnlineRewardBasicManager.Instance.remainTime=nextTime;
				_timer.reset();
				_timer.start();
				_onlineRewardCtrl.show();
			}
			else//vo不存在表示已经没有可领取在线奖励
			{
				_timer.stop();
				_onlineRewardCtrl.hide();
			}
		}
	}
}