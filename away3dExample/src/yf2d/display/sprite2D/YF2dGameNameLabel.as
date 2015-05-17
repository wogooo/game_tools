package yf2d.display.sprite2D
{
	import flash.display.BitmapData;
	import flash.filters.GlowFilter;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import yf2d.textures.TextureHelper;
	import yf2d.textures.sprite2D.TextNameTexture;
	
	/**文本对象     主角色的名称    高度 为  16  宽度 为64  只能显示5个名字 也就是只能打出五个字
	 * 2012-11-21 上午11:04:21
	 *@author yefeng
	 */
	public class YF2dGameNameLabel extends YF2dAbsLabel
	{
		public function YF2dGameNameLabel()
		{
			super();
		}
		override protected function initTexure():void
		{
			_texture=new TextNameTexture();
			setTextureData(_texture);
			_atlas=new BitmapData(TextNameTexture.Width,TextNameTexture.Height);
			letTopRegister();
		}
		override protected function drawText():void
		{
			disposeFlashTexture();
			var minW:int= _textFiled.textWidth+15
			_textFiled.width=minW<_textFiled.width?minW:_textFiled.width;
			_textFiled.height=_textFiled.textHeight;
			_atlas.fillRect(_atlas.rect,0xFFFFFF);
			_atlas.draw(_textFiled);
			createFlashTexture();
		}
		
		override public function get width():Number
		{
			return _texture.rect.width;
		}
		override public function get height():Number
		{
			return _texture.rect.height;
		}

		override public function dispose(childrenDispose:Boolean=true):void
		{
			super.dispose(childrenDispose);
			if(_texture)
			{
				_texture.dispose();
				_texture=null;
			}
			disposeFlashTexture();
		}

		
	}
}