package com.YFFramework.game.core.module.pet.view
{
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.net.loader.image_swf.IconLoader;
	import com.YFFramework.core.utils.URLTool;
	import com.YFFramework.core.utils.common.ClassInstance;
	import com.YFFramework.game.core.global.manager.ConstMapBasicManager;
	import com.YFFramework.game.core.global.manager.PetBasicManager;
	import com.YFFramework.game.core.global.manager.PropsBasicManager;
	import com.YFFramework.game.core.global.manager.PropsDyManager;
	import com.YFFramework.game.core.global.manager.SkillBasicManager;
	import com.YFFramework.game.core.global.model.PetBasicVo;
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
	import com.msg.pets.PetRequest;
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;

	/**
	 * @version 1.0.0
	 * creation time：2013-3-8 下午2:57:07
	 * 
	 */
	public class PetComprePanel
	{
		private var _mc:MovieClip;
		
		private var petsCollection:PetsCollection;
		private var petScrollbar:VScrollBar;
		
		private var itemsCollection:ItemsCollection;
		private var itemScrollbar:VScrollBar;
		
		private var skillsCollection:SkillsCollection;
		
		private var comprehend_button:Button;
	
		public function PetComprePanel(mc:MovieClip){
			_mc = mc;
			AutoBuild.replaceAll(_mc);
			comprehend_button = Xdis.getChild(_mc,"comprehend_button");
			comprehend_button.addEventListener(MouseEvent.CLICK,onComprehend);

			petsCollection=new PetsCollection(5,30);
			petsCollection.init();
			_mc.addChild(petsCollection);
			
			petScrollbar = Xdis.getChild(_mc,"mainPet_vScrollBar");
			petScrollbar.setTarget(petsCollection,false,160,235);
			petScrollbar.updateSize(30*48+10);
			_mc.addChild(petScrollbar);
			
			itemsCollection = new ItemsCollection(5,300);
			_mc.addChild(itemsCollection);
			
			skillsCollection = new SkillsCollection();
			
			itemScrollbar = Xdis.getChild(_mc,"item_vScrollBar");
			itemScrollbar.setTarget(itemsCollection,false,160,160);
			itemScrollbar.updateSize(4*48+10);
			_mc.addChild(itemScrollbar);
		}
		
		public function onTabUpdate():void{
			updatePetList();
			updateCrtPetGrid();
			updateSkills();
			updateItem();
			updateItemGrid();
		}
		
		public function onSelectUpdate(petItem:PetItem):void{
			petsCollection.setFilter(petItem.getIndex());
			updateCrtPetGrid();
			updateSkills();
			updateItem();
			updateItemGrid();
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
			if(_mc.petImg.numChildren>0)
				_mc.petImg.removeChildAt(0);
		}
		
		/**
		 * 更新Item Grid区
		 **/
		public function updateItemGrid():void{
			if(_mc.itemImg.numChildren!=0){
				_mc.itemImg.removeChildAt(0);
			}
			var enableBtn:Boolean = false;
			if(PetDyManager.Instance.getPetListSize()!=0){
				var skillSlots:int = PetDyManager.Instance.getCrtPetDyVo().skillOpenSlots;
				if(skillSlots!=8){
					var com_lv:int = Math.floor(skillSlots/2);
					if(PropsDyManager.instance.getPropsQuantity(ConstMapBasicManager.Instance.getTempId(TypeProps.CONST_ID_PET_COMPREHEND1)+com_lv)!=0){
						IconLoader.initLoader(itemsCollection.getIconURL(com_lv),_mc.itemImg);
						enableBtn=true;
					}
				}
			}
			if(enableBtn==true)
				comprehend_button.enabled = true;
			else
				comprehend_button.enabled = false;
		}
		
		/**
		 * 更新Item区
		 **/
		public function updateItem():void{
			itemsCollection.clearItem();
			itemsCollection.loadContent(ConstMapBasicManager.Instance.getTempId(TypeProps.CONST_ID_PET_COMPREHEND1),ConstMapBasicManager.Instance.getTempId(TypeProps.CONST_ID_PET_COMPREHEND4),false);
		}
		
		/**
		 * 更新Skill区
		 **/
		public function updateSkills():void{
			skillsCollection.clearSkillGrid();
			skillsCollection.loadContent(false,_mc);
		}
		
		private function onComprehend(e:MouseEvent):void{
			var msg:PetRequest = new PetRequest();
			msg.petId = PetDyManager.crtPetId;
			YFEventCenter.Instance.dispatchEventWith(PetEvent.ComprehendReq,msg);
		}
	}
} 