package com.YFFramework.game.core.module.notice.controller
{
	import com.YFFramework.core.center.abs.module.AbsModule;
	import com.YFFramework.core.event.YFEventCenter;
	import com.net.MsgPool;

	/**
	 * @version 1.0.0
	 * creation time：2013-8-17 下午5:11:15
	 */
	public class NoticeModule extends AbsModule{
		
		public function NoticeModule(){
		}
		
		override public function init():void{
			addEvents();
			addSocketCallback();
		}
		
		private function addEvents():void{
			//YFEventCenter.Instance.addEventListener(GlobalEvent.GameIn,onGameIn);						//进入游戏   请求坐骑列表
			
		}
		
		private function addSocketCallback():void{
			//MsgPool.addCallBack(GameCmd.SMountList,SMountList,onMountListResp);						//坐骑列表回复
		}
		
	}
} 