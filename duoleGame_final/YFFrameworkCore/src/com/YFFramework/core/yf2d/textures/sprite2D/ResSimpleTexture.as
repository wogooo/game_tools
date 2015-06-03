package com.YFFramework.core.yf2d.textures.sprite2D
{
	import com.YFFramework.core.ui.yf2d.data.ATFBitmapFrame;
	import com.YFFramework.core.yf2d.core.YF2d;
	import com.YFFramework.core.yf2d.events.YF2dEvent;
	import com.YFFramework.core.yf2d.textures.TextureHelper;
	
	import flash.display.BitmapData;
	import flash.display3D.textures.TextureBase;
	
	/**  uv  rect 
	 * 2012-11-22 上午9:43:03
	 *@author yefeng
	 */
	public class ResSimpleTexture extends  ATFBitmapFrame
	{
		/**参照图片
		 */		
		public var atlasData:BitmapData;
		/**材质
		 */ 
		public var flashTexture:TextureBase;
		private var _isResetContext3d:Boolean;
		public function ResSimpleTexture(isResetContext3d:Boolean=true)
		{
			_isResetContext3d=isResetContext3d;
			if(_isResetContext3d)addEvents();
		}
		/**初始化数据
		 */		
		private function addEvents():void
		{
			YF2d.Instance.scence.addEventListener(YF2dEvent.CONTEXT_Re_CREATE_InitActionData,onCreate);
		}
		private function removeEvents():void
		{
			YF2d.Instance.scence.removeEventListener(YF2dEvent.CONTEXT_Re_CREATE_InitActionData,onCreate);
		}        

		private function onCreate(e:YF2dEvent):void
		{
			///此处 注意flashTexture不要进行dispose 因 该方法可能disposed 多次 
			flashTexture=TextureHelper.Instance.getTexture(atlasData);          
		}
//		
		override public function dispose():void
		{
			if(_isResetContext3d)removeEvents(); 
			atlasData.dispose();
			flashTexture.dispose();
			atlasData=null;
			flashTexture=null;
		}
		
		
	}
}