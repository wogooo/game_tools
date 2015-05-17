package com.YFFramework.game.core.module.pet.manager
{
	import com.YFFramework.game.core.module.pet.model.PetBasicVo;
	
	import flash.utils.Dictionary;

	/**缓存petProp表
	 * 2012-9-18 下午3:18:17
	 *@author yefeng
	 */
	public class PetBasicManager
	{
		
		
		private var _dict:Dictionary;
		
		private static var _instance:PetBasicManager;
		public function PetBasicManager()
		{
			_dict=new Dictionary();
		}
		
		public static function get Instance():PetBasicManager
		{
			if(_instance==null) _instance=new PetBasicManager();
			return _instance;
		}
		
		/**缓存数据
		 */ 
		public function cacheData(obj:Object):void
		{
			var petBasicVo:PetBasicVo;
			for(var id:String  in obj)
			{
				petBasicVo=new PetBasicVo();
				petBasicVo.basicId=int(id);
				petBasicVo.quality=obj[id].quality;
				petBasicVo.defaultSkill=obj[id].defaultSkill;
				petBasicVo.resId=obj[id].resId;
				petBasicVo.speed=obj[id].speed;
				petBasicVo.name=obj[id].name;
				_dict[petBasicVo.basicId]=petBasicVo;
			}
		}
		/**获取宠物静态vo 
		 */		
		public function getPetBasicVo(basicId:int):PetBasicVo
		{
			return _dict[basicId];
		}
		
		
	}
}