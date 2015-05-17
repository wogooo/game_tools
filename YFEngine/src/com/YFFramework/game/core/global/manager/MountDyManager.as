package com.YFFramework.game.core.global.manager
{
	import com.YFFramework.game.core.global.model.MountDyVo;
	
	import flash.utils.Dictionary;

	/**2012-10-26 下午12:00:24
	 *@author yefeng
	 */
	public class MountDyManager
	{
		private var _dict:Dictionary;
		private static var _instance:MountDyManager;
		/**能够骑上去的坐骑
		 */		
		private var _fightMount:MountDyVo;
		public function MountDyManager()
		{
			_dict=new Dictionary();
		}
		public static function get Instance():MountDyManager
		{
			if(_instance==null) _instance=new MountDyManager();
			return _instance;
		}
		/** arr数组里面保存的事MountDyVo的Object类型变量
		 * @param arr
		 */		
		public function cacheData(arr:Array):void
		{
			var mountDyVo:MountDyVo ;
			for each(var obj:Object in arr)
			{
				mountDyVo=new MountDyVo();
				mountDyVo.basicId=obj.basicId;
				mountDyVo.dyId=obj.dyId;
				_dict[mountDyVo.dyId]=mountDyVo;
			}
		}
		
		public function getMountDyVo(dyId:String):MountDyVo
		{
			return _dict[dyId];	
		}
		/**添加坐骑
		 */		
//		public function addMountDyVo(mountDyVo:MountDyVo):void
//		{
//			_dict[mountDyVo.dyId]=mountDyVo;
//		}
		/**删除怪物额
		 */		
		public function delMountDyVo(dyId:String):void
		{
			delete _dict[dyId];	
		}
		/**
		 * @return  当前坐着的坐骑
		 */		
		public function getMounting():MountDyVo
		{
			return _fightMount;
		}
		/**@return获取能够坐上去的马
		 */		
		public function getAvailableMount():MountDyVo
		{
			if(_fightMount) return _fightMount;
			else 
			{
				for each(var mountDyVo:MountDyVo in _dict)
				{
					_fightMount=mountDyVo;
					return _fightMount;
				}
			}
			return null;
		}
		/**下马
		 */		
		public function dismounting(dyId:String):void
		{
			if(_fightMount.dyId==dyId)_fightMount=null;
		}
	}
}