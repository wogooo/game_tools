package com.YFFramework.game.core.module.bag.source
{
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.game.core.global.manager.PropsBasicManager;
	import com.YFFramework.game.core.global.manager.PropsDyManager;
	import com.YFFramework.game.core.global.model.ItemDyVo;
	import com.YFFramework.game.core.global.model.PropsBasicVo;
	import com.YFFramework.game.core.global.model.PropsDyVo;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.module.bag.event.BagEvent;
	import com.YFFramework.game.core.module.notice.model.NoticeType;
	import com.YFFramework.game.core.module.notice.model.NoticeUtils;
	import com.dolo.ui.controls.Menu;
	
	import flash.geom.Point;

	/**
	 * @version 1.0.0
	 * creation time：2013-4-28 上午9:51:51
	 * 
	 */
	public class BagPopUpMenu
	{
		//======================================================================
		//       public property
		//======================================================================
		
		//======================================================================
		//       private property
		//======================================================================
		private static var _instance:BagPopUpMenu;
		
		private var lastMenu:Menu;
		
		private var _curInfo:ItemDyVo;
		
		private var _menuIndex:int;
		//======================================================================
		//        constructor
		//======================================================================
		
		public function BagPopUpMenu()
		{
		}
		
		//======================================================================
		//        public function
		//======================================================================
		public static function Instance():BagPopUpMenu
		{
			if(_instance == null)
			{
				_instance=new BagPopUpMenu();
				return _instance;
			}
			return _instance;
		}
		
		public function popUp(pos:Point,curInfo:ItemDyVo):void
		{
			if(lastMenu)
				lastMenu.remove();
			
			_curInfo=curInfo;
			
			var menu:Menu=new Menu();
			menu.addItem(NoticeUtils.getStr(NoticeType.Notice_id_100021),onMenuClick);
			menu.addItem(NoticeUtils.getStr(NoticeType.Notice_id_100022),onMenuClick);
			menu.addItem(NoticeUtils.getStr(NoticeType.Notice_id_100023),onMenuClick);
			menu.addItem(NoticeUtils.getStr(NoticeType.Notice_id_100024),onMenuClick);
			
			if(_curInfo.type == TypeProps.ITEM_TYPE_PROPS)//道具类
			{
				if(PropsDyManager.instance.getPropsInfo(_curInfo.id))//如果有这个道具
				{
					var pDyVo:PropsDyVo=PropsDyManager.instance.getPropsInfo(_curInfo.id);
					var pBsVo:PropsBasicVo=PropsBasicManager.Instance.getPropsBasicVo(pDyVo.templateId);
					if(pBsVo.type == TypeProps.PROPS_TYPE_TASK)//如果是任务道具,不能使用、丢弃
					{
						menu.disableItem(0);
						menu.disableItem(3);
						if(pDyVo.quantity == 1)
						{
							menu.disableItem(1);
						}
					}
					else//其他道具
					{
						if(pDyVo.quantity == 1)
						{
							menu.disableItem(1);
						}
						else
						{
							if(pBsVo.type == TypeProps.PROPS_TYPE_GIFTPACKS || pBsVo.type == TypeProps.PROPS_TYPE_OTHER_USE ||
								pBsVo.type == TypeProps.PROPS_TYPE_ATTR_UP || pBsVo.type == TypeProps.PROPS_TYPE_EXP_UP ||
								pBsVo.type == TypeProps.PROPS_TYPE_OPEN_PACK || pBsVo.type == TypeProps.PROPS_TYPE_OPEN_DEPOT ||
								pBsVo.type == TypeProps.PROPS_TYPE_MAGIC_SOUL || pBsVo.type == TypeProps.PROPS_TYPE_HPPOOL ||
								pBsVo.type == TypeProps.PROPS_TYPE_MPPOOL)
								menu.addItem('使用全部',onMenuClick);
						}
					}
				}
			}
			else//装备道具
			{
				menu.disableItem(1);
			}
			
			menu.show(null,pos.x,pos.y);
			lastMenu=menu;
		}
		//======================================================================
		//        private function
		//======================================================================
		private function onMenuClick(index:uint,label:String):void
		{
			switch(index)
			{
				case BagSource.MENU_USE:
					YFEventCenter.Instance.dispatchEventWith(BagEvent.POP_UP_INDEX,BagSource.MENU_USE);
					break;
				case BagSource.MENU_SPILT:
					YFEventCenter.Instance.dispatchEventWith(BagEvent.POP_UP_INDEX,BagSource.MENU_SPILT);
					break;
				case BagSource.MENU_SHOW://展示
					YFEventCenter.Instance.dispatchEventWith(BagEvent.POP_UP_INDEX,BagSource.MENU_SHOW);
					break;
				case BagSource.MENU_ABANDON:
					YFEventCenter.Instance.dispatchEventWith(BagEvent.POP_UP_INDEX,BagSource.MENU_ABANDON);
					break;
				case BagSource.MENU_USE_MORE:
					YFEventCenter.Instance.dispatchEventWith(BagEvent.POP_UP_INDEX,BagSource.MENU_USE_MORE);
					break;
			}
		}

		
		public function removeMenu():void
		{
			if(lastMenu)
				lastMenu.remove();
		}
		//======================================================================
		//        event handler
		//======================================================================
		
		//======================================================================
		//        getter&setter
		//======================================================================
		
		
	}
} 