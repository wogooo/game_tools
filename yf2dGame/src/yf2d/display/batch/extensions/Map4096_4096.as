package yf2d.display.batch.extensions
{
	import flash.display.BitmapData;
	import flash.display3D.textures.Texture;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import yf2d.display.DisplayObject2D;
	import yf2d.display.SpriteScroll;
	import yf2d.textures.batch.TextureScroll;
	
	/** 4096-4096大小的地图  采用  x= [0,2048] y=[0,2048]  x=[2048,4096]y=[0,2048]           x= [0,2048] y=[2048,4096]  x=[2048,4096]y=[2048,4096]      
	 * 四个区块  也就是 4个 texure         索引是横排下去 0,1,2,3 
	 * author :夜枫
	 */
	public final class Map4096_4096 extends Map 
	{
		/**当当前SpriteScroll距离下一张SpriteScroll还有 48像素的距离时就将其显示出来 避免 临时显示出来的的停顿
		 */		
		protected static const  ScrollBuffer:int=48;  
		
		/// x= [0,2048] y=[0,2048] 
		protected var spriteScroll0:SpriteScroll;
		protected var rect0:Rectangle;
		// x=[2048,4096]y=[0,2048]  
		protected var spriteScroll1:SpriteScroll;
		protected var rect1:Rectangle;
		// x= [0,2048] y=[2048,4096]
		protected var spriteScroll2:SpriteScroll;
		protected var rect2:Rectangle;
		//x=[2048,4096]y=[2048,4096] 
		protected var spriteScroll3:SpriteScroll;
		protected var rect3:Rectangle;
		public function Map4096_4096(sourceBitmapData:BitmapData,viewWidth:Number,viewHeight:Number)
		{
			super(sourceBitmapData,viewWidth,viewHeight);
			scrollTo(0,0);
		}
		
		///区块范围
		override protected function initRectangle():void
		{
			rect0=new Rectangle(0,0,Texture_2048,Texture_2048);
			rect1=new Rectangle(Texture_2048,0,Texture_2048,Texture_2048);
			rect2=new Rectangle(0,Texture_2048,Texture_2048,Texture_2048);
			rect3=new Rectangle(Texture_2048,Texture_2048,Texture_2048,Texture_2048);
		}

		override protected function initTexture():void
		{
			var pt:Point=new Point();
			var len:int=4;
			
			///初始化SpriteScroll
			for(var i:int=0;i!=len;++i)
			{
				///初始化SpriteScroll
				this["spriteScroll"+i]=new SpriteScroll(viewRect.width,viewRect.height);
				this["spriteScroll"+i].initTexture(sourceBitmapData,this["rect"+i],pt);
			}
		}
		
		/** px py 是地图坐标  
		 */		
		override public function scrollTo(px:Number,py:Number):void
		{
			///相同 则直接返回
		//	if(px==viewRect.x&&py==viewRect.y) return ;
			viewRect.x=px;
			viewRect.y=py;
			

			///9种情况  滑动算法
			/////前四种情况  当 viewRect在其中某一个SpriteScroll内时  单一 SpriteScroll内部时
			var singleLen:int=4;
			for(var i:int=0;i!=singleLen;++i)
			{
				///左上角和右下角都在SpriteScroll内部
			//	if(this["rect"+i].containsPoint(viewRect.topLeft)&&this["rect"+i].containsPoint(viewRect.bottomRight))
				if(this["rect"+i].containsRect(viewRect))
				{
					addOnlyChild(Vector.<DisplayObject2D>([this["spriteScroll"+i]]));
					this["spriteScroll"+i].x=0;
					this["spriteScroll"+i].y=0;
					this["spriteScroll"+i].scrollTo(px-this["rect"+i].x,py-this["rect"+i].y);
					return ;
				}
			}
			
			///索引   0 1	交叉 
			if(rect0.containsPoint(viewRect.topLeft)&&rect1.containsPoint(viewRect.bottomRight))
			{
				addOnlyChild(Vector.<DisplayObject2D>([spriteScroll0,spriteScroll1]));
				
				///设置 UV滑动
				spriteScroll0.scrollTo(Texture_2048-viewRect.width,py);///UV滑至最右边 
				spriteScroll1.scrollTo(0,py);///UV滑至最左边
				///设置坐标滑动   spriteScroll0    px-2048         spriteScroll1    2048-px
				spriteScroll0.x=Texture_2048-px-viewRect.width;
				spriteScroll0.y=0;
				spriteScroll1.x=Texture_2048-px;
				spriteScroll1.y=0;
				return;
			}
			
			///索引  0 2	交叉
			else if(rect0.containsPoint(viewRect.topLeft)&&rect2.containsPoint(viewRect.bottomRight))
			{
	
				addOnlyChild(Vector.<DisplayObject2D>([spriteScroll0,spriteScroll2]));
				///设置UV滑动
				spriteScroll0.scrollTo(px,Texture_2048-viewRect.height);///UV滑至最下边 
				spriteScroll2.scrollTo(px,0);///滑至最上边
				///设置坐标
				spriteScroll0.x=0;
				spriteScroll0.y=Texture_2048-py-viewRect.height;
				spriteScroll2.x=0;
				spriteScroll2.y=Texture_2048-py;
				return ;
			}
			
			///索引  3	 2 	交叉  
			else if(rect2.containsPoint(viewRect.topLeft)&&rect3.containsPoint(viewRect.bottomRight))
			{
				addOnlyChild(Vector.<DisplayObject2D>([spriteScroll2,spriteScroll3]));
				///设置 UV滑动
				spriteScroll2.scrollTo(Texture_2048-viewRect.width,py-Texture_2048);///UV滑至最右边 
				spriteScroll3.scrollTo(0,py-Texture_2048);///UV滑至最左边
				///设置坐标滑动   
				spriteScroll2.x=Texture_2048-px-viewRect.width;
				spriteScroll2.y=0;
				spriteScroll3.x=Texture_2048-px;
				spriteScroll3.y=0;
				return;
			}
			
			//索引 3		1	交叉
			else if(rect1.containsPoint(viewRect.topLeft)&&rect3.containsPoint(viewRect.bottomRight))
			{
				addOnlyChild(Vector.<DisplayObject2D>([spriteScroll1,spriteScroll3]));
				///设置UV滑动
				spriteScroll1.scrollTo(px-Texture_2048,Texture_2048-viewRect.height);///UV滑至最下边 
				spriteScroll3.scrollTo(px-Texture_2048,0);///滑至最上边
				///设置坐标
				spriteScroll1.x=0;
				spriteScroll1.y=Texture_2048-py-viewRect.height;
				spriteScroll3.x=0;
				spriteScroll3.y=Texture_2048-py;
				return ;
			}
			////索引   0 1 2 3 交叉  也就是 viewRect在中间时
			else if(rect0.containsPoint(viewRect.topLeft)&&rect3.containsPoint(viewRect.bottomRight))
			{
				if(!this.contains(spriteScroll0)) this.addChild(spriteScroll0);
				if(!this.contains(spriteScroll1)) this.addChild(spriteScroll1);
				if(!this.contains(spriteScroll2)) this.addChild(spriteScroll2);
				if(!this.contains(spriteScroll3)) this.addChild(spriteScroll3);
				///设置UV滑动
				spriteScroll0.scrollTo(Texture_2048-viewRect.width,Texture_2048-viewRect.height);///UV滑至最右下边 
				spriteScroll1.scrollTo(0,Texture_2048-viewRect.height);///UV滑至最左下边 
				spriteScroll2.scrollTo(Texture_2048-viewRect.width,0);///UV滑至最右上边 
				spriteScroll3.scrollTo(0,0);///UV 左上
				///设置坐标
				spriteScroll0.x=Texture_2048-px-viewRect.width;
				spriteScroll0.y=Texture_2048-py-viewRect.height;
				spriteScroll1.x=Texture_2048-px;
				spriteScroll1.y=spriteScroll0.y;
				spriteScroll2.x=spriteScroll0.x;
				spriteScroll2.y=Texture_2048-py;
				spriteScroll3.x=spriteScroll1.x;
				spriteScroll3.y=spriteScroll2.y;
				return;
			}
		}
		
		/**sourceBitmapData是总贴图
		 * 更新某一区块贴图  rectIndex的值为 0 1 2 3 表示要更新的区域
		 */		
		public function  updateTexture(sourceBitmapData:BitmapData,rectIndex:int):void
		{
			this["spriteScroll"+rectIndex].initTexture(sourceBitmapData,this["rect"+rectIndex],new Point())
		}
		
		
	}
}