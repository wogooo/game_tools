package com.YFFramework.core.ui.res
{
	import com.YFFramework.core.ui.yf2d.data.BitmapFrameData;
	
	import flash.display.BitmapData;
	import flash.display3D.textures.Texture;
	
	/**  uv  rect 
	 * 2012-11-22 上午9:43:03
	 *@author yefeng
	 */
	public class ResSimpleTexture extends  BitmapFrameData
	{
		/**参照图片
		 */		
		public var atlasData:BitmapData;
		/**材质
		 */ 
		public var flashTexture:Texture;
		
		/**偏移量  x  y 
		 */		
//		public var x:int;
//		public var y:int;
		
		
//		private var _uvData:Vector.<Number>;
//		private var _rect:Rectangle;
		public function ResSimpleTexture()
		{
		}
		
//		public function getUVData(scaleY:Number=1):Vector.<Number>
//		{
//			return null;
//		}
//		public function setUVData(uvData:Vector.<Number>):void
//		{
//			_uvData=uvData;
//		}
//		
//		public function set rect(rect:Rectangle):void
//		{
//			_rect=rect;
//		}
//		
//		public function get rect():Rectangle
//		{
//			return _rect;
//		}
//		
//		public function clone():ITextureBase
//		{
//			return null;
//		}
//		
		override public function dispose():void
		{
			atlasData=null;
			flashTexture=null;
		}
	}
}