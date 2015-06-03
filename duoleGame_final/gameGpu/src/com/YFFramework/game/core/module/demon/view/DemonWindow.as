package com.YFFramework.game.core.module.demon.view
{
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.core.global.manager.DyModuleUIManager;
	import com.YFFramework.game.core.global.util.FilterConfig;
	import com.YFFramework.game.core.global.util.NoticeUtil;
	import com.YFFramework.game.core.global.view.window.WindowTittleName;
	import com.YFFramework.game.core.module.AnswerActivity.dataCenter.ActivityBasicManager;
	import com.YFFramework.game.core.module.AnswerActivity.dataCenter.ActivityDyManager;
	import com.YFFramework.game.core.module.demon.event.DemonEvent;
	import com.YFFramework.game.core.module.demon.manager.DemonManager;
	import com.YFFramework.game.core.module.raid.event.RaidEvent;
	import com.YFFramework.game.core.module.raid.manager.RaidManager;
	import com.dolo.ui.controls.Button;
	import com.dolo.ui.controls.Window;
	import com.dolo.ui.tools.Xdis;
	import com.msg.actv.CSignActivity;
	import com.msg.raid_pro.CEnterRaid;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	/**
	 * @version 1.0.0
	 * creation time：2013-10-10 上午10:31:08
	 */
	public class DemonWindow extends Window{
		
		private var _mc:MovieClip;
		private var enter_button:Button;
		public var _selectedIndex:int=0;
		private var _maxTextField:TextField;
		private var l1_button:Button;
		private var l2_button:Button;
		private var l3_button:Button;
		private var l4_button:Button;
		private var l5_button:Button;
		private var l6_button:Button;
		public static var activityType:int=3;
		public static var activityId:int=-1;
		private static var instance:DemonWindow;
		
		public function DemonWindow(){
			_mc = initByArgument(570,420,"DemonWindow",WindowTittleName.DemonTitle,true,DyModuleUIManager.demonWinBg) as MovieClip;
			setContentXY(24,27);
			
			enter_button = Xdis.getChild(_mc,"enter_button");
			enter_button.addEventListener(MouseEvent.CLICK,onEnter);
			
			l1_button = Xdis.getChild(_mc,"l1_button");
			l1_button.enabled=false;
			l2_button = Xdis.getChild(_mc,"l2_button");
			l2_button.enabled=false;
			l3_button = Xdis.getChild(_mc,"l3_button");
			l3_button.enabled=false;
			l4_button = Xdis.getChild(_mc,"l4_button");
			l4_button.enabled=false;
			l5_button = Xdis.getChild(_mc,"l5_button");
			l5_button.enabled=false;
			l6_button = Xdis.getChild(_mc,"l6_button");
			l6_button.enabled=false;
			
			_maxTextField = _mc.maxtxt;
		}
		
		public static function get Instance():DemonWindow{
			return instance ||= new DemonWindow();
		}
		
		/**更新魔族入侵面板
		 */		
		public function updateView():void{
			_mc.numtxt.text = "今天可参与次数："+ActivityDyManager.instance.getActivityTimes(activityType)+"/"
				+ActivityBasicManager.Instance.getActivityBasicVoByType(activityType).limit_times;
		}
		
		/**设定最多次数
		 * @param num
		 */		
		public function setMaxTextField(num:String):void{
			_maxTextField.text = num;
		}
		
		/**等级按钮设定
		 * @param lv
		 */		
		public function setLevelButtons(lv:int):void{
			if(lv>=30){
				l1_button.enabled=true;
				l1_button.addEventListener(MouseEvent.CLICK,onClick);
			}else{
				l1_button.enabled=false;
			}
			if(lv>=60){
				l2_button.enabled=true;
				l2_button.addEventListener(MouseEvent.CLICK,onClick);
			}else{
				l2_button.enabled=false;
			}
			if(lv>=90){
				l3_button.enabled=true;
				l3_button.addEventListener(MouseEvent.CLICK,onClick);
			}else{
				l3_button.enabled=false;
			}
			if(lv>=120){
				l4_button.enabled=true;
				l4_button.addEventListener(MouseEvent.CLICK,onClick);
			}else{
				l4_button.enabled=false;
			}
			if(lv>=150){
				l5_button.enabled=true;
				l5_button.addEventListener(MouseEvent.CLICK,onClick);
			}else{
				l5_button.enabled=false;
			}
			if(lv>=180){
				l6_button.enabled=true;
				l6_button.addEventListener(MouseEvent.CLICK,onClick);
			}else{
				l6_button.enabled=false;
			}
		}
		
		/**进入按钮点击
		 * @param e
		 */		
		private function onEnter(e:MouseEvent):void{
			if(ActivityDyManager.instance.canJoinActivity(activityType)){
				var msg:CSignActivity = new CSignActivity();
				msg.activityId = ActivityBasicManager.Instance.getActivityBasicVoByType(activityType).active_id;
				activityId = msg.activityId;
				msg.items = ActivityDyManager.instance.getComsumeItems(msg.activityId);
				YFEventCenter.Instance.dispatchEventWith(DemonEvent.SignRaidActivity,msg);
			}
			else
				NoticeUtil.setOperatorNotice("今日次数已用完，请明天再来！");
		}
		
		/**等级选择按钮点击
		 * @param e
		 */		
		private function onClick(e:MouseEvent):void{
			clearAllFilters();
			if(e.currentTarget==l1_button && l1_button.enabled==true){
				_selectedIndex=1;
				l1_button.filters = FilterConfig.Blue_Glow_Filter;
			}else if(e.currentTarget==l2_button && l2_button.enabled==true){
				_selectedIndex=2;
				l2_button.filters = FilterConfig.Blue_Glow_Filter;
			}else if(e.currentTarget==l3_button && l3_button.enabled==true){
				_selectedIndex=3;
				l3_button.filters = FilterConfig.Blue_Glow_Filter;
			}else if(e.currentTarget==l4_button && l4_button.enabled==true){
				_selectedIndex=4;
				l4_button.filters = FilterConfig.Blue_Glow_Filter;
			}else if(e.currentTarget==l5_button && l5_button.enabled==true){
				_selectedIndex=5;
				l5_button.filters = FilterConfig.Blue_Glow_Filter;
			}else if(e.currentTarget==l6_button && l6_button.enabled==true){
				_selectedIndex=6;
				l6_button.filters = FilterConfig.Blue_Glow_Filter;
			}
		}
		
		/**清除滤镜
		 */		
		private function clearAllFilters():void{
			if(l1_button.enabled==true)	l1_button.filters =null;
			if(l2_button.enabled==true) l2_button.filters =null;
			if(l3_button.enabled==true) l3_button.filters =null;
			if(l4_button.enabled==true) l4_button.filters =null;
			if(l5_button.enabled==true) l5_button.filters =null;
			if(l6_button.enabled==true) l6_button.filters =null;
		}
	}
} 