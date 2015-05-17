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
	 * creation time：2013-3-9 下午1:15:54
	 * 宠物洗练界面
	 */
	public class PetSophiPanel{
		
		private var _mc:MovieClip;
		
		private var petsCollection:PetsCollection;
		private var petScrollbar:VScrollBar;
		
		private var itemsCollection:ItemsCollection;
		private var itemScrollbar:VScrollBar;
		
		private var succ_button:Button;
		private var confirm_button:Button;
		
		private var arrows:Array;
		private var diff:Array;
		
		public function PetSophiPanel(mc:MovieClip){
			_mc = mc;
			AutoBuild.replaceAll(_mc);
			succ_button = Xdis.getChild(_mc,"succ_button");
			succ_button.addEventListener(MouseEvent.CLICK,onSucc);
			
			confirm_button = Xdis.getChild(_mc,"confirm_button");
			confirm_button.addEventListener(MouseEvent.CLICK,onConfirm);
			confirm_button.enabled = false;
			
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
			
			arrows = new Array(5);
			diff = new Array(5);
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
				
				_mc.t0.text = "【当前资质】";
				_mc.t1.text = "体力资质："+pet.fightAttrs[TypeProps.BASIC_PHY_QLT]+"/"+pet.fightAttrs[TypeProps.BASIC_PHY_QLT_LIM];
				_mc.t2.text = "力量资质："+pet.fightAttrs[TypeProps.BASIC_STR_QLT]+"/"+pet.fightAttrs[TypeProps.BASIC_STR_QLT_LIM];
				_mc.t3.text = "敏捷资质："+pet.fightAttrs[TypeProps.BASIC_AGI_QLT]+"/"+pet.fightAttrs[TypeProps.BASIC_AGI_QLT_LIM];
				_mc.t4.text = "智力资质："+pet.fightAttrs[TypeProps.BASIC_INT_QLT]+"/"+pet.fightAttrs[TypeProps.BASIC_INT_QLT_LIM];
				_mc.t5.text = "精神资质："+pet.fightAttrs[TypeProps.BASIC_SPI_QLT]+"/"+pet.fightAttrs[TypeProps.BASIC_SPI_QLT_LIM];
				
				if(pet.succTempAttrs.length>0){
					_mc.t6.text = "【洗练资质】";
					
					_mc.t7.text = "体力资质："+pet.succTempAttrs[TypeProps.BASIC_PHY_QLT]+"/"+pet.fightAttrs[TypeProps.BASIC_PHY_QLT_LIM];
					_mc.t8.text = "力量资质："+pet.succTempAttrs[TypeProps.BASIC_STR_QLT]+"/"+pet.fightAttrs[TypeProps.BASIC_STR_QLT_LIM];
					_mc.t9.text = "敏捷资质："+pet.succTempAttrs[TypeProps.BASIC_AGI_QLT]+"/"+pet.fightAttrs[TypeProps.BASIC_AGI_QLT_LIM];
					_mc.t10.text = "智力资质："+pet.succTempAttrs[TypeProps.BASIC_INT_QLT]+"/"+pet.fightAttrs[TypeProps.BASIC_INT_QLT_LIM];
					_mc.t11.text = "精神资质："+pet.succTempAttrs[TypeProps.BASIC_SPI_QLT]+"/"+pet.fightAttrs[TypeProps.BASIC_SPI_QLT_LIM];
					
					for(var i:int=0;i<5;i++){
						diff[i] = pet.succTempAttrs[TypeProps.BASIC_STR_QLT+i]-pet.fightAttrs[TypeProps.BASIC_STR_QLT+i];
						if(diff[i]>0)	arrows[i] = ClassInstance.getInstance("pet.arrowUp") as MovieClip;
						else if(diff[i]<0)	arrows[i] = ClassInstance.getInstance("pet.arrowDown") as MovieClip;
						else	arrows[i] = null;
						if(arrows[i]!=null){
							arrows[i].x=622;
							_mc.addChild(arrows[i]);
						}					
					}
					
					_mc.t12.text = int(Math.abs(diff[3]));
					_mc.t13.text = int(Math.abs(diff[0]));
					_mc.t14.text = int(Math.abs(diff[1]));
					_mc.t15.text = int(Math.abs(diff[2]));
					_mc.t16.text = int(Math.abs(diff[4]));
					
					if(arrows[0]!=null)	arrows[0].y=58+23;
					if(arrows[1]!=null)	arrows[1].y=58+23*2;
					if(arrows[2]!=null)	arrows[2].y=58+23*3;
					if(arrows[3]!=null)	arrows[3].y=58;
					if(arrows[4]!=null)	arrows[4].y=58+23*4;
					
					confirm_button.enabled = true;
				}else{
					confirm_button.enabled = false;
				}
			}
		}
		
		/**
		 * 更新Item区
		 **/
		public function updateItem():void{
			itemsCollection.clearItem();
			itemsCollection.loadContent(ConstMapBasicManager.Instance.getTempId(TypeProps.CONST_ID_PET_SOPHI),ConstMapBasicManager.Instance.getTempId(TypeProps.CONST_ID_PET_SOPHI),false);
		}
		
		/**
		 * 更新Item Grid区
		 **/
		public function updateItemGrid():void{
			if(_mc.itemImg.numChildren!=0){
				_mc.itemImg.removeChildAt(0);
			}
			
			if(PropsDyManager.instance.getPropsQuantity(ConstMapBasicManager.Instance.getTempId(TypeProps.CONST_ID_PET_SOPHI))>0)
				IconLoader.initLoader(itemsCollection.getIconURL(0),_mc.itemImg);
			
			updateMoneyTxt();
			updateSophiBtn();
		}
		
		public function updateMoneyTxt():void{
			_mc.moneyTxt.text = "消耗银锭：50000";
			if(DataCenter.Instance.roleSelfVo.note<50000)	_mc.moneyTxt.textColor = TypeProps.RED;
			else	_mc.moneyTxt.textColor = TypeProps.Cfff3a5;
			updateSophiBtn();
		}
		
		public function updateSophiBtn():void{
			if(PropsDyManager.instance.getPropsQuantity(ConstMapBasicManager.Instance.getTempId(TypeProps.CONST_ID_PET_SOPHI))>0 && DataCenter.Instance.roleSelfVo.note>50000 && PetDyManager.crtPetId!=-1)
				succ_button.enabled = true;
			else
				succ_button.enabled = false;
		}
		
		private function clearCrtPetGrid():void{
			if(_mc.petImg.numChildren>0)
				_mc.petImg.removeChildAt(0);
			
			for(var i:int=0;i<17;i++){
				_mc["t"+i].text = "";
			}
			
			for(i=0;i<arrows.length;i++){
				if(arrows[i]!=null){
					_mc.removeChild(arrows[i]);
					arrows[i]=null;
				}
			}
		}
		
		private function onSucc(e:MouseEvent):void{
			var msg:PetRequest = new PetRequest();
			msg.petId = PetDyManager.crtPetId;
			YFEventCenter.Instance.dispatchEventWith(PetEvent.SuccReq,msg);
		}	
		
		private function onConfirm(e:MouseEvent):void{
			var msg:PetRequest = new PetRequest();
			msg.petId = PetDyManager.crtPetId;
			YFEventCenter.Instance.dispatchEventWith(PetEvent.SuccConfirmReq,msg);
		}
	}
} 