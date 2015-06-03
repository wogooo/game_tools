package com.YFFramework.game.core.module.chat.view
{
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.text.RichText;
	import com.YFFramework.core.ui.abs.AbsView;
	import com.YFFramework.core.utils.common.ClassInstance;
	import com.YFFramework.core.utils.net.SourceCache;
	import com.YFFramework.game.core.global.manager.CommonEffectURLManager;
	import com.YFFramework.game.ui.layer.LayerManager;
	import com.dolo.ui.managers.UI;
	import com.dolo.ui.tools.Align;
	import com.dolo.ui.tools.Xtip;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	/**表情显示类
	 */	
	public class FacesView extends AbsView{
		
		public static var frameSpeedSpace:int = 1;
		public static var max:int = 72;
		public static var linkName:String = "a";
		public static var overLinkage:String = "ChatUIFaceOver";
		public static var faceWidht:int = 24;
		public static var faceHeight:int = 24;
		public static var oneLineCount:int = 12;
		public static var faceCode:String = "&";
		
		private var _target:Object;
		private var _closeWithOut:Array;
		private var _ui:Sprite;
		private var _faces:Sprite;
		private var _overs:Sprite;
		private var _isFaceLoaded:Boolean = false;
		private var _count:int = 0;
		/**
		 */		
		private var _timer:Timer;
		
		public function FacesView(){
			
			_ui = ClassInstance.getInstance("ChatUIFacesBG");
			this.addChild(_ui);
			_faces = new Sprite();
			this.addChild(_faces);
			_faces.mouseChildren = false;
			_faces.mouseEnabled = false;
			_overs = new Sprite();
			this.addChild(_overs);
			initTimer();
			if(_isFaceLoaded == false)
			{
				SourceCache.Instance.addEventListener(CommonEffectURLManager.FaceURL,onComplete);
			}
		}
		public function get target():Object{
			return _target;
		}

		public function set target(value:Object):void{
			_target = value;
		}

		public function get closeWithOut():Array{
			return _closeWithOut;
		}
		
		//按到某些地方不会关闭faceView
		public function set closeWithOut(value:Array):void{
			_closeWithOut = value;
		}

		public function switchShowClose():void{
			if(this.parent)	close();
			else	show();
		}
		
		public function show():void
		{
			if(_isFaceLoaded == false)
			{
				SourceCache.Instance.loadRes(CommonEffectURLManager.FaceURL,null,SourceCache.ExistAllScene,null,null,false);
			}else
			{
				playAll();
			}
			LayerManager.TipsLayer.addChild(this);
			UI.stage.addEventListener(MouseEvent.MOUSE_DOWN,onStageMouseDown);
		}
		
		private function playAll():void{
//			_faces.addEventListener(Event.ENTER_FRAME,onMCEnterFrame);
			_timer.start();
		}
		
		private function initTimer():void
		{
			_timer=new Timer(30);
			_timer.addEventListener(TimerEvent.TIMER,onMCEnterFrame);
		}
		private function removeTimer():void
		{
			_timer.removeEventListener(TimerEvent.TIMER,onMCEnterFrame);
			_timer.stop()
			_timer=null;
		}
		protected function onMCEnterFrame(event:Event=null):void{
			_count++;
			if(_count<frameSpeedSpace){
				return;
			}else{
				_count = 0;
			}
			var len:int = _faces.numChildren;
			for(var i:int=0;i<len;i++){
				var mc:MovieClip = MovieClip(_faces.getChildAt(i)) ;
				if(mc){
					if(mc.currentFrame == mc.totalFrames){
						mc.gotoAndStop(1);
					}else{
						mc.nextFrame();
					}
				}
			}
		}
		
		private function stopAll():void
		{
//			_faces.removeEventListener(Event.ENTER_FRAME,onMCEnterFrame);
			_timer.stop();
		}
		
		protected function onStageMouseDown(event:MouseEvent):void{
			if(this.hitTestPoint(UI.stage.mouseX,UI.stage.mouseY)==true){
				return
			}
			if(closeWithOut){
				var len:int = closeWithOut.length;
				for(var i:int=0;i<len;i++){
					if(closeWithOut[i].hitTestPoint(UI.stage.mouseX,UI.stage.mouseY)==true){
						return
					}
				}
			}
			close();
		}
		
		private function close():void{
			UI.stage.removeEventListener(MouseEvent.MOUSE_DOWN,onStageMouseDown);
			if(this.parent){
				this.parent.removeChild(this);
				stopAll();
			}
		}
		
		private  function onComplete(e:YFEvent):void{
			SourceCache.Instance.removeEventListener(CommonEffectURLManager.FaceURL,onComplete);
			RichText.resLoadComplete = true;
			_isFaceLoaded = true;
			_ui.getChildByName("loading_mc").visible = false;
			addFaces();
		}
		
		private function addFaces():void{
			var mc:MovieClip;
			var btn:SimpleButton;
			for(var i:int=0;i<max;i++){
				mc = ClassInstance.getInstance(linkName+i);
				mc.stop();
				_faces.addChild(mc);
				btn = ClassInstance.getInstance(overLinkage);
				btn.name = "i"+i;
				btn.addEventListener(MouseEvent.CLICK,onFaceBtnClick);
				btn.useHandCursor = false;
				_overs.addChild(btn);
				if(i<10){
					Xtip.registerTip(btn,faceCode+"0"+i);
				}else{
					Xtip.registerTip(btn,faceCode+i);
				}
			}
			Align.gridAllChild(_faces,faceWidht,faceHeight,oneLineCount);
			Align.gridAllChild(_overs,faceWidht,faceHeight,oneLineCount);
			playAll();
		}
		
		protected function onFaceBtnClick(event:MouseEvent):void{
			var btn:DisplayObject = event.currentTarget as DisplayObject;
			var index:int = int(btn.name.slice(1));
			var indexStr:String;
			indexStr = String(index);
			if(index<10){
				indexStr = "0"+indexStr;
			}
			target.insertString(faceCode+indexStr);
		}
		
		override public function dispose(e:Event=null):void
		{
			super.dispose(e);
			removeTimer();
			UI.stage.removeEventListener(MouseEvent.MOUSE_DOWN,onStageMouseDown);
			_target=null;
			_closeWithOut=null;
			_ui=null;
			_faces=null;
			_overs=null;
		}
		
	}
}