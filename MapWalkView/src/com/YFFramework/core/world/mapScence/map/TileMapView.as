package com.YFFramework.core.world.mapScence.map
{
	/**
	 *  图切片单元
	 *   2012-7-2
	 *	@author yefeng
	 */
	import com.YFFramework.core.center.pool.IPool;
	import com.YFFramework.core.center.pool.PoolCenter;
	import com.YFFramework.core.utils.IDCreator;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	public class TileMapView extends Bitmap 
	{
		public function TileMapView(bitmapData:BitmapData=null)
		{
			super(bitmapData,"auto", true);
		}
		
		/** 将图片宽高放大一像素
		 */
		override public function set bitmapData(value:BitmapData):void
		{
			super.bitmapData=value;
			if(bitmapData)
			{
				scaleX=(super.bitmapData.width+1)/super.bitmapData.width;
				scaleY=(super.bitmapData.height+1)/super.bitmapData.height;
			}
		}
		public function dispose():void
		{
			if(bitmapData)	bitmapData.dispose();
			super.bitmapData=null;
		}
		


	}
}