//图片的爆破



/*

date :2010/3/23
made by : dreamnight 
email :hujun36978@gmail.com


interface :


var spliteImage:  SpliteImage= new SpliteImage 

spliteImage.splite(image,200,200);
	imageArr=spliteImagesmallImages
	spliteImage.release();


*/


package com.YFFramework.core.utils.image.advanced  {
	
	import adobe.utils.CustomActions;
	
	import com.YFFramework.core.utils.math.MathConvertion;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	
	
	public class SpliteImage   {

		public var smallImages:Array;//保存图片实例
		public var storePosition:Array;//保存图片的位置
		public var cellWidth:Number;//爆破粒子宽度
		public var cellHeight:Number;//爆破粒子高度
		public var bmp:DisplayObject;//需要爆破的位图 或者MC
		public var container:Sprite=new Sprite();//照片的容器    可以对它进行侦听事件
		//默认的位图宽高比必须满足   4:3
		public var column:int;
		public var row :int;
		public function  SpliteImage(){
			
			smallImages = [];
			storePosition = [];
			
			
			
			}
		public  function splite(_bmp:DisplayObject,  _cellWidth:Number = 20.0, _cellHeight:Number = 15.0,force:Boolean=false):void {
			
			/**
			 * 多次调用摧毁数据
			 */
			destroyData();
			
			cellWidth=_cellWidth;
			cellHeight=_cellHeight;
			bmp=_bmp;

		//	container=_container;
			

			//爆破的个数 ：  row*column
			 column=MathConvertion.uppper(bmp.width/cellWidth);//横向的个数
			 row=MathConvertion.uppper(bmp.height/cellHeight);//列个数
			//trace(row);
			//trace(column);

			var bitmap:Bitmap;
			var oj:Object;
			var matrix:Matrix;
			var cellBitmapData:BitmapData;
			var mc:Sprite;
			/**
			 * 当切割数步是整数时 使用
			 */
			var cellW:Number = cellWidth;
			var cellH:Number = cellHeight;

			for (var i:int = 0; i!=row; ++i) {

				for (var j:int = 0; j != column; ++j) {

					
					var tx:Number = - cellWidth * j;
					
					var ty:Number = - cellHeight * i;
					
					 cellW = cellWidth;
					 cellH = cellHeight;
				//
					if(!force)
					{
						if(j==column-1)	cellW = bmp.width - cellWidth * j;
						
						if(i==row-1) cellH = bmp.height - cellHeight * i;
					}
					
					cellBitmapData = new BitmapData(cellW,cellH);
					
					matrix = new Matrix();
					matrix.translate(tx ,ty );
					cellBitmapData.draw(bmp,matrix);
					//var rect:Rectangle = new Rectangle(i, j, cellWidth, cellHeight);

					//cellcopyPixels


					//var bitmap:Bitmap=new Bitmap(cellBitmapData);
					bitmap=new Bitmap(cellBitmapData);


					//对该照片进行复原
					
					mc= new Sprite();
					mc.addChild(bitmap);
					mc.x=- tx;
					mc.y=- ty;
					
					smallImages[j+i*column]=mc;//为了内部的交互功能  必须保存为Sprite 或者MovieClip 而不是 位图Bitmap
					//保存初始位置：
					oj= new Object();
					oj.x=- tx;
					oj.y=- ty;
					oj.row=i;//所在行
					oj.column=j;//所在列
					oj.index=i*row+j;//数组中的索引
					storePosition.push(oj);
					//将其添加到容器中
					container.addChild(mc);
					//trace("tx为："+tx);
					//trace("ty为:"+ty);
					//trace("源的X为"+bmp.x+"\nY为"+bmp.y);
					matrix=null;
					//cellBitmapData=null;
					//oj=null;
					//bitmap=null
					;
				}
			}

		}
		
		
		
		
		
		
		
		
		
		public function release():void {
			
			destroyData();
			smallImages = null;
			storePosition = null;
			column = 0;
			row = 0;
			}

			
			
			/**
			 * 摧毁上一次的数据
			 */
			private function destroyData():void {
				smallImages =[]
				storePosition = [];
				bmp = null;
				container = new Sprite();
				
				}


	}

}