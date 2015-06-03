package com.YFFramework.game.core.module.shop.view
{
	import com.CMD.GameCmd;
	import com.YFFramework.game.core.global.DataCenter;
	import com.YFFramework.game.core.global.manager.EquipBasicManager;
	import com.YFFramework.game.core.global.manager.EquipDyManager;
	import com.YFFramework.game.core.global.manager.PropsBasicManager;
	import com.YFFramework.game.core.global.manager.PropsDyManager;
	import com.YFFramework.game.core.global.model.EquipBasicVo;
	import com.YFFramework.game.core.global.model.EquipDyVo;
	import com.YFFramework.game.core.global.model.PropsBasicVo;
	import com.YFFramework.game.core.global.model.PropsDyVo;
	import com.YFFramework.game.core.global.util.NoticeUtil;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.module.bag.baseClass.BagGrid;
	import com.YFFramework.game.core.module.bag.source.BagSource;
	import com.YFFramework.game.core.module.shop.data.ShopDyManager;
	import com.msg.item.Unit;
	import com.msg.storage.CGetFromBuyBackListReq;
	import com.net.MsgPool;
	
	import flash.events.MouseEvent;

	public class BuyBackBagGrid extends BagGrid
	{
		public function BuyBackBagGrid()
		{
			addEventListener(MouseEvent.MOUSE_DOWN,onMouseDownHandler);
		}
		
		private function onMouseDownHandler(e:MouseEvent):void
		{
			if(info != null){
				//请求回购列表，商店事件定义好后再填星号的部分
				if(boxType == BagSource.BACK_LIST){
					var money:int;
					if(info.type == TypeProps.ITEM_TYPE_EQUIP)
					{
						var eDyVo:EquipDyVo=ShopDyManager.instance.getBackListInfo(info).info;
						var eBsVo:EquipBasicVo=EquipBasicManager.Instance.getEquipBasicVo(eDyVo.template_id);
						money=eBsVo.sell_price;
						if(money > DataCenter.Instance.roleSelfVo.note)
						{
							NoticeUtil.setOperatorNotice("银锭不足，不能回购！");
							return;
						}
					}
					else if(info.type == TypeProps.ITEM_TYPE_PROPS)
					{
						var pDyVo:PropsDyVo=ShopDyManager.instance.getBackListInfo(info).info;
						var pBsVo:PropsBasicVo=PropsBasicManager.Instance.getPropsBasicVo(pDyVo.templateId);
						money=pBsVo.sell_price;
						if(money > DataCenter.Instance.roleSelfVo.note)
						{
							NoticeUtil.setOperatorNotice("银锭不足，不能回购！");
							return;
						}
					}
					var msg:CGetFromBuyBackListReq=new CGetFromBuyBackListReq();
					var unitItem:Unit = new Unit();
					unitItem.id = info.id;
					unitItem.type = info.type;
					msg.item = unitItem;
					MsgPool.sendGameMsg(GameCmd.CGetFromBuyBackListReq,msg);
				}
			}
		}
		
	}
}