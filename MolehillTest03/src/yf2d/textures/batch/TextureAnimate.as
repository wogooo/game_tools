package yf2d.textures.batch
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.IBitmapDrawable;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import yf2d.textures.face.ITextureAnimate;
	import yf2d.textures.face.ITextureBase;
	
	

	/**   单一图片 或者多张图片显示
	 * author :夜枫
	 * 时间 ：2011-11-25 下午04:37:02
	 */
	public class TextureAnimate extends Texture2D implements ITextureAnimate
	{
			
	//	public var bitmapDataId:String;////BitmapDataCollection中 的id  通过BitmapDataCollection.Instance.
		
		/**
		 * sourceTextureData为像素源 最终要显示的图像的像素数据
		 * @param destbmpData 大小为 2的倍数 最终的贴图
		 * sourceRect sourceTextureData被复制的区域
		 * destPoint sourceTextureData放在destbmpData里的坐标位置
		 */
		protected var textureRectFrame:Vector.<Rectangle>
		protected var _frame:uint;
		protected var frameUVData:Vector.<Vector.<Number>>;
		public function TextureAnimate(destBmpData:AtlasData)
		{
			super(destBmpData);
			textureRectFrame=new Vector.<Rectangle>();
			frameUVData=new Vector.<Vector.<Number>>();
			_frame=0;
		}
		/**
		 *  将 sourceTextureData 复制到  destBmpData中去   形成一张大的地图集
		 */		
		override public function copyData(sourceTextureData:BitmapData,sourceRect:Rectangle,destPoint:Point):void
		{
			//super.copyData(sourceTextureData,sourceRect,destPoint);
			destBmpData.copyPixels(sourceTextureData,sourceRect,destPoint); 
			var rect:Rectangle=new Rectangle(0,0,sourceRect.width,sourceRect.height);
			rect.x=destPoint.x;
			rect.y=destPoint.y;
			textureRectFrame.push(rect);
		}
		
		/**设置显示的对象即显示的对象帧    默认从0开始
		 */		
		public function setFrame(value:uint):void{		_frame=value;		}
		
		/**得到_frame 状态下的uv 信息 
		 */		
		override public function getUVData(scaleY:Number=1):Vector.<Number>
		{
			if(_frame>=frameUVData.length) frameUVData.length=_frame+1;
			else if(frameUVData[_frame])  return frameUVData[_frame];
			var textureRect:Rectangle=textureRectFrame[_frame];
			var vector:Vector.<Number>=Vector.<Number>([textureRect.x/atlasWidth,textureRect.y/atlasHeight,textureRect.width/atlasWidth,textureRect.height/atlasHeight]);
			frameUVData[_frame]=vector;
			vector.fixed=true;
			return vector;
		}
		
		override public function get textureRect():Rectangle{	return 	textureRectFrame[_frame] 	}
		
		
		override public function clone():ITextureBase
		{
			var texture:TextureAnimate=new TextureAnimate(destBmpData);
			texture.textureRectFrame=textureRectFrame.concat();
			texture._frame=_frame;
			texture.frameUVData=frameUVData;
			return texture as ITextureBase;
		}
		
		override public  function dispose():void
		{
			textureRectFrame=null;
			frameUVData=null;
		}
		
		
	}
}