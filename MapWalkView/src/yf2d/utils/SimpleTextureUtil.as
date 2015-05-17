package yf2d.utils
{
	import com.YFFramework.core.ui.res.ResSimpleTexture;
	import com.YFFramework.core.utils.image.BitmapDataUtil;
	
	import flash.display.BitmapData;
	import flash.display3D.textures.Texture;
	
	import yf2d.textures.TextureHelper;
	import yf2d.textures.sprite2D.SimpleTexture2D;

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
		public static function getTexureData(content:BitmapData):Object
		{
			var w:int=content.width;
			var h:int=content.height;
			var realData:Object=BitmapDataUtil.getValideBitmapData(content);
			var texture2D:SimpleTexture2D=new SimpleTexture2D();
			texture2D.setTextureRect(0,0,w,h);
			texture2D.setUVData(Vector.<Number>([0,0,realData.u,realData.v]));
			var texture:Texture=TextureHelper.Instance.getTexture(realData.data as BitmapData);
			return {texure:texture2D,flashTexture:texture,bitmapData:realData.data};
		}
		
		public static function getTexureData2(content:BitmapData):ResSimpleTexture
		{
			var w:int=content.width;
			var h:int=content.height;
			var realData:Object=BitmapDataUtil.getValideBitmapData(content);
			var texture:Texture=TextureHelper.Instance.getTexture(realData.data as BitmapData);
			var texture2D:ResSimpleTexture=new ResSimpleTexture();
			texture2D.setTextureRect(0,0,w,h);
			texture2D.setUVData(Vector.<Number>([0,0,realData.u,realData.v]));
			texture2D.flashTexture=texture;
			texture2D.atlasData=realData.data;
			return texture2D;
		}
		
	}
}