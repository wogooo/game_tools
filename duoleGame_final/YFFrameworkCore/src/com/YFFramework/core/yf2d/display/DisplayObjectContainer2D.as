package com.YFFramework.core.yf2d.display
{
	import com.YFFramework.core.yf2d.material.Sprite2DMaterial;
	
	import flash.display3D.Context3D;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	/**
	 * author :夜枫
	 * 时间 ：2011-11-11 下午02:53:08
	 */
	public class DisplayObjectContainer2D extends DisplayObject2D           
	{
		
		protected var _mouseChildren:Boolean;
		
		internal var _children:Vector.<DisplayObject2D>=new Vector.<DisplayObject2D>();
		private var _dict:Dictionary=new Dictionary();///进行对象检测时的优化
		protected var _num:int;
		
		/**遍历时候使用
		 */		
		private var displayObj:DisplayObject2D;
		/**用于for 循环
		 */		 
		private var i:int;
		
		public function DisplayObjectContainer2D()
		{
			super();
			_mouseChildren=true;
			_num=0;
		}
		public function  addChild(child:DisplayObject2D):DisplayObject2D
		{                                                 
			return addChildAt(child, numChildren);
		}
		public function addChildAt(child:DisplayObject2D,index:int):DisplayObject2D
		{
			if (index >= 0 && index <= numChildren)
			{
				child.removeFromParent();
				_children.splice(index, 0, child);
				_dict[child.getYF2dID()]=child;
				child.setParent(this);           
//				child.invalidateMatrix=true;
				child.invalidateColors=true;
				_num++;
			}
			else
			{
				throw new RangeError("Invalid child index");
			}
			return child;
		}
		public function  removeChild(_obj:DisplayObject2D,__dispose:Boolean=false):DisplayObject2D
		{
			var index:int=getChildIndex(_obj);
			if (index!=-1) return removeChildAt(index,__dispose);
			else throw new Error("_obj对象不在容器中");
			return null;
		}
		public function removeChildAt(index:int,__dispose:Boolean=false):DisplayObject2D
		{
			if (index >= 0 && index < numChildren)
			{
				var child:DisplayObject2D = _children[index];
				child.setParent(null);
				_children.splice(index, 1);
				_dict[child.getYF2dID()]=null;
				delete _dict[child.getYF2dID()]
				if (__dispose) child.dispose();
//				child.invalidateMatrix=true;
//				child.invalidateColors=true;
				_num--;
				return child;
			}
			else
			{
				throw new RangeError("Invalid child index");
			}
			return null;	
		}
		
		/** 删除   [beginIndex,endIndex) 之间的元素    endIndex 不进行删除  实际删除时   beginIndex到 endIndex-1  之间进行删除
		 */		
		public function removeChildren(beginIndex:int=0, endIndex:int=-1, dispose:Boolean=false):void
		{
			if (endIndex < 0 || endIndex >= numChildren) 
				endIndex = numChildren ;
			for (var i:int=beginIndex; i<endIndex; ++i)
				removeChildAt(beginIndex, dispose);
		}
//		public function getChildByName(_name:String):DisplayObject2D
//		{
//			for each (var currentChild:DisplayObject2D in _children)
//			if (currentChild.name == _name) return currentChild;
//			return null;
//		}
		public function getChildAt(index:int):DisplayObject2D
		{
			return _children[index];
		}
		public function getChildIndex(child:DisplayObject2D):int
		{
			return _children.indexOf(child);
		}
		
		public function setChildIndex(child:DisplayObject2D,index:int):void
		{
			var oldIndex:int = getChildIndex(child);
			if(oldIndex==index) return ;
			if (oldIndex == -1) throw new ArgumentError("Not a child of this container");
			_children.splice(oldIndex, 1);
			_children.splice(index, 0, child);
		}
		
		public function swapChildren(child1:DisplayObject2D,child2:DisplayObject2D):void
		{
			var index1:int = getChildIndex(child1);
			var index2:int = getChildIndex(child2);
			if (index1 == -1 || index2 == -1) throw new ArgumentError("Not a child of this container");
//			swapChildrenAt(index1, index2);  ///优化  ...
			_children[index1] = child2;
			_children[index2] = child1;
		}
		public function swapChildrenAt(index1:int,index2:int):void
		{
			var child1:DisplayObject2D = getChildAt(index1);
			var child2:DisplayObject2D = getChildAt(index2);
			_children[index1] = child2;
			_children[index2] = child1;
		}
		public function contains(child:DisplayObject2D):Boolean
		{
//			var index:int=_children.indexOf(child);
//			if(index!=-1) return true;
//			return false;
			return _dict[child.getYF2dID()];
		}
		public function get numChildren():int 
		{
//			return _children.length;
			return _num;
		}
		// internal methods
		/** 容器和子容器  进行事件发送
		 */
		
		override internal function dispatchEventOnChildren(type:String,data:Object=null):void
		{
			// the event listeners might modify the display tree, which could make the loop crash. 
			// thus, we collect them in a list and iterate over that list instead.
			
			var listeners:Vector.<DisplayObject2D> = new <DisplayObject2D>[];
			getChildEventListeners(this, type, listeners);
			for each (var listener:DisplayObject2D in listeners)
			listener.dispatchEventWith(type,data);
		}
		
		private function getChildEventListeners(object:DisplayObject2D, eventType:String, 
												listeners:Vector.<DisplayObject2D>):void
		{
			var container:DisplayObjectContainer2D = object as DisplayObjectContainer2D;                
			if (object.hasEventListener(eventType))
				listeners.push(object);
			if (container)
				for each (var child:DisplayObject2D in container._children)
				getChildEventListeners(child, eventType, listeners);
		}
		
		/**childrenDispose 表示该容器中方的对象是否也进行内存释放
		 */		
		override public function dispose(childrenDispose:Boolean=true):void
		{	
//			if(childrenDispose)
//			{
//				for(var i:int=0;i!=_num;++i)
//				{
//					displayObj=_children[i];
//					displayObj.dispose();
//				}
//			}
			super.dispose();
			_children=null;
			_dict=null; 
		}
		/**删除所有的子对象
		 * @param childrenDispose
		 */		
		public function removeAllChildren(childrenDispose:Boolean=true):void
		{
			
				if(childrenDispose)
				{
	
					for each (var child:DisplayObject2D in _children)
					{
							child.dispose();	
					}
				}
				_dict=new Dictionary();
				_children=new Vector.<DisplayObject2D>();
				_num=0;
		}
		
		override public function getBounds(targetSpace:DisplayObject2D):Rectangle
		{
			var numChildren:int = _num;
			
			if (numChildren == 0)
			{
				var matrix:Matrix = getTransformationMatrixToSpace(targetSpace);
				var position:Point = matrix.transformPoint(new Point(x, y));
				return new Rectangle(position.x, position.y);
			}
			else if (numChildren == 1)
			{	
				return _children[0].getBounds(targetSpace);     
			}
			else
			{
				var minX:Number = Number.MAX_VALUE, maxX:Number = -Number.MAX_VALUE;
				var minY:Number = Number.MAX_VALUE, maxY:Number = -Number.MAX_VALUE;
				for each (var child:DisplayObject2D in _children)
				{
					var childBounds:Rectangle = child.getBounds(targetSpace);
					minX = Math.min(minX, childBounds.x);
					maxX = Math.max(maxX, childBounds.x + childBounds.width);
					minY = Math.min(minY, childBounds.y);
					maxY = Math.max(maxY, childBounds.y + childBounds.height);   
				}
				return new Rectangle(minX, minY, maxX-minX, maxY-minY);
			}                
		}
		
		/**
		 * @param globalPoint
		 * @param checkApla  是否检测透明区域
		 */		
		override public function hitTestPoint(globalPoint:Point,checkApla:Boolean=false):DisplayObject2D
		{
			if (_visible==false||_isDispose==true)return null;
			if(mouseEnabled)  ///具备鼠标
			{
				var numChildren:int = _children.length;
				for (var i:int=numChildren-1; i>=0; i--) // front to back!
				{
					var child:DisplayObject2D = _children[i];
					var target:DisplayObject2D = child.hitTestPoint(globalPoint,checkApla);
					if (target) 
					{
						if(mouseChildren)return target;
						else return this;
					}
				}
			}
			return null;
		}
		/**  检测碰撞 
		 * @param globalPoint
		 * @param checkArr [dict,dict] dict的唯一id 是getYF2dID 	 只需要检测的对象  checkArr  唯一id 为 getYF2dID
		 * @param checkApla
		 */		
		public function hitTestPoint2(globalPoint:Point,checkArr:Array,checkApla:Boolean=false):DisplayObject2D
		{
			if (!_visible)return null;
			if(mouseEnabled)  ///具备鼠标
			{
				var numChildren:int = _children.length;
				var isExist:Boolean;
				for (var i:int=numChildren-1; i>=0; i--) // front to back!
				{
					var child:DisplayObject2D = _children[i];
					isExist=isContainObj(checkArr,child);
					if(isExist)
					{
						var target:DisplayObject2D = child.hitTestPoint(globalPoint,checkApla);
						if (target) 
						{
							if(mouseChildren)return target;
							else return this;
						}
					}
				}
			}
			return null;
		}
		/**checkArr [dict,dict] dict的唯一id 是getYF2dID 	 只需要检测的对象  checkArr  唯一id 为 getYF2dID
		 * child 待检测的对象
		 */		
		private  function isContainObj(checkArr:Array,child:DisplayObject2D):Boolean
		{
			var isContain:DisplayObject2D=null;
			for each(var dict:Dictionary in checkArr)
			{
				if(dict[child.getYF2dID()]) return true;
			}
			return false;
		}
		
		
		
		
		public function get mouseChildren():Boolean
		{
			return _mouseChildren
		}
		public function set mouseChildren(value:Boolean):void
		{
			_mouseChildren=value;
			//			for each(var child:DisplayObject2d in _children)
			//			{
			//				 child.mouseEnable=_mouseChildren;
			//				 if(child is DisplayObjectContainer2d)
			//					 DisplayObjectContainer2d(child).mouseChildren=_mouseChildren;
			//			}
		}
		
		
		
		override public function render(context3d:Context3D,shader2d:Sprite2DMaterial):void
		{
			if((!_isDispose)&&_visible)
			{
				///先画最上面的   也就是最后添加的 
//				var child:DisplayObject2D;
				for(i=0;i!=_num;++i)
				{
					displayObj=_children[i]; //提高效率
				//	if(!displayObj.isDispose)
					displayObj.render(context3d,shader2d);
				}
			}
		}
		/**子对象颜色发生改变
		 */		
		override internal function set invalidateColors(value:Boolean):void
		{
			_invalidateColors=value;
			if(_invalidateColors) ///如果颜色为改变为true则将子对象也设置为改变 
			{
				for each(var displayObj:DisplayObject2D in _children)
				{
					displayObj.invalidateColors=true;///颜色发生改变
				}
			}
			
			_invalidateColors=false;
		}
		
		
//		override internal function set invalidateMatrix(value:Boolean):void
//		{
//			_invalidateMatrix=value;
//			if(_invalidateMatrix) ///如果坐标位置换大小等发生改变 为true 则对其子对象也有影响
//			{
//				for(i=0;i!=_num;++i)
//				{
//					displayObj=_children[i];
//					displayObj.invalidateMatrix=true;
//				}
//			}
//		} 
		
		public function get children():Vector.<DisplayObject2D>
		{
			return _children;
		}
		
		
		override public function set blendMode(value:String):void 
		{
			super.blendMode=value;
			for each(var obj:DisplayObject2D in _children )
			{
				obj.blendMode=value;
			}
		}
		/**设置是否检测alpha  在怪物类中使用    一般设置 为flase 表示不进行alpha检测     默认值是为true 的 
		 */		
		override public function set checkAlpha(value:Boolean):void 
		{
			super.checkAlpha=value;
			for each(var obj:DisplayObject2D in _children )
			{
				obj.checkAlpha=value;
			}
		}
	}
}