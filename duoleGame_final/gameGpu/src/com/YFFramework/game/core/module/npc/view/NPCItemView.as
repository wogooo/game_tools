package com.YFFramework.game.core.module.npc.view
{
	/**@author yefeng
	 * 2013 2013-5-2 上午10:33:41 
	 */
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.text.RichText;
	import com.YFFramework.core.ui.abs.AbsView;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.core.global.model.RaidNPCVo;
	import com.YFFramework.game.core.module.guild.event.GuildInfoEvent;
	import com.YFFramework.game.core.module.npc.events.NPCEvent;
	import com.YFFramework.game.core.module.npc.manager.NPCIocnQualityUtil;
	import com.YFFramework.game.core.module.npc.model.NPCFuncVo;
	import com.YFFramework.game.core.module.npc.model.NPCTaskWindowVo;
	import com.YFFramework.game.core.module.npc.model.Npc_PositionBasicVo;
	import com.YFFramework.game.core.module.npc.model.TypeNPCFunc;
	import com.YFFramework.game.core.module.task.enum.TaskState;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/** npc 信息数据单元
	 */	
	public class NPCItemView extends AbsView
	{
		/**内容
		 */		
		private var _richText:RichText;
		/** 数据{funcId:_npcBasicVo.func_id,funcType:_npcBasicVo.func_type,npcDyId:positionVo.npc_id};    	  NPC静态数据
		 */		
		public var data:Object;
		/**关闭 窗口 
		 */		
		public var closeCallBack:Function;
		/** 任务状态符号
		 */		
		private var _flagMC:MovieClip;
		/** 该 npc的信息
		 */		
		private var npcPositionVo:Npc_PositionBasicVo;
		/** 是否为关闭副本 类型    副本  会创建 两个类型的 item  一个 是 开启副本类型  一个是关闭副本 类型     true 表示关闭副本类型  false 表示 开启副本类型  
		 */		
//		private var _isCloseRaid:Boolean;
		/**
		 * @param closeRaid    是否为关闭副本 类型    副本  会创建 两个 item  一个 是 开启副本  一个是关闭副本   
		 */		
		public function NPCItemView(data:Object,npcPositionVo:Npc_PositionBasicVo)
		{
//			_isCloseRaid=closeRaid;
			this.data=data;
			this.npcPositionVo=npcPositionVo;
			super(false);
		}
		override protected function initUI():void
		{
			super.initUI();
			_richText=new RichText();
			addChild(_richText);
			_richText.width=200;
		}
		override protected function addEvents():void
		{
			super.addEvents();
			addEventListener(MouseEvent.CLICK,onClick);
		}
		override protected function removeEvents():void
		{
			super.removeEvents();
			removeEventListener(MouseEvent.CLICK,onClick);
		}

		public function setText(text:String,color:String="#00FF00"):void
		{
			var str:String=text;
			if(data is NPCTaskWindowVo)  //如果 为  任务item
			{
				_flagMC=NPCIocnQualityUtil.getTaskItemMC(NPCTaskWindowVo(data).state,NPCTaskWindowVo(data).quality); ///获取mc
				addChild(_flagMC);
				_richText.x=20;
				if(NPCTaskWindowVo(data).state==TaskState.ACCEPT)
				{
					str +="{#00FF00|[可接]}";
				}
				else if(NPCTaskWindowVo(data).state==TaskState.FINISH)//可完成
				{
					str +="{#00FF00|[可完成]}";
				}
				_richText.setText(str,clickFunc);
			}
			else 
			{
				_richText.setText(text,clickFunc);
				_richText.x=0;
			}
		} 
		
		override public function set width(value:Number):void
		{
			_richText.width=value;
			_richText.exactWidth();
		}
		/**单击文本打开事件
		 */		
		private function clickFunc(obj:Object):void
		{
			
		}
		
		/**是否为副本类型
		 */
		public function handleRaidItem():Boolean
		{
			if(data is NPCFuncVo)
			{
				var npcFuncVo:NPCFuncVo=data as NPCFuncVo;
				if(npcFuncVo.funcType==TypeNPCFunc.Raid)
				{
					onClick();
					return true
				}
			}
			return false;
		}
		private function onClick(e:MouseEvent=null):void
		{
//			if(data is TaskBasicVo)  //任务数据 
//			{
//				var taskBasicVo:TaskBasicVo=data as TaskBasicVo;
//			}
//			else 
			if(data is NPCFuncVo)
			{
				var npcFuncVo:NPCFuncVo=data as NPCFuncVo;
				switch(data.funcType)   //npc数据
				{
					//商店
					case TypeNPCFunc.Shop:   //打开商店
						YFEventCenter.Instance.dispatchEventWith(GlobalEvent.OpenShopById,data.funcId);
						break;
					break;
					case TypeNPCFunc.Transfer: ///传送到目标点
						YFEventCenter.Instance.dispatchEventWith(NPCEvent.TransferToPoint,data);// {funcId:_npcBasicVo.func_id,funcType:_npcBasicVo.func_type,npcDyId:positionVo.npc_id}; 
						break;
					case TypeNPCFunc.Raid: //副本类型
						var raidNPCVo:RaidNPCVo=new RaidNPCVo();
						raidNPCVo.npcId=npcPositionVo.npc_id;
						raidNPCVo.raidId=npcFuncVo.funcId;
						if(npcFuncVo.closeRaid)//关闭副本类型
						{
							YFEventCenter.Instance.dispatchEventWith(GlobalEvent.CloseRaid,raidNPCVo);/////进入副本 
						}
						else   //开启副本类型
						{
						//	YFEventCenter.Instance.dispatchEventWith(GlobalEvent.EnterRaid,raidNPCVo);/////进入副本 
							YFEventCenter.Instance.dispatchEventWith(GlobalEvent.GotoEnterRaid,raidNPCVo);/////准备进入副本  场景侦听 

						}
						break;
					case TypeNPCFunc.Guid: //工会
						switch(npcFuncVo.guidType)
						{
							case TypeNPCFunc.Guid_Add: //加入工会
								YFEventCenter.Instance.dispatchEventWith(GlobalEvent.GuildUIClick);
								break;
							case TypeNPCFunc.Guid_Create: //创建工会
								YFEventCenter.Instance.dispatchEventWith(GuildInfoEvent.ShowCreateWindow);
								break;
							case TypeNPCFunc.Guid_Enter://进入工会领地
								YFEventCenter.Instance.dispatchEventWith(GuildInfoEvent.GoBackGuild);
								break;
						}
					case TypeNPCFunc.Exchange: //兑换界面
						YFEventCenter.Instance.dispatchEventWith(GlobalEvent.ExchangeUIshow);  //打开兑换界面
						break;
				}

			}
			if(closeCallBack!=null) closeCallBack(data);
		}
		/**主动触发调用
		 */		
		public function triggerItem():void
		{
			closeCallBack(data);
		}
		override public function dispose(e:Event=null):void
		{
			super.dispose(e);
			_richText=null;
			data=null;
			closeCallBack=null;
			_flagMC=null;
		}
			
	}
}