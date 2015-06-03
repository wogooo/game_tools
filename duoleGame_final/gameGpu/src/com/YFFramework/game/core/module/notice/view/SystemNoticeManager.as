package com.YFFramework.game.core.module.notice.view
{
	import com.YFFramework.core.proxy.StageProxy;
	
	import flash.text.TextField;

	/**
	 * @version 1.0.0
	 * creation time：2013-8-17 下午3:38:59
	 */
	public class SystemNoticeManager extends PopupNoticeManager{
		
		public function SystemNoticeManager(){
			super();
			showTime = 3;
		}
		
		override protected function initPos():void{
			_spArea.x = (StageProxy.Instance.stage.stageWidth/2);
			_spArea.y = 200;
		}
		
	}
}