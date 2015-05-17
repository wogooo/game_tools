package com.YFFramework.game.core.global.manager
{
	import com.YFFramework.game.core.global.model.EquipDyVo;
	import com.YFFramework.game.core.global.model.ItemDyVo;
	import com.YFFramework.game.core.global.util.TypeProps;
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
				equip.binding_attr=(equips[i] as CharacterEquip).bindingAttr;
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
				equipList[equip.equip_id]=equip;
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
		public function getEquipPos(equipId:int):int
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