package com.YFFramework.game.core.module.pet.view
{
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.core.global.manager.PetBasicManager;
	import com.YFFramework.game.core.global.manager.PropsBasicManager;
	import com.YFFramework.game.core.global.manager.PropsDyManager;
	import com.YFFramework.game.core.global.model.PetBasicVo;
	import com.YFFramework.game.core.global.util.NoticeUtil;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.global.util.UIPositionUtil;
	import com.YFFramework.game.core.module.bag.source.JInputWindow;
	import com.YFFramework.game.core.module.chat.manager.ChatFilterManager;
	import com.YFFramework.game.core.module.newGuide.manager.NewGuideDrawHoleUtil;
	import com.YFFramework.game.core.module.newGuide.model.NewGuideStep;
	import com.YFFramework.game.core.module.newGuide.view.NewGuideMovieClipWidthArrow;
	import com.YFFramework.game.core.module.pet.events.PetEvent;
	import com.YFFramework.game.core.module.pet.manager.PetDyManager;
	import com.YFFramework.game.core.module.pet.manager.PetLevelXpManager;
	import com.YFFramework.game.core.module.pet.model.PetDyVo;
	import com.YFFramework.game.core.module.pet.view.collection.PetsCollection;
	import com.YFFramework.game.core.module.pet.view.collection.SkillsCollection;
	import com.YFFramework.game.core.module.pet.view.grid.PetItem;
	import com.YFFramework.game.core.module.pet.view.grid.PetSkillGrid;
	import com.dolo.ui.controls.Alert;
	import com.dolo.ui.controls.Button;
	import com.dolo.ui.controls.ProgressBar;
	import com.dolo.ui.controls.VScrollBar;
	import com.dolo.ui.events.AlertCloseEvent;
	import com.dolo.ui.managers.UI;
	import com.dolo.ui.tools.AutoBuild;
	import com.dolo.ui.tools.MouseDownKeepCall;
	import com.dolo.ui.tools.Xdis;
	import com.msg.hero.CUseItem;
	import com.msg.pets.*;
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * @version 1.0.0
	 * creation time：2013-3-8 下午2:57:07
	 * 宠物信息
	 */
	public class PetInfoPanel{
		
		private var _mc:MovieClip;
		private var _petWindow:PetWindow;

		private var release_button:Button;
		public var fight_button:Button;
		private var rename_button:Button;
		private var feed_button:Button;
		private var sophi_button:Button;
		private var left_button:SimpleButton;
		private var right_button:SimpleButton;

		private var petsCollection:PetsCollection;
		private var petScrollbar:VScrollBar;
		private var skillsCollection:SkillsCollection;
		private var _skillId:int;

		private var hp_progressBar:ProgressBar;
		private var exp_progressBar:ProgressBar;
		private var phy_progressBar:ProgressBar;
		private var str_progressBar:ProgressBar;
		private var agi_progressBar:ProgressBar;
		private var int_progressBar:ProgressBar;
		private var spi_progressBar:ProgressBar;
		
		public function PetInfoPanel(mc:MovieClip,petWindow:PetWindow){
			_mc = mc;
			_petWindow = petWindow;
			AutoBuild.replaceAll(_mc);

			release_button = Xdis.getChild(_mc,"release_button");
			release_button.addEventListener(MouseEvent.CLICK,onRelease);
			fight_button = Xdis.getChild(_mc,"fight_button");
			fight_button.addEventListener(MouseEvent.CLICK,onFight);

			rename_button = Xdis.getChild(_mc,"rename_button");
			rename_button.addEventListener(MouseEvent.CLICK,onRename);

			feed_button = Xdis.getChild(_mc,"feed_button");
			feed_button.addEventListener(MouseEvent.CLICK,onFeed);
			sophi_button = Xdis.getChild(_mc,"sophi_button");
			sophi_button.addEventListener(MouseEvent.CLICK,onSophi);
			sophi_button.enabled=false;

			left_button = _mc.right;
			new MouseDownKeepCall(left_button,onLeft,8);
			
			right_button = _mc.left;
			new MouseDownKeepCall(right_button,onRight,8);
			
			hp_progressBar = Xdis.getChild(_mc,"hp_progressBar");
			exp_progressBar = Xdis.getChild(_mc,"exp_progressBar");
			phy_progressBar = Xdis.getChild(_mc,"phy_progressBar");
			str_progressBar = Xdis.getChild(_mc,"str_progressBar");
			agi_progressBar = Xdis.getChild(_mc,"agi_progressBar");
			int_progressBar = Xdis.getChild(_mc,"int_progressBar");
			spi_progressBar = Xdis.getChild(_mc,"spi_progressBar");

			petsCollection=new PetsCollection(0,30);
			petsCollection.init();
			_mc.addChild(petsCollection);
			
			petScrollbar = Xdis.getChild(_mc,"pet_vScrollBar");
			petScrollbar.setTarget(petsCollection,false,160,395);
			petScrollbar.updateSize(30*49+10);
			_mc.addChild(petScrollbar);
			
			skillsCollection = new SkillsCollection();

			YFEventCenter.Instance.addEventListener(PetEvent.Select_Skill,onSelSkill);
		}
		
		/**获得洗练窗口实例
		 * @return 
		 */		
		public function getSophiPanel():PetSophiPanel{
			return PetSophiPanel.Instance;
		}
		
		/**洗练按钮点击
		 * @param e
		 */		
		private function onSophi(e:MouseEvent):void{
			if(PetSophiPanel.Instance.isOpen){
				PetSophiPanel.Instance.close();
			}else
				PetSophiPanel.Instance.open();
		}
		
		/**切换界面更新
		 */		
		public function onTabUpdate():void{
			updatePetList();
			updateCrtPetGrid();
			_petWindow.playAvatar();
			updateSkill();
			if(PetSophiPanel.Instance.isOpen)	PetSophiPanel.Instance.updateContent();
		}
		/**切换选择更新
		 * @param petItem
		 */		
		public function onSelectUpdate(petItem:PetItem):void{
			petsCollection.setFilter(petItem.getIndex());
			updateCrtPetGrid();
			_petWindow.playAvatar();
			updateSkill();
			if(PetSophiPanel.Instance.isOpen)	PetSophiPanel.Instance.updateContent();
		}
		/**更新宠物列表
		 */		
		public function updatePetList():void{
			_mc.petListTxt.text="宠物列表("+PetDyManager.Instance.getPetListSize()+"/"+PetDyManager.petOpenSlots+")";
			petsCollection.openSlot();
			petsCollection.clearPetContent();
			petsCollection.loadContent();
		}

		/**更新当前宠物
		 */		
		public function updateCrtPetGrid():void{
			
			if(PetDyManager.crtPetId!=-1){
				var petDyVo:PetDyVo = PetDyManager.Instance.getCrtPetDyVo();
				if(petDyVo)
				{
					var petConfigVo:PetBasicVo = PetBasicManager.Instance.getPetConfigVo(petDyVo.basicId);
					
					_mc.t0.text = int(petDyVo.fightAttrs[TypeProps.BA_PHYSIQUE]);
					_mc.t1.text = int(petDyVo.fightAttrs[TypeProps.BA_STRENGTH]);
					_mc.t2.text = int(petDyVo.fightAttrs[TypeProps.BA_AGILE]);
					_mc.t3.text = int(petDyVo.fightAttrs[TypeProps.BA_INTELLIGENCE]);
					_mc.t4.text = int(petDyVo.fightAttrs[TypeProps.BA_SPIRIT]);
					//text
					//				_mc.petTypeTxt.text = "宠物类型："+petConfigVo.pet_type_name;
					//				_mc.petLvTxt.text = "Lv ： "+petDyVo.level;
					_mc.attTxt.text = int(petDyVo.fightAttrs[TypeProps.EA_PHYSIC_ATK]);
					_mc.magicTxt.text = int(petDyVo.fightAttrs[TypeProps.EA_MAGIC_ATK]);
					_mc.defTxt.text = int(petDyVo.fightAttrs[TypeProps.EA_PHYSIC_DEFENSE]);
					_mc.magicDefTxt.text = int(petDyVo.fightAttrs[TypeProps.EA_MAGIC_DEFENSE]);
					//_mc.growTxt.text = "成长率："+petDyVo.fightAttrs[TypeProps.BA_GROW].toFixed(2);
					_mc.petNameTxt.text = petDyVo.roleName;
					
					//progressbar
					hp_progressBar.percent = petDyVo.fightAttrs[TypeProps.EA_HEALTH] / petDyVo.fightAttrs[TypeProps.EA_HEALTH_LIMIT];
					_mc.hpTxt.text = Math.ceil(petDyVo.fightAttrs[TypeProps.EA_HEALTH])+ "/"+ Math.ceil(petDyVo.fightAttrs[TypeProps.EA_HEALTH_LIMIT]);
					
					//				happy_progressBar.percent = petDyVo.happy/100;
					//				_mc.happyTxt.text = petDyVo.happy+"/100";
					
					exp_progressBar.percent = petDyVo.exp/PetLevelXpManager.Instance.getXp(petDyVo.level);
					_mc.expTxt.text = petDyVo.exp + "/" + PetLevelXpManager.Instance.getXp(petDyVo.level);
					
					phy_progressBar.percent = petDyVo.fightAttrs[TypeProps.BA_PHYSIQUE_APT]/petDyVo.fightAttrs[TypeProps.BA_PHY_QLT_LIM];
					_mc.phyTxt.text = petDyVo.fightAttrs[TypeProps.BA_PHYSIQUE_APT]+"/"+petDyVo.fightAttrs[TypeProps.BA_PHY_QLT_LIM];
					str_progressBar.percent = petDyVo.fightAttrs[TypeProps.BA_STRENGTH_APT]/petDyVo.fightAttrs[TypeProps.BA_STR_QLT_LIM];
					_mc.strTxt.text = petDyVo.fightAttrs[TypeProps.BA_STRENGTH_APT]+"/"+petDyVo.fightAttrs[TypeProps.BA_STR_QLT_LIM];
					agi_progressBar.percent = petDyVo.fightAttrs[TypeProps.BA_AGILE_APT]/petDyVo.fightAttrs[TypeProps.BA_AGI_QLT_LIM];
					_mc.agiTxt.text = petDyVo.fightAttrs[TypeProps.BA_AGILE_APT]+"/"+petDyVo.fightAttrs[TypeProps.BA_AGI_QLT_LIM];
					int_progressBar.percent = petDyVo.fightAttrs[TypeProps.BA_INTELLIGENCE_APT]/petDyVo.fightAttrs[TypeProps.BA_INT_QLT_LIM];
					_mc.intTxt.text = petDyVo.fightAttrs[TypeProps.BA_INTELLIGENCE_APT]+"/"+petDyVo.fightAttrs[TypeProps.BA_INT_QLT_LIM];
					spi_progressBar.percent = petDyVo.fightAttrs[TypeProps.BA_SPIRIT_APT]/petDyVo.fightAttrs[TypeProps.BA_SPI_QLT_LIM];
					_mc.spiTxt.text = petDyVo.fightAttrs[TypeProps.BA_SPIRIT_APT]+"/"+petDyVo.fightAttrs[TypeProps.BA_SPI_QLT_LIM];
					
					_mc.powerTxt.text = petDyVo.power;
					
					fight_button.setSTAbleLater(true);
					if(petDyVo.dyId == PetDyManager.fightPetId){
						fight_button.label = "休息";
						fight_button.enabled = true;
						fight_button.setCDViewable(false);
					}else{
						if(fight_button.isCDing()){
							fight_button.setCDBackupTxt("出战");
							fight_button.setCDViewable(true);
							fight_button.enabled=false;
						}else{
							fight_button.label = "出战";
							fight_button.enabled=true;
						}
					}
					
					_petWindow._bitmapClip.visible = true;
					
					if(release_button.enabled==false){
						release_button.enabled = true;
						rename_button.enabled = true;
						feed_button.setSTAbleLater(true);
						if(feed_button.isCDing())	feed_button.enabled=false;
						else	feed_button.enabled = true;
						UI.setEnable(left_button,true);
						UI.setEnable(right_button,true);
					}
					sophi_button.enabled=true;
				}else{
					release_button.enabled = false;
					fight_button.setCDViewable(false);
					fight_button.label = "出战";
					fight_button.enabled=false;
					fight_button.setSTAbleLater(false);
					rename_button.enabled = false;
					feed_button.enabled=false;
					feed_button.setSTAbleLater(false);
					UI.setEnable(left_button,false);
					UI.setEnable(right_button,false);
					sophi_button.enabled=false;
					_petWindow._bitmapClip.visible=false;
					
					_mc.t0.text="";
					_mc.t1.text="";
					_mc.t2.text="";
					_mc.t3.text="";
					_mc.t4.text="";
					
					//				_mc.petTypeTxt.text = "宠物类型：";
					//				_mc.petLvTxt.text = "Lv : ";
					_mc.attTxt.text = "";
					_mc.magicTxt.text = "";
					_mc.defTxt.text = "";
					_mc.magicDefTxt.text = "";
					_mc.petNameTxt.text = "";
					hp_progressBar.percent = 0;
					_mc.hpTxt.text = "";
					
					exp_progressBar.percent = 0;
					_mc.expTxt.text = "";
					
					phy_progressBar.percent = 0;
					_mc.phyTxt.text = "";
					str_progressBar.percent = 0;
					_mc.strTxt.text = "";
					agi_progressBar.percent = 0;
					_mc.agiTxt.text = "";
					int_progressBar.percent = 0;
					_mc.intTxt.text = "";
					spi_progressBar.percent = 0;
					_mc.spiTxt.text = "";
					_petWindow._bitmapClip.visible = false;
				}
			}
		}
		
		/**Disable喂养按钮CD
		 */		
		public function updateFeedBtn():void{
			feed_button.STAddCDTime(PropsBasicManager.Instance.getPropsBasicVo(PropsBasicManager.Instance.getAllBasicVoByType(TypeProps.PROPS_TYPE_PET_FEED)[0].template_id).cd_time,true,"喂养");
		}
		
		/**更新宠物名称 
		 */		
		public function updateName():void{
			_mc.petNameTxt.text = PetDyManager.Instance.getCrtPetDyVo().roleName;
		}
		
		/**宠物收回更新 
		 */		
		public function updateTakeBack():void{
			updatePetList();
			updateCrtPetGrid();
			fight_button.STAddCDTime(15000,true,"出战");
		}
		
		/**宠物出战更新 
		 */		
		public function updateFightPet():void{
			updatePetList();
			fight_button.STAddCDTime(15000,false,"出战");
			fight_button.label = "休息";
			fight_button.enabled = true;
		}
		
		/**宠物技能更新 
		 */		
		public function updateSkill():void{
			skillsCollection.setFilter(-1);
			skillsCollection.clearSkillGrid();
			_skillId = -1;
			skillsCollection.loadContent(true,_mc);
		}
		
		/**更新血量
		 */		
		public function updateHp():void{
			var pet:PetDyVo = PetDyManager.Instance.getCrtPetDyVo();
			if(pet){
				hp_progressBar.percent = pet.fightAttrs[TypeProps.EA_HEALTH] / pet.fightAttrs[TypeProps.EA_HEALTH_LIMIT];
				_mc.hpTxt.text = Math.ceil(pet.fightAttrs[TypeProps.EA_HEALTH])+ "/"+ Math.ceil(pet.fightAttrs[TypeProps.EA_HEALTH_LIMIT]);
			}
		}
		
		/**更新经验
		 */		
		public function updateExp():void{
			var pet:PetDyVo = PetDyManager.Instance.getCrtPetDyVo();
			exp_progressBar.percent = pet.exp/PetLevelXpManager.Instance.getXp(pet.level);
			_mc.expTxt.text = pet.exp + "/" + PetLevelXpManager.Instance.getXp(pet.level);
		}

		/**宠物放生框
		 * @param e
		 */		
		private function onRelease(e:MouseEvent):void{
			var txt:String = "确定要放生"+PetDyManager.Instance.getCrtPetDyVo().roleName+"吗？放生后，宠物将永久消失";
			Alert.show(txt,'放生宠物',onReleaseConfirm,["确认","取消"]);
		}
		
		/**宠物放生确认
		 * @param e
		 */		
		private function onReleaseConfirm(e:AlertCloseEvent):void{
			if(e.clickButtonIndex==1){
				var msg:PetRequest = new PetRequest();
				msg.petId = PetDyManager.crtPetId;
				YFEventCenter.Instance.dispatchEventWith(PetEvent.ReleaseReq,msg);
			}
		}
		
		/**宠物出战
		 * @param e
		 */		
		private function onFight(e:MouseEvent):void{
			var msg:PetRequest = new PetRequest();
			msg.petId = PetDyManager.crtPetId;
			if(PetDyManager.crtPetId!=PetDyManager.fightPetId){
				if(PetDyManager.Instance.getCrtPetDyVo().happy<60)	NoticeUtil.setOperatorNotice("快乐度不足，无法出战");
				else	YFEventCenter.Instance.dispatchEventWith(PetEvent.FightPetReq,msg);
			}
			else	YFEventCenter.Instance.dispatchEventWith(PetEvent.TakeBackReq,msg);
		}
		
		/**宠物模型往左
		 * @param e
		 */		
		private function onLeft(e:MouseEvent=null):void{
			_petWindow._bitmapClip.turnLeft();
		}
		
		/**宠物模型往右
		 * @param e
		 */	
		private function onRight(e:MouseEvent=null):void{
			_petWindow._bitmapClip.turnRight();
		}
				
		/**宠物技能遗忘弹出框
		 * @param e
		 */		
		private function onForget(e:MouseEvent):void{
			if(_skillId==-1)	NoticeUtil.setOperatorNotice("请先选择要遗忘的技能!");
			else
				Alert.show("确定要让["+PetDyManager.Instance.getCrtPetDyVo().roleName+"]遗忘技能吗？技能遗忘后，将永久消失。","遗忘技能",onForgetAlert,["确认","取消"]);
		}
		
		/**宠物技能遗忘确定
		 * @param e
		 */		
		private function onForgetAlert(e:AlertCloseEvent):void{
			if(e.clickButtonIndex==1){
				var msg:CPetForgetSkill = new CPetForgetSkill();	
				msg.petId = PetDyManager.crtPetId;
				msg.skillId = _skillId;
				YFEventCenter.Instance.dispatchEventWith(PetEvent.ForgetSkillReq,msg);
			}
		}
		/**喂养宠物
		 * @param e
		 */		
		private function onFeed(e:MouseEvent):void{
			if(Math.ceil(PetDyManager.Instance.getCrtPetDyVo().fightAttrs[TypeProps.EA_HEALTH])==Math.ceil(PetDyManager.Instance.getCrtPetDyVo().fightAttrs[TypeProps.EA_HEALTH_LIMIT])){
				NoticeUtil.setOperatorNotice("宠物血量已满");
			}else if(PropsDyManager.instance.getFirstPetDrugPos()==-1){
				NoticeUtil.setOperatorNotice("没有喂养道具");
			}else{
				var msg:CUseItem=new CUseItem();
				msg.petId = PetDyManager.crtPetId;
				msg.itemPos = PropsDyManager.instance.getFirstPetDrugPos();
				YFEventCenter.Instance.dispatchEventWith(GlobalEvent.USE_ITEM,msg);
			}
		}
		/**宠物重命名
		 * @param e
		 */		
		private function onRename(e:MouseEvent):void{
			JInputWindow.Instance().initPanel("宠物改名","请输入宠物名称",onRenameOK,"");
		}
		/**宠物重命名确认
		 * @param e
		 */	
		private function onRenameOK():void{
			if(ChatFilterManager.containsFilterWords(JInputWindow.Instance().getInputText())){
				NoticeUtil.setOperatorNotice("名字不合法，请重新输入");
			}else{
				var msg:CPetRenameReq = new CPetRenameReq();
				msg.petId = PetDyManager.crtPetId;
				msg.name = JInputWindow.Instance().getInputText();
				YFEventCenter.Instance.dispatchEventWith(PetEvent.RenameReq,msg);
				JInputWindow.Instance().close();
			}
		}
		/**选中技能
		 * @param e
		 */		
		private function onSelSkill(e:YFEvent):void{
			skillsCollection.setFilter((e.param as PetSkillGrid).getIndex());
			_skillId = (e.param as PetSkillGrid).getSkillId();
		}
		
		/**引导宠物出战
		 */
		public function handlePetFightGuide():Boolean
		{
			if(NewGuideStep.PetGuideStep==NewGuideStep.PetFight)
			{  // label =="出战"  "休息"
//				var point:Point=UIPositionUtil.getPosition(fight_button,_mc);
//				var rect:Rectangle=new Rectangle(point.x,point.y,fight_button.width,fight_button.height);//获取升级区域
//				NewGuideMovieClipWidthArrow.Instance.initRect(rect.x,rect.y,rect.width,rect.height,NewGuideMovieClipWidthArrow.ArrowDirection_Left);
//				NewGuideMovieClipWidthArrow.Instance.addToContainer(_mc);
				var point:Point=UIPositionUtil.getUIRootPosition(fight_button);
				NewGuideDrawHoleUtil.drawHoleByNewGuideMovieClipWidthArrow(point.x,point.y,fight_button.width,fight_button.height,NewGuideMovieClipWidthArrow.ArrowDirection_Left,fight_button);
				return true;
			}
			return false;
		}
	}
} 