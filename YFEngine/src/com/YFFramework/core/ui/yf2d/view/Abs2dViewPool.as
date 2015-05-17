package com.YFFramework.core.ui.yf2d.view
{
	import com.YFFramework.core.center.pool.IPool;
	import com.YFFramework.core.center.pool.PoolCenter;
	import com.YFFramework.core.utils.IDCreator;
	
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	/**2012-11-21 下午2:17:34
	 *@author yefeng
	 */
	public class Abs2dViewPool extends Abs2dView implements IPool
	{
		/**是否 将其回收率   为true时表示 其 已经被回收率 了 false表示其还没有进行回收
		 */		
		protected var _isPool:Boolean;
		private var __id:Number;

		public function Abs2dViewPool()
		{
			super();
			__id=IDCreator.getID();
			_isPool=false;
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
			removeAllChildren(true);
		}
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
			addEvents();
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