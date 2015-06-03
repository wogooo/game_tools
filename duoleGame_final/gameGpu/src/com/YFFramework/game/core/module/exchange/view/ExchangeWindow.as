package com.YFFramework.game.core.module.exchange.view
{
	import com.YFFramework.core.utils.common.ClassInstance;
	import com.YFFramework.game.core.module.exchange.manager.Exchange_MapBasicManager;
	import com.YFFramework.game.core.module.exchange.model.Exchange_MapBasicVo;
	import com.YFFramework.game.core.module.exchange.view.render.ExchangeItemRender;
	import com.dolo.ui.controls.List;
	import com.dolo.ui.controls.Window;
	import com.dolo.ui.tools.AutoBuild;
	import com.dolo.ui.tools.Xdis;
	import com.msg.pets.EmptyReq;
	
	import flash.display.Sprite;
	
	/***
	 *兑换UI
	 *@author ludingchang 时间：2013-8-16 下午3:51:57
	 */
	public class ExchangeWindow extends Window
	{
		private static const uiName:String="Exchange_window";

		private var _list:List;
		public function ExchangeWindow()
		{
			super(0);
			var sp:Sprite=ClassInstance.getInstance(uiName);
			AutoBuild.replaceAll(sp);
//				initByArgument(700,350,uiName);
			_list=Xdis.getChild(sp,"list_list");
			_list.itemRender=ExchangeItemRender;
			setSize(700,350);
			content=sp;
		}
		public override function update():void
		{
			var arr:Vector.<Exchange_MapBasicVo>=Exchange_MapBasicManager.Instance.getAllExchangeMapBasicVo();
		    _list.removeAll();
			var i:int,len:int=arr.length;
			for(i=0;i<len;i++)
			{
				_list.addItem(arr[i]);
			}
		}
	}
}