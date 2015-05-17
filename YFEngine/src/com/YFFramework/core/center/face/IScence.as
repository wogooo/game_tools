package com.YFFramework.core.center.face
{
	import flash.events.IEventDispatcher;
	/**
	 * author :夜枫 * 时间 ：Sep 21, 2011 1:46:29 PM
	 */
	public interface IScence extends IEventDispatcher
	{
		function get scenceType():String;
		function set scenceType(_scenceType:String):void;
		function enterScence():void;
		/** 移除场景 该方法的调用是通过Scencemanager调用的  该方法内部不需要释放Module  
		 * 所有场景相关的Module都在ScenceManager中完成   函数内部发送 ScenceEvent.RemoveScenceComplete事件
		 */		
		function removeScence():void;
		/**场景注册
		 */		
		function regScence():void;
		/**移除场景注册
		 */		
		function delScence():void;
	}
}