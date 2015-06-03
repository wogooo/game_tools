package com.YFFramework.core.yf2d.textures
{
	import com.YFFramework.core.debug.print;
	import com.YFFramework.core.yf2d.core.YF2d;
	import com.YFFramework.core.yf2d.events.YF2dEvent;
	import com.YFFramework.core.yf2d.textures.sprite2D.SingleLineTextTexture;
	
	import flash.display.BitmapData;
	import flash.display3D.textures.TextureBase;
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;

	/**单行 文本管理器  生成 文字需要的 Texture 
	 * @author yefeng
	 * 2013 2013-5-3 下午4:11:08 
	 */
	public class SingleLineTextManager
	{
		protected static const  _glowFilter:GlowFilter=new GlowFilter(0x000000,1,2,2,2);  ///滤镜文本
		private static var _instance:SingleLineTextManager;
		private static const Width:int=256;
		private static const Height:int=32;
		private var _textFiled:TextField;
		private var _bitmapData:BitmapData;
		/**缓存 Texture
		 */		
		private var _cache:Dictionary;
		public function SingleLineTextManager()
		{
			_bitmapData=new BitmapData(Width,Height,true,0xFFFFFF);
			_cache=new Dictionary();
			initText();
			YF2d.Instance.scence.addEventListener(YF2dEvent.CONTEXT_Re_CREATE_InitActionData,onDataCreate);
		}
		/**重复创建context  释放上一次的texture
		 * 
		 */		
		private function onDataCreate(e:YF2dEvent):void
		{
			
//			for each(var texture:SingleLineTextTexture in _cache)
//			{
//				texture.dispose();
//			}
			_cache=new Dictionary();
		}
		public static function get Instance():SingleLineTextManager
		{
			if(_instance==null) _instance=new SingleLineTextManager();
			return _instance;
		}
		private function initText():void
		{
			_textFiled=new TextField();
			_textFiled.filters=[_glowFilter];
			_textFiled.autoSize="left";

		}
		/**   获取该文本对应的贴图， 只对应 单行贴图
		 */		
		public function getTextData(text:String,color:uint=0xFFFFFF,size:int=12):SingleLineTextTexture
		{
			var key:String=getSingleKey(text,color,size);
			var textTexture:SingleLineTextTexture=_cache[key];
			if(!textTexture)
			{
				
				_textFiled.text=text;
				_textFiled.textColor=color;
				var f:TextFormat=new TextFormat();
				f.size=size;
				_textFiled.setTextFormat(f);
				_textFiled.width=_textFiled.textWidth+2;
				_textFiled.height=_textFiled.textHeight+1;
				drawText(key);	
			}
			textTexture=_cache[key];
			return textTexture;
		}
		
		protected function drawText(key:String):void
		{
			var t:Number=getTimer();
			_bitmapData.fillRect(_bitmapData.rect,0xFFFFFF);
			_bitmapData.draw(_textFiled);
			var texture:TextureBase=TextureHelper.Instance.getTexture(_bitmapData);
			///设置 UV
			var uvData:Vector.<Number>= Vector.<Number>([0,0,_textFiled.width/_bitmapData.width,_textFiled.height/_bitmapData.height]);
			var rect:Rectangle=new Rectangle(0,0,_textFiled.width,_textFiled.height);
			var textTexture:SingleLineTextTexture=new SingleLineTextTexture();
			textTexture.setFlashTexture(texture);
			textTexture.setUVData(uvData);
			textTexture.setRect(rect);
			_cache[key]=textTexture;
		}
		
		private function getSingleKey(text:String,color:uint=0xFFFFFF,size:int=12):String
		{
			var key:String=text+color+""+size;
			return key;
		}

		
	}
}