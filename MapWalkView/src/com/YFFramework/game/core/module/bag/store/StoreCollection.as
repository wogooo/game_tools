package com.YFFramework.game.core.module.bag.store
{
	/**
	 * @version 1.0.0
	 * creation time：2012-11-21 下午01:58:26
	 * 
	 */
	
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.game.core.global.DataCenter;
	import com.YFFramework.game.core.global.manager.BagStoreManager;
	import com.YFFramework.game.core.global.util.NoticeUtil;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.module.bag.baseClass.Collection;
	import com.YFFramework.game.core.module.bag.event.BagEvent;
	import com.YFFramework.game.core.module.bag.source.PackSource;
	import com.dolo.ui.controls.Alert;
	import com.dolo.ui.events.AlertCloseEvent;
	import com.msg.storage.CExpandStorageReq;

	
	public class StoreCollection extends Collection
	{
		//======================================================================
		//        const variable
		//======================================================================
		
		//======================================================================
		//        static variable
		//======================================================================
		
		//======================================================================
		//        variable
		//======================================================================
		private var _money:int=0;
		
		private var _alter:Alert;
		//======================================================================
		//        constructor
		//======================================================================
		
		public function StoreCollection(boxType:int)
		{
			super(boxType);
			addEvents();
		}
		
		//======================================================================
		//        function
		//======================================================================

		//======================================================================
		//        private function
		//======================================================================
		private function addEvents():void
		{
			addEventListener(BagEvent.OPEN_GRID,openGrid);
			addEventListener(BagEvent.HIGH_LIGHT,storeHighLight);
//			addEventListener(BagEvent.ABANDON_ITEM,abandonItem);
		}
		
		private function storeHighLight(e:BagEvent):void
		{		
			highLight(e.data as int);
		}
		
//		private function abandonItem(e:BagEvent):void
//		{
//			YFEventCenter.Instance.dispatchEventWith(BagEvent.BAG_UI_CRemoveFromDepotReq,e.data);
//		}
		//======================================================================
		//        event handler
		//======================================================================
		private function openGrid(e:BagEvent):void
		{
			
			if(BagStoreManager.instantce.getDepotNum() < PackSource.TOTAL_GRIDS)
			{	
				_money=(int((BagStoreManager.instantce.getDepotNum()-PackSource.PAGE_NUM)/PackSource.ROW_GRIDS)+1)*10000;
				var str:String="扩展7格仓库，需要花费*银币，是否继续？";
				str=str.replace("*",_money.toString());
				
				_alter = Alert.show(str,"扩展仓库",onAlertClose,["确认","取消"]);
				
			}
		}

		private function onAlertClose(e:AlertCloseEvent):void
		{
			if(e.clickButtonIndex == 1)
			{
				if(_money <= (DataCenter.Instance.roleSelfVo.silver+DataCenter.Instance.roleSelfVo.note))
				{
					var msg:CExpandStorageReq=new CExpandStorageReq();
					msg.stType=TypeProps.STORAGE_TYPE_DEPOT;
					
					YFEventCenter.Instance.dispatchEventWith(BagEvent.BAG_UI_CExpandStorageReq,msg);
					
				}
				else
				{
					//无提示框提示
					NoticeUtil.setOperatorNotice("金钱不够不能开启!");
				}
			}
			else
			{
				
			}
			
		}

		//======================================================================
		//        getter&setter
		//======================================================================
		
		
	}
} 