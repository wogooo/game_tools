package com.dolo.ui.controls
{
	import com.YFFramework.core.center.manager.update.UpdateManager;
	import com.dolo.ui.managers.UI;
	import com.dolo.ui.sets.ButtonTextStyle;
	import com.dolo.ui.tools.AutoBuild;
	import com.dolo.ui.tools.LibraryCreat;
	import com.greensock.TweenLite;
	
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;

	/**
	 * 弹出菜单 
	 * @author flashk
	 * 
	 * 示范代码：
		private function onStrengthenBtnClick(event:MouseEvent):void
		{
			if(!_menu){
				_menu = new Menu();
				_menu.addItem("跟随",onMenuItemClick);
				_menu.addSpace(Menu.creatDefautSpace());
				_menu.addItem("Test",onMenuItemClick);
				_menu.addItem("跟随跟随跟随跟随",onMenuItemClick);
				_menu.addSpace(Menu.creatDefautSpace());
				_menu.addItem("跟随",onMenuItemClick2,"flyBoot");
				_menu.addItem("跟随",onMenuItemClick2,"flyBoot");
				_menu.addItem("跟随",onMenuItemClick);
				_menu.disableItem(4);
				//可写可不写
				_menu.setSize(300,_menu.compoHeight);
			}
			_menu.show(_strengthenButton,0,33);
		}
		private function onMenuItemClick(index:uint,label:String):void
		{
			trace("onMenuItemClick",index,label);
		}
		 * 
		 * 或者
		 * 
		 private function onStrengthenBtnClick(event:MouseEvent):void
		 {
			if(!_menu){
				_menu = new Menu();
				//可写可不写
				_menu.setSkin(Menu.defaultBagckGroundLinkage,Menu.defaultMenuItemLinkage);
				_menu.initByArray(["跟随","跟随",Menu.creatDefautSpace(),"跟随","跟随跟随跟随","跟随",Menu.creatDefautSpace(),"跟随"],onMenuItemClick);
			}
			_menu.show(_strengthenButton,0,33);
		 }
		 private function onMenuItemClick(index:uint,label:String):void
		 {
			trace("onMenuItemClick",index,label);
		 }
		 * 
		 * 动态修改文字和图标
		 * 
			_menu.changeIcon(3,"smallMapNPCPic");
			_menu.changeLabel(2,"my God!!!!");
		 * 
	 * 如果菜单大小不符合要求，调用一次 _menu.setSize(300,_menu.compoHeight);
	 */
	public class Menu extends UIComponent
	{
		public static var defaultBagckGroundLinkage:String = "uiSkin.menuBG1";
		public static var defaultMenuItemLinkage:String = "uiSkin.menuItem1";
		
		public static var textMaxWidth:int = 300;
		public static var nameIcon:String = "icon_iconImage";
		public static var nameText:String = "label_txt";
		public static var nameMouseEffect:String = "mouseEffect_mc";
		
		public var withoutMouseDownClose:Array = [];
		
		protected var _bg:Sprite;
		protected var _menuItemLinkage:String;
		protected var _bagckGroundLinkage:String;
		protected var _textColor:ButtonTextStyle;
		protected var _hasInit:Boolean = false;
		protected var _scrollH:Number;
		protected var _items:Array = [];
		protected var _calls:Array = [];
		protected var _labels:Array = [];
		protected var _space:Array = [];
		protected var _args:Array = [];
		protected var _txtX:int = 15;
		protected var _iconX:int = 3;
		
		override public function dispose():void
		{
			clearAllItem();
			
			super.dispose();
			withoutMouseDownClose = null;
			_bg = null;
			_menuItemLinkage = null;
			_bagckGroundLinkage = null;
			_textColor = null;
			_items = null;
			_calls = null;
			_labels = null;
			_space = null;
			_args = null;
		}
		
		public function Menu()
		{
			super();
			_compoWidth = 0;
			_compoHeight = 0;
			setSkin( Menu.defaultBagckGroundLinkage, Menu.defaultMenuItemLinkage );
		}
		
		public function get iconX():int
		{
			return _iconX;
		}

		public function set iconX(value:int):void
		{
			_iconX = value;
		}

		public function get txtX():int
		{
			return _txtX;
		}

		public function set txtX(value:int):void
		{
			_txtX = value;
		}

		public function setSkin(bagckGroundLinkage:String,menuItemLinkage:String,textColor:ButtonTextStyle=null):void{
			_textColor = textColor;
			if( _textColor == null ){
				_textColor = new ButtonTextStyle();
				_textColor.outColor = 0xFFF0B6;
				_textColor.overColor = 0xFFFFFF;
				_textColor.downColor = 0xFFF0B6;
			}
			_menuItemLinkage = menuItemLinkage;
			_bagckGroundLinkage = bagckGroundLinkage;
		}
		
		/**获得一个默认的分隔栏 
		 * @return 
		 */
		public static function creatDefautSpace():Sprite{
			return LibraryCreat.getSprite( "uiSkin.menuSpace1" );
		}
		
		/**快速初始化菜单（不带图标），使用相同的Click处理函数 ，如 initByArray(["使用道具","丢弃",sapceSpriteRef,"取消"],myCallFunction)
		 * @param arr 包含菜单文本和space显示对象引用的数组
		 * @param itemClickCallFunction Click处理函数，具体参考addItem方法
		 */
		public function initByArray(arr:Array,itemClickCallFunction:Function):void{
			var len:int = arr.length;
			for(var i:int=0; i<len; i++){
				if(arr[i] is String)	addItem(arr[i], itemClickCallFunction);
				if(arr[i] is DisplayObject)	addSpace(arr[i]);
			}
		}
		
		/**往菜单里添加分隔栏 
		 * @param spaceDisplay 注意要为每一个spaceDisplay生成一个新的不同的显示对象，将使用此显示对象的高度作为分隔的间距
		 */
		public function addSpace(spaceDisplay:DisplayObject):void{
			spaceDisplay.y = int( _compoHeight );
			if( spaceDisplay is Sprite ){
				Sprite( spaceDisplay ).mouseChildren = false;
				Sprite( spaceDisplay ).mouseEnabled = false;
			}
			_compoHeight += spaceDisplay.height;
			_space.push( spaceDisplay );
			this.addChild( spaceDisplay );
		}
		
		/**往菜单里添加项 
		 * @param htmlLabel 菜单文本
		 * @param clickCallFunction 用户点击菜单后调用的函数，，可以对不同菜单项使用不同或者同样的函数。
		 * 会向此函数传递两个参数index（索引）和label（菜单文本），如 onMenuItemClick(index:uint,label:String),index从0开始
		 * @param iconLinkage 如果需要显示图标，传递图标在库中的链接名（如果有点符号，是完整路径名）
		 */
		public function addItem(htmlLabel:String,clickCallFunction:Function,iconLinkage:String="",...args):void
		{
			var item:Sprite = LibraryCreat.getSprite( _menuItemLinkage );
			item.mouseEnabled = false;
			var txt:TextField = TextField( item.getChildByName( nameText ) );
			if( htmlLabel == null ){
				htmlLabel = "";
			}
			txt.width = textMaxWidth;
			txt.htmlText = htmlLabel;
			txt.width = txt.textWidth + 8;
			txt.textColor = _textColor.outColor;
			txt.mouseEnabled = false;
			txt.selectable = false;
			txt.x = _txtX;
			item.addEventListener( MouseEvent.CLICK, onItemClick );
			item.addEventListener( MouseEvent.ROLL_OVER, onItemOver );
			item.addEventListener( MouseEvent.ROLL_OUT, onItemOut );
			item.addEventListener( MouseEvent.MOUSE_DOWN, onItemDown );
			_items.push( item );
			_calls.push( clickCallFunction );
			_labels.push( htmlLabel );
			_args.push( args );
			AutoBuild.replaceAll( item );
			var bg:MovieClip = item.getChildByName( nameMouseEffect ) as MovieClip;
			bg.mouseChildren = false;
			bg.mouseEnabled = false;
			bg.stop();
			item.y = int( _compoHeight ) + 1;
			var itemWidth:Number = txt.width + txt.x * 2 - 5;
			if( _compoWidth < itemWidth ){
				_compoWidth = itemWidth;
			}
			_compoHeight += item.height;
			var simpleButton:SimpleButton = new SimpleButton();
			var sh:Shape = new Shape();
			sh.graphics.beginFill( 0, 0);
			sh.graphics.drawRect( 0, 0, 100, item.height );
			sh.graphics.endFill();
			simpleButton.hitTestState = sh;
			simpleButton.upState = sh;
			simpleButton.name = "hit";
			simpleButton.useHandCursor = false;
			var icon:IconImage = item.getChildByName( nameIcon ) as IconImage;
			if( icon ){
				icon.mouseChildren = false;
				icon.mouseEnabled = false;
				icon.x = _iconX;
			}
			if( iconLinkage != "" && icon ){
				icon.linkage = iconLinkage;
			}
			item.addChildAt( simpleButton, 0 );
			this.addChild( item );
		}
		
		public function get isOpen():Boolean
		{
			return this.parent == null ? false:true;
		}
		
		/**
		 * 重置整个菜单，重新初始化。之后可以重新添加菜单项 
		 * 
		 */
		public function clearAllItem():void
		{
			var item:Sprite;
			var bg:MovieClip;
			var btn:SimpleButton;
			for( var i:int = 0; i<_items.length; i++ ){
				item = _items[ i ];
				if( item && item.parent ){
					item.parent.removeChild( item );
				}
			}
			for (i=0; i<_space.length; i++ ){
				if( _space[ i ] && DisplayObject( _space[ i ] ).parent ){
					DisplayObject( _space[ i ]).parent.removeChild( DisplayObject( _space[ i ] ))
				}
			}
			_space.length=0;
			_items.length=0;
			_labels.length=0;
			_calls.length=0;
			_args.length=0;
			_compoWidth = 0;
			_compoHeight = 0;
			_hasInit = false;
		}
		
		/**
		 * 禁止(true)/重新启用(false)某个菜单项 
		 * @param itemIndex
		 * @param isDisable
		 * 
		 */
		public function disableItem(itemIndex:uint,isDisable:Boolean = true):void
		{
			UI.setEnable( _items[ itemIndex ] as InteractiveObject,  !isDisable );
		}
		
		/**
		 * 动态修改某个菜单项的图标  
		 * @param itemIndex
		 * @param iconLinkage
		 * 
		 */
		public function changeIcon(itemIndex:uint,iconLinkage:String):void
		{
			var item:Sprite = _items[itemIndex];
			var icon:IconImage = item.getChildByName( nameIcon ) as IconImage;
			if( iconLinkage != "" && icon ){
				icon.linkage = iconLinkage;
			}
			if((iconLinkage == null  || iconLinkage == "" ) && icon){
				icon.clear();
			}
		}
		
		/**动态修改某个菜单项的文本 
		 * @param itemIndex
		 * @param label
		 */
		public function changeLabel(itemIndex:uint,label:String):void{
			var item:Sprite = _items[ itemIndex ];
			var txt:TextField = TextField(item.getChildByName(nameText));
			if( label == null )	label = "";
			txt.htmlText = label;
		}
		
		/**
		 * 立即弹出显示菜单 ，菜单显示在所以显示对象的最顶层。坐标有两种模式。坐标和某个显示对象绑定，或者和舞台绑定。
		 * 坐标和某个显示对象绑定：followTarget 传递要绑定的对象，在弹出的一瞬间，菜单和显示对象在舞台上的坐标一致。stageExcursionX，stageExcursionY为偏移
		 * 坐标和舞台绑定  followTarget 传递 null，如果不设定stageExcursionX和stageExcursionY，则弹出菜单坐标和用户当前鼠标保持一致。否则使用传递的坐标
		 * @param followTarget 菜单坐标锁定到某个对象
		 * @param stageExcursionX 菜单坐标X偏移
		 * @param stageExcursionY 菜单坐标X偏移
		 * 
		 */
		public function show(followTarget:DisplayObject=null,stageExcursionX:int=-1000,stageExcursionY:int=-1000):void{
			if( _bg == null ){
				_bg = LibraryCreat.getSprite( _bagckGroundLinkage );
				this.addChildAt( _bg, 0 );
			}
			initSize();
			UI.topSprite.addChild( this );
			UI.stage.addEventListener( MouseEvent.MOUSE_DOWN, onStageMouseDown );
			var sx:int;
			var sy:int;
			var po:Point;
			var spo:Point;
			if( followTarget ){
				var addX:int = 0;
				var addY:int = 0;
				if( stageExcursionX != -1000 ) addX = stageExcursionX;
				if( stageExcursionY != -1000 ) addY = stageExcursionY;
				po = new Point( addX, addY );
				spo = followTarget.localToGlobal( po );
				sx = spo.x;
				sy = spo.y;
			}else{
				if( stageExcursionX == -1000 && stageExcursionY == -1000 ){
					sx = UI.stage.mouseX + 1;
					sy = UI.stage.mouseY + 1;
				}else{
					sx = stageExcursionX;
					sy = stageExcursionY;
				}
			}
			if( sx +_compoWidth + 3 > UI.stage.stageWidth ) sx = UI.stage.stageWidth - _compoWidth - 3;
			if( sy + _compoHeight + 3 > UI.stage.stageHeight ) sy = UI.stage.stageHeight - _compoHeight - 3;
			if( sx < 0 ) sx = 0;
			if( sy < 0 ) sy = 0;
			this.x = sx;
			this.y = sy;
			_scrollH = 0;
			this.scrollRect = new Rectangle( 0, 0, 0, _scrollH );
			UpdateManager.Instance.framePer.regFunc(onEnterFrameAdd);
			this.alpha = 0;
			TweenLite.to( this, 0.3, { alpha: 1 } );
		}
		
		protected function onEnterFrameAdd(event:Event=null):void
		{
			_scrollH += ( _compoHeight + 5 - _scrollH ) / 3;
			if(Math.abs( _compoHeight + 5 - _scrollH ) < 1.1){
				_scrollH = _compoHeight + 5;
				UpdateManager.Instance.framePer.delFunc(onEnterFrameAdd);
			}
			this.scrollRect = new Rectangle( 0, 0, ( _compoWidth + 5 ) * _scrollH / ( _compoHeight + 5 ), _scrollH );
		}
		
		protected function onItemOver(event:MouseEvent):void
		{
			var item:Sprite = event.currentTarget as Sprite;
			var bg:MovieClip = item.getChildByName( nameMouseEffect ) as MovieClip;
			item.parent.setChildIndex( item, item.parent.numChildren - 1 );
			bg.gotoAndStop( 2 );
			var txt:TextField = TextField( item.getChildByName( nameText ) );
			txt.textColor = _textColor.overColor;
		}
		
		protected function onItemOut(event:MouseEvent):void
		{
			var item:Sprite = event.currentTarget as Sprite;
			var bg:MovieClip = item.getChildByName( nameMouseEffect ) as MovieClip;
			bg.gotoAndStop( 1 );
			var txt:TextField = TextField( item.getChildByName( nameText ) );
			txt.textColor = _textColor.outColor;
		}
		
		protected function onItemDown(event:MouseEvent):void
		{
			var item:Sprite = event.currentTarget as Sprite;
			var bg:MovieClip = item.getChildByName( nameMouseEffect ) as MovieClip;
			bg.gotoAndStop( 3 );
			var txt:TextField = TextField(item.getChildByName( nameText ));
			txt.textColor = _textColor.downColor;
		}
		
		protected function onItemClick(event:MouseEvent):void
		{
			var calls:Array;
			var item:Sprite = event.currentTarget as Sprite;
			var index:int = -1;
			if( this.parent ){
				this.parent.removeChild( this );
			}
			var len:int = _items.length;
			for( var i:int=0; i< len; i ++ ){
				if( _items[ i ] == item ){
					index = i;
					break;
				}
			}
			if( index < 0 ) return;
			var callFunction:Function = _calls[ index ];
			calls = _args[ index ].slice( 0 );
			calls.unshift( _labels[ index ] );
			calls.unshift( index );
			if( callFunction != null ){
				callFunction.apply( null, calls );
			}
		}
		
		protected function onStageMouseDown(event:MouseEvent):void
		{
			if( withoutMouseDownClose != null ){
				var len:int = withoutMouseDownClose.length;
				var dis:DisplayObject;
				for( var i:int = 0; i < len; i ++ ){
					dis = withoutMouseDownClose[ i ] as DisplayObject;
					if( dis ){
						if( dis.mouseX > 0 && dis.mouseY > 0 && dis.mouseX < dis.width && dis.mouseY < dis.height ){
							return;
						}
					}
				}
			}
			if( this.mouseX < 0 || this.mouseX > this.width || this.mouseY < 0 || this.mouseY > this.height ){
				UI.stage.removeEventListener( MouseEvent.MOUSE_DOWN, onStageMouseDown );
				if( this.parent ){
					this.parent.removeChild( this );
				}
			}
		}
		
		public function hide():void
		{
			if( this.parent ){
				this.parent.removeChild( this );
			}
		}
		
		protected function initSize():void
		{
			if( _hasInit == true ) return;
			setSize( _compoWidth, _compoHeight );
			_hasInit = true;
			_bg.width = _compoWidth;
			_bg.height = _compoHeight;
			var item:Sprite;
			var bg:MovieClip;
			var btn:SimpleButton;
			for( var i:int = 0; i<_items.length; i++ ){
				item = _items[ i ];
				bg = item.getChildByName( nameMouseEffect ) as MovieClip;
				bg.width = _compoWidth - bg.x * 2;
				btn = item.getChildByName( "hit" ) as SimpleButton;
				btn.width = _compoWidth;
			}
			for( i=0; i< _space.length; i++ ){
				DisplayObject( _space[ i ] ).width = _compoWidth;
			}
		}
		
		override public function setSize(newWidht:Number, newHeight:Number):void
		{
			super.setSize( newWidht, newHeight );
			_hasInit = false;
		}
		
	}
}