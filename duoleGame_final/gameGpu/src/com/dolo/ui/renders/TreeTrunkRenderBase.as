package com.dolo.ui.renders
{
	import com.dolo.ui.controls.DoubleDeckTree;
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
	 * 
	 * 对于默认渲染器里面有一个命名为bg的MovieClip，为item的各种划入划出效果，每帧的说明如下：
	 * 帧1:默认效果
	 * 帧2:划过效果
	 * 帧3:选中效果
	 */
	public class TreeTrunkRenderBase extends Sprite implements ITreeRender{
		
		public static var defaultWidth:Number = 150;
		public static var defaultHeight:Number = 27;
		public static var defaultRenderLinkage:String = "uiSkin.TreeTrunkRender";
		
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
		protected var _tree:DoubleDeckTree;
		protected var _isDown:Boolean;
		protected var _trunkIndex:int;
		protected var _openIconMC:MovieClip;
		
		public function TreeTrunkRenderBase(){
			
			this.addEventListener(MouseEvent.ROLL_OVER,onMouseOver);
			this.addEventListener(MouseEvent.ROLL_OUT,onMouseOut);
			this.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
			this.mouseEnabled = false;
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
			_hit = Xdis.getChild(_ui,"hit") as SimpleButton;
			if(_hit){
				_hit.useHandCursor = false;
			}
			this.addChild(_ui);
			_openIconMC = Xdis.getChild(_ui,"openIcon_mc");
			if(_openIconMC){
				_openIconMC.stop();
			}
			onLinkageComplete();
			this.addEventListener(MouseEvent.CLICK,onClick);
		}
		
		public function set open(value:Boolean):void{
			if(_openIconMC)	_openIconMC.gotoAndStop(value == true?2:1);
		}
		
		public function get trunkIndex():int{
			return _trunkIndex;
		}

		public function set trunkIndex(value:int):void{
			_trunkIndex = value;
		}

		protected function onClick(event:MouseEvent):void{
			_tree.openTrunk(_index,!_tree.isTrunkOpen(_index));
		}
		
		public function get bg():MovieClip{
			return _bg;
		}
		
		public function get renderHeight():Number{
			return _renderHeight;
		}
		
		public function set renderHeight(value:Number):void{
			_renderHeight = value;
		}
		
		public function get renderWidth():Number{
			return _renderWidth;
		}
		
		public function set renderWidth(value:Number):void{
			_renderWidth = value;
		}
		
		/**子类如果需要设置变量，添加事件覆盖此方法
		 */
		protected function onLinkageComplete():void{	
		}
		
		public function get data():Object{
			return _data;
		}
		
		/**子类需要覆盖此方法并在覆盖的方法内调用 super.data =value，或者直接覆盖updateView方法;
		 * @param value
		 */
		public function set data(value:Object):void{
			_data = value;
			updateView(_data);
		}
		
		/**显示更新数据对应的视图。子类需要覆盖此方法，item对应List.addItem(item)中的item内容
		 * @param value
		 */
		protected function updateView(item:Object):void{
			var value:Object = item;
			if(_txt && value.hasOwnProperty("label") ){
				_txt.htmlText = value.label;
			}
			if(value.hasOwnProperty("icon") && value.icon != null && _icon){
				_hasIcon = true;
				_icon.linkage = value.icon;
			}else if(_txt){
			}
		}
		
		public function set label(value:String):void{
			if(_txt  )	_txt.htmlText = value;
		}
		
		/**垃圾回收
		 */
		public function dispose():void{
			if(_icon)	_icon.clear();
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
		
		public function get nodeIndex():uint{
			return _index;
		}
		
		public function set index(value:uint):void{
			_index = value;
			if( _select == false && _isOver == false)	showDefault();
		}
		
		/**子类如果要使用自己的显示对象的话应该覆盖此方法并设置 _linkage为自己的库链接名，此链接名生成的实例对应_ui变量
		 */
		protected function resetLinkage():void{
			_linkage = defaultRenderLinkage;
		}
		
		/**子类可以覆盖show的一系列方法来自定义默认效果
		 */
		protected function showDefault():void{
			if(_bg)	_bg.gotoAndStop(1);
		}
		
		/**子类可以覆盖show的一系列方法来自定义划入划出等的效果显示 ，划过
		 */
		protected function showOver():void{
			if(_bg)	_bg.gotoAndStop(2);
		}
		
		/**子类可以覆盖show的一系列方法来自定义划入划出等的效果显示 ，按下
		 */
		protected function showDown():void{
			if(_bg)	_bg.gotoAndStop(2);
		}
		
		/**子类可以覆盖show的一系列方法来自定义划入划出等的效果显示 ，选中
		 */
		protected function showSelectOn():void{
			if(_bg)	_bg.gotoAndStop(3);
		}
		
		override public function get height():Number{
			return _renderHeight;
		}
		
		public function set list(value:List):void{
			_list = value;
		}
		
		public function set tree(value:DoubleDeckTree):void{
			_tree = value;
		}
		
		public function set select(value:Boolean):void{
			_select = value;
			_isDown = false;
			if(_select == true){
				showSelectOn()
			}else{
				index = _index;
				showDefault();
			}
		}
		
		public function get select():Boolean{
			return _select;
		}
		
		/**如果自定义需要自适应不同大小覆盖此方法 
		 * @param newWidth
		 * @param newHeight
		 */
		public function setSize(newWidth:Number,newHeight:Number):void{
			if(_hit)	_hit.scaleX = newWidth/_renderWidth;
			if(_bg)	_bg.scaleX = newWidth/_renderWidth;
		}
		
		protected function onMouseDown(event:MouseEvent):void{
			_isDown = true;
			showDown();
			this.addEventListener(MouseEvent.MOUSE_UP,onStageMouseUp);
		}
		
		protected function onStageMouseUp(event:MouseEvent):void{
			_isDown = false;
			this.removeEventListener(MouseEvent.MOUSE_UP,onStageMouseUp);
			if(_select == false)	onMouseOut();
		}
		
		protected function onMouseOut(event:MouseEvent = null):void{
			if(_isDown) return;
			_isOver = false;
			if(_select == false){
				index = _index;
				showDefault();
			}else	select = true;
		}
		
		protected function onMouseOver(event:MouseEvent):void{
			if(_isDown) return;
			_isOver = true;
			if(_select==false)	showOver();
		}
	}
}