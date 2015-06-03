package com.YFFramework.game.core.module.gameView.view
{
	import com.CMD.GameCmd;
	import com.YFFramework.core.debug.print;
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.net.loader.image_swf.IconLoader;
	import com.YFFramework.core.ui.abs.AbsView;
	import com.YFFramework.core.ui.yfComponent.PopUpManager;
	import com.YFFramework.core.ui.yfComponent.controls.YFCD;
	import com.YFFramework.core.utils.common.ClassInstance;
	import com.YFFramework.game.core.global.DataCenter;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.core.global.manager.BuffBasicManager;
	import com.YFFramework.game.core.global.manager.ConstMapBasicManager;
	import com.YFFramework.game.core.global.manager.PetBasicManager;
	import com.YFFramework.game.core.global.manager.PropsBasicManager;
	import com.YFFramework.game.core.global.manager.PropsDyManager;
	import com.YFFramework.game.core.global.model.BuffBasicVo;
	import com.YFFramework.game.core.global.model.PropsBasicVo;
	import com.YFFramework.game.core.global.util.FilterConfig;
	import com.YFFramework.game.core.global.util.NoticeUtil;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.global.util.UIPositionUtil;
	import com.YFFramework.game.core.global.view.tips.AutoHealTip;
	import com.YFFramework.game.core.global.view.tips.TipUtil;
	import com.YFFramework.game.core.module.autoSetting.event.AutoEvent;
	import com.YFFramework.game.core.module.autoSetting.manager.AutoManager;
	import com.YFFramework.game.core.module.autoSetting.source.AutoSource;
	import com.YFFramework.game.core.module.bag.data.BagStoreManager;
	import com.YFFramework.game.core.module.bag.event.BagEvent;
	import com.YFFramework.game.core.module.chat.model.ChatData;
	import com.YFFramework.game.core.module.newGuide.events.NewGuideEvent;
	import com.YFFramework.game.core.module.newGuide.manager.NewGuideDrawHoleUtil;
	import com.YFFramework.game.core.module.newGuide.manager.NewGuideManager;
	import com.YFFramework.game.core.module.newGuide.model.NewGuideStep;
	import com.YFFramework.game.core.module.newGuide.view.NewGuideMovieClip;
	import com.YFFramework.game.core.module.pet.events.PetEvent;
	import com.YFFramework.game.core.module.pet.manager.PetDyManager;
	import com.YFFramework.game.core.module.pet.model.PetDyVo;
	import com.YFFramework.game.core.module.shop.controller.ModuleShop;
	import com.YFFramework.game.core.module.shop.data.ShopBasicManager;
	import com.YFFramework.game.gameConfig.URLTool;
	import com.dolo.ui.controls.Button;
	import com.dolo.ui.controls.Menu;
	import com.dolo.ui.controls.ProgressBar;
	import com.dolo.ui.controls.Slider;
	import com.dolo.ui.managers.UI;
	import com.dolo.ui.sets.ButtonTextStyle;
	import com.dolo.ui.tools.AutoBuild;
	import com.dolo.ui.tools.Xdis;
	import com.dolo.ui.tools.Xtip;
	import com.msg.hero.CAddPetHpByPool;
	import com.msg.hero.CUseItem;
	import com.msg.hero.SAddPetHpByPool;
	import com.msg.hero.SPetHpPoolChange;
	import com.msg.pets.CSetPetFightAI;
	import com.msg.pets.PetRequest;
	import com.msg.sys.CAutoConfigSave;
	import com.msg.sys.ConfigInt;
	import com.net.MsgPool;
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.utils.Dictionary;
	import flash.utils.setTimeout;

	/**
	 * @version 1.0.0
	 * creation time：2013-3-28 下午12:17:40
	 * 宠物场景组件类
	 */
	public class PetIconView extends AbsView{
		
		private var _mc:MovieClip;
		private var _pet:PetDyVo;
		private var _buffs:Dictionary;
		private var _isMenuOpen:Boolean=false;
		
		private var hp_progressBar:ProgressBar;
//		private var happy_progressBar:ProgressBar;
		private var feed_button:Button;
//		private var comfort_button:Button;
		private var fight_button:Button;
		private var mode_button:Button;
		private var hp_slider:Slider;
		private var _menu:Menu;
		
		private var slideValue:Number;
		private var _hasHpDrugCD:Boolean=false;
		private var _hasHpPoolCD:Boolean=false;
		
		private const Pet_Hp_Pool_Type:int=20;
		
		private var _buffView:BuffIconView;
		
		
		/** 强制引导的 mc 
		 */
		private var _newGuideMovieClip:NewGuideMovieClip;

		public function PetIconView(){
			_buffs = new Dictionary();
			_mc = ClassInstance.getInstance("petIconView") as MovieClip;
			this.visible=false;
			
			super(false);
			
			addChild(_mc);
			
			AutoBuild.replaceAll(_mc);
		
			_mc.hpTxt.mouseEnabled = false;
						
			hp_progressBar = Xdis.getChild(_mc,"hp_progressBar");
			
			hp_slider = Xdis.getChild(_mc,"hp_slider");
			hp_slider.addEventListener(Event.CHANGE,onSlide);
			hp_slider.liveDragging=false;
			
//			happy_progressBar = Xdis.getChild(_mc,"happy_progressBar");
			feed_button = Xdis.getChildAndAddClickEvent(onFeed,_mc,"feed_button");
			feed_button.label="血";
			feed_button.changeTextColor(new ButtonTextStyle(0xffffff,0xffffff,0xffffff,0xffffff));
			

//			comfort_button = Xdis.getChildAndAddClickEvent(onComfort,_mc,"comfort_button");
//			comfort_button.label="驯";
//			comfort_button.changeTextColor(new ButtonTextStyle(0xffffff,0xffffff,0xffffff,0xffffff));
			
			
			fight_button = Xdis.getChildAndAddClickEvent(onFight,_mc,"fight_button");
			fight_button.label="出";
			fight_button.changeTextColor(new ButtonTextStyle(0xffffff,0xffffff,0xffffff,0xffffff));
			
			mode_button = Xdis.getChildAndAddClickEvent(onModeChange,_mc,"mode_button");
			
			//YFEventCenter.Instance.addEventListener(GlobalEvent.PetUseItemResp,updateFeedBtn);
			YFEventCenter.Instance.addEventListener(AutoEvent.LOAD_COMPLETE,onLoadComplete);
			
			MsgPool.addCallBack(GameCmd.SPetHpPoolChange,SPetHpPoolChange,onPetHpPoolChange);
			MsgPool.addCallBack(GameCmd.SAddPetHPByPool,SAddPetHpByPool,onAddPetHPByPool);
			
			_buffView=new BuffIconView;
			_mc.buffImg.addChild(_buffView);
			//引导宠物出战
//			NewGuideManager.PetFightGuideFunc=initPetCreateGuide;
		}
		/**引导宠物孵化
		 */
//		private  function initPetCreateGuide():Boolean
//		{
//			if(NewGuideStep.PetGuideStep==NewGuideStep.FightPet)
//			{
//				var rect:Rectangle=getBtnRect(); 
//				_newGuideMovieClip=NewGuideModalUtil.drawHole(rect.x,rect.y,rect.width,rect.height);
//				NewGuideStep.PetGuideStep=-1;
//				return true;
//			}
//			return false;
//		}

		/**移除引导
		 */
		private function removeNewGuideModal():void
		{
			if(_newGuideMovieClip)
			{
				PopUpManager.removePopUp(_newGuideMovieClip);
				_newGuideMovieClip.dispose();
				_newGuideMovieClip=null;
			}
		}
		
		/**获取使用按钮在事件坐标点位置
		 */
		private function getBtnRect():Rectangle
		{
			var pt:Point=UIPositionUtil.getRootPosition(fight_button);
			return new Rectangle(pt.x,pt.y,fight_button.width,fight_button.height);
		}

		
		/**血池加血
		 * @param msg
		 */
		private function onAddPetHPByPool(msg:SAddPetHpByPool):void{
			if(msg.erroInfo==TypeProps.RSPMSG_SUCCESS){
				if(PetDyManager.fightPetId!=0){
					PetDyManager.Instance.getFightPetDyVo().fightAttrs[TypeProps.EA_HEALTH] = msg.petHp;
					_pet.fightAttrs[TypeProps.EA_HEALTH]=msg.petHp;
					_hasHpPoolCD = true;
					setTimeout(onHpCDComplete,15000);
					YFEventCenter.Instance.dispatchEventWith(GlobalEvent.PetHpChg);
					updatePetHp();
				}	
			}else{
				_hasHpPoolCD=false;
			}
		}
		
		/**血池加血cd完成*/
		private function onHpCDComplete():void{
			_hasHpPoolCD = false;
			updatePetHp();
		}
		
		/**血池改变
		 * @param msg
		 */		
		private function onPetHpPoolChange(msg:SPetHpPoolChange):void{
			DataCenter.Instance.roleSelfVo.petHpPool = msg.petHpPool;
//			updatePool();
			updatePetHp();
		}
		
		/**更新血池魔池
		 */
		private function updatePool(e:YFEvent=null):void{
			Xtip.registerLinkTip(feed_button,AutoHealTip,TipUtil.autoPoolInitFunc,AutoHealTip.TypePet);
		}
		
		/**加载完成
		 * @param e
		 */		
		private function onLoadComplete(e:YFEvent):void{
			hp_slider.value = AutoManager.Instance.petHpPercent;
			Xtip.registerLinkTip(hp_slider.drag,AutoHealTip,TipUtil.autoHealInitFunc,hp_slider.value,"宠物生命值","宠物药");
			updatePool();
		}
		
		/**划动自动加血完成
		 * @param e
		 */
		private function onSlide(e:Event):void{
			AutoManager.Instance.petHpPercent = hp_slider.value;
			Xtip.registerLinkTip(hp_slider.drag,AutoHealTip,TipUtil.autoHealInitFunc,hp_slider.value,"宠物生命值","宠物药");
			var msg:CAutoConfigSave = new CAutoConfigSave();
			msg.configIntArr = new Array();
			var config:ConfigInt = new ConfigInt();
			config.configType = AutoSource.CT_PET_HP_PERCENT;
			config.configValue = hp_slider.value;
			msg.configIntArr.push(config);
			YFEventCenter.Instance.dispatchEventWith(AutoEvent.SAVE,msg);
			updatePetHp();
			//Xtip.showTipNow(hp_slider.drag);
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
//					updatePetHappy();
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
//					updatePetHappy();
					break;
				case "lvup":
					updatePetLevel();
					updatePetHp();
					break;
				case "takeback":
//					updatePetHappy();
					updatePetHp();
					updateStatus();
					updatePetIcon();
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
//		public function updatePetHappy():void{
//			if(_pet)
//			{
//				happy_progressBar.percent=_pet.happy/100;
//				_mc.happyTxt.text = _pet.happy+"/100";
//				_mc.happyTxt.visible = false;
//			}
//		}
		
		/**更新 宠物Ai模式
		 */
		public function updateMode():void{
			switch(PetDyManager.aiMode){
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
			if(_pet){
				hp_progressBar.percent=_pet.fightAttrs[TypeProps.EA_HEALTH]/_pet.fightAttrs[TypeProps.EA_HEALTH_LIMIT];
				_mc.hpTxt.text = Math.ceil(_pet.fightAttrs[TypeProps.EA_HEALTH])+"/"+Math.ceil(_pet.fightAttrs[TypeProps.EA_HEALTH_LIMIT]);
				var hpPercent:Number = hp_progressBar.percent*100;
				var sendByPool:Boolean=false;
				print("hp%:"+hpPercent);
				print("hpPool:"+DataCenter.Instance.roleSelfVo.petHpPool);
				print("hp Max/5:"+_pet.fightAttrs[TypeProps.EA_HEALTH_LIMIT]*.2);
				print("cd :"+_hasHpPoolCD);
				if(hpPercent<=70 
					&& DataCenter.Instance.roleSelfVo.petHpPool>=_pet.fightAttrs[TypeProps.EA_HEALTH_LIMIT]*0.2 
					&& _hasHpPoolCD==false){//使用血池
					MsgPool.sendGameMsg(GameCmd.CAddPetHPByPool,new CAddPetHpByPool());
					sendByPool = true;
					_hasHpPoolCD = true;
				}
				
				if(sendByPool==false && hpPercent<hp_slider.value && hpPercent<100 && _hasHpDrugCD==false){//使用血瓶
					var pos:int = PropsDyManager.instance.getFirstPetDrugPos();
					if(pos>0){
						var bvo:PropsBasicVo = PropsBasicManager.Instance.getPropsBasicVo(PropsDyManager.instance.getPropsInfo(BagStoreManager.instantce.getPackInfoByPos(pos).id).templateId);
						var cd:YFCD = BagStoreManager.instantce.getCd(bvo.cd_type);
						if(cd==null){
							if(PetDyManager.fightPetId!=0){
								var msg:CUseItem = new CUseItem();
								msg.itemPos = pos;
								msg.petId = PetDyManager.fightPetId;	
								YFEventCenter.Instance.dispatchEventWith(GlobalEvent.USE_ITEM,msg);
								setTimeout(onHpDrugCDComplete,bvo.cd_time+500);
								_hasHpDrugCD=true;
							}else	_hasHpDrugCD=false;
						}else{
							setTimeout(onHpDrugCDComplete,cd.getRemainTime()+500);
							_hasHpDrugCD=true;
						}
					}
				}
			}
		}
		
		private function onHpDrugCDComplete():void{
			_hasHpDrugCD=false;
			updatePetHp();
		}
		
		/**更新 宠物头像
		 */	
		public function updatePetIcon():void{
			if(_mc.petImg.numChildren>0)
				_mc.petImg.removeChildAt(0);
			
			IconLoader.initLoader(URLTool.getMonsterIcon(PetBasicManager.Instance.getPetConfigVo(_pet.basicId).head_id),_mc.petImg);
			if(_pet.dyId!=PetDyManager.fightPetId){
				_mc.petImg.filters = UI.disableFilter;
				hp_progressBar.filters=UI.disableFilter;
//				happy_progressBar.filters=UI.disableFilter;
//				_mc.petImg.filters = FilterConfig.dead_filter;
//				hp_progressBar.filters=FilterConfig.dead_filter;
//				happy_progressBar.filters=FilterConfig.dead_filter;
			}
			else{
				_mc.petImg.filters = null;
				hp_progressBar.filters=null;
//				happy_progressBar.filters=null;
			}
		}
		
		/**更新 宠物出战按钮
		 */	
		public function updateStatus():void{
			if(_pet.dyId==PetDyManager.fightPetId){
				fight_button.label = "休";
				fight_button.enabled = true;
				fight_button.setCDViewable(false);
			}else{
				if(fight_button.isCDing()){
					fight_button.setCDBackupTxt("出");
					fight_button.setCDViewable(true);
					fight_button.enabled=false;
				}else{
					fight_button.label = "出";
				}
			}
		}
		
		/**宠物休息更新 
		 */		
		public function updateTakeBack():void{
			fight_button.STAddCDTime(15000,true,"出",2);
		}
		
		/**宠物出战更新 
		 */
		public function updateFightPet():void{
			fight_button.STAddCDTime(15000,false,"出",2);
			fight_button.label = "休";
			fight_button.enabled = true;
		}
		
//		/**更新喂养按钮的CD状态
//		 * @param e 使用喂养道具的事件通知
//		 */		
//		public function updateFeedBtn(e:YFEvent):void{
//			feed_button.STAddCDTime(PropsBasicManager.Instance.getPropsBasicVo(PropsBasicManager.Instance.getAllBasicVoByType(TypeProps.PROPS_TYPE_PET_FEED)[0].template_id).cd_time,true,"喂",2);
//		}
		
		public function addBuff(buffID:int):void
		{
			_buffView.addBuffIcon(buffID,BuffIconView.TypePet);
		}
		public function deleteBuff(buffID:int):void
		{
			_buffView.deleteBuffIcon(buffID);
		}
		public function removeAllBuff():void
		{
			_buffView.removeAllBuffIcon();
		}

		/**宠物出战按钮 点击
		 */
		private function onFight(e:MouseEvent):void{
			removeNewGuideModal();
			
			var msg:PetRequest = new PetRequest();
			msg.petId = _pet.dyId;
			if(fight_button.textField.text=="出"){
				if(_pet.happy<60)	NoticeUtil.setOperatorNotice("快乐度不足，无法出战");
				else	YFEventCenter.Instance.dispatchEventWith(PetEvent.FightPetReq,msg);
			}else{
				YFEventCenter.Instance.dispatchEventWith(PetEvent.TakeBackReq,msg);
			}
		}
		
		/**宠物喂养按钮 点击
		 */
		private function onFeed(e:MouseEvent):void{
//			if(PetDyManager.Instance.getCrtPetDyVo().fightAttrs[TypeProps.EA_HEALTH]==PetDyManager.Instance.getCrtPetDyVo().fightAttrs[TypeProps.EA_HEALTH_LIMIT]){
//				NoticeUtil.setOperatorNotice("宠物血量已满");
//			}else if(PropsDyManager.instance.getFirstPetDrugPos()==-1){
//				NoticeUtil.setOperatorNotice("没有喂养道具");
//			}else{
//				var msg:CUseItem=new CUseItem();
//				msg.petId = PetDyManager.crtPetId;
//				msg.itemPos = PropsDyManager.instance.getFirstPetDrugPos();
//				YFEventCenter.Instance.dispatchEventWith(GlobalEvent.USE_ITEM,msg);
//			}
			var bvo:PropsBasicVo = PropsBasicManager.Instance.getAllBasicVoByType(Pet_Hp_Pool_Type)[0];
			if((AutoSource.Pet_Hp_Pool_Max-DataCenter.Instance.roleSelfVo.petHpPool)<bvo.attr_value){
				NoticeUtil.setOperatorNotice("宠物生命源泉还很充足，不需要补充！");
			}else{
				AutoManager.autoUseTempId= bvo.template_id;
				ModuleShop.instance.buyItemDirect(TypeProps.ITEM_TYPE_PROPS,AutoManager.autoUseTempId,1);
			}
		}
		
		/**宠物驯养按钮 点击
		 */
		private function onComfort(e:MouseEvent):void{
			if(_pet.happy==100){
				NoticeUtil.setOperatorNotice("宠物快乐度已满");
			}else if(PropsDyManager.instance.getPropsQuantity(PropsBasicManager.Instance.getAllBasicVoByType(TypeProps.PROPS_TYPE_PET_COMFORT)[0].template_id)==0){
				NoticeUtil.setOperatorNotice("道具不足，无法驯养");
			}else{
				var msg:CUseItem = new CUseItem();
				msg.petId = _pet.dyId;
				msg.itemPos=PropsDyManager.instance.getFirstPropsPos(PropsBasicManager.Instance.getAllBasicVoByType(TypeProps.PROPS_TYPE_PET_COMFORT)[0].template_id);
				YFEventCenter.Instance.dispatchEventWith(GlobalEvent.USE_ITEM,msg);
			}
		}
		
		/**宠物AI按钮 点击
		 */
		private function onModeChange(e:MouseEvent):void{
			if(!_menu){
				_menu = new Menu();
				_menu.withoutMouseDownClose.push(mode_button);
				_menu.txtX=5;
				_menu.setSize(36,0);
//				_menu.addItem("主动",onMenuItemClick);
//				_menu.addSpace(Menu.creatDefautSpace());
				_menu.addItem("被动",onMenuItemClick);
				//_menu.addSpace(Menu.creatDefautSpace());
				_menu.addItem("跟随",onMenuItemClick);
			}
			if(_menu.isOpen)	_menu.hide();
			else	_menu.show(mode_button,5,20);
		}
		
		/**宠物AI按钮下拉选项 点击
		 */
		private function onMenuItemClick(index:uint,label:String):void{
			var msg:CSetPetFightAI = new CSetPetFightAI();
			msg.fightAi=index+2;
			YFEventCenter.Instance.dispatchEventWith(PetEvent.AiModeReq,msg);
		}
	}
} 