package com.YFFramework.game.core.module.rank.data
{
	import flash.utils.Dictionary;

	public class RankBasicManager
	{
		private static var _instance:RankBasicManager;
		private var _dict:Dictionary;
		public function RankBasicManager()
		{
			_dict=new Dictionary();
		}
		public static function get Instance():RankBasicManager
		{
			if(_instance==null)_instance=new RankBasicManager();
			return _instance;
		}
		public  function cacheData(jsonData:Object):void
		{
			var rankConfigBasicVo:RankBasicVo;
			for (var id:String in jsonData)
			{
				rankConfigBasicVo=new RankBasicVo();
				rankConfigBasicVo.show_info=jsonData[id].show_info;
				rankConfigBasicVo.classic_type=jsonData[id].classic_type;
				rankConfigBasicVo.title_id=jsonData[id].title_id;
				rankConfigBasicVo.classic_name=jsonData[id].classic_name;
				rankConfigBasicVo.subClassic_name=jsonData[id].subClassic_name;
				rankConfigBasicVo.type=jsonData[id].type;
				_dict[rankConfigBasicVo.classic_type]=rankConfigBasicVo;
			}
		}
		public function getRankConfigBasicVo(classic_type:int):RankBasicVo
		{
			return _dict[classic_type];
		}
		
		/** 看有多少个大类 */		
		public function getTypeArray():Vector.<RankBasicVo>
		{
			var ary:Vector.<RankBasicVo>=new Vector.<RankBasicVo>(4);
			for each(var vo:RankBasicVo in _dict)
			{
				ary[vo.type]=vo;
			}
			return ary;
		}
		
		/** 这个大类有几个小类
		 * @param type 大类
		 * @return 这个大类有几个小类，数组成员为RankBasicVo
		 */		
		public function getSubTypeAry(type:int):Array
		{
			var ary:Array=[];
			for each(var vo:RankBasicVo in _dict)
			{
				if(vo.type == type)
					ary.push(vo);
			}
			ary.sortOn("classic_type",Array.NUMERIC);
			return ary;
		}
	}
}