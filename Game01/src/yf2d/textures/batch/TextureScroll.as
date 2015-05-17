package yf2d.textures.batch
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import yf2d.textures.face.ITextureBase;
	import yf2d.textures.face.ITextureScroll;

	/**该类用于游戏地图滚屏
	 * author :夜枫
	 * 时间 ：2011-12-4 下午04:40:42
	 */
	public class TextureScroll extends Texture2D implements ITextureScroll
	{
		/**前一个uv值
		 */		
		private var preUV:Vector.<Number>;
		private var invalidUV:Boolean;//无效UV 

		private var viewWidth:Number;
		private var viewHeight:Number;
		/**左上角坐标 Left_top 当前要显示的左上角的坐标
		 */		
		private var ltPoint:Point;////坐标  
		/**
		 * @param viewWidth  显示的视口宽高大小 也就是当前显示图片的宽高
		 * @param viewHeight
		 */		
		public function TextureScroll(destBmpData:AtlasData,viewWidth:Number,viewHeight:Number)
		{
			super(destBmpData);
			ltPoint=new Point(0,0);
			setViewRect(viewWidth,viewHeight);
		}
		
		/**
		 *  将 sourceTextureData 复制到  destBmpData中去   形成一张大的地图集    
		 */		
		override public function copyData(sourceTextureData:BitmapData,sourceRect:Rectangle,destPoint:Point):void
		{
			//super.copyData(sourceTextureData,sourceRect,destPoint);
			destBmpData.copyPixels(sourceTextureData,sourceRect,destPoint); 
			ltPoint.x=destPoint.x;
			ltPoint.y=destPoint.y;
		}
		
		override public function getUVData(scaleY:int=1):Vector.<Number>
		{
			if(invalidUV)
			{
				var ltX:Number=ltPoint.x;
				var ltY:Number=ltPoint.y;
				preUV= Vector.<Number>([ltX/atlasWidth,ltY/atlasHeight,viewWidth/atlasWidth,viewHeight/atlasHeight]);
				invalidUV=false;
				return preUV;
			}
			return preUV;
		}
		/**显示的对象的大小
		 */		
		override public function get rect():Rectangle{	return 	new Rectangle(ltPoint.x,ltPoint.y,viewWidth,viewHeight)	}
		
		/**
		 * @param offsetX  x 轴方向滚动的像素
		 * @param offsetY y 轴方向滚动的像素
		 */
		public function scroll(offsetX:Number,offsetY:Number):void
		{
			var px:Number=ltPoint.x+offsetX;
			var py:Number=ltPoint.y+offsetY;
			scrollTo(px,py);
		}
		
		/**滚动至坐标  px  py处
		 */
		public function scrollTo(px:Number,py:Number):void
		{
		//	if(px==ltPoint.x&&py==ltPoint.y) return ;
			ltPoint.x=px;
			ltPoint.y=py;
			invalidUV=true;
		}
		/**得到当前地图的位置 左上角坐标
		 */		
		public function getCoordinate():Point{	return 	ltPoint;		}
		
		/** 显示的的宽高大小 也就是视口大小
		 */
		public function setViewRect(width:Number,height:Number):void
		{
			if(width==viewWidth&&height==viewHeight) return ;
			viewWidth=width;
			viewHeight=height;
			invalidUV=true;
		}
		
		override public function clone():ITextureBase
		{
			var texture:TextureScroll=new TextureScroll(destBmpData,viewWidth,viewHeight);
			texture.preUV=preUV;
			texture.ltPoint=ltPoint.clone();
			texture.invalidUV=invalidUV;
			return texture as ITextureBase;
		}
		
		override public function dispose():void
		{
			preUV=null;
			ltPoint=null;
		}
	}
}