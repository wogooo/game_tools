package com.YFFramework.game.core.module.exchange.view.render
{
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.game.core.module.exchange.event.ExchangeEvent;
	import com.YFFramework.game.core.module.exchange.model.Exchange_MapBasicVo;
	import com.YFFramework.game.core.module.exchange.view.ExchangeContainerCtrl;
	import com.dolo.ui.renders.ListRenderBase;
	import com.dolo.ui.tools.AutoBuild;
	import com.dolo.ui.tools.Xdis;
	
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	/***
	 *兑换单条渲染类
	 *@author ludingchang 时间：2013-8-17 下午4:04:18
	 */
	public class ExchangeItemRender extends ListRenderBase
	{
		private var _exchange_btn:SimpleButton;
		private var _item:Exchange_MapBasicVo;

		private var _needCTRL:ExchangeContainerCtrl;

		private var _getCTRL:ExchangeContainerCtrl;
		public function ExchangeItemRender()
		{
			_renderHeight=85;
		}
		override protected function resetLinkage():void
		{
			_linkage="uiSkin.Exchange_item";
		}
		override protected function onLinkageComplete():void
		{
			AutoBuild.replaceAll(_ui);
			var _container1:Sprite=Xdis.getChild(_ui,"container1");
			var _container2:Sprite=Xdis.getChild(_ui,"container2");
			_needCTRL=new ExchangeContainerCtrl(_container1);
			_getCTRL=new ExchangeContainerCtrl(_container2);
			_exchange_btn=Xdis.getChildAndAddClickEvent(onExchange,_ui,"exchange_btn");
		}
		
		private function onExchange(e:MouseEvent):void
		{
			YFEventCenter.Instance.dispatchEventWith(ExchangeEvent.DoExchange,_item);
		}
		override protected function updateView(item:Object):void
		{
			_item = item as Exchange_MapBasicVo;
			var h1:Number=_needCTRL.update(ExchangeContainerCtrl.TypeNeed,_item.need_id);
			var h2:Number=_getCTRL.update(ExchangeContainerCtrl.TypeGet,_item.get_id);
			if(h1>=h2)
				_renderHeight=h1+5;
			else
				_renderHeight=h2+5;
			setPos();
		}
		private function setPos():void
		{
			_needCTRL.setPos(_renderHeight/2);
			_getCTRL.setPos(_renderHeight/2);
			_exchange_btn.y=_renderHeight/2-_exchange_btn.height/2;
		}
		override public function dispose():void
		{
			super.dispose();
			_exchange_btn.removeEventListener(MouseEvent.CLICK,onExchange);
			
			_needCTRL.dispose();
			_getCTRL.dispose();
			
			_needCTRL=null;
			_getCTRL=null;
			_exchange_btn=null;
		}
	}
}