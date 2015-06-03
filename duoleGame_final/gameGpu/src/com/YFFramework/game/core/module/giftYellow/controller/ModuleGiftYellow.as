package com.YFFramework.game.core.module.giftYellow.controller
{
	import com.CMD.GameCmd;
	import com.YFFramework.core.center.abs.module.AbsModule;
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.text.RichText;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.core.module.giftYellow.event.GiftYellowEvent;
	import com.YFFramework.game.core.module.giftYellow.manager.YellowAPIManager;
	import com.YFFramework.game.core.module.giftYellow.model.TypeVipGift;
	import com.YFFramework.game.core.module.giftYellow.view.GiftYellowWindow;
	import com.msg.enumdef.RspMsg;
	import com.msg.vip_gift_pack.CGetVipGiftPackReq;
	import com.msg.vip_gift_pack.CVipGiftPackReq;
	import com.msg.vip_gift_pack.SGetVipGiftPackRsp;
	import com.msg.vip_gift_pack.SVipGiftPackRsp;
	import com.net.MsgPool;
	
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	/***
	 *黄钻礼包控制类
	 *@author ludingchang 时间：2013-12-6 下午3:22:25
	 */
	public class ModuleGiftYellow extends AbsModule
	{
		private var _giftYellow:GiftYellowWindow;
		public function ModuleGiftYellow()
		{
			
		}
		override public function init():void
		{
			_giftYellow=new GiftYellowWindow;
			YFEventCenter.Instance.addEventListener(GlobalEvent.GameIn,onGameIn);
			//本地消息
			YFEventCenter.Instance.addEventListener(GlobalEvent.YellowVipUIClick,onUIClick);//游戏主视图右上角按钮点击
			YFEventCenter.Instance.addEventListener(GiftYellowEvent.UpdateIndex,onGiftYellowChangeTab);//更改显示的页面
			YFEventCenter.Instance.addEventListener(GiftYellowEvent.CallOpenAPI,onCallOpenAPI);//调用开通黄钻的API
			YFEventCenter.Instance.addEventListener(GiftYellowEvent.CallOpenYearAPI,onCallOpenYearAPI);//调用开通黄钻的API
			YFEventCenter.Instance.addEventListener(GiftYellowEvent.AskNewPlayerGift,onAskNewPlayerGift);//请求领取黄钻新手礼包
			YFEventCenter.Instance.addEventListener(GiftYellowEvent.AskDayGift,onAskDayGift);//请求领取黄钻每日礼包
			YFEventCenter.Instance.addEventListener(GiftYellowEvent.AskYearDayGift,onAskYearDayGift);//请求领取黄钻每日礼包
			//打开黄沾礼包
			YFEventCenter.Instance.addEventListener(RichText.VipIconClickEvent,onOpenGiftYellow);
			//网络消息
			MsgPool.addCallBack(GameCmd.SVipGiftPackRsp,SVipGiftPackRsp,onVipGiftPackRsp);//返回可领取礼包的信息
			MsgPool.addCallBack(GameCmd.SGetVipGiftPackRsp,SGetVipGiftPackRsp,onGetVipGiftRsp);//领取礼包返回
		}
		/**打开黄钻礼包
		 */
		private function onOpenGiftYellow(e:YFEvent):void
		{
			YFEventCenter.Instance.dispatchEventWith(GiftYellowEvent.UpdateIndex,1);//更改显示的页面
		}
		private function onUIClick(e:YFEvent):void
		{
			_giftYellow.switchOpenClose();
		}
		
		private function onGetVipGiftRsp(msg:SGetVipGiftPackRsp):void
		{
			var type:int=msg.giftPackType;
			if(msg.rsp==RspMsg.RSPMSG_SUCCESS)
			{
				switch(type)
				{
					case TypeVipGift.NEW_PLAYER_GIFT:
						YellowAPIManager.Instence.has_get_new_gift=true;
						break;
					case TypeVipGift.DAY_GIFT:
						YellowAPIManager.Instence.has_get_day_gift=true;
						break;
					case TypeVipGift.YEAR_DAY_GIFT:
						YellowAPIManager.Instence.has_get_year_day_gift=true;
						break;
				}
				_giftYellow.doIconMoveEff(type);
				_giftYellow.update();
				YFEventCenter.Instance.dispatchEventWith(GlobalEvent.YellowVipEffUpdate);
			}
			else
			{
				trace("领取"+TypeVipGift.getVIPGiftName(type)+"失败！");
			}
		}
		
		private function onVipGiftPackRsp(msg:SVipGiftPackRsp):void
		{
			if(!msg)
				return;
			if(msg.hasVipNovicePack)
				YellowAPIManager.Instence.has_get_new_gift=(msg.vipNovicePack==1);
			if(msg.hasVipEverydayPack)
				YellowAPIManager.Instence.has_get_day_gift=(msg.vipEverydayPack==1);
			if(msg.hasVipNoblePack)
				YellowAPIManager.Instence.has_get_year_day_gift=(msg.vipNoblePack==1);
			YFEventCenter.Instance.dispatchEventWith(GlobalEvent.YellowVipEffUpdate);
		}
		
		private function onGameIn(e:YFEvent):void
		{
			YFEventCenter.Instance.removeEventListener(GlobalEvent.GameIn,onGameIn);
			
			var msg:CVipGiftPackReq=new CVipGiftPackReq;
			MsgPool.sendGameMsg(GameCmd.CVipGiftPackReq,msg);
		}
		
		private function onAskYearDayGift(e:YFEvent):void
		{
			// 发送领取年费黄钻每日礼包的消息
			var msg:CGetVipGiftPackReq=new CGetVipGiftPackReq;
			msg.giftPackType=TypeVipGift.YEAR_DAY_GIFT;
			MsgPool.sendGameMsg(GameCmd.CGetVipGiftPackReq,msg);
		}
		
		private function onAskDayGift(e:YFEvent):void
		{
			// 发送领取普通黄钻每日礼包的消息
			var msg:CGetVipGiftPackReq=new CGetVipGiftPackReq;
			msg.giftPackType=TypeVipGift.DAY_GIFT;
			MsgPool.sendGameMsg(GameCmd.CGetVipGiftPackReq,msg);
		}
		
		private function onAskNewPlayerGift(e:YFEvent):void
		{
			// 发送领取黄钻新手礼包的协议给服务端
			var msg:CGetVipGiftPackReq=new CGetVipGiftPackReq;
			msg.giftPackType=TypeVipGift.NEW_PLAYER_GIFT;
			MsgPool.sendGameMsg(GameCmd.CGetVipGiftPackReq,msg);
		}
		
		private function onCallOpenYearAPI(e:YFEvent):void
		{
			// 调用开通年费黄钻API
			var url:URLRequest=new URLRequest(YellowAPIManager.Instence.getYearOpenApiUrl());
			navigateToURL(url);
		}
		
		private function onCallOpenAPI(e:YFEvent):void
		{
			// 调用开通黄钻API
			var url:URLRequest=new URLRequest(YellowAPIManager.Instence.getOpenApiUrl());
			navigateToURL(url);
		}
		
		private function onGiftYellowChangeTab(e:YFEvent):void
		{
			_giftYellow.updateTo(e.param as int);
		}
	}
}