package com.YFFramework.core.yf2d.textures
{
	import flash.display3D.textures.Texture;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;

	/**@author yefeng
	 * 2013 2013-12-10 上午10:59:54 
	 */
	public class TextureData
	{
		private static var _size:int=0;
		private static const MaxSize:int=20;
		private static var _pool:Vector.<TextureData>=new Vector.<TextureData>();
		
		
		public var texure:Texture;
		public var atfBytes:ByteArray
		public function TextureData()
		{
			
		}
		public function handle():void
		{
//			var t:Number=getTimer();
			texure.uploadCompressedTextureFromByteArray(atfBytes,0,true);
//			trace(getTimer()-t);
		}
		public static function getTextureData():TextureData
		{
			if(_size>0)
			{
				_size--;
				return _pool.pop();
			}
			return  new TextureData();
		}
		public static function toTextureDataPool(textureData:TextureData):void
		{
			if(_size<MaxSize)
			{
				_size++;
				_pool.push(textureData);
			}
			else 
			{
				textureData.texure=null;
				textureData.atfBytes=null;
			}
		}

		
		
	}
}