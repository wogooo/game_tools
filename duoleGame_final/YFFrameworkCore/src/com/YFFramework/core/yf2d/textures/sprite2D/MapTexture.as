package com.YFFramework.core.yf2d.textures.sprite2D
{
	/**@author yefeng
	 *2012-11-20下午10:52:30
	 */
	import flash.geom.Rectangle;
	
	import com.YFFramework.core.yf2d.textures.face.ITextureBase;
	
	public class MapTexture implements ITextureBase
	{
		private var _rect:Rectangle;
		public function MapTexture()
		{
			_rect=new Rectangle();
		}
		
		public function getUVData(scaleX:Number=1,scaleY:Number=1):Vector.<Number>
		{
			return Vector.<Number>([0,0,1,1]);
		}
		
		public function get rect():Rectangle
		{
			return _rect;
		}
		
		public function updateSize(width:int,height:int):void
		{
			_rect.width=width;
			_rect.height=height;
		}
			
		
		public function clone():ITextureBase
		{
			var texture:MapTexture=new MapTexture();
			texture._rect=_rect;
			return texture;
		}
		
		public function dispose():void
		{
			_rect=null;
		}
	}
}