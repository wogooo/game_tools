package yf2d.display.batch.extensions
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import yf2d.display.DisplayObject2d;
	import yf2d.display.DisplayObjectContainer2d;
	import yf2d.display.SpriteBatch;
	
	/**  大地图基类  大于2048的图片地图   大地图是有多个SpriteScroll拼接而成的类
	 * author :夜枫
	 */
	public class Map extends DisplayObjectContainer2d
	{
		/**贴图值
		 */		
	//	protected static const Texture_4096:int=4096;
		protected static const Texture_2048:int=2048;
		protected static const Texture_1024:int=1024;
		protected static const Texture_512:int=512;
		
		protected var sourceBitmapData:BitmapData;
		/**显示的区域
		 */
		protected var viewRect:Rectangle;///当前显示的矩形框  注册点坐标也就是左上角坐标滚动点
		public function Map(sourceBitmapData:BitmapData,viewWidth:Number,viewHeight:Number)
		{
			super();
			viewRect=new Rectangle(0,0,viewWidth,viewHeight);
			initRectangle();//设置区域大小范围
			setData(sourceBitmapData);
		}
		public function setData(sourceBitmapData:BitmapData):void
		{
			this.sourceBitmapData=sourceBitmapData;
			initTexture();
		}
		protected function initRectangle():void
		{
			///子类覆盖
		}
		public function scroll(offsetX:Number,offsetY:Number):void
		{
			var px:Number=viewRect.left+offsetX;
			var py:Number=viewRect.top+offsetY;
			scrollTo(px,py);
		}
		
		protected function initTexture():void
		{
			//子类覆盖
		}
		public function scrollTo(px:Number,py:Number):void
		{
			//子类覆盖
		}
		
		
		/**  容器中只存在 childList对象   其他的对象全部移除
		 */		
		protected function addOnlyChild(childList:Vector.<DisplayObject2d>):void
		{
			this.removeChildren();
			var len:int=childList.length;
			for(var i:int=0;i!=len;++i)
				addChild(childList[i]);
		
/*			var child:DisplayObject2d;
			var childrenNum:int=this.numChildren
			for(var i:int=childrenNum-1;i>=0;i--)
			{
				child=getChildAt(i);
				if(childList.indexOf(child)==-1) removeChild(child);
			}
			var len:int=childList.length;
			for(i=0;i!=len;++i)
			{
				if(!contains(childList[i])) addChild(childList[i]);
			}
*/				
			
		}

		
		public function getViewRect():Rectangle{	return viewRect;		}
	}
}