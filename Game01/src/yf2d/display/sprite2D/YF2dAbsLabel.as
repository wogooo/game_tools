package yf2d.display.sprite2D
{
	import flash.filters.GlowFilter;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import yf2d.textures.TextureHelper;

	/**2012-11-21 下午2:39:39
	 *@author yefeng
	 */
	public class YF2dAbsLabel extends Sprite2D
	{
		protected var _textFiled:TextField;
		protected static const  _glowFilter:GlowFilter=new GlowFilter(0x000000,1,2,2,2);;  ///滤镜文本

		public function YF2dAbsLabel()
		{
			super();
			initUI();
			initTexure();
		}
		private function initUI():void
		{
			_textFiled=new TextField();
			_textFiled.filters=[_glowFilter];
			_textFiled.autoSize="left";
			_textFiled.antiAliasType = AntiAliasType.ADVANCED;
		}
		protected function initTexure():void
		{

		}
		/**设置文本   主角色的文本 
		 * @param text
		 * @param color
		 * @param size
		 */		
		public function setText(text:String,color:uint=0xFFFFFF,size:int=12):void
		{
			_textFiled.text=text;
			_textFiled.textColor=color;
			var f:TextFormat=new TextFormat();
			f.size=size;
			_textFiled.setTextFormat(f);
			drawText();	
		}
		public function get text():String
		{
			return _textFiled.text;
		}
		
		
		protected function drawText():void
		{
			disposeFlashTexture();
			var minW:int= _textFiled.textWidth+15
			_textFiled.width=minW<_textFiled.width?minW:_textFiled.width;
			_textFiled.height=_textFiled.textHeight;
			_atlas.fillRect(_atlas.rect,0xFFFFFF);
			_atlas.draw(_textFiled);
		}
		
		override public function  createFlashTexture():void
		{
			setFlashTexture(TextureHelper.Instance.getTexture(_atlas));
		}
		
		/**清空文本
		 */		
		public function clearText():void
		{
			_textFiled.text="";
		}
		public function getText():String
		{
			return _textFiled.text;
		}
		public function getTextWidth():Number
		{
			return _textFiled.textWidth;
		}
		public function getTextHeight():Number
		{
			return _textFiled.textHeight;
		}
		
		
		override public function dispose(childrenDispose:Boolean=true):void
		{
			super.dispose(childrenDispose);
			disposeFlashTexture();
			if(_atlas)	_atlas.dispose();
			_atlas=null; 
			_textFiled.text="";
			_textFiled=null;
		}
	}
}