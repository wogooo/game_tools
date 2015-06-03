package com.YFFramework.core.net.loader.map
{
	/**加载  .jpg文件 用于低版本flash的地图加载   主要指 不能加载atf的 swf 
	 * @author yefeng
	 * 2013 2013-9-24 下午3:43:14 
	 */
	import com.YFFramework.core.net.loader.image_swf.UILoader;
	import com.YFFramework.core.net.so.ShareObjectManager;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.system.ApplicationDomain;
	import flash.utils.ByteArray;
	
	public class TileMapLoader 
	{
		/**回调 带有 bitmapData参数  和data 参数
		 */
		public var loadCompleteCallBack:Function;
		public var loader:UILoader;
		public function TileMapLoader()
		{
			super();
			loader=new UILoader();
		}
		public function load(url:String,data:Object=null):void
		{
			var bytes:ByteArray=ShareObjectManager.Instance.getObjByteArray(url) as ByteArray;
			if(bytes)
			{
				loader.loadCompleteCallback=completeIt2;
				loader.loadBytes(bytes,data);
			}
			else 
			{
				loader.loadCompleteCallback=completeIt;
				loader.initData(url,null,{data:data,url:url},null,null);
			}
		}
		
		private function completeIt(bitmap:Bitmap,data:Object):void
		{
			var url:String=data.url;
			ShareObjectManager.Instance.put(url,loader.getContentBytes());
			loadCompleteCallBack(bitmap.bitmapData,data.data);
			dispose();
		}
		
		private function completeIt2(bitmap:Bitmap,data:Object):void
		{
			loadCompleteCallBack(bitmap.bitmapData,data);
			dispose();
		}
		
		
		private function dispose():void
		{
			loader=null;
		}
			
		
	}
}