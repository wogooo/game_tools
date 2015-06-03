package com.YFFramework.game.core.module.loginNew.view
{
	import com.YFFramework.core.center.manager.ResizeManager;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.net.loader.image_swf.UILoader;
	import com.YFFramework.core.proxy.StageProxy;
	import com.YFFramework.core.ui.abs.AbsView;
	import com.YFFramework.core.ui.yfComponent.PopUpManager;
	import com.YFFramework.core.utils.RandomName;
	import com.YFFramework.core.utils.StringUtil;
	import com.YFFramework.core.utils.common.ClassInstance;
	import com.YFFramework.game.core.global.util.FilterConfig;
	import com.YFFramework.game.core.module.loginNew.events.LoginNewEvent;
	import com.YFFramework.game.core.module.loginNew.model.RegisterDyVo;
	import com.YFFramework.game.core.module.mapScence.world.model.type.TypeRole;
	import com.YFFramework.game.gameConfig.ConfigManager;
	import com.YFFramework.game.ui.layer.LayerManager;
	import com.dolo.ui.managers.UI;
	import com.greensock.TweenLite;
	import com.greensock.easing.Back;
	import com.greensock.easing.Elastic;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	/** 注册UI
	 * @author yefeng
	 * 2013 2013-8-20 上午10:56:19 
	 */
	public class RegisterView extends AbsView
	{
		/**宽
		 */
		private static const Width:int=1250;
		/** 高
		 */		
		private static const Height:int=750;
		/**  mc 影片剪辑 
		 */
		private var _mc:MovieClip;
		
		/**UI加载完成的回调 
		 */
		public var completeUILoadComplete:Function;
		
		/**登录成功后的回调 进入主游戏
		 */
		public var loginCompleteCall:Function;
		
		
		/**服务器关闭 的回调
		 */
//		public var socketCloseCall:Function;
		
		private static var _instance:RegisterView;
		
		private var _registerDyVo:RegisterDyVo;
		/**名称是否可用
		 */		
		private var _canUse:Boolean;

		public function RegisterView()
		{
			_registerDyVo=new RegisterDyVo();
			_canUse=false;
			StageProxy.Instance.stage.addEventListener(Event.RESIZE,resize);
		}
		
		public static function get Instance():RegisterView
		{
			if(!_instance)_instance=new RegisterView();
			return _instance;
		}
		
		public function resize(e:Event=null):void
		{
			PopUpManager.centerPopUpWidthWH(RegisterView.Instance,Width,Height);
		}
		
		public function loadIt():void
		{
			var loader:UILoader=new UILoader();
			loader.loadCompleteCallback=completeCall;
			loader.initData(ConfigManager.Instance.getLoginURL());
		}
		
		/**完成后的回调
		 */
		private function completeCall(content:MovieClip,data:Object):void
		{
//			_mc=content;
//			addChild(_mc);
			_mc=ClassInstance.getInstance("createHero_RegisterUI");
			addChild(_mc);
			_mc.y=168;
			_mc.manMC.gotoAndStop(1);
			_mc.womanMC.gotoAndStop(1);
			initMC();
			
			_registerDyVo.sex=TypeRole.Sex_Man;
			onRadomName(); 
			completeUILoadComplete();				
		}
		 
		private function initMC():void
		{
			TweenLite.from(_mc.logo_mc, 1.2, {alpha:0.6, y:-65, ease:Elastic.easeOut});
			
//			TweenLite.from(_mc.logo_mc, 0.7, {y:-65, alpha: 0.5,ease:Back.easeOut});
			
//			_mc.manMC.buttonMode=true;
//			_mc.womanMC.buttonMode=true;
			StageProxy.Instance.stage.addEventListener(Event.ENTER_FRAME,onFrame);
			
		}
		private function onFrame(e:Event):void
		{
			if(_mc.currentFrame>=39) 
			{
				StageProxy.Instance.stage.removeEventListener(Event.ENTER_FRAME,onFrame);
				addMyEvents();
				setSelect(_mc.manMC); //默认为男
			}
		}
		private function onMouseEffect(e:MouseEvent):void
		{
			var target:DisplayObject=e.currentTarget as DisplayObject;
			if(target)
			{
				switch(e.type)
				{
					case MouseEvent.MOUSE_OVER:
						if(target==_mc.manButton||target==_mc.manMC||target==_mc.boyHit)  //选择 的为男 角色
						{
							if(_registerDyVo.sex==TypeRole.Sex_Woman)
							{
								MovieClip(_mc.manButton).gotoAndStop(2);
								MovieClip(_mc.manMC).gotoAndStop(2);
							}
						}
						else if(target==_mc.womanButton||target==_mc.womanMC||target==_mc.girlHit)  //选择的为 女 角色 
						{
							if(_registerDyVo.sex==TypeRole.Sex_Man)
							{
								MovieClip(_mc.womanButton).gotoAndStop(2);
								MovieClip(_mc.womanMC).gotoAndStop(2);
							}
						}
						break;
					case MouseEvent.MOUSE_OUT:
						if(target==_mc.manButton||target==_mc.manMC||target==_mc.boyHit)  //选择 的为男 角色
						{
							if(_registerDyVo.sex==TypeRole.Sex_Woman)
							{
								MovieClip(_mc.manButton).gotoAndStop(1);
								MovieClip(_mc.manMC).gotoAndStop(1);
							}
						}
						else if(target==_mc.womanButton||target==_mc.womanMC||target==_mc.girlHit)  //选择的为 女 角色 
						{
							if(_registerDyVo.sex==TypeRole.Sex_Man)
							{
								MovieClip(_mc.womanButton).gotoAndStop(1);
								MovieClip(_mc.womanMC).gotoAndStop(1);
							}
						}
						break;
				}
			}
		}
		private function addMyEvents():void
		{
			_mc.manButton.gotoAndStop(1);
			_mc.womanButton.gotoAndStop(1);
			_mc.manMC.buttonMode=true;
			_mc.womanMC.buttonMode=true;
			
			_mc.manButton.buttonMode=true;
			_mc.womanButton.buttonMode=true;
			
			_mc.manButton.addEventListener(MouseEvent.MOUSE_OVER,onMouseEffect);
			_mc.womanButton.addEventListener(MouseEvent.MOUSE_OVER,onMouseEffect);
			
			_mc.boyHit.addEventListener(MouseEvent.MOUSE_OVER,onMouseEffect);
			_mc.girlHit.addEventListener(MouseEvent.MOUSE_OVER,onMouseEffect);

 
			_mc.manMC.addEventListener(MouseEvent.MOUSE_OUT,onMouseEffect);
			_mc.womanMC.addEventListener(MouseEvent.MOUSE_OUT,onMouseEffect);

			_mc.boyHit.addEventListener(MouseEvent.MOUSE_OUT,onMouseEffect);
			_mc.girlHit.addEventListener(MouseEvent.MOUSE_OUT,onMouseEffect);

			
			_mc.manMC.addEventListener(MouseEvent.CLICK,onClick);
			_mc.womanMC.addEventListener(MouseEvent.CLICK,onClick);
			
			_mc.boyHit.addEventListener(MouseEvent.CLICK,onClick);
			_mc.girlHit.addEventListener(MouseEvent.CLICK,onClick);

			
			_mc.intobtn.addEventListener(MouseEvent.CLICK,onLogin);
			TextField(_mc.nameInput).maxChars=7;
			TextField(_mc.nameInput).addEventListener(Event.CHANGE,onTextChange);
			_mc.randomBtn.addEventListener(MouseEvent.CLICK,onRadomName);  ///随机名称
		}
		
		
		override protected  function removeEvents():void
		{
			super.removeEvents();
			if(_mc)
			{
				_mc.manMC.removeEventListener(MouseEvent.CLICK,onClick);
				_mc.womanMC.removeEventListener(MouseEvent.CLICK,onClick);
				
				
				_mc.boyHit.removeEventListener(MouseEvent.CLICK,onClick);
				_mc.girlHit.removeEventListener(MouseEvent.CLICK,onClick);

				_mc.intobtn.removeEventListener(MouseEvent.CLICK,onLogin);
				TextField(_mc.nameInput).removeEventListener(Event.CHANGE,onTextChange);
				_mc.randomBtn.removeEventListener(MouseEvent.CLICK,onRadomName);  ///随机名称
				
				
				_mc.manMC.removeEventListener(MouseEvent.MOUSE_OVER,onMouseEffect);
				_mc.womanMC.removeEventListener(MouseEvent.MOUSE_OVER,onMouseEffect);
				
				_mc.manButton.removeEventListener(MouseEvent.MOUSE_OUT,onMouseEffect);
				_mc.womanButton.removeEventListener(MouseEvent.MOUSE_OUT,onMouseEffect);
				
				_mc.boyHit.removeEventListener(MouseEvent.MOUSE_OVER,onMouseEffect);
				_mc.girlHit.removeEventListener(MouseEvent.MOUSE_OVER,onMouseEffect);

				

			}
		}
		
		private function onTextChange(e:Event=null):void
		{
			_registerDyVo.name=StringUtil.trim(_mc.nameInput.text);
			noticeCheckName(_registerDyVo.name);
		}
		
		private function noticeCheckName(name:String):void
		{
			YFEventCenter.Instance.dispatchEventWith(LoginNewEvent.C_CheckName,name);
		}

		private function onRadomName(e:MouseEvent=null):void
		{
			_mc.nameInput.text=RandomName.getName(_registerDyVo.sex);
			onTextChange();
		}

		
		private function onClick(e:MouseEvent):void
		{
			var target:DisplayObject=e.currentTarget as DisplayObject;
			var preSex:int=_registerDyVo.sex;
			switch(target)
			{
				case _mc.manMC:
				case _mc.boyHit:
					_registerDyVo.sex=TypeRole.Sex_Man;
					setSelect(_mc.manMC);
					break;
				case _mc.womanMC:
				case _mc.girlHit:
					_registerDyVo.sex=TypeRole.Sex_Woman;
					setSelect(_mc.womanMC);
					break;
			}
			if(preSex!=_registerDyVo.sex)	_mc.nameInput.text=RandomName.getName(_registerDyVo.sex);
		}
		
		private function setSelect(mc:MovieClip):void
		{
//			_mc.womanMC.filters=UI.characterFilter;
//			_mc.manMC.filters=UI.characterFilter;
//			mc.filters=[];
			
			_mc.manMC.gotoAndStop(1);
			_mc.womanMC.gotoAndStop(1);
			mc.gotoAndStop(3);
			if(mc==_mc.manMC)
			{
				_mc.manButton.gotoAndStop(3);
				_mc.womanButton.gotoAndStop(1);
			}
			else 
			{
				_mc.manButton.gotoAndStop(1);
				_mc.womanButton.gotoAndStop(3);
			}
				
		}
		
//		public function show():void 
//		{
//			LayerManager.PopLayer.addChild(this);
//			PopUpManager.centerPopUpWidthWH(this,Width,Height);
//		}
		
		
		private function sendLogin():void
		{
			_registerDyVo.name=StringUtil.trim(_mc.nameInput.text);
			YFEventCenter.Instance.dispatchEventWith(LoginNewEvent.C_CreateHero,_registerDyVo);		
		}
		private function onLogin(e:MouseEvent):void
		{
			if(_canUse)
			{
				sendLogin();
			}
			else 
			{
				updateNameCanUse(false);
			}
//			else Alert.show("名称已经存在");
		}
		
		/**检测名字是否可用
		 */		
		public function updateNameCanUse(canUse:Boolean):void
		{
			_canUse=canUse;
			_mc.errorMc.visible=!_canUse;
		}
		
		
		override public function dispose(e:Event=null):void
		{
			super.dispose(e);	
			StageProxy.Instance.stage.removeEventListener(Event.RESIZE,resize);
			if(parent)
			{
				parent.removeChild(this)
			}
			if(_mc)	_mc.stop();
			_mc=null;
			completeUILoadComplete=null;
//			socketCloseCall=null;
		}
		
		
	}
}