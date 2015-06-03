package com.YFFramework.game.core.module.demon.view
{
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.utils.common.ClassInstance;
	import com.YFFramework.game.core.global.TimeManager;
	import com.YFFramework.game.core.module.demon.manager.DemonManager;
	import com.YFFramework.game.core.module.mapScence.manager.RoleDyManager;
	import com.YFFramework.game.core.module.mapScence.world.model.RoleDyVo;
	import com.YFFramework.game.core.module.raid.event.RaidEvent;
	import com.YFFramework.game.ui.layer.LayerManager;
	import com.dolo.ui.controls.Alert;
	import com.dolo.ui.controls.Button;
	import com.dolo.ui.controls.Panel;
	import com.dolo.ui.events.AlertCloseEvent;
	import com.dolo.ui.tools.Align;
	import com.dolo.ui.tools.AutoBuild;
	import com.dolo.ui.tools.ObjectFactory;
	import com.dolo.ui.tools.Xdis;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;

	/**
	 * @version 1.0.0
	 * creation time：2013-10-12 下午2:34:49
	 */
	public class DemonMiniWindow extends Panel{
		
		private var _mc:MovieClip;
		private static var instance:DemonMiniWindow;
		private var _bg:Sprite;
		private var _timeId:uint;
		private var exit_button:Button;
		
		public function DemonMiniWindow(){
			_isResizeResetXY = false;
			_closeButton.visible = false;
			_mc = ClassInstance.getInstance("DemonMiniWindow");
			AutoBuild.replaceAll(_mc);
			content = _mc;
			
			exit_button = Xdis.getChild(_mc,"exit_button");
			exit_button.addEventListener(MouseEvent.CLICK,onExit);
			_bg = ObjectFactory.getNewSprite ("skin_minWindow");
			_bg.width=175;
			_bg.height=235;
			_bg.x = 40;
			_bg.y = 10;
			this.addChildAt(_bg,0);
			open();
			LayerManager.UILayer.addChild(this);
			Align.toRight(this,true,-255,230);
			this.visible=false;
		}
		
		/**弹出离开副本框
		 * @param e
		 */		
		private function onExit(e:MouseEvent):void{
			Alert.show("是否确定退出副本？","退出副本",onExitRaid,["退出","取消"]);
		}

		/**离开副本请求
		 * @param event
		 */		
		private function onExitRaid(event:AlertCloseEvent):void{
			if(event.clickButtonIndex==1){
				YFEventCenter.Instance.dispatchEventWith(RaidEvent.ExitRaidReq);
			}
		}
		
		/**更新波数
		 */		
		public function updateWave():void{
			if(DemonManager.current_wave<100){
				_mc.addtxt.text = "当前属性加成："+DemonManager.current_wave+"%";
			}else{
				_mc.addtxt.text = "当前属性加成：100%";
			}
			clearInterval(_timeId);
			_mc.timetxt.text = TimeManager.getTimeStrFromSec(DemonManager.next_wave_seconds,false);
			_timeId=setInterval(count,1000);
			_mc.crttxt.text = "第"+DemonManager.current_wave+"波";
			var vo:RoleDyVo = RoleDyManager.Instance.getRole(DemonManager.goddessDyId);
			if(vo)	_mc.hptxt.text = "女神雕像耐久度："+RoleDyManager.Instance.getRole(DemonManager.goddessDyId).hp;
		}
		
		/**更新女神血量
		 */		
		public function updateHp():void{
			var vo:RoleDyVo = RoleDyManager.Instance.getRole(DemonManager.goddessDyId);
			if(vo)	_mc.hptxt.text = "女神雕像耐久度："+vo.hp;
		}
		
		/**倒数器
		 */		
		private function count():void{
			DemonManager.next_wave_seconds--;
			_mc.timetxt.text = TimeManager.getTimeStrFromSec(DemonManager.next_wave_seconds,false);
			if(DemonManager.next_wave_seconds==0)	clearInterval(_timeId);
		}
		
		public static function get Instance():DemonMiniWindow{
			return instance ||= new DemonMiniWindow();
		}
	}
} 