package com.YFFramework.game.core.module.pet.view.grid
{
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.net.loader.image_swf.IconLoader;
	import com.YFFramework.core.utils.common.ClassInstance;
	import com.YFFramework.game.core.global.manager.PropsDyManager;
	import com.YFFramework.game.core.global.util.FilterConfig;
	import com.YFFramework.game.core.global.util.NoticeUtil;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.global.view.tips.PropsTip;
	import com.YFFramework.game.core.global.view.tips.TipUtil;
	import com.YFFramework.game.core.module.ModuleManager;
	import com.YFFramework.game.core.module.bag.source.JInputWindow;
	import com.YFFramework.game.core.module.pet.events.PetEvent;
	import com.dolo.ui.managers.UI;
	import com.dolo.ui.tools.Xtip;
	import com.msg.shop.CBuyItemReq;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	/**
	 * @version 1.0.0
	 * creation time：2013-3-14 下午1:36:58
	 * 
	 */
	public class Item extends Sprite{
		
		private var _mc:MovieClip;
		private var _index:int;
		private var _templateId:int;
		private var _selectable:Boolean;
		private var _buyable:Boolean;
		private var _iconURL:String;
		private var _bg:MovieClip;
		private var _isDown:Boolean;
		private var _select:Boolean;
		private var _isOver:Boolean;

		public function Item(index:int,select:Boolean){
			
			_mc = ClassInstance.getInstance("pet.petItem");	
			_mc.expandTxt.visible = false;			
			addChild(_mc);

			_index = index;
			this.y = 48*_index;
			_selectable = select;
			_buyable = false;
			
			addEventListener(MouseEvent.CLICK,mouseClickHandler);	
			
			_bg = _mc.bg;
			_bg.gotoAndStop(1);
			
			if(_selectable){
				this.addEventListener(MouseEvent.ROLL_OVER,onMouseOver);
				this.addEventListener(MouseEvent.ROLL_OUT,onMouseOut);
				this.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
			}
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
		
		public function updateItem(templateId:int,iconURL:String,name:String,amount:int):void{
			_mc.pname.text = name;
			_mc.level.text = amount;
			_templateId = templateId;
			_iconURL = iconURL;
			IconLoader.initLoader(_iconURL,_mc.petIcon);
			if(amount==0){
				_mc.petIcon.filters = FilterConfig.dead_filter;
				_buyable = true;
			}else{
				_mc.petIcon.filters = null;
				_buyable = false;
			}
			Xtip.registerLinkTip(_mc.petIcon,PropsTip,TipUtil.propsTipInitFunc,0,_templateId);
		}
		
		public function getIconURL():String{
			return _iconURL;
		}
		
		public function getIndex():int{
			return _index;
		}
		
		public function getTemplateId():int{
			return _templateId;
		}
		
		private function mouseClickHandler(e:MouseEvent):void{
			if(_selectable)	YFEventCenter.Instance.dispatchEventWith(PetEvent.Select_Item,this);
			else if(_buyable)	ModuleManager.moduleShop.openBuySmallWindow(TypeProps.ITEM_TYPE_PROPS,_templateId,1);
		}
	}
} 