package com.YFFramework.game.core.module.pk.controller
{
	/**@author yefeng
	 * 2013 2013-5-6 下午3:53:01 
	 */
	import com.CMD.GameCmd;
	import com.YFFramework.core.center.abs.module.AbsModule;
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.utils.net.SourceCache;
	import com.YFFramework.game.core.global.DataCenter;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.core.global.manager.CommonEffectURLManager;
	import com.YFFramework.game.core.global.util.NoticeUtil;
	import com.YFFramework.game.core.module.gameView.view.EjectBtnView;
	import com.YFFramework.game.core.module.mapScence.manager.RoleDyManager;
	import com.YFFramework.game.core.module.pk.event.PKEvent;
	import com.YFFramework.game.core.module.pk.manager.CompeteDyManager;
	import com.YFFramework.game.core.module.pk.view.CompeteView;
	import com.YFFramework.game.core.module.system.data.SystemConfigManager;
	import com.YFFramework.game.core.scence.TypeScence;
	import com.msg.enumdef.RspMsg;
	import com.msg.hero.CAcceptCompete;
	import com.msg.hero.CCompeteReq;
	import com.msg.hero.SAcceptCompete;
	import com.msg.hero.SAcceptCompeteResp;
	import com.msg.hero.SOtherRoleCompeteReq;
	import com.net.MsgPool;
	
	public class ModulePK extends AbsModule
	{
		
		private var _competeView:CompeteView;
		public function ModulePK()
		{
			super();
			_belongScence=TypeScence.ScenceGameOn;
			_competeView=new CompeteView();

		}
		override public function init():void
		{
			addEvents();
			addSocketCallBack();
		}
		private function addEvents():void
		{
			///请求切磋
			YFEventCenter.Instance.addEventListener(GlobalEvent.C_RequestCompete,onSendSocket);
			
			YFEventCenter.Instance.addEventListener(PKEvent.C_AcceptCompete,onSendSocket);
			
			//处理 UI界面的打开
			YFEventCenter.Instance.addEventListener(GlobalEvent.CompeteUIClick,onSendSocket);
		}
		private function addSocketCallBack():void
		{
			///请求切磋
			MsgPool.addCallBack(GameCmd.SOtherRoleCompeteReq,SOtherRoleCompeteReq,onSOtherRoleCompeteReq);
			///同意切磋返回
			MsgPool.addCallBack(GameCmd.SAcceptCompeteResp,SAcceptCompeteResp,onSAcceptCompeteResp);
			//同意切磋 返回给邀请者
			MsgPool.addCallBack(GameCmd.SAcceptCompete,SAcceptCompete,onSAcceptCompete);
			
		}
		/**加载 切磋特效
		 */		
		private function loadCompeteRes():void
		{
			SourceCache.Instance.loadRes(CommonEffectURLManager.CompetingEffect);
			SourceCache.Instance.loadRes(CommonEffectURLManager.CompeteWinEffect);
		}
		/**请求pk送达给其他玩家
		 */
		private function onSOtherRoleCompeteReq(sOtherRoleCompeteReq:SOtherRoleCompeteReq):void
		{
			if(!SystemConfigManager.rejectPK) // 不  拒绝PK 
			{
				CompeteDyManager.Instance.addCompeteRole(sOtherRoleCompeteReq.otherId);
				YFEventCenter.Instance.dispatchEventWith(GlobalEvent.DisplayBtn,EjectBtnView.RequestCompete);
				loadCompeteRes();
			}
		}
		/**同意切磋返回 给同意者
		 */
		private function onSAcceptCompeteResp(sAcceptCompeteResp:SAcceptCompeteResp):void
		{
			switch(sAcceptCompeteResp.code)
			{
				case RspMsg.RSPMSG_SUCCESS:
					NoticeUtil.setOperatorNotice("切磋成功");
					RoleDyManager.Instance.updateRoleCompete(sAcceptCompeteResp.otherId,DataCenter.Instance.roleSelfVo.roleDyVo.dyId);
					DataCenter.Instance.roleSelfVo.roleDyVo.competeId=sAcceptCompeteResp.otherId;
					noticeAddCompetingEffect();
					break;
				case RspMsg.RSPMSG_FAIL:
					NoticeUtil.setOperatorNotice("切磋失败");
					break;
				case RspMsg.RSPMSG_COMPETE_OFFLINE:
					NoticeUtil.setOperatorNotice("切磋玩家已经离线");
					break;

				case RspMsg.RSPMSG_COMPET_OUT_RANGE:
					NoticeUtil.setOperatorNotice("切磋玩家不在范围内");
					break;
			}
			loadCompeteRes();
					
		}
		/**同意切磋 返回给邀请者
		 */
		private function onSAcceptCompete(sAcceptCompete:SAcceptCompete):void
		{
			///显示  图标  
			NoticeUtil.setOperatorNotice("同意切磋");
			RoleDyManager.Instance.updateRoleCompete(sAcceptCompete.otherId,DataCenter.Instance.roleSelfVo.roleDyVo.dyId);
			DataCenter.Instance.roleSelfVo.roleDyVo.competeId=sAcceptCompete.otherId;
			noticeAddCompetingEffect();
		}
		/**开始切磋 添加切磋特特效
		 */
		private function noticeAddCompetingEffect():void
		{
			YFEventCenter.Instance.dispatchEventWith(GlobalEvent.BeginCompeting);
		}
		
		private function onSendSocket(e:YFEvent):void
		{
			var data:Object=e.param;
			var dyId:int;
			switch(e.type)		
			{
				case GlobalEvent.C_RequestCompete: ///请求切磋
					if(DataCenter.Instance.roleSelfVo.roleDyVo.competeId<=0)
					{
						dyId=data.dyId;
						if(RoleDyManager.Instance.getRole(dyId)!=null) //在字节的九宫格内的玩家才能进行切磋
						{
							var cCompeteReq:CCompeteReq=new CCompeteReq();
							cCompeteReq.otherId=dyId;
							MsgPool.sendGameMsg(GameCmd.CCompeteReq,cCompeteReq);
							NoticeUtil.setOperatorNotice("请求与"+data.name+"进行切磋.");
						}
						else NoticeUtil.setOperatorNotice("对方距离太远，无法切磋");
					}
					else 	NoticeUtil.setOperatorNotice("你已在切磋状态中");
					break;
				case PKEvent.C_AcceptCompete://同意切磋
					var cAcceptCompete:CAcceptCompete=new CAcceptCompete();
					cAcceptCompete.otherId=int(data);
					MsgPool.sendGameMsg(GameCmd.CAcceptCompete,cAcceptCompete);
					break;
				case GlobalEvent.CompeteUIClick:
					_competeView.updateView();
					YFEventCenter.Instance.dispatchEventWith(GlobalEvent.RemoveEjectBtn,EjectBtnView.RequestCompete);
					break;
			}
		}	
	}
}