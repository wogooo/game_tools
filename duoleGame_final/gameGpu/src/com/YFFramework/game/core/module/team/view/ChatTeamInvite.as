package com.YFFramework.game.core.module.team.view
{
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.game.core.global.DataCenter;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.module.chat.manager.ChatTextUtil;
	import com.YFFramework.game.core.module.chat.model.ChatData;
	import com.YFFramework.game.core.module.chat.model.ChatType;
	import com.YFFramework.game.core.module.team.manager.TeamDyManager;
	import com.YFFramework.game.core.module.team.model.ReqDyVo;
	import com.dolo.ui.controls.Button;
	import com.dolo.ui.controls.Menu;
	import com.dolo.ui.controls.PopMiniWindow;
	import com.dolo.ui.controls.Window;
	import com.dolo.ui.tools.AutoBuild;
	import com.dolo.ui.tools.Xdis;
	import com.msg.enumdef.Career;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.utils.Dictionary;

	/**
	 * @version 1.0.0
	 * creation time：2013-7-5 下午4:52:13
	 */
	public class ChatTeamInvite extends PopMiniWindow{
		
		private var _mc:MovieClip;
		private var send_button:Button;
		private var _inputTxt:TextField;
		private var _careerTxt:TextField;
		private var _powerTxt:TextField;
		private var career_button:Button;
		private var power_button:Button;
		private var _menu:Menu;
		private var reqDyVo:ReqDyVo;
		private static var _instance:ChatTeamInvite;
		
		public function ChatTeamInvite(){
			_mc = initByArgument(270,200,"ChatTeamInvite",null) as MovieClip;
			AutoBuild.replaceAll(_mc);
			send_button = Xdis.getChildAndAddClickEvent(onSend,_mc,"send_button");
			career_button = Xdis.getChildAndAddClickEvent(onCareer,_mc,"career_button");
			power_button = Xdis.getChildAndAddClickEvent(onPower,_mc,"power_button");
			_inputTxt = Xdis.getChild(_mc,"inputTxt");
			_careerTxt = Xdis.getChild(_mc,"careerTxt");
			_powerTxt = Xdis.getChild(_mc,"powerTxt");
			
			_inputTxt.text = "开组啦，快来一起打怪物!~";
			_careerTxt.text = "职业（全部）";
			_powerTxt.text = "战斗力（全部）";
			reqDyVo = new ReqDyVo();
			if(TeamDyManager.LeaderId==0)	reqDyVo.leaderId = DataCenter.Instance.roleSelfVo.roleDyVo.dyId;
			else	reqDyVo.leaderId = TeamDyManager.LeaderId;
			reqDyVo.careerReq = TypeProps.TeamCareerReqAll;
			reqDyVo.powerReq = TypeProps.TeamPowerReqAll;
		}
		
		public static function get Instance():ChatTeamInvite{
			return _instance ||= new ChatTeamInvite();
		}
		
		override protected function resetTitleBgLinkage():void{
			
		}
		
		private function onCareer(e:MouseEvent):void{
			_menu = new Menu();
			_menu.addItem("职业（全部）",onMenuCareer,"",TypeProps.TeamCareerReqAll);
			_menu.addItem("职业（战士）",onMenuCareer,"",Career.CAREER_WARRIOR);
			_menu.addItem("职业（刺客）",onMenuCareer,"",Career.CAREER_BRAVO);
			_menu.addItem("职业（法师）",onMenuCareer,"",Career.CAREER_MASTER);
			_menu.addItem("职业（医生）",onMenuCareer,"",Career.CAREER_PRIEST);
			_menu.addItem("职业（猎人）",onMenuCareer,"",Career.CAREER_HUNTER);
			_menu.show();
		}
		
		private function onMenuCareer(index:int,label:String,reqId:int=0):void{
			reqDyVo.careerReq = reqId;
			_careerTxt.text = label;
		}
		
		private function onPower(e:MouseEvent):void{
			_menu = new Menu();
			_menu.addItem("战斗力（全部）",onMenuPower,"",TypeProps.TeamPowerReqAll);
			_menu.addItem("30级以上",onMenuPower,"",TypeProps.TeamPowerReq30);
			_menu.addItem("50级以上",onMenuPower,"",TypeProps.TeamPowerReq50);
			_menu.show();
		}
		
		private function onMenuPower(index:int,label:String,reqId:int=0):void{
			reqDyVo.powerReq = reqId;
			_powerTxt.text = label;
		}
		
		private function onSend(e:MouseEvent):void{
			var chatData:ChatData = new ChatData();
			chatData.data = reqDyVo;
			chatData.displayName ="加入队伍";
			chatData.myId = reqDyVo.leaderId;
			chatData.myQuality = 2;
			chatData.myType = ChatType.Chat_Type_Team;
			var txt:String ="[招募"+_careerTxt.text+"，"+_powerTxt.text+"]"+ _inputTxt.text + "["+chatData.displayName+","+chatData.myType+","+chatData.myId+"]";
			var dict:Dictionary = new Dictionary();
			dict["【"+chatData.displayName+"】"+"_"+chatData.myType+"_"+chatData.myId] = chatData;
			var sendStr:String = ChatTextUtil.convertSendDataToString(txt,dict);
			YFEventCenter.Instance.dispatchEventWith(GlobalEvent.ChatAutoSend,sendStr);
			this.close();
		}
		
		override public function dispose():void{
			send_button.removeEventListener(MouseEvent.CLICK,onSend);
			career_button.removeEventListener(MouseEvent.CLICK,onCareer);
			power_button.removeEventListener(MouseEvent.CLICK,onPower);
			send_button=null;
			career_button=null;
			power_button=null;
			_inputTxt = null;
			_careerTxt = null;
			_powerTxt = null;
			reqDyVo = null;
			_menu = null;
			while(_mc.numChildren>0)	_mc.removeChildAt(0);
			_mc = null;
			super.dispose();
		}
		
		override public function close(event:Event=null):void{
			super.close();
			//this.dispose();
		}
	}
} 