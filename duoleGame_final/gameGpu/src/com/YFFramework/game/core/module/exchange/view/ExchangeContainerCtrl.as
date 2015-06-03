package com.YFFramework.game.core.module.exchange.view
{
	import com.YFFramework.game.core.module.exchange.manager.Exchange_GetBasicManager;
	import com.YFFramework.game.core.module.exchange.manager.Exchange_NeedBasicManager;
	import com.YFFramework.game.core.module.exchange.model.Exchange_GetBasicVo;
	import com.YFFramework.game.core.module.exchange.model.Exchange_NeedBasicVo;
	import com.dolo.ui.tools.Xdis;
	
	import flash.display.Sprite;
	import flash.text.TextField;

	/***
	 *兑换容器控制类
	 *@author ludingchang 时间：2013-8-17 下午4:23:46
	 */
	public class ExchangeContainerCtrl
	{
		public static const TypeGet:int=1;
		public static const TypeNeed:int=2;
		private static const MaxNumOneLine:int=4;
		private static const DisX:int=13;
		private static const DisY:int=12;
		private static const EachW:int=54;
		private static const EachH:int=68;
		
		private var _box:Sprite;
		private var _items:Vector.<ExchangeItem>;
		private var _sp:Sprite;
		public function ExchangeContainerCtrl(sp:Sprite)
		{
			_sp=sp;
			_box=Xdis.getChild(sp,"box");
			_items=new Vector.<ExchangeItem>;
		}
		public function update(type:int,id:int):Number
		{
			clearItems();
			var item:ExchangeItem;
			if(type==TypeGet)
			{
				var getVos:Vector.<Exchange_GetBasicVo>=Exchange_GetBasicManager.Instance.getExchange_GetBasicVo(id);
				
				setSize(getVos.length);
				
				var i:int,len:int=getVos.length;
				for(i=0;i<len;i++)
				{
					item=new ExchangeItem();
					item.initByGetVo(getVos[i]);
					item.x=DisX+(i%MaxNumOneLine)*EachW;
					item.y=DisY+int(i/MaxNumOneLine)*EachH;
					_sp.addChild(item);
					_items.push(item);
				}
			}
			else if(type==TypeNeed)
			{
				var needVos:Vector.<Exchange_NeedBasicVo>=Exchange_NeedBasicManager.Instance.getExchange_NeedBasicVo(id);
				
				setSize(needVos.length);
				
				var j:int,len2:int=needVos.length;
				for(j=0;j<len2;j++)
				{
					item=new ExchangeItem;
					item.initByNeedVo(needVos[j]);
					item.x=DisX+(j%MaxNumOneLine)*EachW;
					item.y=DisY+int(j/MaxNumOneLine)*EachH;
					_sp.addChild(item);
					_items.push(item);
				}
			}
			return _sp.height;
		}
		private function clearItems():void
		{
			var i:int,len:int=_items.length;
			var item:ExchangeItem;
			for(i=0;i<len;i++)
			{
				item=_items[i];
				if(item&&item.parent)
					item.parent.removeChild(item);
			}
			_items.length=0;
		}
		private function setSize(len:int):void
		{
			var lines:int=Math.ceil(len/MaxNumOneLine);
			_box.height=DisY+lines*EachH;
		}
		public function dispose():void
		{
			_box=null;
			clearItems();
		}
		public function setPos(center:Number):void
		{
			_sp.y=center-_sp.height/2;
		}
	}
}