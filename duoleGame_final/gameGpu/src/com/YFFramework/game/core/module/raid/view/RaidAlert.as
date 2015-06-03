package com.YFFramework.game.core.module.raid.view
{
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.game.core.global.view.window.WindowTittleName;
	import com.YFFramework.game.core.module.raid.event.RaidEvent;
	import com.dolo.ui.controls.Button;
	import com.dolo.ui.controls.PopMiniWindow;
	import com.dolo.ui.controls.Window;
	import com.dolo.ui.tools.AutoBuild;
	import com.dolo.ui.tools.Xdis;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.clearInterval;
	import flash.utils.clearTimeout;
	import flash.utils.setInterval;

	/**
	 * @version 1.0.0
	 * creation time：2013-11-22 下午3:01:40
	 */
	public class RaidAlert extends PopMiniWindow{
		
		private var leave_button:Button;
		private var _mc:MovieClip;
		private var _time:int;
		private var _timeId:uint;
		
		public function RaidAlert(){
			_mc = initByArgument(300,160,"ui.RaidAlert",WindowTittleName.titleMetion) as MovieClip;
			AutoBuild.replaceAll(_mc);
			leave_button = Xdis.getChildAndAddClickEvent(onLeave,_mc,"leave_button");
		}
		/**更新内容
		 * @param text
		 */		
		public function updateContent(text:String):void{
			clearInterval(_timeId);
			_mc.contentTxt.text = text;
			_time = 10;
			_mc.timeTxt.text = "倒计时："+_time;
			_timeId = setInterval(countDown, 1000);
		}
		/**倒计时
		 */		
		private function countDown():void{
			_time--;
			if(_time>=0){
				if(_mc)
					_mc.timeTxt.text = "倒计时："+_time;
			}else{
				clearInterval(_timeId);
				onLeave();
			}
		}
		/**离开副本
		 * @param e
		 */		
		private function onLeave(e:MouseEvent=null):void{
			close();
			YFEventCenter.Instance.dispatchEventWith(RaidEvent.ExitRaidReq);
		}
		
		override public function close(event:Event=null):void{
			super.close();
			this.dispose();
		}
		
		override public function dispose():void{
			clearInterval(_timeId);
			if(leave_button)	leave_button.removeEventListener(MouseEvent.CLICK,onLeave);
			leave_button=null;
			_mc=null;
			super.dispose();
		}
	}
} 