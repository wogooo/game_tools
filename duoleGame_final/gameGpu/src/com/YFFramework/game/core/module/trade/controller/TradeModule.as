package com.YFFramework.game.core.module.trade.controller
{
	import com.CMD.GameCmd;
	import com.YFFramework.core.center.abs.module.AbsModule;
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.utils.math.YFMath;
	import com.YFFramework.game.core.global.DataCenter;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.core.global.manager.EquipBasicManager;
	import com.YFFramework.game.core.global.manager.EquipDyManager;
	import com.YFFramework.game.core.global.manager.PropsBasicManager;
	import com.YFFramework.game.core.global.manager.PropsDyManager;
	import com.YFFramework.game.core.global.model.ItemDyVo;
	import com.YFFramework.game.core.global.util.NoticeUtil;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.module.ModuleManager;
	import com.YFFramework.game.core.module.bag.backPack.BagWindow;
	import com.YFFramework.game.core.module.gameView.view.EjectBtnView;
	import com.YFFramework.game.core.module.mapScence.manager.RoleDyManager;
	import com.YFFramework.game.core.module.mapScence.world.model.RoleDyVo;
	import com.YFFramework.game.core.module.system.data.SystemConfigManager;
	import com.YFFramework.game.core.module.trade.events.TradeEvent;
	import com.YFFramework.game.core.module.trade.manager.TradeDyManager;
	import com.YFFramework.game.core.module.trade.model.LockItemDyVo;
	import com.YFFramework.game.core.module.trade.view.TradeAlert;
	import com.YFFramework.game.core.module.trade.view.TradeInviteWindow;
	import com.YFFramework.game.core.module.trade.view.TradeWindow;
	import com.dolo.ui.managers.UIManager;
	import com.msg.trade.*;
	import com.net.MsgPool;

	/**
	 * @version 1.0.0
	 * creation time：2013-4-28 下午4:06:31
	 * 
	 */
	public class TradeModule extends AbsModule{
		
		public var _tradeWindow:TradeWindow;
		private var _inviteWindow:TradeInviteWindow;
		
		public function TradeModule(){
			_tradeWindow = new TradeWindow();
			_inviteWindow = new TradeInviteWindow();

		}
		
		override public function init():void{
			addEvents();
			addSocketCallback();
		}
		
		private function addEvents():void{
			YFEventCenter.Instance.addEventListener(GlobalEvent.TradeUIClick,onTradeUIClick);		//打开交易邀请面板
			YFEventCenter.Instance.addEventListener(GlobalEvent.MoveToTrade,onMoveToTrade);			//背包东西点击到交易面板
			YFEventCenter.Instance.addEventListener(GlobalEvent.MoveToBagSuccess,onMoveToBag);		//交易面板拖动物品到背包
			YFEventCenter.Instance.addEventListener(GlobalEvent.BagChange,onBagChange);				//背包改变通知
			YFEventCenter.Instance.addEventListener(GlobalEvent.ToTrade,tradeInviteReq);			//交易邀请请求
			YFEventCenter.Instance.addEventListener(GlobalEvent.CancelTrade,cancelTradeReq);		//距离太远取消交易
			YFEventCenter.Instance.addEventListener(TradeEvent.AcceptTrade,acceptTradeReq);			//同意交易请求
			YFEventCenter.Instance.addEventListener(TradeEvent.CancelTrade,cancelTradeReq);			//取消交易请求
			YFEventCenter.Instance.addEventListener(TradeEvent.LockReq,lockReq);					//锁定物品请求
			YFEventCenter.Instance.addEventListener(TradeEvent.ConfirmTradeReq,confirmTradeReq);	//确认交易请求
		}
		
		private function addSocketCallback():void{
			MsgPool.addCallBack(GameCmd.STradeNotify,STradeNotify,onTradeResp);						//交易请求回复
			MsgPool.addCallBack(GameCmd.SAcceptTradeResp,SAcceptTradeResp,onAcceptTradeResp);		//同意交易回复
			MsgPool.addCallBack(GameCmd.SAcceptTradeNotify,SAcceptTradeNotify,onAcceptTradeNotify);	//对方同意交易回复
			MsgPool.addCallBack(GameCmd.SCancelTradeNotify,SCancelTradeNotify,onCancelTradeResp);	//取消交易回复
			MsgPool.addCallBack(GameCmd.SLockTradeNotify,SLockTradeNotify,onLockResp);				//对方锁定物品回复
			MsgPool.addCallBack(GameCmd.SFinishTrade,SFinishTrade,onFinishTradeResp);				//完成交易回复
		}
		
		/**完成交易回复
		 * @param msg	收到的协议
		 */		
		private function onFinishTradeResp(msg:SFinishTrade):void{
			NoticeUtil.setOperatorNotice("交易成功！！！");
			var otherItems:Array = TradeDyManager.Instance.getOtherLockItem();
			var len:int = otherItems.length;
			for(var i:int=0;i<len;i++){
				var name:String;
				if(otherItems[i].type==TypeProps.ITEM_TYPE_EQUIP){
					name=EquipBasicManager.Instance.getEquipBasicVo(otherItems[i].templateId).name;
				}else{
					name=PropsBasicManager.Instance.getPropsBasicVo(otherItems[i].templateId).name;
				}
				NoticeUtil.setOperatorNotice("恭喜你，获得物品【"+name+"】");
			}
			var myItems:Array = TradeDyManager.Instance.getMyLockItem();
			len=myItems.length;
			for(i=0;i<len;i++){
				if(myItems[i].type==TypeProps.ITEM_TYPE_EQUIP){
					name=EquipBasicManager.Instance.getEquipBasicVo(myItems[i].templateId).name;
				}else{
					name=PropsBasicManager.Instance.getPropsBasicVo(myItems[i].templateId).name;
				}
				NoticeUtil.setOperatorNotice("物品【"+name+"】已转移");
			}
			if(TradeDyManager.otherDiamond>0)	NoticeUtil.setOperatorNotice("恭喜你，获得魔钻【"+TradeDyManager.otherDiamond+"】");
			if(TradeDyManager.otherSilver>0)	NoticeUtil.setOperatorNotice("恭喜你，获得银币【"+TradeDyManager.otherSilver+"】");
			if(TradeDyManager.myDiamond>0)	NoticeUtil.setOperatorNotice("魔钻【"+TradeDyManager.myDiamond+"】已转移");
			if(TradeDyManager.mySilver>0)	NoticeUtil.setOperatorNotice("银币【"+TradeDyManager.mySilver+"】已转移");
			TradeDyManager.Instance.clearTradeInfo();
			
			_tradeWindow.close();
		}
		
		/**背包数量改变更新；如果已经锁定物品，发送取消交易；如果还没锁定，更新界面
		 * @param e	收到的背包数量改变更新事件通知
		 */		
		private function onBagChange(e:YFEvent):void{
			_tradeWindow.onBagChange();
		}
		
		/**物品移回背包回复
		 * @param e	收到的物品移回背包回复事件通知
		 */		
		private function onMoveToBag(e:YFEvent):void{
			TradeDyManager.Instance.removeFromMyLockItem((e.param) as int);
			_tradeWindow.updateMyGrid();
			_tradeWindow.clearMyLastGrid();
		}
		
		/**背包物品单击移动到交易面板
		 * @param e 收到的背包物品单击移动到交易面板回复事件通知
		 */		
		private function onMoveToTrade(e:YFEvent):void{
			if(TradeDyManager.Instance.getMyLockItem().length==21){
				NoticeUtil.setOperatorNotice("交易面板已满");
			}else if(TradeDyManager.isLock==true){
				NoticeUtil.setOperatorNotice("交易面板已锁定");
			}else{
				var item:ItemDyVo = e.param as ItemDyVo;
				var itemDyVo:LockItemDyVo = new LockItemDyVo();
				itemDyVo.type = item.type;
				itemDyVo.pos = item.pos;
				itemDyVo.dyId = item.id;
				if(itemDyVo.type == TypeProps.ITEM_TYPE_PROPS){
					itemDyVo.templateId = PropsDyManager.instance.getPropsInfo(itemDyVo.dyId).templateId;
					itemDyVo.quantity = PropsDyManager.instance.getPropsInfo(itemDyVo.dyId).quantity;
					itemDyVo.url = PropsBasicManager.Instance.getURL(itemDyVo.templateId);
				}else{
					itemDyVo.templateId = EquipDyManager.instance.getEquipInfo(itemDyVo.dyId).template_id;
					itemDyVo.quantity=1;
					itemDyVo.url = EquipBasicManager.Instance.getURL(itemDyVo.templateId);
				}
				
				TradeDyManager.Instance.addToMyLockItem(itemDyVo);
				_tradeWindow.updateMyGrid();
				YFEventCenter.Instance.dispatchEventWith(GlobalEvent.LockItem,itemDyVo.pos);
				YFEventCenter.Instance.dispatchEventWith(GlobalEvent.BagChange);
			}
		}
		
		/**对方锁定物品回复 
		 * @param msg	收到的协议
		 */		
		private function onLockResp(msg:SLockTradeNotify):void{
			var itemDyVo:LockItemDyVo;
			var len:int;
			if(msg.propsArray){
				len=msg.propsArray.length;
				for(var i:int=0;i<len;i++){
					itemDyVo = new LockItemDyVo();
					itemDyVo.templateId = msg.propsArray[i].templateId;
					itemDyVo.quantity = msg.propsArray[i].quantity;
					itemDyVo.type = TypeProps.ITEM_TYPE_PROPS;
					itemDyVo.url = PropsBasicManager.Instance.getURL(itemDyVo.templateId);
					TradeDyManager.Instance.addToOtherLockItem(itemDyVo);
				}
			}
			if(msg.equipArray){
				len=msg.equipArray.length;
				EquipDyManager.instance.setEquipInfo(msg.equipArray);
				for(i=0;i<len;i++){
					itemDyVo = new LockItemDyVo();
					itemDyVo.dyId = msg.equipArray[i].equipId;
					itemDyVo.templateId = msg.equipArray[i].templateId;
					itemDyVo.quantity = 1;
					itemDyVo.type = TypeProps.ITEM_TYPE_EQUIP;
					itemDyVo.url = EquipBasicManager.Instance.getURL(itemDyVo.templateId);
					TradeDyManager.Instance.addToOtherLockItem(itemDyVo);
				}
			}
			TradeDyManager.otherDiamond = msg.diamondNum;
			TradeDyManager.otherSilver = msg.silverNum;
			_tradeWindow.updateOtherGrid();
		}
		
		/**取消交易回复
		 * @param msg	收到的协议
		 */		
		private function onCancelTradeResp(msg:SCancelTradeNotify):void{
			if(TradeDyManager.myDiamond>0 || TradeDyManager.mySilver>0){
				DataCenter.Instance.roleSelfVo.diamond += TradeDyManager.myDiamond;
//				DataCenter.Instance.roleSelfVo.silver += TradeDyManager.mySilver;
				YFEventCenter.Instance.dispatchEventWith(GlobalEvent.MoneyChange);
			}
			var otherItemArr:Array = TradeDyManager.Instance.getOtherLockItem();
			var len:int = otherItemArr.length;
			for(var i:int=0;i<len;i++){
				if(otherItemArr[i].type==TypeProps.ITEM_TYPE_EQUIP){
					EquipDyManager.instance.delEquip(otherItemArr[i].templateId);
				}
			}
			TradeDyManager.Instance.clearTradeInfo();
			_tradeWindow.close();
			NoticeUtil.setOperatorNotice("交易失败");
		}
		
		/**同意交易信息回复
		 * @param msg	收到的协议
		 */
		private function onAcceptTradeResp(msg:SAcceptTradeResp):void{
			if(msg.rsp==TypeProps.RSPMSG_IN_TRADING){
				NoticeUtil.setOperatorNotice("对方正在交易中。。。");
			}else if(msg.rsp==TypeProps.RSPMSG_TRADE_OFFLINE){
				NoticeUtil.setOperatorNotice("对方已离线。。。");
			}else if(msg.rsp==TypeProps.RSPMSG_TRADE_OUT_RANGE){
				NoticeUtil.setOperatorNotice("对方离开了可交易范围。。。");
			}else{				
				TradeDyManager.isTrading = true;
				TradeDyManager.otherDyId = msg.otherId;
				var bagWin:BagWindow = ModuleManager.bagModule.getBagWin();
				bagWin.open();
//				bagWin.beforeOpenBag();
//				bagWin.lockMode();
				_tradeWindow.open();
				UIManager.centerMultiWindows(_tradeWindow,bagWin);
				_tradeWindow.switchToTop();
				_tradeWindow.initTrade();
			}
		}
		
		/**对方同意交易通知回复 
		 * @param msg	收到的协议
		 */		
		private function onAcceptTradeNotify(msg:SAcceptTradeNotify):void{
			TradeDyManager.isTrading = true;
			TradeDyManager.otherDyId = msg.otherId;
			var bagWin:BagWindow = ModuleManager.bagModule.getBagWin();
			bagWin.open();
//			bagWin.beforeOpenBag();
//			bagWin.lockMode();
			_tradeWindow.open();
			UIManager.centerMultiWindows(_tradeWindow,bagWin);
			_tradeWindow.switchToTop();
			_tradeWindow.initTrade();
		}
		
		/**交易回复
		 * @param msg	收到的协议
		 */		
		private function onTradeResp(msg:STradeNotify):void{
			if(SystemConfigManager.rejectTrade==false){
				TradeDyManager.Instance.addToTradeList(msg.otherId);
				if(_inviteWindow.isOpen)	_inviteWindow.updateList();
				else	YFEventCenter.Instance.dispatchEventWith(GlobalEvent.DisplayBtn,EjectBtnView.RequestTrade);
			}
		}
		
		/**打开交易弹出按钮；如果只有一个邀请，弹出Alert；如果多于1个，弹出列表 
		 * @param e
		 */		
		private function onTradeUIClick(e:YFEvent):void{
			if(TradeDyManager.Instance.getTradeList().length==1){
				var tradeAlert:TradeAlert = new TradeAlert();
				tradeAlert.open();
				tradeAlert.update();
			}else{
				_inviteWindow.open();
				_inviteWindow.updateList();
			}
			YFEventCenter.Instance.dispatchEventWith(GlobalEvent.RemoveEjectBtn,EjectBtnView.RequestTrade);
		}
		
		/**交易邀请请求
		 * @param e 收到的交易邀请请求事件通知
		 */		
		private function tradeInviteReq(e:YFEvent):void{
			if(TradeDyManager.isTrading){
				NoticeUtil.setOperatorNotice("你已在交易中，无法发出交易邀请");
			}else{
				var role:RoleDyVo = RoleDyManager.Instance.getRole(e.param as int);
				if(role){
					if(YFMath.distance(role.mapX,role.mapY,DataCenter.Instance.roleSelfVo.roleDyVo.mapX,DataCenter.Instance.roleSelfVo.roleDyVo.mapY)>160){
						NoticeUtil.setOperatorNotice("距离太远，无法交易");
					}else{
						NoticeUtil.setOperatorNotice("已邀请【"+role.roleName+"】进行交易");
						var msg:CTradeReq = new CTradeReq();
						msg.otherId = role.dyId;
						MsgPool.sendGameMsg(GameCmd.CTradeReq,msg);
					}
				}else{
					NoticeUtil.setOperatorNotice("邀请失败，对方已离开");
				}
			}
		}
		
		/**确认交易请求 
		 * @param e	收到的确认交易请求事件通知
		 */	
		private function confirmTradeReq(e:YFEvent):void{
			MsgPool.sendGameMsg(GameCmd.CDoTradeReq,e.param as CDoTradeReq);
		}
		
		/**锁定物品请求 
		 * @param e	收到的锁定物品请求事件通知
		 */		
		private function lockReq(e:YFEvent):void{
			MsgPool.sendGameMsg(GameCmd.CLockTradeReq,(e.param) as CLockTradeReq);
		}
		
		/**同意交易请求 
		 * @param e 收到的同意交易请求事件通知
		 */
		private function acceptTradeReq(e:YFEvent):void{
			MsgPool.sendGameMsg(GameCmd.CAcceptTradeReq,(e.param) as CAcceptTradeReq);
		}
		
		/**取消交易请求 
		 * @param e 收到的同意交易请求事件通知
		 */
		private function cancelTradeReq(e:YFEvent):void{
			MsgPool.sendGameMsg(GameCmd.CCancelTradeReq,new CCancelTradeReq());
		}
	}
} 