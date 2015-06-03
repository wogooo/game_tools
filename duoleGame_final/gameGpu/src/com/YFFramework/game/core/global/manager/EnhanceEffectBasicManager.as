package com.YFFramework.game.core.global.manager
{
	import com.YFFramework.game.core.global.model.EnhanceEffectBasicVo;
	import com.YFFramework.game.core.module.mapScence.world.model.type.TypeRole;
	
	import flash.utils.Dictionary;

	public class EnhanceEffectBasicManager
	{
		private static var _instance:EnhanceEffectBasicManager;
		private var _dict:Dictionary;
		public function EnhanceEffectBasicManager()
		{
			_dict=new Dictionary();
		}
		public static function get Instance():EnhanceEffectBasicManager
		{
			if(_instance==null)_instance=new EnhanceEffectBasicManager();
			return _instance;
		}
		public  function cacheData(jsonData:Object):void
		{
			var enhanceEffectBasicVo:EnhanceEffectBasicVo;
			var key:String;
			for (var id:String in jsonData)
			{
				enhanceEffectBasicVo=new EnhanceEffectBasicVo();
				enhanceEffectBasicVo.priest=jsonData[id].priest;
				enhanceEffectBasicVo.sex=jsonData[id].sex;
				enhanceEffectBasicVo.master=jsonData[id].master;
				enhanceEffectBasicVo.part_type=jsonData[id].part_type;
				enhanceEffectBasicVo.enhance_level=jsonData[id].enhance_level;
				enhanceEffectBasicVo.warrior=jsonData[id].warrior;
				enhanceEffectBasicVo.hunter=jsonData[id].hunter;
				enhanceEffectBasicVo.bravo=jsonData[id].bravo;
				key=getKey(enhanceEffectBasicVo.part_type,enhanceEffectBasicVo.sex,enhanceEffectBasicVo.enhance_level);
				_dict[key]=enhanceEffectBasicVo;
			}
		}
		/**获取特效id   如果 不存在该等级的特效 则返回-1 
		 * @param part_type  模型 部位 值在 EquipBigCategory  为 武器  或者衣服
		 * @param sex
		 * @param level
		 * @param career
		 */
		public function getEnhanceEffectId(part_type:int,sex:int,level:int,career:int):int
		{
			var key:String=getKey(part_type,sex,level);
			var enhanceEffectBasicVo:EnhanceEffectBasicVo=_dict[key];
			if(enhanceEffectBasicVo)
			{
				switch(career)
				{
					case TypeRole.CAREER_WARRIOR:  //战士
						return enhanceEffectBasicVo.warrior;
						break;
					case TypeRole.CAREER_MASTER://法师
						return enhanceEffectBasicVo.master;
						break;
					case TypeRole.CAREER_PRIEST://牧师
						return enhanceEffectBasicVo.priest;
						break;
					case TypeRole.CAREER_BRAVO://刺客
						return enhanceEffectBasicVo.bravo;
						break;
					case TypeRole.CAREER_HUNTER: //猎人
						return enhanceEffectBasicVo.hunter;
						break;
				}
			}
			return -1;
		}
		/**唯一key 
		 */		
		private function getKey(part_type:int,sex:int,level:int):String
		{
			return part_type+"_"+sex+"_"+level;
		}
	}
}