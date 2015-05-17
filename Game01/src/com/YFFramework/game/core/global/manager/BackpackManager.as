package com.YFFramework.game.core.global.manager
{
	import com.YFFramework.game.core.global.DataCenter;
	import com.YFFramework.game.core.global.model.GoodsBasicVo;
	import com.YFFramework.game.core.global.model.GoodsDyVo;
	
	import flash.utils.Dictionary;

	/**2012-8-17 下午4:01:34
	 *@author yefeng
	 */
	public class BackpackManager
	{
		/**保存所有的 物品 通过   dyId --- goodsDyVO
		 */		
		private var _dict:Dictionary;
		
		/**保存所有物品 通过 gridNUm ---goodsDyVO  格子数目 对应物品
		 */		
		private var _gridDict:Dictionary;
		
		/**背包容量大小
		 */		
		public var size:int;
		
		/**当前物品总数
		 */ 
		private var _goodsNum:int;
		
		
		public function BackpackManager()
		{
			_dict=new Dictionary();
			_gridDict=new Dictionary();
		}
		public function addGoodsDyVo(goodsDyVo:GoodsDyVo):void
		{
			if(!_dict[goodsDyVo.dyId])_goodsNum++;
			_dict[goodsDyVo.dyId]=goodsDyVo;
			_gridDict[goodsDyVo.gridNum]=goodsDyVo;
		}
		
		public function delGoodsDyVo(dyId:String):void
		{
			if(_dict[dyId])_goodsNum--;
			var goodsDyVo:GoodsDyVo=_dict[dyId];
			_dict[dyId]=null;
			delete _dict[dyId];
			_gridDict[goodsDyVo.gridNum]=null;
			delete _gridDict[goodsDyVo.gridNum];
			goodsDyVo=null;
		}
		
		public function getList():Dictionary
		{
			return _dict;
		}
		
		/**
		 * @param bigCategory 根据物品大类类获取相应的物品列表
		 */		
		public function getGoodsList(bigCategory:int):Array
		{
			 var arr:Array=[];
			 var goodsBasicVo:GoodsBasicVo;
			 for  each (var goodsDyVo:GoodsDyVo in _dict)
			 {
				 goodsBasicVo=GoodsBasicManager.Instance.getGoodsBasicVo(goodsDyVo.basicId);
				 if(goodsBasicVo.bigCategory==bigCategory)arr.push(goodsDyVo);
			 }
			 ///按照 gridNum排序 
			 arr.sortOn("gridNum",Array.NUMERIC);
			 return arr;
		}
		/**  根据物品打类 和小类来拿具体的物品  比如 拿加血的药水  或者加蓝的药水 就要使用下面的方法
		 * @param bigCategory  物品大类
		 * @param smallCategory  物品小类
		 * @return  返回满足要求的列表  GoodsDyVo
		 */		
		public function getGoodsSmallCategoryList(bigCategory:int,smallCategory:int):Array
		{
			var bigCategoryArr:Array=getGoodsList(bigCategory);
			var arr:Array=[];
			var basicVo:GoodsBasicVo;
			for each(var vo:GoodsDyVo in bigCategoryArr)
			{
				basicVo=GoodsBasicManager.Instance.getGoodsBasicVo(vo.basicId);
				if(basicVo.smallCategory==smallCategory)arr.push(vo);
			}
			return arr;
		}
		
		/**当前背包物品总数
		 */		
		public function getGoodsNum():int
		{
			return _goodsNum;
		}
		
		/**
		 *更新格子数   newGridNum的位置是不存在物品的 否则的话就要使用 exchangeGridNum方法来交换物品格子
		 */		
		public function updateGridNum(dyId:String,newGridNum:int):void
		{
			var goodsDyVo:GoodsDyVo=_dict[dyId];
			delete _gridDict[goodsDyVo.gridNum];///删除旧格子索引 
			goodsDyVo.gridNum=newGridNum;
			_gridDict[goodsDyVo.gridNum]=goodsDyVo;  ///新格子索引

		}
		/**交换格子
		 * dyId_1的新格子为 newGridNum_1  dyId_2 的新格子为 newGridNum_2
		 */		
		public function exchangeGridNum(dyId_1:String,newGridNum_1:int,dyId_2:String,newGridNum_2:int):void
		{
			var goodsVo1:GoodsDyVo=_dict[dyId_1];
			var goodsVo2:GoodsDyVo=_dict[dyId_2];
			goodsVo1.gridNum=newGridNum_1;
			goodsVo2.gridNum=newGridNum_2;
			_gridDict[goodsVo1.gridNum]=goodsVo1;
			_gridDict[goodsVo2.gridNum]=goodsVo2;
		}

		
		/** 通过格子数获取物品
		 */		
		public function getGoodsDyVo(gridNum:int):GoodsDyVo
		{
			return _gridDict[gridNum];
		}
		
	}
}