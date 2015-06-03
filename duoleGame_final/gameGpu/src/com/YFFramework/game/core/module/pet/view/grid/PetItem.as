package com.YFFramework.game.core.module.pet.view.grid
{
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.net.loader.image_swf.IconLoader;
	import com.YFFramework.core.ui.abs.AbsView;
	import com.YFFramework.core.utils.common.ClassInstance;
	import com.YFFramework.game.core.global.DataCenter;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.core.global.model.PetBasicVo;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.module.pet.events.PetEvent;
	import com.YFFramework.game.core.module.pet.manager.PetDyManager;
	import com.YFFramework.game.core.module.pet.model.PetDyVo;
	import com.YFFramework.game.gameConfig.URLTool;
	import com.dolo.ui.controls.Alert;
	import com.dolo.ui.controls.BitmapControl;
	import com.dolo.ui.events.AlertCloseEvent;
	import com.dolo.ui.managers.UI;
	import com.dolo.ui.managers.UIManager;
	import com.dolo.ui.skin.Skins;
	import com.dolo.ui.tools.Xdis;
	
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * @version 1.0.0
	 * creation time：2013-3-12 下午2:01:04
	 */
	public class PetItem extends Sprite{
		
		private var _mc:MovieClip;
		private var _index:int;
		private var _pet:PetDyVo;
		private var _isMainPet:Boolean;
		private var _color:uint=TypeProps.COLOR_WHITE;
		private var _bg:MovieClip;
		private var _isDown:Boolean;
		private var _select:Boolean;
		private var _isOver:Boolean;
		private var _statusImg:Sprite;

		public function PetItem(index:int,isMainPet:Boolean){
			_index=index;
			_isMainPet=isMainPet;
			_mc=ClassInstance.getInstance("pet.petItem");
			_statusImg = _mc.statusImg;
			_mc.x=5;
			_mc.y = 49*index+5;
			addChild(_mc);
			addEventListener(MouseEvent.CLICK,mouseClickHandler);
			_bg = _mc.bg;
			_bg.gotoAndStop(1);
			this.addEventListener(MouseEvent.ROLL_OVER,onMouseOver);
			this.addEventListener(MouseEvent.ROLL_OUT,onMouseOut);
			this.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
		}
		
		private function onMouseDown(event:MouseEvent):void{
			_isDown = true;
			showDown();
			UI.stage.addEventListener(MouseEvent.MOUSE_UP,onStageMouseUp);
		}
		
		private function onStageMouseUp(event:MouseEvent):void{
			_isDown = false;
			UI.stage.removeEventListener(MouseEvent.MOUSE_UP,onStageMouseUp);
			if(_select == false)	onMouseOut();
		}
		
		private function onMouseOut(event:MouseEvent = null):void{
			if(_isDown) return;
			_isOver = false;
			if(_select == false){
				index = _index;
				if(_bg)	_bg.gotoAndStop(1);
			}else	select = true;
		}
		
		public function set select(value:Boolean):void{
			_select = value;
			_isDown = false;
			if(_select == true){
				showSelectOn();
			}else{
				index = _index;
				if(_bg)	_bg.gotoAndStop(1);
			}
		}
		
		public function set index(value:uint):void{
			_index = value;
			if( _select == false && _isOver == false)	showDefault();
		}
		
		private function onMouseOver(event:MouseEvent):void{
			if(_isDown) return;
			_isOver = true;
			if(_select==false)	showOver();
		}
		
		/**子类可以覆盖Show的一系列方法：默认状态
		 */		
		private function showDefault():void{
			if(_bg)	_bg.gotoAndStop(1);
		}
		
		/**子类可以覆盖show的一系列方法:划入状态
		 */
		private function showOver():void{
			if(_bg)	_bg.gotoAndStop(2);
		}
		
		/**子类可以覆盖show的一系列方法：按下状态
		 */
		private function showDown():void{
			if(_bg)	_bg.gotoAndStop(2);
		}
		
		/**子类可以覆盖show的一系列方法：选中状态
		 */
		private function showSelectOn():void{
			if(_bg)	_bg.gotoAndStop(3);
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
					_color = TypeProps.COLOR_WHITE;
					break;
				case 2:
					_color = TypeProps.COLOR_GREEN;
					break;
				case 3:
					_color = TypeProps.COLOR_BLUE;
					break;
				case 4:
					_color = TypeProps.COLOR_PURPLE;
					break;
				case 5:
					_color = TypeProps.COLOR_ORANGE;
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
		
		public function setImg(iconId:int):void{
			IconLoader.initLoader(URLTool.getMonsterIcon(iconId),_mc.petIcon);
		}
		
		public function setStatus(status:String):void{
			while(_statusImg.numChildren>0){
				_statusImg.removeChildAt(0);
			}
			if(status=="出战"){
				_statusImg.addChild(new Bitmap(ClassInstance.getInstance("fightImg")));
			}else{
				_statusImg.addChild(new Bitmap(ClassInstance.getInstance("restImg")));
			}
		}
		
		/**
		 * 把全部内容清除
		 **/
		public function clearContent():void{
			_pet = null;
			_mc.pname.text = "";
			_mc.level.text = "";
			_mc.petStatus.text = "";
			if(_mc.petIcon.numChildren>0)	_mc.petIcon.removeChildAt(0);
			if(_statusImg.numChildren>0)	_statusImg.removeChildAt(0);
		}
		
		private function mouseClickHandler(e:MouseEvent):void{			
			if(_mc.expandTxt.visible==false && _pet){
				YFEventCenter.Instance.dispatchEventWith(PetEvent.Select_Pet,this);
				if(_isMainPet==true && PetDyManager.fightPetId==0)
					YFEventCenter.Instance.dispatchEventWith(GlobalEvent.PetChange,"all");
			}
			if(_mc.expandTxt.visible){
				var txt:String = "扩展1格宠物栏，需要花费"+((PetDyManager.petOpenSlots+1)*10-60)+"魔钻，是否继续？";
				Alert.show(txt,"宠物扩展",onExpandSlot,["确认","取消"]);
			}
		}
		
		private function onExpandSlot(event:AlertCloseEvent):void{
			if(event.clickButtonIndex==1){
				if(DataCenter.Instance.roleSelfVo.diamond<((PetDyManager.petOpenSlots+1)*10-60)){
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