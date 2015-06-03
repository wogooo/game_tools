package com.YFFramework.game.core.global.model
{
	/** 缓存 Buff.json表
	 */	
	public class BuffBasicVo
	{
		public var attr_value2:int;
		public var param1:int;
		public var attr_type1:int;
		public var attr_type2:int;
		public var client_show:int;
		public var description:String;
		public var icon_id:int;
		public var attr_type3:int;
		/** 死亡后是否需要保留buff */
		public var keep_buff:int;
		public var name:String;
		public var replace:int;
		public var attr_value3:int;
		public var param2:int;
		public var attr_value1:int;
		public var benefit:int;
		
		/**buff特效显示在哪层  上层还是下层
		 * 值在typeSkill里面  的TypeSkill.BuffLayer_
		 */
		public var buff_layer:int;


		
		/** buff id 
		 */
		public var buff_id:int;

		/**特效模型id 播放特效的资源id 
		 */		
		public var effectmodeid:int;
		
		/** buff状态  具体的类型在  TypeSkill_Buff_ 字段里
		 */
		public var buff_state:int;

		public function BuffBasicVo()
		{
		}
	}
}