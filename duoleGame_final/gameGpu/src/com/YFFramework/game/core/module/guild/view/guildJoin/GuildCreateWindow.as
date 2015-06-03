package com.YFFramework.game.core.module.guild.view.guildJoin
{
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.game.core.global.DataCenter;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.core.global.view.window.WindowTittleName;
	import com.YFFramework.game.core.module.chat.manager.ChatFilterManager;
	import com.YFFramework.game.core.module.guild.event.GuildInfoEvent;
	import com.YFFramework.game.core.module.guild.model.GuildConfig;
	import com.YFFramework.game.core.module.guild.model.GuildCreateVo;
	import com.YFFramework.game.core.module.guild.view.GuildTabWindow;
	import com.YFFramework.game.core.module.guild.view.InputText;
	import com.YFFramework.game.core.module.notice.manager.NoticeManager;
	import com.YFFramework.game.core.module.notice.model.NoticeType;
	import com.dolo.ui.controls.Button;
	import com.dolo.ui.controls.PopMiniWindow;
	import com.dolo.ui.tools.Xdis;
	import com.greensock.TweenLite;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	
	/***
	 *公会创建面板/公会改名
	 *@author ludingchang 时间：2013-7-16 上午10:56:03
	 */
	public class GuildCreateWindow extends PopMiniWindow
	{
		private static const uiName:String="Guild_create";
		private static const create_money:int=GuildConfig.GuildCreaeMoney;//创建公会需要的钱
		private static var _inst:GuildCreateWindow;
		
		private var _create:Button;
		private var _cancle:Button;
		private var _name:InputText;
		private var _diamond:TextField;
		private var _mc:Sprite;
		private var _compare_value:int=create_money;
		/**是否点击过名字文本*/
		private var _isSelected:Boolean;
		private var _hasInit:Boolean=false;

		public static function get Instence():GuildCreateWindow
		{
			if(!_inst)
				_inst=new GuildCreateWindow;
			return _inst;
		}
		
		public function GuildCreateWindow()
		{
			isOpenUseTween=false;//自己重写
		}
		
		private function init():void
		{
			if(!_hasInit)
			{
				_hasInit=true;
				
				_mc=initByArgument(260,190,uiName,WindowTittleName.GuildCreate);
				_create=Xdis.getChildAndAddClickEvent(onCreate,_mc,"create_button");
				_cancle=Xdis.getChildAndAddClickEvent(close,_mc,"cancle_button");
				var name_txt:TextField=Xdis.getChild(_mc,"name_txt");
				_name=new InputText(name_txt,"请输入公会名");
				_diamond=Xdis.getChild(_mc,"num_txt");
				YFEventCenter.Instance.addEventListener(GlobalEvent.MoneyChange,onMoneyChange);
				_closeButton.visible=false;//没有关闭按钮
				
				_name.setMaxChars(GuildConfig.GuildNameMaxChars);
				
				_diamond.text=create_money.toString();
				_compare_value=create_money;
				_create.label="创建";
			}
		}
		
		private function onMoneyChange(e:YFEvent):void
		{
			update();
		}		
		
		private function onCreate(e:MouseEvent):void
		{
			if(!_name.isSelected||_name.text=="")
			{
//				NoticeUtil.setOperatorNotice("请输入公会名");
				NoticeManager.setNotice(NoticeType.Notice_id_1328);
				return;
			}
			if(ChatFilterManager.containsFilterWords(_name.text))
			{
				NoticeManager.setNotice(NoticeType.Notice_id_1303);
				return;
			}
			
			var vo:GuildCreateVo=new GuildCreateVo;
			vo.name=_name.text;
			YFEventCenter.Instance.dispatchEventWith(GuildInfoEvent.CreateGuild,vo);
		}
		public override function open():void
		{
			init();
			super.open();
			update();
			resetPos();
		}
		public override function update():void
		{
			if(DataCenter.Instance.roleSelfVo.note>=_compare_value)
			{
				_diamond.textColor=0x00ff00;//银锭不足用红色，够了用绿色
				_create.enabled=true;
			}
			else
			{
				_diamond.textColor=0xff0000;
				_create.enabled=false;
			}
		}
		private function resetPos():void
		{
			var posX:int,posY:int;
			var rec:Rectangle;
			if(GuildTabWindow.Instence.isOpen)
			{
				rec=GuildTabWindow.Instence.getBounds(GuildTabWindow.Instence.parent);
				posX=rec.x-this.width;
				posY=rec.y+rec.width/2-this.height-30;
				TweenLite.to(this,.5,{x:posX,y:posY,alpha:1});
			}
			else if(GuildJoinWindow.Instence.isOpen)
			{
				rec=GuildJoinWindow.Instence.getBounds(GuildJoinWindow.Instence.parent);
				posX=rec.x-this.width;
				posY=rec.y+rec.width/2-this.height;
				TweenLite.to(this,.5,{x:posX,y:posY,alpha:1});
			}
		}
		private function resetTxt():void
		{
			_name.changeDefStr("请输入公会名");
		}
		
		override public function dispose():void
		{
			_create.removeEventListener(MouseEvent.CLICK,onCreate);
			_create=null;
			_cancle.removeEventListener(MouseEvent.CLICK,close);
			YFEventCenter.Instance.removeEventListener(GlobalEvent.MoneyChange,onMoneyChange);
			_cancle=null;
			_name=null;
			_diamond=null;
			_mc=null;
			
			super.dispose();
		}
	}
}