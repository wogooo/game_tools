package com.YFFramework.game.core.global.model
{
	import com.YFFramework.game.core.global.util.TypeProps;
	

	public class EquipBasicVo
	{

		/**
		 *模板id 
		 */		
		public var template_id:int;
		
		/**
		 * 装备名称
		 */
		public var name:String;
		
		/**
		 * 装备类型 
		 */		
		public var type:int;
		
		/**
		 *  职业类型
		 */		
		public var career:int;
		
		/**
		 *  性别限制
		 */
		public var gender:int;
		
		/**
		 * 等级限制 
		 */	
		public var level:int;
		
		/**
		 * 声望限制 
		 */		
		public var prestige:int;
		
		/**
		 * 装备图标id 
		 */	
		public var icon_id:int;
		
		/**
		 * 模型（男） 
		 */	
		public var model_male:int;
		
		/**
		 * 模型（女） 
		 */
		public var model_female:int;
		
		/**
		 * 装备品质 
		 */
		public var quality:int;
		
		/**
		 * 耐久度 
		 */
		public var durability:int;
		
		/**
		 * 基础属性1类型 
		 */
		public var base_attr_t1:int;
		
		/**
		 * 基础属性1数值 
		 */
		public var base_attr_v1:Number;
		
		/**
		 * 基础属性2类型 
		 */		
		public var base_attr_t2:int;
		
		/**
		 * 基础属性2数值 
		 */	
		public var base_attr_v2:Number;
		
		/**
		 * 基础属性3类型
		 */	
		public var base_attr_t3:int;
		
		/**
		 * 基础属性3数值 
		 */		
		public var base_attr_v3:Number;
		
		/**
		 * 附加属性1类型 
		 */	
		public var app_attr_t1:int;
		
		/**
		 * 附加属性1数值 
		 */
		public var app_attr_v1:Number;
		
		/**
		 * 附加属性2类型 
		 */	
		public var app_attr_t2:int;
		
		/**
		 * 附加属性2数值 
		 */
		public var app_attr_v2:Number;
		
		/**
		 * 装备孔数 
		 */		
		public var hole_number:int;
		
		/**
		 * 绑定类型 
		 */		
		public var binding_type:int;

		/**
		 * 所属套装id 
		 */
		public var suit_id:int;
		
		/**
		 *出售价格 
		 */	
		public var sell_price:int;
		
		/**
		 * 分解类型 
		 */		
		public var dec_type:int;

		/**
		 * 剩余时间 ,秒数
		 */
		public var remain_time:int;
		
		/**
		 * 能否强化    0：不能强化  1：可以强化
		 */		
		public var can_enhance:int;

		/**
		 * 装备简介 
		 */	
		public var introduction:String;
		
		/**
		 * 使用说明 
		 */		
		public var effect_desc:String;

		public function EquipBasicVo()
		{
		}
		
		public function getModelId(sex:int):int
		{
			switch(sex)
			{
				case TypeProps.GENDER_MALE:
					return model_male;
					break;
				case TypeProps.GENDER_FEMALE:
					return model_female;
					break;
			}
			return -1;
		}

		
	}
}