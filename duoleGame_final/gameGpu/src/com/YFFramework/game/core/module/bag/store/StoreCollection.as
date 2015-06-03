package com.YFFramework.game.core.module.bag.store
{
	/**
	 * @version 1.0.0
	 * creation time：2012-11-21 下午01:58:26
	 * 
	 */
	
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.game.core.global.DataCenter;
	import com.YFFramework.game.core.global.manager.ConfigDataManager;
	import com.YFFramework.game.core.global.manager.PropsDyManager;
	import com.YFFramework.game.core.global.util.NoticeUtil;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.module.ModuleManager;
	import com.YFFramework.game.core.module.bag.baseClass.Collection;
	import com.YFFramework.game.core.module.bag.data.BagStoreManager;
	import com.YFFramework.game.core.module.bag.event.BagEvent;
	import com.YFFramework.game.core.module.bag.source.BagSource;
	import com.YFFramework.game.core.module.notMetion.data.NotMetionDataManager;
	import com.YFFramework.game.core.module.notMetion.view.NotMetionWindow;
	import com.YFFramework.game.core.module.notice.manager.NoticeManager;
	import com.YFFramework.game.core.module.notice.model.NoticeType;
	import com.dolo.ui.controls.Alert;
	import com.dolo.ui.events.AlertCloseEvent;
	import com.msg.common.ItemConsume;
	
	import flash.display.Sprite;

	
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
		
		public function StoreCollection(boxType:int,mc:Sprite)
		{
			super(boxType,mc);
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
			YFEventCenter.Instance.addEventListener(BagEvent.OPEN_STORE_GRID,openGrid);
		}
		
		//======================================================================
		//        event handler
		//======================================================================
		private function openGrid(e:YFEvent):void
		{
			var mouseOverGridIndex:int=getMouseOverGridIndex();//此处mouseOverGridIndex是鼠标点击的位置，索引从 0开始  计算总量需要加上1  计算开启格子数是  left= mouseOverGridIndex+1  - 开启的数量
			var openGridNum:int=mouseOverGridIndex+1 -BagStoreManager.instantce.getPackNum();  //开启的格子数
			_money=ConfigDataManager.Instance.getConfigData("depot_one_line_money").config_value;
			var propsNum:int=PropsDyManager.instance.getPropsQuantity(BagSource.OPEN_STORE_GRID_PROPS);//这个数字是我直接查表的，有可能会改变，到时候再改，与其写configMap里让策划不长脑子总不填，还不如直接写死呢				
			if(propsNum > 0)//背包里的道具数量够开格子的
			{
				var num:int=Math.min(openGridNum,propsNum);
				Alert.show("剩余"+num.toString()+"个仓库扩充石可以使用，是否开启?",'提示',openGridsComfirm,['确认','取消'],true,num);							
			}
			else
			{
				if(NotMetionDataManager.storeOpenGrid == false)//面板不用打开
				{
					if(_money <= DataCenter.Instance.roleSelfVo.diamond)
					{
						ModuleManager.bagModule.expandSorageReq(TypeProps.STORAGE_TYPE_DEPOT);
					}
					else
						NoticeUtil.setOperatorNotice('魔钻不足！');
					return;
				}
				var str:String="扩展7格仓库，需要花费"+_money.toString()+"魔钻，是否继续？";			
				NotMetionWindow.show(str,onConsumeMoney);			
			}
		}

		private function openGridsComfirm(e:AlertCloseEvent):void
		{
			if(e.clickButtonIndex == BagSource.ALTER_COMFIRM)
			{
				var propsNum:int=e.data as int;
				var storeRemainGrid:int=BagSource.TOTAL_GRIDS-BagStoreManager.instantce.getDepotNum();
				var num:int;
				if(storeRemainGrid >= propsNum)  num=propsNum;//格子数大于道具数，也就是道具可全部用完
				else  num = propsNum - storeRemainGrid;//道具用不完
				var posAry:Array=PropsDyManager.instance.getPropsPosArray(BagSource.OPEN_BAG_GRID_PROPS,Math.min(propsNum,num));
				for each(var itemPos:ItemConsume in posAry)
				{
					ModuleManager.bagModule.useItemMoreReq(itemPos.pos,itemPos.number);
				}	
			}
		}
		
		private function onConsumeMoney(data:Boolean):void
		{
			NotMetionDataManager.storeOpenGrid=data;
			if(_money <= DataCenter.Instance.roleSelfVo.note)
			{
				ModuleManager.bagModule.expandSorageReq(TypeProps.STORAGE_TYPE_DEPOT);
			}
			else
			{
				//无提示框提示
				NoticeManager.setNotice(NoticeType.Notice_id_332);
			}
			
		}

		//======================================================================
		//        getter&setter
		//======================================================================
		
		
	}
} 