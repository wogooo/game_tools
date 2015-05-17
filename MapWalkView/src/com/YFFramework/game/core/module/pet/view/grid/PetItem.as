package com.YFFramework.game.core.module.pet.view.grid
{
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.net.loader.image_swf.IconLoader;
	import com.YFFramework.core.ui.abs.AbsView;
	import com.YFFramework.core.utils.URLTool;
	import com.YFFramework.core.utils.common.ClassInstance;
	import com.YFFramework.game.core.global.DataCenter;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.core.global.model.PetBasicVo;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.module.pet.events.PetEvent;
	import com.YFFramework.game.core.module.pet.manager.PetDyManager;
	import com.YFFramework.game.core.module.pet.model.PetDyVo;
	import com.dolo.ui.controls.Alert;
	import com.dolo.ui.events.AlertCloseEvent;
	import com.dolo.ui.managers.UIManager;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * @version 1.0.0
	 * creation time：2013-3-12 下午2:01:04
	 * 
	 */
	public class PetItem extends Sprite{
		
		private var _mc:MovieClip;
		private var _index:int;
		private var _pet:PetDyVo;
		private var _isMainPet:Boolean;
		private var _color:uint=TypeProps.WHITE;

		public function PetItem(index:int,isMainPet:Boolean){
			_index=index;
			_isMainPet=isMainPet;
			_mc=ClassInstance.getInstance("pet.petItem");
			_mc.y = 48*index;
			addChild(_mc);
			addEventListener(MouseEvent.CLICK,mouseClickHandler);
		}
		
		public function getIndex():int{
			return _index;
		}

		public function getPetDyVo():PetDyVo{
			return _pet;
		}
		
		public function isMainPet():Boolean{
			return _isMainPet;
		}

		public function openSlot():void{
			_mc.expandTxt.visible = false;
		}

		public function setPetDyVo(pet:PetDyVo):void{
			_pet = pet;
		}
		
		public function setColor(petId:int):void{
			switch(PetDyManager.Instance.getGrowQuality(petId)){
				case 1:
					_color = TypeProps.WHITE;
					break;
				case 2:
					_color = TypeProps.GREEN;
					break;
				case 3:
					_color = TypeProps.BLUE;
					break;
				case 4:
					_color = TypeProps.PURPLE;
					break;
				case 5:
					_color = TypeProps.ORANGE;
					break;	
			}
		}

		public function setName(pname:String):void{
			_mc.pname.text = pname;
			_mc.pname.textColor=_color;
		}
		
		public function setLv(lv:String):void{
			_mc.level.text=lv;
			_mc.level.textColor=_color;
		}
		
		public function setStatus(status:String):void{
			_mc.petStatus.text=status;
		}

		public function setImg(iconId:int):void{
			IconLoader.initLoader(URLTool.getMonsterIcon(iconId),_mc.petIcon);
		}
		
		/**
		 * 把全部内容清除
		 **/
		public function clearContent():void{
			_pet = null;
			_mc.pname.text = "";
			_mc.level.text = "";
			_mc.petStatus.text = "";
			if(_mc.petIcon.numChildren>0)
				_mc.petIcon.removeChildAt(0);
		}
		
		private function mouseClickHandler(e:MouseEvent):void{			
			if(_mc.expandTxt.visible==false && _pet){
				YFEventCenter.Instance.dispatchEventWith(PetEvent.Select_Pet,this);
				if(_isMainPet==true && PetDyManager.Instance.getFightPetId()==0)
					YFEventCenter.Instance.dispatchEventWith(GlobalEvent.PetChange,"all");
			}
			if(_mc.expandTxt.visible){
				var txt:String = "扩展1格宠物栏，需要花费"+(PetDyManager.Instance.getPetOpenSlots()+1)*10+"魔钻，是否继续？";
				Alert.show(txt,"宠物扩展",onExpandSlot,["确认","取消"]);
			}
		}
		
		private function onExpandSlot(event:AlertCloseEvent):void{
			if(event.clickButtonIndex==1){
				if(DataCenter.Instance.roleSelfVo.diamond<((PetDyManager.Instance.getPetOpenSlots()+1)*10)){
					Alert.show("您的魔钻不够了！您可以...","金钱不够",onNoMoney,["确认","取消"]);
				}
				else{
					YFEventCenter.Instance.dispatchEventWith(PetEvent.OpenSlotReq,this);
				}
			}
		}
		
		private function onNoMoney(event:AlertCloseEvent):void{
			trace("noMoney:need to display purchase money dialogue");
		}
	}
} 