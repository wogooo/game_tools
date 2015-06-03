package com.YFFramework.game.core.module.mapScence.manager
{
	/**管理宠物的buff 
	 * 出战宠物buff 
	 * @author yefeng
	 * 2013 2013-12-31 下午2:16:02 
	 */
	public class PetBuffDyManager extends BuffDyManager
	{
		private static var _petBuffDyManager:PetBuffDyManager;
		public function PetBuffDyManager()
		{
			super();
		}
		public static function get Instance():PetBuffDyManager
		{
			if(_petBuffDyManager==null)_petBuffDyManager=new PetBuffDyManager();
			return _petBuffDyManager;
		}

	}
}