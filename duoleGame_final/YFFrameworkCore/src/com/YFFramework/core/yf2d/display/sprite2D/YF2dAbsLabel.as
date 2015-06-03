package com.YFFramework.core.yf2d.display.sprite2D
{
	import com.YFFramework.core.yf2d.core.YF2d;
	import com.YFFramework.core.yf2d.events.YF2dEvent;
	import com.YFFramework.core.yf2d.textures.LineTextData;
	import com.YFFramework.core.yf2d.textures.SingleLineTextManager;
	import com.YFFramework.core.yf2d.textures.TextureHelper;
	import com.YFFramework.core.yf2d.textures.sprite2D.SingleLineTextTexture;

	/**2012-11-21 下午2:39:39
	 *@author yefeng
	 */
	public class YF2dAbsLabel extends Sprite2D
	{
		
		private var _lineTextData:LineTextData;
		
		public function YF2dAbsLabel()
		{
			super();
			_lineTextData=new LineTextData();
			addEvents();
			
		}
		private function addEvents():void
		{
			YF2d.Instance.scence.addEventListener(YF2dEvent.CONTEXT_Re_CREATE_InitMovieClip,onContextComplete);
		}
		private function removeEvents():void
		{
			YF2d.Instance.scence.removeEventListener(YF2dEvent.CONTEXT_Re_CREATE_InitMovieClip,onContextComplete);
		}
		/**重新创建文本
		 */		
		private function onContextComplete(e:YF2dEvent):void
		{
			setText(_lineTextData.text,_lineTextData.color,_lineTextData.size);
		}
		
		
		/**设置文本   主角色的文本 
		 * @param text
		 * @param color
		 * @param size
		 */		
		public function setText(text:String,color:uint=0xFFFFFF,size:int=12):void
		{
			_lineTextData.text=text;
			_lineTextData.color=color;
			_lineTextData.size=size;
			var texTure:SingleLineTextTexture=SingleLineTextManager.Instance.getTextData(text,color,size);
			setTextureData(texTure);
			setFlashTexture(texTure.getFlashTexture());
			letTopRegister();
		}
		public function get text():String
		{
			return _lineTextData.text;
		}
		
		override public function  createFlashTexture():void
		{
			setFlashTexture(TextureHelper.Instance.getTexture(_atlas));
		}
		
		public function getText():String
		{
			return _lineTextData.text;
		}
		public function getTextWidth():Number
		{
			return _texture.rect.width;
		}
		public function getTextHeight():Number
		{
			return _texture.rect.height;
		}
		
		
		override public function dispose(childrenDispose:Boolean=true):void
		{
			super.dispose(childrenDispose);
			removeEvents();
			_lineTextData.dispose();
			_lineTextData=null;
		}
		
		/** 释放到对象池
		 */		
		public function disposeToPool():void
		{
			visible=true;
			removeEvents();
			setFlashTexture(null);
		}
		/**对象池中获取数据重新初始化
		 */		
		public function initFromPool():void
		{
			addEvents();
		}
		
	}
}