package com.YFFramework.game.core.module.pet.view
{
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.net.loader.image_swf.IconLoader;
	import com.YFFramework.core.ui.layer.LayerManager;
	import com.YFFramework.core.utils.URLTool;
	import com.YFFramework.core.utils.common.ClassInstance;
	import com.YFFramework.game.core.global.manager.ConstMapBasicManager;
	import com.YFFramework.game.core.global.manager.PetBasicManager;
	import com.YFFramework.game.core.global.manager.PropsBasicManager;
	import com.YFFramework.game.core.global.manager.PropsDyManager;
	import com.YFFramework.game.core.global.manager.SkillBasicManager;
	import com.YFFramework.game.core.global.model.PetBasicVo;
	import com.YFFramework.game.core.global.util.NoticeUtil;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.module.pet.events.PetEvent;
	import com.YFFramework.game.core.module.pet.manager.PetDyManager;
	import com.YFFramework.game.core.module.pet.model.PetDyVo;
	import com.YFFramework.game.core.module.pet.view.collection.ItemsCollection;
	import com.YFFramework.game.core.module.pet.view.collection.PetsCollection;
	import com.YFFramework.game.core.module.pet.view.collection.SkillsCollection;
	import com.YFFramework.game.core.module.pet.view.grid.Item;
	import com.YFFramework.game.core.module.pet.view.grid.PetItem;
	import com.dolo.ui.controls.Button;
	import com.dolo.ui.controls.VScrollBar;
	import com.dolo.ui.tools.AutoBuild;
	import com.dolo.ui.tools.Xdis;
	import com.msg.pets.CPetLearnSkill;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	/**
	 * @version 1.0.0
	 * creation time：2013-3-8 下午2:57:07
	 * 宠物技能学习面板
	 */
	public class PetLearnPanel
	{
		private var _mc:MovieClip;
		
		private var petsCollection:PetsCollection;
		private var petScrollbar:VScrollBar;
		
		private var itemsCollection:ItemsCollection;
		private var itemScrollbar:VScrollBar;
		
		private var skillsCollection:SkillsCollection;
		
		private var learn_button:Button;
		
		private var _itemTempId:int;
		private var _skillbooks:Array;
		
		public function PetLearnPanel(mc:MovieClip){
			_mc = mc;
			
			AutoBuild.replaceAll(_mc);
			learn_button = Xdis.getChild(_mc,"learn_button");
			learn_button.addEventListener(MouseEvent.CLICK,onLearn);
			learn_button.enabled = false;
			
			petsCollection=new PetsCollection(5,30);
			petsCollection.init();
			_mc.addChild(petsCollection);
			
			petScrollbar = Xdis.getChild(_mc,"mainPet_vScrollBar");
			petScrollbar.setTarget(petsCollection,false,160,235);
			petScrollbar.updateSize(30*48+10);
			_mc.addChild(petScrollbar);
			
			skillsCollection = new SkillsCollection();
			
			itemsCollection = new ItemsCollection(5,300);
			_mc.addChild(itemsCollection);
			
			itemScrollbar = Xdis.getChild(_mc,"item_vScrollBar");
			itemScrollbar.setTarget(itemsCollection,false,160,160);
			_mc.addChild(itemScrollbar);
			
			YFEventCenter.Instance.addEventListener(PetEvent.Select_Item,onSelectItem);
		}

		public function onTabUpdate():void{
			clearItemImg();
			updatePetList();
			updateCrtPetGrid();
			updateSkills();
			updateItem();
		}
		
		public function onSelectUpdate(petItem:PetItem):void{
			petsCollection.setFilter(petItem.getIndex());
			updateCrtPetGrid();
			updateSkills();
			itemsCollection.setFilter(-1);
			clearItemImg();
			learn_button.enabled = false;
		}
		
		private function onSelectItem(e:YFEvent):void{
			var item:Item = e.param as Item;
			itemsCollection.setFilter(item.getIndex());
			clearItemImg();
			updateItemImg(item.getTemplateId());
			_itemTempId = item.getTemplateId();
			learn_button.enabled = true;
		}
		
		public function updatePetList():void{
			_mc.petTxt.text="宠物列表("+PetDyManager.Instance.getPetListSize()+"/"+PetDyManager.Instance.getPetOpenSlots()+")";
			petsCollection.openSlot();
			petsCollection.clearPetContent();
			petsCollection.loadContent();
		}
		
		public function updateCrtPetGrid():void{
			clearCrtPetGrid();
			
			if(PetDyManager.crtPetId!=-1){
				var petBasic:PetBasicVo = PetBasicManager.Instance.getPetConfigVo(PetDyManager.Instance.getCrtPetDyVo().basicId);
				IconLoader.initLoader(URLTool.getMonsterIcon(petBasic.show_id),_mc.petImg);
			}
		}
		
		private function clearCrtPetGrid():void{
			if(_mc.petImg.numChildren>0)	_mc.petImg.removeChildAt(0);
		}

		/**
		 * 更新Item Grid图标
		 **/
		private function updateItemImg(templateId:int):void{
			IconLoader.initLoader(PropsBasicManager.Instance.getURL(templateId),_mc.itemImg);
		}
		
		/**
		 * 清除Item Grid图标
		 **/
		public function clearItemImg():void{
			if(_mc.itemImg.numChildren>0)	_mc.itemImg.removeChildAt(0);
		}
		
		/**
		 * 更新Item区
		 **/
		public function updateItem():void{
			itemsCollection.clearItem();
			_skillbooks = PropsBasicManager.Instance.getAllBasicVoByType(TypeProps.BIG_PROPS_TYPE_SKILLBOOK);
			itemsCollection.loadDyContent(_skillbooks,true);
			itemScrollbar.updateSize(itemsCollection.numChildren*48+10);
		}
		
		/**
		 * 更新Skill区
		 **/
		public function updateSkills():void{
			skillsCollection.clearSkillGrid();
			skillsCollection.loadContent(false,_mc);
		}
		
		private function onLearn(e:MouseEvent):void{
			var petDyVo:PetDyVo = PetDyManager.Instance.getCrtPetDyVo();
			var skillArr:Array = petDyVo.skillAttrs;
			var sendMsg:Boolean = true;
			var learnId:int = PropsBasicManager.Instance.getPropsBasicVo(_itemTempId).skill_id;
			var learnLv:int = PropsBasicManager.Instance.getPropsBasicVo(_itemTempId).skill_level;
			if((skillArr.length-1)>=petDyVo.skillOpenSlots){
				NoticeUtil.setOperatorNotice("宠物没有空技能格，无法学习!");
			}
			else{
				for(var i:int=0;i<skillArr.length;i++){
					if(skillArr[i].skillId==learnId){
						if(skillArr[i].skillLevel>=learnLv){
							NoticeUtil.setOperatorNotice("已有该技能，无需再学习!");
							sendMsg = false;
						}else{
							sendMsg = true;
						}
						break;
					}
				}
				if(sendMsg==true){
					var msg:CPetLearnSkill = new CPetLearnSkill();
					msg.petId = petDyVo.dyId;
					msg.skillbookPos = PropsDyManager.instance.getFirstPropsPos(_itemTempId);
					YFEventCenter.Instance.dispatchEventWith(PetEvent.LearnReq,msg);
				}	
			}
		}
	}
} 