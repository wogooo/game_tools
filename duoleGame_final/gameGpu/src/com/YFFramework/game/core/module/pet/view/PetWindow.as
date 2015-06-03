package com.YFFramework.game.core.module.pet.view
{
	import com.YFFramework.core.event.ParamEvent;
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.ui.movie.AvatarShow;
	import com.YFFramework.core.ui.movie.data.ActionData;
	import com.YFFramework.core.ui.movie.data.TypeAction;
	import com.YFFramework.core.ui.movie.data.TypeDirection;
	import com.YFFramework.core.ui.yf2d.data.ATFActionData;
	import com.YFFramework.core.utils.net.SourceCache;
	import com.YFFramework.game.core.global.DataCenter;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.core.global.manager.DyModuleUIManager;
	import com.YFFramework.game.core.global.manager.PetBasicManager;
	import com.YFFramework.game.core.global.util.UIPositionUtil;
	import com.YFFramework.game.core.global.view.window.WindowTittleName;
	import com.YFFramework.game.core.module.newGuide.manager.NewGuideDrawHoleUtil;
	import com.YFFramework.game.core.module.newGuide.manager.NewGuideManager;
	import com.YFFramework.game.core.module.newGuide.model.NewGuideStep;
	import com.YFFramework.game.core.module.newGuide.view.NewGuideMovieClipWidthArrow;
	import com.YFFramework.game.core.module.pet.events.PetEvent;
	import com.YFFramework.game.core.module.pet.manager.PetDyManager;
	import com.YFFramework.game.core.module.pet.view.grid.PetItem;
	import com.YFFramework.game.gameConfig.URLTool;
	import com.dolo.ui.controls.Window;
	import com.dolo.ui.managers.TabsManager;
	import com.dolo.ui.managers.UI;
	import com.dolo.ui.tools.Xdis;
	import com.msg.pets.PetRequest;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.utils.setTimeout;
	
	/**
	 * @version 1.0.0
	 * creation time：2013-3-8 下午2:05:20
	 */
	public class PetWindow extends Window{
		
		private var basePanel:MovieClip;
		public var _bitmapClip:AvatarShow;
		
		private var _panels:Array;
		private var _infoPanel:PetInfoPanel;
		private var _learnPanel:PetLearnPanel;
		private var _inheritPanel:PetInheritPanel;
		
		private var _tabsManager:TabsManager;
		
		public function PetWindow(){
			basePanel = initByArgument(910,580,"pet",WindowTittleName.PetTitle,true,DyModuleUIManager.petWinBg) as MovieClip;
			setContentXY(25,28);
			
			_tabsManager = new TabsManager();
			var _toogleBtn:MovieClip = basePanel.tab;
			
			for(var i:int=1;i<4;i++){
				var temp:MovieClip = basePanel["m"+i];
				_tabsManager.add(Xdis.getChild(_toogleBtn,"tab"+i),temp);
			}
			_tabsManager.addEventListener(TabsManager.INDEX_CHANGE,onTabChange);
			
			_infoPanel = new PetInfoPanel(basePanel.m1,this);
			_learnPanel = new PetLearnPanel(basePanel.m2);
			_inheritPanel = new PetInheritPanel(basePanel.m3);
			
			_panels=[_infoPanel,_learnPanel,_inheritPanel];
			
			//pet animation
			_bitmapClip=new AvatarShow();
			_bitmapClip.x=85;
			_bitmapClip.y=170;
			basePanel.avatarImg.addChild(_bitmapClip);
			basePanel.avatarImg.mouseChildren=false;
			basePanel.avatarImg.mouseEnabled=false;
			
			YFEventCenter.Instance.addEventListener(PetEvent.Select_Pet,onSelectPet);
			YFEventCenter.Instance.addEventListener(GlobalEvent.PetUseItemResp,updateFeedBtn);
		}
		
		/**窗口关闭
		 * @param event
		 */		
		override public function close(event:Event=null):void{
			closeTo(UI.stage.stageWidth-245,UI.stage.stageHeight-45,0.02,0.04);
			_bitmapClip.stop();
			PetDyManager.Instance.initCrtPetId();
			_learnPanel.reset();
			if(_infoPanel.getSophiPanel().isOpen){
				_infoPanel.getSophiPanel().close();
			}
			
			handlePetNewGuideHideGuide();
		}
		
		/**更新喂养按钮cd状态
		 * @param e
		 */		
		public function updateFeedBtn(e:YFEvent):void{
			_infoPanel.updateFeedBtn();
		}
		
		/**更新当前面板 
		 */
		public function updateAllPanel():void{
			if(this.isOpen)	_panels[_tabsManager.nowIndex-1].onTabUpdate();
		}
		
		/**更新学习面板
		 */		
		public function updateLearnPanel():void{
			_learnPanel.updateSkill();
		}
		/**更新魔元
		 */		
		public function updateMagicSoul():void{
			_learnPanel.updateMagicSoulTxt();
		}
		
		/**宠物收回更新 
		 */		
		public function updateTackBack():void{
			_infoPanel.updateTakeBack();
		}
		
		/** 宠物自动出战
		 */		
		public function autoFight():void{
			setTimeout(onCDDone,_infoPanel.fight_button.getCDTime());
		}
		
		/**宠物cd更新
		 */		
		private function onCDDone():void{
			if(PetDyManager.fightPetId==0 && PetDyManager.Instance.getPetDyVo(PetDyManager.backupFightPetId).happy>=60){
				if(DataCenter.Instance.roleSelfVo.roleDyVo.hp<=0){
					YFEventCenter.Instance.addEventListener(GlobalEvent.HeroRevive,onRevive);
				}else{
					var msg:PetRequest = new PetRequest();
					msg.petId = PetDyManager.backupFightPetId;
					YFEventCenter.Instance.dispatchEventWith(PetEvent.FightPetReq,msg);
					PetDyManager.backupFightPetId=0;
				}
			}
		}
		
		private function onRevive(e:YFEvent):void{
			if(DataCenter.Instance.roleSelfVo.roleDyVo.hp>0){
				YFEventCenter.Instance.removeEventListener(GlobalEvent.HeroRevive,onRevive);
				var msg:PetRequest = new PetRequest();
				msg.petId = PetDyManager.backupFightPetId;
				YFEventCenter.Instance.dispatchEventWith(PetEvent.FightPetReq,msg);
				PetDyManager.backupFightPetId=0;
			}
		}
		
		/**宠物出战更新
		 */
		public function updateFightPet():void{
			_infoPanel.updateFightPet();
		}
		
		/**更新信息面板 
		 */
		public function updateInfoPanel(type:String):void{
			if(this.isOpen && _tabsManager.nowIndex==1)		
				switch(type){
					case "all":
						_infoPanel.onTabUpdate();
						break;
					case "rename":
						_infoPanel.updatePetList();
						_infoPanel.updateName();
						break;
					case "forget":
						_infoPanel.updateSkill();
						break;
					case "addExp":
						_infoPanel.updateExp();
						break;
					case "hp":
						_infoPanel.updateHp();
						break;
					case "drop":
						_infoPanel.onTabUpdate();
						break;
				}
		}
		
		/**打开对应的界面
		 * @param index	界面的index,从1开始
		 */		
		public function popUpWindow(index:int):void{
			if(!this.isOpen)	this.switchOpenClose();
			_tabsManager.switchToTab(index);
			this.switchToTop();
		}
		
		/**背包改动更新
		 **/
		public function updateItem():void{
			if(this.isOpen){
				if(_tabsManager.nowIndex==1 && _infoPanel.getSophiPanel().isOpen){
					_infoPanel.getSophiPanel().updateContent();
				}
			}
		}
		
		/**金钱改动更新
		 */		
		public function updateMoney():void{
			if(this.isOpen){
				var index:int = _tabsManager.nowIndex;
				if(index==3){
					_panels[index-1].updateMoneyTxt();
				}else if(index==1 && _infoPanel.getSophiPanel().isOpen){
					_infoPanel.getSophiPanel().updateContent();
				}
			}
		}
		
		/**播放宠物Avatar 
		 */		
		public function playAvatar():void{
			if(PetDyManager.crtPetId!=-1){
				basePanel.loadingTxt.text = "加载中。。。";
				var url:String=URLTool.getPetView(PetBasicManager.Instance.getPetConfigVo(PetDyManager.Instance.getCrtPetDyVo().basicId).model_id);//URLTool.getMonsterStandWalk(PetBasicManager.Instance.getPetConfigVo(PetDyManager.Instance.getCrtPetDyVo().basicId).model_id);
				var actionData:ActionData=SourceCache.Instance.getRes2(url) as ActionData;
				if(actionData){
					_bitmapClip.initData(actionData);
					_bitmapClip.start();
					_bitmapClip.play(TypeAction.Stand,TypeDirection.Down,true,null,null,true);
					basePanel.loadingTxt.text="";
				}
				else{
					addEventListener(url,loaded); //加载
					SourceCache.Instance.loadRes(url,null,SourceCache.ExistAllScene,null,{dispatcher:this});
				}
			}else	basePanel.loadingTxt.text="";
		}
		
		/**宠物模型加载完成
		 * @param e
		 */		
		private function loaded(e:ParamEvent):void{
			var url:String=e.type;
			this.removeEventListener(url,loaded);
			var selectUrl:String=URLTool.getPetView(PetBasicManager.Instance.getPetConfigVo(PetDyManager.Instance.getCrtPetDyVo().basicId).model_id);
			var actionData:ActionData=SourceCache.Instance.getRes2(selectUrl) as ActionData;
			//播放选中的宠物
			if(actionData){
				_bitmapClip.initData(actionData);
				_bitmapClip.start();
				_bitmapClip.play(TypeAction.Stand,TypeDirection.Down,true,null,null,true);
				basePanel.loadingTxt.text="";
			}
		}
		
		/**切换tab
		 * @param index
		 */		
		public function switchTab(index:uint):void{
			_tabsManager.switchToTab(index);
		}
		
		/**tab切换事件响应
		 * @param event
		 */		
		private function onTabChange(event:Event=null):void{
			_panels[_tabsManager.nowIndex-1].onTabUpdate();
			if(_tabsManager.nowIndex!=1)	_bitmapClip.visible=false;
			UI.setToTop(basePanel.avatarImg);
		}
		
		/**选择宠物
		 * @param e
		 */		
		private function onSelectPet(e:YFEvent):void{
			if((e.param as PetItem).isMainPet()==true){
				PetDyManager.crtPetId = (e.param as PetItem).getPetDyVo().dyId;
				_panels[_tabsManager.nowIndex-1].onSelectUpdate(e.param as PetItem);
			}else{
				_panels[_tabsManager.nowIndex-1].onSecSelectUpdate(e.param as PetItem);
			}
		}
		
		
		private function handleCloseWindowGuide():Boolean
		{
			if(NewGuideStep.PetGuideStep==NewGuideStep.PetCloseWindow)
			{
//				var pt:Point=UIPositionUtil.getPosition(_closeButton,this);
//				NewGuideMovieClipWidthArrow.Instance.initRect(pt.x,pt.y,_closeButton.width,_closeButton.height,NewGuideMovieClipWidthArrow.ArrowDirection_Left);
//				NewGuideMovieClipWidthArrow.Instance.addToContainer(this);
				var pt:Point=UIPositionUtil.getUIRootPosition(_closeButton);
				NewGuideDrawHoleUtil.drawHoleByNewGuideMovieClipWidthArrow(pt.x,pt.y,_closeButton.width,_closeButton.height,NewGuideMovieClipWidthArrow.ArrowDirection_Left,_closeButton);
				NewGuideStep.PetGuideStep=NewGuideStep.PetNone;
				return true;
			}
			return false;
		}
		
		/**隐藏引导箭头  关闭按钮时候触发
		 */ 
		private function handlePetNewGuideHideGuide():Boolean
		{
			if(NewGuideStep.PetGuideStep==NewGuideStep.PetNone)
			{
				NewGuideMovieClipWidthArrow.Instance.hide();
				NewGuideStep.PetGuideStep=-1;
				NewGuideManager.DoGuide();
				return true;
			}
			return false;
		}
		
		override public function getNewGuideVo():*
		{
			var trigger:Boolean=false;
			trigger=_infoPanel.handlePetFightGuide();
			if(!trigger)
			{
				trigger=handleCloseWindowGuide();
			}
			if(!trigger)
			{
				trigger=handlePetNewGuideHideGuide();
			}
			return trigger;
		}
	}
} 