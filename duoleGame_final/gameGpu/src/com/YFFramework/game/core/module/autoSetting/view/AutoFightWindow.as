package com.YFFramework.game.core.module.autoSetting.view
{
	import com.YFFramework.core.center.manager.keyboard.KeyBoardItem;
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.game.core.global.DataCenter;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.core.global.view.window.WindowTittleName;
	import com.YFFramework.game.core.module.mapScence.events.MapScenceEvent;
	import com.YFFramework.game.core.module.mapScence.world.model.type.TypeRole;
	import com.YFFramework.game.core.module.newGuide.manager.GuaJiManager;
	import com.dolo.ui.controls.Button;
	import com.dolo.ui.controls.PopMiniWindow;
	import com.dolo.ui.controls.Window;
	import com.dolo.ui.tools.Xdis;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.ui.Keyboard;
	import flash.utils.Timer;
	
	/***
	 *倒数5秒开始挂机
	 *@author ludingchang 时间：2013-11-21 下午3:33:20
	 */
	public class AutoFightWindow extends PopMiniWindow
	{
		private var _ui:Sprite;
		private var _btn:Button;
		private var _timer:Timer;
		private var _count:int=5;

		private var _keyZ:KeyBoardItem;
		public function AutoFightWindow()
		{
			_ui=initByArgument(300,170,"autofight",WindowTittleName.titleMetion);
			_btn=Xdis.getChildAndAddClickEvent(onClick,_ui,"auto_button");
			_timer=new Timer(1000,5);
			_timer.addEventListener(TimerEvent.TIMER,onTimer);
			_timer.addEventListener(TimerEvent.TIMER_COMPLETE,onTimerComplete);
			YFEventCenter.Instance.addEventListener(GlobalEvent.EnterDifferentMap,stopTimer);
		}
		
		private function stopTimer(e:YFEvent):void
		{
			close();
		}
		
		protected function onTimerComplete(event:TimerEvent):void
		{
			onClick(null);
		}
		
		override public function open():void
		{
			super.open();
			_timer.start();
			_keyZ=new KeyBoardItem(Keyboard.Z,onKeyZ);
			update();
		}
		
		private function onKeyZ(e:KeyboardEvent):void
		{
			_keyZ.dispose();
			close();
		}
		
		private function onTimer(e:TimerEvent):void
		{
			_count--;
			update();
		}
		
		override public function update():void
		{
			_btn.label="开始挂机（"+_count+"）";
		}
		
		private function onClick(e:MouseEvent):void
		{
			GuaJiManager.Instance.start();
			close();
		}
		public override function close(event:Event=null):void
		{
			if(_timer)_timer.stop();
			super.close();
			dispose();
		}
		public override function dispose():void
		{
			super.dispose();
			_keyZ.dispose();
			_btn.removeEventListener(MouseEvent.CLICK,onClick);
			_timer.removeEventListener(TimerEvent.TIMER,update);
			_timer.removeEventListener(TimerEvent.TIMER_COMPLETE,onTimerComplete);
			YFEventCenter.Instance.removeEventListener(GlobalEvent.EnterDifferentMap,stopTimer);
			_timer=null;
			_btn=null;
			_ui=null;
		}
	}
}