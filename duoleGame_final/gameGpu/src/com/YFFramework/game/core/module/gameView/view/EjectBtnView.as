package com.YFFramework.game.core.module.gameView.view
{
	import com.YFFramework.core.center.manager.ResizeManager;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.proxy.StageProxy;
	import com.YFFramework.core.ui.abs.AbsView;
	import com.YFFramework.core.utils.common.ClassInstance;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.core.module.im.model.PrivateTalkPlayerVo;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;

	/**
	 * 弹出按钮统一管理器
	 * @version 1.0.0
	 * creation time：2013-4-2 下午4:07:20
	 * 
	 */
	public class EjectBtnView extends AbsView{
		
		/**请求组队图标
		 */		
		public static const RequestTeam:String="RequestTeam";
		/**有人申请加入队伍*/
		public static const JoinTeamList:String="JoinTeamList";
		/**请求交易图标
		 */		
		public static const RequestTrade:String="RequestTrade";
		/**
		 */		
		public static const RequestCompete:String="RequestCompete";
		/**请求添加好友图标
		 */		
		public static const RequestFriend:String="RequestFriend";
		/**私聊图标
		 */		
		public static const PrivateChat:String="PrivateChat";
		/**公会邀请*/
		public static const RequestGuild:String="RequestGuild";
		/**技能加点*/
		public static const newSkill:String="newSkill";
		
		
		
		
		private var _mc:MovieClip;
		/**
		 *是否有对应的按钮，Boolean值 
		 */		
		private var _btnDict:Dictionary;
		private var _btnArray:Array;
		
		/**私聊 好友 图标
		 */		
		private var _friendIconBtn:Dictionary;
		public function EjectBtnView(mc:MovieClip){
			_mc = mc;
			super(false);
			_btnDict = new Dictionary();
			_friendIconBtn=new Dictionary();
			_btnArray = new Array();
			StageProxy.Instance.stage.addEventListener(Event.RESIZE,updatePos);
			updatePos(null);
		}
		
		private function updatePos(e:Event):void
		{
			var pw:int=_mc.parent.width;
			var sw:int=StageProxy.Instance.getWidth();
			if(sw>=pw+300)
				_mc.x=5;
			else
				_mc.x=(pw-sw)*0.5+sw*.25;
		}
		
		/**添加弹出按钮 
		 * @param type	按钮类型  RequestTeam  RequestTrade RequestCompete  RequestFriend  
		 */		
		public function addBtn(type:String,privateTalkRequestVo:PrivateTalkPlayerVo=null):void{
			var btn:Sprite;
			
			switch(type){
				case RequestTeam:
					btn = ClassInstance.getInstance("teamBtn") as MovieClip;
					_btnDict[type] = true;
					btn.name = type;
					break;
				case JoinTeamList:
					btn = ClassInstance.getInstance("teamBtn") as MovieClip;
					_btnDict[type] = true;
					btn.name = type;
					break;
				case RequestTrade:
					btn = ClassInstance.getInstance("tradeBtn") as MovieClip;
					_btnDict[type] = true;
					btn.name = type;
					break;
				case RequestCompete: //切磋
					btn = ClassInstance.getInstance("competeBtn") as MovieClip;
					_btnDict[type] = true;
					btn.name = type;
					break;
				case RequestFriend: //  好友列表
					btn = ClassInstance.getInstance("friendBtn") as MovieClip;
					_btnDict[type] = true;
					btn.name = type;
					break;
				case PrivateChat: //好友 私聊
					if(_friendIconBtn[privateTalkRequestVo.dyId]) return ; //如果已经存在 则不做任何处理
					btn=new PrivateChatIcon(privateTalkRequestVo);
					_btnDict[type] = false;
					btn.name = privateTalkRequestVo.dyId.toString();  ///  name====dyId
					_friendIconBtn[privateTalkRequestVo.dyId]=true;// 存在
					break;
				case RequestGuild://公会
					btn = ClassInstance.getInstance("guildBtn");
					_btnDict[type] = true;
					btn.name = type;
					break;
				case newSkill://技能加点  newMainUI  右下角图标文件夹下
					btn = ClassInstance.getInstance("skillBtn");
					_btnDict[type] = true;
					btn.name = type;
					break;
				
			}
			_btnArray.push(btn);
			btn.addEventListener(MouseEvent.CLICK,onClick);
			
		}
		
		/**更新弹出按钮View 
		 */		
		public function updateBtnView():void{
			removeAllBtn();
			for(var i:int=0;i<_btnArray.length;i++){
				_btnArray[i].x = i*40;
				_mc.addChild(_btnArray[i]);
			}
		}
		
		/**移除全部弹出的按钮
		 */		
		public function removeAllBtn():void{
			while(_mc.numChildren!=0)	_mc.removeChildAt(0);
		}
		
		/**移除指定按钮 
		 * @param type	按钮类型
		 */		
		public function removeBtn(type:String,privateTalkRequestVo:PrivateTalkPlayerVo=null):void{
			var btn:Sprite;
			if(type==RequestTeam||type==RequestTrade||type==RequestCompete||type==RequestFriend||type==RequestGuild||type==newSkill
			||type==JoinTeamList)
			{
				if(hasBtn(type)){///  私聊图标的  type是 false的
					_btnDict[type]=false;
					for(var i:int=0;i<_btnArray.length;i++){
						if(_btnArray[i].name==type){
							btn=_btnArray[i];
							_btnArray.splice(i,1);
							btn.removeEventListener(MouseEvent.CLICK,onClick);
							return ;
						}
					}
				}
			}
			else if(type==PrivateChat) //私聊图标
			{
				for(i=0;i<_btnArray.length;i++)
				{
					if(_btnArray[i].name==privateTalkRequestVo.dyId.toString())
					{
						btn=_btnArray[i];
						_btnArray.splice(i,1);
						btn.removeEventListener(MouseEvent.CLICK,onClick);
						PrivateChatIcon(btn).dispose();
						_friendIconBtn[privateTalkRequestVo.dyId]=null;
						delete _friendIconBtn[privateTalkRequestVo.dyId];
						return;
					}
				}
			}
		}
		
		/**是否已经有该弹出按钮 
		 * @param type	按钮类型
		 * @return Boolean值
		 */		
		public function hasBtn(type:String):Boolean{
			if(_btnDict[type])	return true;
			return false;
		}
		
		private function onClick(e:MouseEvent):void{
			switch(e.currentTarget.name){
				case RequestTeam:
					YFEventCenter.Instance.dispatchEventWith(GlobalEvent.InviteUIClick);
					return;
				case JoinTeamList:
					YFEventCenter.Instance.dispatchEventWith(GlobalEvent.JoinTeamOpen);
					return;
				case RequestTrade:
					YFEventCenter.Instance.dispatchEventWith(GlobalEvent.TradeUIClick);
					return;
				case RequestCompete:
					YFEventCenter.Instance.dispatchEventWith(GlobalEvent.CompeteUIClick);
					return;
				case RequestFriend: //好友 
					YFEventCenter.Instance.dispatchEventWith(GlobalEvent.FriendBtnUIClick);
					removeBtn(RequestFriend); //移除按钮
					updateBtnView();
					return;
				case RequestGuild://公会邀请
					YFEventCenter.Instance.dispatchEventWith(GlobalEvent.GuildInviteClick);
					removeBtn(RequestGuild); //移除按钮
					updateBtnView();
					return;
				case newSkill://有新技能
					YFEventCenter.Instance.dispatchEventWith(GlobalEvent.SkillUIClick);
					removeBtn(newSkill); //移除按钮
					updateBtnView();
					return;
			}
			
			///处理  好友图标
			var privateChatIcon:PrivateChatIcon=e.currentTarget as PrivateChatIcon;
			YFEventCenter.Instance.dispatchEventWith(GlobalEvent.FriendPrivateChatIconClick,privateChatIcon.privateTalkRequestVo);
		}
	}
} 