package yf2d.textures.sprite2D
{
	/**@author yefeng
	 *20122012-11-17上午3:24:57
	 */
	import com.YFFramework.core.debug.print;
	
	import flash.display.BitmapData;
	import flash.display3D.textures.Texture;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	
	import yf2d.textures.TextureHelper;
	import yf2d.textures.face.ITextureBase;
	
	public class Sprite2DTexture implements ITextureSprite2D
	{
		private var _uvData:Vector.<Number>;
		private var _uvDataScaleX:Vector.<Number>;
		protected var _textureRect:Rectangle;
		private var _bitmapData:BitmapData;
		private var atlasWidth:int;
		private var atlasHeight:int;
		private var _texture:Texture;
		public function Sprite2DTexture(bitmapData:BitmapData)
		{
			_bitmapData=bitmapData;
			initData(_bitmapData);
		}
		/**创建材质
		 */
		private function initData(bitmapData:BitmapData):void
		{
//			var  myW:int=int(Math.ceil(bitmapData.width*0.5));
//			var myH:int=int(Math.ceil(bitmapData.height*0.5));
//			if(myW==0)myW=1;
//			if(myH==0)myH=1;
//			atlasWidth=myW<<1;
//			atlasHeight=myH<<1;
			atlasWidth=bitmapData.width;
			atlasHeight=bitmapData.height;
			_textureRect=new Rectangle(0,0,bitmapData.width,bitmapData.height);
			////创建  uv  
			_uvData=new Vector.<Number>();
			_uvDataScaleX=new Vector.<Number>();
			_uvData=Vector.<Number>([_textureRect.x/atlasWidth,_textureRect.y/atlasHeight,_textureRect.width/atlasWidth,_textureRect.height/atlasHeight]);
			_uvDataScaleX=Vector.<Number>([_textureRect.width/atlasWidth,_textureRect.y/atlasHeight,_textureRect.x/atlasWidth,_textureRect.height/atlasHeight]);
			
			var t:Number=getTimer();
			///创建 Texture
			_texture=TextureHelper.Instance.getTexture(_bitmapData);
			
			print(this,"时间",getTimer()-t); //// texture 不用时 则即时dispose 只保存BitmapData 用时在生成Textue 因为Texture的数量有限制
		}
		

		
		/**@param scaleX 进行镜像翻转需要
		 * scaleX 只能为  1  或者-1
		 */		 
		public function getUVData(scaleX:Number=1):Vector.<Number>
		{
			if(scaleX==1)return _uvData;
			else if(scaleX==-1)return _uvDataScaleX;
			return null;
		}
		
		public function get rect():Rectangle
		{
			return _textureRect;
		}
		
		public function clone():ITextureBase
		{
			var texture:Sprite2DTexture=new Sprite2DTexture(this._bitmapData);
			texture._textureRect=this._textureRect.clone();
			texture._uvData=this._uvData.concat();
			texture._uvDataScaleX=_uvDataScaleX.concat();
			return texture as ITextureBase;	
		}
		
		
		public function getFlashTexture():Texture
		{
			return _texture;
		}
		
		public function dispose():void
		{
			
			_textureRect=null;
			_uvData=null;
			_uvDataScaleX=null;
			_texture=null;
		}
		
		public function disposeTexture():void
		{
			if(_texture)
			{
				_texture.dispose();
				_texture=null;
			}
		}
		
//
//		/**该贴图在 源图上的x y 坐标 用于检测透明部分
//		 */		
//		public function getAtlasX():Number
//		{
//			return 0;
//		}
//		/**该贴图在 源图上的x y 坐标  用于检测透明部分
//		 */	
//		public function getAtlasY():Number
//		{
//			return 0;
//		}
		
		
	}
}