package com.YFFramework.game.core.module.shop
{
	import com.CMD.GameCmd;
	import com.YFFramework.game.core.module.bag.baseClass.BagGrid;
	import com.YFFramework.game.core.module.bag.source.PackSource;
	import com.msg.item.Unit;
	import com.msg.storage.CGetFromBuyBackListReq;
	import com.net.MsgPool;
	
	import flash.events.MouseEvent;

	public class BuyBackBagGrid extends BagGrid
	{
		public function BuyBackBagGrid(id:int)
		{
			super();
		}
		
		override protected function onMouseDownHandler(e:MouseEvent):void
		{
			if(_info != null){
				//请求回购列表，商店事件定义好后再填星号的部分
				if(boxType == PackSource.BACK_LIST){
					var msg:CGetFromBuyBackListReq=new CGetFromBuyBackListReq();
					var unitItem:Unit = new Unit();
					unitItem.id = _info.id;
					unitItem.type = _info.type;
					msg.item = unitItem;
					MsgPool.sendGameMsg(GameCmd.CGetFromBuyBackListReq,msg);
				}
			}
		}
		
	}
}