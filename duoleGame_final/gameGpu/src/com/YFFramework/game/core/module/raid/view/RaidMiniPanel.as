package com.YFFramework.game.core.module.raid.view
{
	import com.YFFramework.core.utils.common.ClassInstance;
	import com.YFFramework.game.core.global.TimeManager;
	import com.YFFramework.game.core.global.util.TimerDispather;
	import com.YFFramework.game.core.global.util.TimerDispatherEvent;
	import com.YFFramework.game.core.module.raid.manager.RaidDyManager;
	import com.YFFramework.game.core.module.raid.manager.RaidManager;
	import com.YFFramework.game.core.module.raid.model.RaidVo;
	import com.YFFramework.game.ui.layer.LayerManager;
	import com.dolo.ui.controls.Panel;
	import com.dolo.ui.managers.UI;
	import com.dolo.ui.tools.Align;
	import com.dolo.ui.tools.AutoBuild;
	import com.dolo.ui.tools.HTMLFormat;
	import com.dolo.ui.tools.Xdis;
	import com.dolo.ui.tools.Xtip;
	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;
	import com.netease.protobuf.stringToByteArray;
	
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	import flash.utils.setTimeout;
	
	import org.osmf.elements.HTMLElement;

	/**
	 * 副本引导<br>
	 * 在界面右边，任务引导边上
	 * @version 1.0.0
	 * creation time：2013-11-21 下午1:31:25
	 */
	public class RaidMiniPanel extends Panel{
		
		private static var instance:RaidMiniPanel;
		private var _ui:Sprite;
		private var _dragBtn:SimpleButton;
		private var _miniBtn:SimpleButton;
		public var _isMiniNow:Boolean = false;
		private var _openBtnSprite:Sprite;
		/**副本名称*/
		private var _raidNameTxt:TextField;
		/**副本总时间*/
		private var _contentTxt:TextField;
		
		public function RaidMiniPanel(){
			_isResizeResetXY = false;
			_closeButton.visible = false;
			_ui = ClassInstance.getInstance("RaidMiniPanelUI");
		
			AutoBuild.replaceAll(_ui);
			content = _ui;
			_dragBtn = Xdis.getChild(_ui,"drag_btn");
			setDragTarget(_dragBtn);
			_miniBtn = Xdis.getChild(_ui,"mini_btn");
			_miniBtn.addEventListener(MouseEvent.CLICK,onMiniBtnClick);
			Xtip.registerTip(_miniBtn,"最小化");
			Xtip.registerTip(_dragBtn,"拖动面板");
			_openBtnSprite = ClassInstance.getInstance("ui.RaidMiniOpen");
			_openBtnSprite.visible = false;
			_openBtnSprite.addEventListener(MouseEvent.CLICK,onMiniBtnClick);
			
			_raidNameTxt = Xdis.getChild(_ui,"raidNameTxt");
			_contentTxt = Xdis.getChild(_ui,"content_txt");
			
			_raidNameTxt.mouseEnabled=false;
			_contentTxt.mouseEnabled=false;
			
		}
		
		/**初始化
		 */		
		public function init():void{
			open();
			LayerManager.UILayer.addChild(this);
			Align.toRight(this,true,-230,230);
			LayerManager.UILayer.addChild(_openBtnSprite);
			Align.toRight(_openBtnSprite,true,0,330);
		}
		
		public static function get Instance():RaidMiniPanel{
			return instance||=new RaidMiniPanel;
		}
		
		/**最少化面板
		 * @param event
		 */		
		public function onMiniBtnClick(event:MouseEvent=null):void{
			_isMiniNow = !_isMiniNow;
			if(_isMiniNow == true){
				TweenLite.to(this,0.36,{onComplete:onMinied,ease:Cubic.easeOut,x:UI.stage.stageWidth+20,y:230});
				this.mouseChildren = false;
				this.mouseEnabled = false;
			}else{
				this.visible = true;
				this.x = UI.stage.stageWidth+100;
				_openBtnSprite.visible = false;
				this.mouseChildren = false;
				this.mouseEnabled = false;
				setTimeout(setMeClickAble,500);
				TweenLite.to(this,0.4,{ease:Cubic.easeOut,x:UI.stage.stageWidth-230,y:230});
			}
		}
		/**重置
		 */	
		private function setMeClickAble():void{
			this.mouseChildren = true;
			this.mouseEnabled = true;
		}
		/**最小化
		 */
		private function onMinied():void{
			this.visible = false;
			_openBtnSprite.visible = true;
			_openBtnSprite.alpha = 0;
			TweenLite.to(_openBtnSprite,0.8,{ease:Cubic.easeOut,alpha:1});
		}
		private static const ColorLeft:uint=0xebd26c;
		private static const ColorRight:uint=0x5eff1e;
		private static const ColorCom:uint=0xfd4989;
		private static const ColorWaveTime:uint=0x12e0ff;
		/**换行*/
		private static const Space:String="<br>";
		/**每秒更新*/
		public function update():void
		{
			var raid:RaidVo=RaidDyManager.Instence.currentRaid;
			if(!raid)
			{
				_raidNameTxt.text="";
				_contentTxt.htmlText="";
				return;
			}
			_raidNameTxt.text=raid.raidName;
			var content:String=HTMLFormat.color("适合等级：",ColorLeft)+HTMLFormat.color(raid.minLv+"-"+raid.maxLv,ColorRight)
				+Space+HTMLFormat.color("完成条件：",ColorLeft)+HTMLFormat.color(raid.win,ColorCom)+Space
				+HTMLFormat.color("倒计时：",ColorLeft)+HTMLFormat.color(TimeManager.getTimeStrFromSec(RaidDyManager.Instence.getRestTime()/1000,false),ColorRight);
			if(RaidDyManager.Instence.shouldShowEnemy())
				content+=(Space+HTMLFormat.color("剩余怪物数量：",ColorLeft)+HTMLFormat.color(RaidDyManager.Instence.aliveEnemyNum().toString(),ColorRight));
			if(raid.totalFloor>1)
				content+=(Space+HTMLFormat.color("层数：",ColorLeft)+HTMLFormat.color(raid.floor+"/"+raid.totalFloor,ColorRight));
			if(RaidDyManager.Instence.shouldShowWave())
				content+=(Space+HTMLFormat.color("怪物波数:",ColorLeft)+HTMLFormat.color(RaidDyManager.Instence.current_current_wave+"/"+RaidDyManager.Instence.current_total_wave,ColorRight));
			if(RaidDyManager.Instence.shouldShowWaveTime())	
				content+=(Space+HTMLFormat.color("距下一波刷新：",ColorLeft)+HTMLFormat.color(TimeManager.getTimeStrFromSec(RaidDyManager.Instence.getNextWaveTime()/1000,false),ColorWaveTime));
			
			_contentTxt.htmlText=content;
		}
		
		public function startTimer():void
		{
			trace("副本引导界面刷新开始");
			TimerDispather.instance.addFunc(TimerDispatherEvent.RaidTime,update);
		}
		public function stopTimer():void
		{
			TimerDispather.instance.delFunc(TimerDispatherEvent.RaidTime);
			RaidDyManager.Instence.reset();
			trace("副本引导界面关闭");
		}
	}
} 