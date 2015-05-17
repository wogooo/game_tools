package com.YFFramework.game.core.module.pet.view
{
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.utils.common.ClassInstance;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.core.global.manager.ConstMapBasicManager;
	import com.YFFramework.game.core.global.manager.PetBasicManager;
	import com.YFFramework.game.core.global.manager.PropsBasicManager;
	import com.YFFramework.game.core.global.manager.PropsDyManager;
	import com.YFFramework.game.core.global.manager.SkillBasicManager;
	import com.YFFramework.game.core.global.model.PetBasicVo;
	import com.YFFramework.game.core.global.util.NoticeUtil;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.module.bag.event.BagEvent;
	import com.YFFramework.game.core.module.bag.source.JInputWindow;
	import com.YFFramework.game.core.module.pet.events.PetEvent;
	import com.YFFramework.game.core.module.pet.manager.PetDyManager;
	import com.YFFramework.game.core.module.pet.manager.PetLevelXpManager;
	import com.YFFramework.game.core.module.pet.model.PetDyVo;
	import com.YFFramework.game.core.module.pet.view.collection.PetsCollection;
	import com.YFFramework.game.core.module.pet.view.collection.SkillsCollection;
	import com.YFFramework.game.core.module.pet.view.grid.AddGrid;
	import com.YFFramework.game.core.module.pet.view.grid.PetItem;
	import com.YFFramework.game.core.module.pet.view.grid.SkillGrid;
	import com.dolo.ui.controls.Alert;
	import com.dolo.ui.controls.Button;
	import com.dolo.ui.controls.ProgressBar;
	import com.dolo.ui.controls.VScrollBar;
	import com.dolo.ui.events.AlertCloseEvent;
	import com.dolo.ui.managers.UI;
	import com.dolo.ui.tools.AutoBuild;
	import com.dolo.ui.tools.Xdis;
	import com.msg.common.AttrInfo;
	import com.msg.enumdef.PropsType;
	import com.msg.hero.CUseItem;
	import com.msg.pets.*;
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;

	/**
	 * @version 1.0.0
	 * creation time：2013-3-8 下午2:57:07
	 * 宠物信息
	 */
	public class PetInfoPanel{
		
		private var _mc:MovieClip;
		private var _petWindow:PetWindow;

		private var release_button:Button;
		private var confirm_button:Button;
		private var fight_button:Button;
		private var recommand_button:Button;
		private var rename_button:Button;
		private var comfort_button:Button;
		private var feed_button:Button;
		private var combine_button:Button;
		private var enhance_button:Button;
		private var learn_button:Button;
		private var forget_button:Button;
		private var left_button:SimpleButton;
		private var right_button:SimpleButton;

		private var petsCollection:PetsCollection;
		private var petScrollbar:VScrollBar;
		private var skillsCollection:SkillsCollection;
		private var _skillId:int;
		
		private var addArr:Array;
		private var _potential:int;

		private var hp_progressBar:ProgressBar;
		private var happy_progressBar:ProgressBar;
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
			confirm_button = Xdis.getChild(_mc,"confirm_button");
			confirm_button.addEventListener(MouseEvent.CLICK,onConfirm);
			recommand_button = Xdis.getChild(_mc,"recommand_button");
			recommand_button.addEventListener(MouseEvent.CLICK,onRecommand);
			rename_button = Xdis.getChild(_mc,"rename_button");
			rename_button.addEventListener(MouseEvent.CLICK,onRename);
			comfort_button = Xdis.getChild(_mc,"comfort_button");
			comfort_button.addEventListener(MouseEvent.CLICK,onComfort);
			feed_button = Xdis.getChild(_mc,"feed_button");
			feed_button.addEventListener(MouseEvent.CLICK,onFeed);
			combine_button = Xdis.getChild(_mc,"combine_button");
			combine_button.addEventListener(MouseEvent.CLICK,onCombine);
			enhance_button = Xdis.getChild(_mc,"enhance_button");
			enhance_button.addEventListener(MouseEvent.CLICK,onEnhance);
			
			learn_button = Xdis.getChild(_mc,"learn_button");
			learn_button.addEventListener(MouseEvent.CLICK,onLearn);
			
			forget_button = Xdis.getChild(_mc,"forget_button");
			forget_button.addEventListener(MouseEvent.CLICK,onForget);
			
			left_button = _mc.left;
			left_button.addEventListener(MouseEvent.CLICK,onLeft);
			
			right_button = _mc.right;
			right_button.addEventListener(MouseEvent.CLICK,onRight);
			
			//progress bar
			hp_progressBar = Xdis.getChild(_mc,"hp_progressBar");
			happy_progressBar = Xdis.getChild(_mc,"happy_progressBar");
			exp_progressBar = Xdis.getChild(_mc,"exp_progressBar");
			phy_progressBar = Xdis.getChild(_mc,"phy_progressBar");
			str_progressBar = Xdis.getChild(_mc,"str_progressBar");
			agi_progressBar = Xdis.getChild(_mc,"agi_progressBar");
			int_progressBar = Xdis.getChild(_mc,"int_progressBar");
			spi_progressBar = Xdis.getChild(_mc,"spi_progressBar");

			//scrollbar and data
			petsCollection=new PetsCollection(5,30);
			petsCollection.init();
			_mc.addChild(petsCollection);
			
			petScrollbar = Xdis.getChild(_mc,"pet_vScrollBar");
			petScrollbar.setTarget(petsCollection,false,160,430);
			petScrollbar.updateSize(30*48+10);
			_mc.addChild(petScrollbar);
			
			skillsCollection = new SkillsCollection();

			//Add grid
			addArr = new Array();
			for(var i:int=0;i<5;i++){
				addArr[i] = new AddGrid(_mc["add"+i],this);
			}
			
			YFEventCenter.Instance.addEventListener(PetEvent.Select_Skill,onSelSkill);
		}
		
		public function onTabUpdate():void{
			updatePetList();
			updateCrtPetGrid();
			_petWindow.playAvatar();
			updateSkill();
		}
		
		public function onSelectUpdate(petItem:PetItem):void{
			petsCollection.setFilter(petItem.getIndex());
			updateCrtPetGrid();
			_petWindow.playAvatar();
			updateSkill();
		}
		
		public function updatePetList():void{
			_mc.petListTxt.text="宠物列表("+PetDyManager.Instance.getPetListSize()+"/"+PetDyManager.Instance.getPetOpenSlots()+")";
			petsCollection.openSlot();
			petsCollection.clearPetContent();
			petsCollection.loadContent();
		}

		public function updateCrtPetGrid():void{
			for(var i:int=0;i<addArr.length;i++){
				addArr[i].clearContent();
			}
			var num:int=_mc.starImg.numChildren;
			for(i=0;i<num;i++){
				_mc.starImg.removeChildAt(0);
			}
			
			if(PetDyManager.crtPetId!=-1){
				var petDyVo:PetDyVo = PetDyManager.Instance.getCrtPetDyVo();
				var petConfigVo:PetBasicVo = PetBasicManager.Instance.getPetConfigVo(petDyVo.basicId);
				
				//add Grid
				_potential = petDyVo.potential;

				_mc.potentialTxt.text = "潜力 ："+petDyVo.potential;
				_mc.add3.num.text = "体质："+petDyVo.fightAttrs[TypeProps.BASIC_PHY];
				_mc.add0.num.text = "力量："+petDyVo.fightAttrs[TypeProps.BASIC_STR];
				_mc.add1.num.text = "敏捷："+petDyVo.fightAttrs[TypeProps.BASIC_AGI];
				_mc.add2.num.text = "智力："+petDyVo.fightAttrs[TypeProps.BASIC_INT];
				_mc.add4.num.text = "精神："+petDyVo.fightAttrs[TypeProps.BASIC_SPI];
			
				//text
				_mc.petTypeTxt.text = "宠物类型："+petConfigVo.pet_type;
				_mc.petLvTxt.text = "Lv : "+petDyVo.level;
				_mc.attTxt.text = "物理攻击："+int(petDyVo.fightAttrs[TypeProps.PHYSIC_ATK]);
				_mc.magicTxt.text = "魔法攻击："+int(petDyVo.fightAttrs[TypeProps.MAGIC_ATK]);
				_mc.defTxt.text = "物理防御："+int(petDyVo.fightAttrs[TypeProps.PHYSIC_DEF]);
				_mc.magicDefTxt.text = "魔法防御："+int(petDyVo.fightAttrs[TypeProps.PHYSIC_DEF]);
				_mc.growTxt.text = "成长率："+petDyVo.fightAttrs[TypeProps.GROWTH].toFixed(2);
				_mc.petNameTxt.text = petDyVo.roleName;
				_mc.powerTxt.text = "战斗力 ："+petDyVo.power;
				
				//progressbar
				hp_progressBar.percent = petDyVo.fightAttrs[TypeProps.HP] / petDyVo.fightAttrs[TypeProps.HP_LIMIT];
				_mc.progressTxt.hpTxt.text = int(petDyVo.fightAttrs[TypeProps.HP])+ "/"+ int(petDyVo.fightAttrs[TypeProps.HP_LIMIT]);
					
				happy_progressBar.percent = petDyVo.happy/100;
				_mc.progressTxt.happyTxt.text = petDyVo.happy+"/100";
				
				exp_progressBar.percent = petDyVo.exp/PetLevelXpManager.Instance.getXp(petDyVo.level);
				_mc.progressTxt.expTxt.text = petDyVo.exp + "/" + PetLevelXpManager.Instance.getXp(petDyVo.level);
				
				phy_progressBar.percent = petDyVo.fightAttrs[TypeProps.BASIC_PHY_QLT]/petDyVo.fightAttrs[TypeProps.BASIC_PHY_QLT_LIM];
				_mc.progressTxt.phyTxt.text = petDyVo.fightAttrs[TypeProps.BASIC_PHY_QLT]+"/"+petDyVo.fightAttrs[TypeProps.BASIC_PHY_QLT_LIM];
				str_progressBar.percent = petDyVo.fightAttrs[TypeProps.BASIC_STR_QLT]/petDyVo.fightAttrs[TypeProps.BASIC_STR_QLT_LIM];
				_mc.progressTxt.strTxt.text = petDyVo.fightAttrs[TypeProps.BASIC_STR_QLT]+"/"+petDyVo.fightAttrs[TypeProps.BASIC_STR_QLT_LIM];
				agi_progressBar.percent = petDyVo.fightAttrs[TypeProps.BASIC_AGI_QLT]/petDyVo.fightAttrs[TypeProps.BASIC_AGI_QLT_LIM];
				_mc.progressTxt.agiTxt.text = petDyVo.fightAttrs[TypeProps.BASIC_AGI_QLT]+"/"+petDyVo.fightAttrs[TypeProps.BASIC_AGI_QLT_LIM];
				int_progressBar.percent = petDyVo.fightAttrs[TypeProps.BASIC_INT_QLT]/petDyVo.fightAttrs[TypeProps.BASIC_INT_QLT_LIM];
				_mc.progressTxt.intTxt.text = petDyVo.fightAttrs[TypeProps.BASIC_INT_QLT]+"/"+petDyVo.fightAttrs[TypeProps.BASIC_INT_QLT_LIM];
				spi_progressBar.percent = petDyVo.fightAttrs[TypeProps.BASIC_SPI_QLT]/petDyVo.fightAttrs[TypeProps.BASIC_SPI_QLT_LIM];
				_mc.progressTxt.spiTxt.text = petDyVo.fightAttrs[TypeProps.BASIC_SPI_QLT]+"/"+petDyVo.fightAttrs[TypeProps.BASIC_SPI_QLT_LIM];
			
				if(petDyVo.dyId == PetDyManager.Instance.getFightPetId()){
					fight_button.clearCDUpdate();
					fight_button.label = "休息";
					fight_button.enabled = true;
				}
				else{
					fight_button.label = "出战";
					fight_button.resetCD();
				}
				
				if(petDyVo.potential==0)	recommand_button.enabled = false;
				else	recommand_button.enabled = true;
				
				_petWindow._bitmapClip.visible = true;
				
				for(i=0;i<petDyVo.enhanceLv;i++){
					var starMC:MovieClip = ClassInstance.getInstance("pet.star");
					starMC.x=i*16;
					_mc.starImg.addChild(starMC);
				}
				
				if(release_button.enabled==false){
					release_button.enabled = true;
					confirm_button.enabled = true;
					rename_button.enabled = true;
					combine_button.enabled = true;
					enhance_button.enabled = true;
					learn_button.enabled = true;
					forget_button.enabled = true;
					comfort_button.resetCD();
					feed_button.resetCD();
					UI.setEnable(left_button,true);
					UI.setEnable(right_button,true);
					
					for(i=0;i<addArr.length;i++){
						addArr[i].enableBtns();
					}
				}
			}else{
				release_button.enabled = false;
				confirm_button.enabled = false;
				fight_button.enabled = false;
				recommand_button.enabled = false;
				rename_button.enabled = false;
				combine_button.enabled = false;
				enhance_button.enabled = false;
				learn_button.enabled = false;
				forget_button.enabled = false;
				comfort_button.enabled = false;
				feed_button.enabled=false;
				UI.setEnable(left_button,false);
				UI.setEnable(right_button,false);
				
				_petWindow._bitmapClip.visible=false;
				
				_mc.potentialTxt.text = "潜力 ：";
				_mc.add3.num.text = "体质：";
				_mc.add0.num.text = "力量：";
				_mc.add1.num.text = "敏捷：";
				_mc.add2.num.text = "智力：";
				_mc.add4.num.text = "精神：";
				
				_mc.petTypeTxt.text = "宠物类型：";
				_mc.petLvTxt.text = "Lv : ";
				_mc.attTxt.text = "物理攻击：";
				_mc.magicTxt.text = "魔法攻击：";
				_mc.defTxt.text = "物理防御：";
				_mc.magicDefTxt.text = "魔法防御：";
				_mc.growTxt.text = "成长率：";
				_mc.petNameTxt.text = "";
				_mc.powerTxt.text = "战斗力 ：";
				
				hp_progressBar.percent = 0;
				_mc.progressTxt.hpTxt.text = "";
				
				happy_progressBar.percent = 0;
				_mc.progressTxt.happyTxt.text = "";
				
				exp_progressBar.percent = 0;
				_mc.progressTxt.expTxt.text = "";
				
				phy_progressBar.percent = 0;
				_mc.progressTxt.phyTxt.text = "";
				str_progressBar.percent = 0;
				_mc.progressTxt.strTxt.text = "";
				agi_progressBar.percent = 0;
				_mc.progressTxt.agiTxt.text = "";
				int_progressBar.percent = 0;
				_mc.progressTxt.intTxt.text = "";
				spi_progressBar.percent = 0;
				_mc.progressTxt.spiTxt.text = "";
				
				for(i=0;i<addArr.length;i++){
					addArr[i].disableBtns();
				}
				
				_petWindow._bitmapClip.visible = false;
			}
		}
		
		/**Disable喂养按钮和驯养按钮CD
		 */		
		public function CDBtn():void{
			comfort_button.disableAndAbleLater(PropsBasicManager.Instance.getPropsBasicVo(PropsBasicManager.Instance.getAllBasicVoByType(TypeProps.BIG_PROPS_TYPE_COMFORT)[0].template_id).cd_time);
			feed_button.disableAndAbleLater(PropsBasicManager.Instance.getPropsBasicVo(PropsBasicManager.Instance.getAllBasicVoByType(TypeProps.BIG_PROPS_TYPE_FEED)[0].template_id).cd_time);
		}
		
		/**更新宠物名称 
		 */		
		public function updateName():void{
			_mc.petNameTxt.text = PetDyManager.Instance.getCrtPetDyVo().roleName;
		}
	
		/**更新宠物快乐度 
		 */		
		public function updateHappy():void{
			happy_progressBar.percent = PetDyManager.Instance.getCrtPetDyVo().happy/100;
			_mc.progressTxt.happyTxt.text = PetDyManager.Instance.getCrtPetDyVo().happy+"/100";
		}
		
		/**宠物收回更新 
		 */		
		public function updateTakeBack():void{
			updatePetList();
			fight_button.label = "出战";
			fight_button.disableAndAbleLater(15000);
			fight_button.startCDUpdate();
		}
		
		/**宠物出战更新 
		 */		
		public function updateFightPet():void{
			updatePetList();
			fight_button.disableAndAbleLater(15000);
			fight_button.clearCDUpdate();
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
		
		public function updateHp():void{
			var pet:PetDyVo = PetDyManager.Instance.getCrtPetDyVo();
			hp_progressBar.percent = pet.fightAttrs[TypeProps.HP] / pet.fightAttrs[TypeProps.HP_LIMIT];
			_mc.progressTxt.hpTxt.text = int(pet.fightAttrs[TypeProps.HP])+ "/"+ int(pet.fightAttrs[TypeProps.HP_LIMIT]);
		}
		
		public function updateExp():void{
			var pet:PetDyVo = PetDyManager.Instance.getCrtPetDyVo();
			exp_progressBar.percent = pet.exp/PetLevelXpManager.Instance.getXp(pet.level);
			_mc.progressTxt.expTxt.text = pet.exp + "/" + PetLevelXpManager.Instance.getXp(pet.level);
		}
		
		
		public function getPotential():int{
			return _potential;
		}
		
		public function addPotential(p:int):void{
			_potential += p;
		}
		
		public function updatePotential():void{
			_mc.potentialTxt.text = "潜力 ："+_potential;
		}

		private function onRelease(e:MouseEvent):void{
			var txt:String = "确定要放生"+PetDyManager.Instance.getCrtPetDyVo().roleName+"吗？放生后，宠物将永久消失";
			Alert.show(txt,'放生宠物',onReleaseConfirm,["确认","取消"]);
		}
		
		private function onReleaseConfirm(e:AlertCloseEvent):void{
			if(e.clickButtonIndex==1){
				var msg:PetRequest = new PetRequest();
				msg.petId = PetDyManager.crtPetId;
				YFEventCenter.Instance.dispatchEventWith(PetEvent.ReleaseReq,msg);
			}
		}
		
		private function onFight(e:MouseEvent):void{
			var msg:PetRequest = new PetRequest();
			msg.petId = PetDyManager.crtPetId;
			if(PetDyManager.crtPetId!=PetDyManager.Instance.getFightPetId()){
				if(PetDyManager.Instance.getCrtPetDyVo().happy<60)	NoticeUtil.setOperatorNotice("快乐度不足，无法出战");
				else	YFEventCenter.Instance.dispatchEventWith(PetEvent.FightPetReq,msg);
			}
			else{
				YFEventCenter.Instance.dispatchEventWith(PetEvent.TakeBackReq,msg);
			}
		}
		
		private function onLeft(e:MouseEvent):void{
			_petWindow._bitmapClip.turnLeft();
		}
		
		private function onRight(e:MouseEvent):void{
			_petWindow._bitmapClip.turnRight();
		}
		
		private function onCombine(e:MouseEvent):void{
			_petWindow.switchTab(2);
		}
		
		private function onEnhance(e:MouseEvent):void{
			_petWindow.switchTab(3);
		}
		
		private function onLearn(e:MouseEvent):void{
			_petWindow.switchTab(5);
		}
		
		private function onForget(e:MouseEvent):void{
			if(_skillId==-1)
				NoticeUtil.setOperatorNotice("请先选择要遗忘的技能!");
			else
				Alert.show("确定要让["+PetDyManager.Instance.getCrtPetDyVo().roleName+"]遗忘技能吗？技能遗忘后，将永久消失。","遗忘技能",onForgetAlert,["确认","取消"]);
		}
		
		private function onForgetAlert(e:AlertCloseEvent):void{
			if(e.clickButtonIndex==1){
				var msg:CPetForgetSkill = new CPetForgetSkill();	
				msg.petId = PetDyManager.crtPetId;
				msg.skillId = _skillId;
				YFEventCenter.Instance.dispatchEventWith(PetEvent.ForgetSkillReq,msg);
			}
		}
		
		private function onRecommand(e:MouseEvent):void{
			for(var i:int=0;i<addArr.length;i++){
				addArr[i].clearContent();
			}
			
			_potential = PetDyManager.Instance.getCrtPetDyVo().potential;
			updatePotential();
			if(_potential>=5){
				var mul:int = int(_potential/5);

				addArr[3].onAdd(mul*PetBasicManager.Instance.getPetConfigVo(PetDyManager.Instance.getCrtPetDyVo().basicId).phy_add);
				addArr[0].onAdd(mul*PetBasicManager.Instance.getPetConfigVo(PetDyManager.Instance.getCrtPetDyVo().basicId).str_add);
				addArr[1].onAdd(mul*PetBasicManager.Instance.getPetConfigVo(PetDyManager.Instance.getCrtPetDyVo().basicId).agi_add);
				addArr[2].onAdd(mul*PetBasicManager.Instance.getPetConfigVo(PetDyManager.Instance.getCrtPetDyVo().basicId).int_add);
				addArr[4].onAdd(mul*PetBasicManager.Instance.getPetConfigVo(PetDyManager.Instance.getCrtPetDyVo().basicId).spi_add);
			}
		}
		
		private function onConfirm(e:MouseEvent):void{
			var msg:CPetAddPoint = new CPetAddPoint();
			msg.petId = PetDyManager.crtPetId;
			
			for(var i:int=0;i<addArr.length;i++){
				var attr:AttrInfo = new AttrInfo();
				attr.attrId = TypeProps.BASIC_STR+i;
				attr.attrValue = addArr[i].getPoints();
				msg.addProps.push(attr);
			}
			YFEventCenter.Instance.dispatchEventWith(PetEvent.AddPointReq,msg);
		}
		
		private function onComfort(e:MouseEvent):void{
			if(PetDyManager.Instance.getCrtPetDyVo().happy==100){
				NoticeUtil.setOperatorNotice("宠物快乐度已满");
			}else if(PropsDyManager.instance.getPropsQuantity(PropsBasicManager.Instance.getAllBasicVoByType(TypeProps.BIG_PROPS_TYPE_COMFORT)[0].template_id)==0){
				NoticeUtil.setOperatorNotice("道具不足，无法驯养");
			}else{
				var msg:CUseItem = new CUseItem();
				msg.petId = PetDyManager.crtPetId;
				msg.itemPos=PropsDyManager.instance.getFirstPropsPos(PropsBasicManager.Instance.getAllBasicVoByType(TypeProps.BIG_PROPS_TYPE_COMFORT)[0].template_id);
				YFEventCenter.Instance.dispatchEventWith(BagEvent.USE_ITEM,msg);
			}
		}
		
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
		
		private function onRename(e:MouseEvent):void{
			JInputWindow.Instance().initPanel("宠物改名","请输入宠物名称",onRenameOK,"");
		}
		
		private function onRenameOK():void{
			var msg:CPetRenameReq = new CPetRenameReq();
			msg.petId = PetDyManager.crtPetId;
			msg.name = JInputWindow.Instance().getInputText();
			YFEventCenter.Instance.dispatchEventWith(PetEvent.RenameReq,msg);
			JInputWindow.Instance().close();
			JInputWindow.Instance().dispose();
		}
		
		private function onSelSkill(e:YFEvent):void{
			skillsCollection.setFilter((e.param as SkillGrid).getIndex());
			_skillId = (e.param as SkillGrid).getSkillId();
		}
	}
} 