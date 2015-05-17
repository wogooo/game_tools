package gpu2d.display
{
	import flash.display3D.Context3D;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getQualifiedClassName;
	
	import gpu2d.errors.AbstractClassError;
	import gpu2d.events.GEvent;

	/**
	 * author :夜枫
	 * 时间 ：2011-11-11 下午02:53:08
	 */
	public class GDisplayObjectContainer extends GDisplayObject
	{
		
		private var _mouseChildren:Boolean;
		private var _children:Vector.<GDisplayObject>=new Vector.<GDisplayObject>();
		public function GDisplayObjectContainer()
		{
			super();
			if (getQualifiedClassName(this) == "gpu2d.display::GDisplayObjectContainer")
				throw new AbstractClassError("gpu2d.display::GDisplayObjectContainer不能直接实例化.");
			mouseChildren=true;
		}
		public function  addChild(child:GDisplayObject):GDisplayObject
		{                                                 
			return addChildAt(child, numChildren);
		}
		public function addChildAt(child:GDisplayObject,index:int):GDisplayObject
		{
			if (index >= 0 && index <= numChildren)
			{
				child.removeFromParent();
				_children.splice(index, 0, child);
				//child.parent=this;                               
				child.setParent(this);                 
				child.dispatchEvent(new GEvent(GEvent.ADDED));                
				if (stage) child.dispatchEventOnChildren(new GEvent(GEvent.ADDED_TO_STAGE));
			}
			else
			{
				throw new RangeError("Invalid child index");
			}
			return child;
		}
		public function  removeChild(_obj:GDisplayObject,__dispose:Boolean=false):GDisplayObject
		{
			var index:int=getChildIndex(_obj);
			if (index!=-1) return removeChildAt(index,__dispose);
			else throw new Error("_obj对象不在容器中");
			return null;
		}
		public function removeChildAt(index:int,__dispose:Boolean=false):GDisplayObject
		{
			if (index >= 0 && index < numChildren)
			{
				var child:GDisplayObject = _children[index];
				child.dispatchEvent(new GEvent(GEvent.REMOVED));
				if (stage) child.dispatchEventOnChildren(new GEvent(GEvent.REMOVED_FROM_STAGE));
			//	child.parent=null;
				child.setParent(null);
				_children.splice(index, 1);
				if (__dispose) child.dispose();
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
		public function getChildByName(_name:String):GDisplayObject
		{
			for each (var currentChild:GDisplayObject in _children)
			if (currentChild.name == _name) return currentChild;
			return null;
		}
		public function getChildAt(index:int):GDisplayObject
		{
			return _children[index];
		}
		public function getChildIndex(child:GDisplayObject):int
		{
			return _children.indexOf(child);
		}
		
		public function setChildIndex(child:GDisplayObject,index:int):void
		{
			var oldIndex:int = getChildIndex(child);
			if (oldIndex == -1) throw new ArgumentError("Not a child of this container");
			_children.splice(oldIndex, 1);
			_children.splice(index, 0, child);
		}
		
		public function swapChildren(child1:GDisplayObject,child2:GDisplayObject):void
		{
			var index1:int = getChildIndex(child1);
			var index2:int = getChildIndex(child2);
			if (index1 == -1 || index2 == -1) throw new ArgumentError("Not a child of this container");
			swapChildrenAt(index1, index2);
		}
		public function swapChildrenAt(index1:int,index2:int):void
		{
			var child1:GDisplayObject = getChildAt(index1);
			var child2:GDisplayObject = getChildAt(index2);
			_children[index1] = child2;
			_children[index2] = child1;
		}
		public function contains(child:GDisplayObject):Boolean
		{
			if (child == this) return true;
			for each (var currentChild:GDisplayObject in _children)
			{
				if (currentChild is GDisplayObjectContainer)
				{
					if ((currentChild as GDisplayObjectContainer).contains(child)) return true;
				}
				else
				{
					if (currentChild == child) return true;
				}
			}
			return false;
		}
		public function get numChildren():int {return _children.length; }
		// internal methods
		/** 容器和子容器  进行事件发送
		 */

		override internal function dispatchEventOnChildren(event:GEvent):void
		{
			// the event listeners might modify the display tree, which could make the loop crash. 
			// thus, we collect them in a list and iterate over that list instead.
			
			var listeners:Vector.<GDisplayObject> = new <GDisplayObject>[];
			getChildEventListeners(this, event.type, listeners);
			for each (var listener:GDisplayObject in listeners)
			listener.dispatchEvent(event);
		}
		
		private function getChildEventListeners(object:GDisplayObject, eventType:String, 
												listeners:Vector.<GDisplayObject>):void
		{
			var container:GDisplayObjectContainer = object as GDisplayObjectContainer;                
			if (object.hasEventListener(eventType))
				listeners.push(object);
			if (container)
				for each (var child:GDisplayObject in container._children)
				getChildEventListeners(child, eventType, listeners);
		}
		
		/**childrenDispose 表示该容器中方的对象是否也进行内存释放
		 */		
		override public function dispose(childrenDispose:Boolean=true):void
		{	if(childrenDispose)
				for each (var child:GDisplayObject in _children)
				child.dispose();
			super.dispose();
			_children=null;
		}
		
		override public function getBounds(targetSpace:GDisplayObject):Rectangle
		{
			var numChildren:int = _children.length;
			
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
				for each (var child:GDisplayObject in _children)
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
		
		
		override public function hitTestPoint(globalPoint:Point):GDisplayObject
		{
			if (!_visible)return null;
			var numChildren:int = _children.length;
			for (var i:int=numChildren-1; i>=0; --i) // front to back!
			{
				var child:GDisplayObject = _children[i];
				//var transformationMatrix:Matrix = getTransformationMatrixToSpace(child);
				//var transformedPoint:Point = transformationMatrix.transformPoint(localPoint);
			//	var localPoint:Point=child.globalToLocal(globalPoint);
				var target:GDisplayObject = child.hitTestPoint(globalPoint);
				if (target) return target;
			}
			
			return null;
		}
		public function get mouseChildren():Boolean
		{
			return _mouseChildren
		}
		public function set mouseChildren(value:Boolean):void
		{
			_mouseChildren=value;
			for each(var child:GDisplayObject in _children)
			{
				 child.mouseEnable=_mouseChildren;
				 if(child is GDisplayObjectContainer)
					 GDisplayObjectContainer(child).mouseChildren=_mouseChildren;
			}
		}
		
		
		override public function render():void
		{
			 if(!visible) return ;
			 var len:int=numChildren;
			 for(var i:int=len-1;i>=0;i--)
			 {
				 getChildAt(i).render();
			 }
		}
		
		
		
		
	}
}