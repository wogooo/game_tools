package com.YFFramework.core.ui.yf2d.data
{
	import com.YFFramework.core.yf2d.textures.face.ITextureBase;
	
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	

	/**@author yefeng
	 *20122012-11-17下午7:09:12
	 */
	public class BitmapFrameData implements ITextureBase
	{
		/**  x  y  坐标偏移量 
		 */ 
		public var x:Number=0; ///  
		public var y:Number=0;
		/**    表示停留的时间 内部已经乘上了帧频率 							//老的是 停 留的帧数  默认值 为1    表示停留一帧   
		 */
		public var  delay:Number=1;
		
		/** 包含的信息是  uv 信息 以及  宽高大小
		 */		
		
		protected var _uvData:Vector.<Number>;
		/// 只 关于 X坐标对称
		protected var _uvDataScaleX:Vector.<Number>;
		//关于Y坐标对称
		protected var _uvDataScaleY:Vector.<Number>;
		//关于xy 坐标对称
		protected var _uvDataScaleXY:Vector.<Number>;
		
		protected var _textureRect:Rectangle;
		
		/**矩阵，用于给ShapeClip使用 ，作为模型显示 采用 cpu渲染  常规渲染是否已经初始化  在对象初始化时  出于性能考虑 不进行常规数据的初始化
		 */		
		public var matrix:Matrix;
		public var shapeX:Number;
		public var shapeY:Number;
		/**
		 */		
		private var _shapeDataInit:Boolean
		public function BitmapFrameData()
		{
		}
		/**初始化常规渲染数据
		 */		
		public function initShapeData():void
		{
			if(!matrix)
			{
				matrix=new Matrix();
				matrix.translate(-_textureRect.x,-_textureRect.y);
				shapeX=x-_textureRect.width*0.5;
				shapeY=y-_textureRect.height*0.5;
			}
		}
		
		
		/**设置UV数据
		 */		
		public function setUVData(vect:Vector.<Number>):void
		{
			_uvData=vect;
			_uvDataScaleX=vect.concat(); ////  0 ,2  位置交换  //  x 坐标翻转
			_uvDataScaleX[0]=_uvDataScaleX[0]+_uvDataScaleX[2];
			_uvDataScaleX[2]=-_uvDataScaleX[2];
			
			//放到  第一次获取时 初始化  下面初始化的主要是倒影
//			_uvDataScaleY=_uvData.concat(); // 1 3位置交换
//			_uvDataScaleY[1]=_uvDataScaleY[1]+_uvDataScaleY[3];
//			_uvDataScaleY[3]=-_uvDataScaleY[3];
//			_uvDataScaleXY=Vector.<Number>([_uvDataScaleX[0],_uvDataScaleY[1],_uvDataScaleX[2],_uvDataScaleY[3]]);
		}
		
		/**@param scaleX 进行镜像翻转需要
		 * scaleX 只能为  1  或者-1      u v 信息
		 * scaleY 只能为  1  或者-1    Y轴翻转 用于镜像
		 */		 
		public function getUVData(scaleX:Number=1,scaleY:Number=1):Vector.<Number>
		{
			if(scaleX==1&&scaleY==1)return _uvData;
			else if(scaleX==-1&&scaleY==1)return _uvDataScaleX;  ////镜像
			else if(scaleX==1&&scaleY==-1)    //倒影
			{
				if(!_uvDataScaleY)
				{
					_uvDataScaleY=_uvData.concat(); // 1 3位置交换
					_uvDataScaleY[1]=_uvDataScaleY[1]+_uvDataScaleY[3];
					_uvDataScaleY[3]=-_uvDataScaleY[3];
//					_uvDataScaleXY=Vector.<Number>([_uvDataScaleX[0],_uvDataScaleY[1],_uvDataScaleX[2],_uvDataScaleY[3]]);
					_uvDataScaleXY=new Vector.<Number>();
					_uvDataScaleXY.push(_uvDataScaleX[0],_uvDataScaleY[1],_uvDataScaleX[2],_uvDataScaleY[3]);  //性能更高
				}
				return _uvDataScaleY;
			}
			else if(scaleX==-1&&scaleY==-1)			//倒影
			{
				if(!_uvDataScaleXY)
				{
					_uvDataScaleY=_uvData.concat(); // 1 3位置交换
					_uvDataScaleY[1]=_uvDataScaleY[1]+_uvDataScaleY[3];
					_uvDataScaleY[3]=-_uvDataScaleY[3];
//					_uvDataScaleXY=Vector.<Number>([_uvDataScaleX[0],_uvDataScaleY[1],_uvDataScaleX[2],_uvDataScaleY[3]]);
					_uvDataScaleXY=new Vector.<Number>();
					_uvDataScaleXY.push(_uvDataScaleX[0],_uvDataScaleY[1],_uvDataScaleX[2],_uvDataScaleY[3]);
				}
				return _uvDataScaleXY;
			}
			return null;
		}
		/**设置  贴图区域大小  用来进行宽高定位
		 * atlasX atlasY是在源图上的位置
		 */		
		public function setTextureRect(atlasX:Number,atlasY:Number,width:int,height:int):void
		{
			_textureRect=new Rectangle(atlasX,atlasY,width,height);
		}
		public function get rect():Rectangle
		{
			return _textureRect;
		}
		public function clone():ITextureBase
		{
			var texture:BitmapFrameData=new BitmapFrameData();
			texture._textureRect=this._textureRect.clone();
			texture._uvData=this._uvData.concat();
			texture._uvDataScaleX=_uvDataScaleX.concat();
			texture.x=x;
			texture.y=y;
			texture.delay=delay;
			return texture as ITextureBase;	
		}		
		public function dispose():void
		{
			
			_textureRect=null;
			_uvData=null;
			_uvDataScaleX=null;
			matrix=null;
		}
		
	
	}
}