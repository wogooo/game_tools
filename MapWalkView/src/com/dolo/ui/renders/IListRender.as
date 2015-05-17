package com.dolo.ui.renders
{
	import com.dolo.ui.controls.List;
	import flash.events.IEventDispatcher;

	/**
	 * List渲染器 需要实现的接口 
	 * 
	 * com.dolo.ui.renders.ListRenderBase类为自定义List渲染器提供了一个快速实现。可以直接从ListRenderBase继承或者从Sprite继承实现此接口
	 * 
	 * @author flashk
	 * 
	 * @see com.dolo.ui.renders.ListRenderBase
	 * 
	 */
	public interface IListRender extends IEventDispatcher
	{
		//设置数据和显示，value值为list.addItem(obj)对应的obj的传递过来的对象。List会自动传递对应的obj
		function set data(value:Object):void;
		
		//提供给List的获取方法，返回的应该是set data同样的value Object
		function get data():Object;
		
		//设置Render的索引位置，使用此方法value%2==0来判断当前处于奇偶行
		function set index(value:uint):void;
		
		//List会将render所属的List对象引用传递过来
		function set list(value:List):void;
		
		//切换Render的选中状态显示
		function set select(value:Boolean):void;
		
		//设置x坐标（只针对TileList有效），如果渲染器从Sprite继承则不必理会此方法
		function set x(value:Number):void;
		
		//设置y坐标，如果渲染器从Sprite继承则不必理会此方法
		function set y(value:Number):void;
		
		//返回渲染器的行高，List根据此值来确定每个Render之间的显示距离。最好覆盖Sprite的此方法来防止透明高度的问题。
		function get height():Number;
		
		//如果Render需要自适应大小，实现此方法，List会在更改大小和初始化时自动调用此方法
		function setSize(newWidht:Number,newHeight:Number):void;
		
		//当渲染器从List移除时，如removeItemAt或removeAll，将执行此方法，清除所有内存和引用并等待垃圾回收
		function dispose():void;
		
	}
}