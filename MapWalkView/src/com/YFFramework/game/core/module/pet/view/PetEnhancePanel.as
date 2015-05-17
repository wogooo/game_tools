package com.YFFramework.game.core.module.pet.view
{
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.net.loader.image_swf.IconLoader;
	import com.YFFramework.core.utils.URLTool;
	import com.YFFramework.core.utils.common.ClassInstance;
	import com.YFFramework.game.core.global.DataCenter;
	import com.YFFramework.game.core.global.manager.ConstMapBasicManager;
	import com.YFFramework.game.core.global.manager.PetBasicManager;
	import com.YFFramework.game.core.global.manager.PropsBasicManager;
	import com.YFFramework.game.core.global.manager.PropsDyManager;
	import com.YFFramework.game.core.global.model.PetBasicVo;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.module.pet.events.PetEvent;
	import com.YFFramework.game.core.module.pet.manager.PetDyManager;
	import com.YFFramework.game.core.global.manager.StrRatioManager;
	import com.YFFramework.game.core.module.pet.model.PetDyVo;
	import com.YFFramework.game.core.global.model.StrRatioVo;
	import com.YFFramework.game.core.module.pet.view.collection.ItemsCollection;
	import com.YFFramework.game.core.module.pet.view.collection.PetsCollection;
	import com.YFFramework.game.core.module.pet.view.grid.PetItem;
	import com.dolo.ui.controls.Button;
	import com.dolo.ui.controls.NumericStepper;
	import com.dolo.ui.controls.VScrollBar;
	import com.dolo.ui.tools.AutoBuild;
	import com.dolo.ui.tools.Xdis;
	import com.msg.pets.CEnhancePet;
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * @version 1.0.0
	 * creation time：2013-3-8 下午2:57:07
	 * 
	 */
	public class PetEnhancePanel{
		
		private var _mc:MovieClip;
		
		private var petsCollection:PetsCollection;
		private var petScrollbar:VScrollBar;
		
		private var itemsCollection:ItemsCollection;
		private var itemScrollbar:VScrollBar;
		
		private var str_button:Button;
		private var all_button:SimpleButton;
		
		private var _numStep:NumericStepper;
		private var _checkable:Boolean;
		
		public function PetEnhancePanel(mc:MovieClip){
			_mc = mc;
		
			AutoBuild.replaceAll(_mc);
			str_button = Xdis.getChild(_mc,"str_button");
			str_button.addEventListener(MouseEvent.CLICK,onStr);
			
			all_button = _mc.allBtn;
			all_button.addEventListener(MouseEvent.CLICK,onAll);
			
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
			_mc.addChild(itemScrollbar);
			
			_numStep = Xdis.getChild(_mc,"num_numericStepper");
			_numStep.textField.mouseEnabled = false;
			_numStep.addEventListener(Event.CHANGE,updateSucc);
			
			_mc.check.visible=false;
		}
		
		public function onTabUpdate():void{
			_mc.check.visible =false;
			_checkable=true;
			updatePetList();
			updateCrtPetGrid();
			updateItem();
			updateItemGrid();
		}
		
		public function onSelectUpdate(petItem:PetItem):void{
			_mc.check.visible =false;
			_checkable=true;
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
			
			var crtPetId:int = PetDyManager.crtPetId;
			if(crtPetId!=-1){
				var pet:PetDyVo = PetDyManager.Instance.getPetDyVo(crtPetId);
				var petBasic:PetBasicVo = PetBasicManager.Instance.getPetConfigVo(pet.basicId);
				var crtStrRatio:Number = StrRatioManager.Instance.getStrRatioVo(pet.enhanceLv).ratio;
				IconLoader.initLoader(URLTool.getMonsterIcon(petBasic.show_id),_mc.petImg);
				
				_mc.t0.text = "【当前资质】";
				_mc.t1.text = "体力资质："+pet.fightAttrs[TypeProps.BASIC_PHY_QLT]+"/"+pet.fightAttrs[TypeProps.BASIC_PHY_QLT_LIM];
				_mc.t2.text = "力量资质："+pet.fightAttrs[TypeProps.BASIC_STR_QLT]+"/"+pet.fightAttrs[TypeProps.BASIC_STR_QLT_LIM];
				_mc.t3.text = "敏捷资质："+pet.fightAttrs[TypeProps.BASIC_AGI_QLT]+"/"+pet.fightAttrs[TypeProps.BASIC_AGI_QLT_LIM];
				_mc.t4.text = "智力资质："+pet.fightAttrs[TypeProps.BASIC_INT_QLT]+"/"+pet.fightAttrs[TypeProps.BASIC_INT_QLT_LIM];
				_mc.t5.text = "精神资质："+pet.fightAttrs[TypeProps.BASIC_SPI_QLT]+"/"+pet.fightAttrs[TypeProps.BASIC_SPI_QLT_LIM];
				
				if(pet.enhanceLv<12){
					var nxtStrRatio:Number = StrRatioManager.Instance.getStrRatioVo(pet.enhanceLv+1).ratio;
					_mc.t6.text = "【下一级资质】";
					_mc.t7.text = "体力资质："+Math.round(Math.round(pet.fightAttrs[TypeProps.BASIC_PHY_QLT]/crtStrRatio)*nxtStrRatio)+"/"+Math.round(petBasic.physique_apt*1.2*nxtStrRatio);
					_mc.t8.text = "力量资质："+Math.round(Math.round(pet.fightAttrs[TypeProps.BASIC_STR_QLT]/crtStrRatio)*nxtStrRatio)+"/"+Math.round(petBasic.strength_apt*1.2*nxtStrRatio);
					_mc.t9.text = "敏捷资质："+Math.round(Math.round(pet.fightAttrs[TypeProps.BASIC_AGI_QLT]/crtStrRatio)*nxtStrRatio)+"/"+Math.round(petBasic.agile_apt*1.2*nxtStrRatio);
					_mc.t10.text = "智力资质："+Math.round(Math.round(pet.fightAttrs[TypeProps.BASIC_INT_QLT]/crtStrRatio)*nxtStrRatio)+"/"+Math.round(petBasic.intelligence_apt*1.2*nxtStrRatio);
					_mc.t11.text = "精神资质："+Math.round(Math.round(pet.fightAttrs[TypeProps.BASIC_SPI_QLT]/crtStrRatio)*nxtStrRatio)+"/"+Math.round(petBasic.spirit_apt*1.2*nxtStrRatio);
				}
				_mc.t12.text = pet.roleName;
				
				_mc.moneyTxt.text = "消耗银锭：5000";
				if(DataCenter.Instance.roleSelfVo.note<5000)
					_mc.moneyTxt.color = TypeProps.RED;
				
				for(var i:int=0;i<pet.enhanceLv;i++){
					var starMC:MovieClip = ClassInstance.getInstance("pet.star");
					starMC.x=i*16;
					_mc.starImg.addChild(starMC);
				}
			}else{
				_mc.moneyTxt.text="";
			}
		}
		
		private function clearCrtPetGrid():void{
			if(_mc.petImg.numChildren>0)
				_mc.petImg.removeChildAt(0);
			for(var i:int=0;i<12;i++){
				_mc["t"+i].text = "";
			}
			var num:int=_mc.starImg.numChildren;
			for(i=0;i<num;i++){
				_mc.starImg.removeChildAt(0);
			}
		}
		
		/**
		 * 更新Item区
		 **/
		public function updateItem():void{
			itemsCollection.clearItem();
			itemsCollection.loadContent(ConstMapBasicManager.Instance.getTempId(TypeProps.CONST_ID_PET_LOW_CRYSTAL),ConstMapBasicManager.Instance.getTempId(TypeProps.CONST_ID_PET_HIGH_CRYSTAL),false);
		}
		
		/**
		 * 更新Item Grid区
		 **/
		public function updateItemGrid(onAll:Boolean=false):void{
			if(_mc.itemImg.numChildren!=0){
				_mc.itemImg.removeChildAt(0);
			}
			if(PetDyManager.crtPetId!=-1 && PetDyManager.Instance.getCrtPetDyVo().enhanceLv<12){
				var pet:PetDyVo = PetDyManager.Instance.getCrtPetDyVo();
				var petStrRatio:StrRatioVo = StrRatioManager.Instance.getStrRatioVo(pet.enhanceLv+1);
				var consts:Number=petStrRatio.consts;
				var mul:Number=petStrRatio.mul;
				var max:int = Math.ceil((1-consts)/mul);
				var tempId:int;
				if(pet.enhanceLv<=4){
					tempId = ConstMapBasicManager.Instance.getTempId(TypeProps.CONST_ID_PET_LOW_CRYSTAL);
				}else if(pet.enhanceLv>4 && pet.enhanceLv <=8){
					tempId = ConstMapBasicManager.Instance.getTempId(TypeProps.CONST_ID_PET_MID_CRYSTAL);
				}else{
					tempId = ConstMapBasicManager.Instance.getTempId(TypeProps.CONST_ID_PET_HIGH_CRYSTAL);
				}
				var quantity:int = PropsDyManager.instance.getPropsQuantity(tempId);
				if(quantity>0){
					IconLoader.initLoader(PropsBasicManager.Instance.getURL(tempId),_mc.itemImg);
					if(quantity<4){
						_numStep.textField.textColor=TypeProps.RED;
						_numStep.minimum = quantity;
						_numStep.maximum = quantity;
						_numStep.value = quantity;
					}else{
						_numStep.textField.textColor=TypeProps.WHITE;
						_numStep.minimum = 4;
						if(max>quantity){
							_numStep.maximum = quantity;
							if(onAll==false)
								_numStep.value=4;
							else
								_numStep.value=quantity;
						}
						else{
							_numStep.maximum = max;
							if(onAll==false)
								_numStep.value=4;
							else
								_numStep.value=max;
						}
					}
				}else{
					_numStep.textField.textColor=TypeProps.RED;
					_numStep.minimum=0;
					_numStep.maximum=0;
					_numStep.value=0;
				}
			
				var succ:int = int((_numStep.value*mul+consts)*100);
				if(succ>100)	succ=100;
				_mc.succRateTxt.text = "成功率："+succ+"%";
			
				if(_numStep.value>=4){
					str_button.enabled=true;
				}else{
					str_button.enabled=false;
				}
			}else{
				str_button.enabled=false;
				_numStep.maximum=0;
				_numStep.minimum=0;
				_numStep.value=0;
				_checkable=false;
			}
		}
		
		private function onAll(e:MouseEvent):void{
			if(_mc.check.visible==true || _checkable==false){
				_mc.check.visible=false;
			}else{
				_mc.check.visible=true;
				updateItemGrid(true);
			}
		}
		
		private function updateSucc(e:Event):void{
			var pet:PetDyVo = PetDyManager.Instance.getCrtPetDyVo();
			if(pet){
				if(pet.enhanceLv<12){
					var petStrRatio:StrRatioVo = StrRatioManager.Instance.getStrRatioVo(pet.enhanceLv+1);
					var consts:Number=petStrRatio.consts;
					var mul:Number=petStrRatio.mul;
			
					var succ:int = int((_numStep.value*mul+consts)*100);
					if(succ>100)	succ=100;
					_mc.succRateTxt.text = "成功率："+succ+"%";
				}else{
					_mc.succRateTxt.text = "宠物已经强化满级";
				}
			}
		}
		
		private function onStr(e:MouseEvent):void{
			var msg:CEnhancePet = new CEnhancePet();
			msg.petId = PetDyManager.crtPetId;
			msg.materialNumber = _numStep.value;
			YFEventCenter.Instance.dispatchEventWith(PetEvent.EnhanceReq,msg);
		}
	}
} 