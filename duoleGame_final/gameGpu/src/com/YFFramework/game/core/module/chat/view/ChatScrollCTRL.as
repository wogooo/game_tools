package com.YFFramework.game.core.module.chat.view
{
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.game.core.global.DataCenter;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.core.global.model.EquipDyVo;
	import com.YFFramework.game.core.global.model.PropsDyVo;
	import com.YFFramework.game.core.global.util.NoticeUtil;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.global.view.tips.EquipTip;
	import com.YFFramework.game.core.global.view.tips.PropsTip;
	import com.YFFramework.game.core.module.ModuleManager;
	import com.YFFramework.game.core.module.chat.manager.ChatDataManager;
	import com.YFFramework.game.core.module.chat.model.ChatType;
	import com.YFFramework.game.core.module.guild.event.GuildInfoEvent;
	import com.YFFramework.game.core.module.guild.manager.GuildInfoManager;
	import com.YFFramework.game.core.module.guild.model.GuildConfig;
	import com.YFFramework.game.core.module.guild.model.GuildInvitePlayerVo;
	import com.YFFramework.game.core.module.im.event.IMEvent;
	import com.YFFramework.game.core.module.im.model.PrivateTalkPlayerVo;
	import com.YFFramework.game.core.module.im.model.RequestFriendVo;
	import com.YFFramework.game.core.module.mapScence.world.model.RoleDyVo;
	import com.YFFramework.game.core.module.market.source.MarketSource;
	import com.YFFramework.game.core.module.notice.manager.NoticeManager;
	import com.YFFramework.game.core.module.notice.model.NoticeType;
	import com.YFFramework.game.core.module.shop.view.BuyWindow;
	import com.YFFramework.game.core.module.team.events.TeamEvent;
	import com.YFFramework.game.core.module.team.manager.TeamDyManager;
	import com.YFFramework.game.core.module.team.model.ReqDyVo;
	import com.YFFramework.game.ui.layer.LayerManager;
	import com.dolo.ui.controls.Menu;
	import com.dolo.ui.controls.VScrollBar;
	import com.dolo.ui.tools.Xdis;
	import com.msg.team_pro.CJoinTeam;
	
	import flash.display.Sprite;
	import flash.system.System;

	/**聊天单个频道的滚动控制器 
	*/
	public class ChatScrollCTRL{
		/**3种不同大小的高度 
		 */
		public static var sizes:Array = [130,185,235];
		/**3种不同大小的Y坐标值 
		 */
		public static var posYs:Array = [0,-55,-105];
		
		/**UI界面Sprite 
		 */
		private var _ui:Sprite;
		/**滚动条 
		 */
		private var _scrollBar:VScrollBar;
		/**文本内容容器，包装器 
		 */
		private var _richTextSp:ChatRichTextSprite;
		/**频道文本要显示的宽度 
		 */
		private var _textWidth:int = 235;
		/**点击人名的弹出菜单 
		 */
		private var _menu:Menu;
		/**当前弹出菜单要使用的数据 
		 */
		private var _nowMenuDataObj:Object;
		
		public function ChatScrollCTRL(target:Sprite){
			_ui = target;
			_scrollBar = Xdis.getChild( _ui, "view_vScrollBar" );
			_scrollBar.miniScrollerHeight = 23;
			_richTextSp = new ChatRichTextSprite();
			_richTextSp.max = 50;
			_richTextSp.textWidth = _textWidth;
			_richTextSp.x = _scrollBar.x + _scrollBar.compoWidth+3;
			_ui.addChild( _richTextSp );
			_scrollBar.setTarget( _richTextSp, false, _textWidth + 10, _scrollBar.compoHeight ,0,0);
			_scrollBar.arrowClickMove = 21;
		}
		
		public function get scrollBar():VScrollBar{
			return _scrollBar;
		}

		/**是否隐藏滚动条 
		 * @param value
		 */
		public function setScrollBarVisible(value:Boolean):void{
			if(value == true)	_scrollBar.alpha = 1;
			else	_scrollBar.alpha = 0;
		}

		public function get ui():Sprite{
			return _ui;
		}

		/**添加一个新的聊天消息 
		 * @param msg
		 */
		public function addNewMsg(msg:String,dataDict:Object=null,yOffset:int=0):void{
			_richTextSp.addNewLine(msg,exeFunc,flyExeFunc,dataDict,false,yOffset);
			_scrollBar.updateSize(_richTextSp.viewHeight+5);
			_scrollBar.scrollToEnd();
		}
		
		/**更改大小 
		 * @param sizeMode
		 */
		public function changeSize(sizeMode:int):void{
			if(sizeMode<4){
				_scrollBar.setSize(_scrollBar.compoWidth,sizes[sizeMode-1]);
				_scrollBar.y = posYs[sizeMode-1];
				_richTextSp.y = posYs[sizeMode-1];
				_scrollBar.setTarget(_richTextSp,false,_textWidth+10,_scrollBar.compoHeight);
				_scrollBar.scrollToEnd();
			}
		}
		
		/**聊天中点击文本要触发的函数 
		 * @param obj
		 */
		private function exeFunc(obj:Object):void{
			_nowMenuDataObj = obj;
			var _data:*;
			if(_nowMenuDataObj.type!=ChatType.Chat_Type_Person){
				_data = ChatDataManager.castData(obj.type,(_nowMenuDataObj.data)[obj.type+"_"+obj.id].data);
			}
			if(_nowMenuDataObj.type==ChatType.Chat_Type_Person){
				_menu = new Menu();
				if(_nowMenuDataObj.id==DataCenter.Instance.roleSelfVo.roleDyVo.dyId){
					_menu.addItem("查看",onMenuPerson,"",_nowMenuDataObj);
				}else{
					_menu.addItem("观察",onMenuPerson,"",_nowMenuDataObj);
					_menu.addItem("组队",onMenuPerson,"",_nowMenuDataObj);
					_menu.addItem("私聊",onMenuPerson,"",_nowMenuDataObj);
					_menu.addItem("交易",onMenuPerson,"",_nowMenuDataObj);
					_menu.addItem("好友",onMenuPerson,"",_nowMenuDataObj);
					_menu.addItem("黑名单",onMenuPerson,"",_nowMenuDataObj);
					_menu.addItem("切磋",onMenuPerson,"",_nowMenuDataObj);
					_menu.addItem("复制姓名",onMenuPerson,"",_nowMenuDataObj);
					_menu.addItem("邀请入会",onMenuPerson,"",_nowMenuDataObj);
				}
				_menu.show();
			}else if(_nowMenuDataObj.type==ChatType.Chat_Type_Equip){
				var equipDyVo:EquipDyVo=_data;
				EquipTip.instance.setTip([0,0,false,false,equipDyVo,true]);
				LayerManager.UILayer.addChild(EquipTip.instance);
			}else if(_nowMenuDataObj.type == ChatType.Chat_Type_Props){
				var propsDyVo:PropsDyVo=_data;
				PropsTip.instance.setTip([0,0,propsDyVo,true]);
				LayerManager.UILayer.addChild(PropsTip.instance);
			}else if(_nowMenuDataObj.type == ChatType.Chat_Type_Market_Sell){
				BuyWindow.show();
				BuyWindow.instance.initMarket(MarketSource.CONSIGH,_data);			
			}else if(_nowMenuDataObj.type==ChatType.Chat_Type_Market_Buy){
				BuyWindow.show();
				BuyWindow.instance.initMarket(MarketSource.PURCHASE,_data);	
			}else if(_nowMenuDataObj.type== ChatType.Chat_Type_Team){
				if(ReqDyVo(_data).leaderId==DataCenter.Instance.roleSelfVo.roleDyVo.dyId){
					NoticeUtil.setOperatorNotice("无法加入自己!");
				}else if(TeamDyManager.Instance.getMembers().length>1){
					NoticeUtil.setOperatorNotice("你已在队伍中，不能再进入别的队伍");
				}else if(ReqDyVo(_data).careerReq!=TypeProps.TeamCareerReqAll && ReqDyVo(_data).careerReq!=DataCenter.Instance.roleSelfVo.roleDyVo.career){
					NoticeUtil.setOperatorNotice("职业不符合，无法加入!");
				}else if(ReqDyVo(_data).powerReq==TypeProps.TeamPowerReq30 && DataCenter.Instance.roleSelfVo.roleDyVo.level<30){
					NoticeUtil.setOperatorNotice("等级不符合，无法加入!");
				}else if(ReqDyVo(_data).powerReq==TypeProps.TeamPowerReq50 && DataCenter.Instance.roleSelfVo.roleDyVo.level<50){
					NoticeUtil.setOperatorNotice("等级不符合，无法加入!");
				}else{
					var msg:CJoinTeam = new CJoinTeam();
					msg.dyId = ReqDyVo(_data).leaderId;
					YFEventCenter.Instance.dispatchEventWith(TeamEvent.JoinReq,msg);
				}
			}else if(_nowMenuDataObj.type==ChatType.Chat_Type_Basic_Equip){
				EquipTip.instance.setTip([0,_data,false,false,null,true]);
				LayerManager.UILayer.addChild(EquipTip.instance);
			}else if(_nowMenuDataObj.type==ChatType.Chat_Type_Basic_Props){
				PropsTip.instance.setTip([0,_data,null,true]);
				LayerManager.UILayer.addChild(PropsTip.instance);
			}else if(_nowMenuDataObj.type==ChatType.Chat_Type_Guild){
				if(DataCenter.Instance.roleSelfVo.roleDyVo.level < GuildConfig.GuildMinEnterLv)
					NoticeUtil.setOperatorNotice("你等级不到"+GuildConfig.GuildMinEnterLv+"级，无法加入公会");
				else if(GuildInfoManager.Instence.hasGuild)
					NoticeManager.setNotice(NoticeType.Notice_id_1312);
				else
					YFEventCenter.Instance.dispatchEventWith(GuildInfoEvent.chatJoinGuildReq,_data);
			}else if(_nowMenuDataObj.type==ChatType.Chat_Type_GuildInfo){
				YFEventCenter.Instance.dispatchEventWith(GuildInfoEvent.LookupGuildInfo,_data);
			}else if(_nowMenuDataObj.type==ChatType.Chat_Type_Auto_Move){
				YFEventCenter.Instance.dispatchEventWith(GlobalEvent.SmallMapMoveToWorldPt,_data);
			}
			
		}
		
		/**菜单点击触发的函数
		 * @param index 菜单索引	0:观察；1：组队；2：私聊；3：交易；4：好友；5：黑名单；6.切磋；7：复制姓名；8：邀请入会
		 * @param label 菜单文本
		 */
		private function onMenuPerson(index:int,label:String,obj:Object=null):void{
			switch(index){
				case 0: //观察
					ModuleManager.rankModule.otherPlayerReq(obj.id);
					break;
				case 1: //组队
					var roleDyVo:RoleDyVo = new RoleDyVo();
					roleDyVo.dyId = obj.id;
					roleDyVo.roleName = obj.txt;
					YFEventCenter.Instance.dispatchEventWith(TeamEvent.InviteReq,roleDyVo);	
					break;
				case 2: //私聊
					var talkVo:PrivateTalkPlayerVo = new PrivateTalkPlayerVo();
					talkVo.dyId = obj.id;
					talkVo.name = obj.txt;
					talkVo.sex = obj.data.sex;
					talkVo.career=obj.data.career;
					YFEventCenter.Instance.dispatchEventWith(GlobalEvent.PrivateTalkToOpenWindow,talkVo);
					break;
				case 3: //交易
					YFEventCenter.Instance.dispatchEventWith(GlobalEvent.ToTrade,obj.id);
					break;
				case 4: //好友
					var reqFrdVo:RequestFriendVo = new RequestFriendVo();
					reqFrdVo.dyId = obj.id;
					reqFrdVo.name = obj.txt;
					YFEventCenter.Instance.dispatchEventWith(GlobalEvent.C_RequestAddFriend,reqFrdVo);
					break;
				case 5: //黑名单
					YFEventCenter.Instance.dispatchEventWith(IMEvent.C_AddToBlackList,obj.id);
					break;
				case 6: //切磋
					YFEventCenter.Instance.dispatchEventWith(GlobalEvent.C_RequestCompete,{dyId:obj.id,name:obj.txt});
					break;
				case 7: //复制姓名
					System.setClipboard(obj.txt);
					break;
				case 8: //邀请入会
					var player:GuildInvitePlayerVo=new GuildInvitePlayerVo;
					player.dyId=obj.id;
					player.lv=GuildConfig.GuildMinEnterLv;//这里没有玩家等级信息，先用一个可以允许值替代，
					YFEventCenter.Instance.dispatchEventWith(GuildInfoEvent.InvatePlayer,player);
					break;
			}
		}
		
		/**聊天中点击小图标要触发的函数 
		 * @param obj
		 */
		private function flyExeFunc(obj:Object):void{
		}
	}
}