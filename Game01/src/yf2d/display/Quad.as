package yf2d.display
{
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getQualifiedClassName;
	
	import yf2d.errors.AbstractClassError;
	import yf2d.textures.face.ITextureBase;


	/**
	 * author :夜枫
	 */
	public class Quad extends DisplayObject2D
	{
		
		protected var _texture:ITextureBase;
		/**
		 * @param width 显示的宽
		 * @param height  显示的高
		 */		
		public function Quad(width:Number,height:Number)
		{
		//	FaceNum +=2;
			super();
			_width=width;
			_height=height;
			////将轴点pivot设置在对象左上角
			if(getQualifiedClassName(this)=="yf2d.display::Quad") throw new AbstractClassError("该类不能被实例化");           
		}              
		
		/**  默认注册点在中心   
		 */		
		override public function getBounds(targetCoordinateSpace:DisplayObject2D):Rectangle
		{
			var minX:Number = Number.MAX_VALUE, maxX:Number = -Number.MAX_VALUE;
			var minY:Number = Number.MAX_VALUE, maxY:Number = -Number.MAX_VALUE;
			
			var pointArr:Vector.<Point>=new Vector.<Point>();
			//逆时针保存
/*			pointArr.push(new Point(0,0));
			pointArr.push(new Point(0,_height));
			pointArr.push(new Point(_width,_height));
			pointArr.push(new Point(_width,0));
*/		
			//// 默认 原点在几何中心
			pointArr.push(new Point(-_width*0.5-_pivotX,-_height*0.5-_pivotY));
			pointArr.push(new Point(pointArr[0].x,pointArr[0].y+_height));
			pointArr.push(new Point(pointArr[0].x+_width,pointArr[1].y));
			pointArr.push(new Point(pointArr[2].x,pointArr[0].y));

			
			
			
			var matrix:Matrix=getTransformationMatrixToSpace(targetCoordinateSpace);
			
			//转化为yf2d下的 几何中心
		//	matrix.translate(-_width*.5,-_height*.5);
			
			var transformedPoint:Point;
			for(var i:int=0;i!=4;++i)
			{
				transformedPoint=matrix.transformPoint(pointArr[i]);
				minX = Math.min(minX, transformedPoint.x);
				maxX = Math.max(maxX, transformedPoint.x);
				minY = Math.min(minY, transformedPoint.y);
				maxY = Math.max(maxY, transformedPoint.y);                    
			}
			return new Rectangle(minX, minY, maxX-minX, maxY-minY);
		}

		
		override public function dispose(childrenDispose:Boolean=true):void
		{
			super.dispose(childrenDispose);
			_texture=null;
		}
		
		public function get texture():ITextureBase	{	return _texture;			}
		
		public function set texture(value:ITextureBase):void	{	_texture=value;				}
	}
}