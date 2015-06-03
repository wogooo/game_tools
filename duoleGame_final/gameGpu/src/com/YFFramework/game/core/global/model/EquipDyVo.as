package com.YFFramework.game.core.global.model
{
	import com.YFFramework.game.core.global.manager.PropsBasicManager;

	/**装备动态 vo 
	 * @author yefeng
	 *2012-7-28下午10:38:30
	 */
	public class EquipDyVo extends GoodsDyVo
	{
		/**
		 * 道具唯一id 
		 * 动态 id
		 */		
		public var equip_id:int;
		
		/**
		 * 道具模板id 
		 */		
		public var template_id:int;
		/**
		 * 绑定性 ： 绑定1；不绑定2
		 */		
		public var binding_type:int;
		
		/**
		 * 当前耐久度 
		 */		
		public var cur_durability:int;
		
		/**
		 * 强化等级 
		 */			
		public var enhance_level:int;
		
		/**
		 * 镶嵌宝石1 模板Id
		 */
		public var gem_1_id:int;
		
		/**
		 * 镶嵌宝石2  模板Id
		 */
		public var gem_2_id:int;
		
		/**
		 * 镶嵌宝石3  模板Id
		 */
		public var gem_3_id:int;
		
		/**
		 * 镶嵌宝石4  模板Id
		 */
		public var gem_4_id:int;
		
		/**
		 * 镶嵌宝石5  模板Id
		 */
		public var gem_5_id:int;
		
		/**
		 * 镶嵌宝石6  模板Id
		 */
		public var gem_6_id:int;
		
		/**
		 * 镶嵌宝石7  模板Id
		 */
		public var gem_7_id:int;
		
		/**
		 * 镶嵌宝石8 模板Id
		 */
		public var gem_8_id:int;
		/** 道具获得时间,获得时间换算为秒数*/		
		public var obtain_time:int;
		
		/** 附加属性类型1（来源于装备洗练） */		
		public var app_attr_t1:int;
		
		/** 附加属性值1（来源于装备洗练） */
		public var app_attr_v1:int;
		
		/** 附加属性值颜色1（来源于装备洗练） */
		public var app_attr_color1:uint;
		
		/** 附加属性值锁定1（true:这个属性锁定了） */	
		public var app_attr_lock1:Boolean;
		
		/** 附加属性类型2（来源于装备洗练） */		
		public var app_attr_t2:int;
		
		/** 附加属性值2（来源于装备洗练） */
		public var app_attr_v2:int;
		
		/** 附加属性值锁定2（true:这个属性锁定了） */	
		public var app_attr_lock2:Boolean;
		
		/** 附加属性值颜色2（来源于装备洗练） */
		public var app_attr_color2:uint;
		
		/** 附加属性类型3（来源于装备洗练） */		
		public var app_attr_t3:int;
		
		/** 附加属性值3（来源于装备洗练） */
		public var app_attr_v3:int;
		
		/** 附加属性值颜色3（来源于装备洗练） */
		public var app_attr_color3:uint;
		
		/** 附加属性值锁定3（true:这个属性锁定了） */	
		public var app_attr_lock3:Boolean;
		
		/** 附加属性类型4（来源于装备洗练） */		
		public var app_attr_t4:int;
		
		/** 附加属性值4（来源于装备洗练） */
		public var app_attr_v4:int;
		
		/** 附加属性值颜色4（来源于装备洗练） */
		public var app_attr_color4:uint;
		
		/** 附加属性值锁定4（true:这个属性锁定了）*/	
		public var app_attr_lock4:Boolean;
		
		/** 属性锁定次数 */		
		public var deft_lock_num:int;
		
		/** 装备强化星运值（0-10数字） */
		public var star:int;
		
		public function EquipDyVo()
		{
			super();
		}
		
		/**获取指定品质宝石的数量
		 * @param targetQuality
		 * @return 
		 */		
		public function getGemNum(targetQuality:int=0):int{
			var gemNum:int=0;
			if(gem_1_id!=0 && PropsBasicManager.Instance.getPropsBasicVo(gem_1_id).quality>=targetQuality)	gemNum++;
			if(gem_2_id!=0 && PropsBasicManager.Instance.getPropsBasicVo(gem_1_id).quality>=targetQuality)	gemNum++;
			if(gem_3_id!=0 && PropsBasicManager.Instance.getPropsBasicVo(gem_1_id).quality>=targetQuality)	gemNum++;
			if(gem_4_id!=0 && PropsBasicManager.Instance.getPropsBasicVo(gem_1_id).quality>=targetQuality)	gemNum++;
			if(gem_5_id!=0 && PropsBasicManager.Instance.getPropsBasicVo(gem_1_id).quality>=targetQuality)	gemNum++;
			if(gem_6_id!=0 && PropsBasicManager.Instance.getPropsBasicVo(gem_1_id).quality>=targetQuality)	gemNum++;
			if(gem_7_id!=0 && PropsBasicManager.Instance.getPropsBasicVo(gem_1_id).quality>=targetQuality)	gemNum++;
			if(gem_8_id!=0 && PropsBasicManager.Instance.getPropsBasicVo(gem_1_id).quality>=targetQuality)	gemNum++;
			return gemNum;
		}
		
		/**获取宝石数量
		 * @return  
		 */		
		public function getGemNumber():int{
			var gemNum:int=0;
			if(gem_1_id!=0)	gemNum++;
			if(gem_2_id!=0)	gemNum++;
			if(gem_3_id!=0)	gemNum++;
			if(gem_4_id!=0)	gemNum++;
			if(gem_5_id!=0)	gemNum++;
			if(gem_6_id!=0)	gemNum++;
			if(gem_7_id!=0)	gemNum++;
			if(gem_8_id!=0)	gemNum++;
			return gemNum;
		}
	}
}