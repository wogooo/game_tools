package com.YFFramework.game.core.module.guild.view.guildMain
{
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.game.core.global.manager.PropsBasicManager;
	import com.YFFramework.game.core.global.manager.PropsDyManager;
	import com.YFFramework.game.core.global.model.PropsBasicVo;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.global.view.tips.PropsTip;
	import com.YFFramework.game.core.global.view.tips.TipUtil;
	import com.YFFramework.game.core.global.view.window.WindowTittleName;
	import com.YFFramework.game.core.module.guild.event.GuildInfoEvent;
	import com.YFFramework.game.core.module.guild.model.GuildConfig;
	import com.YFFramework.game.core.module.guild.model.GuildContributionVo;
	import com.YFFramework.game.core.module.guild.view.GuildTabWindow;
	import com.YFFramework.game.gameConfig.URLTool;
	import com.dolo.ui.controls.Button;
	import com.dolo.ui.controls.IconImage;
	import com.dolo.ui.controls.NumericStepper;
	import com.dolo.ui.controls.PopMiniWindow;
	import com.dolo.ui.tools.Xdis;
	import com.dolo.ui.tools.Xtip;
	import com.greensock.TweenLite;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	
	/***
	 *公会捐献窗口
	 *@author ludingchang 时间：2013-7-19 下午1:57:19
	 */
	public class GuildContributionWindow extends PopMiniWindow
	{
		private static const uiName:String="Guild_contribution";
		
		private static var _inst:GuildContributionWindow;
		
		private var _num:NumericStepper;
		private var _money:TextField;
		private var _contribution:TextField;
		private var _okBtn:Button;
		private var _noBtn:Button;
		private var _hasInit:Boolean=false;
		private var _icon:IconImage;
		/**公会捐献道具*/
		private var _guildContributionItem:PropsBasicVo;
		
		public static function get Instence():GuildContributionWindow
		{
			if(!_inst)
				_inst=new GuildContributionWindow;
			return _inst;
		}
		
		public function GuildContributionWindow()
		{
			isOpenUseTween=false;//自己重写了
		}
		
		private function init():void
		{
			if(!_hasInit)
			{
				_hasInit=true;
				
				var mc:Sprite=initByArgument(260,210,uiName,WindowTittleName.GuildJX);
				
				_num=Xdis.getChild(mc,"num_numericStepper");
				_money=Xdis.getTextChild(mc,"money_txt");
				_contribution=Xdis.getTextChild(mc,"contribution_txt");
				_okBtn=Xdis.getChildAndAddClickEvent(onOkClick,mc,"ok_button");
				_noBtn=Xdis.getChildAndAddClickEvent(close,mc,"no_button");
				_icon=Xdis.getChild(mc,"icon_iconImage");
				_guildContributionItem=PropsBasicManager.Instance.getAllBasicVoByType(TypeProps.PROPS_TYPE_GUILD_CONTRIBUTION)[0];
				_icon.url=URLTool.getGoodsIcon(_guildContributionItem.icon_id);
				Xtip.registerLinkTip(_icon,PropsTip,TipUtil.propsTipInitFunc,0,_guildContributionItem.template_id);
				
				_num.addEventListener(Event.CHANGE,onNumChange);
				_num.minimum=0;
				_closeButton.visible=false;
				reset();
			}
		}
		
		private function reset():void
		{
			_num.value=0;
			onNumChange(null);
		}
		
		protected function onNumChange(event:Event):void
		{
			var v:int=_num.value;
			_money.text=(v * GuildConfig.EachItemGetMoney).toString();//1魔钻转换为1000资金
			_contribution.text=(v * GuildConfig.EachItemGetContribution).toString();
			var itemNum:int=PropsDyManager.instance.getPropsQuantity(_guildContributionItem.template_id);
			if(itemNum<v)
			{
				_num.textField.textColor=0xff0000;
				_okBtn.enabled=false;
			}
			else
			{
				_num.textField.textColor=0xffffff;
				_okBtn.enabled=true;
			}
		}
		
		override public function update():void
		{
			if(isOpen)
			{
				var itemNum:int=PropsDyManager.instance.getPropsQuantity(_guildContributionItem.template_id);
				_num.maximum=itemNum;
				_num.value=itemNum;
			}
		}
		
		private function onOkClick(e:MouseEvent):void
		{
			var vo:GuildContributionVo=new GuildContributionVo;
			vo.num=_num.value;
			vo.items=PropsDyManager.instance.getPropsPosArray(_guildContributionItem.template_id,vo.num);
			YFEventCenter.Instance.dispatchEventWith(GuildInfoEvent.Donate,vo);
		}
		
		override public function open():void
		{
			init();
			super.open();
			update();
			resetPos();
		}
		
		private function resetPos():void
		{
			var rec:Rectangle;
			var posX:int,posY:int;
			if(GuildTabWindow.Instence.isOpen)
			{
				rec=GuildTabWindow.Instence.getBounds(GuildTabWindow.Instence.parent);
				posX=rec.x-this.width;
				posY=rec.y+rec.height/2+30;
				TweenLite.to(this,.5,{x:posX,y:posY,alpha:1});
			}
		}
	}
}