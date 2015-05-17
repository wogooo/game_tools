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
		protected var _mPivotX:Number;
		/**旋转点Y
		 */
		protected var _mPivotY:Number;
		
		/**  x 偏移量
		 */
		protected var _mOffsetX:Number;
		/** y偏移量
		 */
		protected var _mOffsetY:Number;
		/** 本地矩阵  
		 */
		protected var _mLocalMatrix:Matrix;
		
		/** 假设的父容器
		 */
		protected var _mFakeParentMatrix:Matrix;
		
		/**转化后的最终矩阵
		 */
		protected var _mRootMatrix:Matrix;
		
		protected var _mScaleX:Number;
		protected var _mScaleY:Number;
		/**旋转角度 角度单位
		 */
		protected var _mRotation:Number;
		/**旋转角度 弧度单位
		 */
		protected var _mRadRotation:Number;
		/** 数据对象
		 */		
		private var _bitmapDataEx:BitmapDataEx;
		public function BitmapEx()
		{
			_mOffsetX=0;
			_mOffsetY=0;
			_mPivotX=0;
			_mPivotY=0;
			_mScaleX=1;
			_mScaleY=1;
			_mRotation=0;
			_mRadRotation=0;
			_mLocalMatrix=new Matrix();
			_mFakeParentMatrix=new Matrix();
			_mRootMatrix=new Matrix();
			_isDispose=false;
			super(null,"auto",true);
		}
		/**设置数据
		 */		
		public function setBitmapDataEx(data:BitmapDataEx):void
		{
			_mOffsetX=data.x;
			_mOffsetY=data.y;
			bitmapData=data.bitmapData;
			_bitmapDataEx=data;
			updateMatrix()
		}
		/**  获取数据 bitmapDataEx
		 */		
		public function getBitmapDataEx():BitmapDataEx
		{
			return _bitmapDataEx;	
		}
		
		/** 得到 进行scaleY旋转所需要的矩阵 
		 */
		protected function updateRootMatrix():void
		{
			updateLocalMatrix();
			updateFakeParentMatrix();
			_mRootMatrix.identity();
			_mRootMatrix.concat(_mLocalMatrix);
			_mRootMatrix.concat(_mFakeParentMatrix);
		}
		/**改变状态  在设置 scaleX  scaleY  rotation   pivotX  pivotY时调用
		 */
		protected function updateMatrix():void
		{
			updateRootMatrix();
			transform.matrix=_mRootMatrix;
		}
		/** 本地矩阵
		 */
		protected function updateLocalMatrix():Matrix
		{
			_mLocalMatrix.identity();
			_mLocalMatrix.translate(_mOffsetX,_mOffsetY)
			return  _mLocalMatrix;
		}
		protected function updateFakeParentMatrix():void
		{
			_mFakeParentMatrix.identity();
			_mFakeParentMatrix.scale(_mScaleX,_mScaleY);
			_mFakeParentMatrix.rotate(_mRadRotation);
			_mFakeParentMatrix.translate(_mPivotX,_mPivotY);
		}
		

		public function get pivotX():Number
		{
			return _mPivotX;
		}

		public function get pivotY():Number
		{
			return _mPivotY;
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
		
		/**设置pivot x y 坐标  也就是注册点位置
		 */
		public function setPivotXY(pivotX:Number,pivotY:Number):void
		{
			_mPivotX=pivotX;
			_mPivotY=pivotY;
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
			return _mRotation;
		}
		
		override public function set rotation(value:Number):void
		{
			_mRotation=value;
			_mRadRotation=degreeToRadian(_mRotation);
			updateMatrix();
		}
		
		override public function get scaleX():Number
		{
			return _mScaleX;
		}
		
		override public function set scaleX(value:Number):void
		{
			_mScaleX=value;
			updateMatrix();
		}
		
		override public function get scaleY():Number
		{
			return _mScaleY;
		}
		
		override public function set scaleY(value:Number):void
		{
			_mScaleY=value;
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
		    _mLocalMatrix=null;
			_mFakeParentMatrix=null;
			_isDispose=true;
			_bitmapDataEx=null;
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