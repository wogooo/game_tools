package com.YFFramework.core.ui.yfComponent.controls
{
	/**  
	 * 下拉菜单 
	 * 2012-6-28
	 *	@author yefeng
	 */
	import com.YFFramework.core.event.ParamEvent;
	import com.YFFramework.core.ui.yfComponent.YFComponent;
	import com.YFFramework.core.ui.yfComponent.YFSkin;
	import com.YFFramework.core.ui.yfComponent.events.YFControlEvent;
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	
	///得到的数据时 数据对象        e.data
	[Event(name="Select",type="com.YFFramework.core.ui.yfComponent.events.YFControlEvent")]
	public class YFComboBox extends YFComponent
	{
		
		protected var _btn:YFButton;
		protected var _list:YFList;
		/** 背景容器  填充颜色 
		 */
		protected var _width:Number;
		protected var _height:Number;
		
		protected var _scroller:YFScroller;
		
		/**滚动条的宽度
		 */
		private var _trackSize:int;
		public function YFComboBox(width:Number=200,height:Number=200,autoRemove:Boolean=false)
		{
			_width=width;
			_height=height;
			super(autoRemove);
		}
		
		override protected function initUI():void
		{
			super.initUI();
			_style=YFSkin.Instance.getStyle(YFSkin.ComboBox);
			_btn=new YFButton("YFControls",9,-1,"left");
			_btn.width=_width;
			addChild(_btn);
			_list=new YFList(_width,_style.link.space,8,_style.backgroundColor,"left");
			_scroller=new YFScroller(_list,_height-_btn.height);
			_trackSize=_scroller.trackSize;
			addChild(_scroller);
			_scroller.y=_btn.y+_btn.height;
		}
		
		
		/**添加内容
		 * @param data   数据对象
		 * @param showProp  要显示的属性名 
		 * 
		 */
		public function addItem(data:Object,showProp:String):void
		{
			_list.addItem(data,showProp);
			_scroller.updateView();
			if(_scroller.width>_width)
			{
				_list.width=_width-_trackSize;
				_scroller.updateView();
			}
		}
		/** 删除内容
		 * @param data 要删除的数据对象
		 */
		public function removeItem(data:Object):void
		{
			_list.removeItem(data);
			_scroller.updateView();
			if(_scroller.width<_width)
			{
				_list.width=_width;
				_scroller.updateView();
			}
		}
		
		public function removeItenmAt(index:int):void
		{
			var data:Object=_list.getItemData(index);
			removeItem(data);
		}
		
		override protected function addEvents():void
		{
			super.addEvents();
			_btn.addEventListener(MouseEvent.MOUSE_DOWN,onMouseEvent);
			_list.addEventListener(YFControlEvent.Select,onSelect);
			_stage.addEventListener(MouseEvent.MOUSE_DOWN,onMouseEvent);
		}
		
		override protected function removeEvents():void
		{
			super.removeEvents();
			_btn.removeEventListener(MouseEvent.MOUSE_DOWN,onMouseEvent);
			_list.removeEventListener(YFControlEvent.Select,onSelect);
			_stage.removeEventListener(MouseEvent.MOUSE_DOWN,onMouseEvent);
		}

		private function onMouseEvent(e:MouseEvent):void
		{
			switch(e.currentTarget)
			{
				case _btn:
					toggle();
					break;
				case _stage:
					if(!contains(e.target as DisplayObject)) _scroller.visible=false;
					break;
			}
		}
		
		private function onSelect(e:ParamEvent):void
		{
	//		toggle();
			_scroller.visible=false;   
			var selectItem:YFListItem=_list.getSelectItem();
			_btn.text=selectItem.text;
		}
		
		private function toggle():void
		{
			_scroller.visible=!_scroller.visible;
		}
		
		/** 设置ComboBox的宽度  cellWidth 是每个listItem 的宽度 
		 */
		override public function set width(cellWidth:Number):void
		{
			_btn.width=cellWidth;
			_list.width=cellWidth;
		}
		
		
		/**得到选中的对象
		 */
		public function getSelectData():Object
		{
			return _list.getSelectData();
		}
		/**设置选中的对象
		 */
		public function  setSelectData(obj:Object):void
		{
			_list.setSelectData(obj);
			var selectItem:YFListItem=_list.getSelectItem();
			_btn.text=selectItem.text;
		}
		
		/**设置选中的索引
		 */
		public function setSelectIndex(index:int):void
		{
			_list.setSelectIndex(index);
			var selectItem:YFListItem=_list.getSelectItem();
			_btn.text=selectItem.text;
		}
		/**得到选中的索引
		 */
		public function getSelectIndex():int
		{
			return _list.getSelectIndex();
		}
		/**个数
		 */	
		public function getItemNum():int{	return _list.getItemNum();	}
	}
}