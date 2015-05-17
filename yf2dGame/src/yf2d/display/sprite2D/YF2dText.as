package yf2d.display.sprite2D
{
	import flash.display.BitmapData;
	
	import yf2d.textures.sprite2D.TextTexture;

	/**2012-11-21 下午4:01:45
	 *@author yefeng
	 */
	public class YF2dText extends YF2dAbsLabel
	{
		public function YF2dText()
		{
			super();
		}
		override protected function initTexure():void
		{
			_texture=new TextTexture();
		}
		
		override protected function drawText():void
		{
			TextTexture(_texture).disposeTexture();
			if(_atlas)_atlas.dispose();
			var minW:int= _textFiled.textWidth+5
			_textFiled.width=minW<_textFiled.width?minW:_textFiled.width;
			_textFiled.height=_textFiled.textHeight;
			_atlas=new BitmapData(_textFiled.width,_textFiled.height,true,0x0);
			_atlas.draw(_textFiled);
			///创建新的
			TextTexture(_texture).bitmapData=_atlas;
			setTextureData(_texture);
			setFlashTexture(TextTexture(_texture).getFlashTexture());
		}
		
		override public function dispose(childrenDispose:Boolean=true):void
		{
			super.dispose(childrenDispose);
			TextTexture(_texture).dispose();
			if(_atlas)_atlas.dispose();
			_atlas=null; 
			_textFiled.text="";
			_textFiled=null;
		}

		

	}
}