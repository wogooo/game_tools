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
	import com.YFFramework.core.event.ParamEvent;
	import com.YFFramework.core.ui.abs.AbsUIView;
	import com.YFFramework.core.ui.abs.Scale9Bitmap;
	import com.YFFramework.core.ui.container.HContainer;
	import com.YFFramework.core.ui.container.VContainer;
	import com.YFFramework.core.ui.yfComponent.YFComponent;
	import com.YFFramework.core.ui.yfComponent.YFSkin;
	import com.YFFramework.core.ui.yfComponent.events.YFControlEvent;
	
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	/**具有 两个子类  横的叫做 YFTabMenu
	 * 竖着的叫做YFList
	 */	
	[Event(name="Select",type="com.YFFramework.core.ui.yfComponent.events.YFControlEvent")]
	public class YFAbsList extends YFComponent
	{
		
		public static const  Vertical:int=1;
		public static const Horizontal:int=2;
		/** 存放背景的容器    默认存放颜色
		 */
		//	private var _bgShape:Shape;
		
		private var _bgShape:Scale9Bitmap;
		
		/**   listItem容器
		 */
		private var _listContainer:AbsUIView;
		private var dict:Dictionary;
		private var _selectData:Object;
		private var _width:Number;
		private var _height:Number;
		private var _type:int;
		
		/** 每个对象的间距
		 */
		private var _space:int;
		private var _backgroundColor:int;
		
		private var _align:String;
		private static const BgSpace:int=2;
		/**
		 * @param cellWidth    YFToggleButton的宽度 
		 * @param type     1 表示   为  垂直的 list Vertical      2  表示为水平的list  Horizontal
		 * @param   space    连个 子对象的间距
		 */
		public function YFAbsList(skinId:int=8,cellWidth:Number=100,space:int=0,type:int=1,backgroundColor:int=-1,align:String="center",autoRemove:Boolean=true)
		{
			_skinId=skinId;
			_space=space;
			_width=cellWidth;
			_backgroundColor=backgroundColor;
			_type=type;
			_align=align;
			_height=0;
			super(autoRemove);
		}
		override protected function initUI():void
		{
			super.initUI();
			dict=new Dictionary();
			if(_type==Vertical)
			{
				_listContainer=new VContainer(_space,false);
				_style=YFSkin.Instance.getStyle(YFSkin.MenuListBg) ;
				var menuBgSkin:Scale9Bitmap=_style.link as Scale9Bitmap;
				_bgShape=menuBgSkin;
				addChild(_bgShape);
				_bgShape.x=-BgSpace;
				_bgShape.y=-BgSpace;
			}
			else _listContainer=new HContainer(_space,false);
			addChild(_listContainer);
		}
		
		override protected function addEvents():void
		{
			super.addEvents();
			addEventListener(YFControlEvent.Select,onSelect);
		}
		
		override protected function removeEvents():void
		{
			super.removeEvents();
			removeEventListener(YFControlEvent.Select,onSelect);
		}
		
		protected function onSelect(e:ParamEvent):void
		{
			_selectData=e.param;
		}
		
		
		/**
		 * @param data  数据对象
		 */
		public function setSelectData(data:Object):void
		{
			var len:int=_listContainer.numChildren;
			var item:YFListItem;
			for(var i:int=0;i!=len;++i)
			{
				item=_listContainer.getChildAt(i) as YFListItem;
				if(item.data==data) 
				{
					item.select=true;
					_selectData=data;
					return ;
				}
			}
		}
		/** 返回当前选中对象的数据  得到的是数据对象  不是ui  是 YFToogleButton.data对象
		 */
		public function getSelectData():Object
		{
			return _selectData;
		}
		
		/** 根据索引得到相应的数据
		 */
		public function getItemData(index:int):Object
		{
			return (_listContainer.getChildAt(index) as YFListItem).data;
		}
		/**返回当前选中的UI 对象
		 */
		public function getSelectItem():YFListItem
		{
			var len:int=_listContainer.numChildren;
			var item:YFListItem;
			for(var i:int=0;i!=len;++i)
			{
				item=_listContainer.getChildAt(i) as YFListItem;
				if(item.data==_selectData) 
				{
					return item;
				}
			}
			return null;
		}
		
		public function setSelectIndex(index:int):void
		{
			var item:YFListItem=_listContainer.getChildAt(index) as YFListItem;
			item.select=true;		
			_selectData=item.data;
		}
		/**任何对象都不进行选中 
		 */		
		public function setNullSelect():void
		{
			var selectItem:YFListItem=getSelectItem();
			if(selectItem) selectItem.select=false;
		}
		
		public function getSelectIndex():int
		{
			var len:int=_listContainer.numChildren;
			var item:YFListItem;
			for(var i:int=0;i!=len;++i)
			{
				item=_listContainer.getChildAt(i) as YFListItem;
				if(item.data==_selectData)  return i;
			}
			return -1;
		}
		
		
		/**
		 * @param data     数据对象
		 * @param showProperty   显示的文本属性
		 * 
		 */
		public function addItem(data:Object,showProperty:String=null):YFListItem
		{
			return addItemAt(data,showProperty);
		}
		/** 将物品添加到  哪个位置
		 * @param data
		 * @param index  为-1 时表示追加到最后面
		 * @param showProperty
		 */		
		public function addItemAt(data:Object,showProperty:String=null,index:int=-1):YFListItem
		{
			var name:String;
			if(!showProperty) name=data.toString();
			name=String(data[showProperty]);
			dict[data]=createListItem(data,name,index);
			drawBg();
			return dict[data];
		}
		
		/**  是否包含 该数据源
		 * @param data 数据源
		 */		
		public function  containsItem(data:Object) :Boolean
		{
			return dict[data]?true:false;
		}
		public function removeItem(data:Object):void
		{
			var item:YFListItem=dict[data];
			_listContainer.removeChild(item);
			item.dispose();
			Object(_listContainer).updateView();
			if(_selectData==data) setSelectIndex(0);
			dict[data]=null;
			delete dict[data];
			drawBg();
		}
		
		public function removeItemAt(index:int):void
		{
			var item:YFListItem=_listContainer.removeChildAt(index) as YFListItem;
			removeItem(item.data);
		}
		
		private function createListItem(data:Object,name:String,index:int=-1):YFListItem
		{
			var item:YFListItem=new YFListItem(name,_skinId,-1,_align);
			item.data=data;
			item.width=_width;
			if(index==-1)	_listContainer.addChild(item);
			else _listContainer.addChildAt(item,index);
			Object(_listContainer).updateView();
			return item
		}
		
		
		override public function dispose(e:Event=null):void
		{
			super.dispose(e);
			dict=null;
			_selectData=null;
		}
		
		
		/**  设置宽度   实际上设置的是每一个 ListItem的宽度
		 */
		override public function set width(value:Number):void
		{
			_width=value;
			var len:int=_listContainer.numChildren;
			var item:YFListItem;
			for(var i:int=0;i!=len;++i)
			{
				item=_listContainer.getChildAt(i) as YFListItem;	
				item.width=value;
			}
			drawBg();
		}
		
		override public function get width():Number
		{
			//		return _width;
			return _listContainer.width;
		}
		override public function set height(value:Number):void
		{
			drawBg();
		}
		
		override public function get height():Number
		{
			return _listContainer.height
			
		}
		
		protected function drawBg():void
		{  
		//	if(_backgroundColor>=0)	Draw.DrawRect(_bgShape.graphics,_listContainer.width,_listContainer.height,_backgroundColor);
			if(_bgShape)
			{
				_bgShape.width=_listContainer.width+BgSpace*2;
				_bgShape.height=_listContainer.height+BgSpace*2;
			}
			
		}
		
		
		/**德奥当前的listItem个数
		 */
		public function getItemNum():int
		{
			return _listContainer.numChildren;
		}
	}
}