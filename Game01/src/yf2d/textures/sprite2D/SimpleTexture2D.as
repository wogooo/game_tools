package yf2d.textures.sprite2D
{
	import flash.geom.Rectangle;
	
	import yf2d.textures.face.ITextureBase;
	
	/**2012-11-22 下午2:01:26
	 *@author yefeng
	 */
	public class SimpleTexture2D implements ITextureBase
	{
		/** 包含的信息是  uv 信息 以及  宽高大小
		 */		
		
		protected var _uvData:Vector.<Number>;
		protected var _textureRect:Rectangle;
		public function SimpleTexture2D()
		{
		}
		/**设置UV数据
		 */		
		public function setUVData(vect:Vector.<Number>):void
		{
			_uvData=vect;
		}
		
		public function getUVData(scaleY:Number=1):Vector.<Number>
		{
			return _uvData;
		}
		
		public function get rect():Rectangle
		{
			return _textureRect;
		}
		
		/**设置  贴图区域大小  用来进行宽高定位
		 * atlasX atlasY是在源图上的位置
		 */		
		public function setTextureRect(atlasX:Number,atlasY:Number,width:int,height:int):void
		{
			_textureRect=new Rectangle(atlasX,atlasY,width,height);
		}
		public function clone():ITextureBase
		{
			return null;
		}
		public function dispose():void
		{
			_textureRect=null;
			_uvData=null;
		}
	}
}