package yf2d.display.sprite2D
{
	import com.YFFramework.core.ui.yf2d.data.BitmapFrameData;
	
	import flash.display.BitmapData;
	import flash.display3D.textures.Texture;
	
	import yf2d.display.DisplayObjectContainer2D;

	/**2012-11-22 上午11:01:40
	 *@author yefeng
	 */
	public class YF2dClip extends DisplayObjectContainer2D
	{
		protected var _movie:Sprite2D;
		
		private var _bitmapFrameData:BitmapFrameData;
		public function YF2dClip()
		{
			super();
			initUI();
		}
		
		public function updateUVData(uvoffset:Vector.<Number>):void
		{
			_movie.setUVOffset(uvoffset);
		}
		protected function initUI():void
		{
			_movie=new Sprite2D();
			addChild(_movie);
		}
		
		public function updateTextureData(bitmapFrameData:BitmapFrameData,scaleX:Number=1):void
		{
			_movie.setTextureData(bitmapFrameData,scaleX);
			_movie.x=scaleX*bitmapFrameData.x;
			_movie.y=bitmapFrameData.y;
		}
		
		/**设置默认皮肤
		 */		
		public function setBitmapFrame(bitmapFrameData:BitmapFrameData,texture:Texture,atlasData:BitmapData,scaleX:Number=1):void
		{
			_bitmapFrameData=bitmapFrameData;
			updateTextureData(bitmapFrameData,scaleX);
			_movie.setFlashTexture(texture);
			_movie.setAtlas(atlasData);
		}
		public function getBitmapFrameData():BitmapFrameData
		{
			return _bitmapFrameData;
		}
		public function getFlashTexture():Texture
		{
			return _movie.getFlashTexture();
		}
		
		public function setFlashTexture(flashTexture:Texture):void
		{
			_movie.setFlashTexture(flashTexture);
		}
				
	}
}