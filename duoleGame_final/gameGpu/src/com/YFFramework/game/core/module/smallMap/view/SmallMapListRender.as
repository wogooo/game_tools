package com.YFFramework.game.core.module.smallMap.view
{
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.game.core.global.DataCenter;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.core.global.model.FlyBootVo;
	import com.YFFramework.game.core.module.smallMap.model.SmallMapListItemVo;
	import com.dolo.ui.data.ListItem;
	import com.dolo.ui.renders.TreeNodeRenderBase;
	
	import flash.events.MouseEvent;

	/**@author yefeng
	 * 2013 2013-6-4 下午3:11:39 
	 */
	
	/**小地图子对象  的树形节点
	 */	
	public class SmallMapListRender extends TreeNodeRenderBase
	{
		/**带有的数据
		 */		
		private var _listItem:ListItem;
		public function SmallMapListRender()
		{
			super();
		}
		/**
		 * 子类如果要使用自己的显示对象的话应该覆盖此方法并设置 _linkage为自己的库链接名，此链接名生成的实例对应_ui变量
		 * 
		 */
		override protected function resetLinkage():void
		{
			_linkage = "All_smallMapListRender";  //该链接名在smallMap包里面
		}
		/**设置小飞鞋图标
		 */		
		override protected function onLinkageComplete():void
		{
			_icon.linkage="a931803630";//设置小飞鞋图标 的链接名
			_icon.buttonMode=true;
			addIconEvents();
			mouseChildren=mouseEnabled=true;
			_icon.mouseEnabled=true;
			_icon.mouseChildren=false;
		}
		protected function addIconEvents():void
		{
			_icon.addEventListener(MouseEvent.CLICK,onIconClick);
		}
		protected function removeIconEvents():void
		{
			_icon.removeEventListener(MouseEvent.CLICK,onIconClick);
		}
		
		private function onIconClick(e:MouseEvent):void
		{
			var flyBootVo:FlyBootVo=new FlyBootVo();
			var smallMapListItemVo:SmallMapListItemVo=_listItem.vo;
			flyBootVo.mapId=DataCenter.Instance.getMapId();  ///当前场景的 寻路
			flyBootVo.mapX=smallMapListItemVo.mapX;
			flyBootVo.mapY=smallMapListItemVo.mapY;
			flyBootVo.seach_id=smallMapListItemVo.npcId;
			if(smallMapListItemVo.type==SmallMapListItemVo.TypeNPC)  //为 npc 则向  玩家靠近
			{
				YFEventCenter.Instance.dispatchEventWith(GlobalEvent.SKipToPlayer,flyBootVo);
			}
			else if(smallMapListItemVo.type==SmallMapListItemVo.TypePt)  //为点 则向目标点靠近
			{
				YFEventCenter.Instance.dispatchEventWith(GlobalEvent.SKipToPoint,flyBootVo);
			}
		}
		/** 根据数据显示UI
		 * @param value
		 * 
		 */
		override protected function updateView(item:Object):void
		{
			_listItem=item as ListItem;
			if(_txt && _listItem.hasOwnProperty("label") )
			{
				_txt.htmlText = _listItem.label;
			}
//			if(value.hasOwnProperty("icon") && value.icon != null && _icon)
//			{
//				_hasIcon = true;
//				_icon.linkage = value.icon;
//			}
//			else if(_txt){
//				_txt.x = _icon.x;
//			}
		}
		
		override public function dispose():void
		{
			removeIconEvents();
			super.dispose();
		}
		
		
	}
}