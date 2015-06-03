package com.YFFramework.game.core.module.trade.view
{
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.game.core.global.view.window.WindowTittleName;
	import com.YFFramework.game.core.module.trade.events.TradeEvent;
	import com.YFFramework.game.core.module.trade.manager.TradeDyManager;
	import com.YFFramework.game.core.module.trade.view.render.TradeRender;
	import com.dolo.ui.controls.List;
	import com.dolo.ui.controls.PopMiniWindow;
	import com.dolo.ui.controls.Window;
	import com.dolo.ui.data.ListItem;
	import com.dolo.ui.tools.Xdis;
	
	import flash.display.Sprite;
	import flash.events.Event;

	/**
	 * @version 1.0.0
	 * creation time：2013-5-2 上午11:12:48
	 * 
	 */
	public class TradeInviteWindow extends PopMiniWindow{
		
		private var _mc:Sprite;
		private var _list:List;
		
		public function TradeInviteWindow(){
			_mc = initByArgument(369,345,"invitePanel",WindowTittleName.tradeReqTitle);
			_list = Xdis.getChild(_mc,"invite_list");
			_list.itemRender = TradeRender;
			
			YFEventCenter.Instance.addEventListener(TradeEvent.CloseInviteWindow,onClose);
		}
		/**更新列表
		 */		
		public function updateList():void{
			var item:ListItem;
			var tradeList:Array=TradeDyManager.Instance.getTradeList();
			var len:int = tradeList.length;
			for(var i:int=0;i<len;i++){
				item = new ListItem();
				item.name = tradeList[i].name;
				item.lv = tradeList[i].lv;
				item.dyId = tradeList[i].dyId;
				_list.addItem(item);
			}
			TradeDyManager.Instance.emptyTradeList();
		}
		
		override public function close(event:Event=null):void{
			super.close(event);
			this.dispose();
		}
		
		override public function dispose():void{
			_list.removeAll();
		}

		private function onClose(e:YFEvent):void{
			if(_list.length==0)	this.close();
		}
	}
} 