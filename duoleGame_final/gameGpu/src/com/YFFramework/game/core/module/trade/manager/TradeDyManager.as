package com.YFFramework.game.core.module.trade.manager
{
	import com.YFFramework.game.core.module.ModuleManager;
	import com.YFFramework.game.core.module.mapScence.manager.RoleDyManager;
	import com.YFFramework.game.core.module.trade.model.LockItemDyVo;
	import com.YFFramework.game.core.module.trade.model.TradeInviteDyVo;

	/**
	 * @version 1.0.0
	 * creation time：2013-4-28 下午4:07:47
	 * 
	 */
	public class TradeDyManager{
		
		private static var instance:TradeDyManager;
		public static var isTrading:Boolean=false;
		public static var otherDyId:int=-1;	//-1为没有交易对象
		public static var isLock:Boolean=false;
		public static var myDiamond:int;
		public static var mySilver:int;
		public static var otherDiamond:int;
		public static var otherSilver:int;
		private var _tradeList:Array;
		private var _myLockItems:Array;
		private var _otherLockItems:Array;
		
		public function TradeDyManager(){
			_tradeList = new Array();
			_myLockItems = new Array();
			_otherLockItems = new Array();
		}
		
		/**添加到邀请交易列表 
		 * @param dyId 邀请玩家的dyId
		 */
		public function addToTradeList(dyId:int):void{
			delFromTrade(dyId);
			if(_tradeList.length==20)	_tradeList.shift();
			
			var tradeDyVo:TradeInviteDyVo=new TradeInviteDyVo();;
			tradeDyVo.dyId = dyId;
			tradeDyVo.name = RoleDyManager.Instance.getRole(dyId).roleName;
			tradeDyVo.lv = RoleDyManager.Instance.getRole(dyId).level;
			_tradeList.push(tradeDyVo);
		}
		
		/**从邀请交易列表中删除该邀请 
		 * @param dyId	邀请玩家的dyId
		 */		
		public function delFromTrade(dyId:int):void{
			var len:int = _tradeList.length;
			for(var i:int=0;i<len;i++){
				if(_tradeList[i].dyId==dyId){
					_tradeList.splice(i,1);
					break;
				}
			}
		}
		
		/**清空交易邀请列表 
		 */		
		public function emptyTradeList():void{
			_tradeList.splice(0);
		}
		
		/**获得交易邀请列表 
		 * @return Array	交易邀请列表
		 */		
		public function getTradeList():Array{
			return _tradeList;
		}
		
		/**获得对方锁定物品列表 
		 * @return Array	对方的锁定的物品列表
		 */		
		public function getOtherLockItem():Array{
			return _otherLockItems;
		}
		
		/**添加道具到对方的锁定物品列表
		 * @param itemDyVo 对方的锁定的LockItemDyVo
		 */		
		public function addToOtherLockItem(itemDyVo:LockItemDyVo):void{
			_otherLockItems.push(itemDyVo);
		}
		
		/**清空对方锁定物品的列表
		 */		
		public function emptyOtherLockItem():void{
			_otherLockItems.splice(0);
		}
		
		/**获取我的锁定物品列表 
		 * @return Array	我的锁定的物品列表
		 */		
		public function getMyLockItem():Array{
			return _myLockItems;
		}
		
		/**添加道具到我的锁定物品列表 
		 * @param itemDyVo	LockItemDyVo
		 */		
		public function addToMyLockItem(itemDyVo:LockItemDyVo):void{
			_myLockItems.push(itemDyVo);
		}
		
		/**从锁定物品列表中移除 
		 * @param itemDyVo	要移除的item
		 */		
		public function removeFromMyLockItem(pos:int):void{
			var len:int = _myLockItems.length;
			for(var i:int=0;i<len;i++){
				if(_myLockItems[i].pos==pos){
					_myLockItems.splice(i,1);
					break;
				}
			}
		}
		
		/**把我锁定的物品列表清空
		 */		
		public function emptyMyLockItems():void{
			_myLockItems.splice(0);
		}
		
		/**获取我的锁定物品的指定道具的数量之和 
		 * @param templateId1	指定道具的静态id
		 * @return int	指定道具的数量之和
		 */		
		public function getLockItemQuantity(templateId:int):int{
			var num:int = 0;
			var len:int=_myLockItems.length;
			for(var i:int=0;i<len;i++){
				if(_myLockItems[i].templateId==templateId)	num+=_myLockItems[i].quantity;
			}
			return num;
		}
		
		/**查看道具是否锁定 
		 * @param propsDyId	道具的动态id
		 * @return Boolean	锁定：true;不锁定：false;
		 */		
		public function isLockItem(dyId:int,type:int):Boolean{
			var len:int=_myLockItems.length;
			for(var i:int=0;i<len;i++){
				if(_myLockItems[i].dyId==dyId && _myLockItems[i].type==type)	return true;
			}
			return false;
		}
		
		/**清除交易状态
		 */		
		public function clearTradeInfo():void{
			isTrading=false;
			isLock=false;
			otherDyId=-1;
			ModuleManager.bagModule.getBagWin().lockMode();
			myDiamond=0;
			mySilver=0;
			otherDiamond=0;
			otherSilver=0;
			emptyMyLockItems();
			emptyOtherLockItem();
		}
		
		public static function get Instance():TradeDyManager{
			return instance ||= new TradeDyManager();
		}
	}
}