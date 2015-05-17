package com.YFFramework.game.core.module.gameView.view
{
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.net.loader.image_swf.IconLoader;
	import com.YFFramework.core.ui.abs.AbsView;
	import com.YFFramework.core.utils.URLTool;
	import com.YFFramework.core.utils.common.ClassInstance;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.core.global.manager.ConstMapBasicManager;
	import com.YFFramework.game.core.global.manager.PetBasicManager;
	import com.YFFramework.game.core.global.manager.PropsBasicManager;
	import com.YFFramework.game.core.global.manager.PropsDyManager;
	import com.YFFramework.game.core.global.util.FilterConfig;
	import com.YFFramework.game.core.global.util.NoticeUtil;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.module.bag.event.BagEvent;
	import com.YFFramework.game.core.module.pet.events.PetEvent;
	import com.YFFramework.game.core.module.pet.manager.PetDyManager;
	import com.YFFramework.game.core.module.pet.model.PetDyVo;
	import com.dolo.ui.controls.Button;
	import com.dolo.ui.controls.Menu;
	import com.dolo.ui.controls.ProgressBar;
	import com.dolo.ui.tools.AutoBuild;
	import com.dolo.ui.tools.Xdis;
	import com.msg.hero.CUseItem;
	import com.msg.pets.CSetPetFightAI;
	import com.msg.pets.PetRequest;
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;

	/**
	 * @version 1.0.0
	 * creation time：2013-3-28 下午12:17:40
	 * 宠物场景组件类
	 */
	public class PetIconView extends AbsView{
		
		private var _mc:MovieClip;
		private var _pet:PetDyVo;
		
		private var hp_progressBar:ProgressBar;
		private var happy_progressBar:ProgressBar;
		private var feed_button:Button;
		private var comfort_button:Button;
		private var fight_button:Button;
		private var mode_button:Button;
		
		private var _menu:Menu;
		
		public function PetIconView(){
			_mc = ClassInstance.getInstance("petIconView") as MovieClip;
			super(false);
			
			addChild(_mc);
			
			AutoBuild.replaceAll(_mc);
		
			hp_progressBar = Xdis.getChild(_mc,"hp_progressBar");
			happy_progressBar = Xdis.getChild(_mc,"happy_progressBar");
			feed_button = Xdis.getChildAndAddClickEvent(onFeed,_mc,"feed_button");
			comfort_button = Xdis.getChildAndAddClickEvent(onComfort,_mc,"comfort_button");
			fight_button = Xdis.getChildAndAddClickEvent(onFight,_mc,"fight_button");
			mode_button = Xdis.getChildAndAddClickEvent(onModeChange,_mc,"mode_button");
			
			YFEventCenter.Instance.addEventListener(GlobalEvent.PetUseItemResp,updateBtn);
		}
		
		/**根据相对的Type更新相对的界面 
		 * @param type
		 * @param pet
		 */		
		public function updateInfo(type:String,pet:PetDyVo):void{
			_pet = pet;
			switch(type){
				case "all":
					updatePetName();
					updatePetLevel();
					updatePetHappy();
					updatePetHp();
					updatePetIcon();
					updateStatus();
					updateMode();
					break;
				case "hp":
					updatePetHp();
					break;
				case "name":
					updatePetName();
					break;
				case "happy":
					updatePetHappy();
					break;
				case "lvup":
					updatePetLevel();
					updatePetHp();
					break; 
			}
		}
		
		/** 更新宠物名称
		 */	
		private function updatePetName():void{
			_mc.nameTxt.text = _pet.roleName;
		}
		
		/**更新宠物等级 
		 */
		public function updatePetLevel():void{
			_mc.lvTxt.text = _pet.level;
		}
		
		/**更新 宠物快乐度
		 */		
		public function updatePetHappy():void{
			happy_progressBar.percent=_pet.happy/100;
			_mc.happyTxt.text = _pet.happy+"/100";
		}
		
		/**更新 宠物Ai模式
		 */
		public function updateMode():void{
			switch(PetDyManager.Instance.getAiMode()){
				case 1:
					mode_button.label = "主动";
					break;
				case 2:
					mode_button.label = "被动";
					break;
				case 3:
					mode_button.label = "跟随";
					break;
			}
		}
		
		/**更新 宠物hp
		 */		
		public function updatePetHp():void{
			hp_progressBar.percent=_pet.fightAttrs[TypeProps.HP]/_pet.fightAttrs[TypeProps.HP_LIMIT];
			_mc.hpTxt.text = int(_pet.fightAttrs[TypeProps.HP])+"/"+int(_pet.fightAttrs[TypeProps.HP_LIMIT]);
		}
		
		/**更新 宠物头像
		 */	
		public function updatePetIcon():void{
			if(_mc.petImg.numChildren>0)
				_mc.petImg.removeChildAt(0);
			
			IconLoader.initLoader(URLTool.getMonsterIcon(PetBasicManager.Instance.getPetConfigVo(_pet.basicId).head_id),_mc.petImg);
			if(_pet.dyId!=PetDyManager.Instance.getFightPetId())
				_mc.petImg.filters = FilterConfig.dead_filter;
			else
				_mc.petImg.filters = null;
		}
		
		/**更新 宠物出战按钮
		 */	
		public function updateStatus():void{
			if(_pet.dyId==PetDyManager.Instance.getFightPetId()){
				fight_button.clearCDUpdate();
				fight_button.label = "休息";
				fight_button.enabled = true;
			}else{
				fight_button.label = "出战";
				fight_button.resetCD();
			}
		}
		
		/**宠物休息更新 
		 */		
		public function updateTakeBack():void{
			fight_button.label = "出战";
			fight_button.disableAndAbleLater(15000);
			fight_button.startCDUpdate();
		}
		
		/**宠物出战更新 
		 */
		public function updateFightPet():void{
			fight_button.disableAndAbleLater(15000);
			fight_button.clearCDUpdate();
			fight_button.label = "休息";
			fight_button.enabled = true;
		}
		
		/**更新喂养驯养按钮的CD状态 
		 * @param e 使用喂养驯养道具的事件通知
		 */		
		public function updateBtn(e:YFEvent):void{
			comfort_button.disableAndAbleLater(PropsBasicManager.Instance.getPropsBasicVo(PropsBasicManager.Instance.getAllBasicVoByType(TypeProps.BIG_PROPS_TYPE_COMFORT)[0].template_id).cd_time,"*");
			feed_button.disableAndAbleLater(PropsBasicManager.Instance.getPropsBasicVo(PropsBasicManager.Instance.getAllBasicVoByType(TypeProps.BIG_PROPS_TYPE_FEED)[0].template_id).cd_time,"*");
		}

		/**宠物出战按钮 点击
		 */
		private function onFight(e:MouseEvent):void{
			var msg:PetRequest = new PetRequest();
			msg.petId = _pet.dyId;
			if(fight_button.textField.text=="出战"){
				if(_pet.happy<60)	NoticeUtil.setOperatorNotice("快乐度不足，无法出战");
				else	YFEventCenter.Instance.dispatchEventWith(PetEvent.FightPetReq,msg);
			}else{
				YFEventCenter.Instance.dispatchEventWith(PetEvent.TakeBackReq,msg);
			}
		}
		
		/**宠物喂养按钮 点击
		 */
		private function onFeed(e:MouseEvent):void{
			if(PetDyManager.Instance.getCrtPetDyVo().fightAttrs[TypeProps.HP]==PetDyManager.Instance.getCrtPetDyVo().fightAttrs[TypeProps.HP_LIMIT]){
				NoticeUtil.setOperatorNotice("宠物血量已满");
			}else if(PropsDyManager.instance.getFirstPetDrugPos()==-1){
				NoticeUtil.setOperatorNotice("没有喂养道具");
			}else{
				var msg:CUseItem=new CUseItem();
				msg.petId = PetDyManager.crtPetId;
				msg.itemPos = PropsDyManager.instance.getFirstPetDrugPos();
				YFEventCenter.Instance.dispatchEventWith(BagEvent.USE_ITEM,msg);
			}
		}
		
		/**宠物驯养按钮 点击
		 */
		private function onComfort(e:MouseEvent):void{
			if(_pet.happy==100){
				NoticeUtil.setOperatorNotice("宠物快乐度已满");
			}else if(PropsDyManager.instance.getPropsQuantity(PropsBasicManager.Instance.getAllBasicVoByType(TypeProps.BIG_PROPS_TYPE_COMFORT)[0].template_id)==0){
				NoticeUtil.setOperatorNotice("道具不足，无法驯养");
			}else{
				var msg:CUseItem = new CUseItem();
				msg.petId = _pet.dyId;
				msg.itemPos=PropsDyManager.instance.getFirstPropsPos(PropsBasicManager.Instance.getAllBasicVoByType(TypeProps.BIG_PROPS_TYPE_COMFORT)[0].template_id);
				YFEventCenter.Instance.dispatchEventWith(BagEvent.USE_ITEM,msg);
			}
		}
		
		/**宠物AI按钮 点击
		 */
		private function onModeChange(e:MouseEvent):void{
			if(!_menu){
				_menu = new Menu();
				_menu.addItem("主动",onMenuItemClick);
				_menu.addSpace(Menu.creatDefautSpace());
				_menu.addItem("被动",onMenuItemClick);
				_menu.addSpace(Menu.creatDefautSpace());
				_menu.addItem("跟随",onMenuItemClick);
			}
			_menu.show(mode_button,0,20);
		}
		
		/**宠物AI按钮下拉选项 点击
		 */
		private function onMenuItemClick(index:uint,label:String):void{
			var msg:CSetPetFightAI = new CSetPetFightAI();
			msg.fightAi=index+1;
			YFEventCenter.Instance.dispatchEventWith(PetEvent.AiModeReq,msg);
		}
	}
} 