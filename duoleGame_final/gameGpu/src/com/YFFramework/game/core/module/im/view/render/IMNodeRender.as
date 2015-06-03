package com.YFFramework.game.core.module.im.view.render
{
	/**@author yefeng
	 * 2013 2013-6-21 下午6:08:11 
	 */
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.utils.common.ClassInstance;
	import com.YFFramework.game.core.global.manager.CharacterPointBasicManager;
	import com.YFFramework.game.core.module.giftYellow.event.GiftYellowEvent;
	import com.YFFramework.game.core.module.im.model.IMDyVo;
	import com.YFFramework.game.core.module.im.model.TypeIM;
	import com.YFFramework.game.core.module.mapScence.world.model.type.TypeRole;
	import com.dolo.ui.managers.UI;
	import com.dolo.ui.renders.ListRenderBase;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	/** 好友面板 子节点 渲染器
	 */	
	public class IMNodeRender extends ListRenderBase
	{
		private var _imDyVo:IMDyVo;

		private var _eff:Sprite;
		private var _vip:Sprite;
		public function IMNodeRender()
		{
			super();
			renderHeight=53;
		}
		
		override protected function resetLinkage():void
		{
			_linkage = "uiSkin.IMTreeNodeRender";
		}
			
		override protected function updateView(item:Object):void
		{
			_imDyVo=item as IMDyVo;
			_txt.htmlText=_imDyVo.name;
			//设置图标
			var url:String=CharacterPointBasicManager.Instance.getFriendIconURL(_imDyVo.career,_imDyVo.sex);
			_icon.url=url;
			if(_imDyVo.online==TypeIM.Offline)  //在线状态
				_icon.filters=UI.disableFilter;
			else
				_icon.filters=[];
			
			var vipRes:String=TypeRole.getVipResName(_imDyVo.vipType,_imDyVo.vipLevel);
			_vip.removeChildren();
			if(vipRes!="")
			{
				var _vipBtn:MovieClip=ClassInstance.getInstance(vipRes);
				_vip.addChild(_vipBtn);
				_vip.x=_txt.x+_txt.textWidth+4;
			}
		}
		
		override protected function onLinkageComplete():void
		{
			_eff=_ui["eff"];
			_eff.visible=false;
			_vip=_ui["VIP"];
			_vip.addEventListener(MouseEvent.CLICK,onVipClick);
			_vip.buttonMode=true;
		}
		
		protected function onVipClick(event:MouseEvent):void
		{
			YFEventCenter.Instance.dispatchEventWith(GiftYellowEvent.UpdateIndex,1);
			event.stopPropagation();
		}
		
		override protected function showDefault():void
		{
			_eff.visible=false;
		}
		
		override protected function showOver():void
		{
			_eff.visible=true;
		}
		
		override protected function showDown():void
		{
			_eff.visible=true;
		}
		
		override protected function showSelectOn():void
		{
			_eff.visible=true;
		}

	}
}