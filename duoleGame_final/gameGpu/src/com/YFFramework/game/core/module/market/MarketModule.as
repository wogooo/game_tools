package com.YFFramework.game.core.module.market
{
	/**
	 * @version 1.0.0
	 * creation time：2013-5-27 下午3:39:56
	 * 
	 */
	import com.CMD.GameCmd;
	import com.YFFramework.core.center.abs.module.AbsModule;
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.core.global.manager.EquipBasicManager;
	import com.YFFramework.game.core.global.manager.EquipDyManager;
	import com.YFFramework.game.core.global.manager.PropsBasicManager;
	import com.YFFramework.game.core.global.manager.PropsDyManager;
	import com.YFFramework.game.core.global.model.EquipBasicVo;
	import com.YFFramework.game.core.global.model.ItemDyVo;
	import com.YFFramework.game.core.global.model.PropsBasicVo;
	import com.YFFramework.game.core.global.util.NoticeUtil;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.module.market.data.manager.MarketDyManager;
	import com.YFFramework.game.core.module.market.event.MarketEvent;
	import com.YFFramework.game.core.module.market.source.MarketSource;
	import com.YFFramework.game.core.module.market.view.window.MarketWindow;
	import com.YFFramework.game.core.module.notice.manager.NoticeManager;
	import com.YFFramework.game.core.module.notice.model.NoticeType;
	import com.YFFramework.game.core.module.notice.model.NoticeUtils;
	import com.YFFramework.game.core.scence.TypeScence;
	import com.msg.market_pro.CDownSale;
	import com.msg.market_pro.CDownWant;
	import com.msg.market_pro.CGetBackItem;
	import com.msg.market_pro.CMyDealList;
	import com.msg.market_pro.CMySaleList;
	import com.msg.market_pro.CMyWantList;
	import com.msg.market_pro.CMyWantListNumber;
	import com.msg.market_pro.CSearchSaleList;
	import com.msg.market_pro.CSearchWantList;
	import com.msg.market_pro.CUpSale;
	import com.msg.market_pro.CUpWant;
	import com.msg.market_pro.SBuySale;
	import com.msg.market_pro.SBuySaleNotify;
	import com.msg.market_pro.SDownSale;
	import com.msg.market_pro.SDownWant;
	import com.msg.market_pro.SGetBackItem;
	import com.msg.market_pro.SMyDealList;
	import com.msg.market_pro.SMySaleList;
	import com.msg.market_pro.SMySaleListNumber;
	import com.msg.market_pro.SMyWantList;
	import com.msg.market_pro.SMyWantListNumber;
	import com.msg.market_pro.SSaleDownNotify;
	import com.msg.market_pro.SSaleToWant;
	import com.msg.market_pro.SSearchResult;
	import com.msg.market_pro.SUpSale;
	import com.msg.market_pro.SUpWant;
	import com.net.MsgPool;
	
	public class MarketModule extends AbsModule
	{
		//======================================================================
		//       public property
		//======================================================================
		
		//======================================================================
		//       private property
		//======================================================================
		private var _view:MarketWindow;
		
		private var isFirst:Boolean;
		//======================================================================
		//        constructor
		//======================================================================
		
		public function MarketModule()
		{
			super();
			_belongScence=TypeScence.ScenceGameOn;
			_view=new MarketWindow();
		}
		
		//======================================================================
		//        public function
		//======================================================================
		override public function init():void
		{
			addEvents();
			addSocketCallback();
		}
		//======================================================================
		//        private function
		//======================================================================
		/**
		 * 客户端请求
		 * 
		 */		
		private function addEvents():void
		{
			//点击市场图标
			YFEventCenter.Instance.addEventListener(GlobalEvent.MarketUIClick,openMarket);
			
			//与背包有关的事件
			YFEventCenter.Instance.addEventListener(GlobalEvent.MoveToConsignment,moveToConsignItem);//从背包移过来
			YFEventCenter.Instance.addEventListener(GlobalEvent.clearConsignPanel,unlockItemInConsign);//从寄售拖动到背包,解锁
			
			YFEventCenter.Instance.addEventListener(MarketEvent.MOVE_TO_CONSIGN_ITEM,moveToConsignItem);//记录暂时移动到寄售面板的物品
			
			//发送服务端
			YFEventCenter.Instance.addEventListener(MarketEvent.CSearchSaleList,consignSearchReq);//向服务器请求查询寄售信息							
			YFEventCenter.Instance.addEventListener(MarketEvent.CMySaleList,myConsignListReq);//我的寄售列表请求
			YFEventCenter.Instance.addEventListener(MarketEvent.CDownSale,onDownSaleReq);//我的寄售下架
			YFEventCenter.Instance.addEventListener(MarketEvent.CUpSale,consignReq);//请求寄售\物品货币
			YFEventCenter.Instance.addEventListener(MarketEvent.CMySaleListNumber,mySaleListNumberReq);//请求我的求购列表数量
			
			YFEventCenter.Instance.addEventListener(MarketEvent.CSearchWantList,purchaseSearchReq);//向服务器请求查询求购信息
			YFEventCenter.Instance.addEventListener(MarketEvent.CMyWantList,myPurchaseListReq);//我的求购列表
			YFEventCenter.Instance.addEventListener(MarketEvent.CDownWant,onDownWantReq);//我的求购下架
			YFEventCenter.Instance.addEventListener(MarketEvent.CUpWant,upWantReq);//求购信息上架
			YFEventCenter.Instance.addEventListener(MarketEvent.CMyWantListNumber,myWantListNumber);//请求我的求购列表数量
			
			YFEventCenter.Instance.addEventListener(MarketEvent.CMyDealList,myLogListReq);//请求我的交易记录
			YFEventCenter.Instance.addEventListener(MarketEvent.CGetBackItem,getBackItemReq);//交易记录里取回物品
			
			//金钱改变
			YFEventCenter.Instance.addEventListener(GlobalEvent.MoneyChange,onMoneyChange);
		}
		
		/**
		 * 服务器发回 
		 * 
		 */		
		private function addSocketCallback():void
		{
			MsgPool.addCallBack(GameCmd.SSearchSaleList,SSearchResult,consignListResp);//寄售信息查询返回					
			MsgPool.addCallBack(GameCmd.SMySaleList,SMySaleList,myConsignListResp);//我的寄售信息返回
			MsgPool.addCallBack(GameCmd.SDownSale,SDownSale,onMyDownSaleResp);//我的寄售下架回复
			MsgPool.addCallBack(GameCmd.SUpSaleItem,SUpSale,onUpSaleItemResp);//寄售物品
//			MsgPool.addCallBack(GameCmd.SUpSaleMoney,SUpSale,onUpSaleMoneyResp);//货币回复
			MsgPool.addCallBack(GameCmd.SMySaleListNumber,SMySaleListNumber,onMySaleListNumberResp);//回复我的寄售列表数量
			
			MsgPool.addCallBack(GameCmd.SSearchWantList,SSearchResult,purchaseListResp);//求购信息查询返回
			MsgPool.addCallBack(GameCmd.SMyWantList,SMyWantList,myPurchaseListResp);//我的求购列表回复 
			MsgPool.addCallBack(GameCmd.SDownWant,SDownWant,downWantResp);//我的求购下架回复
			MsgPool.addCallBack(GameCmd.SUpWant,SUpWant,upWantResp);//求购物品回复
			MsgPool.addCallBack(GameCmd.SMyWantListNumber,SMyWantListNumber,onMyWantListNumber);
			
			MsgPool.addCallBack(GameCmd.SMyDealList,SMyDealList,myLogListResp);//我的交易记录回复
			MsgPool.addCallBack(GameCmd.SGetBackItem,SGetBackItem,getBackItemResp);//交易记录取回物品回复
			
			MsgPool.addCallBack(GameCmd.SBuySale,SBuySale,onBuySale);//购买寄售物品回复
			
			MsgPool.addCallBack(GameCmd.SSaleToWant,SSaleToWant,onSaleToWant);//卖东西给求购者回复
			
			//notice提示
			MsgPool.addCallBack(GameCmd.SSaleDownNotify,SSaleDownNotify,onSaleDownNotify);//到时间寄售物品下架通知寄售者
			MsgPool.addCallBack(GameCmd.SBuySaleNotify,SBuySaleNotify,onBuySaleNotify);//寄售的东西被人买了通知寄售者
		}
		//======================================================================
		//        event handler
		//======================================================================
		private function openMarket(e:YFEvent):void
		{
			_view.switchOpenClose();
		}
		
		private function moveToConsignItem(e:YFEvent):void
		{
			_view.moveToConsignItem(e.param as ItemDyVo);
		}
		
		private function unlockItemInConsign(e:YFEvent):void
		{
			_view.resetConsignItemPanel();
			MarketSource.curLockPos=0;
			MarketSource.lastLockPos=0;
		}
		
		private function consignSearchReq(e:YFEvent):void
		{
			MsgPool.sendGameMsg(GameCmd.CSearchSaleList,e.param as CSearchSaleList);
		}
		
		private function consignListResp(msg:SSearchResult):void
		{
			MarketDyManager.instance.setConsignPurchaseList(MarketSource.CONSIGH,msg.recordArr);
			_view.consignListResp(msg.totalPage);
		}
		
		private function purchaseSearchReq(e:YFEvent):void
		{
			MsgPool.sendGameMsg(GameCmd.CSearchWantList,e.param as CSearchWantList);
		}
		
		private function purchaseListResp(msg:SSearchResult):void
		{
			MarketDyManager.instance.setConsignPurchaseList(MarketSource.PURCHASE,msg.recordArr);
			_view.purchaseListResp(msg.totalPage);
		}
		
		private function myConsignListReq(e:YFEvent):void
		{
			var msg:CMySaleList=new CMySaleList();
			MsgPool.sendGameMsg(GameCmd.CMySaleList,msg);
		}
		
		private function myConsignListResp(msg:SMySaleList):void
		{
			if(msg == null)
			{
				msg=new SMySaleList();
				msg.recordArr=[];
			}
			MarketDyManager.instance.setMyConsignPurchaseList(MarketSource.CONSIGH,msg.recordArr);
			_view.myConsignListResp();
		}
		
		private function onDownSaleReq(e:YFEvent):void
		{
			MsgPool.sendGameMsg(GameCmd.CDownSale,e.param as CDownSale);
		}
		
		private function onMyDownSaleResp(msg:SDownSale):void
		{
			if(msg.code == TypeProps.RSPMSG_FAIL)
			{
				NoticeManager.setNotice(NoticeType.Notice_id_1603);
			}
			else
			{
				MarketDyManager.instance.delMyConsign(msg.recordId);
				_view.myConsignListResp();
			}
		}
		
		private function consignReq(e:YFEvent):void
		{
			MsgPool.sendGameMsg(GameCmd.CUpSale,e.param as CUpSale);
		}
		
		private function onUpSaleItemResp(msg:SUpSale):void
		{
			if(msg.code == TypeProps.RSPMSG_FAIL)
			{
				NoticeManager.setNotice(NoticeType.Notice_id_1604);
			}
			else if(msg.code == TypeProps.RSPMSG_SUCCESS)
			{
				MarketDyManager.instance.myConsignItemsNum += 1;
				
				var unLockPos:int=MarketSource.curLockPos;
				if(unLockPos > 0)
				{
					YFEventCenter.Instance.dispatchEventWith(GlobalEvent.UnlockItem,unLockPos);
					_view.resetConsignItemPanel();
				}
			}
		}
		
//		private function onUpSaleMoneyResp(msg:SUpSale):void
//		{
//			if(msg.code == TypeProps.RSPMSG_FAIL)
//			{
//				NoticeManager.setNotice(NoticeType.Notice_id_1605);
//			}
//			else if(msg.code == TypeProps.RSPMSG_SUCCESS)
//			{
//				MarketDyManager.instance.myConsignItemsNum += 1;
//				
//				_view.resetConsignMoneyPanel();
//			}
//		}
		
		private function mySaleListNumberReq(e:YFEvent):void
		{
			var msg:CMyWantListNumber=new CMyWantListNumber();
			MsgPool.sendGameMsg(GameCmd.CMySaleListNumber,msg);
		}
		
		private function onMySaleListNumberResp(msg:SMySaleListNumber):void
		{
			MarketDyManager.instance.myConsignItemsNum=msg.saleListNumber;
		}
		
		private function myWantListNumber(e:YFEvent):void
		{
			var msg:CMyWantListNumber=new CMyWantListNumber();
			MsgPool.sendGameMsg(GameCmd.CMyWantListNumber,msg);
		}
		
		private function onMyWantListNumber(msg:SMyWantListNumber):void
		{
			MarketDyManager.instance.myPurchaseItemsNum=msg.wantListNumber;
		}	
		
		private function myPurchaseListReq(e:YFEvent):void
		{
			MsgPool.sendGameMsg(GameCmd.CMyWantList,e.param as CMyWantList);
		}
		
		private function myPurchaseListResp(msg:SMyWantList):void
		{
			if(msg == null)
			{
				msg=new SMyWantList();
				msg.recordArr=[];
			}
			MarketDyManager.instance.setMyConsignPurchaseList(MarketSource.PURCHASE,msg.recordArr);
			_view.myPurchaseListResp();
		}
		
		public function onDownWantReq(e:YFEvent):void
		{
			MsgPool.sendGameMsg(GameCmd.CDownWant,e.param as CDownWant);
		}
		
		public function downWantResp(msg:SDownWant):void
		{
			if(msg.code == TypeProps.RSPMSG_FAIL)
			{
				NoticeManager.setNotice(NoticeType.Notice_id_1606);
			}
			else
			{
				MarketDyManager.instance.delMyPurchase(msg.recordId);
				_view.myPurchaseListResp();
			}
		}
		
		public function upWantReq(e:YFEvent):void
		{
			MsgPool.sendGameMsg(GameCmd.CUpWant,e.param as CUpWant);
		}
		
		public function upWantResp(msg:SUpWant):void
		{
			if(msg.code == TypeProps.RSPMSG_FAIL)
			{
				NoticeManager.setNotice(NoticeType.Notice_id_1607);
			}
			else if(msg.code == TypeProps.RSPMSG_SUCCESS)
			{
				MarketDyManager.instance.myPurchaseItemsNum += 1;
				_view.resetPurchaseItemPanel();
			}
		}
		
		public function myLogListReq(e:YFEvent):void
		{
			MsgPool.sendGameMsg(GameCmd.CMyDealList,e.param as CMyDealList);
		}
		
		public function myLogListResp(msg:SMyDealList):void
		{
			if(msg)
			{
				MarketDyManager.instance.setMyConsignPurchaseList(MarketSource.MYLOG,msg.recordArr);
				_view.myLogListResp(msg.totalPage);
			}
			
		}
		
		private function getBackItemReq(e:YFEvent):void
		{
			MsgPool.sendGameMsg(GameCmd.CGetBackItem,e.param as CGetBackItem);
		}
		
		private function getBackItemResp(msg:SGetBackItem):void
		{
			if(msg.code == TypeProps.RSPMSG_FAIL)
			{
				NoticeManager.setNotice(NoticeType.Notice_id_1608);
			}
			else
			{
				_view.reFreshMyLog();
			}
		}
		
		private function onBuySale(msg:SBuySale):void
		{
			if(msg.code == TypeProps.RSPMSG_FAIL)
			{
				NoticeManager.setNotice(NoticeType.Notice_id_1609);
			}
			_view.refreshConsignListReq();
		}
		
		private function onSaleToWant(msg:SSaleToWant):void
		{
			if(msg.code == TypeProps.RSPMSG_FAIL)
			{
				NoticeManager.setNotice(NoticeType.Notice_id_1610);
			}
			_view.refreshPurchaseListReq();
		}
		
		private function onMoneyChange(e:YFEvent):void
		{
			_view.updateMoney();
		}
		
		//下架通知
		private function onSaleDownNotify(msg:SSaleDownNotify):void
		{
			var tmpId:int;
			if(msg.itemType == TypeProps.ITEM_TYPE_PROPS)
			{
				tmpId=PropsDyManager.instance.getPropsInfo(msg.itemId).templateId;
				var pbsVo:PropsBasicVo=PropsBasicManager.Instance.getPropsBasicVo(tmpId);
				NoticeManager.setNotice(NoticeType.Notice_id_1602,-1,pbsVo.name);
			}
			else if(msg.itemType == TypeProps.ITEM_TYPE_EQUIP)
			{
				tmpId=EquipDyManager.instance.getEquipInfo(msg.itemId).template_id;
				var bsVo:EquipBasicVo=EquipBasicManager.Instance.getEquipBasicVo(tmpId);
				NoticeManager.setNotice(NoticeType.Notice_id_1602,-1,bsVo.name);
			}
			else if(msg.moneyType == TypeProps.MONEY_DIAMOND)
			{
				NoticeManager.setNotice(NoticeType.Notice_id_1602,-1,NoticeUtils.getMoneyTypeStr(TypeProps.MONEY_DIAMOND));
			}
			else if(msg.moneyType == TypeProps.MONEY_SILVER)
			{
				trace("通知服务器，不可能下架银币，在MarketModule的423行")
//				NoticeManager.setNotice(NoticeType.Notice_id_1602,-1,NoticeUtils.getMoneyTypeStr(TypeProps.MONEY_SILVER));
			}
		}
		
		//被人买了通知
		private function onBuySaleNotify(msg:SBuySaleNotify):void
		{
			var tmpId:int;
			if(msg.itemType == TypeProps.ITEM_TYPE_PROPS)
			{
//				tmpId=PropsDyManager.instance.getPropsInfo(msg.itemId).templateId;
				var pbsVo:PropsBasicVo=PropsBasicManager.Instance.getPropsBasicVo(msg.itemId);
				NoticeManager.setNotice(NoticeType.Notice_id_1601,-1,
					NoticeUtils.setColorText(pbsVo.name,pbsVo.quality),msg.salePrice,NoticeUtils.getMoneyTypeStr(msg.priceType));
			}
			else if(msg.itemType == TypeProps.ITEM_TYPE_EQUIP)
			{
//				tmpId=EquipDyManager.instance.getEquipInfo(msg.itemId).template_id;
				var bsVo:EquipBasicVo=EquipBasicManager.Instance.getEquipBasicVo(msg.itemId);
				NoticeManager.setNotice(NoticeType.Notice_id_1601,-1,
					NoticeUtils.setColorText(bsVo.name,bsVo.quality),msg.salePrice,NoticeUtils.getMoneyTypeStr(msg.priceType));
			}
			else if(msg.moneyType == TypeProps.MONEY_DIAMOND)
			{
				NoticeManager.setNotice(NoticeType.Notice_id_1601,-1,NoticeUtils.getMoneyTypeStr(TypeProps.MONEY_DIAMOND),
					msg.salePrice,NoticeUtils.getMoneyTypeStr(msg.priceType));
			}
			else if(msg.moneyType == TypeProps.MONEY_SILVER)
			{
				trace("通知服务器，不可能买了或买了银币，在MarketModule的452行")
//				NoticeManager.setNotice(NoticeType.Notice_id_1601,-1,NoticeUtils.getMoneyTypeStr(TypeProps.MONEY_SILVER),
//					msg.salePrice,NoticeUtils.getMoneyTypeStr(msg.priceType));
			}
		}
		//======================================================================
		//        getter&setter
		//======================================================================
		
		
	}
} 