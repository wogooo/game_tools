package com.YFFramework.game.core.module.shop
{
	import com.CMD.GameCmd;
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.game.core.global.model.ItemDyVo;
	import com.YFFramework.game.core.module.bag.source.PackSource;
	import com.msg.enumdef.RspMsg;
	import com.msg.storage.CGetBuyBackListReq;
	import com.msg.storage.SGetBuyBackListRsp;
	import com.msg.storage.SGetFromBuyBackListRsp;
	import com.msg.storage.SSellItemRsp;
	import com.net.MsgPool;
	
	import flash.display.Sprite;

	/**
	 * 管理回购列表 
	 * @author Administrator
	 * 
	 */
	public class BuyBackCOL
	{
		private var _ui:Sprite;
		private var _backList:Vector.<BuyBackBagGrid>;
		
		public function BuyBackCOL()
		{
			MsgPool.addCallBack(GameCmd.SSellItemRsp,SSellItemRsp,onServerSellItemRsp);
			MsgPool.addCallBack(GameCmd.SGetBuyBackListRsp,SGetBuyBackListRsp,getBuyBackList);
			MsgPool.addCallBack(GameCmd.SGetFromBuyBackListRsp,SGetFromBuyBackListRsp,onSGetFromBuyBackListRsp);
		}
		
		private function onSGetFromBuyBackListRsp(vo:SGetFromBuyBackListRsp):void
		{
			if(vo.rsp == RspMsg.RSPMSG_SUCCESS){
				onBuyBackNeedUpdate();
			}
		}
		
		private function onServerSellItemRsp(vo:SSellItemRsp):void
		{
			if(vo.rsp == RspMsg.RSPMSG_SUCCESS){
				onBuyBackNeedUpdate();
			}
		}
		
		private function onBuyBackNeedUpdate(event:YFEvent=null):void
		{
			var msg:CGetBuyBackListReq = new CGetBuyBackListReq();
			msg.append = 1;
			MsgPool.sendGameMsg(GameCmd.CGetBuyBackListReq,msg);
		}
		
		public function initUI(target:Sprite):void
		{
			_ui = target;
			_backList=new Vector.<BuyBackBagGrid>(6);
			for(var i:int=0;i<_backList.length;i++){
				_backList[i]=new BuyBackBagGrid(i);
				_backList[i].openGrid();
				_backList[i].x=2+(_backList[i].width+11.5)*i;
				_backList[i].y=23;
				_backList[i].boxType=PackSource.BACK_LIST;
				_ui.addChild(_backList[i]);
			}
		}
		
		public function getBuyBackList(msg:SGetBuyBackListRsp):void
		{
			clearAllList();
			if(msg != null){
				var items:Array=msg.cell;
				for(var i:int=0;i<items.length;i++){
					var itemDyVo:ItemDyVo=new ItemDyVo(items[i].pos,items[i].item.type,items[i].item.id);
					_backList[i].setContent(itemDyVo);
				}
			}
		}
		
		private function clearAllList():void
		{
			for(var i:int=0;i<_backList.length;i++){
				_backList[i].disposeContent();
				_backList[i].clearFilter();
			}
		}
		
	}
}