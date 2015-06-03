package com.YFFramework.game.core.global.model
{
	public class Gather_ConfigBasicVo
	{

		/**静态id 
		 */		
		public var basic_id:int;

		public var level:int;
		public var wordInterval:int;
		public var camp:int;
		public var life_skill_level:int;
		public var life_skill_id:int;
		public var name:String;
		public var gather_time:int;
		
		/** 冒泡
		 */		
		public var bubble1:String;
		
		public var bubble2:String;

		public var bubble3:String;

		
		/** 采集物 随机生成 道具1
		 */
		public var item_id1:int;
		/**采集物 随机生成 道具2
		 */		
		public var item_id2:int;
		/**采集物 随机生成 道具3
		 */		
		public var item_id3:int;


		/**模型id 
		 */		
		public var model_id:int;
		/**图标id 
		 */		
		public var icon_id:int;

		public function Gather_ConfigBasicVo()
		{
		}
	}
}