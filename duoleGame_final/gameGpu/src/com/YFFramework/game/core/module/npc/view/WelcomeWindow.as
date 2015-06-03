package com.YFFramework.game.core.module.npc.view
{
	import com.YFFramework.core.center.manager.ResizeManager;
	import com.YFFramework.core.debug.print;
	import com.YFFramework.core.net.loader.image_swf.UILoader;
	import com.YFFramework.core.proxy.StageProxy;
	import com.YFFramework.core.ui.yfComponent.PopUpManager;
	import com.YFFramework.game.core.global.DataCenter;
	import com.YFFramework.game.core.global.manager.CommonEffectURLManager;
	import com.YFFramework.game.core.module.newGuide.manager.NewGuideManager;
	import com.YFFramework.game.core.module.newGuide.view.NewGuideArrowMovie;
	import com.YFFramework.game.core.module.newGuide.view.NewGuideMovieClip;
	import com.YFFramework.game.core.module.newGuide.view.NewGuideMovieClipWidthArrow;
	import com.dolo.ui.controls.Button;
	import com.dolo.ui.controls.Panel;
	import com.dolo.ui.skin.SkinLinkages;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;

	/** 欢迎新手玩家第一次登录
	 * @author yefeng
	 * 2013 2013-7-11 上午11:14:39 
	 */
	public class WelcomeWindow extends Panel
	{
		public static  const Width:int=470;
		public static  const Height:int=235;
		private var _button:Button;
		/**新手引导箭头
		 */		
//		private var _newGuideArrow:NewGuideArrowMovie;
//		/**新手引导选中区域
//		 */		
//		private var _newGuideMovie:NewGuideMovieClip;
		

		private var _mc:MovieClip;
		
		private var _isDispose:Boolean;
		public function WelcomeWindow()
		{
			initUI();
			addEvents();
			_isDispose=false;
		}
		private function initUI():void
		{
			setSize(Width,Height);
			var loader:UILoader=new UILoader();
			loader.loadCompleteCallback=completCall;
			loader.initData(CommonEffectURLManager.WecomeFresh);
			_button=new Button();
			addChild(_button);
			_button.label="开始";
			_button.setSkinLinkage(SkinLinkages.DEFAULT_BUTTON);
			_button.x=211;
			_button.y=178;
			removeChild(_closeButton);
			initNewGuide();
			showNewGuide();
		}
		private function completCall(content:MovieClip,data:Object):void
		{
			if(!_isDispose)
			{
				_mc=content;
				addChildAt(content,0);
			}
		}
		/**
		 */		
		private function addEvents():void
		{
			addEventListener(MouseEvent.CLICK,onClick);
//			ResizeManager.Instance.regFunc(resizeIt);
			StageProxy.Instance.stage.addEventListener(Event.RESIZE,resizeIt);
			resizeIt();
		}
		private function resizeIt(e:Event=null):void
		{
			if(_mc)
			{
				_mc.x=0;
				_mc.y=0;
			}
//			x=StageProxy.Instance.getWidth()*0.5+1;
//			y=StageProxy.Instance.getHeight()*0.5+1;	
			PopUpManager.centerPopUpWidthWH(this,Width,Height);
//			StageProxy.Instance.stage.invalidate();
		}
		
		private function removeEvents():void
		{
			removeEventListener(MouseEvent.CLICK,onClick);
		}
		public function onClick(e:MouseEvent=null):void
		{
			PopUpManager.removePopUp(this);
			dispose();
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
			NewGuideMovieClipWidthArrow.Instance.initRect(_button.x+1,_button.y+1,_button.width-3,_button.height-3,NewGuideMovieClipWidthArrow.ArrowDirection_Left);
		}

		
		/**显示引导箭头
		 */		
		private function showNewGuide():void
		{
			if(DataCenter.Instance.roleSelfVo.roleDyVo.level<NewGuideManager.MaxGuideLevel)  //显示引导
			{
//				addChild(_newGuideArrow);
//				addChild(_newGuideMovie);
				NewGuideMovieClipWidthArrow.Instance.addToContainer(this);
			}
		}
		override public function dispose():void
		{
			super.dispose();
			NewGuideMovieClipWidthArrow.Instance.removeParent(this);
//			ResizeManager.Instance.delFunc(resizeIt);
			StageProxy.Instance.stage.removeEventListener(Event.RESIZE,resizeIt);
			if(_mc)	_mc.stop();
			_button=null;
			_mc=null;
			_isDispose=true;
			NewGuideManager.DoGuide();
		}
		override public function getNewGuideVo():*
		{
			return 1;
		}
		
	}
}
