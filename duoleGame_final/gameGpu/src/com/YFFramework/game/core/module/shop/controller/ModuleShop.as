package com.YFFramework.game.core.module.shop.controller
{
	import com.CMD.GameCmd;
	import com.YFFramework.core.center.abs.module.AbsModule;
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.game.core.global.DataCenter;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.core.global.manager.EquipBasicManager;
	import com.YFFramework.game.core.global.manager.PropsBasicManager;
	import com.YFFramework.game.core.global.model.EquipBasicVo;
	import com.YFFramework.game.core.global.model.PropsBasicVo;
	import com.YFFramework.game.core.global.util.NoticeUtil;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.module.market.data.vo.MarketRecord;
	import com.YFFramework.game.core.module.notice.manager.NoticeManager;
	import com.YFFramework.game.core.module.notice.model.NoticeType;
	import com.YFFramework.game.core.module.shop.data.ShopBasicManager;
	import com.YFFramework.game.core.module.shop.data.ShopBasicVo;
	import com.YFFramework.game.core.module.shop.view.BuyWindow;
	import com.YFFramework.game.core.module.shop.view.FixCOL;
	import com.YFFramework.game.core.module.shop.view.ShopWindow;
	import com.YFFramework.game.core.scence.TypeScence;
	import com.dolo.ui.controls.Alert;
	import com.msg.common.ItemConsume;
	import com.msg.enumdef.RspMsg;
	import com.msg.market_pro.CBuySale;
	import com.msg.market_pro.CSaleToWant;
	import com.msg.shop.CBuyItemReq;
	import com.msg.shop.SBuyItemRsp;
	import com.net.MsgPool;

	public class ModuleShop extends AbsModule
	{
		private static var _instance:ModuleShop;
		
		private var _view:ShopWindow;
		private var _shopID:uint;
		private var _fix:FixCOL;
		private var _lastOpenID:int = -1;
		
		public function ModuleShop()
		{
			_instance = this;
			_belongScence=TypeScence.ScenceGameOn;
			_fix = new FixCOL();
		}
		
		public function get fix():FixCOL
		{
			return _fix;
		}

		public function get view():ShopWindow
		{
			return _view;
		}

		private function onBuyRsp(vo:SBuyItemRsp):void
		{
			switch(vo.rsp){
				case RspMsg.RSPMSG_FAIL:
					Alert.show("购买失败！","商店");
					break;
				case RspMsg.RSPMSG_PACK_FULL:
					NoticeManager.setNotice(NoticeType.Notice_id_302);
					break;
			}
		}
		
		public static function get instance():ModuleShop
		{
			return _instance;
		}

		override public function init():void
		{
			_view = new ShopWindow();
			YFEventCenter.Instance.addEventListener(GlobalEvent.ShopUIClick,openShop);
			YFEventCenter.Instance.addEventListener(GlobalEvent.OpenShopById,onOpenShopById);
			MsgPool.addCallBack(GameCmd.SBuyItemRsp,SBuyItemRsp,onBuyRsp);
		}
		
		private function onOpenShopById(event:YFEvent):void
		{
			openShopByID(int(event.param));
		}
		
		/**
		 * 打开NPC商店 
		 * @param id 对应shopId
		 * 
		 */
		public function openShopByID(id:uint):void
		{
			_shopID = id;
			_view.open();
			if(id != _lastOpenID){
				_view.reset();
				var tabIndexAry:Array=ShopBasicManager.Instance.getShopInfoByShopId(id);
				for each(var i:int in tabIndexAry)
				{
					showTabAt(i);
				}
			}
			_view.switchTabAt(1);
			_lastOpenID = id;
		}
		
		private function showTabAt(tabIndex:int):void
		{
			var info:Vector.<ShopBasicVo>;
			var labelStr:String = ShopBasicManager.Instance.getTabLabelByIDAndTab(_shopID,tabIndex);
			info = ShopBasicManager.Instance.getDataByIDAndTab(_shopID,tabIndex);
			_view.updateList(info,tabIndex,labelStr);
		}
		
		/** 市场购买专用(寄售：购买；求购：出售) */
		public function openMarketBuyWindow(type:int,record:MarketRecord):void
		{
			BuyWindow.show();
			BuyWindow.instance.initMarket(type,record);
		}
		
		public function get isNPCShopOpened():Boolean
		{
			if(_view == null) return false;
			if(_view && _view.parent) return true;
			return false;
		}
		
		/** 只用于商店商城黑市商店通过正常购买产生的弹框购买,暂时唯一例外是公会商店利用贡献值购买（并且小路已经做过判断了）；其他地方不要随意调用这个接口*/
		public function buyItem(itemVO:ShopBasicVo,amount:int):void
		{
			var msg:CBuyItemReq = new CBuyItemReq();
			msg.shopId = itemVO.shop_id;
			msg.pos = itemVO.pos;
			msg.amount = amount;
			MsgPool.sendGameMsg(GameCmd.CBuyItemReq,msg);
		}
		
		/** 非商店商城黑市商店(shop_id==300)，不弹框购买 */
		public function buyItemDirect(itemType:int,itemID:int,amount:int=1):void
		{
			var vo:ShopBasicVo = ShopBasicManager.Instance.getShopBasicVoDirect(itemType,itemID);
			if(vo.money_type == TypeProps.MONEY_COUPON)
			{
				if(DataCenter.Instance.roleSelfVo.coupon >= (vo.price * amount))
					buyItem(vo,amount);
				else
					NoticeUtil.setOperatorNotice("礼券不足");
			}
			else if(vo.money_type == TypeProps.MONEY_DIAMOND)
			{
				if(DataCenter.Instance.roleSelfVo.diamond >= (vo.price * amount))
					buyItem(vo,amount);
				else
					NoticeManager.setNotice(NoticeType.Notice_id_319);
			}
			else if(vo.money_type == TypeProps.MONEY_NOTE)
			{
				if(DataCenter.Instance.roleSelfVo.note >= (vo.price * amount))
					buyItem(vo,amount);
				else
					NoticeManager.setNotice(NoticeType.Notice_id_332);
			}
		}
		
		/** 非商店商城黑市商店(shop_id==300)，弹框购买 */
		public function openBuySmallWindowDirect(itemType:int,itemID:int,count:int=1):void
		{
			var vo:ShopBasicVo = ShopBasicManager.Instance.getShopBasicVoDirect(itemType,itemID);
			BuyWindow.show();
			BuyWindow.instance.init(vo,count);
		}
		
		/** 商店商城黑市商店(shop_id!=300)，弹框购买 */
		public function openBuySmallWindow(vo:ShopBasicVo,count:int=1):void
		{
			BuyWindow.show();
			BuyWindow.instance.init(vo,count);
		}
		
		/**
		 * 购买出售物品,针对寄售
		 * @param recordId
		 * @param num
		 * 
		 */		
		public function marketBuy(recordId:int,num:int):void
		{
			var msg:CBuySale = new CBuySale();
			msg.recordId=recordId;
			msg.number=num;
			MsgPool.sendGameMsg(GameCmd.CBuySale,msg);
		}
		
		/**
		 * 卖东西给求购者,针对求购
		 * @param recordId
		 * @param saleItem
		 * 
		 */		
		public function marketSale(recordId:int,saleItem:Array):void
		{
			var msg:CSaleToWant=new CSaleToWant();
			msg.recordId=recordId;
			msg.saleItems=saleItem;
			MsgPool.sendGameMsg(GameCmd.CSaleToWant,msg);
		}
		
		public function closeShop():void
		{
			if(_view){
				_view.close();
			}
		}
		
		private function openShop(event:YFEvent=null):void
		{
			openShopByID(1);
		}
		
		public static function getItemNameByShopVO(vo:ShopBasicVo):String
		{
			var gName:String = "";
			if(vo.item_type == 1){
				var evo:EquipBasicVo;
				evo = EquipBasicManager.Instance.getEquipBasicVo(vo.item_id);
				if(evo){
					gName = evo.name;
				}
			}else{
				var pvo:PropsBasicVo;
				pvo = PropsBasicManager.Instance.getPropsBasicVo(vo.item_id);
				if(pvo){
					gName = pvo.name;
				}
			}
			return gName;
		}
		
		public static function getItemQuality(vo:ShopBasicVo):int
		{
			var quality:int;
			if(vo.item_type == 1){
				var evo:EquipBasicVo;
				evo = EquipBasicManager.Instance.getEquipBasicVo(vo.item_id);
				if(evo){
					quality = evo.quality;
				}
			}else{
				var pvo:PropsBasicVo;
				pvo = PropsBasicManager.Instance.getPropsBasicVo(vo.item_id);
				if(pvo){
					quality=pvo.quality;
				}
			}
			return quality;
		}
	}
}