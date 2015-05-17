package com.YFFramework.core.center.face
{
	/**
	 * author :夜枫 * 时间 ：2011-9-25 下午02:51:46
	 * 配置资源，也就是外部的文本资源的接口
	 * 一般常用的界面文字的配置资源
	 */
	public interface IConfigFile
	{
		/** 注册配置资源到配置资源管理中心     只要进入游戏首先就会加载这些配置资源 因为这些资源为文本 所以大小比较小
		 */		
		function regFile():void;
		/** 配置文件的url地址
		 */
		function get fileUrl():String;
		/** 文件具体的文本数据
		 */		
		function set data(value:*):void;
		
		function get data():*;
		/**释放内存
		 */		
		function remove():void;
		
	}
}