package yf2d.textures.sprite2D
{
	import flash.display.BitmapData;
	import flash.display3D.textures.Texture;
	import flash.geom.Rectangle;
	
	import yf2d.textures.TextureHelper;
	import yf2d.textures.face.ITextureBase;
	import yf2d.utils.getTwoPower;
	
	/**2012-11-21 下午2:45:33
	 *@author yefeng
	 */
	public class TextTexture implements ITextureBase
	{
		protected var _uvData:Vector.<Number>;
		
		protected var _rect:Rectangle;
		
		protected var _atlas:BitmapData; 
		protected var _bitmapData:BitmapData;
		private var _flashTexture:Texture;
		public function TextTexture()
		{
		}
		
		public function set bitmapData(value:BitmapData):void
		{
			_bitmapData=value;
			var w:int=getTwoPower(_bitmapData.width);
			var h:int=getTwoPower(_bitmapData.height);
			_atlas=new BitmapData(w,h,true,0x0);
			_rect=new Rectangle();
			_rect.width=_bitmapData.width;
			_rect.height=_bitmapData.height;
			_uvData=Vector.<Number>([0,0,_bitmapData.width/_atlas.width,_bitmapData.height/_atlas.height]);
			disposeTexture();
			_flashTexture=TextureHelper.Instance.getTexture(_atlas);
			_bitmapData.dispose();
			_atlas.dispose();
		}
		
		public function disposeTexture():void
		{
			if(_flashTexture)
			{
				_flashTexture.dispose();
				_flashTexture=null;
			}
		}
		public function getFlashTexture():Texture
		{
			return _flashTexture;
		}
		
		public function getUVData(scaleY:Number=1):Vector.<Number>
		{
			return _uvData;
		}
		
		public function get rect():Rectangle
		{
			return _rect;
		}
		
		public function clone():ITextureBase
		{
			var texture:TextTexture=new TextTexture();
			texture._uvData=_uvData;
			texture._rect=_rect;
			texture._atlas=_atlas;
			texture._bitmapData=_bitmapData;
			texture._flashTexture=_flashTexture;
			return texture;
		}
		
		public function dispose():void
		{
			disposeTexture();
			_uvData=null;
			_rect=null;
			_atlas=null;
			_bitmapData=null;
		}
		
	}
}