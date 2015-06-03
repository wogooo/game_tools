package com.YFFramework.game.core.module.npc.view
{
	/**@author yefeng
	 * 2013 2013-4-28 下午2:14:50 
	 */
	import com.YFFramework.core.ui.container.VContainer;
	import com.YFFramework.game.core.module.guild.manager.GuildInfoManager;
	import com.YFFramework.game.core.module.npc.model.NPCFuncVo;
	import com.YFFramework.game.core.module.npc.model.NPCTaskWindowVo;
	import com.YFFramework.game.core.module.npc.model.Npc_PositionBasicVo;
	import com.YFFramework.game.core.module.npc.model.TypeNPCFunc;
	import com.YFFramework.game.core.module.raid.manager.RaidManager;
	import com.YFFramework.game.core.module.raid.model.RaidNumVo;
	import com.YFFramework.game.core.module.task.enum.TaskState;
	import com.YFFramework.game.core.module.task.manager.TaskDyManager;
	import com.YFFramework.game.core.module.task.model.TaskBasicVo;
	
	import flash.events.Event;
	import flash.events.MouseEvent;

	/** 打开npc弹出的第一级面板
	 */	
	public class NpcWindow extends NPCBaseWindow
	{

		/** 接受任务   进行接受人物对话  关闭当前窗口，打开完成任务对象窗口
		 */		
		private var _acceptTaskCall:Function;
		
		/**进行完成任务对话 关闭当前窗口 打开 完成任务对象窗口
		 */
		private var _finishTaskCall:Function;
		/**任务进行中
		 */		
		private var _progressTaskCall:Function;
		
		
		/**窗口 关闭的回调
		 */		
		public var windowCloseCall:Function;


		private var _vContainer:VContainer;
		
		/**是否处于 任务状态   如果为 true  则可能处于 完成任务  进行任务  或者可接任务的状态   ,false 则没有任何任务条件 
		 */		
		private var _isTaskState:Boolean;
		
		
		
		/**
		 * @param npcid
		 * @param taskId  任务不存在 则 taskId ==-1
		 */		
		public function NpcWindow(npcid:int,acceptTaskCall:Function,finishTaskCall:Function,progressCall:Function)
		{
			this._acceptTaskCall=acceptTaskCall;
			this._finishTaskCall=finishTaskCall;
			_progressTaskCall=progressCall;
			super(npcid)
			
//			YFEventCenter.Instance.addEventListener(GlobalEvent.taskListUpdate,onTaskListUpdate)			
		}
		override protected function initUI():void
		{
			super.initUI();
			initNewGuide();
		}
		/**初始化新手引导
		 */		
		private function initNewGuide():void
		{
			if(_isTaskState) //处于任务状态  显示箭头
			{
				showNewGuide();
			}
		}
		
		/**执行方法
		 */		
		override protected function exeFunc(obj:Object):void
		{
			/// do nothing 
		}
		
		/**初始化内容
		 */		
		override protected function initContent():void
		{
			_isTaskState=false;
			_button.label="关闭";
			_richText.setText(_npcBasicVo.defaultDialog,exeFunc);
			_vContainer=new VContainer();
			addChild(_vContainer);
			_vContainer.x=227;
			_vContainer.y=140;	
			//设置对白
			var item:NPCItemView;
			var taskBasicVo:TaskBasicVo;
			// 可以完成的任务列表
			var canfinishTaskArr:Vector.<TaskBasicVo>=TaskDyManager.getInstance().getFinishNPCTasks(_npcBasicVo.basic_id);
			if(canfinishTaskArr.length>0)
			{
				_button.label="完成任务";
				_isTaskState=true;
			}
			for each(taskBasicVo in canfinishTaskArr )
			{
				item=new NPCItemView(createNPCTaskWindowVo(positionVo,taskBasicVo,TaskState.FINISH),positionVo);
				item.setText(taskBasicVo.description);
				item.width=500;
				item.closeCallBack=_finishTaskCall;
				_vContainer.addChild(item);
			}
			////可接任务列表
			var canReceiveTask:Vector.<TaskBasicVo>=TaskDyManager.getInstance().getAcceptNPCTasks(_npcBasicVo.basic_id);
			if(canReceiveTask.length>0)
			{
				if(!_isTaskState)
				{
					_button.label="接受任务";
					_isTaskState=true;
				}
			}
			for each(taskBasicVo in canReceiveTask )
			{
				item=new NPCItemView(createNPCTaskWindowVo(positionVo,taskBasicVo,TaskState.ACCEPT),positionVo);
				item.setText(taskBasicVo.description);
				item.width=500;
				item.closeCallBack=_acceptTaskCall;
				_vContainer.addChild(item);
			}
			///正在进行中的任务列表
			var progressaskVec:Vector.<TaskBasicVo>=TaskDyManager.getInstance().getProgressNPCTasks(_npcBasicVo.basic_id);
			if(progressaskVec.length>0)
			{
				if(!_isTaskState)
				{
					_button.label="继续任务";
					_isTaskState=true;
				}
			}
			for each(taskBasicVo in progressaskVec )
			{
				item=new NPCItemView(createNPCTaskWindowVo(positionVo,taskBasicVo,TaskState.PROGRESS),positionVo);
				item.setText(taskBasicVo.description);
				item.width=500;
				item.closeCallBack=_progressTaskCall;
				_vContainer.addChild(item);
			}
			
			//副本是否可见
			var canVisible:Boolean=true; //是否可以显示 只有时间到了才可以显示副本
			var closeRaidVisible:Boolean=false;  //关闭副本是否可见
			var npcFuncVo:NPCFuncVo;//副本功能类型
			var funcStr:String; //功能描述
			var enterRaidTxt:String="进入副本-";
			var raidNumVo:RaidNumVo;
			var radidLeft:String; //副本剩余次数 说明
			//// npc 默认对话 
			if(_npcBasicVo.func_type1!=0)
			{
				canVisible=true;
				closeRaidVisible=false;
				npcFuncVo=createNPCFunc(_npcBasicVo.func_id1,_npcBasicVo.func_type1,positionVo.npc_id);
				funcStr=_npcBasicVo.func_desc1;
				if(npcFuncVo.funcType==TypeNPCFunc.Raid)  //副本类型
				{
					raidNumVo=RaidManager.Instance.isViewable2(npcFuncVo.funcId);
					if(raidNumVo)  //副本  可以显示
					{
						canVisible=true;
					}
					else canVisible=false;

//					canVisible=RaidManager.Instance.isViewable(npcFuncVo.funcId);
					closeRaidVisible=RaidManager.Instance.isCancelable(npcFuncVo.funcId);//关闭副本是否可见
					
					if(canVisible)
					{
						radidLeft="("+raidNumVo.raidNum+"/"+raidNumVo.raidLimit+")";
						funcStr=getColorText(enterRaidTxt,"#00FF00")+funcStr+getColorText(radidLeft,"#00FF00");
						_button.label="进入";
					}
				}
				if(canVisible)
				{
					if(npcFuncVo.funcType==TypeNPCFunc.Guid) //如果为工会类型
					{
						if(GuildInfoManager.Instence.hasGuild)  //有工会
						{
							npcFuncVo.guidType=TypeNPCFunc.Guid_Enter;  //创建工会
							item=new NPCItemView(npcFuncVo,positionVo);
							item.setText("{#00FF00|进入工会领地|3}");
							_vContainer.addChild(item);
							item.closeCallBack=npcFuncCall;
						}
						else //没有工会 
						{
							npcFuncVo.guidType=TypeNPCFunc.Guid_Create;  //创建工会
							item=new NPCItemView(npcFuncVo,positionVo);
							item.setText("{#00FF00|创建工会|3}");
							_vContainer.addChild(item);
							item.closeCallBack=npcFuncCall;
							
							npcFuncVo=createNPCFunc(_npcBasicVo.func_id1,_npcBasicVo.func_type1,positionVo.npc_id);
							npcFuncVo.guidType=TypeNPCFunc.Guid_Add;
							item=new NPCItemView(npcFuncVo,positionVo);  //加入工会
							item.setText("{#00FF00|加入工会|3}");
							_vContainer.addChild(item);
							item.closeCallBack=npcFuncCall;
						}
					}
					else  //不为 副本类型
					{
						npcFuncVo.closeRaid=false;
						item=new NPCItemView(npcFuncVo,positionVo);
						item.setText(funcStr);
						_vContainer.addChild(item);
						item.closeCallBack=npcFuncCall;
					}
				}
				if(closeRaidVisible) //显示关闭副本
				{
					npcFuncVo=createNPCFunc(_npcBasicVo.func_id1,_npcBasicVo.func_type1,positionVo.npc_id);
					npcFuncVo.closeRaid=true;
					item=new NPCItemView(npcFuncVo,positionVo);
					item.setText(getColorText("关闭:","#FFFF00")+_npcBasicVo.func_desc1);
					_vContainer.addChild(item);
					item.closeCallBack=npcFuncCall;
				}
			}
			if(_npcBasicVo.func_type2!=0)
			{
				canVisible=true;
				closeRaidVisible=false;
				funcStr=_npcBasicVo.func_desc2;
				npcFuncVo=createNPCFunc(_npcBasicVo.func_id2,_npcBasicVo.func_type2,positionVo.npc_id);
				if(npcFuncVo.funcType==TypeNPCFunc.Raid)  //副本类型
				{
//					canVisible=RaidManager.Instance.isViewable(npcFuncVo.funcId);
//					closeRaidVisible=RaidManager.Instance.isCancelable(npcFuncVo.funcId);//关闭副本是否可见
//					if(canVisible)funcStr=getColorText(enterRaidTxt,"#00FF00")+funcStr;
					
					raidNumVo=RaidManager.Instance.isViewable2(npcFuncVo.funcId);
					if(raidNumVo)  //副本  可以显示
					{
						canVisible=true;
					}
					else canVisible=false;
					//					canVisible=RaidManager.Instance.isViewable(npcFuncVo.funcId);
					closeRaidVisible=RaidManager.Instance.isCancelable(npcFuncVo.funcId);//关闭副本是否可见
					
					if(canVisible)
					{
						radidLeft="("+raidNumVo.raidNum+"/"+raidNumVo.raidLimit+")";
						funcStr=getColorText(enterRaidTxt,"#00FF00")+funcStr+getColorText(radidLeft,"#00FF00");
					}
				}
				if(canVisible)
				{
					if(npcFuncVo.funcType==TypeNPCFunc.Guid) //如果为副本类型
					{
						if(GuildInfoManager.Instence.hasGuild)  //有工会
						{
							npcFuncVo.guidType=TypeNPCFunc.Guid_Enter;  //创建工会
							item=new NPCItemView(npcFuncVo,positionVo);
							item.setText("{#00FF00|进入工会领地|3}");
							_vContainer.addChild(item);
							item.closeCallBack=npcFuncCall;
						}
						else //没有工会 
						{
							npcFuncVo.guidType=TypeNPCFunc.Guid_Create;  //创建工会
							item=new NPCItemView(npcFuncVo,positionVo);
							item.setText("{#00FF00|创建工会|3}");
							_vContainer.addChild(item);
							item.closeCallBack=npcFuncCall;
							
							npcFuncVo=createNPCFunc(_npcBasicVo.func_id2,_npcBasicVo.func_type2,positionVo.npc_id);
							npcFuncVo.guidType=TypeNPCFunc.Guid_Add;
							item=new NPCItemView(npcFuncVo,positionVo);  //加入工会
							item.setText("{#00FF00|加入工会|3}");
							_vContainer.addChild(item);
							item.closeCallBack=npcFuncCall;
						}
					}
					else 
					{
						npcFuncVo.closeRaid=false;
						item=new NPCItemView(npcFuncVo,positionVo);
						item.setText(funcStr);
						_vContainer.addChild(item);
						item.closeCallBack=npcFuncCall;
					}
				}
				if(closeRaidVisible) //显示关闭副本
				{
					npcFuncVo=createNPCFunc(_npcBasicVo.func_id2,_npcBasicVo.func_type2,positionVo.npc_id);
					npcFuncVo.closeRaid=true;
					item=new NPCItemView(npcFuncVo,positionVo);
					item.setText(getColorText("关闭:","#FFFF00")+_npcBasicVo.func_desc2);
					_vContainer.addChild(item);
					item.closeCallBack=npcFuncCall;
				}
			}
			if(_npcBasicVo.func_type3!=0)
			{
				canVisible=true;
				closeRaidVisible=false;
				funcStr=_npcBasicVo.func_desc3;
				npcFuncVo=createNPCFunc(_npcBasicVo.func_id3,_npcBasicVo.func_type3,positionVo.npc_id);
				if(npcFuncVo.funcType==TypeNPCFunc.Raid)  //副本类型
				{
//					canVisible=RaidManager.Instance.isViewable(npcFuncVo.funcId);
//					closeRaidVisible=RaidManager.Instance.isCancelable(npcFuncVo.funcId);//关闭副本是否可见
//					if(canVisible)funcStr=getColorText(enterRaidTxt,"#00FF00")+funcStr;
					
					raidNumVo=RaidManager.Instance.isViewable2(npcFuncVo.funcId);
					if(raidNumVo)  //副本  可以显示
					{
						canVisible=true;
					}
					else canVisible=false;
					//					canVisible=RaidManager.Instance.isViewable(npcFuncVo.funcId);
					closeRaidVisible=RaidManager.Instance.isCancelable(npcFuncVo.funcId);//关闭副本是否可见
					
					if(canVisible)
					{
						radidLeft="("+raidNumVo.raidNum+"/"+raidNumVo.raidLimit+")";
						funcStr=getColorText(enterRaidTxt,"#00FF00")+funcStr+getColorText(radidLeft,"#00FF00");
					}

				}
				if(canVisible)
				{
					
					if(npcFuncVo.funcType==TypeNPCFunc.Guid) //如果为副本类型
					{
						if(GuildInfoManager.Instence.hasGuild)  //有工会
						{
							npcFuncVo.guidType=TypeNPCFunc.Guid_Enter;  //创建工会
							item=new NPCItemView(npcFuncVo,positionVo);
							item.setText("{#00FF00|进入工会领地|3}");
							_vContainer.addChild(item);
							item.closeCallBack=npcFuncCall;
						}
						else //没有工会 
						{
							npcFuncVo.guidType=TypeNPCFunc.Guid_Create;  //创建工会
							item=new NPCItemView(npcFuncVo,positionVo);
							item.setText("{#00FF00|创建工会|3}");
							_vContainer.addChild(item);
							item.closeCallBack=npcFuncCall;
							npcFuncVo=createNPCFunc(_npcBasicVo.func_id3,_npcBasicVo.func_type3,positionVo.npc_id);
							npcFuncVo.guidType=TypeNPCFunc.Guid_Add;
							item=new NPCItemView(npcFuncVo,positionVo);  //加入工会
							item.setText("{#00FF00|加入工会|3}");
							_vContainer.addChild(item);
							item.closeCallBack=npcFuncCall;
						}
					}
					else 
					{
						npcFuncVo.closeRaid=false;
						item=new NPCItemView(npcFuncVo,positionVo);
						item.setText(funcStr);
						_vContainer.addChild(item);
						item.closeCallBack=npcFuncCall;
					}
				}
				if(closeRaidVisible) //显示关闭副本
				{
					npcFuncVo=createNPCFunc(_npcBasicVo.func_id3,_npcBasicVo.func_type3,positionVo.npc_id);
					npcFuncVo.closeRaid=true;
					item=new NPCItemView(npcFuncVo,positionVo);
					item.setText(getColorText("关闭:","#FFFF00")+_npcBasicVo.func_desc3);
					_vContainer.addChild(item);
					item.closeCallBack=npcFuncCall;
				}
			}
			_vContainer.updateView();
		}
		/**获取 带颜色的文本
		 */		
		private function getColorText(txt:String,color:String):String
		{
			return "{"+color+"|"+txt+"}";
		}
		
		private function createNPCFunc(funcId:int,functype:int,npcDyId:int):NPCFuncVo
		{
			var npcFuncVo:NPCFuncVo=new NPCFuncVo();
			npcFuncVo.funcId=funcId;
			npcFuncVo.funcType=functype;
			npcFuncVo.npcDyId=npcDyId;
			return npcFuncVo;
		}
		/**npc数据
		 */		
		public static  function createNPCTaskWindowVo(positionVo:Npc_PositionBasicVo,taskBasicVo:TaskBasicVo,state:int):NPCTaskWindowVo
		{
			var npcWindowVO:NPCTaskWindowVo=new NPCTaskWindowVo();
			npcWindowVO.npcDyId=positionVo.npc_id;
			npcWindowVO.npcBasicId=positionVo.basic_id;
			npcWindowVO.taskId=taskBasicVo.task_id;
			npcWindowVO.loopId=taskBasicVo.loopID;
			npcWindowVO.run_rings_id=taskBasicVo.run_rings_id;
			
			npcWindowVO.state=state;
			npcWindowVO.quality=taskBasicVo.quality;
			return npcWindowVO;
		}
		
		private function npcFuncCall(npcFuncVo:NPCFuncVo):void
		{
			close();
		}
		
		override protected function onButtonClick(e:MouseEvent=null):void
		{
			if(_vContainer.numChildren>0)	
			{
				var npcItemView:NPCItemView=_vContainer.getChildAt(0) as NPCItemView;
				if(!npcItemView.handleRaidItem())  //如果为副本先处理副本
				{
					npcItemView.triggerItem();
				}
			}
			else close();
			
		}
		 
		
		override public function close(event:Event=null):void
		{
			super.close(event);
			windowCloseCall(positionVo.npc_id);
		}
		
		override public function dispose():void
		{
			super.dispose();
			_vContainer=null;
			_acceptTaskCall=null;
			_finishTaskCall=null;
		}
		/**  是否处于任务状态
		 */		
		override public function getNewGuideVo():*
		{
			return _isTaskState;
		}
		
	}
	
}