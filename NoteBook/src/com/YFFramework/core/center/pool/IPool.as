package com.YFFramework.core.center.pool
{
	/**
	 * 对象池 接口
	 *  所有想要创建对象词的类都需要实现该接口
	 * @author yefeng
	 *2012-8-23下午7:57:38
	 */
	public interface IPool
	{
		/**恢复到初始状态  便于以后重用
		 * obj为参数
		 */	
		function  reset():void; 
		
		/**对象回收
		 */ 
		function toPool():void;
		
		/**构造函数    也就是对象池的构造函数
		 * obj为参数
		 */		
		function constructor(obj:Object):IPool;
		/**唯一标志id 
		 */		
		function getID():int;
	}
	
}