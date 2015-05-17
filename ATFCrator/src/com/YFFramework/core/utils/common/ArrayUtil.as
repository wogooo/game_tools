package com.YFFramework.core.utils.common
{
	import flash.display.BitmapData;
	import flash.utils.ByteArray;
	import flash.utils.Endian;

	/**
	 * author :夜枫 * 时间 ：Sep 21, 2011 1:25:09 PM
	 */
	public class ArrayUtil
	{
		/** 支持泛型
		 */		
		public function ArrayUtil()
		{
		}
		
		public static function addElement(arr:Array,obj:Object):void
		{
			var index:int=arr.indexOf(obj);
			if(index==-1)arr.push(obj);
		}
		
		public static function removeElement(arr:Array,obj:Object):void
		{
			var index:int=arr.indexOf(obj);
			if(index!=-1)arr.splice(index,1);
		}
		
		
		
		
		public static  function  arrayToVectorBitmapData(sourceArr:Array):Vector.<BitmapData>
		{
			var len:int=sourceArr.length;
			var vector:Vector.<BitmapData>=new Vector.<BitmapData>();
			for(var i:int=0;i!=len;++i)
			{
				vector.push(sourceArr[i]);
			}
			return vector;
			
		}
	}
}