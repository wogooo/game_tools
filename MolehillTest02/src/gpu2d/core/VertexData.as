package gpu2d.core
{
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.display3D.IndexBuffer3D;
	import flash.display3D.Program3D;
	import flash.display3D.VertexBuffer3D;
	import flash.geom.Matrix3D;
	
	import gpu2d.errors.SingletonError;

	/**
	 * author :夜枫
	 * 时间 ：2011-11-22 下午10:07:50
	 */
	public final class VertexData
	{
		public var indexBuffer:IndexBuffer3D;
		public static var _instance:VertexData;
		private var vertexBuffer:VertexBuffer3D;
		private var context3d:Context3D;
		private var _programRBG:Boolean;
		public function VertexData()
		{
			if(_instance) throw new SingletonError();
		}
		public static function get Instance():VertexData
		{
			if(!_instance) _instance=new VertexData();
			return _instance;				
		}
		public function initContext(context3d:Context3D):void
		{
			this.context3d=context3d;
			initData();
		}
		protected  function initData():void
		{
			vertexBuffer=context3d.createVertexBuffer(4,4);
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
			var program:Program3D =_programRBG? GProgramManager.Instance.getProgram(GProgramName.RGB_PROGRAM):GProgramManager.Instance.getProgram(GProgramName.RGBA_PROGRAM);
			context3d.setProgram(program);
		}
		
	}
}