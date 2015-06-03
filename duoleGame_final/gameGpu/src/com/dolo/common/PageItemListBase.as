package com.dolo.common
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	/**
	 * 分页内容控制的基类  
	 * @author flashk
	 * 
	 */
	public class PageItemListBase
	{
		protected var _list:Array;
		protected var _nowItemIndex:int;
		protected var _selectIndex:int=-1;
		protected var _lastSelectView:Sprite;
		protected var _datas:Array;
		
		public function PageItemListBase()
		{
			_list = [];
		}
		
		/**
		 * 添加一个Item显示对象到列表中，所有的Item组成一页的显示内容
		 * @param sp
		 * 
		 */
		public function addItemView(sp:Sprite):void
		{
			_list.push(sp);
			sp.addEventListener(MouseEvent.ROLL_OVER,onMouseOver);
			sp.addEventListener(MouseEvent.ROLL_OUT,onMouseOut);
			sp.addEventListener(MouseEvent.CLICK,onMouseClick);
			onItemOut(sp);
		}
		
		protected function onMouseClick(event:MouseEvent):void
		{
			if(_lastSelectView){
				onItemOut(_lastSelectView);
			}
			_lastSelectView = event.currentTarget as Sprite;
			onItemSelect(_lastSelectView);
			var index:int = getViewIndex(_lastSelectView);
			if(_datas == null) return;
			onItemClick(_lastSelectView,_datas[index],index);
		}
		
		protected function getViewIndex(view:Sprite):int
		{
			var index:int=0;
			var len:int = _list.length;
			for(var i:int=0;i<len;i++){
				if(_list[i] == view) {
					index = i;
					break;
				}
			}
			return index;
		}
		
		protected function onMouseOut(event:MouseEvent):void
		{
			var sp:Sprite = event.currentTarget as Sprite;
			if(_lastSelectView != sp){
				onItemOut(sp);
			}
		}
		
		protected function onMouseOver(event:MouseEvent):void
		{
			onItemOver(event.currentTarget as Sprite);
		}
		
		/**
		 * 渲染器项目被用户选中的逻辑处理 
		 * @param view
		 * 
		 */
		protected function onItemClick(view:Sprite,vo:Object,index:int):void
		{
			
		}
		
		/**
		 * 渲染器项目被用户选中的显示处理 
		 * @param view
		 * 
		 */
		protected function onItemSelect(view:Sprite):void
		{
			
		}
		
		/**
		 * 渲染器项目划出的显示处理
		 * @param view
		 * 
		 */
		protected function onItemOut(view:Sprite):void
		{
			
		}
		
		/**
		 * 渲染器项目划过的显示处理
		 * @param view
		 * 
		 */
		protected function onItemOver(view:Sprite):void
		{
			
		}
		/**
		 * 重置当前页 
		 * 
		 */
		public function removeAll():void
		{
			_nowItemIndex = 0;
			var sp:Sprite;
			_lastSelectView = null;
			_datas = [];
			for(var i:int=0;i<_list.length;i++){
				sp = Sprite(_list[i]);
				sp.visible = false;
				disposeItem(sp);
			}
		}
		
		/**
		 * 获得当前页某个项的渲染器实例引用 
		 * @param index
		 * @return 
		 * 
		 */
		public function getItemViewAt(index:uint):Sprite
		{
			return _list[index] as Sprite;
		}
		
		/**
		 *  向页面添加一个数据项 
		 * @param itemData
		 * 
		 */
		public function addItem(itemData:Object):void
		{
			_nowItemIndex++;
			var sp:Sprite = _list[_nowItemIndex-1] as Sprite;
			sp.visible = true;
			_datas.push(itemData);
			initItem(itemData,sp,_nowItemIndex-1);
			onItemOut(sp);
		}
		
		/**
		 * 子类覆盖此方法，显示Item内容 
		 * @param data
		 * @param view
		 * 
		 */
		protected function initItem(data:Object,view:Sprite,index:int):void
		{
			
		}
		/**
		 * 子类覆盖此方法，释放Item内存资源
		 * @param data
		 * @param view
		 * 
		 */
		protected function disposeItem(view:Sprite):void
		{
			
		}
		
	}
}