package com.YFFramework.game.core.module.gift.controller
{
	import com.CMD.GameCmd;
	import com.YFFramework.core.center.abs.module.AbsModule;
	import com.YFFramework.core.debug.print;
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.core.module.gift.event.GiftEvent;
	import com.YFFramework.game.core.module.gift.manager.GiftManager;
	import com.YFFramework.game.core.module.gift.model.SignPackageAskVo;
	import com.YFFramework.game.core.module.gift.model.TypeSignPackage;
	import com.YFFramework.game.core.module.gift.view.GiftWindow;
	import com.YFFramework.game.core.module.notice.manager.NoticeManager;
	import com.YFFramework.game.core.module.notice.model.NoticeType;
	import com.msg.enumdef.RspMsg;
	import com.msg.sign_package.CGiveSignPackageReq;
	import com.msg.sign_package.CSignPackageReq;
	import com.msg.sign_package.SGiveSignPackageRsp;
	import com.msg.sign_package.SSendSignDayChange;
	import com.msg.sign_package.SSignPackageRsp;
	import com.net.MsgPool;

	/***
	 *
	 *@author ludingchang 时间：2013-9-10 上午11:43:51
	 */
	public class ModuleGift extends AbsModule
	{

		private var _giftWindow:GiftWindow;
		public function ModuleGift()
		{
			_giftWindow=new GiftWindow();
		}
		override public function init():void
		{
			addEvents();
			addSocketCallback();
			var msg:CSignPackageReq=new CSignPackageReq;
			MsgPool.sendGameMsg(GameCmd.CSignPackageReq,msg);
		}
		
		private function addEvents():void
		{
			// TODO 添加UI的事件接收函数
			YFEventCenter.Instance.addEventListener(GiftEvent.PageAsk,pageAsk);//签到礼包请求
			YFEventCenter.Instance.addEventListener(GlobalEvent.GiftUIClick,onUIclick);//礼包窗口打开
		}
		
		private function onUIclick(e:YFEvent):void
		{
			_giftWindow.switchOpenClose();
		}
		
		private function pageAsk(e:YFEvent):void
		{
			// TODO 将VO转换成消息发送给服务器
			var vo:SignPackageAskVo=e.param as SignPackageAskVo;
			var msg:CGiveSignPackageReq=new CGiveSignPackageReq;
			msg.packageId=vo.package_id;
			MsgPool.sendGameMsg(GameCmd.CGiveSignPackageReq,msg);
		}
		
		private function addSocketCallback():void
		{
			// TODO 添加服务器信息的接收回调函数
			MsgPool.addCallBack(GameCmd.SSignPackageRsp,SSignPackageRsp,onSignPackRsp);//请求新手签到礼包信息
			MsgPool.addCallBack(GameCmd.SGiveSignPackageRsp,SGiveSignPackageRsp,onGiveSignPackageRsp);//领取新手礼包响应
			MsgPool.addCallBack(GameCmd.SSendSignDayChange,SSendSignDayChange,onSignDayChange);//签到礼包可领取改变
		}
		
		private function onSignDayChange(msg:SSendSignDayChange):void
		{
			GiftManager.Instence.newPlayerGiftAdd(msg.signDay);
			_giftWindow.update();
		}
		
		private function onGiveSignPackageRsp(msg:SGiveSignPackageRsp):void
		{
			if(msg.rsp==RspMsg.RSPMSG_SUCCESS)
			{
				NoticeManager.setNotice(NoticeType.Notice_id_1901);
				GiftManager.Instence.setNewPlayerGiftState(msg.packageId,TypeSignPackage.State_HasGet);
				_giftWindow.update();
				_giftWindow.doMoveEff();
			}
			else 
			{
				if(msg.rsp==RspMsg.RSPMSG_PACK_FULL)
					NoticeManager.setNotice(NoticeType.Notice_id_302);
				NoticeManager.setNotice(NoticeType.Notice_id_1900);
			}
		}
		
		private function onSignPackRsp(msg:SSignPackageRsp):void
		{
			GiftManager.Instence.setNewPlayerGift(msg.packageId,msg.signDay);
			YFEventCenter.Instance.dispatchEventWith(GlobalEvent.GiftUiUpdate);
		}
	}
}