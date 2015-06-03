package com.YFFramework.game.core.module.gift.view
{
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.game.core.global.model.ObjectAmount;
	import com.YFFramework.game.core.global.util.ActiveRewardIconTips;
	import com.YFFramework.game.core.global.util.IconMoveUtil;
	import com.YFFramework.game.core.module.activity.model.ActiveRewardBasicVo;
	import com.YFFramework.game.core.module.bag.data.BagStoreManager;
	import com.YFFramework.game.core.module.gift.event.GiftEvent;
	import com.YFFramework.game.core.module.gift.manager.GiftManager;
	import com.YFFramework.game.core.module.gift.model.SignPackageAskVo;
	import com.YFFramework.game.core.module.gift.model.SignPackageVo;
	import com.YFFramework.game.core.module.gift.model.TypeSignPackage;
	import com.YFFramework.game.core.module.notice.manager.NoticeManager;
	import com.YFFramework.game.core.module.notice.model.NoticeType;
	import com.YFFramework.game.core.module.systemReward.view.IconCtrl;
	import com.YFFramework.game.core.module.task.enum.RewardTypes;
	import com.dolo.ui.controls.Button;
	import com.dolo.ui.tools.Xdis;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	/***
	 *单个礼包
	 *@author ludingchang 时间：2013-7-12 下午12:04:02
	 */
	public class Package
	{
		/**最多8个图片*/
		private static const ImgNums:int=8;
		private var _get_btn:Button;
		private var _vo:SignPackageVo;
		private var _icon:Vector.<IconCtrl>;
		private var _hasGet_img:Sprite;
		public function Package()
		{
		}
		
		public function init(sp:Sprite):void
		{
			_icon=new Vector.<IconCtrl>(ImgNums);
			for(var i:int=0;i<ImgNums;i++)
			{
				_icon[i]=new IconCtrl(Xdis.getChild(sp,"item"+(i+1)));
			}
			_get_btn=Xdis.getChildAndAddClickEvent(clicked,sp,"get_button");
			_hasGet_img=Xdis.getSpriteChild(sp,"hasGetImg");
		}
		
		private function clicked(e:MouseEvent):void
		{
			//处理点击事件，发送对应的VO
			if(GiftManager.checkBagSpace(_vo.items))
			{
				var vo:SignPackageAskVo=new SignPackageAskVo;
				vo.package_id=_vo.id;
				YFEventCenter.Instance.dispatchEventWith(GiftEvent.PageAsk,vo);
			}
			else
			{
				NoticeManager.setNotice(NoticeType.Notice_id_302);//背包已满
				NoticeManager.setNotice(NoticeType.Notice_id_1900);//领取失败
			}
		}
		
		
		/**设置内容*/
		public function setContent(vo:SignPackageVo):void
		{
			//填充数据，图
			_vo=vo;
			checkBtnEnable(vo.state);
			var items:ActiveRewardBasicVo;
			var len:int=vo.items.length;
			for(var i:int=0;i<ImgNums;i++)
			{
				if(i<len)
				{
					items=vo.items[i];
					_icon[i].visible=true;
					ActiveRewardIconTips.registerTip(items,_icon[i].icon,null,_icon[i].num_txt);
				}
				else
				{
					_icon[i].visible=false;
					ActiveRewardIconTips.clearAllTips(_icon[i].icon);
				}
			}
		}
		
		private function checkBtnEnable(state:int):void
		{
			_get_btn.visible=(state==TypeSignPackage.State_CanGet);
			_hasGet_img.visible=(state==TypeSignPackage.State_HasGet);
		}
		
		public function dispose():void
		{
			_get_btn.removeMouseClickEventListener(clicked);
			_get_btn=null;
			_icon.length=0;
			_icon=null;
		}
		
		/**得到所以显示的图标的副本的数组*/
		private function getIconCopy():Array
		{
			var res:Array=new Array;
			for(var i:int=0;i<ImgNums;i++)
			{
				if(_icon[i].visible)
				{
					res.push(_icon[i].icon);
				}
			}
			return res;
		}
		/**执行缓动特效**/
		public function doMoveEff():void
		{
			var icons:Array=getIconCopy();
			IconMoveUtil.MoveIconToBag(icons);
		}
		
	}
}