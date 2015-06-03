package com.YFFramework.core.yf2d.utils
{
	import com.YFFramework.core.utils.image.BitmapDataUtil;
	import com.YFFramework.core.yf2d.display.sprite2D.LowMapData;
	import com.YFFramework.core.yf2d.textures.TextureHelper;
	import com.YFFramework.core.yf2d.textures.sprite2D.ResSimpleTexture;
	import com.YFFramework.core.yf2d.textures.sprite2D.SimpleTexture2D;
	
	import flash.display.BitmapData;
	import flash.display3D.textures.Texture;
	import flash.display3D.textures.TextureBase;

	/**@author yefeng
	 * 2013 2013-4-3 下午2:58:25 
	 */
	public class SimpleTextureUtil
	{
		public function SimpleTextureUtil()
		{
		}
		/** 获取材质信息  
		 * @param content
		 * @return 
		 */		
//		public static function getTexureData(content:BitmapData):Object
//		{
//			var w:int=content.width;
//			var h:int=content.height;
//			var realData:Object=BitmapDataUtil.getValideBitmapData(content);
//			var texture2D:SimpleTexture2D=new SimpleTexture2D();
//			texture2D.setTextureRect(0,0,w,h);
//			texture2D.setUVData(Vector.<Number>([0,0,realData.u,realData.v]));
//			var texture:TextureBase=TextureHelper.Instance.getTexture(realData.data as BitmapData);
//			return {texure:texture2D,flashTexture:texture,bitmapData:realData.data};
//		}
		
		public static function getTexureData2(content:BitmapData):ResSimpleTexture
		{
			var w:int=content.width;
			var h:int=content.height;
			var realData:LowMapData=BitmapDataUtil.getValideBitmapData(content);
			var texture:TextureBase=TextureHelper.Instance.getTexture(realData.bitmapData );
			var texture2D:ResSimpleTexture=new ResSimpleTexture();
			texture2D.setTextureRect(0,0,w,h);
			texture2D.setUVData(Vector.<Number>([0,0,realData.u,realData.v]));
			texture2D.flashTexture=texture;
			texture2D.atlasData=realData.bitmapData;
			return texture2D;
		}
		
	}
}