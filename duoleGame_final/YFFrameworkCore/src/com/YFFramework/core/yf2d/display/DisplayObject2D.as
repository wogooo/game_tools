package com.YFFramework.core.yf2d.display
{
	import com.YFFramework.core.proxy.StageProxy;
	import com.YFFramework.core.yf2d.errors.AbstractMethodError;
	import com.YFFramework.core.yf2d.events.YF2dEventDispatcher;
	import com.YFFramework.core.yf2d.material.Program3DManager;
	import com.YFFramework.core.yf2d.material.Sprite2DMaterial;
	
	import flash.display3D.Context3D;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Matrix3D;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	
	/**  显示对象  显示对象默认的注册点是在几何中心
	 * author :夜枫
	 */
	public class DisplayObject2D extends YF2dEventDispatcher
	{
		
		/**programId号
		 */
//		public var programId:int=Program3DManager.ATFAlphaProgram;
		
//		protected static const InitialName:String="yf2d_instance";
		
		private static var ConvertMatrix:Matrix=new Matrix();;
		
		internal var _width:Number=0;                                 
		internal var _height:Number=0;     
		protected var _x:Number=0;
		protected var _y:Number=0;
		protected var _pivotX:Number=0;
		protected var _pivotY:Number=0;
		protected var _scaleX:Number=0;
		protected var _scaleY:Number=0;
		protected var _rotationZ:Number=0;
		protected var _rotationX:Number=0;
		protected var _rotationY:Number=0;
		protected var _visible:Boolean;
		protected var _alpha:Number=1;
//		protected var _name:String;
		protected var _parent:DisplayObjectContainer2D;
		
		/**是否检测透明区域  ,怪物选中是不需要检测透明区域的     默认值为true  表示进行检测   该 值 的具体使用 在Sprite2D中使用
		 */		
		protected var _checkAlpha:Boolean;

		/**渲染模式
		 */		
		private var _blendMode:String;
		private var blendFactors:Array ; 
		
		protected var _transformMatrix:Matrix=new Matrix();
		////三维矩阵转化
//		internal var _invalidateMatrix:Boolean=true;
		/** 坐标改变
		 */		
		private var _selfInvalidateMatrix:Boolean=true;
		
		/** 2d 矩阵 改变 
		 */
		private var _self2dMatrixInvalidate:Boolean=true;
		/**子类重写  颜色无效 
		 */		
		internal var _invalidateColors:Boolean=true;
		private var _selfInvalidateColors:Boolean=true;
		
		protected var _localModelMatrix:Matrix3D = new Matrix3D();
		protected var worldModelMatrix:Matrix3D = new Matrix3D();
		
		protected var _colorTransform:ColorTransform=new ColorTransform();
		protected var _worldColorTransform:ColorTransform=new ColorTransform();
		protected var _localColorTransform:ColorTransform=new ColorTransform();

//		public var name:String;                     
		protected  var _mouseEnabled:Boolean;
		/**创建唯一标识  id 为hash 数组使用
		 */
		private static var __yfIdCreate:Number=0;
		private var ___yfID:Number;
		
		/**是否已经释放了内存
		 */		
		protected var _isDispose:Boolean;
		public function DisplayObject2D()
		{
			++__yfIdCreate;
			___yfID=__yfIdCreate;
			_x=_y=_pivotX=_pivotY=_rotationZ=_rotationX=_rotationY=_width=_height=0;
			_scaleX=_scaleY=_alpha=1;
			_visible=_mouseEnabled=true;
			//// 名字属性初始化
//			name=InitialName+___yfID;
			_isDispose=false;
			blendMode = BlendMode.NORMAL;
			_checkAlpha=true;
			
			super();
		}
		public function getYF2dID():Number
		{
			return ___yfID;
		}
		/** 是否检测透明区域   DisplayObject类对该方法进行重写  AbsSprite对 该属性进行 具体实际的操作
		 */		
		public function set checkAlpha(value:Boolean):void
		{
			_checkAlpha=value;
		}
		public function get checkAlpha():Boolean
		{
			return _checkAlpha;
		}
		
		
		
		internal function get invalidateColors():Boolean
		{
			return _invalidateColors;
		}
		internal function set invalidateColors(value:Boolean):void
		{
			_invalidateColors=value;
			updateWorldColors();
		}
		
//		internal function get invalidateMatrix():Boolean
//		{
//			return _invalidateMatrix;
//		}
//		internal function set invalidateMatrix(value:Boolean):void
//		{
//			_invalidateMatrix=value;
//		}
		
		/**无效
		 */
//		public function doInvalide():void
//		{
//			if(!_invalidateMatrix)invalidateMatrix=true;
//		}
		
		/** 显示对象的边界  显示对象的外围边界  当 对象旋转时  这个边界是会发生变化的
		 * 
		 * targetCoordinateSpace 指的是 父容器    表示是哪个坐标中相应的的边界
		 */		
		public function getBounds(targetCoordinateSpace:DisplayObject2D):Rectangle
		{
			throw new AbstractMethodError("该方法需要在子类中实现.");
		}
	
		/**globalPoint 指的是全局舞台坐标
		 * checkAlpha 是否检测透明区域
		 */		
		public function hitTestPoint(globalPoint:Point,checkAlpha:Boolean=false):DisplayObject2D
		{
			if(!_visible) return null;
			if(mouseEnabled)
			{
				var localPoint:Point=globalToLocal(globalPoint);
				var isContain:Boolean=getBounds(this).contains(localPoint.x,localPoint.y);
				if(isContain) 
				{
					if(!checkAlpha) return this;
					else 
					{
						if(!handleCheckAlpha(localPoint))return this;   ///不透明 则表示检测到对象了
					}
				}
			}
			return null;
		}
		/** 
		 * @该方法需要在子类重写  如果要进行透明检测的话
		 * 是否为透明   为透明 则返回true 
		 * @param localPt
		 */		
		public function handleCheckAlpha(localPt:Point):Boolean
		{
			return false;
		}
		
		public function globalToLocal(globalPoint:Point):Point
		{
		//	var matrix:Matrix=new Matrix();
			ConvertMatrix.identity();
			var currentObj:DisplayObject2D=this;
			while(currentObj)
			{
				ConvertMatrix.concat(currentObj.transformMatrix);
				currentObj=currentObj._parent;
			}
			ConvertMatrix.invert();
			return ConvertMatrix.transformPoint(globalPoint);
		}
		
		
		/**  二维 矩阵
		 * 此方法无用 注释diao
		 */		
		public function  get transformMatrix():Matrix
		{
			if(_self2dMatrixInvalidate)
			{
				_transformMatrix.identity();
				if (_pivotX != 0.0 || _pivotY != 0.0) _transformMatrix.translate(-_pivotX, -_pivotY);
				if (_scaleX != 1.0 || _scaleY != 1.0) _transformMatrix.scale(_scaleX, _scaleY);
				if (_rotationZ != 0.0)                 _transformMatrix.rotate(_rotationZ);
				if(isNaN(_x))_x=0;
				if(isNaN(_y))_y=0;
				if (_x != 0.0 || _y != 0.0)           _transformMatrix.translate(_x, _y);
				_self2dMatrixInvalidate=false;
			}
			return _transformMatrix;
		}
		 
		/** targetSpace为 null表示转化到targetSpace的根容器中去
		 *  矩阵转化   从当前对象的点 转化到  targetSpace 对象中   的矩阵    思维是 首先寻找 两者的根容器，然后再进行转化
		 * 
		 * 万能转化函数   将点从一个容器通过 该矩阵值可以实现转化到另一个容器中  getTransformationMatrixToSpace(targetSpace).transformPoint(pt)
		 */		
		
		public function getTransformationMatrixToSpace(targetSpace:DisplayObject2D=null):Matrix
		{
			var rootMatrix:Matrix;
			var targetMatrix:Matrix;
			
			var currentObject:DisplayObject2D = this;            
			
			if (targetSpace == this)
			{
				return new Matrix();
			}
			else if (targetSpace == null)
			{
				// targetCoordinateSpace 'null' represents the target space of the root object.
				// -> move up from this to root
				rootMatrix = new Matrix();
				currentObject = this;
				while (currentObject)
				{
					rootMatrix.concat(currentObject.transformMatrix);
					currentObject = currentObject._parent;
				}
				return rootMatrix;
			}
			else if (targetSpace._parent == this) // optimization
			{
				targetMatrix = targetSpace.transformMatrix;
				targetMatrix.invert();
				return targetMatrix;
			}
			else if (targetSpace == _parent) // optimization
			{
				return transformMatrix;
			}
			
			// 1. find a common parent of this and the target space
			
			var ancestors:Vector.<DisplayObject2D> = new <DisplayObject2D>[];
			var commonParent:DisplayObject2D = null;///两者的共同容器
			while (currentObject)
			{
				ancestors.push(currentObject);
				currentObject = currentObject._parent;
			}
			
			currentObject = targetSpace;
			while (currentObject && ancestors.indexOf(currentObject) == -1)
				currentObject = currentObject._parent;
			
			if (currentObject == null)
				throw new ArgumentError("Object not connected to target");
			else
				commonParent = currentObject;
			
			// 2. move up from this to common parent
			
			rootMatrix = new Matrix();
			currentObject = this;
			
			while (currentObject != commonParent)
			{
				rootMatrix.concat(currentObject.transformMatrix);
				currentObject = currentObject._parent;
			}
			
			// 3. now move up from target until we reach the common parent
			
			targetMatrix = new Matrix();
			currentObject = targetSpace;
			while (currentObject != commonParent)
			{
				targetMatrix.concat(currentObject.transformMatrix);
				currentObject = currentObject._parent;
			}
			
			// 4. now combine the two matrices
			
			targetMatrix.invert();
			rootMatrix.concat(targetMatrix);
			
			return rootMatrix;            
		}   
		
		/**包含Z维度的矩阵转化  转化到 targetSpace空间所需要的矩阵
		 * 
		 * 
		 * 使用 ：lastMatrix.appendScale(width>>1,height>>1,1);  ///进行宽高转化匹配
		 * 
		 lastMatrix.append(getTransformationMatrix3DToSpace()); //世界矩阵
		 lastMatrix.append(projection)  //投影矩阵
		 
		 * 
		 * 
		 */		
		public function getTransformationMatrix3DToSpace(targetSpace:DisplayObject2D=null):Matrix3D
		{
			var rootMatrix:Matrix3D;
			var targetMatrix:Matrix3D;
			
			var currentObject:DisplayObject2D = this;            
			
			if (targetSpace == this)
			{
				return new Matrix3D();
			}
			else if (targetSpace == null)
			{
				// targetCoordinateSpace 'null' represents the target space of the root object.
				// -> move up from this to root
				rootMatrix = new Matrix3D();
				currentObject = this;
				while (currentObject)
				{
					rootMatrix.append(currentObject._localModelMatrix)
					//rootMatrix.concat(currentObject.transformMatrix);
					currentObject = currentObject._parent;
				}
				return rootMatrix;
			}
			else if (targetSpace._parent == this) // optimization
			{
				//targetMatrix = targetSpace.transformMatrix;
				targetMatrix = targetSpace._localModelMatrix;
				targetMatrix.invert();
				return targetMatrix;
			}
			else if (targetSpace == _parent) // optimization
			{
				return _localModelMatrix;
			}
			
			// 1. find a common parent of this and the target space
			
			var ancestors:Vector.<DisplayObject2D> = new <DisplayObject2D>[];
			var commonParent:DisplayObject2D = null;///两者的共同容器
			while (currentObject)
			{
				ancestors.push(currentObject);
				currentObject = currentObject._parent;
			}
			
			currentObject = targetSpace;
			while (currentObject && ancestors.indexOf(currentObject) == -1)
				currentObject = currentObject._parent;
			
			if (currentObject == null)
				throw new ArgumentError("Object not connected to target");
			else
				commonParent = currentObject;
			
			// 2. move up from this to common parent
			
			rootMatrix = new Matrix3D();
			currentObject = this;
			
			while (currentObject != commonParent)
			{
				//rootMatrix.concat(currentObject.transformMatrix);
				rootMatrix.append(currentObject._localModelMatrix);
				currentObject = currentObject._parent;
			}
			
			// 3. now move up from target until we reach the common parent
			
			targetMatrix = new Matrix3D();
			currentObject = targetSpace;
			while (currentObject != commonParent)   ///  currentObject 在 commonParent内部
			{
				//targetMatrix.concat(currentObject.transformMatrix);
				targetMatrix.append(currentObject._localModelMatrix);
				currentObject = currentObject._parent;
			}
			
			// 4. now combine the two matrices
			
			targetMatrix.invert();
			rootMatrix.append(targetMatrix);
			
			return rootMatrix;    
		}
		
		
		
		
		/** 从父容器中移除
		 * @param _dispose   true 表示移出舞台时  该对象还进行内存释放 	false 表示移出舞台时  不进行内存释放
		 * @return    true 表示 成功 移除  false  表示对象原来就不存在parent 不需要进行移除
		 */		
		public function  removeFromParent(_dispose:Boolean=false):Boolean
		{
			if(_dispose) dispose();
			if(_parent)	
			{
				_parent.removeChild(this);
				return true;
			}
			return false;
		}
		
		internal function dispatchEventOnChildren(type:String,data:Object=null):void 
		{ 
			//	dispatchEvent(event);
			dispatchEventWith(type,data);
		}
		public function get root():DisplayObject2D
		{
			var currentObject:DisplayObject2D = this;
			while (currentObject.parent) currentObject = currentObject.parent;
			return currentObject;
		}
		public function get scence():Scence2D
		{
			return root as Scence2D;
		}
		internal  function setParent(__parent:DisplayObjectContainer2D):void	{	this._parent=__parent;	}
		
		public function get parent():DisplayObjectContainer2D {	return _parent;		}
		
		public function get blendMode():String { return _blendMode; }
		public function set blendMode(value:String):void 
		{
			_blendMode = value; 
			blendFactors=BlendMode.getBlendFactors(value,true);
		}
		/**设置blend模式
		 */ 
		internal function setBlendFactors(context3d:Context3D):void
		{
			context3d.setBlendFactors(blendFactors[0],blendFactors[1]);  ////设置alpha值
		}
		
		
		public function get mouseEnabled():Boolean {		return _mouseEnabled;				}
		public function set mouseEnabled(value:Boolean):void {		_mouseEnabled=value;			}
		
		public function get x():Number { return _x; }
		public function get y():Number { return _y; }
		
		/**不 推荐使用 
		 */
		public function set x(value:Number):void
		{
			_x = value; 
//			invalidateMatrix=true;
			_selfInvalidateMatrix=true;
			_self2dMatrixInvalidate=true;
		}
		
		/**不 推荐使用 
		 */
		public function set y(value:Number):void 
		{
			if(_y!=value)
			{
				_y = value;
				_selfInvalidateMatrix=true;
				_self2dMatrixInvalidate=true;
//				invalidateMatrix=true;
			}
		} 
		
		public function setX(value:Number):void
		{
				_x = value; 
//				invalidateMatrix=true;
				_selfInvalidateMatrix=true;
				_self2dMatrixInvalidate=true;
		}
		public function setY(value:Number):void 
		{
//			if(_y!=value)
//			{
				_y = value;
				_selfInvalidateMatrix=true;
				_self2dMatrixInvalidate=true;
//				invalidateMatrix=true;
//			}
		} 
		/**优化  设置 xy 优于单独设置
		 */
		public function setXY(mX:Number,mY:Number):void
		{
				_x=mX;
				_y=mY;
				_selfInvalidateMatrix=true;
				_self2dMatrixInvalidate=true;
//				invalidateMatrix=true;
		}
		
		/**优化  设置 xy 优于单独设置
		 */
		public function setXYScaleX(mX:Number,mY:Number,mScaleX:Number):void
		{
				_x=mX;
				_y=mY;
				scaleX=mScaleX;
				_selfInvalidateMatrix=true;
				_self2dMatrixInvalidate=true;
//				invalidateMatrix=true;
		}
		
		public function setXYScaleXY(mX:Number,mY:Number,mScaleX:Number,mScaleY:Number):void
		{
				_x=mX;
				_y=mY;
				_scaleX=mScaleX;
				_scaleY=mScaleY;
				_selfInvalidateMatrix=true;
				_self2dMatrixInvalidate=true;
//				invalidateMatrix=true;
		}
		
		/**优化  设置 xy 优于单独设置
		 */
		public function setXYPivotXY(mX:Number,mY:Number,pivotX:Number,pivotY:Number):void
		{
				_x=mX;
				_y=mY;
				_pivotX=pivotX;
				_pivotY=pivotY;
				_selfInvalidateMatrix=true;
				_self2dMatrixInvalidate=true;
//				invalidateMatrix=true;
		}

		public function get pivotX():Number { return _pivotX; }
		public function set pivotX(value:Number):void 
		{ 
			if(_pivotX!=value)
			{
				_pivotX = value;
//				invalidateMatrix=true; 
				_selfInvalidateMatrix=true;
				_self2dMatrixInvalidate=true;
			}
		}
		
		public function get pivotY():Number { return _pivotY; }
		public function set pivotY(value:Number):void 
		{
			if(_pivotY!=value)
			{
				_pivotY = value;
//				invalidateMatrix=true; 
				_selfInvalidateMatrix=true;
				_self2dMatrixInvalidate=true;
			}
		}
		
		public function get scaleX():Number { return _scaleX; }
		public function set scaleX(value:Number):void 
		{	
			if(_scaleX!=value)
			{
				_scaleX = value;
//				invalidateMatrix=true;
				_selfInvalidateMatrix=true;
				_self2dMatrixInvalidate=true;
			}
		}
		
		public function set scaleY(value:Number):void
		{
			if(_scaleY!=value)
			{
				_scaleY = value;
//				invalidateMatrix=true;
				_selfInvalidateMatrix=true;
				_self2dMatrixInvalidate=true;
			}
		}
		
		public function get scaleY():Number { return _scaleY; }

		
		
		public function get rotationZ():Number { return _rotationZ; }
		public function set rotationZ(value:Number):void 
		{ 
			if(_rotationZ!=value)
			{
				_rotationZ = value;
//				invalidateMatrix=true;
				_selfInvalidateMatrix=true;
				_self2dMatrixInvalidate=true;
			}
		}
		/**  去除 不需要的部分
		 * 
		public function get rotationY():Number { return _rotationY; }
		public function set rotationY(value:Number):void 
		{ 
			// move into range [-180 deg, +180 deg]
			//while (value < -180) value += 360
			//while (value >  180) value -= 360;
			if(_rotationY!=value)
			{
				_rotationY = value;
				invalidateMatrix=true;
				_selfInvalidateMatrix=true;
			}
		}
		public function get rotationX():Number { return _rotationX; }
		public function set rotationX(value:Number):void 
		{ 
			// move into range [-180 deg, +180 deg]
			//while (value < -180) value += 360
			//while (value >  180) value -= 360;
			if(_rotationX!=value)
			{
				_rotationX = value;
				invalidateMatrix=true;
				_selfInvalidateMatrix=true;
			}
		}
		
		**/
		
		public function get alpha():Number { return _alpha; }
		public function set alpha(value:Number):void 
		{ 
			if(value!=_alpha)
			{
				_alpha = Math.max(0.0, Math.min(1.0, value)); 
				_selfInvalidateColors=true;
				invalidateColors=true;
			}
		}
		
		/**鼠标坐标
		 */		
		public function get mousePt():Point
		{
			var gloablePt:Point=new Point(StageProxy.Instance.stage.mouseX-scence.x,StageProxy.Instance.stage.mouseY-scence.y);
			///转化为本地坐标
			return globalToLocal(gloablePt);
		}
		
		public function get visible():Boolean { return _visible; }
		public function set visible(value:Boolean):void { _visible = value; } 
		
		public function get width():Number { return getBounds(_parent).width; }        
		public function set width(value:Number):void
		{
			// this method calls 'this.scaleX' instead of changing mScaleX directly.
			// that way, subclasses reacting on size changes need to override only the scaleX method.
			
			_scaleX = 1.0;
			var actualWidth:Number = width;
			if (actualWidth != 0.0) scaleX = value / actualWidth;
			else                    scaleX = 1.0;
//			invalidateMatrix=true;
			_selfInvalidateMatrix=true;
			_self2dMatrixInvalidate=true;
		}
		
		public function get height():Number { return getBounds(_parent).height; }
		public function set height(value:Number):void
		{
			_scaleY = 1.0;
			var actualHeight:Number = height;
			if (actualHeight != 0.0) scaleY = value / actualHeight;
			else                     scaleY = 1.0;
//			invalidateMatrix=true;
			_selfInvalidateMatrix=true;
			_self2dMatrixInvalidate=true;
		}
		/**是否已经释放了内存
		 */		
		public function get isDispose():Boolean
		{
			return _isDispose;
		}
		
		
		public function set localColorTransform(_colorData:ColorTransform):void
		{
			if(_colorData!=_colorTransform)
			{
				this._colorTransform=_colorData;
				_selfInvalidateColors=true;
				invalidateColors=true;
			}
		}
		
		public function set localModelMatrix(matrix3d:Matrix3D):void
		{
			_localModelMatrix=matrix3d;
//			invalidateMatrix=true;
			_selfInvalidateMatrix=false;
		}
		public function get localModelMatrix():Matrix3D
		{
			return _localModelMatrix;
		}
			
		/** 具体使用 			
		 * lastMatrix.appendScale(width>>1,height>>1,1);  ///进行宽高转化匹配
		 * 
		 lastMatrix.append(worldModelMatrix); //世界矩阵
		 lastMatrix.append(projection)  //投影矩阵
		 */		
		public function updateLocalModelMatrix3d():void
		{
//			invalidateMatrix = false;
			_selfInvalidateMatrix=false;
			_localModelMatrix.identity();
			if(_pivotX!=0||_pivotY!=0)
				_localModelMatrix.appendTranslation(-_pivotX, -_pivotY, 0);
			if(_scaleX!=0&&_scaleY!=0)
				_localModelMatrix.appendScale(_scaleX, _scaleY, 1.0);
			if(_rotationZ!=0)
				_localModelMatrix.appendRotation(_rotationZ, Vector3D.Z_AXIS);
			if(_rotationY!=0)
				_localModelMatrix.appendRotation(_rotationY, Vector3D.Y_AXIS);
			if(_rotationX!=0)
				_localModelMatrix.appendRotation(_rotationX, Vector3D.X_AXIS);
			if(_x!=0||_y!=0)
			_localModelMatrix.appendTranslation(_x, _y, 0);
		}
		public function updateWorldModelMatrix3d():void
		{
//			_invalidateMatrix = false;
			worldModelMatrix.identity();
			var currentObj:DisplayObject2D=this;
			while(currentObj)
			{
			//	if(currentObj.invalidateMatrix) currentObj.updateLocalModelMatrix3d();
				if(currentObj._selfInvalidateMatrix) currentObj.updateLocalModelMatrix3d();
				worldModelMatrix.append(currentObj._localModelMatrix)
				currentObj=currentObj._parent;
			}
		}
		
		private function updateLocalColors():void
		{
			_selfInvalidateColors=false;
			_localColorTransform.redMultiplier = _colorTransform.redMultiplier * _alpha;
			_localColorTransform.greenMultiplier = _colorTransform.greenMultiplier * _alpha;
			_localColorTransform.blueMultiplier = _colorTransform.blueMultiplier * _alpha;
			_localColorTransform.alphaMultiplier = _colorTransform.alphaMultiplier * _alpha;
			_localColorTransform.redOffset = _colorTransform.redOffset;
			_localColorTransform.greenOffset = _colorTransform.greenOffset;
			_localColorTransform.blueOffset = _colorTransform.blueOffset;
			_localColorTransform.alphaOffset = _colorTransform.alphaOffset;
		}
		
		public function updateWorldColors():void {
			
			_invalidateColors = false;
			_worldColorTransform.redMultiplier = 1;
			_worldColorTransform.greenMultiplier = 1;
			_worldColorTransform.blueMultiplier = 1;
			_worldColorTransform.alphaMultiplier = 1;
			_worldColorTransform.redOffset = 0;
			_worldColorTransform.greenOffset = 0;
			_worldColorTransform.blueOffset = 0;
			_worldColorTransform.alphaOffset = 0;
			var currentObj:DisplayObject2D=this;
			while(currentObj)
			{
				if(currentObj._selfInvalidateColors) currentObj.updateLocalColors(); ///更新变化的color
				_worldColorTransform.concat(currentObj._localColorTransform);
				currentObj=currentObj._parent;
			}
		}
		
		public function render(context3d:Context3D,shader2d:Sprite2DMaterial):void
		{
			
		}
		/**左上角 设置为注册点
		 */		
		public function letTopRegister():void
		{
			pivotX=-_width*0.5;
			pivotY=-_height*0.5
		}
		
		
		
		public function dispose(childrenDispose:Boolean=true):void
		{
			removeEventListeners();
			_parent=null;
			_localModelMatrix=null;
			worldModelMatrix=null;
			_transformMatrix=null;
			_isDispose=true;
			blendFactors=null;
			_colorTransform=null;
			_worldColorTransform=null;
			_localColorTransform=null;
		}

		
	}
}