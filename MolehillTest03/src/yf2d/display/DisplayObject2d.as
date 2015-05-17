package yf2d.display
{
	import com.YFFramework.core.event.YFDispather;
	
	import flash.display3D.Context3D;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Matrix3D;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	import flash.utils.getQualifiedClassName;
	
	import yf2d.errors.AbstractClassError;
	import yf2d.errors.AbstractMethodError;
	import yf2d.material.AbsMaterial;
	import yf2d.utils.NameUtil;
	
	/**  显示对象  显示对象默认的注册点是在几何中心
	 * author :夜枫
	 */
	public class DisplayObject2d extends YFDispather
	{
		protected static const InitialName:String="yf2d_instance";
		
		internal var _width:Number;                                 
		internal var _height:Number;     
		protected var _x:Number;
		protected var _y:Number;
		protected var _pivotX:Number;
		protected var _pivotY:Number;
		protected var _scaleX:Number;
		protected var _scaleY:Number;
		protected var _rotationZ:Number;
		protected var _rotationX:Number;
		protected var _rotationY:Number;
		protected var _visible:Boolean;
		protected var _alpha:Number;
		protected var _name:String;
		protected var _parent:DisplayObjectContainer2d;
		
		
		
		
		////三维矩阵转化
		internal var invalidateMatrix:Boolean=true;
		internal var invalidateColors:Boolean=true;
		
		public var localModelMatrix:Matrix3D = new Matrix3D();
		public var worldModelMatrix:Matrix3D = new Matrix3D();
		
		
		
		protected var colorData:ColorTransform=new ColorTransform();
		protected var _colorTransform:ColorTransform=new ColorTransform();

		public function DisplayObject2d()
		{
			super();
			if (getQualifiedClassName(this) == "yf2d.display::DisplayObject2d")
				throw new AbstractClassError("gpu2d.display::DisplayObject2d不能使用构造函数初始化");
			_x=_y=_pivotX=_pivotY=_rotationZ=_rotationX=_rotationY=_width=_height=0;
			_scaleX=_scaleY=_alpha=1;
			_visible=_mouseEnable=true;
			//// 名字属性初始化
			name=InitialName+NameUtil.getNameIndex();
		}
		public function dispose(childrenDispose:Boolean=true):void
		{
			removeEventListeners();
			_parent=null;
			localModelMatrix=null;
			worldModelMatrix=null;
		}
		
		/** 显示对象的边界  显示对象的外围边界  当 对象旋转时  这个边界是会发生变化的
		 * 
		 * targetCoordinateSpace 指的是 父容器    表示是哪个坐标中相应的的边界
		 */		
	    public function getBounds(targetCoordinateSpace:DisplayObject2d):Rectangle
    	{
		 throw new AbstractMethodError("该方法需要在子类中实现.");
		}
		
		/**显示对象的本地边界  也就是  这个矩形是出于该对象的内部     这个矩形用于计算本地坐标   当显示对象旋转时，这个边界始终不变
		 */		
/*		public function getLocalBounds():Rectangle
		{
			this.rotation=0;
			var tmpRotation:Number=rotation;
			var rect:Rectangle=getBounds(this);
			rotation=tmpRotation;
			return	rect;
		}
*/	
		/**globalPoint 指的是全局舞台坐标
		 */		
		public function hitTestPoint(globalPoint:Point):DisplayObject2d
		{
			if(!_visible) return null;
			var localPoint:Point=globalToLocal(globalPoint);
			if(getBounds(this).contains(localPoint.x,localPoint.y))  return this;
			else return null;
		}
		/** 默认转化到stage根容器中去
		 * 
		 *  container 参数 是其他容器  
		 */		
		public function localToContainer(localPoint:Point,container:DisplayObjectContainer2d=null):Point
		{
			if(container==null) container=scence;
			var matrix:Matrix=getTransformationMatrixToSpace(container);
			return matrix.transformPoint(localPoint);
		}
		public function globalToLocal(globalPoint:Point):Point
		{
			 var matrix:Matrix=new Matrix();
			 var currentObj:DisplayObject2d=this;
			 while(currentObj)
			 {
				 matrix.concat(currentObj.transformMatrix);
				 currentObj=currentObj.parent;
			 }
			 matrix.invert();
			 return matrix.transformPoint(globalPoint);
	
		}
		
		
		/**  二维 矩阵
		 */		
		public function  get transformMatrix():Matrix
		{
			var matrix:Matrix = new Matrix();
			if (_pivotX != 0.0 || _pivotY != 0.0) matrix.translate(-_pivotX, -_pivotY);
			if (_scaleX != 1.0 || _scaleY != 1.0) matrix.scale(_scaleX, _scaleY);
			if (_rotationZ != 0.0)                 matrix.rotate(_rotationZ);
			if (_x != 0.0 || _y != 0.0)           matrix.translate(_x, _y);
			return matrix;
		}
		
		/** targetSpace为 null表示转化到targetSpace的根容器中去
		 *  矩阵转化   从当前对象的点 转化到  targetSpace 对象中   的矩阵    思维是 首先寻找 两者的根容器，然后再进行转化
		 * 
		 * 万能转化函数   将点从一个容器通过 该矩阵值可以实现转化到另一个容器中  getTransformationMatrixToSpace(targetSpace).transformPoint(pt)
		 */		
		public function getTransformationMatrixToSpace(targetSpace:DisplayObject2d=null):Matrix
		{
			var rootMatrix:Matrix;
			var targetMatrix:Matrix;
			
			var currentObject:DisplayObject2d = this;            

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
					currentObject = currentObject.parent;
				}
				return rootMatrix;
			}
			else if (targetSpace.parent == this) // optimization
			{
				targetMatrix = targetSpace.transformMatrix;
				targetMatrix.invert();
				return targetMatrix;
			}
			else if (targetSpace == parent) // optimization
			{
				return transformMatrix;
			}
		
			// 1. find a common parent of this and the target space
			
			var ancestors:Vector.<DisplayObject2d> = new <DisplayObject2d>[];
			var commonParent:DisplayObject2d = null;///两者的共同容器
			while (currentObject)
			{
				ancestors.push(currentObject);
				currentObject = currentObject.parent;
			}
			
			currentObject = targetSpace;
			while (currentObject && ancestors.indexOf(currentObject) == -1)
				currentObject = currentObject.parent;
			
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
				currentObject = currentObject.parent;
			}
			
			// 3. now move up from target until we reach the common parent
			
			targetMatrix = new Matrix();
			currentObject = targetSpace;
			while (currentObject != commonParent)
			{
				targetMatrix.concat(currentObject.transformMatrix);
				currentObject = currentObject.parent;
			}
			
			// 4. now combine the two matrices
			
			targetMatrix.invert();
			rootMatrix.concat(targetMatrix);
			
			return rootMatrix;            
		}   
    
		
	//	public function 
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
		public function getTransformationMatrix3DToSpace(targetSpace:DisplayObject2d=null):Matrix3D
		{
			var rootMatrix:Matrix3D;
			var targetMatrix:Matrix3D;
			
			var currentObject:DisplayObject2d = this;            
			
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
					rootMatrix.append(currentObject.localModelMatrix)
					//rootMatrix.concat(currentObject.transformMatrix);
					currentObject = currentObject.parent;
				}
				return rootMatrix;
			}
			else if (targetSpace.parent == this) // optimization
			{
				//targetMatrix = targetSpace.transformMatrix;
				targetMatrix = targetSpace.localModelMatrix;
				targetMatrix.invert();
				return targetMatrix;
			}
			else if (targetSpace == parent) // optimization
			{
				return localModelMatrix;
			}
			
			// 1. find a common parent of this and the target space
			
			var ancestors:Vector.<DisplayObject2d> = new <DisplayObject2d>[];
			var commonParent:DisplayObject2d = null;///两者的共同容器
			while (currentObject)
			{
				ancestors.push(currentObject);
				currentObject = currentObject.parent;
			}
			
			currentObject = targetSpace;
			while (currentObject && ancestors.indexOf(currentObject) == -1)
				currentObject = currentObject.parent;
			
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
				rootMatrix.append(currentObject.localModelMatrix);
				currentObject = currentObject.parent;
			}
			
			// 3. now move up from target until we reach the common parent
			
			targetMatrix = new Matrix3D();
			currentObject = targetSpace;
			while (currentObject != commonParent)   ///  currentObject 在 commonParent内部
			{
				//targetMatrix.concat(currentObject.transformMatrix);
				targetMatrix.append(currentObject.localModelMatrix);
				currentObject = currentObject.parent;
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
			if(_parent)	_parent.removeChild(this);
			else return false;
			if(_dispose) dispose();
			return true;
		}
		
		internal function dispatchEventOnChildren(type:String,data:Object=null):void 
		{ 
		//	dispatchEvent(event);
			dispatchEventWith(type,data);
		}
		public function get root():DisplayObject2d
		{
			var currentObject:DisplayObject2d = this;
			while (currentObject.parent) currentObject = currentObject.parent;
			return currentObject;
		}
		public function get scence():Scence2D
		{
			return root as Scence2D;
		}
		internal  function setParent(__parent:DisplayObjectContainer2d):void	{	this._parent=__parent;	}
		
		public function get parent():DisplayObjectContainer2d {	return _parent;		}
		
		public var name:String;
		protected  var _mouseEnable:Boolean;
		
		public function get mouseEnable():Boolean {		return _mouseEnable;				}
		public function set mouseEnable(value:Boolean):void {		_mouseEnable=value;			}
		
		public function get x():Number { return _x; }
		public function set x(value:Number):void
		{
			_x = value; 
			invalidateMatrix=true;
		}
		
		public function get y():Number { return _y; }
		public function set y(value:Number):void { _y = value; invalidateMatrix=true;}
		
		public function get pivotX():Number { return _pivotX; }
		public function set pivotX(value:Number):void { _pivotX = value;invalidateMatrix=true; }
		
		public function get pivotY():Number { return _pivotY; }
		public function set pivotY(value:Number):void { _pivotY = value;invalidateMatrix=true; }
		
		public function get scaleX():Number { return _scaleX; }
		public function set scaleX(value:Number):void {	_scaleX = value;	invalidateMatrix=true;	}
		
		public function get scaleY():Number { return _scaleY; }
		public function set scaleY(value:Number):void { _scaleY = value;invalidateMatrix=true; }
		
		public function get rotationZ():Number { return _rotationZ; }
		public function set rotationZ(value:Number):void 
		{ 
			// move into range [-180 deg, +180 deg]
			//while (value < -180) value += 360
			//while (value >  180) value -= 360;
			_rotationZ = value;
			invalidateMatrix=true;
		}
		
		public function get rotationY():Number { return _rotationY; }
		public function set rotationY(value:Number):void 
		{ 
			// move into range [-180 deg, +180 deg]
			//while (value < -180) value += 360
			//while (value >  180) value -= 360;
			_rotationY = value;
			invalidateMatrix=true;
		}
		public function get rotationX():Number { return _rotationX; }
		public function set rotationX(value:Number):void 
		{ 
			// move into range [-180 deg, +180 deg]
			//while (value < -180) value += 360
			//while (value >  180) value -= 360;
			_rotationX = value;
			invalidateMatrix=true;
		}
		
		
		public function get alpha():Number { return _alpha; }
		public function set alpha(value:Number):void 
		{ 
			if(value!=_alpha)
			{
				_alpha = Math.max(0.0, Math.min(1.0, value)); 
				invalidateColors=true;
			}
		}
		
		public function set colorTransform(_colorData:ColorTransform):void
		{
			if(_colorData!=colorData)
			{
				this.colorData=_colorData;
				invalidateColors=true;
			}
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
			invalidateMatrix=true;
		}
		
		public function get height():Number { return getBounds(_parent).height; }
		public function set height(value:Number):void
		{
			_scaleY = 1.0;
			var actualHeight:Number = height;
			if (actualHeight != 0.0) scaleY = value / actualHeight;
			else                     scaleY = 1.0;
			invalidateMatrix=true;
		}
		
		public function get colorTransform():ColorTransform{	return _colorTransform;}
		
		/** 具体使用 			
		 * lastMatrix.appendScale(width>>1,height>>1,1);  ///进行宽高转化匹配
		 * 
			lastMatrix.append(worldModelMatrix); //世界矩阵
			 lastMatrix.append(projection)  //投影矩阵
		 */		
		public function updateLocalModelMatrix3d():void
		{
			invalidateMatrix = false;
			localModelMatrix.identity();
			localModelMatrix.appendTranslation(-_pivotX, -_pivotY, 0);
			localModelMatrix.appendScale(_scaleX, _scaleY, 1.0);
			localModelMatrix.appendRotation(_rotationZ, Vector3D.Z_AXIS);
			localModelMatrix.appendRotation(_rotationY, Vector3D.Y_AXIS);
			localModelMatrix.appendRotation(_rotationX, Vector3D.X_AXIS);
			localModelMatrix.appendTranslation(_x, _y, 0);
		}
		public function updateWorldModelMatrix3d():void
		{
			worldModelMatrix.identity();
			var currentObj:DisplayObject2d=this;
			
		//	worldModelMatrix.append(currentObj.localModelMatrix)
		//	if(parent)  worldModelMatrix.append(parent.localModelMatrix)
			while(currentObj)
			{
					if(currentObj.invalidateMatrix) currentObj.updateLocalModelMatrix3d();
					worldModelMatrix.append(currentObj.localModelMatrix)
					currentObj=currentObj.parent;
			}
		}
		
		public function updateColors():void {
			
			invalidateColors = false;
			
			_colorTransform.redMultiplier = colorData.redMultiplier * _alpha;
			_colorTransform.greenMultiplier = colorData.greenMultiplier * _alpha;
			_colorTransform.blueMultiplier = colorData.blueMultiplier * _alpha;
			_colorTransform.alphaMultiplier = colorData.alphaMultiplier * _alpha;
			_colorTransform.redOffset = colorData.redOffset;
			_colorTransform.greenOffset = colorData.greenOffset;
			_colorTransform.blueOffset = colorData.blueOffset;
			_colorTransform.alphaOffset = colorData.alphaOffset;
			
			var currentObj:DisplayObject2d=parent;
			
		//	if(currentObj)  _colorTransform.concat(currentObj._colorTransform)

			while(currentObj)
			{
				if(currentObj.invalidateColors) currentObj.updateColors(); ///更新变化的color
				_colorTransform.concat(currentObj._colorTransform);
				currentObj=currentObj.parent;
			}
		
			if(this is DisplayObjectContainer2d)
			{
				
				for each(var child:DisplayObject2d in DisplayObjectContainer2d(this)._children)
				{
					child.updateColors();
				}
			}
		}
		
		public function render(context3d:Context3D,shader2d:AbsMaterial):void
		{
			
		}

		
	}
}