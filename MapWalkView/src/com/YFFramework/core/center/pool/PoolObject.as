package com.YFFramework.core.center.pool
{
	import flash.utils.Dictionary;
	

	/**对象池对象
	 * @author yefeng
	 *2012-8-23下午8:04:10
	 */
	public class PoolObject
	{
		/**对象池大小
		 */
		public var size:int;
		/** 要进行缓存的类    一般该类实例比较多 并且经常性的创建与释放
		 */
		public var myClass:Class;
		
		private var _dict:Dictionary;
		/**
		 * @param myClass
		 * @param size  能够实例化的最大个数  当超过这个个数  多余的的个数 在达到一定的时候会被GC掉的
		 */		
		public function PoolObject(myClass:Class,size:int)
		{
			this.myClass=myClass;
			this.size=size;
			_dict=new Dictionary();
//			_dict=new Vector.<IPool>();
				
		}
		/**从对象池取数据
		 */		
		public function getFromPool(obj:Object):IPool
		{
			///对象池里有可用对象
			for each (var pool:IPool in _dict )
			{
				delete _dict[pool.getID()];
				return pool.constructor(obj);
			}
//			if(_dict.length>0)_dict.pop().constructor(obj);
			///无可用对象 创建新对象
			return NewInstance(myClass,obj);
		}
		
		internal static function NewInstance(myClass:Class,obj:Object):IPool
		{
			if(obj!=null) return new myClass(obj) as IPool;
			return new myClass() as IPool;
		}
		/**回收
		 */		
		public function toPool(pool:IPool):void
		{

			_dict[pool.getID()]=pool;
			
//			var index:int=_dict.indexOf(pool);
//			if(index==-1)_dict.push(pool);
			pool.toPool();
		}
		
		/** 回收超过Size大小的对象   让其恢复至  size大小 
		 */		
		internal function gc():void
		{
//			var len:int=_dict.length;
//			var dif:int=len-size;
//			var obj:Object;
//			if(dif>0) /// 回收多余的 对象
//			{
//				for (var i:int=0;i!=dif;++i)
//				{
//					obj=_dict.pop();
//					if(obj.hasOwnProperty("dispose")) obj.dispose();
//				}
//			}
			var len:int=0;
			for each(var pool:IPool in _dict)
			{
				if(len<size)
				{
					delete _dict[pool.getID()];
					if(Object(pool).hasOwnProperty("dispose")) Object(pool).dispose();
					len++;
				}
			}
			
		}
		
		
		public function dispose():void
		{
			myClass=null;
			_dict=null;
		}
		
	}
}