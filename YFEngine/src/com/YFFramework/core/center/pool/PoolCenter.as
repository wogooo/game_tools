package com.YFFramework.core.center.pool
{
	import com.YFFramework.core.center.manager.update.UpdateManager;
	import com.YFFramework.core.debug.print;
	
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getTimer;

	/**
	 *   对象池 管理所有的对象池
	 * @author yefeng
	 *2012-8-23下午8:02:14
	 */
	public class PoolCenter
	{
		private static var _instance:PoolCenter;
		private var _dict:Dictionary;
		public function PoolCenter()
		{
			_dict=new Dictionary();
			///每五分钟执行一次gc 
		//	UpdateManager.Instance.frame3601.regFunc(gc);
			UpdateManager.Instance.frame601.regFunc(gc);
		}
		public static function get Instance():PoolCenter
		{
			if(!_instance) _instance=new PoolCenter();
			return _instance;
		}
		/** 注册到对象池
		 * @param mClass  mClass对象必须实现IPool
		 * @param size    容量  超过 这个容量的 Size将来 会被gc掉
		 */		
		public function regClass(mClass:Class,size:int=10):void
		{
			var className:String=getQualifiedClassName(mClass);
			if(!_dict[className])
			{
				var poolObj:PoolObject=new PoolObject(mClass,size);
				_dict[className]=poolObj;
			}
		}
		/**从对象池删除
		 * @param mClass
		 */		
		public function delClass(mClass:Class):void
		{
			var className:String=getQualifiedClassName(mClass);
			if(_dict[className])
			{
				var obj:PoolObject=_dict[className];
				delete _dict[className];
				obj.dispose();
			}
		}
		/** 获取 myClass对象的一个实例
		 * params 为构造函数的参数
		 * @param mClass
		 * @return 
		 */		
		public function getFromPool(mClass:Class,params:Object=null):IPool
		{
			var className:String=getQualifiedClassName(mClass);
			var poolObj:PoolObject=_dict[className];
			if(poolObj)
			{
				return poolObj.getFromPool(params);
			}
			//不再对象池时  mClass内部实现将其进行注册
			return PoolObject.NewInstance(mClass,params);
		}
		
		/** 对象回收  
		 * @param pool
		 */		
		public function toPool(pool:IPool):void
		{
			var className:String=getQualifiedClassName(pool);
			var poolObj:PoolObject=_dict[className];
			if(poolObj)
			{
				poolObj.toPool(pool);
			}
			else  throw new Error("请将"+className+"注册到对象池后在使用!");
			
		}
		
		
		internal function gc():void
		{
	//		var _gcTime:Number=getTimer();
			for each (var poolObj:PoolObject in _dict)
			{
				poolObj.gc();
			}
	//		print(this,"_gcTime:",getTimer()-_gcTime);
		}
			
	}
}