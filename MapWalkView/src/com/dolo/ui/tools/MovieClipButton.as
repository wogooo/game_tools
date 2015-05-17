package com.dolo.ui.tools
{
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import com.dolo.ui.managers.UI;
	import flash.display.Sprite;

	/**
	 * 影片剪辑按钮,需要4帧 ["first","over","down","out"]和一个命名为hit的按钮（或Sprite）
	 * @author flashk
	 * 
	 */
	public class MovieClipButton
	{
		public static var labels:Array = ["first","over","down","out"];
		public static var hitName:String = "hit";
		
		public var data:Object = {};
		
		private var _mc:MovieClip;
		private var _hit:InteractiveObject;
		protected var _enabled:Boolean;
		
		public function MovieClipButton(target:MovieClip):void
		{
			_mc = target;
			_mc.stop();
			_hit = target.getChildByName(hitName) as InteractiveObject;
			if(_hit is  SimpleButton){
				SimpleButton(_hit).useHandCursor = false;
			}
			_hit.addEventListener(MouseEvent.MOUSE_OVER,showOver);
			_hit.addEventListener(MouseEvent.MOUSE_OUT,showOut);
			_hit.addEventListener(MouseEvent.MOUSE_DOWN,showDown);
			_hit.addEventListener(MouseEvent.MOUSE_UP,showUp);
			_mc.mouseEnabled = false;
		}
		
		public function get enabled():Boolean
		{
			return _enabled;
		}
		
		/**
		 * 禁用(false)启用(true)组件 
		 * @param value
		 * 
		 */
		public function set enabled(value:Boolean):void
		{
			_enabled = value;
			if(value == true){
				_mc.filters = [];
			}else{
				_mc.filters = UI.disableFilter;
			}
			if(_hit is  SimpleButton){
				SimpleButton(_hit).mouseEnabled = value;
			}
			if(_hit is Sprite){
				Sprite(_hit).mouseChildren = value;
			}
		}
		
		public function get mc():MovieClip
		{
			return _mc;
		}
		
		public function get hit():InteractiveObject
		{
			return _hit;
		}

		public function showUp(event:MouseEvent=null):void
		{
			_mc.gotoAndPlay(labels[1]);
		}
		
		public function showDown(event:MouseEvent=null):void
		{
			_mc.gotoAndPlay(labels[2]);
		}
		
		public function showOut(event:MouseEvent=null):void
		{
			_mc.gotoAndPlay(labels[3]);
		}
		
		public function showOver(event:MouseEvent=null):void
		{
			_mc.gotoAndPlay(labels[1]);
		}
		
	}
}