package yf2d.display
{
	import flash.display.BitmapData;
	import flash.display3D.textures.Texture;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import yf2d.textures.batch.AtlasData;
	import yf2d.textures.face.ITextureBase;
	import yf2d.textures.face.ITextureScroll;
	import yf2d.textures.TextureHelper;
	import yf2d.textures.batch.TextureScroll;
	
	/** 2048范围内的单张图像滚屏
	 * author :夜枫
	 */
	public class SpriteScroll extends SpriteQuad
	{
		public function SpriteScroll(viewWidth:Number,viewHeight:Number)
		{
			super( null,viewWidth,viewHeight);
		}
		/**
		 * @param bmpData 大小必须为2的倍数   函数处理完后sourceData不作改变 ，一般情况下 可以将sourceData进行内存释放掉  调用sourceData.dispose()函数  
		 */
		public function initTexture(sourceData:BitmapData,sourceRect:Rectangle,dest:Point):void
		{
			var atlasData:AtlasData=new AtlasData(sourceRect.width,sourceRect.height);///作用是创建材质Texture 创建完Texture后 该类型就可以dispose释放了
			imageTexture=new TextureScroll(atlasData,viewWidth,viewHeight);
			TextureScroll(imageTexture).copyData(sourceData,sourceRect,dest);
			var texture:Texture=TextureHelper.Instance.getTexture(atlasData);
			setImageTexture(imageTexture);///设置Image材质
			///设置全局SPrite2d材质
			setTexture(texture);
			//释放内存 
			atlasData.dispose();
			atlasData=null;
		}
		
		public function scrollTo(px:Number,py:Number):void
		{
			ITextureScroll(imageTexture).scrollTo(px,py);
		}
		public function scroll(offsetX:Number,offsetY:Number):void
		{
			ITextureScroll(imageTexture).scroll(offsetX,offsetY);
		}
		
		/**得到当前地图的位置
		 */		
		public function getCoordinate():Point{	return 	ITextureScroll(imageTexture).getCoordinate();		}
		
	}
}