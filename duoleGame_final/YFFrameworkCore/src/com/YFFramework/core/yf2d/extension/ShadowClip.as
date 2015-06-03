package com.YFFramework.core.yf2d.extension
{
	import com.YFFramework.core.ui.yf2d.data.ATFActionData;

	/**处理人物阴影   禁止使用  x  y属性 只准使用 矩阵
	 * @author yefeng
	 * 2013 2013-5-9 下午6:02:02 
	 */
	public class ShadowClip extends RolePart2DView 
	{
		public function ShadowClip()
		{
			super();
		}
		override public function initActionDataStandWalk(data:ATFActionData):void
		{
			actionDataStandWalk=data;
		}

		/**  不要 对矩阵进行修改
		 */		
//		override public function set x(value:Number):void
//		{
////			throw new Error("禁止使用x,y属性， 只允许使用localModelMatrix 方法");
//			
//		}
//		override public function set y(value:Number):void
//		{
////			throw new Error("禁止使用x,y属性， 只允许使用localModelMatrix 方法");
//		}
		override public function setXY(mX:Number, mY:Number):void
		{
			throw new Error("禁止使用x,y属性， 只允许使用localModelMatrix 方法");
		}
		
		 
		

//		override public function set pivotX(value:Number):void 
//		{ 
//			throw new Error("禁止使用该属性， 只允许使用localModelMatrix 方法");
//		}
//		
//		override public function set pivotY(value:Number):void 
//		{
//			throw new Error("禁止使用该属性， 只允许使用localModelMatrix 方法");
//		}
//		
//		override public function set scaleX(value:Number):void 
//		{	
//			throw new Error("禁止使用该属性， 只允许使用localModelMatrix 方法");
//		}
//		
//		override public function set scaleY(value:Number):void
//		{
//			throw new Error("禁止使用该属性， 只允许使用localModelMatrix 方法");
//		}
//		
//		override public function set rotationZ(value:Number):void 
//		{ 
//			throw new Error("禁止使用该属性， 只允许使用localModelMatrix 方法");
//		}
//		
//		override public function set rotationY(value:Number):void 
//		{ 
//			throw new Error("禁止使用该属性， 只允许使用localModelMatrix 方法");
//		}
//		override public function set rotationX(value:Number):void 
//		{ 
//			throw new Error("禁止使用该属性， 只允许使用localModelMatrix 方法");
//		}
//		override public function disposeToPool():void
//		{
//			disposeToPoolExceptMatrix();
//		}

	}
}