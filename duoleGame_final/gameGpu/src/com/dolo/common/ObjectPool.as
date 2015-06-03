package com.dolo.common
{
	import flash.utils.Dictionary;
	
	/**
	 * 单个特定Class类型的对象池，可以为任意类型的Class，如Sprite,TextField,Object等
	 * @author flashk
	 * 
	 */
	public class ObjectPool
	{
		private static var _pool : Dictionary = new Dictionary(true);
		
		private var _template : Class; 
		private var _list : Array;
		private var _returnCallFunction:Function;
		private var _getCallFunction:Function;
		private var _creatCallFunction:Function;

		/**
		 * 获得某类的对象池 
		 * @param value
		 * @return 
		 * 
		 */
		public static function getPoolInstance(value : Class,returnBackCallFunction:Function=null,getObjectCallFunction:Function=null,creatObjectCallFunction:Function=null) : ObjectPool 
		{
			if(!_pool[value]) {
				_pool[value] = new ObjectPool(value);
				ObjectPool(_pool[value]).returnCallFunction = returnBackCallFunction;
				ObjectPool(_pool[value]).getCallFunction = getObjectCallFunction;
				ObjectPool(_pool[value]).creatCallFunction = creatObjectCallFunction;
			}
			return _pool[value];
		}
		
		public function ObjectPool(value : Class)
		{
			_template = value;
			_list = [];  
		}
		
		public function get returnCallFunction():Function
		{
			return _returnCallFunction;
		}
		
		/**
		 * 返回对象池要执行的清理函数，函数接收返回的对象作为唯一参数，如function resetTextFiled(txt:TextField):void 
		 * @param value
		 * 
		 */
		public function set returnCallFunction(value:Function):void
		{
			_returnCallFunction = value;
		}
		
		public function get getCallFunction():Function
		{
			return _getCallFunction;
		}
		
		/**
		 *  获取对象要执行的初始化函数，函数接收返回的对象作为唯一参数，如function initTextFiled(txt:TextField):void ，
		 *  和creatCallFunction不同，不管拿到的对象是否是新创建的对象，此函数在getObject()时始终执行
		 * @param value
		 * 
		 */
		public function set getCallFunction(value:Function):void
		{
			_getCallFunction = value;
		}
		
		public function get creatCallFunction():Function
		{
			return _creatCallFunction;
		}
		
		/**
		 * 对象在完全新建时要执行的函数 
		 * @param value
		 * 
		 */
		public function set creatCallFunction(value:Function):void
		{
			_creatCallFunction = value;
		}
		
		/**
		 *  从对象池获取一个闲置对象
		 * @return 
		 * 
		 */
		public function getObject() : * 
		{
			var obj:*;
			if(_list.length > 0) { 
				obj  = _list.shift();
			}else{
				obj =  new _template();
				if(_creatCallFunction != null){
					_creatCallFunction(obj);
				}
			}
			if(_getCallFunction != null){
				_getCallFunction(obj);
			}
			return obj;
		}
		
		/**
		 * 返还一个对象到对象池中
		 * @param value 对象
		 * 
		 */
		public function returnObject(value : *) : void 
		{
			var len:int = _list.length;
			for(var i:int = 0;i<len;i++){
				if(_list[i] == value) return;
			}
			_list.push(value); 
			if(_returnCallFunction != null){
				_returnCallFunction(value);
			}
		}
		
		/**
		 * 预创建对象并放入池中
		 * @param creatNum 要一次创建的个数
		 * 
		 */
		public function creatObject(creatNum:uint,isAddNewAlways:Boolean=false):void
		{
			var needAdd:int = creatNum;
			if(isAddNewAlways == false){
				needAdd = creatNum - _list.length;
			}
			var obj:Object;
			for(var i:int=0;i<needAdd;i++){
				obj = new _template();
				if(_creatCallFunction != null){
					_creatCallFunction(obj);
				}
				_list.push(obj); 
			}
		}
		
	}
}