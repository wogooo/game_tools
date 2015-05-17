package com.YFFramework.game.core.module.pet.view.grid
{
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.net.loader.image_swf.IconLoader;
	import com.YFFramework.core.utils.common.ClassInstance;
	import com.YFFramework.game.core.global.manager.PropsDyManager;
	import com.YFFramework.game.core.global.util.FilterConfig;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.module.bag.source.JInputWindow;
	import com.YFFramework.game.core.module.pet.events.PetEvent;
	import com.YFFramework.game.core.module.shop.vo.NPCShopBasicManager;
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

		public function Item(index:int,select:Boolean){
			
			_mc = ClassInstance.getInstance("pet.petItem");	
			_mc.expandTxt.visible = false;			
			addChild(_mc);

			_index = index;
			this.y = 48*_index;
			_selectable = select;
			_buyable = false;
			
			addEventListener(MouseEvent.CLICK,mouseClickHandler);		
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
			if(_selectable){
				YFEventCenter.Instance.dispatchEventWith(PetEvent.Select_Item,this);
			}else if(_buyable){
				var txt:String = "请输入购买"+_mc.pname.text+"的数量";
				JInputWindow.Instance().initPanel("快速购买",txt,onBuy,"");
				JInputWindow.Instance().setRestrict("0-9");
				JInputWindow.Instance().setMaxMin(-1,1);
			}
		}
		
		private function onBuy():void{
			var pos:int=NPCShopBasicManager.Instance.getPositionByShopAndItemID(TypeProps.ITEM_SHOP_ID,_templateId,TypeProps.ITEM_TYPE);
			if(pos!=-1){
				var msg:CBuyItemReq = new CBuyItemReq();
				msg.shopId = TypeProps.ITEM_SHOP_ID;
				msg.pos = pos;
				msg.amount = int(JInputWindow.Instance().getInputText());
				YFEventCenter.Instance.dispatchEventWith(PetEvent.QuickBuyReq,msg);
			}
			JInputWindow.Instance().close();
			JInputWindow.Instance().dispose();
		}
	}
} 