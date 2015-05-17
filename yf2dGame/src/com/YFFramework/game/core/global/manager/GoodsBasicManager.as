package com.YFFramework.game.core.global.manager
{
	import com.YFFramework.game.core.global.DataCenter;
	import com.YFFramework.game.core.global.model.EquipBasicVo;
	import com.YFFramework.game.core.global.model.GoodsBasicVo;
	import com.YFFramework.game.core.global.model.GoodsUtil;
	import com.YFFramework.game.core.global.model.SkinVo;
	import com.YFFramework.game.core.module.backpack.model.MedicineBasicVo;
	
	import flash.utils.Dictionary;

	/** 保存的是所有物品的静态vo 
	 * 2012-7-3
	 *	@author yefeng
	 */
	public class GoodsBasicManager
	{
		
		private static var _instance:GoodsBasicManager;
		private var _dict:Dictionary;
		public function GoodsBasicManager()
		{
			_dict=new Dictionary();
		}
		public static function get Instance():GoodsBasicManager
		{
			if(_instance==null) _instance=new GoodsBasicManager();
			return _instance;
		}
		
		/** 缓存普通道具
		 */		
		public function cacheGoodsData(jsonData:Object):void
		{
			var goodsBasicVo:GoodsBasicVo;
			for(var id:String   in jsonData)
			{
				goodsBasicVo=new GoodsBasicVo();
				_dict[goodsBasicVo.basicId]=goodsBasicVo;
				goodsBasicVo.basicId=int(id);
				goodsBasicVo.resId=jsonData[id].resId;
				goodsBasicVo.name=jsonData[id].name;
				goodsBasicVo.level=jsonData[id].level;
				goodsBasicVo.price=jsonData[id].price;
				goodsBasicVo.bigCategory=jsonData[id].bigCategory;
				goodsBasicVo.smallCategory=jsonData[id].smallCategory;
				_dict[goodsBasicVo.basicId]=goodsBasicVo;
			}
		}
		
		/** 缓存药品道具
		 */		
		public function cacheMedicineData(jsonData:Object):void
		{
			var goodsBasicVo:MedicineBasicVo
			for(var id:String   in jsonData)
			{
				goodsBasicVo=new MedicineBasicVo();
				goodsBasicVo.basicId=int(id);
				goodsBasicVo.resId=jsonData[id].resId;
				goodsBasicVo.name=jsonData[id].name;
				goodsBasicVo.level=jsonData[id].level;
				goodsBasicVo.price=jsonData[id].price;
				goodsBasicVo.bigCategory=jsonData[id].bigCategory;
				goodsBasicVo.smallCategory=jsonData[id].smallCategory;
				goodsBasicVo.coolTime=jsonData[id].coolTime;
				_dict[goodsBasicVo.basicId]=goodsBasicVo;
			}
		}
		
		/** 缓存 装备道具表
		 */		
		public function cacheEquipData(jsonData:Object):void
		{
			var equipBasicVo:EquipBasicVo;
			for  (var id:String  in jsonData)
			{
				equipBasicVo=new EquipBasicVo();
				equipBasicVo.basicId=int(id);
				equipBasicVo.carrer=jsonData[id].carrer;
				equipBasicVo.sex=jsonData[id].sex;
				equipBasicVo.resId=jsonData[id].resId;
				equipBasicVo.name=jsonData[id].name;
				equipBasicVo.level=jsonData[id].level;
				equipBasicVo.price=jsonData[id].price;
				equipBasicVo.quality=jsonData[id].quality;
				equipBasicVo.bigCategory=jsonData[id].bigCategory;
				equipBasicVo.smallCategory=jsonData[id].smallCategory;
				equipBasicVo.maxHold=jsonData[id].maxHold;
				_dict[equipBasicVo.basicId]=equipBasicVo;
			}
		}
		/**   得到普通物品静态vo 
		 * @param basicId  物品静态id 
		 */		
		public function getGoodsBasicVo(basicId:int):GoodsBasicVo
		{
			return  _dict[basicId];
		}
		/** 得到装备物品静态vo
		 * @param basicId 物品静态id 
		 */
		public function getEquipBasicVo(basicId:int):EquipBasicVo
		{
			return  getGoodsBasicVo(basicId) as EquipBasicVo;
		}
		/**是否为装备物品
		 */		
		public function  isEquip(basicId:int):Boolean
		{
			var basicVo:GoodsBasicVo=_dict[basicId];
			if(basicVo.bigCategory==GoodsUtil.Big_Category_Equip) return true;
			return false;
		}
		/**是否为药品 等消耗性道具  具有CD
		 * 
		 */		
		public function isMedicine(basicId:int):Boolean
		{
			var basicVo:GoodsBasicVo=_dict[basicId];
			if(basicVo.bigCategory==GoodsUtil.Big_Category_Medicine) return true;
			return false;
		}
		
		/**根据 静态id 获取皮肤资源vo
		 * @param basicId
		 * @return 
		 */		
		public function getSkinVo(basicId:int):SkinVo
		{
			var basicVo:GoodsBasicVo=getGoodsBasicVo(basicId);
			var skinVo:SkinVo=SkinManager.Instance.getSkinVo(basicVo.resId);
			return skinVo;
		}
		
	}
}