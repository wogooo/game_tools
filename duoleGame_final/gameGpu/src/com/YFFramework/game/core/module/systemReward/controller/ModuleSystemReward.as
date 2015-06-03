package com.YFFramework.game.core.module.systemReward.controller
{
	import com.CMD.GameCmd;
	import com.YFFramework.core.center.abs.module.AbsModule;
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.core.module.notice.manager.NoticeManager;
	import com.YFFramework.game.core.module.notice.model.NoticeType;
	import com.YFFramework.game.core.module.systemReward.event.SystemRewardEvent;
	import com.YFFramework.game.core.module.systemReward.manager.SystemRewardManager;
	import com.YFFramework.game.core.module.systemReward.view.SystemRewardWindow;
	import com.YFFramework.game.core.scence.TypeScence;
	import com.msg.enumdef.RspMsg;
	import com.msg.rewardsystem.CAllClickReward;
	import com.msg.rewardsystem.COneClickReward;
	import com.msg.rewardsystem.CRewardSysReq;
	import com.msg.rewardsystem.SAddRewardInfo;
	import com.msg.rewardsystem.SAllClickReward;
	import com.msg.rewardsystem.SOneClickReward;
	import com.msg.rewardsystem.SRewardSysRsp;
	import com.net.MsgPool;

	/***
	 *系统奖励控制类
	 *@author ludingchang 时间：2013-9-4 上午10:34:11
	 */
	public class ModuleSystemReward extends AbsModule
	{

		private var _systemRewardWindow:SystemRewardWindow;
		public function ModuleSystemReward()
		{
			super();
			_belongScence=TypeScence.ScenceGameOn;
			_systemRewardWindow=new SystemRewardWindow;

		}
		
		override public function init():void
		{
			addEvents();
			addSocketEvent();
			var msg:CRewardSysReq=new CRewardSysReq;
			MsgPool.sendGameMsg(GameCmd.CRewardSysReq,msg);
		}
		
		private function addEvents():void
		{
			// TODO 添加事件侦听
			YFEventCenter.Instance.addEventListener(GlobalEvent.SystemRewardUIClick,onUIClick);//开关
			
			YFEventCenter.Instance.addEventListener(SystemRewardEvent.UpdateInfo,onUpdateInfo);//更新右边的奖励内容UI
			YFEventCenter.Instance.addEventListener(SystemRewardEvent.GetOne,onGetOne);//领取一个礼包
			YFEventCenter.Instance.addEventListener(SystemRewardEvent.GetAll,onGetAll);//一键领取所有礼包
		}
		
		private function onUpdateInfo(e:YFEvent):void
		{
			// TODO 更新右边内容奖励
			_systemRewardWindow.updateInfo();
		}
		
		private function onGetOne(e:YFEvent):void
		{
			// TODO 取选中礼包的信息，发送礼包请求
			if(SystemRewardManager.Instence.checkBagNumber())//判断背包格子是否足够
			{
				var msg:COneClickReward=new COneClickReward;
				msg.rsId=SystemRewardManager.Instence.current.id;
				MsgPool.sendGameMsg(GameCmd.COneClickReward,msg);
			}
			else 
				NoticeManager.setNotice(NoticeType.Notice_id_1900);
		}
		
		private function onGetAll(e:YFEvent):void
		{
			// TODO 发送请求一键领取的协议消息
			if(SystemRewardManager.Instence.checkBagAll())//判断背包格子是否足够
			{
				var msg:CAllClickReward=new CAllClickReward;
				MsgPool.sendGameMsg(GameCmd.CAllClickReward,msg);
			}
			else
			{
				NoticeManager.setNotice(NoticeType.Notice_id_302);//背包已满
				NoticeManager.setNotice(NoticeType.Notice_id_1900);//领取失败
			}
		}
		
		private function onUIClick(e:YFEvent):void
		{
			// TODO 开\关窗口
			_systemRewardWindow.switchOpenClose();
		}
		
		private function addSocketEvent():void
		{
			// TODO 添加服务器事件侦听
			MsgPool.addCallBack(GameCmd.SOneClickReward,SOneClickReward,reOneClickReward);//单个领取返回
			MsgPool.addCallBack(GameCmd.SAllClickReward,SAllClickReward,reAllClickReward);//一键领取返回
			MsgPool.addCallBack(GameCmd.SRewardSysRsp,SRewardSysRsp,reSRewardSysRsp);//收到奖励信息
			MsgPool.addCallBack(GameCmd.SAddRewardInfo,SAddRewardInfo,reSAddRewardInfo);//收到添加奖励信息
		}
		
		private function reSAddRewardInfo(msg:SAddRewardInfo):void
		{
			// TODO 添加数据，更新UI,显示按钮
			SystemRewardManager.Instence.addData(msg.rewardInfo);
			
			_systemRewardWindow.update();
			YFEventCenter.Instance.dispatchEventWith(GlobalEvent.SystemRewardBtnShow);
		}
		
		private function reSRewardSysRsp(msg:SRewardSysRsp):void
		{ 
			// TODO 设置数据，更新UI，显示按钮
			if(msg&&msg.rewardInfo)
			{
				SystemRewardManager.Instence.setPackagesData(msg.rewardInfo);
				YFEventCenter.Instance.dispatchEventWith(GlobalEvent.SystemRewardBtnShow);
			}
			else
				SystemRewardManager.Instence.setPackagesData([]);
			_systemRewardWindow.update();
		}
		
		private function reAllClickReward(msg:SAllClickReward):void
		{
			// TODO 如果成功，关闭界面，隐藏按钮，清空数据，否则什么都不做
			if(msg.code==RspMsg.RSPMSG_SUCCESS)
			{
				_systemRewardWindow.close();
				YFEventCenter.Instance.dispatchEventWith(GlobalEvent.SystemRewardBtnHide);
				SystemRewardManager.Instence.clearData();
				NoticeManager.setNotice(NoticeType.Notice_id_1901);
				SystemRewardManager.Instence.current=null;
			}
			else
				NoticeManager.setNotice(NoticeType.Notice_id_1900);
		}
		
		private function reOneClickReward(msg:SOneClickReward):void
		{
			// TODO 如果成功，减掉对应的数据，刷新界面
			if(msg.rsId!=-1)
			{
				
				SystemRewardManager.Instence.removeData(msg.rsId);
				if(SystemRewardManager.Instence.packages.length>0)// 还有礼包
				{
					SystemRewardManager.Instence.current=SystemRewardManager.Instence.packages[0];
					_systemRewardWindow.update();
				}
					
				else//没有礼包了
				{
					_systemRewardWindow.close();
					SystemRewardManager.Instence.current=null;
					YFEventCenter.Instance.dispatchEventWith(GlobalEvent.SystemRewardBtnHide);
				}
				NoticeManager.setNotice(NoticeType.Notice_id_1901);
			}
			else
				NoticeManager.setNotice(NoticeType.Notice_id_1900);
		}
	}
}