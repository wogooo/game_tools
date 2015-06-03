package com.YFFramework.game.core.module.raid.view
{
	import com.YFFramework.core.center.manager.ResizeManager;
	import com.YFFramework.core.proxy.StageProxy;
	import com.YFFramework.game.core.global.TimeManager;
	import com.YFFramework.game.ui.layer.LayerManager;
	
	import flash.display.Sprite;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	import flash.utils.setTimeout;

	/**
	 * @version 1.0.0
	 * creation time：2013-6-27 上午9:36:26
	 */
	public class ExitSprite extends Sprite{
		
		private var _raidView:RaidView;
		private var _time:int;
		private var _timeId:int;
		
		public function ExitSprite(){
			super();
			this.y = 120;
			LayerManager.UILayer.addChild(this);
			ResizeManager.Instance.regFunc(resize);
			resize();
		}
		
		public function addExit(time:int):void{
			_raidView = new RaidView(-1);
			_time = time;
			_raidView.getTxt().text = TimeManager.getTimeStrFromSec(_time);
			this.addChild(_raidView.mc);
			_timeId = setInterval(countDown,1000);
		}
		
		public function removeExit():void{
			if(_raidView){
				this.removeChild(_raidView.mc);
				_raidView.dispose();
				_raidView = null;
				clearInterval(_timeId);
			}
		}
		
		private function countDown():void{
			_time--;
			if(_time<=0)	clearInterval(_timeId);
			_raidView.getTxt().text = TimeManager.getTimeStrFromSec(_time);
		}
		
		private function resize():void{
			this.x = StageProxy.Instance.viewRect.width - 300;
			this.y = 120;
		}
		
	}
} 