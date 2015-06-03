package com.YFFramework.game.core.module.pet.view
{
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.net.loader.image_swf.IconLoader;
	import com.YFFramework.core.utils.common.ArrayUtil;
	import com.YFFramework.core.utils.common.ClassInstance;
	import com.YFFramework.game.core.global.DataCenter;
	import com.YFFramework.game.core.global.manager.PetBasicManager;
	import com.YFFramework.game.core.global.model.PetBasicVo;
	import com.YFFramework.game.core.global.util.NoticeUtil;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.module.autoSetting.view.SkillGrid;
	import com.YFFramework.game.core.module.pet.events.PetEvent;
	import com.YFFramework.game.core.module.pet.manager.PetDyManager;
	import com.YFFramework.game.core.module.pet.model.PetDyVo;
	import com.YFFramework.game.core.module.pet.view.collection.PetsCollection;
	import com.YFFramework.game.core.module.pet.view.grid.PetItem;
	import com.YFFramework.game.core.module.pet.view.grid.PetSkillGrid;
	import com.YFFramework.game.gameConfig.URLTool;
	import com.dolo.ui.controls.Button;
	import com.dolo.ui.controls.VScrollBar;
	import com.dolo.ui.tools.AutoBuild;
	import com.dolo.ui.tools.Xdis;
	import com.msg.common.SkillInfo;
	import com.msg.pets.CInheritPet;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	/**
	 * @version 1.0.0
	 * creation time：2013-3-8 下午2:57:07
	 * 宠物继承面板
	 */
	public class PetInheritPanel{
		
		private var _mc:MovieClip;
		
		private var petsCollection:PetsCollection;
		private var petScrollbar:VScrollBar;
		
		private var secPetsCollection:PetsCollection;
		private var secPetsScrollbar:VScrollBar;
		
		private var inherit_button:Button;
		private var oldSkillMCArr:Array=new Array();
		private var skillIndex:int;
		
		private var _secPetId:int=-1;
		private var skillArr:Array=new Array(8);
		private var _skillOpenSlot:int;
		
		public function PetInheritPanel(mc:MovieClip){
			_mc = mc;
			AutoBuild.replaceAll(_mc);
			
			inherit_button = Xdis.getChildAndAddClickEvent(onInherit,_mc,"inherit_button");
			
			petsCollection=new PetsCollection(0,30);
			petsCollection.init();
			_mc.addChild(petsCollection);
			
			petScrollbar = Xdis.getChild(_mc,"mainPet_vScrollBar");
			petScrollbar.setTarget(petsCollection,false,160,260);
			petScrollbar.updateSize(30*49+10);
			_mc.addChild(petScrollbar);
			
			secPetsCollection = new PetsCollection(0,320);
			_mc.addChild(secPetsCollection);
			
			secPetsScrollbar = Xdis.getChild(_mc,"secPet_vScrollBar");
			_mc.addChild(secPetsScrollbar);
			
			YFEventCenter.Instance.addEventListener(PetEvent.Select_Inherit_Skill,onInheritSkill);
		}
		
		private function onInheritSkill(e:YFEvent):void{
			var skillGrid:PetSkillGrid = e.param as PetSkillGrid;
			if(skillGrid.getSelected()==false){
				var len:int = skillArr.length;
				for(var i:int=0;i<len;i++){
					if(skillArr[i]){
						if(skillArr[i].getSkillId()==skillGrid.getSkillId()){
							skillArr[i].dispose();
							skillArr[i] = null;
							break;
						}	
					}
				}
			}
			else{
				if(!containsSkill(skillGrid.getSkillId())){
					len = _skillOpenSlot;
					var hasAdded:Boolean=false;
					for(i=0;i<len;i++){
						if(skillArr[i]==null){
							skillArr[i] = new PetSkillGrid(i,false,false,_mc["ii"+i],skillGrid.getSkillId(),skillGrid.getSkillLv(),false);
							hasAdded = true;
							break;
						}
					}
					if(!hasAdded){
						skillGrid.setSelect(false);
					}
				}else{
					skillGrid.setSelect(false);
				}
			}
		}
		
		private function containsSkill(skillId:int):Boolean{
			var len:int = skillArr.length;
			for(var i:int=0;i<len;i++){
				if(skillArr[i] && skillArr[i].getSkillId()==skillId){
					return true;
				}
			}
			return false;
		}
		
		public function onTabUpdate():void{			
			updatePetList();
			updateCrtPetGrid();
			updateSecPetList();
		}
		
		public function onSelectUpdate(petItem:PetItem):void{
			petsCollection.setFilter(petItem.getIndex());
			secPetsCollection.setFilter(-1);
			updateCrtPetGrid();
			updateSecPetList();
			_secPetId = -1;
		}
		
		public function onSecSelectUpdate(petItem:PetItem):void{
			clearSecPetGrid();
			clearSecSkillGrids();
			_secPetId = petItem.getPetDyVo().dyId;
			secPetsCollection.setFilter(petItem.getIndex());
			
			IconLoader.initLoader(PetBasicManager.Instance.getShowURL(petItem.getPetDyVo().basicId),_mc.secPetImg);
			
			var petVo:PetDyVo = PetDyManager.Instance.getPetDyVo(_secPetId);
			var arr:Array = petVo.skillAttrs;
			var len:int = arr.length;
			var secIndex:int=skillIndex;
			for(var i:int=0;i<len;i++){
				if(arr[i].skillId!=petVo.defaultSkillId){
					var skillGrid:PetSkillGrid = new PetSkillGrid(i,false,true,_mc["i"+secIndex],arr[i].skillId,arr[i].skillLevel,true);
					oldSkillMCArr.push(skillGrid);
					secIndex++;
				}
			}
			
			if(petVo.skillOpenSlots>_skillOpenSlot){
				clearFinalSkillGrid();
				
				for(i=petVo.skillOpenSlots;i<8;i++){
					skillArr[i] = new PetSkillGrid(i,true,false,_mc["ii"+i]);
				}
				_skillOpenSlot = petVo.skillOpenSlots;
			}
			
			_mc.t0.text = "新宠资质";
			var crtPetVo:PetDyVo = PetDyManager.Instance.getCrtPetDyVo();
			if(crtPetVo.fightAttrs[TypeProps.BA_PHYSIQUE_APT]>petVo.fightAttrs[TypeProps.BA_PHYSIQUE_APT]){
				_mc.t1.text="体质资质："+crtPetVo.fightAttrs[TypeProps.BA_PHYSIQUE_APT]+"/"+crtPetVo.fightAttrs[TypeProps.BA_PHY_QLT_LIM];
			}else{
				_mc.t1.text="体质资质："+petVo.fightAttrs[TypeProps.BA_PHYSIQUE_APT]+"/"+petVo.fightAttrs[TypeProps.BA_PHY_QLT_LIM];
			}
			if(crtPetVo.fightAttrs[TypeProps.BA_STRENGTH_APT]>petVo.fightAttrs[TypeProps.BA_STRENGTH_APT]){
				_mc.t2.text="力量资质："+crtPetVo.fightAttrs[TypeProps.BA_STRENGTH_APT]+"/"+crtPetVo.fightAttrs[TypeProps.BA_STR_QLT_LIM];
			}else{
				_mc.t2.text="力量资质："+petVo.fightAttrs[TypeProps.BA_STRENGTH_APT]+"/"+petVo.fightAttrs[TypeProps.BA_STR_QLT_LIM];
			}
			if(crtPetVo.fightAttrs[TypeProps.BA_AGILE_APT]>petVo.fightAttrs[TypeProps.BA_AGILE_APT]){
				_mc.t3.text="敏捷资质："+crtPetVo.fightAttrs[TypeProps.BA_AGILE_APT]+"/"+crtPetVo.fightAttrs[TypeProps.BA_AGI_QLT_LIM];
			}else{
				_mc.t3.text="敏捷资质："+petVo.fightAttrs[TypeProps.BA_AGILE_APT]+"/"+petVo.fightAttrs[TypeProps.BA_AGI_QLT_LIM];
			}
			if(crtPetVo.fightAttrs[TypeProps.BA_INTELLIGENCE_APT]>petVo.fightAttrs[TypeProps.BA_INTELLIGENCE_APT]){
				_mc.t4.text="智力资质："+crtPetVo.fightAttrs[TypeProps.BA_INTELLIGENCE_APT]+"/"+crtPetVo.fightAttrs[TypeProps.BA_INT_QLT_LIM];
			}else{
				_mc.t4.text="智力资质："+petVo.fightAttrs[TypeProps.BA_INTELLIGENCE_APT]+"/"+petVo.fightAttrs[TypeProps.BA_INT_QLT_LIM];
			}
			if(crtPetVo.fightAttrs[TypeProps.BA_SPIRIT_APT]>petVo.fightAttrs[TypeProps.BA_SPIRIT_APT]){
				_mc.t5.text="精神资质："+crtPetVo.fightAttrs[TypeProps.BA_SPIRIT_APT]+"/"+crtPetVo.fightAttrs[TypeProps.BA_SPI_QLT_LIM];
			}else{
				_mc.t5.text="精神资质："+petVo.fightAttrs[TypeProps.BA_SPIRIT_APT]+"/"+petVo.fightAttrs[TypeProps.BA_SPI_QLT_LIM];
			}
			
			updateInheritBtn();
		}
		
		private function clearSecSkillGrids():void{
			for(var i:int=skillIndex;i<oldSkillMCArr.length;i++){
				oldSkillMCArr[i].dispose();
				oldSkillMCArr.splice(i,1);
				i--;
			}
		}
		
		public function updatePetList():void{
			_mc.mainPetTxt.text="宠物列表("+PetDyManager.Instance.getPetListSize()+"/"+PetDyManager.petOpenSlots+")";
			petsCollection.openSlot();
			petsCollection.clearPetContent();
			petsCollection.loadContent();
		}
		
		public function updateCrtPetGrid():void{
			clearCrtPetGrid();
			clearSkillGrid();
			clearFinalSkillGrid();
			
			if(PetDyManager.crtPetId!=-1){
				var petBasic:PetBasicVo = PetBasicManager.Instance.getPetConfigVo(PetDyManager.Instance.getCrtPetDyVo().basicId);
				IconLoader.initLoader(URLTool.getMonsterIcon(petBasic.show_id),_mc.mainPetImg);
				IconLoader.initLoader(URLTool.getMonsterIcon(petBasic.show_id),_mc.inheritImg);
				
				var petDyVo:PetDyVo = PetDyManager.Instance.getCrtPetDyVo();
				var arr:Array = petDyVo.skillAttrs;
				var len:int = arr.length;
				skillIndex=0;
				for(var i:int=0;i<len;i++){
					if(arr[i].skillId!=petDyVo.defaultSkillId){
						var skillGrid:PetSkillGrid = new PetSkillGrid(i,false,true,_mc["i"+i],arr[i].skillId,arr[i].skillLevel,true);
						oldSkillMCArr.push(skillGrid);
						skillIndex++;
					}
				}
				
				for(i=petDyVo.skillOpenSlots;i<8;i++){
					skillArr[i] = new PetSkillGrid(i,true,false,_mc["ii"+i]);
				}
				_skillOpenSlot = petDyVo.skillOpenSlots;
				
				updateMoneyTxt();
			}
			for(i=0;i<6;i++){
				_mc["t"+i].text="";
			}
		}
		
		private function clearFinalSkillGrid():void{
			var len:int = skillArr.length;
			for(var i:int=0;i<len;i++){
				if(skillArr[i]){
					skillArr[i].dispose();
					skillArr[i] = null;
				}
			}
		}
		
		private function clearSkillGrid():void{
			var len:int = oldSkillMCArr.length;
			for(var i:int=0;i<len;i++){
				oldSkillMCArr[i].dispose();
			}
			oldSkillMCArr = new Array();
		}
		
		public function updateMoneyTxt():void{
			_mc.moneyTxt.text = "消耗银锭：1000";
			if(DataCenter.Instance.roleSelfVo.note<1000)	_mc.moneyTxt.textColor = TypeProps.COLOR_RED;
			else	_mc.moneyTxt.textColor = TypeProps.Cfff3a5;
			updateInheritBtn();
		}
		
		public function updateInheritBtn():void{
			if(DataCenter.Instance.roleSelfVo.note<1000 || _secPetId==-1)	inherit_button.enabled = false;
			else	inherit_button.enabled = true;
		}
		
		private function clearCrtPetGrid():void{
			if(_mc.mainPetImg.numChildren>0)
				_mc.mainPetImg.removeChildAt(0);
			if(_mc.inheritImg.numChildren>0)
				_mc.inheritImg.removeChildAt(0);
			_mc.moneyTxt.text = "";
		}
		
		public function updateSecPetList():void{
			clearSecPetGrid();
			secPetsCollection.clearPetItem();
			
			var petIdArr:Array = PetDyManager.Instance.getPetIdArray();
			var len:int=petIdArr.length;
			for(var i:int=0;i<len;i++){
				var petDyVo:PetDyVo = PetDyManager.Instance.getPetDyVo(petIdArr[i]); 
				if(petDyVo.dyId!=PetDyManager.crtPetId){
					secPetsCollection.addPet(petDyVo);
				}
			}
			secPetsScrollbar.setTarget(secPetsCollection,false,160,110);
			secPetsScrollbar.updateSize(secPetsCollection.numChildren*48+10);
			secPetsScrollbar.scrollToPosition(0);
			
			inherit_button.enabled=false;
		}
		
		private function clearSecPetGrid():void{
			if(_mc.secPetImg.numChildren>0)
				_mc.secPetImg.removeChildAt(0);
		}
		
		private function onInherit(e:MouseEvent):void{
			if(PetDyManager.crtPetId!=-1 && _secPetId!=-1){
				var msg:CInheritPet = new CInheritPet();
				msg.mainPetId = PetDyManager.crtPetId;
				msg.deputyPetId = _secPetId;
				msg.keepSkills = new Array();
				var skill:SkillInfo;
				var len:int = skillArr.length;
				for(var i:int=0;i<len;i++){
					if(skillArr[i] && skillArr[i].getSkillId()!=0){
						skill= new SkillInfo();
						skill.skillId = skillArr[i].getSkillId();
						skill.skillLevel = skillArr[i].getSkillLv();
						msg.keepSkills.push(skill);
					}
				}
				YFEventCenter.Instance.dispatchEventWith(PetEvent.InheritReq,msg);
			}
		}
	}
} 