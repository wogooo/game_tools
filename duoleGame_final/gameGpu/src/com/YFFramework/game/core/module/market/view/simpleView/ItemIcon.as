package com.YFFramework.game.core.module.market.view.simpleView
{
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.utils.common.ClassInstance;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.core.global.manager.EquipBasicManager;
	import com.YFFramework.game.core.global.manager.EquipDyManager;
	import com.YFFramework.game.core.global.manager.PropsBasicManager;
	import com.YFFramework.game.core.global.manager.PropsDyManager;
	import com.YFFramework.game.core.global.model.EquipDyVo;
	import com.YFFramework.game.core.global.model.ItemDyVo;
	import com.YFFramework.game.core.global.model.PropsDyVo;
	import com.YFFramework.game.core.global.util.DragManager;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.global.view.tips.EquipTipMix;
	import com.YFFramework.game.core.global.view.tips.PropsTip;
	import com.YFFramework.game.core.global.view.tips.TipUtil;
	import com.YFFramework.game.core.module.bag.Interface.IMoveGrid;
	import com.YFFramework.game.core.module.market.data.manager.MarketDyManager;
	import com.YFFramework.game.core.module.market.event.MarketEvent;
	import com.YFFramework.game.core.module.market.source.MarketSource;
	import com.YFFramework.game.core.module.market.view.window.PurchaseItemWindow;
	import com.YFFramework.game.core.module.market.view.window.SiftItemWindow;
	import com.YFFramework.game.core.module.notice.manager.NoticeManager;
	import com.YFFramework.game.core.module.notice.model.NoticeType;
	import com.YFFramework.game.core.module.skill.model.DragData;
	import com.dolo.ui.controls.IconImage;
	import com.dolo.ui.controls.Window;
	import com.dolo.ui.tools.WindowManager;
	import com.dolo.ui.tools.Xtip;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	/**
	 * @version 1.0.0
	 * creation time：2013-5-30 下午1:31:19
	 * 
	 */
	public class ItemIcon extends Sprite implements IMoveGrid
	{
		//======================================================================
		//       public property
		//======================================================================
		
		//======================================================================
		//       private property
		//======================================================================		
		private var _icon:IconImage;
		
		private var _type:int;
		
		private var _itemType:int;
		private var _itemId:int;
		private var _item:ItemDyVo;
		//======================================================================
		//        constructor
		//======================================================================	
		public function ItemIcon()
		{
			
		}
		
		//======================================================================
		//        public function
		//======================================================================
		/**
		 * 必须先设置这个type ,确定这个icon属于哪个面板
		 * @param type
		 * 
		 */		
		public function setIconType(type:int):void
		{
			_type=type;
//			switch(_type)
//			{
//				case MarketSource.CONSIGH:
//				case MarketSource.PURCHASE:
					addEvents();				
					var bg:Sprite=ClassInstance.getInstance("bagBgDefault") as Sprite;
					addChild(bg);
//					break;
//				case MarketSource.SIFT:
//					addEvents();
//					break;
//			}
		}
		
		/**
		 *  
		 * @param type
		 * @param id 动态id
		 * 
		 */		
		public function setIcon(type:int,dyId:int):void
		{	
			if(type > 0 && dyId > 0)
			{
				_icon=new IconImage();
				_icon.x=2;
				_icon.y=2;
				addChild(_icon);
				
				_itemType=type;
				_itemId=dyId;
				
				var pos:int=0;
				if(type == TypeProps.ITEM_TYPE_EQUIP)
				{
					pos=EquipDyManager.instance.getEquipPosFromBag(dyId);
					_item=new ItemDyVo(pos,type,dyId);
					
					var tmp1:EquipDyVo=EquipDyManager.instance.getEquipInfo(dyId);
					_icon.url=EquipBasicManager.Instance.getURL(tmp1.template_id);
					
					Xtip.registerLinkTip(this,EquipTipMix,TipUtil.equipTipInitFunc,dyId,tmp1.template_id);
				}
				else
				{
					pos=PropsDyManager.instance.getPropsPosFromBag(dyId);
					_item=new ItemDyVo(pos,type,dyId);
					
					var tmp2:PropsDyVo=PropsDyManager.instance.getPropsInfo(dyId);
					_icon.url=PropsBasicManager.Instance.getURL(tmp2.templateId);
					
					Xtip.registerLinkTip(this,PropsTip,TipUtil.propsTipInitFunc,dyId,tmp2.templateId);
				}
			}
			
		}
		
		public function setTemplateIcon(type:int,templateId:int):void
		{
			_item=new ItemDyVo(0,type,templateId);
			
			_icon=new IconImage();
			_icon.x=2;
			_icon.y=2;
			addChild(_icon);
			
			_itemType=type;
			_itemId=templateId;
			
			if(type == TypeProps.ITEM_TYPE_EQUIP)
			{
				_icon.url=EquipBasicManager.Instance.getURL(templateId);
				
				Xtip.registerLinkTip(this,EquipTipMix,TipUtil.equipTipInitFunc,0,templateId);
			}
			else if(type == TypeProps.ITEM_TYPE_PROPS)
			{
				_icon.url=PropsBasicManager.Instance.getURL(templateId);
				
				Xtip.registerLinkTip(this,PropsTip,TipUtil.propsTipInitFunc,0,templateId);
			}
			
		}
		
		public function disposeContent(obj:Object=null):void
		{
			if(_icon)
			{
				_icon.clear();
				removeChild(_icon);
				_icon=null;
			}
			_item=null;
			Xtip.clearLinkTip(this);
			
		}
		
		public function removeListener():void
		{
			removeEventListener(MouseEvent.CLICK,onIconClick);
			removeEventListener(MouseEvent.MOUSE_DOWN,onStartDrag);
		}
		
		/**
		 * 物品id 
		 * @return 
		 * 
		 */		
		public function get boxKey():int
		{
			return _itemId;
		}
		
		/**
		 * 物品类型
		 * @return 
		 * 
		 */		
		public function get boxType():int
		{
			return _itemType;
		}
		//======================================================================
		//        private function
		//======================================================================
		private function addEvents():void
		{
			addEventListener(MouseEvent.CLICK,onIconClick);
			addEventListener(MouseEvent.MOUSE_DOWN,onStartDrag);
		}
		//======================================================================
		//        event handler
		//======================================================================
		private function onIconClick(e:MouseEvent):void
		{
			PurchaseItemWindow.instance.switchToTop();
			switch(_type)
			{
				case MarketSource.CONSIGH:
					YFEventCenter.Instance.dispatchEventWith(MarketEvent.CLEAR_CONSIGNMENT_ITEM,_item);
					YFEventCenter.Instance.dispatchEventWith(GlobalEvent.BagChange);
					disposeContent();
					break;
				case MarketSource.PURCHASE:
					YFEventCenter.Instance.dispatchEventWith(MarketEvent.CLEAR_PERCHASE_ITEM,_item);	
					disposeContent();
					break;
				case MarketSource.SIFT:
					var otherWindow:Window=WindowManager.getTopWindow(PurchaseItemWindow,SiftItemWindow);
					if(otherWindow is PurchaseItemWindow)
					{
						var purWin:PurchaseItemWindow=otherWindow as PurchaseItemWindow;
						if(purWin.getTabIndex() == 1)
						{
							var nowNum:int=MarketDyManager.instance.myPurchaseItemsNum;
							if(nowNum == MarketSource.MY_TOTAL_ITEMS)
							{
								NoticeManager.setNotice(NoticeType.Notice_id_1605);
							}
							else
							{
								YFEventCenter.Instance.dispatchEventWith(MarketEvent.MOVE_TO_PURCHASE_ITEM,_item);
							}
						}
					}				
					break;
			}

		}
		
		private function onStartDrag(e:MouseEvent):void
		{
			if(_icon)
			{
				var dragVO:DragData = new DragData();
				dragVO.data=new Object();
				dragVO.fromID = _item.pos;
				if(_type == MarketSource.CONSIGH)
					dragVO.type = DragData.FROM_CONSIGNMENT;
				else if(_type == MarketSource.SIFT)
					dragVO.type = DragData.FROM_SIFT_WINDOW;
				dragVO.data.type = _item.type;
				dragVO.data.id = _item.id;
				
				DragManager.Instance.startDrag(_icon,dragVO);
			}
		}
		
		//======================================================================
		//        getter&setter
		//======================================================================
		public function get icon():IconImage
		{
			return _icon;
		}

		
	}
} 