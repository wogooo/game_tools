package com.YFFramework.core.utils.math
{
	/**
	 * author :夜枫 * 时间 ：Sep 20, 2011 12:30:57 PM
	 */
	public class Algorithm
	{
		private static   var  index:int=0;
		public function Algorithm()
		{
		}
		/**二分查找
		 */		
		private  static  function  search(array:Array,target:int):int
		{
			var midIndex:int = int(array.length / 2);
			var mid:int = array[midIndex];
			if (target == mid){
				
			//	trace("找到了");
				index+=midIndex
			//	trace(index);
				return index
			}
			if (! midIndex)//arr长度为 0 1的情况
			{
				trace("数组中不存在该值");
				index=-1
				return  index;
			}
			var leftArray:Array = array.slice(0,midIndex);
			var rightArray:Array = array.slice(midIndex,array.length);
			if (target > mid)
			{
				index+=midIndex
				search(rightArray,target);
			}
			else
			{
				search(leftArray,target);
			}
			return index;
		}
		
		/** 查找带属性 的对象 
		 * @param array  带查找的数组
		 * @param sortProperty   对象的  排序属性
		 * @param compareProperty target 对象的  的比对属性 也就是满足条件的属性   
		 * @param sortValue    要查找对象的排序值
		 * @param compareValue  要查找对象的比较属性
		 */		
		private  static  function  superSearch(array:Array,sortProperty:String,compareProperty:String,sortValue:int,compareValue:Object):int
		{
			var midIndex:int = int(array.length / 2);
			var mid:Object=array[midIndex];
			if (compareValue == mid[compareProperty]){
				index+=midIndex
				//	trace("找到了",index);
				return index
			}
			if (! midIndex)//arr长度为 0 的情况
			{
			//	trace("数组中不存在该值");
				index=-1
				return  index;
			}
			var leftArray:Array = array.slice(0,midIndex);
			var rightArray:Array = array.slice(midIndex,array.length);
			if (sortValue > mid[sortProperty])
			{
				index+=midIndex
				superSearch(rightArray,sortProperty,compareProperty,sortValue,compareValue);
			}
			else
			{
				superSearch(leftArray,sortProperty,compareProperty,sortValue,compareValue);
			}
			return index;
		}
		/*
		二分查找: 根据数组里面的值查它的索引,假如查到了就返回所在索引 ，否则返回 -1 
		该数组是有序数组 ，从小到大排列的  
		target 为索要查找的对象     函数返回的是该target对象 在数组中的索引，假如在数组中不存在就返回-1
		用法：
		var a:Array=[1,3,6,9,12,15,16,200,500]  
		var s:int=Algorithm.binarySearch(a,200);//搜索
		trace(s)
		*/
		public static   function binarySearch(array:Array,target:int):int{
			Algorithm.reset();
			return Algorithm.search(array,target);
		}
		
		/**   在数组中根据对象的属性来查找对象在数组中的索引，该对象除了核对属性外必须要有一个数值int型的属性    查找不到返回-1 
		 *  sortProperty  compareProperty  这两个属性值可以是一样的
				var obj1:Object={id:2,name:"kacj"};
				var obj2:Object={id:6,name:"gdgdg"};
				var obj3:Object={id:1,name:"rerr"};
				var arr:Array=[obj1,obj2,obj3];
				arr.sortOn("id");
				var index:int=Algorithm.superBinarySearch(arr,'id','name',6,"gdgdg");///查找obj2
				trace(index);
		 */		
		public static function superBinarySearch(array:Array,sortProperty:String,compareProperty:String,sortValue:int,compareValue:Object):int
		{
			Algorithm.reset();
			return Algorithm.superSearch(array,sortProperty,compareProperty,sortValue,compareValue);
		}
		private  static function reset():void
		{
			index=0
		} 
	}
}