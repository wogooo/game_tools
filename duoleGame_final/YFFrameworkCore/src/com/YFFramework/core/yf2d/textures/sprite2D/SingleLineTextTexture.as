package com.YFFramework.core.yf2d.textures.sprite2D
{
	import com.YFFramework.core.yf2d.textures.face.ITextureBase;
	
	import flash.display3D.textures.TextureBase;
	import flash.geom.Rectangle;
	
	/**2012-11-21 下午2:45:33
	 *@author yefeng
	 */
	public class SingleLineTextTexture implements ITextureBase
	{
		protected var _uvData:Vector.<Number>;
		protected var _rect:Rectangle;
		private var _flashTexture:TextureBase;
		public function SingleLineTextTexture()
		{
		}
		public function setUVData(uvData:Vector.<Number>):void
		{
			_uvData=uvData;
		}
		/**设置矩形区域
		 */		
		public function setRect(rect:Rectangle):void
		{
			_rect=rect;
		}
		/**设置贴图
		 */		
		public function setFlashTexture(texture:TextureBase):void
		{
			_flashTexture=texture;
		}
		public function disposeTexture():void
		{
			if(_flashTexture)
			{
				_flashTexture.dispose();
				_flashTexture=null;
			}
		}
		public function getFlashTexture():TextureBase
		{
			return _flashTexture;
		}
		
		public function getUVData(scaleX:Number=1,scaleY:Number=1):Vector.<Number>
		{
			return _uvData;
		}
		
		public function get rect():Rectangle
		{
			return _rect;
		}
		
		public function clone():ITextureBase
		{
			var texture:SingleLineTextTexture=new SingleLineTextTexture();
			texture._uvData=_uvData;
			texture._rect=_rect;
			texture._flashTexture=_flashTexture;
			return texture;
		}
		
		public function dispose():void
		{
			disposeTexture();
			_uvData=null;
			_rect=null;
		}
		
	}
}