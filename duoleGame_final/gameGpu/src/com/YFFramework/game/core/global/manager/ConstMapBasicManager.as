package com.YFFramework.game.core.global.manager
{
	import com.YFFramework.core.debug.print;
	import com.YFFramework.game.core.global.model.ConstMapBasicVo;
	
	import flash.utils.Dictionary;

	public class ConstMapBasicManager
	{
		private static var _instance:ConstMapBasicManager;
		private var _dict:Dictionary;
		public function ConstMapBasicManager()
		{
			_dict=new Dictionary();
		}
		public static function get Instance():ConstMapBasicManager
		{
			if(_instance==null)_instance=new ConstMapBasicManager();
			return _instance;
		}
		public  function cacheData(jsonData:Object):void
		{
			var const_mapBasicVo:ConstMapBasicVo;
			for (var id:String in jsonData)
			{
				const_mapBasicVo=new ConstMapBasicVo();
				const_mapBasicVo.const_id=jsonData[id].const_id;
				const_mapBasicVo.tmpl_id=jsonData[id].tmpl_id;
				_dict[const_mapBasicVo.const_id]=const_mapBasicVo;
			}
		}
		public function getConstMapBasicVo(const_id:int):ConstMapBasicVo
		{
			return _dict[const_id];
		}
		
		public function getTempId(const_id:int):int{
			if(!_dict[const_id])
			{
				print(this,"const map 配置错误："+const_id);
				return -1;
			}
			return _dict[const_id].tmpl_id;
		}
		
		public function getConstId(tmpId:int):int
		{
			for each(var vo:ConstMapBasicVo in _dict)
			{
				if(vo.tmpl_id == tmpId)
					return vo.const_id;
			}
			return 0;
		}
		
	}
}