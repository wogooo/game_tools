package com.YFFramework.game.core.module.blackShop.view
{
	/**
	 * @author jina;
	 * @version 1.0.0
	 * creation time：2013-9-24 下午4:10:40
	 */
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.net.loader.image_swf.UILoader;
	import com.YFFramework.game.core.global.DataCenter;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.core.global.manager.DyModuleUIManager;
	import com.YFFramework.game.core.global.view.window.WindowTittleName;
	import com.YFFramework.game.core.module.ModuleManager;
	import com.YFFramework.game.core.module.blackShop.data.BlackShopDyManager;
	import com.YFFramework.game.core.module.blackShop.data.BlackShopDyVo;
	import com.YFFramework.game.core.module.notMetion.data.NotMetionDataManager;
	import com.YFFramework.game.core.module.notMetion.view.NotMetionWindow;
	import com.YFFramework.game.core.module.notice.model.NoticeType;
	import com.YFFramework.game.core.module.notice.model.NoticeUtils;
	import com.dolo.ui.controls.Alert;
	import com.dolo.ui.controls.Button;
	import com.dolo.ui.controls.Window;
	import com.dolo.ui.events.AlertCloseEvent;
	import com.dolo.ui.managers.UI;
	import com.dolo.ui.tools.Xdis;
	import com.dolo.ui.tools.Xtip;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class BlackShopWindow extends Window
	{
		//======================================================================
		//       public property
		//======================================================================
		
		//======================================================================
		//       private property
		//======================================================================
		private var _mc:MovieClip;
		private var _numTxt:TextField;
		private var _refreshBtn:Button;
		private var _items:Vector.<BlackShopItem>;
		private var _npcSp:Sprite;
		//======================================================================
		//        constructor
		//======================================================================
		
		public function BlackShopWindow()
		{
			_mc = initByArgument(910,580,"blackShopWindow",WindowTittleName.blackShopTitle,true,DyModuleUIManager.petWinBg) as MovieClip;
			setContentXY(25,28);
			
			var item:BlackShopItem;
			_items=new Vector.<BlackShopItem>();
			for(var i:int=0;i<BlackShopDyManager.MAX;i++)
			{
				var sp:Sprite=_mc.getChildByName("item"+i) as Sprite
				item=new BlackShopItem(sp);
				_items.push(item);
			}
			
			_refreshBtn=Xdis.getChild(_mc,'fresh_button');
			_refreshBtn.addEventListener(MouseEvent.CLICK,onRefreshClick);
			
			_npcSp=Xdis.getChild(_mc,'npcMc');
			_numTxt=Xdis.getChild(_mc,"numTxt");
		}
		
		//======================================================================
		//        public function
		//======================================================================
		override public function open():void
		{
			super.open();
			if(_npcSp.numChildren == 0)
			{
				var loader:UILoader=new UILoader();
				loader.initData(DyModuleUIManager.blackShopNpcBg,_npcSp,DyModuleUIManager.blackShopNpcBg);
			}
			updateView();
			
		}
		override public function close(event:Event=null):void
		{
			closeTo(UI.stage.stageWidth-200,135,0.02,0.04);
		}
		
		public function updateView():void
		{
			var items:Vector.<BlackShopDyVo>=BlackShopDyManager.instance.itemsInfo;
			for(var i:int=0;i<BlackShopDyManager.MAX;i++)
			{
				_items[i].updateView(i+1,items[i].props_id,items[i].buy_info);
			}
			updateRefreshNum();
		}
		
		public function updateRefreshNum():void
		{
			var total:int=BlackShopDyManager.instance.canRefresh;
			var already:int=BlackShopDyManager.instance.refresh;
			var remain:int=total-already;
			if(remain>=0)
				_numTxt.text=remain.toString()+"/"+total.toString();
		}
		
		public function buyRsp(index:int):void
		{
			_items[index].updateBuyRsp();
		}
		//======================================================================
		//        private function
		//======================================================================
		
		//======================================================================
		//        event handler
		//======================================================================
		private function onRefreshClick(e:MouseEvent):void
		{	
			var total:int=BlackShopDyManager.instance.canRefresh;
			var already:int=BlackShopDyManager.instance.refresh;
			if((total-already) <= 0)
			{
//				var buttonLabels:Array = [NoticeUtils.getStr(NoticeType.Notice_id_100005),NoticeUtils.getStr(NoticeType.Notice_id_100006)];
//				var alert:Alert=Alert.show('本次刷新需要5魔钻，确定需要刷新吗？','提示',refresh,buttonLabels);
				if(NotMetionDataManager.blackShopRefresh)
					NotMetionWindow.show('本次刷新需要5魔钻，确定需要刷新吗？',refresh);
				else
				{
					if(DataCenter.Instance.roleSelfVo.diamond >= 5)
					{
						ModuleManager.blackShopModule.refresh();
					}
				}
			}
			else
			{
				ModuleManager.blackShopModule.refresh();
			}
		}
		
		protected function refresh(data:Boolean):void
		{
			NotMetionDataManager.blackShopRefresh=data;
			if(DataCenter.Instance.roleSelfVo.diamond >= 5)
			{
				ModuleManager.blackShopModule.refresh();
			}
			else
			{
				var buttonLabels:Array = [NoticeUtils.getStr(NoticeType.Notice_id_100005),NoticeUtils.getStr(NoticeType.Notice_id_100006)];
				var alert:Alert=Alert.show('您的魔钻不足请充值……','提示',onPay,buttonLabels);
			}
			
		}
		
		protected function onPay(e:AlertCloseEvent):void
		{
			if(e.clickButtonIndex == 1)
			{
				YFEventCenter.Instance.dispatchEventWith(GlobalEvent.Recharge);
			}
		}
		//======================================================================
		//        getter&setter
		//======================================================================
		
	}
} 