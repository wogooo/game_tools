package com.YFFramework.game.core.module.task.view
{
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.core.global.model.FlyBootVo;
	import com.YFFramework.game.core.global.model.TaskWillDoVo;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.module.npc.manager.Npc_PositionBasicManager;
	import com.YFFramework.game.core.module.npc.model.Npc_PositionBasicVo;
	import com.YFFramework.game.core.module.task.manager.TaskBasicManager;
	import com.YFFramework.game.core.module.task.manager.Task_targetBasicManager;
	import com.YFFramework.game.core.module.task.model.TaskBasicVo;
	import com.YFFramework.game.core.module.task.model.TaskDyVo;
	import com.YFFramework.game.core.module.task.model.TaskTagDyVo;
	import com.YFFramework.game.core.module.task.model.Task_targetBasicVo;

	/**单个任务的操作/显示控制 
	 * @author flashk
	 */
	public class TaskViewAndOperate{
		
		private static var _ins:TaskViewAndOperate;
		
		public function TaskViewAndOperate(){
		}
		
		public static function getInstance():TaskViewAndOperate{
			return _ins ||= new TaskViewAndOperate();
		}
		/**   点击下滑文本 响应的方法
		 */		
		public function ableTextUserClick(obj:Object):void{
			if(int(obj.type) == TypeProps.TaskGoodsType_NPC){
				var vo:TaskWillDoVo = new TaskWillDoVo();
				vo.npcDyId = obj.id;
				YFEventCenter.Instance.dispatchEventWith(GlobalEvent.TaskMoveToNPC,vo);
			}
		}

		
		/**添加任务目标 
		 * @param view
		 * @param vo
		 * 返回新手引导数据
		 */		
		public function viewOneNowTask(view:RichTextSprite,vo:TaskDyVo):Object{
			var newGuideObj:Object;//新手 引导数据
			var tempObj:Object; //新手引导数据
			var taskBasicVo:TaskBasicVo;
			if(vo.isFinish == false){
//				var taskTagetBasicVo:TaskBasicVo=TaskBasicManager.Instance.getTaskBasicVo(vo.taskID);
				taskBasicVo=TaskBasicManager.Instance.getTaskBasicVo(vo.taskID);

				var taskTagetBasicVo:Task_targetBasicVo;
				var showStr:String = "";
				var showColor:String;
				var desc:String="";
				var len:int=vo.tagList.length;
				var taskTagDyVo:TaskTagDyVo;
				for(var i:int=0;i<len;i++){
					taskTagDyVo=vo.tagList[i];
					taskTagetBasicVo=Task_targetBasicManager.Instance.getTask_targetBasicVo(taskBasicVo.task_tag_id,taskTagDyVo.tagType,taskTagDyVo.tagID);  //目标任务表
					var a:int = taskTagDyVo.curNum;
					var b:int = taskTagDyVo.totalNum;
					//对为对话类型时  已经 其他的不需要显示个数的
					if(taskTagetBasicVo.tag_type==TypeProps.TaskTargetType_NPCDialog||taskTagetBasicVo.tag_type==TypeProps.TaskTargetType_NPCSimpleDialog
						||taskTagetBasicVo.tag_type==TypeProps.TaskTargetType_Equip_Enhance||taskTagetBasicVo.tag_type==TypeProps.TaskTargetType_Inlay
						||taskTagetBasicVo.tag_type==TypeProps.TaskTargetType_Div||taskTagetBasicVo.tag_type==TypeProps.TaskTargetType_Wing
					)
					{
						//b=1;
						showStr = "";
					}else{
						if(a>b) a=b;
						showStr = "("+a+"/"+b+")";
					}
					
					if(taskTagDyVo.curNum >= taskTagDyVo.totalNum)	showColor = "#00FF00";
					else	showColor = "#FFFF00";
//					taskBasicVo=TaskBasicManager.Instance.getTaskBasicVo(vo.taskID);
//					var targetVO:Task_targetBasicVo = Task_targetBasicManager.Instance.getTask_targetBasicVo(taskBasicVo.task_tag_id,vo.tagList[i].tagType,vo.tagList[i].tagID);
					desc=taskTagetBasicVo.desc;
					tempObj=addText(view,desc+"{"+showColor+"| "+showStr+"}",taskTagetBasicVo,true);
					if(newGuideObj==null)newGuideObj=tempObj;
				}
			}else{
				var tbvo:TaskBasicVo = TaskBasicManager.Instance.getTaskBasicVo(vo.taskID);
				newGuideObj=addText(view,tbvo.submit_desc,null,true);
			}
			return newGuideObj;
		}
		
		/**添加新行
		 * @param target
		 * @param textStr
		 * @param data
		 * @param isSpace
		 */		
		private function addText(target:RichTextSprite,textStr:String,data:Object,isSpace:Boolean=false):Object{
//			if(isSpace)	textStr = " "+textStr;
			return target.addNewLine(textStr,exeFunc,flyExeFunc,data,isSpace); 
		}
		
		/**自动寻路
		 * @param obj 
		 */		
		private function exeFunc(obj:Object):void{
			if(int(obj.type) == TypeProps.TaskGoodsType_NPC){
				var vo:TaskWillDoVo = new TaskWillDoVo();
				var targetVO:Task_targetBasicVo = obj.data as Task_targetBasicVo;
				vo.npcDyId = obj.id;
				if(targetVO){
					vo.seach_id = targetVO.seach_id;
					vo.seach_type = targetVO.seach_type;
				}
				YFEventCenter.Instance.dispatchEventWith(GlobalEvent.TaskMoveToNPC,vo);
			}
		}
		
		/**小飞鞋
		 * @param obj
		 */		
//		private function flyExeFunc(obj:Object):void{
//			var npcPositionId:int=obj.id;
//			var npcPositioVo:Npc_PositionBasicVo=Npc_PositionBasicManager.Instance.getNpc_PositionBasicVo(npcPositionId);
//			var flyBootVo:FlyBootVo=new FlyBootVo();
//			flyBootVo.mapX=npcPositioVo.pos_x;
//			flyBootVo.mapY=npcPositioVo.pos_y;
//			flyBootVo.mapId=npcPositioVo.scene_id;
//			flyBootVo.playerId=npcPositionId;
//			if(npcPositioVo.basic_id>0)  //为 npc
//			{
//				YFEventCenter.Instance.dispatchEventWith(GlobalEvent.SKipToPlayer,flyBootVo);//  向 目标玩家靠近
//			}
//			else // 为坐标点 
//			{
//				YFEventCenter.Instance.dispatchEventWith(GlobalEvent.SKipToPoint,flyBootVo);//  向目标靠近
//			}
//		}
		
		/**点击小飞鞋响应的方法
		 */		
		public function flyExeFunc(obj:Object):void
		{
			var npcPositionId:int=obj.id;
			var npcPositioVo:Npc_PositionBasicVo=Npc_PositionBasicManager.Instance.getNpc_PositionBasicVo(npcPositionId);
			var flyBootVo:FlyBootVo=new FlyBootVo();
			flyBootVo.mapX=npcPositioVo.pos_x;
			flyBootVo.mapY=npcPositioVo.pos_y;
			flyBootVo.mapId=npcPositioVo.scene_id;
//			flyBootVo.seach_id=npcPositionId;
//			flyBootVo.seach_id=taskTagetBasicVo.seach_id;
//			flyBootVo.seach_type=taskTagetBasicVo.seach_type;
			if(npcPositioVo.basic_id>0)  //为 npc
			{
				flyBootVo.seach_id=npcPositionId;  //搜索npc 
				YFEventCenter.Instance.dispatchEventWith(GlobalEvent.SKipToPlayer,flyBootVo);//  向 目标玩家靠近
			}
			else // 为坐标点 
			{
				var taskTagetBasicVo:Task_targetBasicVo = obj.data as Task_targetBasicVo;
				if(taskTagetBasicVo)
				{
					flyBootVo.seach_type=taskTagetBasicVo.seach_type;
					flyBootVo.seach_id=taskTagetBasicVo.seach_id; //跳转自动打怪
				}
				YFEventCenter.Instance.dispatchEventWith(GlobalEvent.SKipToPoint,flyBootVo);//  向目标靠近
			}
		}
	}
}