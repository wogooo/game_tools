package com.YFFramework.game.core.global.manager
{
	import com.YFFramework.core.debug.print;
	import com.YFFramework.game.core.global.model.EquipBasicVo;
	import com.YFFramework.game.core.global.util.NoticeUtil;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.gameConfig.URLTool;
	
	import flash.utils.Dictionary;

	public class EquipBasicManager
	{
		private static var _instance:EquipBasicManager;
		private var _dict:Dictionary;
		
		/**根据部位 等级 职业存储装备 
		 */
		private var _equipLevelCahe:Dictionary;
		public function EquipBasicManager()
		{
			_dict=new Dictionary();
			_equipLevelCahe=new Dictionary();
		}
		public static function get Instance():EquipBasicManager
		{
			if(_instance==null)_instance=new EquipBasicManager();
			return _instance;
		}
		public  function cacheData(jsonData:Object):void
		{
			var equip_TemplateBasicVo:EquipBasicVo;
			
			var careerCache:Dictionary;//职业
			var typeCache:Array; // 装备类型    
			
			for (var id:String in jsonData)
			{
				equip_TemplateBasicVo=new EquipBasicVo();
				equip_TemplateBasicVo.app_attr_t2=jsonData[id].app_attr_t2;
				equip_TemplateBasicVo.hole_number=jsonData[id].hole_number;
				equip_TemplateBasicVo.model_male=jsonData[id].model_male;
				equip_TemplateBasicVo.base_attr_v2=jsonData[id].base_attr_v2;
				equip_TemplateBasicVo.binding_type=jsonData[id].binding_type;
				equip_TemplateBasicVo.model_female=jsonData[id].model_female;
				equip_TemplateBasicVo.durability=jsonData[id].durability;
				equip_TemplateBasicVo.base_attr_v1=jsonData[id].base_attr_v1;
				equip_TemplateBasicVo.dec_type=jsonData[id].dec_type;
				equip_TemplateBasicVo.template_id=jsonData[id].template_id;
				equip_TemplateBasicVo.base_attr_t1=jsonData[id].base_attr_t1;
				equip_TemplateBasicVo.suit_id=jsonData[id].suit_id;
				equip_TemplateBasicVo.remain_time=jsonData[id].remain_time;
				equip_TemplateBasicVo.can_enhance=jsonData[id].can_enhance;
				equip_TemplateBasicVo.type=jsonData[id].type;
				equip_TemplateBasicVo.base_attr_t2=jsonData[id].base_attr_t2;
				equip_TemplateBasicVo.app_attr_t1=jsonData[id].app_attr_t1;
				equip_TemplateBasicVo.base_attr_v3=jsonData[id].base_attr_v3;
				equip_TemplateBasicVo.effect_desc=jsonData[id].effect_desc;
				equip_TemplateBasicVo.name=jsonData[id].name;
				equip_TemplateBasicVo.base_attr_t3=jsonData[id].base_attr_t3;
				equip_TemplateBasicVo.quality=jsonData[id].quality;
				equip_TemplateBasicVo.introduction=jsonData[id].introduction;
				equip_TemplateBasicVo.career=jsonData[id].career;
				equip_TemplateBasicVo.app_attr_v2=jsonData[id].app_attr_v2;
				equip_TemplateBasicVo.app_attr_v1=jsonData[id].app_attr_v1;
				equip_TemplateBasicVo.sell_price=jsonData[id].sell_price;
				equip_TemplateBasicVo.level=jsonData[id].level;
				equip_TemplateBasicVo.icon_id=jsonData[id].icon_id;
				equip_TemplateBasicVo.prestige=jsonData[id].prestige;
				equip_TemplateBasicVo.gender=jsonData[id].gender;
				_dict[equip_TemplateBasicVo.template_id]=equip_TemplateBasicVo;
//				print(this,"equip_TemplateBasicVo.template_id:",equip_TemplateBasicVo.template_id);
				
				if(!_equipLevelCahe[equip_TemplateBasicVo.career])
				{
					careerCache=new Dictionary();
					_equipLevelCahe[equip_TemplateBasicVo.career]=careerCache;
				}
				careerCache=_equipLevelCahe[equip_TemplateBasicVo.career];
				
				if(!careerCache[equip_TemplateBasicVo.type])
				{
					typeCache=[];
					careerCache[equip_TemplateBasicVo.type]=typeCache;
				}
				typeCache=careerCache[equip_TemplateBasicVo.type];
				typeCache.push(equip_TemplateBasicVo);
			}
		}
		
		
		/**获取下一等级的装备
		 * career 职业
		 * type 类型 也就是模型部位 值在TypeProps.EQUIP_TYPE_
		 * currentEquipLevel 是当前的武器等级   
		 * 返回 currentEquipLevel 的下一等级的装备 
		 */
		public function getNextEquipBasicVo(career:int,type:int,currentEquipLevel:int):EquipBasicVo
		{
			var typeCahe:Array=_equipLevelCahe[career][type];
			typeCahe.sortOn("level");  //从小到大 根据等级排序
			var len:int=typeCahe.length;
			var equipBasicVo:EquipBasicVo;
			for (var i:int=0;i!=len;++i)
			{
				equipBasicVo=typeCahe[i];
				if(equipBasicVo.level>currentEquipLevel)
				{
					return equipBasicVo;
				}
			}
			return null;
		}
		
		/**  获取  该职业的 的某部位的 第  index 把装备   index 从 0 开始    比如 获取 武器  第  二 把 武器    装备 的 获取 是从低等级 向高等级 慢慢进阶获取的 
		 * @param career 职业
		 * @param type  类型
		 * @param index   第几个武器  从低到高
		 * 
		 */
		public function getEquipBasicVoByIndex(career:int,type:int,index:int):EquipBasicVo
		{
			var typeCahe:Array=_equipLevelCahe[career][type];
			typeCahe.sortOn("level");  //从小到大 根据等级排序
			if(typeCahe.length>index)
			{
				return typeCahe[index];
			}
			return null;
		}

		
		
		
		
		public function getEquipBasicVo(template_id:int):EquipBasicVo
		{
			return _dict[template_id];
		}
		/**  获取装备图标  id
		 * @param template_id
		 * @return 
		 */		
		public function getURL(template_id:int):String
		{
			var equipBasicVo:EquipBasicVo=_dict[template_id];
			return URLTool.getGoodsIcon(equipBasicVo.icon_id);
		}
		
		/**含有该套装id 的 所有含该套装id的 静态vo
		 */		
		public function getSuitIdArr(suitId:int):Array
		{
			var arr:Array=[];
			for each(var equip_TemplateBasicVo:EquipBasicVo in _dict)
			{
				if(equip_TemplateBasicVo.suit_id==suitId)
				{
					arr.push(equip_TemplateBasicVo);
				}
			}
			return arr;
		}
		
		public static function getEquipType(type:int):String
		{
			var str:String='';
			switch(type)
			{
				case TypeProps.EQUIP_TYPE_HELMET:
					str = "头盔";
					break;
				case TypeProps.EQUIP_TYPE_CLOTHES:
					str = "衣服";
					break;
				case TypeProps.EQUIP_TYPE_WRIST:
					str = "手套";
					break;
				case TypeProps.EQUIP_TYPE_NECKLACE:
					str = "项链";
					break;
				case TypeProps.EQUIP_TYPE_RING:
					str = "戒指";
					break;
				case TypeProps.EQUIP_TYPE_SHOES:
					str = "鞋子";
					break;
				case TypeProps.EQUIP_TYPE_WEAPON:
					str = "武器";
					break;
				case TypeProps.EQUIP_TYPE_SHIELD:
					str = "副手";
					break;
				case TypeProps.EQUIP_TYPE_WINGS:
					str = "翅膀";
					break;
//				case TypeProps.EQUIP_TYPE_FASHION_HEAD:
//					str = "时尚头盔";
//					break;
				case TypeProps.EQUIP_TYPE_FASHION_BODY:
					str = "时尚衣服";
					break;
			}
			return str;
		}
		

		
	}
}