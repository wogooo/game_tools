package com.YFFramework.core.center.pool
{
	import com.YFFramework.core.utils.IDCreator;
	
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;

	/**
	 * 数据对象池   UI对象池请使用AbsUIPool
	 * 2012-8-24 上午9:09:03
	 *@author yefeng
	 */
	public class AbsPool implements IPool
	{
		/**是否 将其回收率   为true时表示 其 已经被回收率 了 false表示其还没有进行回收
		 */		
		protected var _isPool:Boolean;
		private var __id:int;
		public function AbsPool()
		{
			_isPool=false;
			__id=IDCreator.getID();
			regObject();
		}
		
		
		/**注册对象池
		 */			
		protected function regPool(size:int):void
		{
			var className:String=getQualifiedClassName(this);
			var myClass:Class=getDefinitionByName(className) as Class;
			PoolCenter.Instance.regClass(myClass,size);
		}
		
		/**注册对象池
		 */		
		protected function regObject():void
		{
			regPool(3);
		}
		/**子类重写
		 * 重置对象至初始状态
		 */		
		public function reset():void
		{
		}
		/**子类重写
		 * 池对象的 构造函数
		 ** @param obj
		 */		
		public function constructor(obj:Object):IPool
		{
			_isPool=false;
			return this;
		}
		
		public function toPool():void
		{
			_isPool=true;
			reset();
		}
		/**是否已经回收
		 */		
		public function get isPool():Boolean
		{
			return _isPool;
		}
		
		/**
		 * 回收进对象池
		 */ 
		public function disposeToPool():void
		{
			PoolCenter.Instance.toPool(this);
		}
		
		public function getID():int
		{
			return __id;
		}
	}
}