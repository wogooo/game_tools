package com.YFFramework.game.ui.sound
{
	import com.YFFramework.core.center.manager.update.UpdateManager;
	
	import flash.display.Stage;
	import flash.events.Event;
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;

	/**
	 * 游戏全局声音控制 
	 * @author flashk
	 * 
	 */
	public class GlobalSoundControl
	{
		public static var speed:Number = 0.02;
		public static var volumeMax:Number = 1;
	
		private static var _instance:GlobalSoundControl;
		
//		private var _timer:Timer;
		private var _isMute:Boolean;
		private var _volume:Number;
		private var _isUserMute:Boolean;
		private var _isDeactivate:Boolean=false;
		
		public function GlobalSoundControl()
		{
//			_timer = new Timer(30);
//			_timer.addEventListener(TimerEvent.TIMER,onTimer);
		}
		
		public function get isUserMute():Boolean
		{
			return _isUserMute;
		}
		
		private function timeStart():void
		{
			UpdateManager.Instance.framePer.regFunc(onTimer);
		}
		
		private function timeStop():void
		{
			UpdateManager.Instance.framePer.delFunc(onTimer);
		}
		
		public function set isUserMute(value:Boolean):void
		{
			_isUserMute = value;
		}

		public function set volume(value:Number):void
		{
			_volume = value;
			SoundMixer.soundTransform = new SoundTransform(_volume);
		}

		public function get volume():Number
		{
			return _volume;
		}

		public function get isMute():Boolean
		{
			return _isMute;
		}
		
		public function startDeactivateSwitchListener(stage:Stage):void
		{
			volume = volumeMax;
//			stage.addEventListener(Event.DEACTIVATE,onStageDeactivate);
//			stage.addEventListener(Event.ACTIVATE,onStageActivate);
		}
		
		protected function onStageActivate(event:Event):void
		{
			_isDeactivate = false;
			if(_isUserMute == false){
				unMute();
			}
		}
		
		protected function onStageDeactivate(event:Event):void
		{
			_isDeactivate = true;
			mute();
		}
		
		protected function onTimer(event:Event=null):void
		{
			if(_isMute == true){
				_volume -= speed;
				if(_isDeactivate){
					_volume -= speed;
				}
				if(_volume <= 0){
					_volume = 0;
//					_timer.stop();
					timeStop();
				}
			}else{
				_volume += speed;
				if(_volume >= volumeMax){
					_volume = volumeMax;
//					_timer.stop();
					timeStop();
				}
			}
			SoundMixer.soundTransform = new SoundTransform(_volume);
		}
		
		public static function getInstance():GlobalSoundControl
		{
			if(_instance == null){
				_instance = new GlobalSoundControl();
			}
			return _instance;
		}
		
		public function mute():void
		{
			if(_isMute == false)
			{
				_isMute = true;
				startTween();
			}
		}
		
		public function unMute():void
		{
			if(_isMute)
			{
				_isMute = false;
				startTween();

			}
		}
		
		private function startTween():void
		{
			_volume = SoundMixer.soundTransform.volume;
//			_timer.start();
			timeStart();
		}
		
	}
}