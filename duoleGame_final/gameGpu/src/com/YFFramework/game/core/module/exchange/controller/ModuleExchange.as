package com.YFFramework.game.core.module.exchange.controller
{
	import com.CMD.GameCmd;
	import com.YFFramework.core.center.abs.module.AbsModule;
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.core.global.manager.PropsDyManager;
	import com.YFFramework.game.core.global.util.NoticeUtil;
	import com.YFFramework.game.core.module.exchange.event.ExchangeEvent;
	import com.YFFramework.game.core.module.exchange.manager.Exchange_NeedBasicManager;
	import com.YFFramework.game.core.module.exchange.model.Exchange_MapBasicVo;
	import com.YFFramework.game.core.module.exchange.model.Exchange_NeedBasicVo;
	import com.YFFramework.game.core.module.exchange.view.ExchangeWindow;
	import com.YFFramework.game.core.scence.TypeScence;
	import com.msg.actv.CExchangeItems;
	import com.msg.actv.SExchangeItems;
	import com.net.MsgPool;
	
	/***
	 *兑换module
	 *@author ludingchang 时间：2013-8-16 下午3:38:59
	 */
	public class ModuleExchange extends AbsModule
	{

		private var _EXwindow:ExchangeWindow;
		public function ModuleExchange()
		{
			super();
			_belongScence=TypeScence.ScenceGameOn;
			_EXwindow=new ExchangeWindow;

		}
		override public function init():void
		{
			addEvents();
			addSocketEvent();
		}
		
		private function addSocketEvent():void
		{
			MsgPool.addCallBack(GameCmd.SExchangeItems,SExchangeItems,reExchangeItems);//兑换返回
		}
		
		private function reExchangeItems(msg:SExchangeItems):void
		{
			if(msg.result==0)
				NoticeUtil.setOperatorNotice("兑换成功");
			else
				NoticeUtil.setOperatorNotice("兑换失败");
		}
		
		private function addEvents():void
		{
			YFEventCenter.Instance.addEventListener(GlobalEvent.ExchangeUIshow,showUI);//打开UI
			YFEventCenter.Instance.addEventListener(ExchangeEvent.DoExchange,doExchange);//请求兑换奖励
		}
		
		private function doExchange(e:YFEvent):void
		{
			var vo:Exchange_MapBasicVo=e.param as Exchange_MapBasicVo;
			var needVos:Vector.<Exchange_NeedBasicVo>=Exchange_NeedBasicManager.Instance.getExchange_NeedBasicVo(vo.need_id);
			var msg:CExchangeItems=new CExchangeItems;
			msg.exchangeId=vo.map_id;
			msg.items=[];
			var i:int,len1:int=needVos.length;
			var items:Array;
			for(i=0;i<len1;i++)
			{
				var nv:Exchange_NeedBasicVo=needVos[i];
				items=PropsDyManager.instance.getPropsPosArray(nv.item_id,nv.item_num);
				if(items&&items.length>0)
				{
					var j:int,len2:int=items.length;
					var total:int=0;
					for(j=0;j<len2;j++)
					{
						total+=items[j].number;
					}
					if(total<nv.item_num)
					{
						NoticeUtil.setOperatorNotice("道具数量不足");
						return;
					}
					else
					{
						msg.items=msg.items.concat(items);
						items=null;
					}
				}
				else
				{
					NoticeUtil.setOperatorNotice("道具数量不足");
					return;
				}
			}
			MsgPool.sendGameMsg(GameCmd.CExchangeItems,msg);
		}
		
		private function showUI(e:YFEvent):void
		{
			_EXwindow.open();
			_EXwindow.update();
		}
	}
}