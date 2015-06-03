package com.YFFramework.game.core.module.blackShop
{
	/**
	 * @author jina;
	 * @version 1.0.0
	 * creation time：2013-9-24 下午4:09:27
	 */
	import com.CMD.GameCmd;
	import com.YFFramework.core.center.abs.module.AbsModule;
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.game.core.global.DataCenter;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.core.global.util.NoticeUtil;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.module.blackShop.data.BlackShopDyManager;
	import com.YFFramework.game.core.module.blackShop.view.BlackShopWindow;
	import com.YFFramework.game.core.scence.TypeScence;
	import com.msg.black_shop.CGetBlackShopList;
	import com.msg.black_shop.CRefreshBSList;
	import com.msg.black_shop.SBuyBSItem;
	import com.msg.black_shop.SGetBlackShopList;
	import com.msg.black_shop.SRefreshBSList;
	import com.net.MsgPool;
	
	public class BlackShopModule extends AbsModule
	{
		//======================================================================
		//       public property
		//======================================================================
		
		//======================================================================
		//       private property
		//======================================================================
		private var _window:BlackShopWindow;
		//======================================================================
		//        constructor
		//======================================================================
		
		public function BlackShopModule()
		{		
			_belongScence=TypeScence.ScenceGameOn;
			_window=new BlackShopWindow();

		}
		
		public function refresh():void
		{
			var msg:CRefreshBSList=new CRefreshBSList();
			MsgPool.sendGameMsg(GameCmd.CRefreshBSList,msg);
		}
		
		
		//======================================================================
		//        public function
		//======================================================================
		override public function init():void
		{
			addEvents();
		}
		//======================================================================
		//        private function
		//======================================================================
		private function addEvents():void
		{
			/*******************************客户端请求******************************/
			YFEventCenter.Instance.addEventListener(GlobalEvent.GameIn,firstBlackListReq);
			YFEventCenter.Instance.addEventListener(GlobalEvent.BlackShopUIClick,openWindow);
			
			/*******************************服务端发送******************************/
			MsgPool.addCallBack(GameCmd.SGetBlackShopList,SGetBlackShopList,getBlackShopListRsp);
			MsgPool.addCallBack(GameCmd.SBuyBSItem,SBuyBSItem,onBuyRsp);
			MsgPool.addCallBack(GameCmd.SRefreshBSList,SRefreshBSList,refreshList);
		}
		//======================================================================
		//        event handler
		//======================================================================
		private function firstBlackListReq(e:YFEvent):void
		{
			var msg:CGetBlackShopList=new CGetBlackShopList();
			MsgPool.sendGameMsg(GameCmd.CGetBlackShopList,msg);
		}
		
		private function getBlackShopListRsp(msg:SGetBlackShopList):void
		{
			BlackShopDyManager.instance.refresh=msg.refresh;
			BlackShopDyManager.instance.updateItemsInfo(msg.blackItemInfo);
		}
		
		private function openWindow(e:YFEvent):void
		{
			_window.switchOpenClose();
		}
		
		private function onBuyRsp(msg:SBuyBSItem):void
		{
			if(msg.rsp == TypeProps.RSPMSG_SUCCESS)
			{
				var index:int=msg.gridIndex-1;
				BlackShopDyManager.instance.updateOneInfo(index);
				_window.buyRsp(index);
			}
			else
			{
				NoticeUtil.setOperatorNotice('黑市商店购买失败!');
			}
		}
		
		public function refreshList(msg:SRefreshBSList):void
		{
			if(msg.rsp == TypeProps.RSPMSG_SUCCESS)
			{
				BlackShopDyManager.instance.refresh += 1;
				BlackShopDyManager.instance.updateItemsInfo(msg.blackItemInfo);
				if(_window.isOpen)
					_window.updateView();
			}
			else
			{
				NoticeUtil.setOperatorNotice('黑市商店刷新失败');
			}
		}
		//======================================================================
		//        getter&setter
		//======================================================================
		
		
	}
} 