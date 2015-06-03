package com.YFFramework.core.yf2d.display.sprite2D
{
	import com.YFFramework.core.ui.yf2d.data.BitmapFrameData;
	import com.YFFramework.core.yf2d.display.DisplayObjectContainer2D;
	
	import flash.display.BitmapData;
	import flash.display3D.textures.Texture;
	import flash.display3D.textures.TextureBase;

	/**2012-11-22 上午11:01:40
	 *@author yefeng
	 */
	public class YF2dClip extends DisplayObjectContainer2D
	{
		/**默认scaleY    是否进行UV贴图进行Y 轴翻转
		 */		
		public var uvScaleY:Number=1;
		protected var _movie:Sprite2D;
		private var _bitmapFrameData:BitmapFrameData;
		public function YF2dClip()
		{
			super();
			initUI();
		}
		/** 不进行渲染
		 */		
		public function resetData():void
		{
			_movie.setFlashTexture(null);
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
			_movie.setTextureData(bitmapFrameData,scaleX,uvScaleY);
//			_movie.x=scaleX*bitmapFrameData.x;
//			_movie.y=bitmapFrameData.y*uvScaleY;
			_movie.setXY(scaleX*bitmapFrameData.x,bitmapFrameData.y*uvScaleY);
		}
		
		/**设置默认皮肤
		 */		
		public function setBitmapFrame(bitmapFrameData:BitmapFrameData,texture:TextureBase,atlasData:BitmapData,scaleX:Number=1):void
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
		public function getFlashTexture():TextureBase
		{
			return _movie.getFlashTexture();
		}
		
		public function setFlashTexture(flashTexture:Texture):void
		{
			_movie.setFlashTexture(flashTexture);
		}
		override public function dispose(childrenDispose:Boolean=true):void
		{
			super.dispose(childrenDispose);
			_bitmapFrameData=null;
			_movie=null;
			
		}
				
	}
}