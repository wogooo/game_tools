package com.YFFramework.core.center.pool
{
	import com.YFFramework.core.ui.abs.AbsUIView;
	
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
		public function AbsUIPool(autoRemove:Boolean=false)
		{
			super(autoRemove);
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
		}
		
		/**回收
		 */		
		public function toPool():void
		{
			_isPool=true;
			reset();
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
		
	}
}