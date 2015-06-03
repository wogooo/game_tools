package com.YFFramework.core.ui.abs
{
	/** 九宫格工具类
	 * 
	 *   使用  
	 *	 var bmp:Bitmap=new Bitmap();
		addChild(bmp);
		bmp.x=bmp.y=100
		var data:BitmapData=new BitmapData(mc.width,mc.height);
		data.draw(mc);
		bmp.bitmapData=data;
		var obj:Scale9Bitmap=new Scale9Bitmap(bmp);
		addChild(obj)
		obj.x=obj.y=250
		obj.width=200
		obj.height=100
	 *  bmp.bitmapData.dispose();//释放内存
	 * 
	 *   obj内存释放 
	 * 	 obj.dispose();
	 * 
	 **/
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.IBitmapDrawable;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	public class Scale9Bitmap extends AbsUIView
	{
		
		private var source : BitmapData;
		
		private var scaleGridTop : Number;
		private var scaleGridLeft : Number;
		
		private var scaleGridBottom : Number;
		private var scaleGridRight : Number;
		
		private var leftUp : Bitmap;
		private var leftCenter : Bitmap;
		private var leftBottom : Bitmap;
		private var centerUp : Bitmap;
		private var center : Bitmap;
		private var centerBottom : Bitmap;
		private var rightUp : Bitmap;
		private var rightCenter : Bitmap;
		private var rightBottom : Bitmap;
		
		private var _width : Number;
		private var _height : Number;
		
		private var minWidth : Number;
		private var minHeight : Number;
		
		
		////优化
		private static var _caheDict:Dictionary=new Dictionary();
		
		/**
		 * @param source 要缩放的 图像
		 * @param top  底部位置
		 * @param bottom   线距离底部的距离
		 * @param left  左边位置
		 * @param right  距离右边距的位置
		 * 
		 */		
		public function Scale9Bitmap(source:BitmapData, top:Number=20, bottom:Number=20, left:Number=20, right:Number=20)
		{
			_width = source.width;
			_height = source.height;
			this.source = source;
			this.scaleGridTop = top;
			this.scaleGridBottom =_height-bottom;
			this.scaleGridLeft = left;
			this.scaleGridRight = _width-right;
			super(false);
			mouseChildren=false;
			
			width=_width;
			height=_height;
		}
		
		override protected function initUI():void
		{
			
			if(_caheDict[source]==null)	initBitmapFromSource();
			else initBitmapFromCache();
			initMinWH();
		}
		
		protected function initMinWH():void
		{
			minWidth = leftUp.width + rightUp.width;
			minHeight = leftBottom.height + leftUp.height;
		}
		/**第一次初始化所有的bitmapData
		 */ 
		private function initBitmapFromSource():void
		{
			leftUp = getBitmap(0, 0, scaleGridLeft, scaleGridTop);
			this.addChild(leftUp);
			
			leftCenter = getBitmap(0, scaleGridTop, scaleGridLeft, scaleGridBottom - scaleGridTop);
			this.addChild(leftCenter);
			
			leftBottom = getBitmap(0, scaleGridBottom, scaleGridLeft, source.height - scaleGridBottom);
			this.addChild(leftBottom);
			
			centerUp = getBitmap(scaleGridLeft, 0, scaleGridRight - scaleGridLeft, scaleGridTop);
			this.addChild(centerUp);
			
			center = getBitmap(scaleGridLeft, scaleGridTop, scaleGridRight - scaleGridLeft, scaleGridBottom - scaleGridTop);
			this.addChild(center);
			
			centerBottom = getBitmap(scaleGridLeft, scaleGridBottom, scaleGridRight - scaleGridLeft, source.height - scaleGridBottom);
			this.addChild(centerBottom);
			
			rightUp = getBitmap(scaleGridRight, 0, source.width - scaleGridRight, scaleGridTop);
			this.addChild(rightUp);
			
			rightCenter = getBitmap(scaleGridRight, scaleGridTop, source.width - scaleGridRight, scaleGridBottom - scaleGridTop);
			this.addChild(rightCenter);
			
			rightBottom = getBitmap(scaleGridRight, scaleGridBottom, source.width - scaleGridRight, source.height - scaleGridBottom);
			this.addChild(rightBottom);
			
			initCacheData();
		}
		
		/**从缓存中初始化
		 */ 
		private function initBitmapFromCache():void
		{
			leftUp = new Bitmap(_caheDict[source].leftUp);
			this.addChild(leftUp);
			
			leftCenter = new Bitmap(_caheDict[source].leftCenter);
			this.addContent(leftCenter,0,scaleGridTop);
			
			leftBottom = new Bitmap(_caheDict[source].leftBottom);
			this.addContent(leftBottom,0, scaleGridBottom);
			
			centerUp = new Bitmap(_caheDict[source].centerUp);
			this.addContent(centerUp,scaleGridLeft, 0);
			
			center = new Bitmap(_caheDict[source].center);
			this.addContent(center,scaleGridLeft, scaleGridTop);
			
			centerBottom = new Bitmap(_caheDict[source].centerBottom);
			this.addContent(centerBottom,scaleGridLeft, scaleGridBottom);
			
			rightUp = new Bitmap(_caheDict[source].rightUp);
			this.addContent(rightUp,scaleGridRight, 0);
			
			rightCenter = new Bitmap(_caheDict[source].rightCenter);
			this.addContent(rightCenter,scaleGridRight, scaleGridTop);
			
			rightBottom = new Bitmap(_caheDict[source].rightBottom);
			this.addContent(rightBottom,scaleGridRight, scaleGridBottom);
		}
		
		
		/**将其数据缓存起来
		 */ 
		protected function initCacheData():void
		{
			var cacheData:Scale9BitmapDataCahce=new Scale9BitmapDataCahce();
			cacheData.leftUp=leftUp.bitmapData;
			cacheData.leftCenter=leftCenter.bitmapData;
			cacheData.leftBottom=leftBottom.bitmapData;
			cacheData.centerUp=centerUp.bitmapData;
			cacheData.center=center.bitmapData;
			cacheData.centerBottom=centerBottom.bitmapData;
			cacheData.rightUp=rightUp.bitmapData;
			cacheData.rightCenter=rightCenter.bitmapData;
			cacheData.rightBottom=rightBottom.bitmapData;
			_caheDict[source]=cacheData;
			
		}
		
		
		
		private function getBitmap(x:Number, y:Number, w:Number, h:Number) : Bitmap 
		{
			var bit:BitmapData=null ;
			if(w!=0&&h!=0)
			{
				bit= new BitmapData(w, h);
				bit.copyPixels(source, new Rectangle(x, y, w, h), new Point(0, 0));
			}
			var bitMap:Bitmap = new Bitmap(bit);
			bitMap.x = x;
			bitMap.y = y;
			return bitMap;
		}
		
		override public function set width(w : Number) : void
		{
			if(w < minWidth)
				w = minWidth;
			_width = w;
			refurbishSize();
		}
		/**设置九宫格中间部分的宽度
		 */		
		public function setContentWidth(contentWidth:Number):void
		{
			width=contentWidth+scaleGridLeft+scaleGridRight;
		}
		
		/**  中间部分的 宽度
		 */
		public function getContentWidth():Number
		{
			return  center.width;
		}

		
		override public function set height(h : Number) : void 
		{
			if(h < minHeight) 
				h = minHeight;
			_height = h;
			refurbishSize();
		}
		
		/**设置九宫格中间部分的高度
		 */		
		public function setContentHeight(contentHeight:Number):void
		{
			height=contentHeight+scaleGridTop+scaleGridBottom;
		}
		/**中间部分的高度
		 */
		public function getContentHeight():Number
		{
			return center.height;
		}
		
		private function refurbishSize() : void
		{
			leftCenter.height =( _height - leftUp.height - leftBottom.height);
			leftBottom.y = _height - leftBottom.height;
			centerUp.width = (_width - leftCenter.width - rightCenter.width);
			center.width =(_width - leftCenter.width - rightCenter.width);
			center.height = ( _height - leftUp.height - leftBottom.height);
			centerBottom.width = center.width;
			centerBottom.y = leftBottom.y;
			rightUp.x = _width - rightCenter.width;
			rightCenter.x = rightUp.x;
			rightCenter.height = center.height;
			rightBottom.x = rightUp.x;
			rightBottom.y = leftBottom.y;
		}
		
		
		
//		override public function removeAllContent(dispose:Boolean=false):void
//		{
//			var len:int=numChildren;
//			var child:Bitmap;
//			for(var i:int=0;i!=len;++i)
//			{
//				child=removeChildAt(0) as Bitmap;
//				if(dispose)
//				{
//					child.bitmapData.dispose();
//					child=null;
//				}
//			}
//		}
		
		
		/**得到一个实例
		 */
		public static function getInstance(mc:IBitmapDrawable,top:Number=20, bottom:Number=20, left:Number=20, right:Number=20):Scale9Bitmap
		{
		//	var data:BitmapData=Cast.Draw(mc);
			var data:BitmapData=mc as BitmapData;
			var scaleBmp:Scale9Bitmap=new Scale9Bitmap(data,top,bottom,left,right);
	//		data.dispose();
			return scaleBmp;
		}
		
		
		
		override public function dispose(e:Event=null):void
		{
			super.dispose(e);
			leftUp=null;
			leftCenter=null;
			leftBottom=null;
			centerUp=null;
			center=null;
			centerBottom=null;
			rightUp=null;
			rightCenter=null;
			rightBottom=null;
		}
		
	}
	
}

