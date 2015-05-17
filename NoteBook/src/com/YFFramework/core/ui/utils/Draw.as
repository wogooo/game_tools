package com.YFFramework.core.ui.utils
{
	import com.YFFramework.core.utils.math.GraphicAlgorithm;
	
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.geom.Point;

	/**
	 * author :夜枫 * 时间 ：2011-9-22 下午08:58:12
	 * 画图API 
	 */
	public final class Draw
	{
		public function Draw()
		{
		}
		
		public static function DrawRect(_graphics:Graphics,_w:Number,_h:Number,_color:uint=0x336699,alpha:Number=1,
											_x:Number=0,_y:Number=0,thickness:Number=NaN,lineColor:uint=0xFF0000,clearPrevious:Boolean=true):void
		{
			if(clearPrevious)_graphics.clear();
			if(thickness>0)_graphics.lineStyle(thickness,lineColor);///thickness指的是笔触的粗细 值为NaN则没有笔触
			_graphics.beginFill(_color,alpha);
			_graphics.drawRect(_x,_y,_w,_h);
			_graphics.endFill();
		}
		public static function drawLine(_graphics:Graphics,_x:Number,_y:Number,endX:Number,endY:Number,lineColor:uint=0xFF0000,_thickness:Number=1):void
		{
			_graphics.clear();
			_graphics.lineStyle(_thickness,lineColor);///thickness指的是笔触的粗细 值为NaN则没有笔触
			_graphics.moveTo(_x,_y);
			_graphics.lineTo(endX, endY);
		}
		public static function  DrawRectLine(_graphics:Graphics,_x:Number,_y:Number,_w:Number,_h:Number,lineColor:uint=0xFFFFFF,
											 _thickness:Number=1,clearPrevious:Boolean=true):void
		{
			var cmd:Vector.<int>=new Vector.<int>();
			cmd.push(1,2,2,2,2);
			var data:Vector.<Number>=new Vector.<Number>();
			var starX:Number=_x;
			var starY:Number=_y;
			var endX:Number=_x+_w;
			var endY:Number=_y+_h;
			data.push(starX,starY,starX,endY,endX,endY,endX,starY,starX,starY);
			if(clearPrevious)_graphics.clear();
			_graphics.lineStyle(_thickness,lineColor);///thickness指的是笔触的粗细 值为NaN则没有笔触
			_graphics.drawPath(cmd,data);
			_graphics.endFill();

		}
		public static function  DrawRoundRect(_graphics:Graphics,_w:Number,_h:Number,
											  _color:uint=0x336699,alpha:Number=1,_ellipseWidth:Number=20,
											  _ellipseHeight:Number=20,_x:Number=0,_y:Number=0,
											  thickness:Number=NaN,clearPrevious:Boolean=true):void
		{
			if(clearPrevious)_graphics.clear();
			if(thickness>0)_graphics.lineStyle(thickness);///thickness指的是笔触的粗细 值为NaN则没有笔触
			_graphics.beginFill(_color,alpha);
			_graphics.drawRoundRect(_x,_y,_w,_h,_ellipseWidth,_ellipseHeight);
			_graphics.endFill();
		}
		public static function DrawCircle(_graphics:Graphics,radius:Number,_x:Number=0,_y:Number=0,_color:uint=0x336969,alpha:Number=1,thickness:Number=NaN,clearPrevious:Boolean=true):void
		{
			if(clearPrevious)_graphics.clear();
			if(thickness>0)_graphics.lineStyle(thickness);///thickness指的是笔触的粗细 值为NaN则没有笔触
			_graphics.beginFill(_color,alpha);
			_graphics.drawCircle(_x,_y,radius);
			_graphics.endFill();
		}
		/**  画菱形 
		 * 	_w  _h 的值可为正也可以为负  主要是代表的方向
		 * thickness 值为 NaN 则表示没有笔触
		 */		
		public static  function DrawRhombus(_graphics:Graphics,_w:Number,_h:Number,_color:uint=0x6699FF,alpha:Number=1,_topX:Number=0,
												_topY:Number=0,thickness:Number=1,lineColor:uint=0,clearPrevious:Boolean=true):void
		{
			var cmd:Vector.<int>=new Vector.<int>();
			cmd.push(1,2,2,2,2);
			var data:Vector.<Number>=new Vector.<Number>();
			data.push(_topX,_topY);
			data.push(_topX-_w*0.5,_topY+_h*0.5);
			data.push(_topX,_topY+_h);
			data.push(_topX+_w*0.5,_topY+_h*0.5);
			data.push(_topX,_topY)
			if(clearPrevious)_graphics.clear();
			if(thickness>0)_graphics.lineStyle(thickness,lineColor);///thickness指的是笔触的粗细 值为NaN则没有笔触
			_graphics.beginFill(_color,alpha);
			_graphics.drawPath(cmd,data);
			_graphics.endFill();
		}
				
		/** 画平行四边形
		 * @param _beginPoint   平行四边形开始点
		 * @param _oppsitePoint   _beginPoint的对角点
		 * @param k1   平行四边形的两条边的斜率   
		 * @param k2	
		 */		
		public static function DrawParallel(_graphics:Graphics,k1:Number,k2:Number,_beginPoint:Point,_oppsitePoint:Point,_color:uint=0x6699FF,
												_alpha:Number=1,thickness:Number=1,lineColor:uint=0,clearPrevious:Boolean=true):void
		{
			var cmd:Vector.<int>=new Vector.<int>();
			cmd.push(1,2,2,2,2);
			var data:Vector.<Number>=new Vector.<Number>();
			var pointArr:Vector.<Point>=GraphicAlgorithm.parallelPoint(_beginPoint,_oppsitePoint,k1,k2);
			var len:int=pointArr.length;
			for(var i:int=0;i!=len;++i)
			{
				data.push(pointArr[i].x,pointArr[i].y);
			}
			data.push(pointArr[0].x,pointArr[0].y);
			if(clearPrevious)_graphics.clear();
			if(thickness>0)_graphics.lineStyle(thickness,lineColor);///thickness指的是笔触的粗细 值为NaN则没有笔触
			_graphics.beginFill(_color,_alpha);
			_graphics.drawPath(cmd,data);
			_graphics.endFill();
		}
		public static function DrawRectShape(_w:Number,_h:Number,_color:uint=0x336699,_alpha:Number=1,_x:Number=0,_y:Number=0,thickness:Number=NaN,lineColor:uint=0,clearPrevious:Boolean=true):Shape
		{
			var shape:Shape=new Shape();
			DrawRect(shape.graphics,_w,_h,_color,_alpha,_x,_y,thickness,lineColor,clearPrevious);
			return shape;
		}
		public static function DrawRoundRectShape(_w:Number,_h:Number,_color:uint=0x336699,_alpha:Number=1,_ellipseWidth:Number=20,_ellipseHeight:Number=20,
												  	_x:Number=0,_y:Number=0,thickness:Number=NaN,clearPrevious:Boolean=true):Shape
		{
			var shape:Shape=new Shape();
			DrawRoundRect(shape.graphics,_w,_h,_color,_alpha,_ellipseWidth,_ellipseHeight,_x,_y,thickness,clearPrevious);
			return shape;
		}
		
		public static function DrawCircleShape(radius:Number,_color:uint=0x336969,_alpha:Number=1,_x:Number=0,_y:Number=0,thickness:Number=1,clearPrevious:Boolean=true):Shape
		{
			var shape:Shape=new Shape();
			DrawCircle(shape.graphics,radius,_color,_alpha,_x,_y,thickness,clearPrevious);
			return shape;
		}
		/**创建棱形图形
		 */		
		public static function DrawRhombusShape(_w:Number,_h:Number,_color:uint=0x6699FF,_alpha:Number=1,_topX:Number=0,
												_topY:Number=0,thickness:Number=1,lineColor:uint=0,clearPrevious:Boolean=true):Shape
		{
			var shape:Shape=new Shape();
			DrawRhombus(shape.graphics,_w,_h,_color,_alpha,_topX,_topY,thickness,lineColor,clearPrevious);
			return shape;
		}
	}
}