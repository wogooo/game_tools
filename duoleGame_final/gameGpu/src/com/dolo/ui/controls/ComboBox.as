package com.dolo.ui.controls
{
	import com.dolo.ui.managers.UI;
	import com.dolo.ui.renders.IListRender;
	import com.dolo.ui.tools.AutoBuild;
	import com.dolo.ui.tools.LibraryCreat;
	import com.dolo.ui.tools.Xdis;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	
	/**
	 * ComboBox 组件包含一个下拉列表，用户可以从该列表中选择单个值。 其功能与 HTML 中的 SELECT 表单元素的功能相似。
	 *  ComboBox 组件可以是可编辑的，在这种情况下，用户可以在 ComboBox 组件的 TextInput 部分键入不在列表中的条目。 。
	 *
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9.0
	 *
	 * @author flashk
	 */
	public class ComboBox extends UIComponent
	{
		public static var defaultListSkinLinkage:String = "uiSkin.comBoBoxSkinList";
		public static var listItemHeight:int = 23;
		public static var listSkin:String = "";
		public static var popYLess:int = 1;
		
		protected var _ui:Sprite;
		protected var _bg:MovieClip;
		protected var _hit:SimpleButton;
		protected var _list:List;
		protected var _skinUI:Sprite;
		protected var _rowCount:int = 5;
		protected var _text:String;
		protected var _txt:TextField;
		protected var _restrict:String;
		protected var _editable:Boolean = false;
		protected var _txtX:int;
		protected var _icon:IconImage;
		protected var _rightSpace:int = 30;
		protected var _maxChars:int = 20;
		protected var _dropdownWidth:int = -1;
		protected var _isAlwaysPopAtTop:Boolean = false;
		
		override public function dispose():void
		{
			super.dispose();
			_hit.removeEventListener( MouseEvent.MOUSE_DOWN, popListMouse );
			_hit.removeEventListener( MouseEvent.MOUSE_OVER, onMouseOver );
			_hit.removeEventListener( MouseEvent.MOUSE_OUT, onMouseOut );
			_hit.removeEventListener( MouseEvent.MOUSE_DOWN, onMouseDown );
			_ui = null;
			_bg = null;
			_hit = null;
			_list = null;
			_skinUI = null;
			_text = null;
			_txt = null;
			_restrict = null;
			_icon = null;
		}
		
		public function ComboBox()
		{
			_list = new List();
			var linkName:String;
			if( listSkin != "" ){
				linkName = listSkin;
			}else{
				linkName = defaultListSkinLinkage;
			}
			listSkin = "";
			_skinUI = LibraryCreat.getSprite( linkName );
			AutoBuild.replaceAll( _skinUI );
			_list.targetSkin( _skinUI );
			_list.addEventListener( Event.CHANGE, onListChange );
			_hit = LibraryCreat.creatHitSimpleButton();
			_hit.addEventListener( MouseEvent.MOUSE_DOWN, popListMouse );
			_hit.addEventListener( MouseEvent.MOUSE_OVER, onMouseOver );
			_hit.addEventListener( MouseEvent.MOUSE_OUT, onMouseOut );
			_hit.addEventListener( MouseEvent.MOUSE_DOWN, onMouseDown );
			this.addChild( _hit );
			_list.scrollBar.isAutoHide = true;
		}
		
		public function get isAlwaysPopAtTop():Boolean
		{
			return _isAlwaysPopAtTop;
		}

		public function set isAlwaysPopAtTop(value:Boolean):void
		{
			_isAlwaysPopAtTop = value;
		}

		protected function onMouseDown(event:MouseEvent):void
		{
			if( _bg ){
				_bg.gotoAndStop( 3 );
			}
		}
		
		protected function onMouseOut(event:MouseEvent):void
		{
			if( _bg ){
				_bg.gotoAndStop( 1 );
			}
		}
		
		protected function onMouseOver(event:MouseEvent):void
		{
			if( _bg ){
				_bg.gotoAndStop( 2 );
			}
		}
		
		public function get dropdown():List
		{
			return _list;
		}
		
		public function get length():int
		{
			return _list.length;
		}
		
		public function get dropdownWidth():int
		{
			return _dropdownWidth;
		}

		/**
		 * 下拉列表的宽度，可以重新设定此值，默认为显示同等宽度 
		 * @param value
		 * 
		 */
		public function set dropdownWidth(value:int):void
		{
			_dropdownWidth = value;
		}

		public function get maxChars():int
		{
			return _maxChars;
		}

		/**
		 * 可输入的最大文字个数 
		 * @param value
		 * 
		 */
		public function set maxChars(value:int):void
		{
			_maxChars = value;
			_txt.maxChars = _maxChars;
		}

		public function get iconImage():IconImage
		{
			return _icon;
		}
		
		public function get icon():String
		{
			return _icon.linkage;
		}

		/**
		 * 设置当前选中的图标 
		 * @param value
		 * 
		 */
		public function set icon(value:String):void
		{
			if( _icon ){
				_icon.linkage = value;
			}
		}

		public function get editable():Boolean
		{
			return _editable;
		}
		
		public function set selectedIndex(value:int):void
		{
			_list.selectedIndex = value;
		}
		
		public function get selectedIndex():int
		{
			return _list.selectedIndex;
		}

		public function set editable(value:Boolean):void
		{
			_editable = value;
			if(_editable == true){
				_txt.type = TextFieldType.INPUT;
				_txt.mouseEnabled = true;
			}else{
				_txt.type = TextFieldType.DYNAMIC;
				_txt.mouseEnabled = false;
			}
			resetHit ();
		}
		
		public function get itemRender():Class
		{
			return _list.itemRender;
		}
		
		/**
		 * 设置自定义渲染器的类。应该在list.addItem()之前调用此方法 
		 * @param value
		 * 
		 */
		public function set itemRender(value:Class):void
		{
			_list.itemRender = value;
		}
		
		/**
		 * 清除列表中当前所选的项目，并将 selectedIndex 属性设置为 -1。 
		 * 
		 */
		public function clearSelection():void
		{
			_list.clearSelection();
			text = "";
			icon = "";
		}
		
		/**
		 * 返回输入框文本实例 
		 * @return 
		 * 
		 */
		public function get inputTextField():TextField
		{
			return _txt;
		}
		
		/**
		 * 返回输入框文本实例 
		 * @return 
		 * 
		 */
		public function get textField():TextField
		{
			return _txt;
		}
		
		/**
		 * 在指定索引位置处将项目插入列表。 
		 * @param itemData
		 * @param index
		 * 
		 */
		public function addItemAt(itemData:Object, index:uint):void
		{
			_list.addItemAt( itemData, index);
		}
		
		/**
		 * 获得某个位置的渲染器实例 
		 * @param index
		 * @return 
		 * 
		 */
		public function getItemRenderAt(index:uint):IListRender
		{
			return _list.getItemRenderAt( index );
		}
		
		/**
		 * 返回指定索引处的项目的数据。 
		 * @param index
		 * @return 
		 * 
		 */
		public function getItemAt(index:uint):Object
		{
			return _list.getItemAt( index );
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
			_list.sortItemsOn( fieldName, options );
		}
		
		/**
		 * 删除指定索引位置处的项目。  
		 * @param index
		 * 
		 */
		public function removeItemAt(index:uint):void
		{
			_list.removeItemAt( index );
		}
		
		/**
		 * 从列表中删除指定项目。 
		 * @param item
		 * @return 
		 * 
		 */
		public function removeItem(item:Object):Object
		{
			return _list.removeItem( item );
		}
		
		/**
		 * 将列表滚动至位于指定索引处的项目。 
		 * @param newCaretIndex
		 * 
		 */
		public function scrollToIndex(newCaretIndex:int):void
		{
			_list.scrollToIndex( newCaretIndex );
		}
		
		/**
		 * 将列表滚动至由 selectedIndex 属性的当前值指示的位置处的项目。 
		 * 
		 */
		public function scrollToSelected():void
		{
			_list.scrollToSelected();
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
			return _list.replaceItemAt( item, index);
		}
		
		/**
		 * 使某个渲染器更新数据 
		 * @param index
		 * @param item 新数据或者原有对象的数据(null)
		 * 
		 */
		public function updateItemAt(index:uint,item:Object=null):void
		{
			_list.updateItemAt( index, item );
		}
		
		/**
		 * 删除列表中的所有项目。 
		 * 
		 */
		public function removeAll():void
		{
			_list.removeAll();
		}
		
		protected function resetHit():void
		{
			if( _editable == true ){
				_hit.x = _compoWidth-_rightSpace;
				_hit.width = _rightSpace;
			}else{
				_hit.x = 0;
				_hit.width = _compoWidth;
			}
		}

		public function get restrict():String
		{
			return _restrict;
		}

		public function set restrict(value:String):void
		{
			_restrict = value;
			_txt.restrict = _restrict;
		}

		protected function onListChange(event:Event):void
		{
			removeList ();
			text = _list.selectedItem.label;
			if( _icon ){
				if( _list.selectedItem.hasOwnProperty( "icon" ) && _list.selectedItem.icon != null ){
					_icon.linkage = _list.selectedItem.icon;
					_txt.x = _txtX;
					_txt.width = _compoWidth - _rightSpace - _txt.x;
				}else{
					_txt.x = _icon.x;
					_txt.width = _compoWidth - _rightSpace - _txt.x;
				}
			}
			this.dispatchEvent( new Event( Event.CHANGE ) );
		}
		
		public function get text():String
		{
			return _text;
		}

		public function set text(value:String):void
		{
			_text = value;
			_txt.htmlText = _text;
		}
		
		public function get value():String
		{
			return _text;
		}

		public function get rowCount():int
		{
			return _rowCount;
		}

		/**
		 * 获取或设置没有滚动条的下拉列表中可显示的最大行数。 
		 * @param value
		 * 
		 */
		public function set rowCount(value:int):void
		{
			_rowCount = value;
		}
		
		public function get selectable():Boolean
		{
			return _list.selectable;
		}
		
		/**
		 *获取或设置一个布尔值，指示列表中的项目是否对用户可以选择。 
		 * @param value
		 * 
		 */
		public function set selectable(value:Boolean):void
		{
			_list.selectable = value;
		}
		
		/**
		 * 获取或设置从单选列表中选择的项目。 
		 * @param value
		 * 
		 */
		public function set selectedItem(value:Object):void
		{
			_list.selectedItem = value;
		}
		
		public function get selectedItem():Object
		{
			return _list.selectedItem;
		}
		
		override public function targetSkin(skin:DisplayObject):void
		{
			_ui = skin as Sprite;
			resetXY( _ui );
			this.addChildAt( _ui, 0 );
			_bg = Xdis.getChild( _ui, "bg" ) as MovieClip;
			if(_bg)
			{
				_bg.stop();
				if( _bg.scale9Grid ){
					_rightSpace = _bg.width -_bg.scale9Grid.right;
				}
			}
			_txt = Xdis.getChild( _ui, "label_txt" );
			_txt.mouseEnabled = false;
			_txtX = _txt.x;
			_txt.multiline = false;
			_txt.wordWrap = false;
			maxChars = _maxChars;
			_icon = Xdis.getChild( _ui, "icon_iconImage" );
			if(_icon){
				_txt.x = _icon.x;
			}
			this.addChild( _txt );
			_compoWidth = _ui.width;
			_ui.scaleX = _ui.scaleY = 1;
			setSize( _compoWidth, _compoHeight );
		}
		
		/**
		 * 立即弹出列表 
		 * 
		 */
		public function popList():void
		{
			popListMouse ();
			//_bg.visible=true;
		}
		
		protected function popListMouse(event:MouseEvent=null):void
		{
			if( _list.length == 0 ) {
				if( _list.parent ){
					_list.parent.removeChild( _list );
				}
				return;
			}
			if( _list.parent ){
				_list.parent.removeChild( _list );
				return;
			}
			var po:Point = this.localToGlobal( new Point( 0, _compoHeight ) );
			_list.x = po.x;
			_list.y = po.y;
			var popWidht:int = _compoWidth;
			var row:int = _rowCount;
			if( row > _list.length ){
				row = _list.length;
			}
			if( _dropdownWidth != -1 ){
				popWidht = _dropdownWidth;
			}
			if( _list.compoWidth != popWidht || _list.compoHeight != row*listItemHeight ){
				_list.setSize( popWidht, row*listItemHeight );
			}
			UI.topSprite.addChild( _list );
			UI.stage.addEventListener( MouseEvent.MOUSE_DOWN, removeList );
			UI.stage.addEventListener( Event.RESIZE, onStageResize );
			if( _list.y + _list.compoHeight > UI.stage.stageHeight - 20 || _isAlwaysPopAtTop == true ){
				_list.y = po.y - _compoHeight - _list.compoHeight - popYLess;
			}
		}
		
		protected function onStageResize(event:Event):void
		{
			removeList ();
		}
		
		protected function removeList(event:MouseEvent = null):void
		{
			if( event ){
				if( _list.hitTestPoint( UI.stage.mouseX, UI.stage.mouseY ) == true || this.hitTestPoint( UI.stage.mouseX, UI.stage.mouseY ) == true ){
					return;
				}
			}
			UI.stage.removeEventListener( MouseEvent.MOUSE_DOWN, removeList );
			UI.stage.removeEventListener( Event.RESIZE, onStageResize );
			if( _list.parent ){
				_list.parent.removeChild( _list );
			}
		}
		/**
		 * 向项目列表的末尾追加项目。 
		 * @param itemData 数据项，此数据项会被传递到渲染器，selectedItem同样是此对象其中的一个
		 * 
		 */
		public function addItem(itemData:Object):void
		{
			_list.addItem( itemData );
		}
		
		override public function setSize(newWidht:Number, newHeight:Number):void
		{
			super.setSize( newWidht, newHeight );
			if(_bg)
			{
				_bg.width = _compoWidth;
				_bg.height = _compoHeight;
			}		
			resetHit ();
			_hit.height = _compoHeight;
			_list.setSize( _compoWidth, _rowCount * listItemHeight );
			_txt.width = _compoWidth - _rightSpace - _txt.x;
		}

		public function get rightSpace():int
		{
			return _rightSpace;
		}

		public function set rightSpace(value:int):void
		{
			_rightSpace = value;
			resetSize();
		}

	}
}