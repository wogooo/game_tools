package com.YFFramework.game.core.module.npc.view
{
	/**@author yefeng
	 * 2013 2013-5-10 下午2:50:18 
	 */
	import com.YFFramework.core.event.ParamEvent;
	import com.YFFramework.core.proxy.StageProxy;
	import com.YFFramework.core.text.RichText;
	import com.YFFramework.core.ui.abs.AbsView;
	import com.YFFramework.core.utils.common.ClassInstance;
	import com.YFFramework.core.utils.net.SourceCache;
	import com.YFFramework.game.core.global.DataCenter;
	import com.YFFramework.game.core.global.manager.CommonEffectURLManager;
	import com.YFFramework.game.core.module.newGuide.manager.NewGuideManager;
	import com.YFFramework.game.core.module.newGuide.view.NewGuideArrowMovie;
	import com.YFFramework.game.core.module.newGuide.view.NewGuideMovieClip;
	import com.YFFramework.game.core.module.newGuide.view.NewGuideMovieClipWidthArrow;
	import com.YFFramework.game.core.module.npc.manager.Npc_ConfigBasicManager;
	import com.YFFramework.game.core.module.npc.manager.Npc_PositionBasicManager;
	import com.YFFramework.game.core.module.npc.model.Npc_ConfigBasicVo;
	import com.YFFramework.game.core.module.npc.model.Npc_PositionBasicVo;
	import com.YFFramework.game.gameConfig.URLTool;
	import com.YFFramework.game.ui.layer.LayerManager;
	import com.dolo.ui.controls.Button;
	import com.dolo.ui.controls.Panel;
	import com.dolo.ui.skin.SkinLinkages;
	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class NPCBaseWindow extends Panel
	{
		private static const NameFilter:GlowFilter=new GlowFilter(0x000000,1,6,6,2);
		private static const WindowWidth:int=762;
		private static const WindowHeight:int=270;
		
		/**npc背景图     资源 
		 */
		private static var _npcDialogBitmapData:BitmapData;
		private static const DialogBgClassName:String="npcWindow_npcDialogBg";
		/**设置对白
		 */		
		protected var _richText:RichText;
		/**物品小图标
		 */		
		private var _icon:DisplayObject;
		
		protected var bgContainer:AbsView;
		protected var _bgDialogBitmap:Bitmap;
		protected var positionVo:Npc_PositionBasicVo;
		protected var _npcBasicVo:Npc_ConfigBasicVo;
		
		/**接受任务，完成任务的 button
		 */		
		protected var _button:Button;
		/**新手引导箭头
		 */		
//		private var _newGuideArrow:NewGuideArrowMovie;
//		/**新手引导选中区域
//		 */		
//		private var _newGuideMovie:NewGuideMovieClip;
		
		private var _nameTxt:TextField;

		
		
		public function NPCBaseWindow(npcid:int)
		{
			if(npcid>0)
			{
				positionVo=Npc_PositionBasicManager.Instance.getNpc_PositionBasicVo(npcid);
				_npcBasicVo=Npc_ConfigBasicManager.Instance.getNpc_ConfigBasicVo(positionVo.basic_id);
			}
			super();
			closeTweenTime = 0;
			initUI();
			addEvents();
			setDragTarget(bgContainer);
		}
		/**初始化新手引导
		 */		
		private function initNewGuide():void
		{
//			_newGuideArrow=new NewGuideArrowMovie();
//			_newGuideArrow.x=_button.x+_button.width+50;
//			_newGuideArrow.y=_button.y+_button.height*0.5;
//			_newGuideMovie=new NewGuideMovieClip();
//			_newGuideMovie.start();
//			_newGuideMovie.initRect(_button.x+1,_button.y+1,_button.width-3,_button.height-3)
			NewGuideMovieClipWidthArrow.Instance.initRect(_button.x+1,_button.y+1,_button.width-3,_button.height-3,NewGuideMovieClipWidthArrow.ArrowDirection_Left)
		}
		/**显示引导箭头
		 */		
		public function showNewGuide():void
		{
			if(DataCenter.Instance.roleSelfVo.roleDyVo.level<NewGuideManager.MaxGuideLevel)  //显示引导
			{
//				addChild(_newGuideArrow);
//				addChild(_newGuideMovie);
				NewGuideMovieClipWidthArrow.Instance.addToContainer(this);
			}
		}
		/**隐藏引导箭头
		 */
		public function hideNewGuide():void
		{
//			if(contains(_newGuideArrow))removeChild(_newGuideArrow);
//			if(contains(_newGuideMovie))removeChild(_newGuideMovie);
			NewGuideMovieClipWidthArrow.Instance.removeParent(this);
		}
		
		protected function addEvents():void
		{
			_button.addEventListener(MouseEvent.CLICK,onButtonClick);
		}
		protected function removeEvents():void
		{
			_button.removeEventListener(MouseEvent.CLICK,onButtonClick);
			
		}
		/**给背景添加事件   子对象 调用
		 */		
		protected function addBgContainerAction():void
		{
			bgContainer.addEventListener(MouseEvent.CLICK,onBgContainerClick);
		}
		/** 移除背景事件
		 */		
		protected function removeBgContainerAction():void
		{
			bgContainer.removeEventListener(MouseEvent.CLICK,onBgContainerClick);
		}
		/**  单击背景 触发  子类 重写覆盖
		 */		
		protected function onBgContainerClick(e:MouseEvent):void
		{
			
		}
		protected function onButtonClick(e:MouseEvent=null):void
		{
			close();
		}
		
		
		protected function initUI():void
		{
			setSize(WindowWidth,WindowHeight);
			initBgContainer();
			setChildIndex(_closeButton,numChildren-1);
			_closeButton.x=WindowWidth-_closeButton.width;
			_closeButton.y=5;
			initHalfIcon();
			initRichText();
			_button=new Button();
			_button.setSkinLinkage(SkinLinkages.LONG_BUTTON);
			_button.label = "点击";
			_button.textField.y=5;
			addChild(_button);
			_button.x=645;
			_button.y=204;
			initContent();
			initNewGuide();
			initName();
		}
		private function initName():void
		{
			if(_npcBasicVo)
			{
				_nameTxt=new TextField();
				_nameTxt.mouseEnabled=false;
				_nameTxt.textColor=0xfcc51f;
				_nameTxt.autoSize="center";
				var mat:TextFormat=new TextFormat();
				mat.color=0xfcc51f;
				mat.size=20;
				_nameTxt.text=_npcBasicVo.name;
				_nameTxt.setTextFormat(mat);
				_nameTxt.filters=[NameFilter];
				addChild(_nameTxt);
				_nameTxt.x=11;
				_nameTxt.y=198;
				_nameTxt.width=160;
			}
		}
		protected function initBgContainer():void
		{
			bgContainer=new AbsView();
			addChild(bgContainer);
			_bgDialogBitmap=new Bitmap();
			bgContainer.addChild(_bgDialogBitmap);
			loadDialogBg();
		}
		
		protected function loadDialogBg():void
		{
			if(_npcDialogBitmapData)
			{
				initBgDialog();
			}
			else 
			{
				addEventListener(CommonEffectURLManager.NpcDialogUrl,onDialogComplete);
				SourceCache.Instance.loadRes(CommonEffectURLManager.NpcDialogUrl,null,SourceCache.ExistAllScene,null,{dispatcher:this},false);
			}
		}
		private function onDialogComplete(e:ParamEvent):void
		{
			var url:String=e.type;
			removeEventListener(url,onDialogComplete);
			if(_npcDialogBitmapData==null)
			{
				_npcDialogBitmapData=ClassInstance.getInstance(DialogBgClassName) as BitmapData;
				initBgDialog();
			}
		}
		/**初始化背景
		 */
		private function initBgDialog():void
		{
			if(_bgDialogBitmap)
			{
				_bgDialogBitmap.bitmapData=_npcDialogBitmapData;
			}
		}
		
		private function initRichText():void
		{
			//设置对白
			_richText=new RichText();
			addChild(_richText);
			_richText.width=486;
//			_richText.height=73;
			_richText.x=219;
			_richText.y=46;
			_richText.mouseChildren=_richText.mouseEnabled=false;
		}
		/**执行方法
		 */		
		protected function exeFunc(obj:Object):void
		{
			/// do nothing 
		}
		/**初始化半身像图标
		 */		
		private function initHalfIcon():void
		{
			var url:String=URLTool.getNPCHalfIcon(_npcBasicVo.icon_id);
//			var loader:IconLoader=new IconLoader();
//			loader.loadCompleteCallback=iconLoaded;
//			loader.initData(url);
//			var bitmapData:BitmapData=SourceCache.Instance.getRes2(url,SourceCache.ExistAllScene) as BitmapData;
			_icon=SourceCache.Instance.getRes2(url,SourceCache.ExistAllScene) as MovieClip;
			if(_icon)
			{
//				_icon=new Bitmap(bitmapData);
				addChildAt(_icon,0);
				doIconTween();
			}
			else  
			{
				addEventListener(url,iconLoadedComplete);
				SourceCache.Instance.loadRes(url,null,SourceCache.ExistAllScene,null,{dispatcher:this},false);
			}
		}
		private function iconLoadedComplete(e:ParamEvent):void
		{
			var url:String=e.type;
			removeEventListener(url,iconLoadedComplete);
			_icon=SourceCache.Instance.getRes2(url,SourceCache.ExistAllScene) as DisplayObject;
//			_icon=new Bitmap(SourceCache.Instance.getRes2(url,SourceCache.ExistAllScene) as BitmapData);
			addChildAt(_icon,0);
			doIconTween();
		}
		
//		private function iconLoaded(bitmap:DisplayObject,data:Object):void
//		{
//			_icon=bitmap;
//			addChildAt(_icon,0);
//			doIconTween();
//		}
		/** 图标滑动
		 */		
		private function doIconTween():void
		{
//			var  myX:int=222-_icon.width;
//			_icon.x=myX;
//			_icon.y=195-_icon.height;
			_icon.x=0;
			_icon.y=0;
		}
		
		/**初始化内容   子类 覆盖
		 */		
		protected function initContent():void
		{
			_richText.setText(_npcBasicVo.defaultDialog,exeFunc);

		}
		
		override public function open():void
		{
			this.mouseChildren = true;
			this.mouseEnabled = true;
			if(this.parent != null) return;
			this.scaleX = this.scaleY = 1;
			this.visible = true;
			addToWindow();
			this.alpha = 0;
			TweenLite.to(this,0.25,{alpha:1.0,ease:Cubic.easeOut});
			if(_icon)
			{
				doIconTween();
			}
		}
		override public function dispose():void
		{
			super.dispose();
			removeEvents();
			removeDragTarget(bgContainer);
//			_newGuideMovie.release();
//			_newGuideMovie=null;
			NewGuideMovieClipWidthArrow.Instance.removeParent(this);
			bgContainer=null;
			_npcBasicVo=null;
			_richText=null;
			_icon=null;
			positionVo=null;
		}
		
		private function addToWindow():void
		{
			if(!LayerManager.WindowLayer.contains(this))LayerManager.WindowLayer.addChild(this);
			onResizeWindow();
		}
		private function onResizeWindow():void
		{
			x=(StageProxy.Instance.stage.stageWidth-WindowWidth)*0.5;
			y=(StageProxy.Instance.stage.stageHeight-WindowHeight)*0.5;
		}
		override protected function onStageResize(event:Event):void
		{
			onResizeWindow();
		}
		/**
		 * 设置窗口显示内容 
		 * @param dis
		 * 
		 */
		override public function set content(dis:DisplayObject):void
		{
		}
		/**具备新手引导功能
		 */		
		override public function getNewGuideVo():*
		{
			return 1;
		}
		
	}
}