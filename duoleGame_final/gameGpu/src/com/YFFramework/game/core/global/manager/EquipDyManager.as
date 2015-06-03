package com.YFFramework.game.core.global.manager
{
	import com.YFFramework.game.core.global.model.EquipBasicVo;
	import com.YFFramework.game.core.global.model.EquipDyVo;
	import com.YFFramework.game.core.global.model.ItemDyVo;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.module.bag.data.BagStoreManager;
	import com.YFFramework.game.core.module.bag.data.BagTimerManager;
	import com.msg.item.CharacterEquip;
	
	import flash.utils.Dictionary;

	/**
	 * @version 1.0.0
	 * creation time：2013-3-14 上午11:38:47
	 * 
	 */
	public class EquipDyManager
	{
		//======================================================================
		//       public property
		//======================================================================
		
		//======================================================================
		//       private property
		//======================================================================
		private static var _instance:EquipDyManager;
		
		private var equipList:Dictionary;
		
		/** 身上必须要有的八件装备（用于强化等级激活） */		
//		private const SUIT_ID:Array=[1,2,3,4,5,6,7,8];
		private const SUIT_NONE:int=0;
		private const SUIT_FIVE:int=5;
		private const SUIT_NINE:int=9;
		private const SUIT_TWELVE:int=12;
		//======================================================================
		//        constructor
		//======================================================================
		
		public function EquipDyManager()
		{
			equipList=new Dictionary();
		}
		
		//======================================================================
		//        public function
		//======================================================================
		public static function get instance():EquipDyManager
		{
			if(_instance == null)
				_instance=new EquipDyManager();
			return _instance;
		}
		
		/**
		 * 返回服务器发来的装备列表，不包括详细信息 
		 * @param equipId 动态（唯一）id
		 * @return CharacterEquip->equip_id,template_id,binding_attr,cur_durability,enhance_level,gem_1_id……gem_8_id,obtain_time
		 * 
		 */		
		public function getEquipInfo(equipId:int):EquipDyVo
		{
			return equipList[equipId];
		}
		
		public function setEquipInfo(equips:Array):void
		{
			for(var i:int=0;i<equips.length;i++)
			{
				var equip:EquipDyVo=new EquipDyVo();
				equip.equip_id=(equips[i] as CharacterEquip).equipId;
				equip.template_id=(equips[i] as CharacterEquip).templateId;
				equip.binding_type=(equips[i] as CharacterEquip).bindingAttr;
				equip.cur_durability=(equips[i] as CharacterEquip).curDurability;
				equip.enhance_level=(equips[i] as CharacterEquip).enhanceLevel;
				equip.gem_1_id=(equips[i] as CharacterEquip).gem_1Id;
				equip.gem_2_id=(equips[i] as CharacterEquip).gem_2Id;
				equip.gem_3_id=(equips[i] as CharacterEquip).gem_3Id;
				equip.gem_4_id=(equips[i] as CharacterEquip).gem_4Id;
				equip.gem_5_id=(equips[i] as CharacterEquip).gem_5Id;
				equip.gem_6_id=(equips[i] as CharacterEquip).gem_6Id;
				equip.gem_7_id=(equips[i] as CharacterEquip).gem_7Id;
				equip.gem_8_id=(equips[i] as CharacterEquip).gem_8Id;
				equip.obtain_time=(equips[i] as CharacterEquip).obtainTime;
				
				equip.app_attr_t1=(equips[i] as CharacterEquip).appAttrT1;
				equip.app_attr_v1=Math.ceil((equips[i] as CharacterEquip).appAttrV1);
				equip.app_attr_color1=(equips[i] as CharacterEquip).appAttrC1;
				equip.app_attr_lock1=(equips[i] as CharacterEquip).appAttrL1;
				
				equip.app_attr_t2=(equips[i] as CharacterEquip).appAttrT2;
				equip.app_attr_v2=Math.ceil((equips[i] as CharacterEquip).appAttrV2);
				equip.app_attr_color2=(equips[i] as CharacterEquip).appAttrC2;
				equip.app_attr_lock2=(equips[i] as CharacterEquip).appAttrL2;
				
				equip.app_attr_t3=(equips[i] as CharacterEquip).appAttrT3;
				equip.app_attr_v3=Math.ceil((equips[i] as CharacterEquip).appAttrV3);
				equip.app_attr_color3=(equips[i] as CharacterEquip).appAttrC3;
				equip.app_attr_lock3=(equips[i] as CharacterEquip).appAttrL3;
				
				equip.app_attr_t4=(equips[i] as CharacterEquip).appAttrT4;
				equip.app_attr_v4=Math.ceil((equips[i] as CharacterEquip).appAttrV4);
				equip.app_attr_color4=(equips[i] as CharacterEquip).appAttrC4;
				equip.app_attr_lock4=(equips[i] as CharacterEquip).appAttrL4;
				
				equip.deft_lock_num=(equips[i] as CharacterEquip).deftLockNum;
				equip.star=(equips[i] as CharacterEquip).star;
				equipList[equip.equip_id]=equip;
				
				//加入时效性装备的处理
				var eBsVo:EquipBasicVo = EquipBasicManager.Instance.getEquipBasicVo(equip.template_id);
				if(equip.obtain_time > 0 || eBsVo.remain_time > 0)
					BagTimerManager.instance.addTimer(TypeProps.ITEM_TYPE_EQUIP,equip.equip_id);
			}
		}
		
		public function delEquip(equipId:int):void
		{
			if(equipList[equipId])
			{
				equipList[equipId]=null;
				delete equipList[equipId];
			}
		}
		
		public function getAllEquips():Array
		{
			var equips:Array=[];
			for each(var equip:EquipDyVo in equipList)
			{
				equips.push(equip);
			}
			return equips;
		}
		
		/**
		 * 给定装备的动态id，返回在背包的位置，0代表没有这个装备 
		 * @param equipId
		 * @return 
		 * 
		 */		
		public function getEquipPosFromBag(equipId:int):int
		{
			var packAry:Array=BagStoreManager.instantce.getAllPackArray();
			
			for each(var item:ItemDyVo in packAry)
			{
				if(item.type == TypeProps.ITEM_TYPE_EQUIP)
				{
					if(item.id == equipId)
						return item.pos;
				}
			}
			return 0;
		}

		/**
		 * 返回在仓库的位置 
		 * @param equipId
		 * @return 
		 * 
		 */		
		public function getEquipPosFromDepot(equipId:int):int
		{
			var depotArr:Array=BagStoreManager.instantce.getAllDepotArray();
			
			for each(var item:ItemDyVo in depotArr)
			{
				if(item.type == TypeProps.ITEM_TYPE_EQUIP)
				{
					if(item.id == equipId)
						return item.pos;
				}
			}
			return 0;
		}
		
		/**
		 * 返回人物身上指定的装备位置 
		 * @param equipId
		 * @return 
		 * 
		 */		
		public function getEquipPosFromRole(equipId:int):int
		{
			var roleArr:Array=CharacterDyManager.Instance.getAllEquips();
			
			for each(var equip:EquipDyVo in roleArr)
			{
				if(equip.equip_id == equipId)
					return equip.position;
			}
			
			return 0;
		}

		/**
		 * 用模板id在背包里寻找，并且返回位置
		 * @param templateId
		 * @return 
		 * 
		 */		
		public function getEquipPosFromBagByTemplateId(templateId:int):int
		{
			var packAry:Array=BagStoreManager.instantce.getAllPackArray();
			
			for each(var item:ItemDyVo in packAry)
			{
				if(item.type == TypeProps.ITEM_TYPE_EQUIP)
				{
					var dyVo:EquipDyVo=getEquipInfo(item.id);
					if(dyVo.template_id == templateId && dyVo.binding_type != TypeProps.BIND_TYPE_YES)
					{
						return item.pos;
					}
				}
			}
			return 0;
		}

		/** 通过一套装备，算出总体强化加成（就是强化星星的显示）
		 * @param equips
		 * @return 只返回1、2、3，代表显示几个星星;0表示没有强化加成
		 */		
		public function getTotalStrengthenAddition(equips:Array):int
		{
			if(equips.length >= 8)//大概排除身上没穿够装备的情况
			{
				var bsVo:EquipBasicVo;
				var tmpEquips:Array=[];
				for each(var dyVo:EquipDyVo in equips)
				{
					bsVo=EquipBasicManager.Instance.getEquipBasicVo(dyVo.template_id);
					if(bsVo.type != TypeProps.EQUIP_TYPE_WINGS && bsVo.quality >= TypeProps.QUALITY_PURPLE)
					{
						tmpEquips.push(dyVo);
					}
						
				}
				if(tmpEquips.length == 8)//排除身上有没有指定的八件
				{
					var strengths1:Array=[];
					var strengths2:Array=[];
					var strengths3:Array=[];
					for each(dyVo in tmpEquips)
					{
						if(dyVo.enhance_level >= SUIT_FIVE)
							strengths1.push(SUIT_FIVE);
						if(dyVo.enhance_level >= SUIT_NINE)
							strengths2.push(SUIT_NINE);
						if(dyVo.enhance_level == SUIT_TWELVE)
							strengths3.push(SUIT_TWELVE);
					}
					if(strengths3.length == 8)
						return 3;
					else if(strengths2.length == 8)
						return 2;
					else if(strengths1.length == 8)
						return 1;
					else
						return 0;
				}
				else
					return 0;
			}
			else
				return 0;
		}
		
		/** 根据装备强化等级，返回强化百分比
		 * @return 
		 */		
		public function getEquipStrengthenIncrement(level:int):Number
		{
			var radio:Number;
			switch(level)
			{
				case 0:
					radio=1;
					break;
				case 1:
					radio=1.15;
					break;
				case 2:
					radio=1.30;
					break;
				case 3:
					radio=1.45;
					break;
				case 4:
					radio=1.60;
					break;
				case 5:
					radio=1.75;
					break;
				case 6:
					radio=1.90;
					break;
				case 7:
					radio=2.05;
					break;
				case 8:
					radio=2.20;
					break;
				case 9:
					radio=2.40;
					break;
				case 10:
					radio=2.60;
					break;
				case 11:
					radio=2.80;
					break;
				case 12:
					radio=3.00;
					break;
			}
			return radio;
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