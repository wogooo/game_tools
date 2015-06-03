package com.YFFramework.game.core.module.pet.view.collection
{
	import com.YFFramework.core.debug.print;
	import com.YFFramework.core.ui.abs.AbsView;
	import com.YFFramework.game.core.global.manager.PetBasicManager;
	import com.YFFramework.game.core.global.model.PetBasicVo;
	import com.YFFramework.game.core.global.util.FilterConfig;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.module.pet.manager.PetDyManager;
	import com.YFFramework.game.core.module.pet.model.PetDyVo;
	import com.YFFramework.game.core.module.pet.view.grid.PetItem;
	
	import flash.display.Sprite;
	import flash.events.Event;

	/**
	 * @version 1.0.0
	 * creation time：2013-3-12 下午3:15:08
	 */
	public class PetsCollection extends Sprite{
		
		private var _items:Vector.<PetItem>;
		
		public function PetsCollection(posX:int,posY:int){
			this.x = posX;
			this.y = posY;
			_items=new Vector.<PetItem>();
		}

		public function init():void{
			for(var i:int=0;i<TypeProps.TOTAL_SLOTS;i++){
				var item:PetItem=new PetItem(i,true);
				addChild(item);
				_items.push(item);
			}
		}
		
		public function openSlot():void{
			for(var i:int=0;i<PetDyManager.petOpenSlots;i++){
				_items[i].openSlot();
			}
		}
		
		public function loadContent():void{
			var petArr:Array = PetDyManager.Instance.getPetIdArray();
			var len:int=petArr.length;
			for(var i:int=0;i<len;i++){
				var pet:PetDyVo = PetDyManager.Instance.getPetDyVo(petArr[i]);
				var petBasic:PetBasicVo = PetBasicManager.Instance.getPetConfigVo(pet.basicId);
				
				_items[i].setPetDyVo(pet);
				_items[i].setColor(pet.dyId);
				_items[i].setName(pet.roleName);
				_items[i].setLv("等级："+pet.level);
				if(PetDyManager.fightPetId!=pet.dyId)	_items[i].setStatus("休息");
				else	_items[i].setStatus("出战");
				_items[i].setImg(petBasic.show_id);
				if(PetDyManager.crtPetId==pet.dyId)	setFilter(i);
			}
			if(petArr.length==0)	setFilter(-1);
		}
		
		public function addPet(pet:PetDyVo):void{
			var petBasic:PetBasicVo = PetBasicManager.Instance.getPetConfigVo(pet.basicId);
			var index:int = _items.length;
			var petItem:PetItem = new PetItem(index,false);
			petItem.setPetDyVo(pet);
			petItem.setColor(pet.dyId);
			petItem.setName(pet.roleName);
			petItem.setLv("等级:"+pet.level);
			if(PetDyManager.fightPetId!=pet.dyId)	petItem.setStatus("休息");
			else	petItem.setStatus("出战");
			petItem.setImg(petBasic.show_id);
			
			petItem.openSlot();
			addChild(petItem);
			_items.push(petItem);
		}
		
		/**
		 * 指定对象进行filter.如果index=-1,清空全部filter
		 **/
		public function setFilter(index:int):void{
			for(var i:int=0;i<this.numChildren;i++){
				_items[i].select=false;
			}
			if(index!=-1)
				_items[index].select = true;
		}

		/**把宠物内容去掉
		 **/
		public function clearPetContent():void{
			for(var i:int=0;i<PetDyManager.petOpenSlots;i++){
				_items[i].clearContent();
			}
		}
		
		/**把全部内容清除
		 **/
		public function clearPetItem():void{
			var len:int=_items.length;
			for(var i:int=0;i<len;i++){
				removeChildAt(0);
			}
			_items = new Vector.<PetItem>();
		}
	}
} 