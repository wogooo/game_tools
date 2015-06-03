package com.dolo.common
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.text.TextField;

	public class GlobalPools
	{
		private static var _spritePool:ObjectPool;
		private static var _bitmapPool:ObjectPool;
		private static var _textFieldPool:ObjectPool;
		
		public static function get textFieldPool():ObjectPool
		{
			if(_textFieldPool == null){
				_textFieldPool = new ObjectPool(TextField);
				_textFieldPool.returnCallFunction = clearTextField;
			}
			return _textFieldPool;
		}
		
		private static function clearTextField(txt:TextField):void
		{
			txt.filters = null;
			txt.text = "";
			txt.htmlText = "";
		}

		public static function get bitmapPool():ObjectPool
		{
			if(_bitmapPool == null){
				_bitmapPool = new ObjectPool(Bitmap);
				_bitmapPool.returnCallFunction = clearBitmap;
			}
			return _bitmapPool;
		}
		
		private static function clearBitmap(bp:Bitmap):void
		{
			bp.bitmapData = null;
			bp.scaleX = bp.scaleY = 1;
			bp.alpha = 1;
		}

		public static function get spritePool():ObjectPool
		{
			if(_spritePool == null){
				_spritePool = new ObjectPool(Sprite);
				_spritePool.returnCallFunction = clearSprite;
			}
			return _spritePool;
		}
		
		private static function clearSprite(sp:Sprite):void
		{
			while(sp.numChildren>0){
				sp.removeChildAt(0);
			}
			sp.scaleX = sp.scaleY = 1;
			sp.alpha = 1;
		}

	}
}