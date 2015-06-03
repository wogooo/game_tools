package com.YFFramework.game.core.module.systemReward.view
{
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.game.core.global.manager.DyModuleUIManager;
	import com.YFFramework.game.core.global.manager.EquipBasicManager;
	import com.YFFramework.game.core.global.manager.PropsBasicManager;
	import com.YFFramework.game.core.global.view.tips.EquipTip;
	import com.YFFramework.game.core.global.view.tips.PropsTip;
	import com.YFFramework.game.core.global.view.tips.TipUtil;
	import com.YFFramework.game.core.global.view.window.WindowTittleName;
	import com.YFFramework.game.core.module.systemReward.data.RewardIconType;
	import com.YFFramework.game.core.module.systemReward.data.RewardItemVo;
	import com.YFFramework.game.core.module.systemReward.data.RewardVo;
	import com.YFFramework.game.core.module.systemReward.data.TypeRewardSource;
	import com.YFFramework.game.core.module.systemReward.event.SystemRewardEvent;
	import com.YFFramework.game.core.module.systemReward.manager.SystemRewardManager;
	import com.YFFramework.game.core.module.systemReward.view.render.SystemRewardListRender;
	import com.YFFramework.game.core.module.task.enum.RewardTypes;
	import com.YFFramework.game.gameConfig.URLTool;
	import com.dolo.ui.controls.Button;
	import com.dolo.ui.controls.IconImage;
	import com.dolo.ui.controls.List;
	import com.dolo.ui.controls.Window;
	import com.dolo.ui.tools.Xdis;
	import com.dolo.ui.tools.Xtip;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	/***
	 *系统奖励窗口
	 *@author ludingchang 时间：2013-9-4 上午10:34:49
	 */
	public class SystemRewardWindow extends Window
	{
		private static const UIName:String="SystemReward";

		private var _getBtn:Button;
		private var _oneKeyBtn:Button;
		private var _ui:Sprite;
		private var _list:List;
		private var _name_txt:TextField;
		private var _icons:Vector.<IconCtrl>;
		
		public function SystemRewardWindow()
		{
			_ui = initByArgument(580,420,UIName,WindowTittleName.titleSysReward,true,DyModuleUIManager.wingWinBg);
			setContentXY(30,26);
			_list=Xdis.getChild(_ui,"reward_list");
			_list.itemRender=SystemRewardListRender;
			_getBtn=Xdis.getChildAndAddClickEvent(onGetOneClick,_ui,"get_button");
			_oneKeyBtn=Xdis.getChildAndAddClickEvent(onOneKeyClick,_ui,"oneKey_button");
			_name_txt=Xdis.getTextChild(_ui,"name_txt");
			_icons=new Vector.<IconCtrl>(12);
			for(var i:int=0;i<12;i++)
			{
				_icons[i]=new IconCtrl(Xdis.getChild(_ui,"reward"+(i+1)));
				_icons[i].hideNum();
			}
		}
		
		private function onOneKeyClick(e:MouseEvent):void
		{
			// TODO 请求一键领取
			YFEventCenter.Instance.dispatchEventWith(SystemRewardEvent.GetAll);
		}
		
		private function onGetOneClick(e:MouseEvent):void
		{
			// TODO 请求领取该奖励礼包
			YFEventCenter.Instance.dispatchEventWith(SystemRewardEvent.GetOne);
		}
		/**整个界面跟新*/
		public override function update():void
		{
			if(!isOpen) return;
			_list.removeAll();
			var list_data:Array=SystemRewardManager.Instence.packages;
			var i:int,len:uint=list_data.length;
			for(i=0;i<len;i++)
			{
				_list.addItem(list_data[i]);
			}
			if(len>0)
				(_list.getItemRenderAt(len-1) as SystemRewardListRender).hideBGLine();
			_list.selectedIndex=0;
			updateInfo();
		}
		/**跟新右边奖励内容*/
		public function updateInfo():void
		{
			if(!isOpen) return;
			var curr:RewardVo=SystemRewardManager.Instence.current;
			var i:int,len:int=12;
			var items:Array
			if(curr)
			{
				_name_txt.text=curr.name/*+" "+TypeRewardSource.getRewardTypeName(curr.type)*/;
				items=curr.items;
				for(i=0;i<len;i++)
				{
					var item:RewardItemVo=items[i];
					var icon:IconImage=_icons[i].icon;
					Xtip.clearTip(icon);
					Xtip.clearLinkTip(icon);
					if(item)
					{
						var url:String;
						switch(item.type)
						{
							case RewardTypes.PROPS:
								url=PropsBasicManager.Instance.getURL(item.id);
								Xtip.registerLinkTip(icon,PropsTip,TipUtil.propsTipInitFunc,0,item.id);
								break;
							case RewardTypes.EQUIP:
								url=EquipBasicManager.Instance.getURL(item.id);
								Xtip.registerLinkTip(icon,EquipTip,TipUtil.equipTipInitFunc,0,item.id);
								break;
							default :
								url=URLTool.getGoodsIcon(RewardIconType.getIconByReWardType(item.type));
								Xtip.registerTip(icon,RewardTypes.getTypeStr(item.type));
								break;
						}
						icon.url=url;
						_icons[i].visible=true;
					}
					else
					{
						icon.url="";
						_icons[i].visible=false;
					}
				}
				_oneKeyBtn.enabled=true;
				_getBtn.enabled=true;
			}
			else
			{
				_name_txt.text="";
				for(i=0;i<len;i++)
				{
					_icons[i].url="";
					_icons[i].visible=false;
					Xtip.clearTip(_icons[i].icon);
					Xtip.clearLinkTip(_icons[i].icon);
				}
				_oneKeyBtn.enabled=false;
				_getBtn.enabled=false;
			}
		}
		override public function open():void
		{
			super.open();
			update();
		}
	}
}