package com.YFFramework.game.core.module.autoSetting.manager
{
	import com.YFFramework.game.core.module.autoSetting.model.FlushPeriodVo;
	
	import flash.utils.Dictionary;

	public class FlushPeriodManager
	{
		private static var _instance:FlushPeriodManager;
		private var _dict:Dictionary;
		private var _arr:Vector.<FlushPeriodVo>;
		public function FlushPeriodManager()
		{
			_dict=new Dictionary();
			_arr=new Vector.<FlushPeriodVo>;
		}
		public static function get Instance():FlushPeriodManager
		{
			if(_instance==null)_instance=new FlushPeriodManager();
			return _instance;
		}
		public  function cacheData(jsonData:Object):void
		{
			var flush_PeriodBasicVo:FlushPeriodVo;
			for (var id:String in jsonData)
			{
				flush_PeriodBasicVo=new FlushPeriodVo();
				flush_PeriodBasicVo.to_time=jsonData[id].to_time;
				flush_PeriodBasicVo.id=jsonData[id].id;
				flush_PeriodBasicVo.flush_id=jsonData[id].flush_id;
				flush_PeriodBasicVo.from_time=jsonData[id].from_time;
				_dict[flush_PeriodBasicVo.id]=flush_PeriodBasicVo;
				_arr.push(flush_PeriodBasicVo);
			}
		}
		
		public function getFlush_PeriodBasicVo(id:int):FlushPeriodVo
		{
			return _dict[id];
		}
		
		public function getAll():Vector.<FlushPeriodVo>
		{
			trace(_arr);
			return _arr.concat();
		}
	}
}