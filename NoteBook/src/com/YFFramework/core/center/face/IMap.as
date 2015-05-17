package com.YFFramework.core.center.face
{
	import flash.events.IEventDispatcher;

	/**
	 * author :夜枫 * 时间 ：Sep 21, 2011 3:57:12 PM
	 * 
	 * 通过定义方法实现地图自动加载
	 */
	public interface IMap extends IEventDispatcher
	{
		// function set mapId(_mapId:int):void;
		 function get mapId():int;
		/** 注册地图到地图数组中   
		 */
		function  regMap():void;
		/** 释放该地图的内存  内部发送ScenceEvent.RemoveMapComplete事件   这里只是进行UI的移除释放  移除后 可以通过  initMap()方法恢复到原始状态
		 */
		function removeMap():void;
		/** 将Map创建完成; 和 removeMap方法是互逆的   该方法是初始化UI但不进行UI的显示 也就是不进行添加到舞台  通过show()方法来将UI添加进舞台
		 */
		function initMap():void;
		
		/**该地图能否进行使用    为true表示能 进行使用 假如为false 则表示 需要调用 initMap()函数才能使用 调用initMap函数canUse值变为true 调用removeMap函数canUse值变为false
		 */
		function get canUse():Boolean;
		/** 将该地图显示出来    show()方法只是将已经初始化好了的UI添加到舞台上进行显示
		 */		
		function show():void;
		
	}
}