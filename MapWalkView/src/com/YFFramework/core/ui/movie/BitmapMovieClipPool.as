package com.YFFramework.core.ui.movie
{
	import com.YFFramework.core.center.pool.IPool;
	import com.YFFramework.core.center.pool.PoolCenter;
	import com.YFFramework.core.utils.IDCreator;
	
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;

	/**  基本动画  具备对象池功能
	 * @author yefeng
	 *2012-8-29下午8:58:44
	 */
	public class BitmapMovieClipPool extends BitmapMovieClip implements IPool
	{
		//////对象池
		/**是否 将其回收率   为true时表示 其 已经被回收率 了 false表示其还没有进行回收
		 */		
		protected var _isPool:Boolean;

		private var __id:int;
		public function BitmapMovieClipPool()
		{
			__id=IDCreator.getID();
			super();
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
			bitmapData=null;
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

		override public function dispose():void
		{
			super.dispose();
		}
		
		
		
	}
}