package com.YFFramework.core.yf2d.display.sprite2D
{
	import com.YFFramework.core.yf2d.core.YF2d;
	import com.YFFramework.core.yf2d.display.AbsSprite2D;
	import com.YFFramework.core.yf2d.events.YF2dEvent;
	import com.YFFramework.core.yf2d.textures.TextureHelper;
	
	import flash.utils.ByteArray;

	/**游戏中 低像素图片   场景地图      mapName  ==mapId+"m.atf"
	 * @author yefeng
	 * 2013 2013-5-28 下午5:47:58 
	 */
	public class LowMap extends AbsSprite2D
	{
		public var renderWidth:int;
		public var renderHeight:int;
		/**是否重复创建
		 */		
		protected var _reCreate:Boolean;

		public var atfBytes:ByteArray;
		public function LowMap()
		{ 
			super(2,2); 
			addEvents();
			_reCreate=false;
		}
		
		/**侦听 context3d重复创建事件
		 */		
		private function addEvents():void
		{
			YF2d.Instance.scence.addEventListener(YF2dEvent.CONTEXT_Re_CREATE_InitActionData,onRecreate);
			
		}
		/**移除context3d重复创建事件
		 */		
		private function removeEvents():void
		{
			YF2d.Instance.scence.removeEventListener(YF2dEvent.CONTEXT_Re_CREATE_InitActionData,onRecreate);
		}
		
		/**context3d 重复创建
		 */		
		private function onRecreate(e:YF2dEvent):void
		{
			_reCreate=true;
			createFlashTexture();
		}

		
		
//		override public function setTextureData(texture2D:ITextureBase,scaleX:Number=1,scaleY:Number=1):void
//		{
//			_textureScaleX=scaleX;
//			_texture=texture2D;
//			updateSize();////更新材质大小 
//			//	var rect:Rectangle=_texture.textureRect;
//			setUVOffset(texture2D.getUVData(scaleX,scaleY));////设置uv
//		}
//		
//		override public function setUVOffset(uvoffset:Vector.<Number>):void
//		{
//			this.uvoffset=uvoffset; 
//			if(uvoffset)uvoffset.fixed=true;
//		}


		
		override public function createFlashTexture():void
		{
			if(_flashTexture==null)	
			{
				if(atfBytes)
				{
					setFlashTexture(TextureHelper.Instance.getTextureFromATFAlphaMap(atfBytes,renderWidth,renderHeight));
				}
				_reCreate=false;
			}
			else 
			{	
				if(_reCreate)
				{
					if(atfBytes)
					{
						setFlashTexture(TextureHelper.Instance.getTextureFromATFAlphaMap(atfBytes,renderWidth,renderHeight));
						
					}
					_reCreate=false;
				}
			}
		}
		override public function dispose(childrenDispose:Boolean=true):void
		{
			super.dispose(childrenDispose);
			removeEvents();
		}
		/**释放所有的材质信息
		 */		
		public function disposeAllData():void
		{
			if(atfBytes)atfBytes.clear();
			atfBytes=null;
			disposeFlashTexture();
			
		}
		
		
		
	}
}