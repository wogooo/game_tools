package yf2d.textures
{
	import flash.display.BitmapData;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DTextureFormat;
	import flash.display3D.textures.Texture;
	import flash.utils.ByteArray;
	
	import yf2d.errors.SingletonError;

	/**材质生成器
	 * author :夜枫
	 * 时间 ：2011-12-6 下午01:03:06
	 */
	public final class TextureHelper
	{
		private static var _instance:TextureHelper;
		private var context3d:Context3D;
		public function TextureHelper()
		{
			if(_instance) throw new SingletonError();
		}
		public function initData(context3d:Context3D):void{	this.context3d=context3d;			}
		
		public static  function get Instance():TextureHelper
		{
			if(!_instance) _instance=new TextureHelper();
			return _instance;
		} 
		
		public function getTexture(atlasData:BitmapData):Texture
		{
			////流式 处理  先加载低像素 图片生成   Texture 等高像素图片生成后在加载高像素图片生成Texture  马赛克处理手法和常规一模一样 地图也是一块一块的拼接起来的的
			var texture:Texture=context3d.createTexture(atlasData.width,atlasData.height,Context3DTextureFormat.BGRA,false);
			texture.uploadFromBitmapData(atlasData);
			return texture;
		}  
		
		/**atfBytes ATF  字节数据
		 */		
		public function getTextureFromATF(atfBytes:ByteArray,width:int,height:int):Texture
		{
			////流式 处理  先加载低像素 图片生成   Texture 等高像素图片生成后在加载高像素图片生成Texture  马赛克处理手法和常规一模一样 地图也是一块一块的拼接起来的的
			var texture:Texture = context3d.createTexture(width, height, Context3DTextureFormat.COMPRESSED, false);
			texture.uploadCompressedTextureFromByteArray(atfBytes,0);
			return texture;
		}

		
		
	}
}