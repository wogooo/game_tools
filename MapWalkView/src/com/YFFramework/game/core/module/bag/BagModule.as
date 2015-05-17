package com.YFFramework.game.core.module.bag
{
	/**
	 * @version 1.0.0
	 * creation time：2013-3-8 下午4:08:23
	 * 
	 */
	import com.CMD.GameCmd;
	import com.YFFramework.core.center.abs.module.AbsModule;
	import com.YFFramework.core.debug.print;
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.core.global.manager.BagStoreManager;
	import com.YFFramework.game.core.global.manager.EquipDyManager;
	import com.YFFramework.game.core.global.manager.PropsBasicManager;
	import com.YFFramework.game.core.global.manager.PropsDyManager;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.module.bag.backPack.BagWindow;
	import com.YFFramework.game.core.module.bag.event.BagEvent;
	import com.YFFramework.game.core.module.bag.source.PackSource;
	import com.YFFramework.game.core.scence.TypeScence;
	import com.dolo.ui.managers.UIManager;
	import com.msg.hero.CUseItem;
	import com.msg.hero.SUseItem;
	import com.msg.item.CGetCharEquipListReq;
	import com.msg.item.CGetCharPropsListReq;
	import com.msg.item.SCharacterEquipList;
	import com.msg.item.SCharacterPropsList;
	import com.msg.item.SModifyPropsQuantity;
	import com.msg.storage.CExpandStorageReq;
	import com.msg.storage.CGetDepotInfReq;
	import com.msg.storage.CGetPackInfReq;
	import com.msg.storage.CMoveItemReq;
	import com.msg.storage.CPutToBodyReq;
	import com.msg.storage.CRemoveFromDepotReq;
	import com.msg.storage.CRemoveFromPackReq;
	import com.msg.storage.CRepairEquipReq;
	import com.msg.storage.CSellItemReq;
	import com.msg.storage.CSortDepotReq;
	import com.msg.storage.CSortPackReq;
	import com.msg.storage.CSplitItemReq;
	import com.msg.storage.SDepot;
	import com.msg.storage.SExpandStorageRsp;
	import com.msg.storage.SMoveItemRsp;
	import com.msg.storage.SPack;
	import com.msg.storage.SPutToBodyRsp;
	import com.msg.storage.SRemoveFromDepotRsp;
	import com.msg.storage.SRemoveFromPackRsp;
	import com.msg.storage.SSetDepotGridNum;
	import com.msg.storage.SSetPackGridNum;
	import com.msg.storage.SSortDepotRsp;
	import com.msg.storage.SSortPackRsp;
	import com.msg.storage.SSplitItemRsp;
	import com.net.MsgPool;
	import com.net.NetManager;
	
	public class BagModule extends AbsModule
	{
		//======================================================================
		//       public property
		//======================================================================
		
		//======================================================================
		//       private property
		//======================================================================
		private var bagWindow:BagWindow;
		
		private var isFirst:Boolean;
		//======================================================================
		//        constructor
		//======================================================================
		
		public function BagModule()
		{
			super();
			_belongScence=TypeScence.ScenceGameOn;
		}
		
		//======================================================================
		//        public function
		//======================================================================
		override public function init():void
		{
			bagWindow=new BagWindow();
			addEvents();
			addSocketCallback();
		}
		
		public function getBagWindow():BagWindow
		{
			return bagWindow;
		}
		
		public function openBagWindow():void
		{		
			bagWindow.openPack();
			bagWindow.updateMoney();		
		}
		//======================================================================
		//        private function
		//======================================================================
		/***************客户端处理消息***************/
		private function addEvents():void
		{
			YFEventCenter.Instance.addEventListener(GlobalEvent.GameIn,onGameIn);// 请求背包,仓库,道具列表，装备列表
			YFEventCenter.Instance.addEventListener(GlobalEvent.B,onBagUIClick);
			YFEventCenter.Instance.addEventListener(GlobalEvent.BagUIClick,onBagUIClick);//打开界面
			YFEventCenter.Instance.addEventListener(BagEvent.BAG_UI_CExpandStorageReq,onSendSocket);//扩展包裹：请求
			YFEventCenter.Instance.addEventListener(BagEvent.BAG_UI_CPutToBodyReq,onSendSocket);//给角色身上装备物品：请求
			YFEventCenter.Instance.addEventListener(BagEvent.BAG_UI_CRemoveFromPackReq,onSendSocket);//从背包指定位置移除一个物品：请求
			YFEventCenter.Instance.addEventListener(BagEvent.BAG_UI_CRemoveFromDepotReq,onSendSocket);//从仓库指定位置移除一个物品：请求
			YFEventCenter.Instance.addEventListener(BagEvent.BAG_UI_CMoveItemReq,onSendSocket);//移动物品：请求
			YFEventCenter.Instance.addEventListener(BagEvent.BAG_UI_CSellItemReq,onSendSocket);//出售物品：请求
			YFEventCenter.Instance.addEventListener(BagEvent.BAG_UI_CRepairEquipReq,onSendSocket);//装备修理
			YFEventCenter.Instance.addEventListener(BagEvent.BAG_UI_CSplitItemReq,onSendSocket);//拆分物品：请求
			YFEventCenter.Instance.addEventListener(BagEvent.BAG_UI_CSortPackReq,onSendSocket);//背包整理：请求
			YFEventCenter.Instance.addEventListener(BagEvent.BAG_UI_CSortDepotReq,onSendSocket);//仓库整理：请求
			YFEventCenter.Instance.addEventListener(BagEvent.USE_ITEM,onSendSocket);//使用道具、装备
			
			//商店事件
			YFEventCenter.Instance.addEventListener(GlobalEvent.USER_SELL_CLICK,userSell);//监听从商店发出时的出售
			YFEventCenter.Instance.addEventListener(GlobalEvent.USER_FIX_CLICK,userMend);//部分修理
			//宠物事件：发给宠物，打开宠物对应界面
			YFEventCenter.Instance.addEventListener(BagEvent.OPEN_PET_PANEL,openPetPanel);
			//钱的刷新
			YFEventCenter.Instance.addEventListener(GlobalEvent.MoneyChange,moneyChange);
			
		}
		
		/***************服务器发送的消息***************/
		private function addSocketCallback():void
		{
			///背包信息
			NetManager.gameSocket.addCallback(GameCmd.SPack,SPack,onStoragePack);
			///仓库信息
			NetManager.gameSocket.addCallback(GameCmd.SDepot,SDepot,onStorageDepot);
			///背包格子数
			NetManager.gameSocket.addCallback(GameCmd.SSetPackGridNum,SSetPackGridNum,onSetPackGridNum);
			///仓库格子数
			NetManager.gameSocket.addCallback(GameCmd.SSetDepotGridNum,SSetDepotGridNum,onSetDepotGridNum);
			///道具列表
			NetManager.gameSocket.addCallback(GameCmd.SCharacterPropsList,SCharacterPropsList,onCharacterPropsList);
			///装备列表
			NetManager.gameSocket.addCallback(GameCmd.SCharacterEquipList,SCharacterEquipList,onCharacterEquipList);
			///给角色身上装备物品：响应
			NetManager.gameSocket.addCallback(GameCmd.SPutToBodyRsp,SPutToBodyRsp,onPutToBodyRsp);
			///在背包指定位置移除一个物品：响应
			NetManager.gameSocket.addCallback(GameCmd.SRemoveFromPackRsp,SRemoveFromPackRsp,onRemoveFromPackRsp);
			///在仓库指定位置移除一个物品：响应
			NetManager.gameSocket.addCallback(GameCmd.SRemoveFromDepotRsp,SRemoveFromDepotRsp,onRemoveFromDepotRsp);
			///移动物品：响应
			NetManager.gameSocket.addCallback(GameCmd.SMoveItemRsp,SMoveItemRsp,onMoveItemRsp);
			///拆分物品：响应
			NetManager.gameSocket.addCallback(GameCmd.SSplitItemRsp,SSplitItemRsp,onSplitItemRsp);
			///背包整理：响应
			NetManager.gameSocket.addCallback(GameCmd.SSortPackRsp,SSortPackRsp,onSortPackRsp);
			///仓库整理：响应
			NetManager.gameSocket.addCallback(GameCmd.SSortDepotRsp,SSortDepotRsp,onSortDepotRsp);
			///扩展包裹：响应
			NetManager.gameSocket.addCallback(GameCmd.SExpandStorageRsp,SExpandStorageRsp,onExpandStorageRsp);
			///改变道具数量
			NetManager.gameSocket.addCallback(GameCmd.SModifyPropsQuantity,SModifyPropsQuantity,onModifyPropsQuantity);
			///使用道具回复
			NetManager.gameSocket.addCallback(GameCmd.SUseItem,SUseItem,onUseItem);
		}
		//======================================================================
		//        event handler
		//======================================================================
		private function onGameIn(e:YFEvent):void
		{
			var propsMsg:CGetCharPropsListReq=new CGetCharPropsListReq();
			propsMsg.append=1;
			MsgPool.sendGameMsg(GameCmd.CGetCharPropsListReq,propsMsg);
			
			var equipMsg:CGetCharEquipListReq=new CGetCharEquipListReq();
			equipMsg.append=1;
			MsgPool.sendGameMsg(GameCmd.CGetCharEquipListReq,equipMsg);
			
			var bagMsg:CGetPackInfReq=new CGetPackInfReq();
			bagMsg.append=1;
			MsgPool.sendGameMsg(GameCmd.CGetPackInfReq,bagMsg);
			
			var storeMsg:CGetDepotInfReq=new CGetDepotInfReq();
			storeMsg.append=1;
			MsgPool.sendGameMsg(GameCmd.CGetDepotInfReq,storeMsg);
				
			YFEventCenter.Instance.removeEventListener(GlobalEvent.GameIn,onGameIn);

			isFirst=true;
		}
		
		private function onBagUIClick(e:YFEvent):void
		{
			UIManager.switchOpenClose(bagWindow);
			openBagWindow();
		}
		
		/**发送消息给服务端
		 * 
		 */		
		private function onSendSocket(e:YFEvent):void
		{		
			print(this,"进入游戏。。。");
			switch(e.type)
			{
				case BagEvent.BAG_UI_CExpandStorageReq:
					MsgPool.sendGameMsg(GameCmd.CExpandStorageReq,e.param as CExpandStorageReq);
					break;
				case BagEvent.BAG_UI_CPutToBodyReq:
					MsgPool.sendGameMsg(GameCmd.CPutToBodyReq,e.param as CPutToBodyReq);
					break;
				case BagEvent.BAG_UI_CRemoveFromPackReq:
					MsgPool.sendGameMsg(GameCmd.CRemoveFromPackReq,e.param as CRemoveFromPackReq);
					break;
				case BagEvent.BAG_UI_CRemoveFromDepotReq:
					MsgPool.sendGameMsg(GameCmd.CRemoveFromDepotReq,e.param as CRemoveFromDepotReq);
					break;
				case BagEvent.BAG_UI_CMoveItemReq:
					var type:int=(e.param as CMoveItemReq).movDirect;
					switch(type)
					{
						case TypeProps.MOV_DIRECT_PACK_TO_PACK:
							if(bagWindow.getPackTabIndex() == PackSource.TAB_ALL)
							{
								MsgPool.sendGameMsg(GameCmd.CMoveItemReq,e.param as CMoveItemReq);
							}
							break;
						case TypeProps.MOV_DIRECT_PACK_TO_DEPOT:
							if(PackSource.openStore && bagWindow.getPackTabIndex() != PackSource.TAB_MISSION 
								&& bagWindow.getDepotTabIndex() == PackSource.TAB_ALL )
							{
								MsgPool.sendGameMsg(GameCmd.CMoveItemReq,e.param as CMoveItemReq);
							}
							break;
						case TypeProps.MOV_DIRECT_PACK_TO_BODY:
							MsgPool.sendGameMsg(GameCmd.CMoveItemReq,e.param as CMoveItemReq);
							break;
						case TypeProps.MOV_DIRECT_DEPOT_TO_DEPOT:
							if(bagWindow.getDepotTabIndex() == PackSource.TAB_ALL)
							{
								MsgPool.sendGameMsg(GameCmd.CMoveItemReq,e.param as CMoveItemReq);
							}
							break;
						case TypeProps.MOV_DIRECT_DEPOT_TO_PACK:
							if(bagWindow.isOpen && bagWindow.getPackTabIndex() == PackSource.TAB_ALL)
							{
								MsgPool.sendGameMsg(GameCmd.CMoveItemReq,e.param as CMoveItemReq);
							}
							break;
						case TypeProps.MOV_DIRECT_BODY_TO_PACK:
							if(bagWindow.getPackTabIndex() == PackSource.TAB_ALL)
							{
								MsgPool.sendGameMsg(GameCmd.CMoveItemReq,e.param as CMoveItemReq);
							}
							break;
					}
					
					break;
				case BagEvent.BAG_UI_CSellItemReq:
					MsgPool.sendGameMsg(GameCmd.CSellItemReq,e.param as CSellItemReq);
					break;
				case BagEvent.BAG_UI_CSplitItemReq:
					MsgPool.sendGameMsg(GameCmd.CSplitItemReq,e.param as CSplitItemReq);
					break;
				case BagEvent.BAG_UI_CSortPackReq:
					MsgPool.sendGameMsg(GameCmd.CSortPackReq,e.param as CSortPackReq);
					break;
				case BagEvent.BAG_UI_CSortDepotReq:
					MsgPool.sendGameMsg(GameCmd.CSortDepotReq,e.param as CSortDepotReq);
					break;
				case BagEvent.USE_ITEM:
					MsgPool.sendGameMsg(GameCmd.CUseItem,e.param as CUseItem);
					break;
				case BagEvent.BAG_UI_CRepairEquipReq:
					var msg:CRepairEquipReq=new CRepairEquipReq();
					msg.pos=[e.param as int];
					MsgPool.sendGameMsg(GameCmd.CRepairEquipReq,msg);
					break;
			}
		}
		
		private function onStoragePack(msg:SPack):void
		{
			if(msg)
			{
				if(msg.hasClearAll)
					bagWindow.clearAll=true;
				else
					bagWindow.clearAll=false;
				
				BagStoreManager.instantce.setPackList(msg.cell,bagWindow.clearAll);
				BagStoreManager.instantce.setNewPackCells(msg.cell);

				bagWindow.onPackTabChange();
				
				YFEventCenter.Instance.dispatchEventWith(GlobalEvent.BagChange);
			}
		}
		
		private function onStorageDepot(msg:SDepot):void
		{
			if(msg)
			{
				if(msg.hasClearAll)
					bagWindow.setDepotClearAll(true);
				else
					bagWindow.setDepotClearAll(false);
				
				BagStoreManager.instantce.setDepotList(msg.cell,bagWindow.getDepotClearAll());
				BagStoreManager.instantce.setNewDepotCells(msg.cell);
				
				bagWindow.setDepotContent();
			}
		}
		private function onSetPackGridNum(msg:SSetPackGridNum):void
		{
			BagStoreManager.instantce.setPackNum(msg.packNum);
			bagWindow.setPackGridNum();
		}
		
		private function onSetDepotGridNum(msg:SSetDepotGridNum):void
		{
			BagStoreManager.instantce.setDepotNum(msg.depotNum);
			bagWindow.setDepotGridNum();
		}
		
		private function onCharacterPropsList(msg:SCharacterPropsList):void
		{
			if(msg)
				PropsDyManager.instance.setPropsList(msg.props);
		}
		
		private function onCharacterEquipList(msg:SCharacterEquipList):void
		{
			if(msg)
				EquipDyManager.instance.setEquipInfo(msg.equip);
			
			if(isFirst)
			{
				bagWindow.init();
				isFirst=false;
			}
		}
		
		private function onModifyPropsQuantity(msg:SModifyPropsQuantity):void
		{
			if(msg)
			{
				PropsDyManager.instance.motifyPropsNum(msg.propsId,msg.quantity);
				bagWindow.changePropsNum(msg.propsId);
				YFEventCenter.Instance.dispatchEventWith(GlobalEvent.BagChange);
			}
		}
		
		private function onUseItem(msg:SUseItem):void
		{
			bagWindow.useItemResp(msg);
			if(msg.code == TypeProps.RSPMSG_SUCCESS)
			{
				var type:int=PropsBasicManager.Instance.getPropsBasicVo(msg.itemTemplateId).type;
				if(type == TypeProps.PROPS_TYPE_DRUG)
					YFEventCenter.Instance.dispatchEventWith(GlobalEvent.BagDrugUseItemResp,msg.itemTemplateId);
				else if(type == TypeProps.PROPS_TYPE_PET_COMFORT || type == TypeProps.PROPS_TYPE_PET_FEED)
					YFEventCenter.Instance.dispatchEventWith(GlobalEvent.PetUseItemResp,msg.itemTemplateId);
			}
		}
		
		private function onPutToBodyRsp(msg:SPutToBodyRsp):void
		{
			bagWindow.respTips(msg.rsp);
		}
		
		private function onRemoveFromPackRsp(msg:SRemoveFromPackRsp):void
		{
			bagWindow.respTips(msg.rsp);
		}
		
		private function onRemoveFromDepotRsp(msg:SRemoveFromDepotRsp):void
		{
			bagWindow.respTips(msg.rsp);
		}
		
		private function onMoveItemRsp(msg:SMoveItemRsp):void
		{
			bagWindow.respTips(msg.rsp);
		}
		
		private function onSplitItemRsp(msg:SSplitItemRsp):void
		{
			bagWindow.respTips(msg.rsp);
		}
		
		private function onSortPackRsp(msg:SSortPackRsp):void
		{
			bagWindow.respTips(msg.rsp);
		}
		
		private function onSortDepotRsp(msg:SSortDepotRsp):void
		{
			bagWindow.respTips(msg.rsp);
		}
		
		private function onExpandStorageRsp(msg:SExpandStorageRsp):void
		{
			bagWindow.respTips(msg.rsp);
		}	
		
		/**
		 * 商店出售模式 
		 */		
		private function userSell(e:YFEvent):void
		{
			bagWindow.sellMode(e.param as Boolean);
		}
		
		private function userMend(e:YFEvent):void
		{
			bagWindow.mendMode(e.param as Boolean);
		}
		
		/**
		 * 打开宠物对应面板 
		 * 
		 */		
		private function openPetPanel(e:YFEvent):void
		{
			YFEventCenter.Instance.dispatchEventWith(GlobalEvent.OPEN_PET_PANEL,e.param);
		}
		
		/**
		 * 刷新钱 
		 */		
		private function moneyChange(e:YFEvent):void
		{
			bagWindow.updateMoney();
		}
		
		//======================================================================
		//        getter&setter
		//======================================================================
		
		
	}
} 