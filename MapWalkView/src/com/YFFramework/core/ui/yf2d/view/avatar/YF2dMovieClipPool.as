package com.YFFramework.core.ui.yf2d.view.avatar
{
	
	import com.YFFramework.core.center.pool.IPool;
	import com.YFFramework.core.center.pool.PoolCenter;
	import com.YFFramework.core.utils.IDCreator;
	
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	/**实现对现池功能
	 * 2012-11-21 上午10:20:28
	 *@author yefeng
	 */
	public class YF2dMovieClipPool extends YF2dMovieClip implements IPool
	{
		//////对象池
		/**是否 将其回收率   为true时表示 其 已经被回收率 了 false表示其还没有进行回收
		 */		
		protected var _isPool:Boolean;
		
		private var __id:int;
		public function YF2dMovieClipPool()
		{
			super();
			__id=IDCreator.getID();
			regObjectSize();
		}
		
		/////对象池
		
		/**注册对象池
		 */			
		protected function regObjectSize():void
		{
			regPool(5);
		}
		
		
		/**创建对象
		 */ 
		public function constructor(roleDyVo:Object):IPool
		{
			_isPool=false;
			addEvents();
			//	start();
			return this;
		}
		/**变为初始状态
		 */		
		public function reset():void
		{
			removeEvents();
			stop();
			actionData=null;
			_completeFunc=null;
			_completeParam=null;
			_playTween.dispose();
		}
		
		/**注册对象池
		 */			
		protected function regPool(size:int):void
		{
			var className:String=getQualifiedClassName(this);
			var myClass:Class=getDefinitionByName(className) as Class;
			PoolCenter.Instance.regClass(myClass,size);
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
		
		public function disposeToPool():void
		{
			PoolCenter.Instance.toPool(this);
		}
		
		public function getID():int
		{
			return __id;
		}
		
		
//		override public function render(context3d:Context3D, shader2d:AbsMaterial):void
//		{
//			super.render(context3d,shader2d);
//		}
	}
}