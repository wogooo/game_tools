package gpu2d.display
{
	import com.adobe.utils.AGALMiniAssembler;
	
	import flash.display.BitmapData;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.display3D.IndexBuffer3D;
	import flash.display3D.Program3D;
	import flash.display3D.VertexBuffer3D;
	import flash.geom.Matrix;
	import flash.geom.Matrix3D;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getQualifiedClassName;
	
	import gpu2d.core.GEventCenter;
	import gpu2d.core.GProgramManager;
	import gpu2d.core.GProgramName;
	import gpu2d.core.GRenderSupport;
	import gpu2d.core.Gpu2d;
	import gpu2d.core.VertexData;
	import gpu2d.errors.AbstractClassError;

	/**
	 * author :夜枫
	 * 时间 ：2011-11-13 下午02:55:09
	 */
	public class GQuad extends GDisplayObject
	{
	//	public static var FaceNum:int=0;
		private var mWidth:Number;
		private var mHeight:Number;
		
		protected var context3d:Context3D;
	//	protected var indexBuffer:IndexBuffer3D;
	//	protected var vertexBuffer:VertexBuffer3D;
		protected var _programRBG:Boolean=true;
		protected var program:Program3D;
		/**
		 * @param width 显示的宽
		 * @param height  显示的高
		 */		
		public function GQuad(width:Number,height:Number)
		{
			super();
		//	FaceNum +=2;
			mWidth=width;
			mHeight=height;
			if(getQualifiedClassName(this)=="gpu2d.display::GQuad") throw new AbstractClassError("该类不能被实例化");
			context3d=Gpu2d.Instance.context3d;
			initVertexData();
		}
		protected function initVertexData():void
		{
/*			vertexBuffer=context3d.createVertexBuffer(4,4);
			//为顶点创建一个索引缓冲来为三角形排序，我们有一个四角形，因此这里有4个顶点，因此有6个索引
			indexBuffer=context3d.createIndexBuffer(6);
			
			var vertexData:Vector.<Number>=Vector.<Number>(
				[
					-1.0, 1.0, 0.0, 0.0,       ///x   y   u   v    
					-1.0,-1.0, 0.0, 1.0,
					1.0,-1.0, 1.0, 1.0,
					1.0, 1.0, 1.0, 0.0
				]
			);
			//这个是我们渲染顶点的顺序，0是第一个顶点，1是第二个，2是第三个。
			var indexData:Vector.<uint>=Vector.<uint>([0, 1, 2,0,2,3]);
			
			//将我们的顶点数据传递给顶点缓冲
			vertexBuffer.uploadFromVector(vertexData,0,4);
			indexBuffer.uploadFromVector(indexData,0,6);
			
			///// render的部分
			context3d.setVertexBufferAt(0, vertexBuffer,0, Context3DVertexBufferFormat.FLOAT_2); 
			context3d.setVertexBufferAt(1, vertexBuffer,2, Context3DVertexBufferFormat.FLOAT_2);
			context3d.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX,0, new Matrix3D());///这句必不可少  
*/		//	program =_programRBG? GProgramManager.Instance.getProgram(GProgramName.RGB_PROGRAM):GProgramManager.Instance.getProgram(GProgramName.RGBA_PROGRAM);

		}
		
		/**设置材质
		 */
		public function setTexture(bmpData:BitmapData):void
		{
			////子类进行重写
		}
		
		override public function getBounds(targetCoordinateSpace:GDisplayObject):Rectangle
		{
			var _width:Number=mWidth
			var _height:Number=mHeight
			var minX:Number = Number.MAX_VALUE, maxX:Number = -Number.MAX_VALUE;
			var minY:Number = Number.MAX_VALUE, maxY:Number = -Number.MAX_VALUE;
			
			var pointArr:Vector.<Point>=new Vector.<Point>();
			//逆时针保存
			pointArr.push(new Point(0,0));
			pointArr.push(new Point(0,_height));
			pointArr.push(new Point(_width,_height));
			pointArr.push(new Point(_width,0));
			
			var matrix:Matrix=getTransformationMatrixToSpace(targetCoordinateSpace);
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
		/**  注册 该显示对象对应的Program 
		 */		
		public static  function regProgramRGB():void
		{
			//m44 op, va0, vc0 表示应用一个4x4矩阵到我们的顶点并输出到屏幕
			//mov v0, va1 表示取出我们顶点的颜色值，并传给片段着色器
			var agalVertexSource:String= 
				"m44 op, va0, vc0\n" +
				"mov v0, va1\n";

			//将我们的颜色输出到屏幕
			var agalFragmentSource:String=          
				"tex ft0, v0, fs0 <2d,clamp,linear>\n" +
				"mul oc, ft0, fc0\n"  ///这里的是tex 是  0 ft0   所以 context3d.setTextureAt(0,texture)  第一个参数为 1    对应的 Context3DProgramType.FRAGMENT  方法中第一个参数为 0

			var vertexProgramAssembler:AGALMiniAssembler = new AGALMiniAssembler();
			vertexProgramAssembler.assemble(Context3DProgramType.VERTEX, agalVertexSource);
			
			var fragmentProgramAssembler:AGALMiniAssembler = new AGALMiniAssembler();
			fragmentProgramAssembler.assemble(Context3DProgramType.FRAGMENT, agalFragmentSource);
			GProgramManager.Instance.regProgram(GProgramName.RGB_PROGRAM,vertexProgramAssembler.agalcode,fragmentProgramAssembler.agalcode);
		}

		public function get programRGB():Boolean {	return _programRBG;	}
		public function set programRGB(value:Boolean):void {	 _programRBG=value;		}
		
		override public function render():void
		{
			if(!visible) return ;
			var curentObj:GDisplayObject=this;
			var alpha:Number=1;
			while(curentObj)
			{
				alpha *=curentObj.alpha;
				curentObj=curentObj.parent;
			}
			var alphaVector:Vector.<Number> = _programRBG ? new <Number>[alpha, alpha, alpha, alpha] :new <Number>[1.0, 1.0, 1.0, alpha];
		//	context3d.setProgram(program);
			/*	
			context3d.setTextureAt(0,texture);
			*/			
			/// 0代表坐标   1 代表 uv 
			/*			context3d.setVertexBufferAt(0, vertexBuffer,0, Context3DVertexBufferFormat.FLOAT_2); 
			context3d.setVertexBufferAt(1, vertexBuffer,2, Context3DVertexBufferFormat.FLOAT_2);
			*/			
			context3d.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, alphaVector, 1);
		//	context3d.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 0, GRenderSupport.Instance.getConvertMatrix(this));      
			context3d.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, GRenderSupport.Instance.getConvertMatrix(this),true); 
			
			context3d.drawTriangles(VertexData.Instance.indexBuffer, 0, 2);
		//	context3d.setProgram(null);
			
			/*			context3d.setTextureAt(0, null);
			context3d.setVertexBufferAt(0, null);
			context3d.setVertexBufferAt(1, null);
			context3d.setProgram(null);
			*/		
		}
	}
}