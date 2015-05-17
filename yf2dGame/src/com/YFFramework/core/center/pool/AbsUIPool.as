package com.YFFramework.core.center.pool
{
	import com.YFFramework.core.ui.abs.AbsUIView;
	import com.YFFramework.core.utils.IDCreator;
	
	import flash.display.DisplayObject;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	
	/**   UI对象池
	 * 2012-8-24 上午9:08:48
	 *@author yefeng
	 */
	public class AbsUIPool extends AbsUIView implements IPool
	{
		/**是否 将其回收率   为true时表示 其 已经被回收率 了 false表示其还没有进行回收
		 */		
		protected var _isPool:Boolean;
		private var __id:int;
		public function AbsUIPool(autoRemove:Boolean=false)
		{
			__id=IDCreator.getID();
			_isPool=false;
			super(autoRemove);
		}
		override protected function initUI():void
		{
			super.initUI();
			setPoolNum();
		}
		
		/**注册对象池 
		 *  子类根据需要重写该类 
		 */		
		protected function setPoolNum():void
		{
			regPool(5);
		}
		
		/**注册对象池
		 *
		 */			
		protected function regPool(size:int):void
		{
			var className:String=getQualifiedClassName(this);
			var myClass:Class=getDefinitionByName(className) as Class;
			PoolCenter.Instance.regClass(myClass,size);
		}
		/**子类重写    重置对象为初始状态
		 * 重置对象至初始状态
		 */		
		public function reset():void
		{
			removeEvents();
			removeAllContent(true);
			x=0;
			y=0;
		}
		
		/**  移除子对象    dispose  表示是否进行内存释放       当为true时   执行  子对象的释放内存函数
		 */
//		override public function removeAllContent(dispose:Boolean=false):void
//		{
//			var len:int=numChildren;
//			var child:DisplayObject;
//			for(var i:int=0;i!=len;++i)
//			{
//				child=removeChildAt(0);
//				if(dispose)
//				{
//					if(child.hasOwnProperty(disposeToPool))  Object(child).disposeToPool();
//					else if(child.hasOwnProperty(dispose)) Object(child).dispose();
//				}
//			}
//		}

		
		/**回收
		 */		
		public function toPool():void
		{
			reset();
			_isPool=true;
		}
		/**子类重写   创建对象
		 * 池对象的 构造函数
		 ** @param obj
		 */		
		public function constructor(obj:Object):IPool
		{
			_isPool=false;
			return this;
		}
		
		/**是否已经被回收
		 * 
		 */		
		public function get isPool():Boolean
		{
			return _isPool;
		}
		
		public function getID():int
		{
			return __id;
		}

		
		public function disposeToPool():void
		{
			PoolCenter.Instance.toPool(this);
		}
	}
}