package com.YFFramework.game.core.global.manager
{
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.game.core.global.event.GlobalEvent;

	/**
	 * @version 1.0.0
	 * creation time：2013-6-27 下午7:32:23
	 */
	public class BagChangeManager{
		
		private static var instance:BagChangeManager;
		
		public function BagChangeManager(){
			YFEventCenter.Instance.addEventListener(GlobalEvent.BagChange,onBagChange);
		}
		
		public function regFunc(func:Function,carelist:Array):void{
			
		}
		
		private function onBagChange(e:YFEvent):void{
			
		}
		
		public static function get Instance():BagChangeManager{
			return instance ||= new BagChangeManager();
		}
	}
} 