package com.dolo.common
{
	public class XFind
	{
		
		/**
		 * 查找某个数据是否位于数组中 
		 * @param data
		 * @param arr
		 * @return 
		 * 
		 */
		public static function checkDataIsInArray(data:*,arr:Array):Boolean
		{
			var isIn:Boolean = false;
			var len:int = arr.length;
			for(var i:int=0;i<len;i++){
				if(arr[i] == data){
					isIn = true;
					break;
				}
			}
			return isIn;
		}
		
		/**
		 * 查找某个数据在数组中的位置 
		 * @param data
		 * @param arr
		 * @return 
		 * 
		 */
		public static function findIndexInArray(data:*,arr:Array):int
		{
			var index:int = -1
			var len:int = arr.length;
			for(var i:int=0;i<len;i++){
				if(arr[i] == data){
					index = i;
					break;
				}
			}
			return index;
		}
		
		public static function findIndexInVector(data:*,vct:Object):int
		{
			var len:int = vct.length;
			for(var i:int=0;i<len;i++){
				if(vct[i]==data){
					return i;
				}
			}
			return -1;
		}
		
	}
}