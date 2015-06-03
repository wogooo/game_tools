package com.YFFramework.game.core.module.market.data.manager
{
	import com.YFFramework.game.core.global.model.EquipDyVo;
	import com.YFFramework.game.core.global.model.PropsDyVo;
	import com.YFFramework.game.core.module.market.data.vo.MarketRecord;
	import com.YFFramework.game.core.module.market.source.MarketSource;
	import com.msg.market_pro.MyRecord;
	import com.msg.market_pro.Record;

	/**
	 * @version 1.0.0
	 * creation time：2013-6-5 下午2:13:16
	 * 
	 */
	public class MarketDyManager
	{
		//======================================================================
		//       public property
		//======================================================================
		
		//======================================================================
		//       private property
		//======================================================================
		private static var _instance:MarketDyManager;
		
		private var _consignAry:Array;
		private var _purchaseAry:Array;
		
		private var _myConsignList:Vector.<MarketRecord>;
		private var _myPurchaseList:Vector.<MarketRecord>;
		
		private var _myLogList:Array;
		
		private var _myConsignItemsNum:int;
		private var _myPurchaseItemsNum:int;
		//======================================================================
		//        constructor
		//======================================================================
		
		public function MarketDyManager()
		{
		}
		
		//======================================================================
		//        public function
		//======================================================================
		public static function get instance():MarketDyManager
		{
			if(_instance == null)
			{
				_instance=new MarketDyManager();
			}
			return _instance;
		}
		
		public function setConsignPurchaseList(type:int,list:Array):void
		{
			if(type == MarketSource.CONSIGH)
				_consignAry=[];
			else
				_purchaseAry=[];
			
			for each(var record:Record in list)
			{
				var mRec:MarketRecord=new MarketRecord();
				
				mRec.recordId=record.recordId;
				mRec.price=record.unitPrice;
				mRec.number=record.number;
				mRec.moneyType=record.priceType;
				mRec.playerName=record.playerName;
				
				if(record.hasEquip)
				{
					mRec.equip=new EquipDyVo();
					mRec.equip.equip_id=record.equip.equipId;
					mRec.equip.template_id=record.equip.templateId;
					mRec.equip.binding_type=record.equip.bindingAttr;
					mRec.equip.cur_durability=record.equip.curDurability;
					mRec.equip.enhance_level=record.equip.enhanceLevel;
					mRec.equip.obtain_time=record.equip.obtainTime;
					mRec.equip.gem_1_id=record.equip.gem_1Id;
					mRec.equip.gem_2_id=record.equip.gem_2Id;
					mRec.equip.gem_3_id=record.equip.gem_3Id;
					mRec.equip.gem_4_id=record.equip.gem_4Id;
					mRec.equip.gem_5_id=record.equip.gem_5Id;
					mRec.equip.gem_6_id=record.equip.gem_6Id;
					mRec.equip.gem_7_id=record.equip.gem_7Id;
					mRec.equip.gem_8_id=record.equip.gem_8Id;
				}
				else if(record.hasProp)
				{
					mRec.props=new PropsDyVo();
					mRec.props.propsId=record.prop.propsId;
					mRec.props.templateId=record.prop.templateId;
					mRec.props.quantity=record.prop.quantity;
					mRec.props.obtain_time=record.prop.obtainTime;
				}
				if(record.hasItemType && record.hasItemTmplId)
				{
					mRec.itemType=record.itemType;
					mRec.itemId=record.itemTmplId;
				}
				else if(record.hasSaleMoneyType)
				{
					mRec.saleMoneyType=record.saleMoneyType;
				}
				
				if(type == MarketSource.CONSIGH)
					_consignAry.push(mRec);
				else
					_purchaseAry.push(mRec);
			}
			
		}
		
		public function getCurPageConsignList():Array
		{
			return _consignAry;
		}
		
		public function getCurPagePurchaseList():Array
		{
			return _purchaseAry;
		}
		
		public function setMyConsignPurchaseList(type:int,list:Array):void
		{
			if(type == MarketSource.CONSIGH)
			{
				_myConsignList=new Vector.<MarketRecord>();
				myConsignItemsNum=list.length;
			}
			else if(type == MarketSource.PURCHASE)
			{
				_myPurchaseList=new Vector.<MarketRecord>();
				myPurchaseItemsNum=list.length;
			}
			else
				_myLogList=[];
			
			for each(var record:MyRecord in list)
			{
				var mRec:MarketRecord=new MarketRecord();
				mRec.recordId=record.recordId;
				if(record.hasEquip)
				{
					mRec.equip=new EquipDyVo();
					mRec.equip.equip_id=record.equip.equipId;
					mRec.equip.template_id=record.equip.templateId;
					mRec.equip.binding_type=record.equip.bindingAttr;
					mRec.equip.cur_durability=record.equip.curDurability;
					mRec.equip.enhance_level=record.equip.enhanceLevel;
					mRec.equip.obtain_time=record.equip.obtainTime;
					mRec.equip.gem_1_id=record.equip.gem_1Id;
					mRec.equip.gem_2_id=record.equip.gem_2Id;
					mRec.equip.gem_3_id=record.equip.gem_3Id;
					mRec.equip.gem_4_id=record.equip.gem_4Id;
					mRec.equip.gem_5_id=record.equip.gem_5Id;
					mRec.equip.gem_6_id=record.equip.gem_6Id;
					mRec.equip.gem_7_id=record.equip.gem_7Id;
					mRec.equip.gem_8_id=record.equip.gem_8Id;
				}
				else if(record.hasProp)
				{
					mRec.props=new PropsDyVo();
					mRec.props.propsId=record.prop.propsId;
					mRec.props.templateId=record.prop.templateId;
					mRec.props.quantity=record.prop.quantity;
					mRec.props.obtain_time=record.prop.obtainTime;
				}
				else if(record.hasItemType && record.hasItemTmplId)
				{
					mRec.itemType=record.itemType;
					mRec.itemId=record.itemTmplId;
				}
				else if(record.hasSaleMoneyType)
				{
					mRec.saleMoneyType=record.saleMoneyType;
				}
				
				mRec.number=record.number;
				mRec.price=record.unitPrice;
				mRec.moneyType=record.priceType;
				mRec.saleTime=record.saleTime;
				mRec.status=record.status;
				
				if(type == MarketSource.CONSIGH)
					_myConsignList.push(mRec);
				else if(type == MarketSource.PURCHASE)
					_myPurchaseList.push(mRec);
				else
					_myLogList.push(mRec);
			}
		}
		
		public function getMyConsignList():Vector.<MarketRecord>
		{
			return _myConsignList;
		}
		
		public function getMyPurchaseList():Vector.<MarketRecord>
		{
			return _myPurchaseList;
		}
		
		public function getCurPageMyLogList():Array
		{
			return _myLogList;
		}

		public function get myConsignItemsNum():int
		{
			return _myConsignItemsNum;
		}

		public function set myConsignItemsNum(value:int):void
		{
			_myConsignItemsNum = value;
		}

		public function get myPurchaseItemsNum():int
		{
			return _myPurchaseItemsNum;
		}

		public function set myPurchaseItemsNum(value:int):void
		{
			_myPurchaseItemsNum = value;
		}

		public function delMyConsign(recordId:int):void
		{
			var len:int=_myConsignList.length;
			for(var i:int=0;i<len;i++)
			{
				if(_myConsignList[i].recordId == recordId)
				{
					_myConsignList.splice(i,1);
					myConsignItemsNum=_myConsignList.length;
					break;
				}
			}
		}
		
		public function delMyPurchase(recordId:int):void
		{
			var len:int=_myPurchaseList.length;
			for(var i:int=0;i<len;i++)
			{
				if(_myPurchaseList[i].recordId == recordId)
				{
					_myPurchaseList.splice(i,1);
					myPurchaseItemsNum=_myPurchaseList.length;
					break;
				}
			}
		}
		
		//======================================================================
		//        private function
		//======================================================================
		
		//======================================================================
		//        event handler
		//======================================================================
		
		//======================================================================
		//        getter&setter
		//======================================================================
		
		
	}
} 