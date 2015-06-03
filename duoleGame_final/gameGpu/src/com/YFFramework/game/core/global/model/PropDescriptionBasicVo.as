package com.YFFramework.game.core.global.model
{
	/**
	 *  缓存装备属性 名称表述表 propDescription.json
	 */	
	public class PropDescriptionBasicVo
	{

		public var attrId:int;
		public var description:String;
		public function PropDescriptionBasicVo()
		{
		}
		/**替换 %d 的描述
		 */		
		public function getDescription(value:Number):String
		{
			var data:String=value.toString();
			var des:String=	description.replace("%d",data);
			return des;
		}
		
	}
}