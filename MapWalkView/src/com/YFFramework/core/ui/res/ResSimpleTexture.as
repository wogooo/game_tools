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
		
		public function ResSimpleTexture()
		{
		}
		

//		
		override public function dispose():void
		{
			atlasData=null;
			flashTexture=null;
		}
	}
}