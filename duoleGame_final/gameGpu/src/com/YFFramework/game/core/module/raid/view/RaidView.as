package com.YFFramework.game.core.module.raid.view
{
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.utils.common.ClassInstance;
	import com.YFFramework.game.core.module.raid.event.RaidEvent;
	import com.dolo.ui.controls.Alert;
	import com.dolo.ui.events.AlertCloseEvent;
	import com.msg.raid_pro.CCloseRaid;
	import com.msg.raid_pro.CExitRaid;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	/**
	 * @version 1.0.0
	 * creation time：2013-6-26 下午3:22:17
	 */
	public class RaidView{
		
		private var _mc:MovieClip;
		private var _raidId:int;
		
		public function RaidView(raidId:int=-1){
			_raidId = raidId;
			_mc = ClassInstance.getInstance("ExitRaid");
			_mc.addEventListener(MouseEvent.CLICK,onClick);
		}
		
		public function get mc():MovieClip{
			return _mc;
		}
		
		public function dispose():void{
			_mc.timeTxt = null;
			_mc = null;
		}
		
		public function getTxt():TextField{
			return _mc.timeTxt;
		}
		
		private function onClick(e:MouseEvent):void{
			Alert.show("是否确定退出副本？","退出副本",onExitRaid,["退出","取消"]);
		}
		
		private function onExitRaid(event:AlertCloseEvent):void{
			if(event.clickButtonIndex==1){
				YFEventCenter.Instance.dispatchEventWith(RaidEvent.ExitRaidReq);
			}
		}
	}
} 