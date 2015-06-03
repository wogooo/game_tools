package com.YFFramework.game.core.module.trade.view
{
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.net.loader.image_swf.IconLoader;
	import com.YFFramework.core.utils.common.ClassInstance;
	import com.YFFramework.game.core.global.DataCenter;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.core.global.manager.EquipDyManager;
	import com.YFFramework.game.core.global.manager.PropsDyManager;
	import com.YFFramework.game.core.global.util.DragManager;
	import com.YFFramework.game.core.global.util.NoticeUtil;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.global.util.ZHitTester;
	import com.YFFramework.game.core.global.view.window.WindowTittleName;
	import com.YFFramework.game.core.module.bag.data.BagStoreManager;
	import com.YFFramework.game.core.module.mapScence.manager.RoleDyManager;
	import com.YFFramework.game.core.module.skill.model.DragData;
	import com.YFFramework.game.core.module.trade.events.TradeEvent;
	import com.YFFramework.game.core.module.trade.manager.TradeDyManager;
	import com.YFFramework.game.core.module.trade.view.collection.GridCollection;
	import com.YFFramework.game.core.module.trade.view.render.TradeGrid;
	import com.dolo.ui.controls.Button;
	import com.dolo.ui.controls.Window;
	import com.dolo.ui.tools.AutoBuild;
	import com.dolo.ui.tools.Xdis;
	import com.msg.trade.CDoTradeReq;
	import com.msg.trade.CLockTradeReq;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	/**
	 * @version 1.0.0
	 * creation time：2013-5-2 上午10:01:23
	 * 交易窗口
	 */
	public class TradeWindow extends Window{
		
		private var _mc:MovieClip;
		private var _myGrids:GridCollection;
		private var _otherGrids:GridCollection;
		private var lock_button:Button;
		private var	confirm_button:Button; 
		
		public function TradeWindow(){
			_mc = initByArgument(325,505,"tradePanel",WindowTittleName.tradeTitle) as MovieClip;
			setContentXY(30,35);
			AutoBuild.replaceAll(_mc);
			_mc.tradeBase.input1.restrict = "0-9";
			_mc.tradeBase.input2.restrict = "0-9";
		}

		/**	更新交易面板
		 */		
		public function initTrade():void{
			_myGrids = new GridCollection(true);
			_myGrids.init();
			_myGrids.x = 0;
			_myGrids.y = 266;
			_mc.tradeBase.addChild(_myGrids);
			
			_otherGrids = new GridCollection(false);
			_otherGrids.init();
			_otherGrids.x=0;
			_otherGrids.y=66;
			_mc.tradeBase.addChild(_otherGrids);
			
			_mc.cover1.visible=false;
			_mc.cover2.visible=false;
			_mc.tradeBase.input1.text="";
			_mc.tradeBase.input1.mouseEnabled=true;
			_mc.tradeBase.input1.addEventListener(Event.CHANGE,onDiamondChange);
			_mc.tradeBase.input2.text="";
			_mc.tradeBase.input2.mouseEnabled=true;
//			_mc.tradeBase.input2.addEventListener(Event.CHANGE,onSilverChange);
			_mc.tradeBase.t0.text="";
			_mc.tradeBase.t1.text="";
			
			lock_button = Xdis.getChildAndAddClickEvent(onLock,_mc.tradeBase,"lock_button");
			confirm_button = Xdis.getChildAndAddClickEvent(onConfirm,_mc.tradeBase,"confirm_button");
			confirm_button.enabled=false;
			lock_button.enabled=true;
			
			if(RoleDyManager.Instance.getRole(TradeDyManager.otherDyId)){
				_mc.tradeBase.otherTxt.text = "对方："+RoleDyManager.Instance.getRole(TradeDyManager.otherDyId).roleName;
				_mc.tradeBase.meTxt.text = "自己："+DataCenter.Instance.roleSelfVo.roleDyVo.roleName;
			}else{
				NoticeUtil.setOperatorNotice("交易失败");
				this.close();
			}
		}
		
		/**更新对方道具列表
		 */		
		public function updateOtherGrid():void{
			var itemArr:Array = TradeDyManager.Instance.getOtherLockItem();
			var len:int = itemArr.length;
			for(var i:int=0;i<len;i++){
				_otherGrids.loadGridContent(i,itemArr[i]);
			}
			_mc.cover1.visible=true;
			_mc.cover1.mouseEnabled =false;
			_mc.cover1.mouseChildren=false;
			_mc.tradeBase.t0.text = TradeDyManager.otherDiamond;
			_mc.tradeBase.t1.text = TradeDyManager.otherSilver;
			updateBtn();
		}
		
		/**更新我的道具列表
		 */		
		public function updateMyGrid():void{
			var itemArr:Array = TradeDyManager.Instance.getMyLockItem();
			var len:int = itemArr.length;
			for(var i:int=0;i<len;i++){
				_myGrids.loadGridContent(i,itemArr[i]);
			}
		}

		/**更新按钮状态
		 */		
		public function updateBtn():void{
			if(_mc.cover1.visible && _mc.cover2.visible)	confirm_button.enabled=true;
		}
		
		/**清除最后一个格子的内容
		 */		
		public function clearMyLastGrid():void{
			_myGrids.clearGridContentAt(TradeDyManager.Instance.getMyLockItem().length);
		}
		
		/**清除对象
		 */		
		override public function dispose():void{
			_mc.tradeBase.input1.removeEventListener(Event.CHANGE,onDiamondChange);
//			_mc.tradeBase.input2.removeEventListener(Event.CHANGE,onSilverChange);
			_mc.tradeBase.removeChild(_myGrids);
			_mc.tradeBase.removeChild(_otherGrids);
			_myGrids.dispose();
			_otherGrids.dispose();
			_myGrids = null;
			_otherGrids = null;
			lock_button.removeEventListener(MouseEvent.CLICK,onLock);
			confirm_button.removeEventListener(MouseEvent.CLICK,onConfirm);
			lock_button=null;
			confirm_button=null;
		}
		
		/**背包改变更新
		 */		
		public function onBagChange():void{
			var myItems:Array=TradeDyManager.Instance.getMyLockItem();
			var len:int = myItems.length;
			if(TradeDyManager.isLock==true){
				for(var i:int=0;i<len;i++){
					if(myItems[i].type==TypeProps.ITEM_TYPE_PROPS){
						if(PropsDyManager.instance.getPropsInfo(myItems[i].dyId).quantity!=myItems[i].quantity){
							YFEventCenter.Instance.dispatchEventWith(TradeEvent.CancelTrade);
							break;
						}
					}
				}
			}else{
				for(i=0;i<len;i++){
					if(myItems[i].type==TypeProps.ITEM_TYPE_PROPS){
						if(PropsDyManager.instance.getPropsInfo(myItems[i].dyId).quantity!=myItems[i].quantity){
							myItems[i].quantity = PropsDyManager.instance.getPropsInfo(myItems[i].dyId).quantity;
							_myGrids.loadGridContent(i,myItems[i]);
						}
					}
				}
			}
		}
		
		/**关闭窗口时取消交易 
		 * @param event
		 */		
		override public function close(event:Event=null):void{
			if(TradeDyManager.isTrading==true){
				YFEventCenter.Instance.dispatchEventWith(TradeEvent.CancelTrade);
			}else{
				super.close();
				this.dispose();
			}
		}
		
		/**锁定交易物品 
		 * @param e
		 */		
		private function onLock(e:MouseEvent):void{
			var msg:CLockTradeReq = new CLockTradeReq();
			var itemArr:Array = TradeDyManager.Instance.getMyLockItem();
			var posArr:Array = new Array();
			var len:int = itemArr.length;
			for(var i:int=0;i<len;i++){
				posArr.push(itemArr[i].pos);
			}
			msg.itemPosArray = posArr;
			msg.diamondNum = int(_mc.tradeBase.input1.text);
			msg.silverNum = int(_mc.tradeBase.input2.text);
			if(msg.diamondNum>0 || msg.silverNum >0){
				DataCenter.Instance.roleSelfVo.diamond -= msg.diamondNum;
//				DataCenter.Instance.roleSelfVo.silver -= msg.silverNum;
				YFEventCenter.Instance.dispatchEventWith(GlobalEvent.MoneyChange);
			}
			YFEventCenter.Instance.dispatchEventWith(TradeEvent.LockReq,msg);
			_mc.cover2.visible=true;
			_mc.cover2.mouseEnabled =false;
			_mc.cover2.mouseChildren=false;
			lock_button.enabled=false;
			TradeDyManager.isLock=true;
			TradeDyManager.myDiamond = int(_mc.tradeBase.input1.text);
			TradeDyManager.mySilver = int(_mc.tradeBase.input2.text);
			_mc.tradeBase.input1.mouseEnabled=false;
			_mc.tradeBase.input2.mouseEnabled=false;
			updateBtn();
		}
		
		/**确认交易面板 
		 * @param e
		 */
		private function onConfirm(e:MouseEvent):void{
			if(BagStoreManager.instantce.remainBagNum()+TradeDyManager.Instance.getMyLockItem().length-TradeDyManager.Instance.getOtherLockItem().length<0){
				NoticeUtil.setOperatorNotice("背包空间不足，请先清理一下再交易哦~~");
			}else{
				confirm_button.enabled=false;
				var msg:CDoTradeReq=new CDoTradeReq();
				YFEventCenter.Instance.dispatchEventWith(TradeEvent.ConfirmTradeReq,msg);
			}
		}
		
		/**魔钻输入检查
		 * @param e
		 */		
		private function onDiamondChange(e:Event):void{
			if(int(_mc.tradeBase.input1.text)>DataCenter.Instance.roleSelfVo.diamond){
				_mc.tradeBase.input1.text=DataCenter.Instance.roleSelfVo.diamond;
			}
		}
		
		/**银币改变检查
		 * @param e
		 */		
//		private function onSilverChange(e:Event):void{
//			if(int(_mc.tradeBase.input2.text)>DataCenter.Instance.roleSelfVo.silver){
//				_mc.tradeBase.input2.text=DataCenter.Instance.roleSelfVo.silver;
//			}
//		}
	}
}