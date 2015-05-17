package com.YFFramework.core.center.face
{
	/**
	 * author :夜枫 * 时间 ：Sep 21, 2011 1:05:44 PM
	 */
	public interface IModule
	{
		/**将模块注册到场景
		 */		
		function regModule():void
		/** 将模块从场景中移除   该函数将调用 remove函数
		 */		
		function delFromScence(scenceType:String):Boolean;
		
		/** 显示模块 也就是将模块UI创建出来
		 */		
		function show():void;
		/**  移出模块删除内存    
		 */		
		function dispose():void;
		
	}
}