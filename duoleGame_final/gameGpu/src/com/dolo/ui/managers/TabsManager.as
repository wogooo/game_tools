package com.dolo.ui.managers
{
	import flash.display.DisplayObject;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	/**
	 * 多Tab标签管理器 
	 * @author flashk
	 * 
	 */
	public class TabsManager extends EventDispatcher
	{
		/**
		 *  当用户点击（或程序）切换选项卡的时候抛出此事件，然后使用nowIndex获取索引
		 */
		public static const INDEX_CHANGE:String = "indexChange";
		
		
		protected var _textUpColor:uint = 0x000000;
		protected var _textOverColor:uint = 0x000000;
		protected var _textDownCloor:uint = 0x000000;
		
		protected var _isRemoveChild:Boolean = true;
		protected var _all:Array;
		protected var _allState:Array;
		/** 存储tabs所有标签的vector */
		protected var _labelTxts:Vector.<TextField>;
		protected var _nowIndex:uint;
		protected var _hand:Boolean=false;
		
		public function TabsManager(showHandCuster:Boolean = false)
		{
			_hand = showHandCuster;
			_all = [];
			_allState = [];
//			_labelTxts = new Vector.<TextField>();
		}
		
		public function get textDownCloor():uint
		{
			return _textDownCloor;
		}

		public function set textDownCloor(value:uint):void
		{
			_textDownCloor = value;
		}

		public function get textOverColor():uint
		{
			return _textOverColor;
		}

		public function set textOverColor(value:uint):void
		{
			_textOverColor = value;
		}

		public function get textUpColor():uint
		{
			return _textUpColor;
		}

		public function set textUpColor(value:uint):void
		{
			_textUpColor = value;
		}

		/**
		 * 是否在切换Tab的时候将其它显示对象从显示列表树里移除 
		 */
		public function get isRemoveChild():Boolean
		{
			return _isRemoveChild;
		}

		/**
		 * @private
		 */
		public function set isRemoveChild(value:Boolean):void
		{
			_isRemoveChild = value;
		}

		/**
		 * 获得当前打开选项卡的索引
		 * @return 
		 * 
		 */
		public function get nowIndex():uint
		{
			return _nowIndex;
		}
		
		/**
		 * 将选项卡按钮和对应的显示对象加入管理器，当单击 tabButton 时，tabView 将显示
		 * @param tabButton Flash CS 制作的SimpleButton实例
		 * @param tabView
		 * 
		 */
		public function add(tabButton:SimpleButton,tabView:DisplayObject,txt:TextField=null):void
		{
			var btn:SimpleButton = tabButton;
			_all.push([tabButton,tabView,tabView.parent]);
			_allState.push({target:btn,up:btn.upState,over:btn.overState,down:btn.downState});
			btn.addEventListener(MouseEvent.MOUSE_DOWN,onSwicthTabClick);
			btn.addEventListener(MouseEvent.ROLL_OVER,onTabBtnRollOver);
			btn.addEventListener(MouseEvent.ROLL_OUT,onTabBtnRollOut);
			btn.useHandCursor = _hand;
			if(txt){
				if(_labelTxts == null) _labelTxts=new Vector.<TextField>();
				_labelTxts.push(txt);
				txt.mouseEnabled = false;
				txt.textColor = textUpColor;
			}
		}
		
		protected function onTabBtnRollOut(event:MouseEvent):void
		{
			var btn:SimpleButton = event.currentTarget as SimpleButton;
			var index:uint = getSimpleButtonIndex(btn);
			if(_nowIndex == index+1) return;
			if(_labelTxts && _labelTxts.length>index){
				_labelTxts[index].textColor = textUpColor;
			}
		}
		
		protected function onTabBtnRollOver(event:MouseEvent):void
		{
			var btn:SimpleButton = event.currentTarget as SimpleButton;
			var index:uint = getSimpleButtonIndex(btn);
			if(_labelTxts && _labelTxts.length>index){
				_labelTxts[index].textColor = textOverColor;
			}
		}
		
		protected function onTabBtnRollDown(btn:SimpleButton):void
		{
			if(_labelTxts == null) return;
			var index:uint = getSimpleButtonIndex(btn);
			if(_labelTxts && _labelTxts.length>index){
				_labelTxts[index].textColor = textDownCloor;
			}
		}
		
		/**
		 * 初始化多个Tab 
		 * @param viewContainer 对应显示的父容器引用
		 * @param tabParentContainer tab的父容器引用
		 * @param max 个数
		 * @param viewName 对应显示的命名前缀，如果此处为空字符串""，则所以显示对象指向同个显示对象targetSameView，并且viewContainer可以为null
		 * @param tabName 对应tab的命名前缀
		 * @param startAt 从哪个个数起始
		 * @param isInitSwitchAtFirst 是否初始化完成后切换至第一个tab显示
		 * 
		 */
		public function initTabs(viewContainer:Sprite,tabParentContainerOrName:*,max:uint,viewName:String="tabView",tabName:String="tab",
								 			startAt:uint=1,isInitSwitchAtFirst:Boolean=true,targetSameView:DisplayObject=null):void
		{
			var tabParentContainer:Sprite;
			if(tabParentContainerOrName is String){
				tabParentContainer = viewContainer.getChildByName(tabParentContainerOrName) as Sprite;
			}else{
				tabParentContainer = tabParentContainerOrName as Sprite;
			}
			if(viewName != ""){
				for(var i:int=startAt;i<=max;i++){
					add(tabParentContainer.getChildByName(tabName+i) as SimpleButton,viewContainer.getChildByName(viewName+i));
				}
			}else{
				for(i=startAt;i<=max;i++){
					add(tabParentContainer.getChildByName(tabName+i) as SimpleButton,targetSameView);
				}
			}
			if(isInitSwitchAtFirst == true){
				switchToTab(1);
			}
		}
		
		/**
		 * 将某个选项卡按钮和对应的显示对象从管理器移除，并移除事件侦听
		 * @param tabButton
		 * 
		 */
		public function remove(tabButton:SimpleButton):void
		{
			tabButton.removeEventListener(MouseEvent.CLICK,onSwicthTabClick);
			tabButton.removeEventListener(MouseEvent.ROLL_OVER,onTabBtnRollOver);
			tabButton.removeEventListener(MouseEvent.ROLL_OUT,onTabBtnRollOut);
			var i:int;
			var len:int = _all.length;
			for(i=0;i<len;i++){
				if(_all[i][0] == tabButton){
					_all.splice(i,1);
					break;
				}
			}
		}
		
		/**
		 * 主动代码切换到某个选项卡,从1开始索引
		 * @param index
		 * 
		 */
		public function switchToTab(index:uint):void
		{
			if(index <1 || index > _all.length) return;
			var btn:SimpleButton;
			var max:uint = _all.length;
			if(_labelTxts && (_nowIndex-1)<_labelTxts.length && _nowIndex != 0){
				_labelTxts[_nowIndex-1].textColor = textUpColor;
			}
			_nowIndex = index;
			for(var i:int=1;i<=max;i++){
				var dis:DisplayObject = _all[i-1][1];
				dis.visible = false;
				if(isRemoveChild && dis.parent){
					dis.parent.removeChild(dis);
				}
				btn = _all[i-1][0] as SimpleButton;
				btn.upState = getStateButton(btn).up;
				btn.mouseEnabled = true;
			}
			btn = _all[index-1][0]  as SimpleButton;
			btn.mouseEnabled = false;
			btn.upState = getStateButton(btn).down;
			DisplayObject(_all[index-1][1]).visible = true;
			var sp:Sprite = _all[index-1][2] as Sprite;
			if(isRemoveChild && sp){
				sp.addChild(_all[index-1][1] as DisplayObject);
			}
			onTabBtnRollDown(btn);
			this.dispatchEvent(new Event(INDEX_CHANGE));
		}
		
		/**
		 * 清除所有引用的事件侦听，不再启用 
		 * 
		 */
		public function clear():void
		{
			var len:int = _all.length;
			for(var i:int=0;i<len;i++){
				SimpleButton(_all[i][0]).removeEventListener(MouseEvent.CLICK,onSwicthTabClick);
			}
			_all = [];
			_allState = [];
			_labelTxts = new Vector.<TextField>();
		}
		
		/**
		 * 获得某个索引的显示对象，索引从1开始 
		 * @param index
		 * @return 
		 * 
		 */
		public function getViewAt(index:uint):DisplayObject
		{
			return _all[index-1][1] as DisplayObject;
		}
		
		/**
		 * 获得某个选项卡按钮的索引， 索引从0开始 
		 * @param btn
		 * @return 
		 * 
		 */
		public function getSimpleButtonIndex(btn:SimpleButton):uint
		{
			var index:uint =0;
			var len:int = _all.length;
			for(var i:int=0;i<len;i++){
				if(_all[i][0] == btn){
					index = i;
					break;
				}
			}
			return index;
		}
		
		protected function onSwicthTabClick(event:MouseEvent):void
		{
			var btn:SimpleButton = event.currentTarget as SimpleButton;
			var index:uint = getSimpleButtonIndex(btn);
			switchToTab(index+1);
		}
		
		protected function getStateButton(btn:SimpleButton):Object
		{
			var obj:Object;
			var len:int = _allState.length;
			for(var i:int=0;i<len;i++){
				if(_allState[i].target == btn){
					obj =  _allState[i];
					break;
				}
			}
			return obj;
		}

		/** 存储tabs上标签的数组,位置从0开始，就是说赋值的时候要nowIndex-1 */
		public function set labelTxts(value:Vector.<TextField>):void
		{
			_labelTxts = value;
		}

		public function get labelTxts():Vector.<TextField>
		{
			return _labelTxts;
		}

		
	}
}