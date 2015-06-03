package com.YFFramework.game.core.module.character.model
{
	public class TitleBasicVo
	{
		/** 称号id（唯一id） */		
		public var title_id:int;
		/** 称号分类（对应品质） */
		public var title_type:int;
		/** 称号名称 */		
		public var name:String;
		/** 附加属性 */
		public var attr_id:int;
		/** 附加属性值 */
		public var attr_value:int;
		/** 称号条件（显示用） */
		public var title_condition:String;
		/** 称号资源id */
		public var effect_id:int;

		public function TitleBasicVo()
		{
		}
	}
}