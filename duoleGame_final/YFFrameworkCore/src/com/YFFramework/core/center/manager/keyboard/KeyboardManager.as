package com.YFFramework.core.center.manager.keyboard
{
	import com.YFFramework.core.proxy.StageProxy;
	
	import flash.events.IMEEvent;
	import flash.events.KeyboardEvent;
	import flash.system.IME;
	import flash.system.IMEConversionMode;
	import flash.system.System;
	import flash.ui.Keyboard;
	import flash.utils.Dictionary;

	/**  管理键盘 操作 
	 *  @author yefeng
	 *   @time:2012-4-5下午06:35:10
	 */
	internal class KeyboardManager
	{
		
		private var upDict:Dictionary;
		private var downDict:Dictionary;
		private static var _instance:KeyboardManager;
		public function KeyboardManager()
		{
			init();
			addEvents();
		}
		 public static function get Instance():KeyboardManager
		 {
			 if(!_instance) _instance=new KeyboardManager(); 
			 return _instance;
		 }
		 private function init():void
		 {
			 upDict=new Dictionary();
			 downDict=new Dictionary();
			  
			 IME.enabled=false;
		 } 
		 public function regUpKeyCode(keyCode:int,func:Function):void
		 {
			if(!upDict[keyCode]) upDict[keyCode]=new KeyboardData();
			upDict[keyCode].regFunc(func);
		 }
		 public function delUpKeyCode(keyCode:int,func:Function):void
		 {
			 if(upDict[keyCode]) upDict[keyCode].delFunc(func);
		 }
		 public function regDownKeyCode(keyCode:int,func:Function):void
		 {
			 if(!downDict[keyCode]) downDict[keyCode]=new KeyboardData();
			 downDict[keyCode].regFunc(func);
		 }
		 public function delDownKeyCode(keyCode:int,func:Function):void
		 {
			 if(downDict[keyCode]) downDict[keyCode].delFunc(func);
		 }
		 private function addEvents():void
		 {
			 StageProxy.Instance.stage.addEventListener(KeyboardEvent.KEY_DOWN,onKeyboardEventDown);
			 StageProxy.Instance.stage.addEventListener(KeyboardEvent.KEY_UP,onKeyboardEventUp);
		 }
		 private function onKeyboardEventDown(e:KeyboardEvent):void
		 {
			 var code:int=e.keyCode;
			 if(downDict[code])
			 {
				 downDict[code].trigger(e);
			 }
		 }
		 
		 private function onKeyboardEventUp(e:KeyboardEvent):void
		 {
			 
			 var code:int=e.keyCode;
			 if(upDict[code])
			 {
				 upDict[code].trigger(e);
			 }
			 
		 }
		
	}
}