package gpu2d.display
{
	import flash.display3D.Context3D;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getQualifiedClassName;
	
	import gpu2d.errors.AbstractClassError;
	import gpu2d.errors.AbstractMethodError;
	import gpu2d.events.GEvent;
	import gpu2d.events.GEventDispatcher;
	import gpu2d.utils.GMath;
	import gpu2d.utils.NameUtil;
	
	/**
	 * author :夜枫
	 * 时间 ：2011-11-11 下午02:47:47
	 */
	public class GDisplayObject extends GEventDispatcher
	{
		protected static const InitialName:String="gpu2d_instance";
		

		protected var _x:Number;
		protected var _y:Number;
		protected var _width:Number;
		protected var _height:Number;
		protected var _pivotX:Number;
		protected var _pivotY:Number;
		protected var _scaleX:Number;
		protected var _scaleY:Number;
		protected var _rotation:Number;
		protected var _visible:Boolean;
		protected var _alpha:Number;
		protected var _name:String;
		protected var _parent:GDisplayObjectContainer;
		
		public function GDisplayObject()
		{
			super();
			if (getQualifiedClassName(this) == "gpu2d.display::GDisplayObject")
				throw new AbstractClassError("gpu2d.display::GDisplayObject不能使用构造函数初始化");
			_x=_y=_pivotX=_pivotY=_rotation=_width=_height=0;
			_scaleX=_scaleY=_alpha=1;
			_visible=_mouseEnable=true;
			//// 名字属性初始化
			name=InitialName+NameUtil.getNameIndex();
		}
		public function dispose(childrenDispose:Boolean=true):void
		{
			removeEventListeners();
		}
		
		/** 显示对象的边界  显示对象的外围边界  当 对象旋转时  这个边界是会发生变化的
		 * 
		 * targetCoordinateSpace 指的是 父容器    表示是哪个坐标中相应的的边界
		 */		
	    public function getBounds(targetCoordinateSpace:GDisplayObject):Rectangle
    	{
		 throw new AbstractMethodError("该方法需要在子类中实现.");
		}
		
		/**显示对象的本地边界  也就是  这个矩形是出于该对象的内部     这个矩形用于计算本地坐标   当显示对象旋转时，这个边界始终不变
		 */		
		public function getLocalBounds():Rectangle
		{
			this.rotation=0;
			var tmpRotation:Number=rotation;
			var rect:Rectangle=getBounds(this);
			rotation=tmpRotation;
			return	rect;
		}
	
		/**globalPoint 指的是全局舞台坐标
		 */		
		public function hitTestPoint(globalPoint:Point):GDisplayObject
		{
			if(!_visible) return null;
			var localPoint:Point=globalToLocal(globalPoint);
			if(getBounds(this).contains(localPoint.x,localPoint.y))  return this;
			else return null;
		}
		
		/** 本地坐标转化为父坐标系
		 */		
		public function localToParent(localPoint:Point):Point
		{
			var matrix:Matrix=transformMatrix.clone();
			var parentPt:Point= matrix.transformPoint(localPoint);
			return parentPt;
		}
		/**父坐标转化为本地坐标
		 */		
		public function parentToLocal(parentPoint:Point):Point
		{
			var matrix:Matrix=transformMatrix.clone();
			matrix.invert();
			return matrix.transformPoint(parentPoint);
		}
		/** 默认转化到stage根容器中去
		 * 
		 *  container 参数 是其他容器  
		 */		
		public function localToContainer(localPoint:Point,container:GDisplayObjectContainer=null):Point
		{
			if(container==null) container=stage;
			var matrix:Matrix=getTransformationMatrixToSpace(container);
			return matrix.transformPoint(localPoint);
		}
		public function globalToLocal(globalPoint:Point):Point
		{
			 var matrix:Matrix=new Matrix();
			 var currentObj:GDisplayObject=this;
			 while(currentObj)
			 {
				 matrix.concat(currentObj.transformMatrix);
				 currentObj=currentObj.parent;
			 }
			 matrix.invert();
			 return matrix.transformPoint(globalPoint);
	
		}
		
		
		
		public function  get transformMatrix():Matrix
		{
			var _transformMatrix:Matrix=new Matrix();
				_transformMatrix.scale(_scaleX,_scaleY);
				_transformMatrix.translate(-pivotX,-pivotY);
				_transformMatrix.rotate(GMath.DegreeToRadian(_rotation));
				_transformMatrix.translate(pivotX,pivotY);
				_transformMatrix.translate(_x,_y);
			return _transformMatrix;
		}
		
		/** targetSpace为 null表示转化到targetSpace的根容器中去
		 *  矩阵转化   从当前对象的点 转化到  targetSpace 对象中   的矩阵    思维是 首先寻找 两者的根容器，然后再进行转化
		 * 
		 * 万能转化函数   将点从一个容器通过 该矩阵值可以实现转化到另一个容器中  getTransformationMatrixToSpace(targetSpace).transformPoint(pt)
		 */		
		public function getTransformationMatrixToSpace(targetSpace:GDisplayObject=null):Matrix
		{
			var rootMatrix:Matrix;
			var targetMatrix:Matrix;
			
			var currentObject:GDisplayObject = this;            

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
			
			var ancestors:Vector.<GDisplayObject> = new <GDisplayObject>[];
			var commonParent:GDisplayObject = null;///两者的共同容器
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
		
		public function render():void
		{
			/// 子类覆盖
		}
		internal function dispatchEventOnChildren(event:GEvent):void 
		{ 
			dispatchEvent(event); 
		}
		public function get root():GDisplayObject
		{
			var currentObject:GDisplayObject = this;
			while (currentObject.parent) currentObject = currentObject.parent;
			return currentObject;
		}
		public function get stage():GStage
		{
			return root as GStage;
		}
		public  function setParent(__parent:GDisplayObjectContainer):void	{	this._parent=__parent;	}
		
		public function get parent():GDisplayObjectContainer {	return _parent;		}
		
		public var name:String;
		public  var _mouseEnable:Boolean;
		
		public function get mouseEnable():Boolean {		return _mouseEnable;				}
		public function set mouseEnable(value:Boolean):void {		_mouseEnable=value;			}
		
		public function get x():Number { return _x; }
		public function set x(value:Number):void { _x = value; }
		
		public function get y():Number { return _y; }
		public function set y(value:Number):void { _y = value; }
		
		public function get pivotX():Number { return _pivotX; }
		public function set pivotX(value:Number):void { _pivotX = value; }
		
		public function get pivotY():Number { return _pivotY; }
		public function set pivotY(value:Number):void { _pivotY = value; }
		
		public function get scaleX():Number { return _scaleX; }
		public function set scaleX(value:Number):void {	_scaleX = value;		}
		
		public function get scaleY():Number { return _scaleY; }
		public function set scaleY(value:Number):void { _scaleY = value; }
		
		public function get rotation():Number { return _rotation; }
		public function set rotation(value:Number):void 
		{ 
			// move into range [-180 deg, +180 deg]
			while (value < -180) value += 360
			while (value >  180) value -= 360;
			_rotation = value;
		}
		
		public function get alpha():Number { return _alpha; }
		public function set alpha(value:Number):void 
		{ 
			_alpha = Math.max(0.0, Math.min(1.0, value)); 
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
		}
		
		public function get height():Number { return getBounds(_parent).height; }
		public function set height(value:Number):void
		{
			_scaleY = 1.0;
			var actualHeight:Number = height;
			if (actualHeight != 0.0) scaleY = value / actualHeight;
			else                     scaleY = 1.0;
		}
		
		
	}
}