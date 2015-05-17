package yf2d.geom
{
	import flash.geom.ColorTransform;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import yf2d.display.DisplayObject2d;

	/**
	 * author :夜枫
	 * 时间 ：2011-11-27 下午05:24:24
	 */
	public final class Transformation
	{
		public var colorTransform:ColorTransform;
		public var colorData:ColorData;
		private var _matrix3d:Matrix3D;
		public function Transformation(object:DisplayObject2d)
		{
			colorData=new ColorData();
			_matrix3d.appendScale(object.width * (object.scaleX / 2), object.height * (object.scaleY / 2), 1);
			_matrix3d.appendTranslation(object.width*0.5-object.pivotX, object.height*0.5-object.pivotY, 0);
		//	_matrix3d.appendRotation(_rotationX, Vector3D.X_AXIS);
		//	_matrix3d.appendRotation(_rotationY, Vector3D.Y_AXIS);
			_matrix3d.appendRotation(object.rotation, Vector3D.Z_AXIS);
			_matrix3d.appendTranslation(object.x,object.y,0);

		}
		
		public function get matrix3d():Matrix3D	{	return _matrix3d;	}
	}
}