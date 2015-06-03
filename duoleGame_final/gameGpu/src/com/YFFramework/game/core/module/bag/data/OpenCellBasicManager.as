package com.YFFramework.game.core.module.bag.data
{
	import com.YFFramework.game.core.module.AnswerActivity.dataCenter.ActivityData;
	
	import flash.utils.Dictionary;

	public class OpenCellBasicManager
	{
		private static var _instance:OpenCellBasicManager;
		private var _dict:Dictionary;
		private var _orderInfo:Array;
		public function OpenCellBasicManager()
		{
			_dict=new Dictionary();
			_orderInfo=[];
		}
		public static function get Instance():OpenCellBasicManager
		{
			if(_instance==null)_instance=new OpenCellBasicManager();
			return _instance;
		}
		public  function cacheData(jsonData:Object):void
		{
			var open_cellBasicVo:OpenCellBasicVo;
			for (var id:String in jsonData)
			{
				open_cellBasicVo=new OpenCellBasicVo();
				open_cellBasicVo.id=jsonData[id].id;
				open_cellBasicVo.cell_pack_num=jsonData[id].cell_pack_num;
				open_cellBasicVo.delta_time=jsonData[id].delta_time*60;
				open_cellBasicVo.cell_depot_num=jsonData[id].cell_depot_num;
				_dict[open_cellBasicVo.id]=open_cellBasicVo;
				
				_orderInfo[open_cellBasicVo.id]=open_cellBasicVo;
			}
		}
		public function getOpenCellBasicVo(id:int):OpenCellBasicVo
		{
			return _dict[id];
		}
		
		/** 返回至参数id（不包括此id）为止经过所有的时间 */
//		public function getTotalTime(id:int):Number
//		{
//			var time:Number=0;
//			for each(var vo:OpenCellBasicVo in _orderInfo)
//			{
//				if(vo && vo.id < id)
//					time = time+vo.delta_time;
//				else
//					break;
//			}
//			return time;
//		}
	}
}