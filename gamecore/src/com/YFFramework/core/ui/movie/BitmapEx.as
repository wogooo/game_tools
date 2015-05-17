package com.YFFramework.core.ui.movie
{
	/**  2012-7-10
	 *	@author yefeng
	 */
	import com.YFFramework.core.ui.movie.data.BitmapDataEx;
	import com.YFFramework.core.utils.image.BitmapDataUtil;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	/** 本类不要使用rotationX rotationY rotationZ属性
	 */
	public class BitmapEx extends Bitmap
	{
		
		/** 是否已经释放了内存 
		 */
		protected var _isDispose:Boolean;
		/**旋转点x   也就是注册点
		 */
		protected var _pivotX:Number;
		/**旋转点Y
		 */
		protected var _pivotY:Number;
		
		/**  x 偏移量
		 */
		protected var _offsetX:Number;
		/** y偏移量
		 */
		protected var _offsetY:Number;
		/** 本地矩阵  
		 */
		protected var _localMatrix:Matrix;
		
		/** 假设的父容器
		 */
		protected var _fakeParentMatrix:Matrix;
		
		/**转化后的最终矩阵
		 */
		protected var _rootMatrix:Matrix;
		
		protected var _scaleX:Number;
		protected var _scaleY:Number;
		/**旋转角度 角度单位
		 */
		protected var _rotation:Number;
		/**旋转角度 弧度单位
		 */
		protected var _radRotation:Number;
		public function BitmapEx()
		{
			_offsetX=0;
			_offsetY=0;
			_pivotX=0;
			_pivotY=0;
			_scaleX=1;
			_scaleY=1;
			_rotation=0;
			_radRotation=0;
			_localMatrix=new Matrix();
			_fakeParentMatrix=new Matrix();
			_rootMatrix=new Matrix();
			_isDispose=false;
			super(null,"auto",true);
		}
		/**设置数据
		 */		
		public function setBitmapDataEx(data:BitmapDataEx):void
		{
			_offsetX=data.x;
			_offsetY=data.y;
			bitmapData=data.bitmapData;
			updateMatrix()
		}
		
		/** 得到 进行scaleY旋转所需要的矩阵 
		 */
		protected function updateRootMatrix():void
		{
			updateLocalMatrix();
			updateFakeParentMatrix();
			_rootMatrix.identity();
			_rootMatrix.concat(_localMatrix);
			_rootMatrix.concat(_fakeParentMatrix);
		}
		/**改变状态  在设置 scaleX  scaleY  rotation   pivotX  pivotY时调用
		 */
		protected function updateMatrix():void
		{
			updateRootMatrix();
			transform.matrix=_rootMatrix;
		}
		/** 本地矩阵
		 */
		protected function updateLocalMatrix():Matrix
		{
			_localMatrix.identity();
			_localMatrix.translate(_offsetX,_offsetY)
			return  _localMatrix;
		}
		protected function updateFakeParentMatrix():void
		{
			_fakeParentMatrix.identity();
			_fakeParentMatrix.scale(_scaleX,_scaleY);
			_fakeParentMatrix.rotate(_radRotation);
			_fakeParentMatrix.translate(_pivotX,_pivotY);
		}
		

		public function get pivotX():Number
		{
			return _pivotX;
		}

		public function get pivotY():Number
		{
			return _pivotY;
		}

//		public function set pivotX(value:Number):void
//		{
//			_pivotX = value;
//			updateMatrix();
//		}
//
//		public function set pivotY(value:Number):void
//		{
//			_pivotY = value;
//			updateMatrix();
//		}
		
		/**设置pivot x y 坐标
		 */
		public function setPivotXY(pivotX:Number,pivotY:Number):void
		{
			_pivotX=pivotX;
			_pivotY=pivotY;
			updateMatrix();
		}
		
		override public function set x(value:Number):void
		{
			throw new Error("请使用pivotX pivotY属性");
		}
		
		override public function set y(value:Number):void
		{
			throw new Error("请使用pivotX pivotY属性");
		}

		
		override public function get rotation():Number
		{
			return _rotation;
		}
		
		override public function set rotation(value:Number):void
		{
			_rotation=value;
			_radRotation=degreeToRadian(_rotation);
			updateMatrix();
		}
		
		override public function get scaleX():Number
		{
			return _scaleX;
		}
		
		override public function set scaleX(value:Number):void
		{
			_scaleX=value;
			updateMatrix();
		}
		
		override public function get scaleY():Number
		{
			return _scaleY;
		}
		
		override public function set scaleY(value:Number):void
		{
			_scaleY=value;
			updateMatrix();
		}
		
		override public function set rotationX(value:Number):void
		{
			throw new Error("该方法被禁用");
		}
		
		override public function set rotationY(value:Number):void
		{
			throw new Error("该方法被禁用");
		}
		
		override public function set rotationZ(value:Number):void
		{
			throw new Error("该方法被禁用");
		}
		
		
		private  function degreeToRadian(degree:Number):Number
		{
			return Math.PI * degree / 180;
		}

		/** 不进行bitmapData内存释放
		 */
		public function dispose():void
		{
			bitmapData=null;
		    _localMatrix=null;
			_fakeParentMatrix=null;
			_isDispose=true;
		}
	
		public function get isDispose():Boolean
		{
			return _isDispose;
		}
		
		/** parentPt是  parentContainer坐标系下的坐标，parentContainer为空时表示根容器舞台   判断该点是否在 BitmapEx对象身上
		 */
		public function getIntersect(parentPt:Point,parentContainer:DisplayObjectContainer=null):Boolean
		{
			if(parentContainer==null) parentContainer=stage;
			///将parentX  parentY转化为本地坐标
			var mat:Matrix=new Matrix();
			var obj:DisplayObject=this;
			while(obj!=parentContainer)
			{
				mat.concat(obj.transform.matrix);
				obj=obj.parent;
			}
			mat.invert();
			var newPt:Point=mat.transformPoint(parentPt);
			return BitmapDataUtil.getInsect(this,newPt.x,newPt.y);
		}
		

		
	}
}