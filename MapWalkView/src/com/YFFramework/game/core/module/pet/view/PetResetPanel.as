package com.YFFramework.game.core.module.pet.view
{
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.net.loader.image_swf.IconLoader;
	import com.YFFramework.core.utils.URLTool;
	import com.YFFramework.core.utils.common.ClassInstance;
	import com.YFFramework.game.core.global.DataCenter;
	import com.YFFramework.game.core.global.manager.ConstMapBasicManager;
	import com.YFFramework.game.core.global.manager.PetBasicManager;
	import com.YFFramework.game.core.global.manager.PropsDyManager;
	import com.YFFramework.game.core.global.model.PetBasicVo;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.module.pet.events.PetEvent;
	import com.YFFramework.game.core.module.pet.manager.PetDyManager;
	import com.YFFramework.game.core.module.pet.model.PetDyVo;
	import com.YFFramework.game.core.module.pet.view.collection.ItemsCollection;
	import com.YFFramework.game.core.module.pet.view.collection.PetsCollection;
	import com.YFFramework.game.core.module.pet.view.grid.PetItem;
	import com.dolo.ui.controls.Button;
	import com.dolo.ui.controls.VScrollBar;
	import com.dolo.ui.tools.AutoBuild;
	import com.dolo.ui.tools.Xdis;
	import com.msg.pets.PetRequest;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;

	/**
	 * @version 1.0.0
	 * creation time：2013-3-8 下午2:57:07
	 * 
	 */
	public class PetResetPanel{
		
		private var _mc:MovieClip;
		
		private var petsCollection:PetsCollection;
		private var petScrollbar:VScrollBar;
		
		private var itemsCollection:ItemsCollection;
		private var itemScrollbar:VScrollBar;
		
		private var reset_button:Button;
		
		public function PetResetPanel(mc:MovieClip){
			_mc = mc;
			AutoBuild.replaceAll(_mc);
			reset_button = Xdis.getChild(_mc,"reset_button");
			reset_button.addEventListener(MouseEvent.CLICK,onReset);
			
			petsCollection=new PetsCollection(5,30);
			petsCollection.init();
			_mc.addChild(petsCollection);
			
			petScrollbar = Xdis.getChild(_mc,"mainPet_vScrollBar");
			petScrollbar.setTarget(petsCollection,false,160,235);
			petScrollbar.updateSize(30*48+10);
			_mc.addChild(petScrollbar);
			
			itemsCollection = new ItemsCollection(5,300);
			_mc.addChild(itemsCollection);
			
			itemScrollbar = Xdis.getChild(_mc,"item_vScrollBar");
			itemScrollbar.setTarget(itemsCollection,false,160,160);
			itemScrollbar.updateSize(1*48+10);
			_mc.addChild(itemScrollbar);
		}
		
		public function onTabUpdate():void{
			updatePetList();
			updateCrtPetGrid();
			updateItem();
			updateItemGrid();
		}
		
		public function onSelectUpdate(petItem:PetItem):void{
			petsCollection.setFilter(petItem.getIndex());
			updateCrtPetGrid();
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
				var pet:PetDyVo = PetDyManager.Instance.getCrtPetDyVo();
				var petBasic:PetBasicVo = PetBasicManager.Instance.getPetConfigVo(pet.basicId);
				IconLoader.initLoader(URLTool.getMonsterIcon(petBasic.show_id),_mc.petImg);
				
				_mc.t0.text = "【当前属性】";
				_mc.t1.text = "体力属性："+pet.fightAttrs[TypeProps.BASIC_PHY];
				_mc.t2.text = "力量属性："+pet.fightAttrs[TypeProps.BASIC_STR];
				_mc.t3.text = "敏捷属性："+pet.fightAttrs[TypeProps.BASIC_AGI];
				_mc.t4.text = "智力属性："+pet.fightAttrs[TypeProps.BASIC_INT];
				_mc.t5.text = "精神属性："+pet.fightAttrs[TypeProps.BASIC_SPI];
				_mc.t6.text = "潜力："+pet.potential;
				
				_mc.t7.text = "【洗点后属性】";
			
				_mc.t8.text = "体力属性："+(petBasic.physique+pet.level-1);
				_mc.t9.text = "力量属性："+(petBasic.strength+pet.level-1);
				_mc.t10.text = "敏捷属性："+(petBasic.agile+pet.level-1);
				_mc.t11.text = "智力属性："+(petBasic.intelligence+pet.level-1);
				_mc.t12.text = "精神属性："+(petBasic.spirit+pet.level-1);
				
				var resetPot:int = pet.fightAttrs[TypeProps.BASIC_PHY]+pet.fightAttrs[TypeProps.BASIC_STR]+pet.fightAttrs[TypeProps.BASIC_AGI]+pet.fightAttrs[TypeProps.BASIC_INT]+pet.fightAttrs[TypeProps.BASIC_SPI]-petBasic.strength-petBasic.physique-petBasic.agile-petBasic.intelligence-petBasic.spirit-pet.level*5+5+pet.potential;
				_mc.t13.text = "潜力："+resetPot;
			}else{
				for(var i:int=0;i<14;i++){
					_mc["t"+i].text="";
				}
			}
		}
		
		/**
		 * 更新Item区
		 **/
		public function updateItem():void{
			itemsCollection.clearItem();
			itemsCollection.loadContent(ConstMapBasicManager.Instance.getTempId(TypeProps.CONST_ID_PET_RESET),ConstMapBasicManager.Instance.getTempId(TypeProps.CONST_ID_PET_RESET),false);
		}
		
		public function updateItemGrid():void{
			if(_mc.itemImg.numChildren!=0){
				_mc.itemImg.removeChildAt(0);
			}
			
			if(PropsDyManager.instance.getPropsQuantity(ConstMapBasicManager.Instance.getTempId(TypeProps.CONST_ID_PET_RESET))>0)
				IconLoader.initLoader(itemsCollection.getIconURL(0),_mc.itemImg);
			
			updateMoneyTxt();			
		}
		
		public function updateMoneyTxt():void{
			_mc.moneyTxt.text = "消耗银锭：50000";
			if(DataCenter.Instance.roleSelfVo.note<50000)	_mc.moneyTxt.textColor = TypeProps.RED;
			else	_mc.moneyTxt.textColor = TypeProps.Cfff3a5;
			updateResetBtn();
		}
		
		public function updateResetBtn():void{
			if(PropsDyManager.instance.getPropsQuantity(ConstMapBasicManager.Instance.getTempId(TypeProps.CONST_ID_PET_RESET))>0 && DataCenter.Instance.roleSelfVo.note>50000 && PetDyManager.crtPetId!=-1)
				reset_button.enabled = true;
			else
				reset_button.enabled = false;
		}
		
		private function clearCrtPetGrid():void{
			if(_mc.petImg.numChildren>0)
				_mc.petImg.removeChildAt(0);
		}
		
		private function onReset(e:MouseEvent):void{
			var msg:PetRequest = new PetRequest();
			msg.petId = PetDyManager.crtPetId;
			YFEventCenter.Instance.dispatchEventWith(PetEvent.ResetReq,msg);
		}
	}
} 