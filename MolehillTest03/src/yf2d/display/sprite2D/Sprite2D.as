package yf2d.display.sprite2D
{
	import flash.geom.Rectangle;
	
	import yf2d.textures.face.ITextureBase;
	import yf2d.textures.sprite2D.ITextureSprite2D;
	import yf2d.display.AbsSprite2D;

	/**@author yefeng
	 *20122012-11-17上午3:05:12
	 */
	public class Sprite2D extends AbsSprite2D
	{
		public function Sprite2D()
		{
			super(0,0);
		}
		
		
		public function setTextureData(texture2D:ITextureSprite2D):void
		{
			_texture=texture2D;
			updateSize();////更新材质大小 
			var rect:Rectangle=_texture.textureRect;
			setUVOffset(texture2D.getUVData());////设置uv
			///设置 flash Texture
			setFlashTexture(texture2D.getFlashTexture());
		}
		

		
		
	}
}