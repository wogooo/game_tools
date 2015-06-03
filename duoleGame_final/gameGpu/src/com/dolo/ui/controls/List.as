package com.dolo.ui.controls
{
	import com.YFFramework.core.center.manager.dbClick.DBClickManager;
	import com.dolo.ui.events.UIEvent;
	import com.dolo.ui.managers.UI;
	import com.dolo.ui.renders.DefaultListItemRender;
	import com.dolo.ui.renders.IListRender;
	import com.dolo.ui.tools.Align;
	import com.dolo.ui.tools.AutoBuild;
	import com.dolo.ui.tools.Xdis;
	
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.getTimer;
	
	/**
	 * 列表 / 表格基础
	 * @author flashk
	 * 
	 * 自定义Render的方法参见：uiSkin.GridItemTest 为库链接的名字，_ui变量对应此链接生成的实例，
	 * list.addItem(obj)之中的obj会被传递到set data方法。并为每一个数据项new一个render。render类必须实现IListRender方法和从Sprite继承
	 * renderWidth分别为render的初始宽高，如果需要让render自适应多个大小，覆盖setSize方法。更多的参考render基类和接口
	 * ===========================================
	 * package com.YFFramework.game.core.module.forge.view
		{
			import com.dolo.ui.renders.ListRenderBase;
			import com.dolo.ui.tools.Xdis;
			public class TestRender extends ListRenderBase
			{
				public function TestRender()
				{
					renderWidth = 270;
					renderHeight = 35;
				}
				override protected function resetLinkage():void
				{
					_linkage = "uiSkin.GridItemTest";
				}
				override public function set data(value:Object):void
				{
					super.data =value;
					
					Xdis.getTextChild(_ui,"a_txt").text = value.label;
					Xdis.getTextChild(_ui,"b_txt").text = value.b;
					Xdis.getTextChild(_ui,"c_txt").text = value.c;
				}
			}
		}
	 * ===========================================
	 */
	public class List extends UIComponent
	{
		/** 设置ScrollBar在list里的位置和render的间隔
		 */		
		public static var defaultScrollBarXAdd:int = 0;
		
		protected var _textFilters:Array = null;
		protected var _itemRender:Class;
		protected var _ui:Sprite;
		protected var _renderContainer:Sprite;
		protected var _scrollBar:VScrollBar;
		protected var _selectedIndex:int = -1;
		protected var _selectedItem:Object;
		protected var _lastSelect:IListRender;
		protected var _selectable:Boolean = true;
		protected var _bg:DisplayObject;
		protected var _isNeedResetRenderSize:Boolean = true;
		protected var _lastSelectIndex:int = -1;
		protected var _isDispatchEvnet:Boolean = true;
		protected var _mulSelectable:Boolean=false;
		protected var _selfDeselect:Boolean=false;
		protected var _selectedSp:IListRender;
		protected var _selectEnable:Boolean=true;
		
		/// yefeng添加  是  单击图标时 是否 只响应小飞鞋 而不响应 本对象      true 表示只响应小飞鞋   false  表示响应 全部对象Event.Change
		/** 默认为不响应   图标  进行图标响应 需要自己外部对 IconImage进行侦听
		 */
		private var _iconImageTrigger:Boolean;
		/**是否支持双击 默认为false 只有为 true  才支持双击
		 */		
		private var _canDBClick:Boolean;
		/**双击事件的回调
		 */		
		public var dbClickCall:Function;
		override public function dispose():void
		{
			super.dispose();
			_textFilters = null;
			_itemRender = null;
			_ui = null;
			_renderContainer = null;
			_scrollBar = null;
			_selectedItem = null;
			_lastSelect = null;
			_bg = null;
		}
		
		public function List()
		{
			itemRender = DefaultListItemRender;
			_renderContainer = new Sprite();
			this.addChild( _renderContainer );
			_iconImageTrigger=false;
		}
		/**当点击图标时候是否只响应 图标   true 表示只响应图标,   false  表示响应 全部对象Event.Change  默认为 false 不进行图标响应  进行图标响应 需要自己外部对 IconImage进行侦听
		 */		
		public function set iconImageTrigger(value:Boolean):void
		{
			_iconImageTrigger=value;
		}
		/**当点击图标时候是否只响应 图标   true 表示只响应图标,   false  表示响应 全部对象Event.Change  默认为 false 不进行图标响应   进行图标响应 需要自己外部对 IconImage进行侦听
		 */		
		public function get iconImageTrigger():Boolean
		{
			return _iconImageTrigger;
		}
		/**设置 list 的 item  是否支持双击
		 */		
		public function set canDBClick(value:Boolean):void
		{
			_canDBClick=value;
		}
		/**设置list  item  是否支持双击 默认不支持
		 */		
		public function get canDBClick():Boolean
		{
			return _canDBClick;
		}


		public function get textFilters():Array
		{
			return _textFilters;
		}

		public function set textFilters(value:Array):void
		{
			_textFilters = value;
		}

		public function get isDispatchEvnet():Boolean
		{
			return _isDispatchEvnet;
		}

		public function set isDispatchEvnet(value:Boolean):void
		{
			_isDispatchEvnet = value;
		}

		public function get selectable():Boolean
		{
			return _selectable;
		}
		
		public function get selectedSp():IListRender{
			return _selectedSp;
		}
		
		/**
		 * 控制这个list可以继续被选择与否
		 * @param val 
		 */		
		public function set selectEnable(val:Boolean):void{
			_selectEnable = val;
		}
		
		/**
		 *获取或设置一个布尔值，指示列表中的项目是否对用户可以选择。 
		 * @param value
		 * 
		 */
		public function set selectable(value:Boolean):void
		{
			_selectable = value;
			_renderContainer.mouseChildren = _selectable;
		}

		/**
		 * 所有渲染器的容器实例 
		 * @return 
		 * 
		 */
		public function get renderContainer():Sprite
		{
			return _renderContainer;
		}

		/**
		 * 获取或设置从单选列表中选择的项目。 
		 * @param value
		 * 
		 */
		public function set selectedItem(value:Object):void
		{
			_selectedItem = value;
			var num:int = _renderContainer.numChildren;
			for( var i:int=0; i<num; i++ ){
				if( IListRender( _renderContainer.getChildAt( i ) ).data == value ){
					selectedIndex = i;
					break;
				}
			}
		}
		
		/**
		 * 获取或设置单选列表中的选定项目的索引;
		 * 如果赋值-1则取消选择
		 * @param value
		 * 
		 */
		public function set selectedIndex(value:int):void
		{
			if( _selectedIndex == value ) return;
			_selectedIndex = value;
			if( value < _renderContainer.numChildren && value > -1 ){
				onItemClick( null, _renderContainer.getChildAt( value ) as Sprite );
			}
			if( _selectedIndex == -1 ){
				clearSelection ();
			}
		}
		
		/**
		 * 查找某个数据的索引 
		 * @param data 要验证匹配的数据
		 * @param fieldName 如果要查找的数据是item对象的子属性，fieldName为不为空的属性名，如果为空，直接验证匹配item Object
		 * @return  查找到的位置，如果没有找到，返回-1
		 * 
		 */
		public function findDataIndex(data:*,fieldName:String=""):int
		{
			var len:int = _renderContainer.numChildren;
			for( var i:int=0; i<len; i++ ){
				var render:IListRender = _renderContainer.getChildAt( i ) as IListRender;
				if( fieldName == "" ){
					if( render && render.data == data ){
						return i;
					}
				}else{
					if( render && render.data[ fieldName ] == data ){
						return i;
					}
				}
			}
			return -1;
		}

		public function get selectedItem():Object
		{
			return _selectedItem;
		}

		public function get selectedIndex():int
		{
			return _selectedIndex;
		}
		
		/**
		 * 获取数据提供程序中的项目数。 
		 * @return 
		 * 
		 */
		public function get length():int
		{
			return _renderContainer.numChildren;
		}
		
		/**
		 * 返回滚动条的实例引用 
		 * @return 
		 * 
		 */
		public function get scrollBar():VScrollBar
		{
			return _scrollBar;
		}

		public function get itemRender():Class
		{
			return _itemRender;
		}

		/**
		 * 设置自定义渲染器的类。应该在list.addItem()之前调用此方法 
		 * @param value
		 * 
		 */
		public function set itemRender(value:Class):void
		{
			_itemRender = value;
		}
		
		/**
		 * 清除列表中当前所选的项目，并将 selectedIndex 属性设置为 -1。 
		 * 
		 */
		public function clearSelection(isDispathEvent:Boolean=false):void
		{
			if( _lastSelect ){
				_lastSelect.select = false;
			}
			_lastSelect = null;
			_selectedIndex = -1;
			_selectedItem = null;
			_selectedSp = null;
			if( isDispathEvent == true ){
				this.dispatchEvent( new Event( Event.CHANGE ) );
			}
		}
		
		/**清除所有项目的选中状态，对应多选List 
		 */		
		public function clearAllSelection():void{
			for(var i:int=0;i<this.length;i++){
				if(this.getItemRenderAt(i).select==true){
					this.getItemRenderAt(i).select=false;
				}
			}
		}
		
		/**
		 * 删除列表中的所有项目。 
		 * 
		 */
		public function removeAll():void
		{
			while( _renderContainer.numChildren > 0 ){
				var obj:Object = _renderContainer.removeChildAt( 0 );
				obj.removeEventListener( MouseEvent.CLICK, onItemClick );
				//yefeng add 移除双击
				if(_canDBClick)DBClickManager.Instance.delDBClick(obj as InteractiveObject);
				obj.dispose();
			}
			clearSelection();
			_scrollBar.scrollToPosition( 0 );
			_scrollBar.updateSize( 0 );
		}
		
		/**
		 * 向项目列表的末尾追加项目。 
		 * @param itemData 数据项，此数据项会被传递到渲染器，selectedItem同样是此对象其中的一个
		 * 
		 */
		public function addItem(itemData:Object):void
		{
			addItemAt( itemData, _renderContainer.numChildren );
		}
		
		/**  是否含有对象 itemData
		 */		
		public function containsItem(itemData:Object):Boolean
		{
			return _renderContainer.contains( itemData as DisplayObject );
		} 
		/**
		 * 在指定索引位置处将项目插入列表。 
		 * @param itemData
		 * @param index
		 * 
		 */
		public function addItemAt(itemData:Object, index:uint):void
		{
			var render:IListRender = new _itemRender() as IListRender;
			_renderContainer.addChildAt( DisplayObject( render ), index );
			render.list = this;
			render.index = index;
			render.data = itemData;
			// yefeng添加  增加双击事件
			if(_canDBClick)DBClickManager.Instance.regDBClick(render as InteractiveObject,renderDBClick);
			render.addEventListener( MouseEvent.CLICK, onItemClick );
			if( _isNeedResetRenderSize == true ){
				render.setSize( itemRenderViewWidth, render.height );
			}
			if( index == _selectedIndex ){
				onItemClick( null, render as Sprite );
			}
			UI.stage.invalidate();
			UI.stage.addEventListener( Event.RENDER, onStageRender );
		}
		/**双击回调
		 */		
		private function renderDBClick(render:IListRender):void
		{
			if(dbClickCall!=null)
			{
				if(dbClickCall.length==0)dbClickCall();
				else if(dbClickCall.length==1)dbClickCall(render.data);
			}
		}
		
		/**
		 * 移动列表的项目到指定位置 
		 * @param from 旧位置
		 * @param to 新位置
		 * 
		 */
		public function moveItemTo(from:int,to:int):void
		{
			var dis:DisplayObject = _renderContainer.getChildAt( from );
			_renderContainer.setChildIndex( dis, to );
			var sto:int = to;
			if( from < to ){
				sto -= 1;
			}
			if( _selectedIndex == from ){
				_selectedIndex = to;
			}
		}
		
		protected function get itemRenderViewWidth():int
		{
			return _compoWidth - _scrollBar.compoWidth + defaultScrollBarXAdd;
		}
		
		/**
		 * 获得某个位置的渲染器实例 
		 * @param index
		 * @return 
		 * 
		 */
		public function getItemRenderAt(index:uint):IListRender
		{
			return _renderContainer.getChildAt( index ) as IListRender;
		}
		
		/**改变单选或多选状态
		 * @param value
		 */		
		public function setMulSelectable(value:Boolean):void{
			_mulSelectable = value;
		}
		
		/**
		 * 设置选中后，再次点击是否会取消原来的选择
		 * @param value
		 */		
		public function setSelfDeselect(value:Boolean):void{
			_selfDeselect = value;
		}
		
		/**
		 * 返回指定索引处的项目的数据。 
		 * @param index
		 * @return 
		 * 
		 */
		public function getItemAt(index:uint):Object
		{
			return IListRender( _renderContainer.getChildAt( index ) ).data;
		}
		
		/**
		 * 对List/表格按照Item提供的字段排序，此方法用来实现表格中按着字段标题点击的排序 
		 * 
		 * @param fieldName 要参照的字段，与addItem中的Object字段对应。该属性的值可用于对该数组进行排序。这样的属性称为 field
		 * @param options 排序选项，如果您传递多个 fieldName 参数，则第一个字段表示主排序字段，第二个字段表示下一个排序字段，依此类推。
		 * 根据 Unicode 值排序。（ASCII 是 Unicode 的一个子集。） 
		 * 如果所比较的两个元素中均不包含 fieldName 参数中指定的字段，则认为将该字段设置为 undefined，在排序后的数组中将连续放置这些元素，不必遵循任何特定顺序。
		 * 默认情况下，sortOn() 按以下方式进行排序：
			排序区分大小写（Z 优先于 a）。
			按升序排序（a 优先于 b）。 
			修改该数组以反映排序顺序；在排序后的数组中不按任何特定顺序连续放置具有相同排序字段的多个元素。
			数值字段按字符串方式进行排序，因此 100 优先于 99，因为 "1" 的字符串值比 "9" 的低。
		 * 要传递多个标志，请使用按位 OR (|) 运算符分隔它们：
		 *  sortOn(someFieldName, Array.DESCENDING | Array.NUMERIC);
		 *  按多个字段进行排序时为每个字段指定不同的排序选项。
		 * options 参数接受排序选项的数组，以便每个排序选项对应于 fieldName 参数中的一个排序字段。
		 * 下例使用降序排序对主排序字段 a 排序，使用数字排序对第二个排序字段 b 排序，使用不区分大小写的排序对第三个排序字段 c 排序：
		 *  sortOn (["a", "b", "c"], [Array.DESCENDING, Array.NUMERIC, Array.CASEINSENSITIVE]);
		 * 
		 * 注意：fieldName 和 options 数组必须具有相同数量的元素；否则，将忽略 options 数组。
		 * 此外，Array.UNIQUESORT 和 Array.RETURNINDEXEDARRAY 选项只能用作数组中的第一个元素；否则，将忽略它们。
		 * 
		 */
		public function sortItemsOn(fieldName:Object, options:Object = null) :void
		{
			var arr:Array = [];
			var num:int = _renderContainer.numChildren;
			for( var i:int = 0; i<num; i++ ){
				arr.push( getItemAt( i ) );
			}
			arr.sortOn( fieldName, options );
			for( i=0; i<num; i++ ){
				_renderContainer.setChildIndex( DisplayObject( findRender( arr[ i ] ) ), i );
			}
			if( _selectedItem != null ){
				selectedItem = _selectedItem;
			}
		}
		
		/**
		 * 寻找渲染器 
		 * @param item
		 * @return 
		 * 
		 */
		public function findRender(item:Object):IListRender
		{
			var num:int = _renderContainer.numChildren;
			for( var i:int=0; i<num; i++ ){
				var render:IListRender = IListRender( _renderContainer.getChildAt( i ) );
				if( render.data == item ){
					return render;
				}
			}
			return null;
		}

		/**
		 * 删除指定索引位置处的项目。  
		 * @param index
		 * 
		 */
		public function removeItemAt(index:uint):void
		{
			if( index >= _renderContainer.numChildren ) return;
			var render:DisplayObject  = _renderContainer.removeChildAt( index );
			render.removeEventListener( MouseEvent.CLICK, onItemClick );
			//删除 双击事件
			if(_canDBClick)DBClickManager.Instance.delDBClick(render as InteractiveObject);
			
			IListRender( render ).dispose();
			if( _selectedIndex == index ){
				clearSelection();
			}
			UI.stage.invalidate();
			UI.stage.addEventListener( Event.RENDER, onStageRender );
		}
		
		/**
		 * 从列表中删除指定项目。 
		 * @param item
		 * @return 
		 * 
		 */
		public function removeItem(item:Object):Object
		{
			var num:int = _renderContainer.numChildren;
			for( var i:int=0; i<num; i++ ){
				if( IListRender( _renderContainer.getChildAt( i ) ).data == item ){
					removeItemAt( i );
					break;
				}
			}
			return item;
		}
		
		/**
		 * 将列表滚动至位于指定索引处的项目。 
		 * @param newCaretIndex
		 * 
		 */
		public function scrollToIndex(newCaretIndex:int):void
		{
			newCaretIndex --;
			if( newCaretIndex < 0 ) {
				newCaretIndex = 0;
			}
			var render:DisplayObject = _renderContainer.getChildAt( 0 );//得到一个任意render的高度
			if( render == null ) return;
			_scrollBar.scrollToPosition( render.height * newCaretIndex );
		}
		
		/**
		 * 将列表滚动至由 selectedIndex 属性的当前值指示的位置处的项目。 
		 * 
		 */
		public function scrollToSelected():void
		{
			if( _selectedIndex < 0 ) return;
			scrollToIndex( _selectedIndex );
		}
		
		/**
		 * 用其他项目替换指定索引位置处的项目。 此方法与updateItemAt的区别在于会重新创建一个Render对象
		 * @param item
		 * @param index
		 * @return 
		 * 
		 */
		public function replaceItemAt(item:Object, index:uint):Object
		{
			removeItemAt( index );
			addItemAt( item, index );
			return null;
		}
		
		/**
		 * 使某个渲染器更新数据 
		 * @param index
		 * @param item 新数据或者原有对象的数据(null)
		 * 
		 */
		public function updateItemAt(index:uint,item:Object=null):void
		{
			var render:IListRender = _renderContainer.getChildAt( index ) as IListRender;
			if( item ){
				render.data = item;
			}else{
				render.data = getItemAt( index );
			}
		}
		
		public function setItemSelectAt(index:uint,isSelected:Boolean):void{
			IListRender(_renderContainer.getChildAt(index)).select=isSelected;
		}
		
		/**
		 * 取消用户当前的选中项状态，返回到上一个选中的项 （取消用户选中的索引）
		 * 
		 */
		public function resetToPrevSelectIndex():void
		{
			_isDispatchEvnet = false;
			if( _lastSelectIndex != -1 )
			{
				selectedIndex = _lastSelectIndex;
			}else
			{
				clearSelection();
			}
		}
		
		protected function onItemClick(event:MouseEvent,targetSP:Sprite=null):void
		{
			_lastSelectIndex = _selectedIndex;
			var sp:Sprite;
			if( event ){
				sp = event.currentTarget as Sprite;
			}else{
				sp = targetSP;
			}
			if( sp.parent != _renderContainer ) return;
			_selectedIndex = _renderContainer.getChildIndex( sp );
			if(_lastSelect && !_mulSelectable){
				if(_selfDeselect==true && _lastSelect!=IListRender(sp)){
					_lastSelect.select = false;
				}else if(_selfDeselect==false){
					_lastSelect.select = false;
				}
			}
			if(_selfDeselect==true){
				if(IListRender(sp).select==true)	IListRender(sp).select=false;
				else if(_selectEnable==false)	return;
				else	IListRender(sp).select=true;
			}else{
				IListRender(sp).select = true;
			}
			_selectedItem = IListRender(sp).data;
			_selectedSp = IListRender(sp);
			_lastSelect = sp as IListRender;
			if( _isDispatchEvnet == true ){
//				///yefeng  添加   canDispath   判断  当点击图标 时候 不触发 Event.CHANG方法     而是响应  IconImage 方法  该方法 需要  使用者自己在外部侦听 MouseClick事件   ///在 子类 SmallMapList 有实现
				if(_iconImageTrigger)  //进行图标响应
				{
					var canDispath:Boolean=true;
					if(event)
					{
						var mytarget:IconImage=event.target as IconImage;
						//当点击的不是  IconImage时候 触发 
						if(mytarget)  canDispath=false;
					}
					if(canDispath)  //当点击的不是  IconImage时候 触发
					{
						this.dispatchEvent( new Event( Event.CHANGE ) );
					}
				}
				else  //不进行图标响应
				{
					this.dispatchEvent( new Event( Event.CHANGE ) );
				}
			}
			_isDispatchEvnet = true;
			if( event != null ){
				this.dispatchEvent( new Event( UIEvent.USER_ITEM_CLICK ) );
			}
		}
		
		/**
		 * 立即刷新Items的渲染和滚动条显示 
		 * 
		 */
		public function updateNow():void
		{
			onStageRender();
		}
		
		protected function onStageRender(event:Event=null):void
		{
			UI.stage.removeEventListener( Event.RENDER, onStageRender );
			var maxHeight:Number = Align.followVerticalOneByOne( _renderContainer );
			_scrollBar.updateSize( maxHeight );
			var num:int = _renderContainer.numChildren;
			for( var i:int=0; i<num; i++ ){
				IListRender( _renderContainer.getChildAt( i ) ).index = i;
			}
			updateItemsResize();
		}
		
		override public function targetSkin(skin:DisplayObject):void
		{
			_ui = skin as Sprite;
			_scrollBar = Xdis.getChild( _ui, "list_vScrollBar" );
			if( _scrollBar is VScrollBar == false ){
				AutoBuild.replaceAll( _ui );
				_scrollBar = Xdis.getChild( _ui, "list_vScrollBar" );
			}
			var hei:int = _scrollBar.height;
			_scrollBar.setSize( _scrollBar.compoWidth, hei * _ui.scaleY );
			_bg = Xdis.getChild( _ui, "bg" );
			resetXY( _ui );
			setSize(_ui.width,_ui.height);
			this.addChild( _scrollBar );
			this.addChildAt( _ui, 0 );
		}
		
		override public function setSize(newWidht:Number, newHeight:Number):void
		{
			super.setSize( newWidht, newHeight );
			var renderViewWidth:int = itemRenderViewWidth;
			_scrollBar.setTarget( _renderContainer, false, renderViewWidth, _compoHeight );
			_scrollBar.x = renderViewWidth;
			_scrollBar.setSize( _scrollBar.compoWidth, _compoHeight );
			resetItemSize();
			if( _bg ){
				if(_scrollBar.visible == false)
					_bg.width = _compoWidth;
				else
					_bg.width = _compoWidth-_scrollBar.compoWidth;
				_bg.height = _compoHeight;
			}	
		}
		
		public function updateItemsResize():void
		{
			resetItemSize();
		}
		
		protected function resetItemSize():void
		{
			var render:IListRender;
			var itemShowWidth:int = itemRenderViewWidth;
			if( _scrollBar.visible == false ){
				itemShowWidth = _compoWidth;
			}
			var num:int = _renderContainer.numChildren;
			for( var i:int=0; i<num; i++ ){
				render = IListRender( _renderContainer.getChildAt( i ) );
				render.setSize( itemShowWidth, render.height );
			}
		}

		public function get bg():DisplayObject
		{
			return _bg;
		}

		
	}
}