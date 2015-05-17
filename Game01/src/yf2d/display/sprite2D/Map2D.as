package yf2d.display.sprite2D
{
	/**    game scene  map 
	 * @author yefeng
	 *2012-11-20下午10:44:40
	 */
	import flash.utils.ByteArray;
	
	import yf2d.display.AbsSprite2D;
	import yf2d.textures.TextureHelper;
	import yf2d.textures.face.ITextureBase;
	import yf2d.textures.sprite2D.MapTexture;
	
	public class Map2D extends AbsSprite2D
	{
		/** atfBytes
		 */		
		public var atfBytes:ByteArray;
		
		public function Map2D(width:Number, height:Number)
		{
			super(width, height);
			super.setUVOffset(Vector.<Number>([0,0,1,1]));
		}
		
		public function disposeATFBytes():void
		{
			atfBytes.clear();
			atfBytes=null
		}
		override public function setUVOffset(uvoffset:Vector.<Number>):void
		{
			
		}
		
		override public function createFlashTexture():void
		{
			if(_flashTexture==null)	setFlashTexture(TextureHelper.Instance.getTextureFromATF(atfBytes,_texture.rect.width,_texture.rect.height));
		}
		/**@param texture2D  texture2D  must  be  MapTexture
		 * @param scaleX
		 */		
		override public function setTextureData(texture2D:ITextureBase,scaleX:Number=1):void
		{
			_texture=texture2D;
			updateSize();////更新材质大小 
		}
		/**    change the  size 
		 * @param width
		 * @param height
		 */		
		public function udateTexureSize(width:int,height:int):void
		{
			MapTexture(_texture).updateSize(width,height);
			updateSize();////更新材质大小 
		}
		override public function dispose(childrenDispose:Boolean=true):void
		{
			super.dispose(childrenDispose);
			if(atfBytes)disposeATFBytes();
		}

	}
}