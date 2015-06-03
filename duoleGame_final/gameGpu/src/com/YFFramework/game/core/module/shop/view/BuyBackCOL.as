package com.YFFramework.game.core.module.shop.view
{
	import com.CMD.GameCmd;
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.game.core.global.manager.EquipBasicManager;
	import com.YFFramework.game.core.global.manager.PropsBasicManager;
	import com.YFFramework.game.core.global.model.EquipBasicVo;
	import com.YFFramework.game.core.global.model.EquipDyVo;
	import com.YFFramework.game.core.global.model.ItemDyVo;
	import com.YFFramework.game.core.global.model.PropsBasicVo;
	import com.YFFramework.game.core.global.model.PropsDyVo;
	import com.YFFramework.game.core.global.util.NoticeUtil;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.module.bag.source.BagSource;
	import com.YFFramework.game.core.module.shop.data.ShopDyManager;
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
				_backList[i]=new BuyBackBagGrid();
				_backList[i].openGrid();
				_backList[i].x=(_backList[i].width+8)*i;
//				_backList[i].y=21;
				_backList[i].boxType=BagSource.BACK_LIST;
				_ui.addChild(_backList[i]);
			}
		}
		
		private function getBuyBackList(msg:SGetBuyBackListRsp):void
		{
			clearAllList();
			if(msg != null)
			{			
				var items:Array=ShopDyManager.instance.saveServerBackList(msg.cell);	
				var len:int=items.length;
				var obj:Object;
				for(var i:int=0;i<len;i++)
				{
					obj=ShopDyManager.instance.getBackListInfo(items[i]);
					if(obj)
					{
						_backList[i].setBackGridContent(obj);
					}
					
				}
					
			}
		}
		
		private function clearAllList():void
		{
			for(var i:int=0;i<_backList.length;i++){
				_backList[i].disposeContent();
			}
		}
		
	}
}