package yf2d.display
{
	import yf2d.textures.face.ITextureBase;

	/**
	 * author :夜枫
	 * 时间 ：2011-11-27 下午05:29:35
	 */
	public class Image extends Quad
	{
		public function Image(texture:ITextureBase=null)
		{
			this._texture=texture;
			var mWidth:Number,mHeight:Number;
			if(texture)
			{
				mWidth=_texture.textureRect.width;
				mHeight=_texture.textureRect.height;
			}
			else mWidth=mHeight=2;
			super(mWidth,mHeight);
		}
		
		override public function set  texture(value:ITextureBase):void
		{
			_texture=value;
			_width=_texture.textureRect.width;
			_height=_texture.textureRect.height;
		}
		
		/** 更新宽高   当更新 Texture2d .setFrame函数时  有可能切换到其他贴图  照成贴图大小发生变化 这时  需要更新 宽高以适应新贴图的宽高
		 */		
		public function updateSize():void
		{
			_width=_texture.textureRect.width;
			_height=_texture.textureRect.height;
		}
		           
		
	}
}