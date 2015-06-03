package com.YFFramework.game.core.module.autoSetting.model
{
	public class FlushPeriodVo
	{

		public var to_time:Number;
		public var id:int;
		public var flush_id:int;
		public var from_time:Number;

		public function FlushPeriodVo()
		{
		}
		
		public function toString():String
		{
			return "from:"+from_time+"-to:"+to_time;
		}
	}
}