package com.YFFramework.game.core.module.mount.view
{
	import com.YFFramework.game.core.global.manager.DyModuleUIManager;
	import com.YFFramework.game.core.global.util.UIPositionUtil;
	import com.YFFramework.game.core.global.view.player.MountPlayer;
	import com.YFFramework.game.core.global.view.window.WindowTittleName;
	import com.YFFramework.game.core.module.mount.manager.MountDyManager;
	import com.YFFramework.game.core.module.newGuide.manager.NewGuideDrawHoleUtil;
	import com.YFFramework.game.core.module.newGuide.manager.NewGuideManager;
	import com.YFFramework.game.core.module.newGuide.model.NewGuideStep;
	import com.YFFramework.game.core.module.newGuide.view.NewGuideMovieClipWidthArrow;
	import com.dolo.ui.controls.Button;
	import com.dolo.ui.controls.Window;
	import com.dolo.ui.managers.TabsManager;
	import com.dolo.ui.managers.TabsMovieClipManager;
	import com.dolo.ui.managers.UI;
	import com.dolo.ui.tools.AutoBuild;
	import com.dolo.ui.tools.Xdis;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	/**
	 * @version 1.0.0
	 * creation time：2013-4-24 下午2:17:55
	 * 
	 */
	public class MountWindow extends Window{
		
		private var _mountWindow:MovieClip;
		private var _info:MountInfo;
		private var _enhance:MountEnhance;
		private var _add:MountAdd;
		//private var _transfer:MountTransfer;
		public var _tabs:TabsManager;
		private var _panels:Array;
		/**坐骑模型 
		 */		
		private var _mountPlayer:MountPlayer;
		
		public function MountWindow(){
			_mountWindow = initByArgument(715,575,"MountUI",WindowTittleName.MountTitle,true,DyModuleUIManager.guildMarketWinBg) as MovieClip;
			setContentXY(25,27);
			
			_tabs = new TabsManager();
			_tabs.isRemoveChild = false;
			_tabs.initTabs(_mountWindow,"mountTabs",3,"tabView");
			
			_tabs.addEventListener(TabsManager.INDEX_CHANGE,onTabChange);
			_info = new MountInfo(Xdis.getChild(_mountWindow,"tabView1"),this);
			_enhance = new MountEnhance(Xdis.getChild(_mountWindow,"tabView2"),this);
			_add = new MountAdd(Xdis.getChild(_mountWindow,"tabView3"));
			//_transfer = new MountTransfer(Xdis.getChild(_mountWindow,"tabView4"));
			//_panels=[_info,_enhance,_add,_transfer];
			_panels=[_info,_enhance,_add];
			
			_mountPlayer = new MountPlayer();
			_mountPlayer.loadComplete=onLoadComplete;
			_mountWindow.model.mouseChildren=false;
			_mountWindow.model.mouseEnabled=false;
			
			var len:int=_panels.length;
			for(var i:int=0;i<len;i++){
				_panels[i].initWin();
			}
		}
		
		private function onLoadComplete():void{
			_mountWindow.loadingTxt.text="";
		}
		
		/**打开对应的界面
		 * @param index	界面的index,从1开始
		 */		
		public function popUpWindow(index:int):void{
			if(!this.isOpen)	this.switchOpenClose();
			_tabs.switchToTab(index);
			this.switchToTop();
		}
		
		/**打开坐骑面板
		 */		
		public function onOpen():void{
			_tabs.switchToTab(1);
		}
		
		/**关闭坐骑面板 
		 * @param event
		 */		
		override public function close(event:Event=null):void{
			closeTo(UI.stage.stageWidth-195,UI.stage.stageHeight-45,0.02,0.04);
			MountDyManager.Instance.initCrtMountId();
			if(_mountWindow.model.numChildren>0)	_mountWindow.model.removeChildAt(0);
			if(_mountPlayer)	_mountPlayer.stop();
//			var len:int=_panels.length;
//			for(var i:int=0;i<len;i++){
//				_panels[i].dispose();
//			}
			
			handleMountNewGuideHideGuide();
			
			_enhance.onClose();
		}
		
		/**切换面板 
		 * @param e
		 */		
		public function onTabChange(e:Event=null):void{
			if(this.isOpen){
				if(_tabs.nowIndex==1 && MountDyManager.crtMountId!=-1){
					if(_mountWindow.model.numChildren>0)	_mountWindow.model.removeChildAt(0);
					if(_mountPlayer)	_mountPlayer.stop();
					
					_mountWindow.model.addChild(_mountPlayer);
					updateMountPlayer();
				}else{
					if(_mountPlayer){
						_mountPlayer.stop();
						_mountPlayer.visible=false;
					}
				}
				
				_panels[_tabs.nowIndex-1].onTabUpdate();
			}
		}
		
		/**更新坐骑模型
		 */		
		public function updateMountPlayer():void{
			_mountWindow.loadingTxt.text="加载中。。。";
			_mountPlayer.updateMount(MountDyManager.Instance.getCrtMount().basicId);
			_mountPlayer.playDefault();
			_mountPlayer.start();
			_mountPlayer.visible=true;
		}
		
		/**背包改变刷新
		 */		
		public function onBagChange():void{
			if(this.isOpen){
				if(_tabs.nowIndex==3){
					_add.onTabUpdate();
				}else if(_tabs.nowIndex==2){
//					_enhance.updateItemList();
//					_enhance.updateItem();
					_enhance.onTabUpdate();
//					_enhance.updateBtn();
				}
			}
		}
		
		/**金钱改变刷新 
		 */		
		public function onMoneyChange():void{
			if(this.isOpen){
				if(_tabs.nowIndex==3 || _tabs.nowIndex==4){
					_panels[_tabs.nowIndex-1].updateMoneyTxt();
					_panels[_tabs.nowIndex-1].updateBtn();
				}
			}
		}
		
		public function turnLeft():void{
			_mountPlayer.turnLeft();
		}
		
		public function turnRight():void{
			_mountPlayer.turnRight();
		}
		
		
		
		///处理新手引导
		
		/**处理新手引导
		 */
		private function handleMountNewGuideFight():Boolean
		{
			return _info.handleMountNewGuideFight();
		}
		private function handleMountNewGuideCloseWindow():Boolean
		{
			if(NewGuideStep.MountGuideStep==NewGuideStep.MountWindowRectCloseBtn)
			{
//				var pt:Point=UIPositionUtil.getPosition(_closeButton,this);
//				NewGuideMovieClipWidthArrow.Instance.initRect(pt.x,pt.y,_closeButton.width,_closeButton.height,NewGuideMovieClipWidthArrow.ArrowDirection_Left);
//				NewGuideMovieClipWidthArrow.Instance.addToContainer(this);
				var pt:Point=UIPositionUtil.getUIRootPosition(_closeButton);
				NewGuideDrawHoleUtil.drawHoleByNewGuideMovieClipWidthArrow(pt.x,pt.y,_closeButton.width,_closeButton.height,NewGuideMovieClipWidthArrow.ArrowDirection_Left,_closeButton);
				NewGuideStep.MountGuideStep=NewGuideStep.MountWindowNone;
				return true;
			}
			return false;
		}
		
		/**隐藏引导箭头  关闭按钮时候触发
		 */ 
		private function handleMountNewGuideHideGuide():Boolean
		{
			if(NewGuideStep.MountGuideStep==NewGuideStep.MountWindowNone)
			{
				NewGuideMovieClipWidthArrow.Instance.hide();
				NewGuideStep.MountGuideStep=-1;
				NewGuideManager.DoGuide();
				return true;
			}
			return false;
		}
		
		
		override public function getNewGuideVo():*
		{
			var trigger:Boolean=false;
			
			trigger=handleMountNewGuideFight();
			if(!trigger)
			{
				trigger=handleMountNewGuideCloseWindow();
			}
			if(!trigger)
			{
				trigger=handleMountNewGuideHideGuide();
			}
			return trigger;
		}
		
		/**播放升阶成功特效*/
		public function showLvEff():void
		{
			_enhance.showLvEff();
		}
		
		public function showLuckEff():void
		{
			_enhance.showLuckEff();
		}
		
		/**检查是否处于一键升阶中*/
		public function checkAutoEnhance():void
		{
			_enhance.checkAuto();
		}
		
		/**用于坐骑预览时对齐的坐标*/
		public function getTarget():Point
		{
			var p:Point=new Point;
			p.x=this.x+this.width+5;
			p.y=this.y+5;
			return p;
		}
		
		/**关闭预览*/
		public function closePreview():void
		{
			_enhance.onClosePreview();
		}
		
	}
} 