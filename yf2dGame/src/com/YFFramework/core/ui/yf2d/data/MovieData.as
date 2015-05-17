package com.YFFramework.core.ui.yf2d.data
{
	import flash.display.BitmapData;
	import flash.display3D.textures.Texture;
	
	import yf2d.textures.TextureHelper;

	/** 某个方向的播放数据
	 * @author yefeng
	 *20122012-11-17下午7:02:35
	 */
	public class MovieData
	{
		
		/**序列帧数据源 
		 */		
		public var dataArr:Vector.<BitmapFrameData>;

		/**大贴图源像素
		 */ 
		public var bitmapData:BitmapData;
		/**和该BitmapData相关联的的Texture  Texture不用时 需要及时dispose 需要时在通过bitmapData生成即可 因为Texture有大小限制必须这样 
		 */		
		private var _texture:Texture;
		public function MovieData()
		{
		}
		
		public function getTexture():Texture
		{
			if(!_texture)
			{
				_texture=TextureHelper.Instance.getTexture(bitmapData);
			}
			return _texture;
		}
		/**释放内存
		 */		
		public function disposeTexture():void
		{
			if(_texture)
			{
				_texture.dispose();
				_texture=null;
			}
		}
		public function dispose():void
		{
			disposeTexture();
			bitmapData.dispose();
			dataArr=null;
		}
	}
}