package com.YFFramework.game.core.module.shop
{
	import com.CMD.GameCmd;
	import com.YFFramework.core.center.abs.module.AbsModule;
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.core.global.manager.EquipBasicManager;
	import com.YFFramework.game.core.global.manager.PropsBasicManager;
	import com.YFFramework.game.core.global.model.EquipBasicVo;
	import com.YFFramework.game.core.global.model.PropsBasicVo;
	import com.YFFramework.game.core.module.shop.vo.NPCShopBasicManager;
	import com.YFFramework.game.core.module.shop.vo.ShopBasicVo;
	import com.YFFramework.game.core.scence.TypeScence;
	import com.dolo.ui.controls.Alert;
	import com.msg.enumdef.RspMsg;
	import com.msg.shop.CBuyItemReq;
	import com.msg.shop.SBuyItemRsp;
	import com.net.MsgPool;
	import com.YFFramework.game.core.module.npc.manager.NPCBasicManager;

	public class ModuleShop extends AbsModule
	{
		private static var _ins:ModuleShop;
		
		private var _view:ShopWindow;
		private var _shopID:uint;
		private var _fix:FixCOL;
		
		public function ModuleShop()
		{
			_ins = this;
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
				case RspMsg.RSPMSG_SUCCESS:
					Alert.show("购买成功。","商店",null,null,false);
					break;
				case RspMsg.RSPMSG_FAIL:
					Alert.show("购买失败！","商店");
					break;
				case RspMsg.RSPMSG_BALANCE_LESS:
					Alert.show("余额不足！","商店");
					break;
				case RspMsg.RSPMSG_PACK_FULL:
					Alert.show("背包已满！","商店");
					break;
			}
		}
		
		public static function get ins():ModuleShop
		{
			return _ins;
		}

		override public function init():void
		{
			_view = new ShopWindow();
			YFEventCenter.Instance.addEventListener(GlobalEvent.ShopUIClick,openShop);
			MsgPool.addCallBack(GameCmd.SBuyItemRsp,SBuyItemRsp,onBuyRsp);
		}
		
		/**
		 * 打开NPC商店 
		 * @param id 对应的NPC ID
		 * 
		 */
		public function openShopByID(id:uint):void
		{
			_shopID = id;
			_view.open();
			_view.reset();
			var len:int = NPCShopBasicManager.Instance.getShopTabsLength(id);
			for(var i:int=1;i<=len;i++){
				showTabAt(i);
			}
			_view.switchTabAt(1);
		}
		
		public function openBuySmallWindow(itemID:int,count:int=1):void
		{
			var vo:ShopBasicVo = NPCShopBasicManager.Instance.getShopBasicVoByItemID(itemID);
			BuyWindow.show();
			BuyWindow.ins.init(vo,count);
		}
		
		public function get isNPCShopOpened():Boolean
		{
			if(_view == null) return false;
			if(_view && _view.parent) return true;
			return false;
		}
		
		public function buyItem(itemVO:ShopBasicVo,amount:int):void
		{
			var msg:CBuyItemReq = new CBuyItemReq();
			msg.shopId = itemVO.shop_id;
			msg.pos = itemVO.pos;
			msg.amount = amount;
			MsgPool.sendGameMsg(GameCmd.CBuyItemReq,msg);
		}
		
		public function closeShop():void
		{
			if(_view){
				_view.close();
			}
		}
		
		public function showTabAt(tabIndex:int):void
		{
			var _das:Vector.<ShopBasicVo>;
			var labelStr:String = NPCShopBasicManager.Instance.getTabLabelByIDAndTab(_shopID,tabIndex);
			_das = NPCShopBasicManager.Instance.getListByIDAndTab(_shopID,tabIndex);
			_view.updateList(_das,tabIndex,labelStr);
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
		
	}
}