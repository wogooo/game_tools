package com.YFFramework.core.utils
{
	import flash.utils.Dictionary;

	/**hash表
	 * 列表  比如 好友列表   组队列表 等等一些列表 使用的类
	 * 2012-11-6 下午2:58:11
	 *@author yefeng
	 */
	public class HashMap
	{
		private var _dict:Dictionary;
		
		private var _size:int;
		
		public function HashMap()
		{
			_dict=new Dictionary();
			_size=0;
		}
		/**清空hashMap
		 */		
		public function clear():void
		{
			_dict=new Dictionary();
			_size=0;
		}
		/**添加
		 */		
		public function put(key:Object,data:Object):void
		{
			_dict[key]=data;
			_size++;
		}
		/**删除
		 */		
		public function remove(key:Object):void
		{
			if(_dict.hasOwnProperty(key)) 
			{
				_size--
				_dict[key]=null;
			}
			delete _dict[key];
		}
		
		public function get(key:Object):*
		{
			return _dict[key];
		}
		
		public function hasKey(key:Object):Boolean
		{
			return _dict.hasOwnProperty(key);
		}
		public function size():int
		{
			return _size;
		}
		/**   数据
		 */		
		public function values():Array
		{
			var arr:Array = [];
			for each(var data:* in _dict)
			{
				arr.push(data);
			}
			return arr;
		}
		public function getDict():Dictionary
		{
			return _dict;
		}
		
		
	}
}