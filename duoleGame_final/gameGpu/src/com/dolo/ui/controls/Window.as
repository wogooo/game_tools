package com.dolo.ui.controls
{
	import com.YFFramework.core.utils.common.ClassInstance;
	import com.YFFramework.game.core.global.view.tips.ModuleLoader;
	import com.YFFramework.game.core.global.view.window.WindowTittleName;
	import com.YFFramework.game.ui.layer.LayerManager;
	import com.dolo.ui.sets.Linkage;
	import com.dolo.ui.tools.AutoBuild;
	import com.dolo.ui.tools.LibraryCreat;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextFormat;
	
	import flashx.textLayout.elements.LinkElement;

	/**   窗口背景资源在newMainUI 界面底框目录下
	 * 游戏基础窗口 
	 * @author Administrator
	 * 
	 */
	public class Window extends Panel
	{
		public static var titleTextformat:TextFormat = new TextFormat("SimSun,Arial,Microsoft Yahei",14,0xFFFFFF,false,null,null,null,null,"center");
		public static var contentX:int = 19;
		public static var contentY:int = 40;
		public static var titleHeight:int = 45;
		public static var closeX:int = 40;
		public static var closeY:int = 2;
		
		public static const TittleBgMinWidth:int=190;// tittle背景的最小 宽度   也就是九宫格 左右两格的宽度和
		/** tittleBg  y坐标
		 */		
		//public static const TittleBgY:int=-23;// tittle背景的最小 宽度   也就是九宫格 左右两格的宽度和
		public static const TittleBgY:int=-19;// tittle背景的最小 宽度   也就是九宫格 左右两格的宽度和
//		protected var _titleText:TextField;
		protected var _background:Sprite;
		protected var _tittleBgUI:Sprite;
		/**tittle文字
		 */		
		protected var _tittleText:Bitmap;
		protected var _backgroundLink:String;
		protected var _titleBgLink:String;
		/** 动态加载的背景 */
		private var _bg:Sprite;
		private var _bgUrl:String='';
//		private var _logoSp:Sprite;
		protected var _titleYOffset:int=0;
		
		/**背景窗口皮肤id 
		 */		
		private var _backgroundBgId:int;
		/** 默认窗口背景
		 */		
		public static const DeafultBackgroundBg:int=0;
		/** 小窗口背景
		 */		
		public static const MinWindowBg:int=1;
		/** 没有背景
		 */		
		public static const NoneBg:int=2;
		
		/**弹出小窗口       用于 购买  等等窗口的背景底         
		 */
		public static const MiniPopWindowBg:int=3;
		
		
		/**小窗口UI2  没有tittle的 窗口 
		 */
		public static const MinWindowBg2:int=4;
		
		/** 新功能开启窗口
		 */
		public static const NewGuideFuncOpenWindowBg:int=5;
		
		private var _bgLoaded:Boolean=false;

		override public function dispose():void
		{
			super.dispose();
			_tittleText = null;
			_background = null;
			_tittleBgUI = null;
			_backgroundLink = null;
			_titleBgLink = null;
			_bg = null;
			_bgUrl = null;
//			_logoSp=null;
		}
		/**
		 * @param backgroundBgId  背景窗口皮肤id 
		 */		
		public function Window(backgroundBgId:int=0)
		{
			super();
			
			_backgroundBgId=backgroundBgId;
//			_compoWidth = 300;
//			_compoHeight = 200;
			
//			_titleText = new TextField();
//			_titleText.defaultTextFormat = titleTextformat;
//			_titleText.mouseEnabled = false;
//			_titleText.y = 15;
			resetBackgroundLinkage();
			resetTitleBgLinkage();
			
//			_background = LibraryCreat.getSprite(_backgroundLink);
//			this.addChildAt(_background,0);
//			_background.mouseChildren = true;
//			_background.mouseEnabled = true;
			backgroundBg=_backgroundLink;
			if(_titleBgLink!=null){
				_tittleBgUI = LibraryCreat.getSprite(_titleBgLink);
				_tittleBgUI.mouseChildren = false;
				_tittleBgUI.mouseEnabled = false;
			}
			
////			_titleText.mouseEnabled = false;
//			this.addChild(_titleText);
			
//			setSize(_compoWidth,_compoHeight);
		}
		
		/**
		 * 直接使用参数初始化窗口 
		 * 
		 * @param windowWidth 窗口宽度
		 * @param windowHeight 窗口高度
		 * @param contentLinkName 窗口内容在CS库里的链接名
		 * @param titleString 窗口标题
		 * @param isAutoBuildContent 是否在窗口初始化完成后对窗口内容使用自动UI构建
		 * @return 
		 * 
		 */
		public function initByArgument(windowWidth:int,windowHeight:int,contentLinkName:String,
									   tittleLinkage:String="",isAutoBuildContent:Boolean=true,
										bgUrl:String=''):Sprite
		{
			var tmpUI:Sprite = LibraryCreat.getSprite(contentLinkName);
			
			if(bgUrl != '')
			{
				_bg=new Sprite();
				addChild(_bg);
				_bgUrl=bgUrl;
			}
			
			content = tmpUI;
			setSize( windowWidth,windowHeight);
			if(tittleLinkage!=null)	title = tittleLinkage;
			if(isAutoBuildContent==true){
				AutoBuild.replaceAll(tmpUI);
			}
			return tmpUI;
		}
		
		public function set bgUrl(value:String):void
		{
			_bgUrl = value;
			if(_bg == null)
			{
				_bg=new Sprite();
				addChild(_bg);
			}
		}
		
		override public function open():void
		{	
			super.open();
			if(_bgUrl != ''&&_bgLoaded==false)
			{
				this.visible=false;
				_bgLoaded=true;
				ModuleLoader.instance.initLoader(_bgUrl,LayerManager.PopLayer,_bg,loadCompleteToOpen);
			}
//			else 
//			{
//				super.open();
//			}
		}
		
		private function loadCompleteToOpen():void
		{
//			super.open();
			this.visible=true;
		}
		
		protected function resetBackgroundLinkage():void
		{
			switch(_backgroundBgId)
			{
				case DeafultBackgroundBg: //默认窗口背景
					_backgroundLink = Linkage.windowBackground;
					break;
				case MinWindowBg: //小窗口背景
					_backgroundLink = Linkage.MinWindowBg;
					break;
				case NoneBg:
					_backgroundLink="";
					break;
				case MiniPopWindowBg:  //弹出小窗口
					_backgroundLink=Linkage.miniPopWindowBg;
					resetCloseLinkage();
					break;
				case MinWindowBg2:
					_backgroundLink=Linkage.MinWindow2;
					break;
				case NewGuideFuncOpenWindowBg: //新功能开启窗口s
					_backgroundLink=Linkage.NewGuideFuncOpenWindowBg;
					break;
				default:
					_backgroundLink = Linkage.windowBackground;
					break;
			}
		}
		
		protected function resetTitleBgLinkage():void
		{
			_titleBgLink = Linkage.tittleBg;
		}
		
		override protected function resetCloseLinkage():void
		{
			_closeButtonLinkage = Linkage.windowCloseButton;
			_closeButtonX=0;
			_closeButtonY=0;
		}
		/**背景窗口皮肤
		 */		
		public function set backgroundBg(linkage:String):void
		{
			if(_background)
			{
				if(_background.parent)_background.parent.removeChild(_background);
			}
			if(linkage!=""&&linkage!=null)
			{
				_background = LibraryCreat.getSprite(linkage);
				this.addChildAt(_background,0);
				_background.mouseChildren = true;
				_background.mouseEnabled = true;
				_background.width = _compoWidth;
				_background.height = _compoHeight;
			}
		}
		
		public function useOwnSkin():void
		{
			_dragArea.graphics.clear();
			if(_background){
				_background.cacheAsBitmap = false;
				if(_background.parent){
					this.removeChild(_background);
				}
			}
			if(_closeButton && _closeButton.parent){
				_closeButton.parent.removeChild(_closeButton);
			}
//			if(_titleText && _titleText.parent){
//				this.removeChild(_titleText);
//			}
			if(_tittleBgUI && _tittleBgUI.parent){
				this.removeChild(_tittleBgUI);
			}
		}

		/**
		 * 设置窗口显示内容 
		 * @param dis
		 * 
		 */
		override public function set content(dis:DisplayObject):void
		{
			super.content = dis;
			content.x = (_compoWidth - content.width)*0.5;
			content.y = contentY;
			if(_bg)
			{
				_bg.x=content.x;
				_bg.y=content.y;
//				_logoSp=new Sprite();
//				addChild(_logoSp);
			}
		}
		
		/**
		 * 设置窗口显示内容 (1.如果有外部加载的bg，这里也顺便重设了bg的x、y;2.改变窗口内容的位置，优先推荐这个方法，不要直接写content.x什么的)
		 * @param x
		 * @param y
		 */		
		public function setContentXY(x:Number,y:Number):void
		{
			content.x = x;
			content.y = y;
			if(_bg)
			{
				_bg.x=content.x;
				_bg.y=content.y;
			}
		}
		
		

		override protected function onRemoveFromStage(event:Event=null):void
		{
			super.onRemoveFromStage(event);
			if(_background)_background.cacheAsBitmap = false;
		}
		
		override protected function onAddToStage(event:Event):void
		{
			super.onAddToStage(event);
			if(_background)	_background.cacheAsBitmap = true;
		}

		public function update():void
		{
			
		}

		/**
		 * 设置窗口标题 
		 * @param value
		 * 
		 */
		public function set title(linkage:String):void
		{
			
//			_titleText.htmlText = value;
			
			if(_tittleBgUI!=null && !contains(_tittleBgUI))this.addChild(_tittleBgUI);
			
			if(!(linkage==WindowTittleName.Bag||linkage==WindowTittleName.Storage || linkage==WindowTittleName.CharacterTitle
				|| linkage==WindowTittleName.Forge || linkage==WindowTittleName.GrowTask|| linkage==WindowTittleName.Guild
				||linkage==WindowTittleName.GuildCreate||linkage==WindowTittleName.GuildInfo||linkage==WindowTittleName.GuildJX
				||linkage==WindowTittleName.GuildResetName||linkage==WindowTittleName.Auto||linkage==WindowTittleName.TeamInvite
				||linkage==WindowTittleName.RequestList||linkage==WindowTittleName.LookUp||linkage==WindowTittleName.PetTitle
				||linkage==WindowTittleName.MountTitle||linkage==WindowTittleName.TeamTitle || linkage==WindowTittleName.answerActivityTitle
				|| linkage==WindowTittleName.titleTitle || linkage==WindowTittleName.rankTitle || linkage==WindowTittleName.mallTitle
				|| linkage==WindowTittleName.shopTitle || linkage==WindowTittleName.systemTitle || linkage==WindowTittleName.marketTitle
				|| linkage==WindowTittleName.friendTitle || linkage==WindowTittleName.taskTitle || linkage==WindowTittleName.purchaseTitle
				|| linkage==WindowTittleName.consignTitle || linkage==WindowTittleName.siftTitle || linkage == WindowTittleName.mapTitle
				||linkage==WindowTittleName.imBoxTitle||linkage==WindowTittleName.speakerTitle||linkage==WindowTittleName.tradeTitle
				||linkage==WindowTittleName.titleRaidClosure||linkage==WindowTittleName.tradeReqTitle||linkage==WindowTittleName.GuildInvite || linkage==WindowTittleName.blackShopTitle
				||linkage==WindowTittleName.ActivityTitle||linkage==WindowTittleName.DemonTitle||linkage==WindowTittleName.titleMetion||linkage==WindowTittleName.titleSysReward
			    ||linkage==WindowTittleName.titleDivinePulse || linkage==WindowTittleName.titleChangeCareer)||linkage==""){
				return ;
			}
			
			
			if(_tittleText)
			{
				_tittleText.bitmapData=null;
			}
			_tittleText = new Bitmap(ClassInstance.getInstance(linkage));
//			_tittleText.mouseChildren = false;
//			_tittleText.mouseEnabled = false;
			this.addChild(_tittleText);
			_tittleText.x = (_compoWidth-_tittleText.width)*0.5;
			_tittleText.y=5-_titleYOffset;
			resetTittleBgWidth();
			_tittleBgUI.x= (_compoWidth-_tittleBgUI.width)*0.5;
//			switch(_backgroundBgId){
//				case DeafultBackgroundBg:
//					_tittleBgUI.y=0;
//					break;
//				case MiniPopWindowBg:
//					_tittleBgUI.y=15;
//					break;
//			}
		}
		/**重置tittle背景 宽度 以及坐标
		 */		
		protected function resetTittleBgWidth():void
		{
			_tittleBgUI.width=_tittleText.width+TittleBgMinWidth;
			_tittleBgUI.y=TittleBgY;
		}

		/**
		 * 重设窗口背景，内容，标题，关闭按钮位置
		 * @param newWidht
		 * @param newHeight
		 * 
		 */		
		override public function  setSize(newWidht:Number, newHeight:Number):void
		{
			super.setSize(newWidht,newHeight);
			if(_background)
			{
				_background.width = _compoWidth;
				_background.height = _compoHeight;
			}
			_dragArea.graphics.beginFill(0,0);
			_dragArea.graphics.drawRect(0,0,_compoWidth,titleHeight);
			_dragArea.graphics.endFill();
//			_dragArea.width = _compoWidth-40;
			if(_tittleBgUI)
			{
				_tittleBgUI.x = (_compoWidth-_tittleBgUI.width)*0.5;
				_tittleBgUI.y=TittleBgY
			}
//			_titleText.width = _compoWidth-50*2;
//			_titleText.x = 50;
			if(_closeButton!=null){
				_closeButton.x = _compoWidth - closeX;
				_closeButton.y = closeY;
			}
			this.graphics.clear();//这是为了把window背景覆盖上一层，为了不让点击window时穿透舞台
			this.graphics.beginFill(0,0);
			this.graphics.drawRect(0,0,_compoWidth,_compoHeight);
			this.graphics.endFill();
			if(content)
			{
				if(_background)
				{
					setContentXY((_compoWidth - content.width)*0.5,contentY);
				}
				else 
				{
					setContentXY(0,0);
				}
			}
		}

		/** 这个方法只是暂时写的，等新手引导所有ui出来后再考虑要不要删
		 * 好多地方用到
		 * @return 
		 */		
		public function get tittleBgUI():Sprite
		{
			return _tittleBgUI;
		}

		
	}
}