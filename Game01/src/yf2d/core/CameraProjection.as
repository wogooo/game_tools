package yf2d.core
{
	import flash.geom.Matrix3D;

	/**
	 * author :夜枫
	 * 时间 ：2011-11-30 上午11:24:53
	
	
				 点点			   x  y  u   v
					-1.0, 1.0, 0.0, 1.0,
					-1.0,-1.0, 0.0, 0.0,
					1.0,-1.0, 1.0, 0.0,
					1.0, 1.0, 1.0, 1.0
	
	  
	  var camera:CameraProjection=new CameraProjection();
		camera.init(W,H)
			var cameralMatrix:Matrix3D=camera.projection;
			
			model.identity();
			 
			 ///// 2d 对象矩阵
			var _pivot:Point=new Point(0,0)
			var _scaleX:Number=1,_scaleY:Number=1,_rotationZ:Number=30,_rotationY:Number=0,_rotationX:Number=0,_x:Number=stage.stageWidth*0.5,_y:Number=stage.stageHeight*0.5,_z:Number=0;
			//model.appendScale(_scaleX, _scaleY, 1.0);
			model.appendScale(width * (_scaleX / 2), height * (_scaleY / 2), 1);
			model.appendTranslation(width*0.5-_pivot.x, height*0.5-_pivot.y, 0);

			model.appendRotation(_rotationZ, Vector3D.Z_AXIS);
			model.appendRotation(_rotationY, Vector3D.Y_AXIS);
			model.appendRotation(_rotationX, Vector3D.X_AXIS);
			model.appendTranslation(_x, _y, _z);
			
			 ///最终矩阵
				
			
			var lastMatrix:Matrix3D=new Matrix3D()

			
		//	model.appendScale(128,128,1);
		//lastMatrix.appendScale(128/W,128/H,1);
				lastMatrix.append(model);
		lastMatrix.append(cameralMatrix);
	  
	  
	   

	 */	
	public class CameraProjection
	{
		
		private var orthoCameraMatrix:Matrix3D;
		public function CameraProjection()
		{
			orthoCameraMatrix=new Matrix3D();
		}
		
		public function init(stageWidth:int, stageHeight:int, p_near:Number=0.1, p_far:int=2000):void
		{
			orthoCameraMatrix.identity();
			var m3dOrtho:Matrix3D = new Matrix3D(Vector.<Number> ([	2/stageWidth, 0  		   ,       			  0,        			  0,
				0  		  , 2/stageHeight,       			  0,       				  0,
				0  		  , 0  		   , 1/(p_far - p_near), -p_near/(p_far-p_near),
				0		  , 0		   ,       			  0,        			  1	]));
			
			orthoCameraMatrix.appendTranslation(-stageWidth/2, -stageHeight/2, 0);
			orthoCameraMatrix.appendScale(1, -1, 1);
			orthoCameraMatrix.append(m3dOrtho);
		}

		public function get projection():Matrix3D{	return 	orthoCameraMatrix;		}
		
		
		
	}
}