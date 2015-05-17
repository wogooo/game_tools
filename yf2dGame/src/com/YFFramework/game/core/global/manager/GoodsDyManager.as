package com.YFFramework.game.core.global.manager
{
	import com.YFFramework.game.core.global.model.EquipDyVo;
	import com.YFFramework.game.core.global.model.GoodsBasicVo;
	import com.YFFramework.game.core.global.model.GoodsDyVo;
	import com.YFFramework.game.core.global.model.GoodsUtil;
	
	import flash.utils.Dictionary;

	/**
	 *  物品中心   管理客户端所有的物品  背包     仓库  人物身上    等等  --
	 * @author yefeng
	 *2012-7-28上午9:23:51
	 */
	public class GoodsDyManager
	{
		
		private static var _instance:GoodsDyManager;
		/**保存客户端所有的数据 包含  背包  仓库  以及人物身上
		 */		
		private var _dict:Dictionary;
		/** 背包数据
		 */		
		public var backpackManager:BackpackManager;
		/**人物身上装备数据
		 */		
		public var bodyManager:BodyManager;
		/**仓库数据
		 */
		public var storageManager:StorageManager;
		
		public function GoodsDyManager()
		{
			_dict=new Dictionary();
			backpackManager=new BackpackManager();
			bodyManager=new  BodyManager();
			storageManager=new StorageManager();
		}
		public static function get Instance():GoodsDyManager
		{
			if(_instance==null) _instance=new GoodsDyManager();
			return _instance;
		}
		
		
		/** 物品动态id 
		 */
		public function getGoodsDyVo(dyId:String):GoodsDyVo
		{
			return _dict[dyId];
		}
		
		
		/** 通过动态id 拿静态物品 
		 */
		public function getGoodsBasicVo(dyId:String):GoodsBasicVo
		{
			var goodsDyVo:GoodsDyVo=getGoodsDyVo(dyId);
			var goodsBasicVo:GoodsBasicVo=GoodsBasicManager.Instance.getGoodsBasicVo(goodsDyVo.basicId);
			return goodsBasicVo;
		}
		
		/**
		 * @param goodDyVo  想背包中添加物品
		 */		
		public function addBackpack(goodsDyVo:GoodsDyVo):void
		{
			backpackManager.addGoodsDyVo(goodsDyVo);
			_dict[goodsDyVo.dyId]=goodsDyVo;
		}
		/** 向人物身上添加装备
		 * @param equipDyVo
		 */		
		public function addBody(equipDyVo:EquipDyVo):void
		{
			bodyManager.addGoodsDyVo(equipDyVo);
			_dict[equipDyVo.dyId]=equipDyVo;
		}
		/**脱下装备
		 */		
		public function putOffBody(equipDyVo:EquipDyVo):void
		{
			bodyManager.delGoodsDyVo(equipDyVo.dyId);
		}
		/**向仓库添加物品
		 */		
		public function addStorage(goodsDyVo:GoodsDyVo):void
		{
			storageManager.addGoodsDyVo(goodsDyVo);
			_dict[goodsDyVo.dyId]=goodsDyVo;
		}
			
		/**删除背包物品  总数据也删除  一般是丢弃物品
		 */		
		public function delBackpack(dyId:String):void
		{
			backpackManager.delGoodsDyVo(dyId);
			_dict[dyId]=null;
			delete _dict[dyId];
		}
		/**删除人物装备   总装备也删除 
		 */		
		public function delBody(dyId:String):void
		{
			bodyManager.delGoodsDyVo(dyId);
			_dict[dyId]=null;
			delete _dict[dyId];
		}
		/** 仓库丢弃物品
		 */		
		public  function delStorage(dyId:String):void
		{
			storageManager.delGoodsDyVo(dyId);
			_dict[dyId]=null;
			delete _dict[dyId];
		}
		/**移动物品     
		 *   将dyId物品 移动到newPostion位置  
		 */ 		
		public function moveGoodsVo(dyId:String,newPosition:int):void
		{
			var goodsDyVo:GoodsDyVo=_dict[dyId];
			var oldPostion:int=goodsDyVo.position;///原来的位置
			goodsDyVo.position=newPosition;
			switch(goodsDyVo.position)
			{
				case GoodsUtil.Position_Body:
					///人物身上    将  物品从  背包 移动到人物身上
					
					
					break;
				case GoodsUtil.Positon_Backpack:
					///背包 
					switch(oldPostion)
					{
						case GoodsUtil.Position_Body:
							
							break;
						case GoodsUtil.Position_Storage:
							
							break;
					}
					break;
				case GoodsUtil.Position_Storage:
					
					break;
			}
		}
		
		/**更新背包列表  
		 * info是  服务端的 hashMap 保存了所有的背包数据
		 */		 
		public function updateBackpackList(info:Object):void
		{
			var goodsDyVo:GoodsDyVo;
			var goodsBasicVo:GoodsBasicVo;
			for each (var obj:Object in info)
			{
				goodsBasicVo=GoodsBasicManager.Instance.getGoodsBasicVo(obj.basicId);
				if(goodsBasicVo.bigCategory==GoodsUtil.Big_Category_Equip)
				{
					goodsDyVo=new EquipDyVo();
				}
				else 
				{
					goodsDyVo=new GoodsDyVo();
				}
				goodsDyVo.basicId=obj.basicId;
				goodsDyVo.dyId=obj.dyId;
				goodsDyVo.position=obj.position;
				goodsDyVo.gridNum=obj.gridNum;
				goodsDyVo.num=obj.num;
				addBackpack(goodsDyVo);
			}
		}
		
	
		/** 更新物品数量
		 * dyId 的数量 
		 * num 物品的新个数
		 */
		public function updateGoodsNum(dyId:String,num:int):void
		{
			var goodsVo:GoodsDyVo=_dict[dyId];
			goodsVo.num=num
			if (goodsVo.num<=0) ///执行物品删除 
			{
				if(goodsVo)
				{
					switch(goodsVo.position)
					{
						case GoodsUtil.Positon_Backpack:
							backpackManager.delGoodsDyVo(goodsVo.dyId);
							break;
						case GoodsUtil.Position_Body:
							bodyManager.delGoodsDyVo(goodsVo.dyId);
							break;
						case GoodsUtil.Position_Storage:
							storageManager.delGoodsDyVo(goodsVo.dyId);
							break;
					}
					delete _dict[dyId];
				}
			}
		}
		
		
	}
}