package yf2d.textures.batch
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getQualifiedClassName;
	
	import yf2d.errors.AbstractClassError;
	import yf2d.textures.face.ITextureBase;

	/**
	 * author :夜枫
	 * 时间 ：2011-12-4 下午04:34:42
	 */
	public class Texture2D implements ITextureBase
	{
		protected var destBmpData:AtlasData;
		/**地图集的宽高
		 */
		protected var atlasWidth:Number;
		protected var atlasHeight:Number;
		
		private var _textureRect:Rectangle;
		private var _uvData:Vector.<Number>
		
		/**
		 * @param destBmpData   地图集  也就是一张大的bitmapData像素源
		 */
		public function Texture2D(destBmpData:AtlasData)
		{
			atlasWidth=destBmpData.width;
			atlasHeight=destBmpData.height;
			this.destBmpData=destBmpData;
		}
		public function getUVData(scaleY:int=1):Vector.<Number>{	return _uvData;	}
		
		public function get rect():Rectangle{	return 	_textureRect;	}
		
		/**
		 *  将 sourceTextureData 复制到  destBmpData中去   形成一张大的地图集
		 */		
		public function copyData(sourceTextureData:BitmapData,sourceRect:Rectangle,destPoint:Point):void
		{
			destBmpData.copyPixels(sourceTextureData,sourceRect,destPoint,null,null,true);
			_textureRect=new Rectangle(destPoint.x,destPoint.y,sourceRect.width,sourceRect.height);
			_uvData=Vector.<Number>([_textureRect.x/atlasWidth,_textureRect.y/atlasHeight,(_textureRect.width+_textureRect.x)/atlasWidth,(_textureRect.height+_textureRect.y)/atlasHeight]);
		}
		
		
		
		public function clone():ITextureBase
		{
			var texture:Texture2D=new Texture2D(this.destBmpData);
			texture._textureRect=this._textureRect.clone();
			texture._uvData=this._uvData.concat();
			return texture as ITextureBase;	
		}
		public function dispose():void
		{
			_textureRect=null;
			_uvData=null;
		}

	}
}