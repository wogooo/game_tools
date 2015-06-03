package com.YFFramework.core.yf2d.display.sprite2D
{
	import com.YFFramework.core.ui.yf2d.data.ATFBitmapFrame;
	
	import flash.display3D.textures.TextureBase;

	/**当前帧的数据 用于调用接口 updateTextureData
	 * @author yefeng
	 * 2014 2014-1-11 下午3:25:51 
	 */
	public class SpriteClipData
	{
		
		public var bitmapFrameData:ATFBitmapFrame;
		
		public var scaleX:Number;
		
		public var scaleY:Number;
		
		/**flash材质
		 */
		public var flashTexure:TextureBase;
		
		public function SpriteClipData()
		{
		}
		public function dispose():void
		{
			bitmapFrameData=null;
			flashTexure=null;
		}
	}
}