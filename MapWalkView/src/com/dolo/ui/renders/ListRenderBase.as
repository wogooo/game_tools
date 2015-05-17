package com.dolo.ui.renders
{
	import com.dolo.ui.controls.IconImage;
	import com.dolo.ui.controls.List;
	import com.dolo.ui.managers.UI;
	import com.dolo.ui.tools.AutoBuild;
	import com.dolo.ui.tools.LibraryCreat;
	import com.dolo.ui.tools.Xdis;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	/**
	 * 自定义List渲染器基类 
	 * @author flashk
	 * 
	 */
	public class ListRenderBase extends Sprite implements IListRender
	{ 
		public static var defaultWidth:Number = 150;
		public static var defaultHeight:Number = 23;
		public static var defaultRenderLinkage:String = "uiSkin.ListRender";
		
		protected var _renderWidth:Number;
		protected var _renderHeight:Number;
		protected var _linkage:String; 
		protected var _ui:Sprite;
		protected var _bg:MovieClip;
		protected var _index:int;
		protected var _isOver:Boolean;
		protected var _select:Boolean;
		protected var _txt:TextField;
		protected var _icon:IconImage;
		protected var _hasIcon:Boolean;
		protected var _hit:SimpleButton;
		protected var _data:Object;
		protected var _list:List;
		protected var _isDown:Boolean;
		
		public function ListRenderBase()
		{
			this.addEventListener(MouseEvent.ROLL_OVER,onMouseOver);
			this.addEventListener(MouseEvent.ROLL_OUT,onMouseOut);
			this.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
			_renderWidth = defaultWidth;
			_renderHeight = defaultHeight;
			resetLinkage();
			_ui = LibraryCreat.getSprite(_linkage);
			_bg = Xdis.getChild(_ui,"bg");
			if(_bg){
				_bg.mouseChildren = false;
				_bg.mouseEnabled = false;
			}
			_txt = Xdis.getChild(_ui,"label_txt");
			if(_txt){
				_txt.mouseEnabled = false;
			}
			var iconTarget:DisplayObject = Xdis.getChild(_ui,"icon_iconImage");
			if(iconTarget){
				_icon = new IconImage();
				_icon.x = int(iconTarget.x);
				_icon.y = int(iconTarget.y);
				_icon.mouseChildren = false;
				_icon.mouseEnabled = false;
				_ui.addChild(_icon);
				_ui.removeChild(iconTarget);
			}
			_hit = Xdis.getChild(_ui,"hit");
			if(_hit){
				_hit.useHandCursor = false;
			}
			this.addChild(_ui);
			onLinkageComplete();
		}
		
		public function get renderHeight():Number
		{
			return _renderHeight;
		}

		public function set renderHeight(value:Number):void
		{
			_renderHeight = value;
		}

		public function get renderWidth():Number
		{
			return _renderWidth;
		}

		public function set renderWidth(value:Number):void
		{
			_renderWidth = value;
		}

		/**
		 * 子类如果需要设置变量，添加事件覆盖此方法
		 * 
		 */
		protected function onLinkageComplete():void{
			
		}
		
		public function get data():Object
		{
			return _data;
		}
		
		/**
		 * 子类需要覆盖此方法并在覆盖的方法内调用 super.data =value，或者直接覆盖updateView方法;
		 * @param value
		 * 
		 */
		public function set data(value:Object):void
		{
			_data = value;
			updateView(_data);
		}
		
		/**
		 * 显示更新数据对应的视图。子类需要覆盖此方法，item对应List.addItem(item)中的item内容
		 * @param value
		 * 
		 */
		protected function updateView(item:Object):void
		{
			var value:Object = item;
			if(_txt && value.hasOwnProperty("label") ){
				_txt.htmlText = value.label;
			}
			if(value.hasOwnProperty("icon") && value.icon != null && _icon){
				_hasIcon = true;
				_icon.linkage = value.icon;
			}else if(_txt){
				_txt.x = _icon.x;
			}
		}
		
		/**
		 * 垃圾回收 
		 * 
		 */
		public function dispose():void
		{
			_list = null;
			_hit = null;
			_bg = null;
			_ui = null;
			_txt = null;
			_icon = null;
			while(this.numChildren>0){
				this.removeChildAt(0);
			}
		}
		
		public function set index(value:uint):void
		{
			_index = value;
			if( _select == false && _isOver == false){
				if(_index %2 == 0){
					showOutIndex1();
				}else{
					showOutIndex2();
				}
			}
		}

		/**
		 * 子类如果要使用自己的显示对象的话应该覆盖此方法并设置 _linkage为自己的库链接名，此链接名生成的实例对应_ui变量
		 * 
		 */
		protected function resetLinkage():void
		{
			_linkage = defaultRenderLinkage;
		}
		
		/**
		 * 子类可以覆盖show的一系列方法来自定义划入划出等的效果显示 ，奇数行索引（划出）
		 * 
		 */
		protected function showOutIndex1():void
		{
			if(_bg){
				_bg.gotoAndStop(1);
			}
		}
		
		/**
		 * 子类可以覆盖show的一系列方法来自定义划入划出等的效果显示  ，偶数行索引（划出）
		 * 
		 */
		protected function showOutIndex2():void
		{
			if(_bg){
				_bg.gotoAndStop(2);
			}
		}
		
		/**
		 * 子类可以覆盖show的一系列方法来自定义划入划出等的效果显示 ，划过
		 * 
		 */
		protected function showOver():void
		{
			if(_bg){
				_bg.gotoAndStop(3);
			}
		}
		
		/**
		 * 子类可以覆盖show的一系列方法来自定义划入划出等的效果显示 ，按下
		 * 
		 */
		protected function showDown():void
		{
			if(_bg){
				_bg.gotoAndStop(4);
			}
		}
		
		/**
		 * 子类可以覆盖show的一系列方法来自定义划入划出等的效果显示 ，选中
		 * 
		 */
		protected function showSelectOn():void
		{
			if(_bg){
				_bg.gotoAndStop(5);
			}
		}
		
		/**
		 * 子类可以覆盖show的一系列方法来自定义划入划出等的效果显示 ，选中划过
		 * 
		 */
		protected function showSelectOver():void
		{
			if(_bg){
				_bg.gotoAndStop(6);
			}
		}
		
		
		/**
		 * 子类可以覆盖show的一系列方法来自定义划入划出等的效果显示 ，选中划过
		 * 
		 */
		protected function showSelectDown():void
		{
			if(_bg){
				_bg.gotoAndStop(7);
			}
		}
		
		override public function get height():Number
		{
			return _renderHeight;
		}
		
		public function set list(value:List):void
		{
			_list = value;
		}
		
		public function set select(value:Boolean):void
		{
			_select = value;
			_isDown = false;
			if(_select == true){
				showSelectOn()
			}else{
				index = _index;
			}
		}
		
		/**
		 * 如果自定义需要自适应不同大小覆盖此方法 
		 * @param newWidth
		 * @param newHeight
		 * 
		 */
		public function setSize(newWidth:Number,newHeight:Number):void
		{
			if(_hit){
				_hit.scaleX = newWidth/_renderWidth;
			}
			if(_bg){
				_bg.scaleX = newWidth/_renderWidth;
			}
		}
		
		protected function onMouseDown(event:MouseEvent):void
		{
			_isDown = true;
			if(_select == false){
				showDown();
			}else{
				showSelectDown();
			}
			UI.stage.addEventListener(MouseEvent.MOUSE_UP,onStageMouseUp);
		}
		
		protected function onStageMouseUp(event:MouseEvent):void
		{
			_isDown = false;
			UI.stage.removeEventListener(MouseEvent.MOUSE_UP,onStageMouseUp);
			if(_select == false)
			{
				onMouseOut();
			}
		}
		
		protected function onMouseOut(event:MouseEvent = null):void
		{
			if(_isDown) return;
			_isOver = false;
			if(_select == false){
				index = _index;
			}else{
				select = true;
			}
		}
		
		protected function onMouseOver(event:MouseEvent):void
		{
			if(_isDown) return;
			_isOver = true;
			if(_select == false){
				showOver();
			}else{
				showSelectOver();
			}
		}
		
	}
}