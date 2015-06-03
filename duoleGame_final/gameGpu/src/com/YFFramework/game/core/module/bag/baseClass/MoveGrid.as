package com.YFFramework.game.core.module.bag.baseClass
{
	import com.YFFramework.core.center.manager.dbClick.DBClickManager;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.game.core.global.DataCenter;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.core.global.manager.EquipBasicManager;
	import com.YFFramework.game.core.global.manager.EquipDyManager;
	import com.YFFramework.game.core.global.manager.PropsBasicManager;
	import com.YFFramework.game.core.global.model.EquipBasicVo;
	import com.YFFramework.game.core.global.model.PropsBasicVo;
	import com.YFFramework.game.core.global.util.DragManager;
	import com.YFFramework.game.core.global.util.NoticeUtil;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.module.bag.Interface.IMoveGrid;
	import com.YFFramework.game.core.module.bag.data.BagStoreManager;
	import com.YFFramework.game.core.module.bag.event.BagEvent;
	import com.YFFramework.game.core.module.bag.source.BagSource;
	import com.YFFramework.game.core.module.bag.store.StoreWindow;
	import com.YFFramework.game.core.module.market.source.MarketSource;
	import com.YFFramework.game.core.module.market.view.window.ConsignItemWindow;
	import com.YFFramework.game.core.module.notice.manager.NoticeManager;
	import com.YFFramework.game.core.module.notice.model.NoticeType;
	import com.YFFramework.game.core.module.shop.data.ShopDyManager;
	import com.YFFramework.game.core.module.shop.view.ShopWindow;
	import com.YFFramework.game.core.module.skill.model.DragData;
	import com.YFFramework.game.core.module.trade.manager.TradeDyManager;
	import com.YFFramework.game.core.module.trade.view.TradeWindow;
	import com.dolo.ui.controls.Window;
	import com.dolo.ui.tools.WindowManager;
	import com.dolo.ui.tools.Xtip;
	import com.msg.item.Unit;
	import com.msg.storage.CMoveItemReq;
	import com.msg.storage.CSellItemReq;
	
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * @version 1.0.0
	 * creation time：2012-11-15 下午03:31:10
	 * 
	 */
	
	
	public class MoveGrid extends BagGrid implements IMoveGrid
	{
		//======================================================================
		//        const variable
		//======================================================================
		
		//======================================================================
		//        static variable
		//======================================================================
		/**
		 *基本不用动原有的东西，可以添加 
		 */		
		//======================================================================
		//        variable
		//======================================================================
		private var _isDoubleClick:Boolean;
		private var MendFactor:Number=1.0;
		//======================================================================
		//        constructor
		//======================================================================
		
		public function MoveGrid()
		{			
//			super(id);
			this.addEventListener(MouseEvent.CLICK,onMouseClick);
			DBClickManager.Instance.regDBClick(this,onMouseDoubleClick);
			addEventListener(MouseEvent.MOUSE_DOWN,onMouseDownHandler);
		}		
		
		//======================================================================
		//        function
		//======================================================================		
		override public function dispose(e:Event=null):void
		{
			super.dispose(e);
			this.removeEventListener(MouseEvent.CLICK,onMouseClick);
			DBClickManager.Instance.delDBClick(this);
			removeEventListener(MouseEvent.MOUSE_DOWN,onMouseDownHandler);
		}
		
		
		//======================================================================
		//        private function
		//======================================================================
		private function startDragGrid(fromBox:MoveGrid):void
		{
			if(fromBox && fromBox.info != null)
			{
				var dragVO:DragData = new DragData();
				dragVO.data=new Object();
				dragVO.fromID = info.pos;
				if(boxType == TypeProps.STORAGE_TYPE_PACK)
				{
					dragVO.type = DragData.FROM_BAG;
				}
				else if(boxType == TypeProps.STORAGE_TYPE_DEPOT)
				{
					dragVO.type = DragData.FROM_DEPOT;
				}
				dragVO.data.type = info.type;
				dragVO.data.id = info.id;//动态id
				//绑定与否，针对交易
				if(getBound())
					dragVO.data.bound=true;
				else
					dragVO.data.bound=false;
				iconImage.filters=null;
				DragManager.Instance.startDrag(iconImage,dragVO);
				
				Xtip.clearTip(this);
				
//				PackSource.startDrag=true;
			}
		}

		//======================================================================
		//        event handler
		//======================================================================
		/** 
		 * 背包正常模式下（非交易、寄售），双击使用道具、穿上装备；打开宠物对应面板
		 */		
		protected function onMouseDoubleClick():void
		{
			_isDoubleClick = true;
			
			if(boxType == TypeProps.STORAGE_TYPE_PACK && info != null)//这个地方为什么要判断锁定否？
			{	
				if(BagSource.shopMend == false && BagSource.shopSell == false)
				{
					if((TradeDyManager.isTrading || MarketSource.ConsignmentStatus) && getLock())//在寄售或交易模式下，锁定不能使用
						return;
					YFEventCenter.Instance.dispatchEventWith(BagEvent.USE_ITEM,info);
					BagSource.popUp=false;
				}
			}	
			
		}
		
		protected function onMouseClick(event:MouseEvent):void
		{
			if(_isDoubleClick) return;
			else
			{
				if(info)
				{
					var otherWindow:Window;
					if(boxType == TypeProps.STORAGE_TYPE_PACK)
					{
						otherWindow=WindowManager.getTopWindow(StoreWindow,TradeWindow,ShopWindow,ConsignItemWindow);
						if(otherWindow is StoreWindow)//移动到仓库
						{
							if(getLock() == false)//不锁定的才能放入仓库
							{
								if(BagStoreManager.instantce.remainDepotNum() > 0)//判断是否仓库里有足够多的格子
								{
									moveToStoreMsg();
									return;
								}
								else
								{
									NoticeManager.setNotice(NoticeType.Notice_id_328);
									return;
								}
							}
						}
						else if(otherWindow is TradeWindow)//移动到交易面板，不能移动绑定，锁定的;打开了交易面板就一定是交易模式
						{
							if(getBound() == false && getLock() == false)
							{
								YFEventCenter.Instance.dispatchEventWith(BagEvent.MOVE_TO_TRADE,info);
								return;
							}
							else if(getLock())//锁定的物品没有弹出菜单
								return;
							
						}
						else if(otherWindow is ConsignItemWindow)
						{
							if(getBound() == false && getLock() == false)
							{
//								YFEventCenter.Instance.dispatchEventWith(BagEvent.MOVE_TO_CONSIGHITEM,info);
								YFEventCenter.Instance.dispatchEventWith(GlobalEvent.MoveToConsignment,info);
								return;
							}
							else if(getBound())
							{
								NoticeManager.setNotice(NoticeType.Notice_id_329);
								return;
							}
							else if(getLock())//锁定的物品没有弹出菜单
								return;
						}
						if(BagSource.shopMode == BagSource.SHOP_SELL)
						{
							if(info.type == TypeProps.ITEM_TYPE_PROPS)
							{
								var vo:PropsBasicVo=PropsBasicManager.Instance.getPropsBasicVo(_propsInfo.templateId);
								if(vo.type == TypeProps.PROPS_TYPE_TASK || vo.type == TypeProps.PROPS_TYPE_GIFTPACKS)
								{
									NoticeManager.setNotice(NoticeType.Notice_id_330);
									return;
								}
							}
							//出售东西, 交易.寄售锁定的东西不能卖
							if(getLock() == false)
							{
								var msg:CSellItemReq=new CSellItemReq();
								msg.sourcePos=info.pos;
								YFEventCenter.Instance.dispatchEventWith(BagEvent.BAG_UI_CSellItemReq,msg);
								ShopDyManager.instance.saveClientBackList(info);//把出售的东西放入回购列表
								return;
							}
							
						}	
						//修理装备
						if(BagSource.shopMode == BagSource.SHOP_FIX)
						{
							if(info.type == TypeProps.ITEM_TYPE_EQUIP && getLock() == false)
							{
								var curDurability:int=EquipDyManager.instance.getEquipInfo(info.id).cur_durability;
								var tmpId:int=EquipDyManager.instance.getEquipInfo(info.id).template_id;
								var equip:EquipBasicVo=EquipBasicManager.Instance.getEquipBasicVo(tmpId);
								var allDurability:int=EquipBasicManager.Instance.getEquipBasicVo(equip.template_id).durability;
								if(curDurability < allDurability)
								{
									var needMoney:int=DataCenter.Instance.roleSelfVo.note;
									var consumeMoney:int=equip.level*(allDurability-curDurability)*MendFactor;
									if(needMoney > consumeMoney)
									{
										YFEventCenter.Instance.dispatchEventWith(BagEvent.BAG_UI_CRepairEquipReq,info.pos);
										return;
									}
								}
								else
								{
									NoticeManager.setNotice(NoticeType.Notice_id_331);
								}
							}
						}
						
						else//弹出菜单
						{
							YFEventCenter.Instance.dispatchEventWith(BagEvent.POP_UP_SECOND_MENU,info.pos);
							BagSource.popUp=true;
						}
					}
					else if(boxType == TypeProps.STORAGE_TYPE_DEPOT)
					{
						if(BagStoreManager.instantce.remainBagNum() > 0)
							moveToStoreMsg();
						else
							NoticeManager.setNotice(NoticeType.Notice_id_302);
						
					}
					
				}
				else
				{
					//开启格子
					if(getCoverStatus())
					{
						if(boxType == TypeProps.STORAGE_TYPE_PACK)
						{
							YFEventCenter.Instance.dispatchEventWith(BagEvent.OPEN_BAG_GRID);
						}
						else
						{
							YFEventCenter.Instance.dispatchEventWith(BagEvent.OPEN_STORE_GRID);
						}
					}
				}
				
			}
		}
		
		private function moveToStoreMsg():void
		{
			var msg:CMoveItemReq=new CMoveItemReq();
			msg.item=new Unit();
			
			if(boxType == TypeProps.STORAGE_TYPE_PACK)
			{
				msg.movDirect=TypeProps.MOV_DIRECT_PACK_TO_DEPOT;
				msg.sourcePos=info.pos;					
				
			}
			else if(boxType == TypeProps.STORAGE_TYPE_DEPOT)
			{
				msg.movDirect=TypeProps.MOV_DIRECT_DEPOT_TO_PACK;
				msg.sourcePos=info.pos;
			}				
			
			msg.targetPos=-1;
			var item:Unit=new Unit();
			item.id=info.id;
			item.type=info.type;
			msg.item=new Unit();
			msg.item=item;
			YFEventCenter.Instance.dispatchEventWith(BagEvent.BAG_UI_CMoveItemReq,msg);
		}
		
		private function onMouseDownHandler(e:MouseEvent):void
		{
//			super.onMouseDownHandler(e);
			
			_isDoubleClick = false;
			
			if(BagSource.shopMend == false && TradeDyManager.isTrading == false && MarketSource.ConsignmentStatus == false)
			{
				startDragGrid(this);
			}
			else if(TradeDyManager.isTrading == true || MarketSource.ConsignmentStatus == true)
			{
				var lock:Boolean=getLock();
				if(lock == false)
					startDragGrid(this);
			}
			
		}

		//======================================================================
		//        getter&setter
		//======================================================================
		public function get boxKey():int
		{
			return actualPos;
		}
		
	}
} 