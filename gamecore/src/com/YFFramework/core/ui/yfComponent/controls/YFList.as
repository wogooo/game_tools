/**
 * 
var list:YFList=new YFList(2,300);
list.addItem({name:"测试1"});
list.addItem({name:"测试2"});
list.addItem({name:"测试3"});
addChild(list);
list.addEventListener(YFControlEvent.Select,onSelect);

function onSelect(e:ParamEvent):void
{
	trace(list.getSelectItem().name)
}

 * 
 */
package com.YFFramework.core.ui.yfComponent.controls
{
	/**  2012-6-21
	 *	@author yefeng
	 */
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.ui.abs.AbsUIView;
	import com.YFFramework.core.ui.abs.Scale9Bitmap;
	import com.YFFramework.core.ui.utils.Draw;
	import com.YFFramework.core.ui.container.HContainer;
	import com.YFFramework.core.ui.container.VContainer;
	import com.YFFramework.core.ui.yfComponent.YFComponent;
	import com.YFFramework.core.ui.yfComponent.YFSkin;
	import com.YFFramework.core.ui.yfComponent.events.YFControlEvent;
	
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;

	/**竖着的 list对象
	 *   皮肤id 可以选择  5   或者 8
	 */	
	[Event(name="Select",type="com.YFFramework.core.ui.yfComponent.events.YFControlEvent")]
	public class YFList extends YFAbsList
	{
		public function YFList(cellWidth:Number=100,space:int=0,skinId:int=8,backgroundColor:int=-1,align:String="center",autoRemove:Boolean=false)
		{
			super(skinId,cellWidth,space,YFAbsList.Vertical,backgroundColor,align,autoRemove);
		}
		
	}
}