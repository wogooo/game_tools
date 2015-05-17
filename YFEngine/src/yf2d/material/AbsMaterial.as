package yf2d.material
{
	import com.YFFramework.core.center.manager.ResizeManager;
	import com.YFFramework.core.proxy.StageProxy;
	
	import flash.display3D.Context3D;
	import flash.display3D.IndexBuffer3D;
	import flash.display3D.Program3D;
	import flash.display3D.VertexBuffer3D;
	
	import yf2d.core.CameraProjection;
	import yf2d.core.ScenceProxy;

	/**@author yefeng
	 *20122012-11-16下午11:57:06
	 */
	public class AbsMaterial
	{
		protected static const VertextData:uint=7;//  x y  u  v Matix_ID    rbgColor_ID     uv_Id 一个点7个数据
		protected static const SpriteVertextNum:uint=4; // 一个Sprite4个点

		public var cameraProjection:CameraProjection;

		public var indexBuffer:IndexBuffer3D;
		public var vertextBuff:VertexBuffer3D;
		protected var program:Program3D;
		protected var context3d:Context3D;

		protected var indexArr:Vector.<uint>;
		protected var vertextArr:Vector.<Number>;

		
		private var _projectionInvalide:Boolean;
		public function AbsMaterial(context3d:Context3D)
		{
			this.context3d=context3d;
			_projectionInvalide=false;
			createVertexData();
			initData();
			initCameraProjection();
		}
		
		private function initCameraProjection():void
		{
			ResizeManager.Instance.regFunc(resize);
			///创建投影视角
			cameraProjection=new CameraProjection();
			resize();
		}
		
		private function resize():void
		{
			_projectionInvalide=true
			cameraProjection.init(ScenceProxy.Instance.scenceRect.width,ScenceProxy.Instance.scenceRect.height);
		}
		
		protected function initData():void
		{
			
		}
		protected function createVertexData():void
		{
			
		}
		
		/**当舞台窗口缩放时 摄像头矩阵变为invalide
		 */		
		public function updateCameraProjectInvalide():Boolean
		{
			if(_projectionInvalide==true)
			{
				_projectionInvalide=false;
				return true;
			}
			return false;	
		}
		
	}
}