package com.YFFramework.game.core.module.pet.view
{
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.net.loader.image_swf.IconLoader;
	import com.YFFramework.core.utils.URLTool;
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
	import com.dolo.ui.controls.List;
	import com.dolo.ui.controls.VScrollBar;
	import com.dolo.ui.data.ListItem;
	import com.dolo.ui.tools.AutoBuild;
	import com.dolo.ui.tools.Xdis;
	import com.msg.pets.CCombinePet;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	/**
	 * @version 1.0.0
	 * creation time：2013-3-8 下午2:57:07
	 * 宠物融合面板
	 */
	public class PetCombinePanel{
		
		private var _mc:MovieClip;
		
		private var petsCollection:PetsCollection;
		private var petScrollbar:VScrollBar;
		
		private var secPetsCollection:PetsCollection;
		private var secPetsScrollbar:VScrollBar;

		private var combine_button:Button;
		
		private var _secPetId:int=-1;
		private var _maxGrow:Boolean;
		
		//new list------
		private var _mainPetList:List;
		private var _secPetList:List;
		
		public function PetCombinePanel(mc:MovieClip){
			_mc = mc;
			AutoBuild.replaceAll(_mc);
			combine_button = Xdis.getChildAndAddClickEvent(onCombine,_mc,"combine_button");

			petsCollection=new PetsCollection(5,30);
			petsCollection.init();
			_mc.addChild(petsCollection);
			
			secPetsCollection = new PetsCollection(5,295);
			_mc.addChild(secPetsCollection);
			
			petScrollbar = Xdis.getChild(_mc,"mainPet_vScrollBar");
			petScrollbar.setTarget(petsCollection,false,160,235);
			petScrollbar.updateSize(30*48+10);
			_mc.addChild(petScrollbar);
			
			secPetsScrollbar = Xdis.getChild(_mc,"secPet_vScrollBar");
			_mc.addChild(secPetsScrollbar);
		}
		
		public function onTabUpdate():void{			
			updatePetList();
			updateCrtPetGrid();
			updateMoneyTxt();
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
			
			updateCombineBtn();
		}

		public function updatePetList():void{
			_mc.mainPetTxt.text="宠物列表("+PetDyManager.Instance.getPetListSize()+"/"+PetDyManager.Instance.getPetOpenSlots()+")";
			petsCollection.openSlot();
			petsCollection.clearPetContent();
			petsCollection.loadContent();
		}

		public function updateCrtPetGrid():void{
			clearCrtPetGrid();
			
			var crtPetId:int = PetDyManager.crtPetId;
			if(crtPetId!=-1){
				var petDyVo:PetDyVo = PetDyManager.Instance.getCrtPetDyVo();
				var petBasicVo:PetBasicVo = PetBasicManager.Instance.getPetConfigVo(petDyVo.basicId);
				IconLoader.initLoader(URLTool.getMonsterIcon(petBasicVo.show_id),_mc.mainPetImg);
				IconLoader.initLoader(URLTool.getMonsterIcon(petBasicVo.show_id),_mc.combinePetImg);
				
				var grow:Number = petDyVo.fightAttrs[TypeProps.GROWTH];
				if(grow>2.5){
					_mc.growTxt.text = "成长率已满!";
					_maxGrow = true;
				}
				else{
					_mc.growTxt.text = "成长率：" + grow.toFixed(2) + "->";
					switch(PetDyManager.Instance.getGrowQuality(crtPetId)){
						case 1:
							grow += TypeProps.GROWTH_RATE1;
							break;
						case 2:
							grow += TypeProps.GROWTH_RATE2;
							break;
						case 3:
							grow += TypeProps.GROWTH_RATE3;
							break;
						case 4:
							grow += TypeProps.GROWTH_RATE4;
							break;
						case 5:
							grow += TypeProps.GROWTH_RATE5;
							break;
					}
					_mc.growTxt.text += grow.toFixed(2);
				}
			}else{
				_mc.growTxt.text = "";
				_mc.moneyTxt.text = "";
			}
		}
		
		public function updateMoneyTxt():void{
			_mc.moneyTxt.text = "消耗银锭：50000";
			if(DataCenter.Instance.roleSelfVo.note<50000)	_mc.moneyTxt.textColor = TypeProps.RED;
			else	_mc.moneyTxt.textColor = TypeProps.Cfff3a5;
			updateCombineBtn();
		}
		
		public function updateCombineBtn():void{
			if(DataCenter.Instance.roleSelfVo.note<50000 || _maxGrow==true || _secPetId==-1)	combine_button.enabled = false;
			else	combine_button.enabled = true;
		}
		
		private function clearCrtPetGrid():void{
			if(_mc.mainPetImg.numChildren>0)
				_mc.mainPetImg.removeChildAt(0);
			if(_mc.combinePetImg.numChildren>0)
				_mc.combinePetImg.removeChildAt(0);
			_maxGrow=false;
		}
		
		public function updateSecPetList():void{
			clearSecPetGrid();
			secPetsCollection.clearPetItem();
			
			var petIdArr:Array = PetDyManager.Instance.getPetIdArray();
			for(var i:int=0;i<petIdArr.length;i++){
				var petDyVo:PetDyVo = PetDyManager.Instance.getPetDyVo(petIdArr[i]);
				var crtPetId:int = PetDyManager.crtPetId;
				if(petDyVo.dyId!=crtPetId && PetDyManager.Instance.getGrowQuality(petDyVo.dyId)==PetDyManager.Instance.getGrowQuality(crtPetId)){
					secPetsCollection.addPet(petDyVo);
				}
			}
			
			secPetsScrollbar.setTarget(secPetsCollection,false,160,150);
			secPetsScrollbar.updateSize(secPetsCollection.numChildren*48+10);
			secPetsScrollbar.scrollToPosition(0);
			
			combine_button.enabled=false;
		}
		
		private function clearSecPetGrid():void{
			if(_mc.secPetImg.numChildren>0)
				_mc.secPetImg.removeChildAt(0);
		}

		private function onCombine(e:MouseEvent):void{
			if(PetDyManager.crtPetId!=-1 && _secPetId!=-1){
				var msg:CCombinePet = new CCombinePet();
				msg.mainPetId = PetDyManager.crtPetId;
				msg.deputyPetId = _secPetId;
				
				YFEventCenter.Instance.dispatchEventWith(PetEvent.CombineReq,msg);
			}
		}
	}
} 