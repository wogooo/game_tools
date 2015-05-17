package com.YFFramework.game.core.module.pet.view
{
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.net.loader.image_swf.IconLoader;
	import com.YFFramework.core.utils.URLTool;
	import com.YFFramework.core.utils.common.ClassInstance;
	import com.YFFramework.game.core.global.DataCenter;
	import com.YFFramework.game.core.global.manager.PetBasicManager;
	import com.YFFramework.game.core.global.model.PetBasicVo;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.module.pet.events.PetEvent;
	import com.YFFramework.game.core.module.pet.manager.PetDyManager;
	import com.YFFramework.game.core.module.pet.model.PetDyVo;
	import com.YFFramework.game.core.module.pet.view.collection.PetsCollection;
	import com.YFFramework.game.core.module.pet.view.grid.PetItem;
	import com.dolo.ui.controls.Button;
	import com.dolo.ui.controls.VScrollBar;
	import com.dolo.ui.tools.AutoBuild;
	import com.dolo.ui.tools.Xdis;
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
		
		private var _secPetId:int=-1;
		
		public function PetInheritPanel(mc:MovieClip){
			_mc = mc;
			AutoBuild.replaceAll(_mc);
			
			inherit_button = Xdis.getChildAndAddClickEvent(onInherit,_mc,"inherit_button");
			
			petsCollection=new PetsCollection(5,30);
			petsCollection.init();
			_mc.addChild(petsCollection);
			
			petScrollbar = Xdis.getChild(_mc,"mainPet_vScrollBar");
			petScrollbar.setTarget(petsCollection,false,160,235);
			petScrollbar.updateSize(30*48+10);
			_mc.addChild(petScrollbar);
			
			secPetsCollection = new PetsCollection(5,295);
			_mc.addChild(secPetsCollection);
			
			secPetsScrollbar = Xdis.getChild(_mc,"secPet_vScrollBar");
			_mc.addChild(secPetsScrollbar);
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
			
			_secPetId = petItem.getPetDyVo().dyId;
			secPetsCollection.setFilter(petItem.getIndex());

			IconLoader.initLoader(PetBasicManager.Instance.getShowURL(petItem.getPetDyVo().basicId),_mc.secPetImg);
			
			updateInheritBtn();
		}
		
		public function updatePetList():void{
			_mc.mainPetTxt.text="宠物列表("+PetDyManager.Instance.getPetListSize()+"/"+PetDyManager.Instance.getPetOpenSlots()+")";
			petsCollection.openSlot();
			petsCollection.clearPetContent();
			petsCollection.loadContent();
		}
		
		public function updateCrtPetGrid():void{
			clearCrtPetGrid();
			
			if(PetDyManager.crtPetId!=-1){
				var petBasic:PetBasicVo = PetBasicManager.Instance.getPetConfigVo(PetDyManager.Instance.getCrtPetDyVo().basicId);
				IconLoader.initLoader(URLTool.getMonsterIcon(petBasic.show_id),_mc.mainPetImg);
				IconLoader.initLoader(URLTool.getMonsterIcon(petBasic.show_id),_mc.inheritImg);
				
				updateMoneyTxt();
			}
		}
		
		public function updateMoneyTxt():void{
			_mc.moneyTxt.text = "消耗银锭：50000";
			if(DataCenter.Instance.roleSelfVo.note<50000)	_mc.moneyTxt.textColor = TypeProps.RED;
			else	_mc.moneyTxt.textColor = TypeProps.Cfff3a5;
			updateInheritBtn();
		}
		
		public function updateInheritBtn():void{
			if(DataCenter.Instance.roleSelfVo.note<50000 || _secPetId==-1)	inherit_button.enabled = false;
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
			for(var i:int=0;i<petIdArr.length;i++){
				var petDyVo:PetDyVo = PetDyManager.Instance.getPetDyVo(petIdArr[i]); 
				if(petDyVo.dyId!=PetDyManager.crtPetId){
					secPetsCollection.addPet(petDyVo);
				}
			}
			secPetsScrollbar.setTarget(secPetsCollection,false,160,150);
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
				YFEventCenter.Instance.dispatchEventWith(PetEvent.InheritReq,msg);
			}
		}
	}
} 