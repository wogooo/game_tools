package com.YFFramework.game.core.module.pet.view
{
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.ui.movie.AvatarShow;
	import com.YFFramework.core.ui.movie.data.ActionData;
	import com.YFFramework.core.ui.movie.data.TypeAction;
	import com.YFFramework.core.ui.movie.data.TypeDirection;
	import com.YFFramework.core.utils.URLTool;
	import com.YFFramework.core.utils.net.SourceCache;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.core.global.manager.PetBasicManager;
	import com.YFFramework.game.core.module.pet.events.PetEvent;
	import com.YFFramework.game.core.module.pet.manager.PetDyManager;
	import com.YFFramework.game.core.module.pet.view.grid.PetItem;
	import com.dolo.ui.controls.Window;
	import com.dolo.ui.managers.TabsManager;
	import com.dolo.ui.tools.Xdis;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.utils.Dictionary;
	/**
	 * @version 1.0.0
	 * creation time：2013-3-8 下午2:05:20
	 * 
	 */
	public class PetWindow extends Window{
		
		private var basePanel:MovieClip;
		public var _bitmapClip:AvatarShow;
		
		private var _panels:Array;
		private var _infoPanel:PetInfoPanel;
		private var _combinePanel:PetCombinePanel;
		private var _enhancePanel:PetEnhancePanel;
		private var _comprePanel:PetComprePanel;
		private var _learnPanel:PetLearnPanel;
		private var _sophiPanel:PetSophiPanel;
		private var _inheritPanel:PetInheritPanel;
		private var _resetPanel:PetResetPanel;

		private var _tabsManager:TabsManager;
		
		public function PetWindow(){
			basePanel = initByArgument(708,552,"pet","宠物") as MovieClip;
			
			_tabsManager = new TabsManager();
			var _toogleBtn:MovieClip = basePanel.tab;
			
			for(var i:int=1;i<9;i++){
				var temp:MovieClip = basePanel["m"+i];
				_tabsManager.add(Xdis.getChild(_toogleBtn,"tab"+i),temp);
			}
			_tabsManager.addEventListener(TabsManager.INDEX_CHANGE,onTabChange);
			
			_infoPanel = new PetInfoPanel(basePanel.m1,this);
			_combinePanel = new PetCombinePanel(basePanel.m2);
			_enhancePanel = new PetEnhancePanel(basePanel.m3);
			_comprePanel = new PetComprePanel(basePanel.m4);
			_learnPanel = new PetLearnPanel(basePanel.m5);
			_sophiPanel = new PetSophiPanel(basePanel.m6);
			_inheritPanel = new PetInheritPanel(basePanel.m7);
			_resetPanel = new PetResetPanel(basePanel.m8);
			
			_panels=[_infoPanel,_combinePanel,_enhancePanel,_comprePanel,_learnPanel,_sophiPanel,_inheritPanel,_resetPanel];
			
			//pet animation
			_bitmapClip=new AvatarShow();
			_bitmapClip.setPivotXY(85,170);
			basePanel.avatarImg.addChild(_bitmapClip);
			basePanel.avatarImg.mouseChildren=false;
			basePanel.avatarImg.mouseEnabled=false;
			
			YFEventCenter.Instance.addEventListener(PetEvent.Select_Pet,onSelectPet);
			YFEventCenter.Instance.addEventListener(GlobalEvent.PetUseItemResp,updateBtn);
		}
		
		override public function close(event:Event=null):void{
			super.close(event);
			_bitmapClip.stop();
			PetDyManager.Instance.initCrtPetId();
		}
		
		public function updateBtn(e:YFEvent):void{
			_infoPanel.CDBtn();
		}
		
		/**更新当前面板 
		 **/
		public function updateAllPanel():void{
			if(this.isOpen)	_panels[_tabsManager.nowIndex-1].onTabUpdate();
		}
		
		/**更新领悟面板 
		 **/
		public function updateComprePanel():void{
			_comprePanel.updateSkills();
			_comprePanel.updateItem();
			_comprePanel.updateItemGrid();
		}
		
		/**更新学习面板 
		 **/
		public function updateLearnPanel():void{
			_learnPanel.clearItemImg();
			_learnPanel.updateSkills();
			_learnPanel.updateItem();
		}
		
		/**宠物收回更新 
		 */		
		public function updateTackBack():void{
			_infoPanel.updateTakeBack();
		}
		
		/**宠物出战更新 
		 */		
		public function updateFightPet():void{
			_infoPanel.updateFightPet();
		}
		
		/**更新信息面板 
		 **/
		public function updateInfoPanel(type:String):void{
			if(this.isOpen && _tabsManager.nowIndex==1)		
				switch(type){
					case "rename":
						_infoPanel.updatePetList();
						_infoPanel.updateName();
						break;
					case "happy":
						_infoPanel.updateHappy();
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
						//_infoPanel.disableCFBtn();
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
				var index:int = _tabsManager.nowIndex;
				if(index==5){
					_learnPanel.updateItem();
				}else if(index==3||index==4||index==6||index==8){
					_panels[index-1].updateItem();
					_panels[index-1].updateItemGrid();
				}
			}
		}
		
		public function updateMoney():void{
			if(this.isOpen){
				var index:int = _tabsManager.nowIndex;
				if(index==2 || index==6 || index==7 || index==8){
					_panels[index-1].updateMoneyTxt();
				}
			}
		}

		/**播放宠物Avatar 
		 */		
		public function playAvatar():void{
			if(PetDyManager.crtPetId!=-1){
				var url:String=URLTool.getMonsterNormal(PetBasicManager.Instance.getPetConfigVo(PetDyManager.Instance.getCrtPetDyVo().basicId).model_id);
				var actionData:ActionData=SourceCache.Instance.getRes2(url) as ActionData;
				if(actionData){
					_bitmapClip.initData(actionData);
					_bitmapClip.start();
					_bitmapClip.play(TypeAction.Stand,TypeDirection.Down,true,null,null,true);
				}
				else{
					SourceCache.Instance.addEventListener(url,loaded);
					SourceCache.Instance.loadRes(url);
				}
			}
		}
		
		private function loaded(e:YFEvent):void{
			var url:String=e.type;
			SourceCache.Instance.removeEventListener(url,loaded);
			var selectUrl:String=URLTool.getMonsterNormal(PetBasicManager.Instance.getPetConfigVo(PetDyManager.Instance.getCrtPetDyVo().basicId).model_id);
			var actionData:ActionData=SourceCache.Instance.getRes2(selectUrl) as ActionData;
			//播放选中的宠物
			if(actionData){
				_bitmapClip.initData(actionData);
				_bitmapClip.start();
				_bitmapClip.play(TypeAction.Stand,TypeDirection.Down,true,null,null,true);
			}
		}
		
		public function switchTab(index:uint):void{
			_tabsManager.switchToTab(index);
		}
		
		private function onTabChange(event:Event=null):void{
			_panels[_tabsManager.nowIndex-1].onTabUpdate();
			if(_tabsManager.nowIndex!=1)
				_bitmapClip.visible=false;
		}
		
		private function onSelectPet(e:YFEvent):void{
			if((e.param as PetItem).isMainPet()==true){
				PetDyManager.crtPetId = (e.param as PetItem).getPetDyVo().dyId;
				_panels[_tabsManager.nowIndex-1].onSelectUpdate(e.param as PetItem);
			}
			else{
				_panels[_tabsManager.nowIndex-1].onSecSelectUpdate(e.param as PetItem);
			}
		}
	}
} 