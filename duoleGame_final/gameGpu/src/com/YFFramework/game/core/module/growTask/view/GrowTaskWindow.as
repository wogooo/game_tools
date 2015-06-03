package com.YFFramework.game.core.module.growTask.view
{
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.net.loader.image_swf.IconLoader;
	import com.YFFramework.core.net.loader.image_swf.UILoader;
	import com.YFFramework.game.core.global.manager.DyModuleUIManager;
	import com.YFFramework.game.core.global.manager.EquipBasicManager;
	import com.YFFramework.game.core.global.manager.PropsBasicManager;
	import com.YFFramework.game.core.global.model.ObjectAmount;
	import com.YFFramework.game.core.global.view.tips.EquipTip;
	import com.YFFramework.game.core.global.view.tips.PropsTip;
	import com.YFFramework.game.core.global.view.tips.TipUtil;
	import com.YFFramework.game.core.global.view.window.WindowTittleName;
	import com.YFFramework.game.core.module.bag.data.BagStoreManager;
	import com.YFFramework.game.core.module.growTask.event.GrowTaskEvent;
	import com.YFFramework.game.core.module.growTask.manager.GrowTaskDyManager;
	import com.YFFramework.game.core.module.growTask.model.GrowTaskDyVo;
	import com.YFFramework.game.core.module.growTask.source.GrowTaskSource;
	import com.YFFramework.game.core.module.newGuide.view.NewGuideAddPoint;
	import com.YFFramework.game.core.module.notice.manager.NoticeManager;
	import com.YFFramework.game.core.module.notice.model.NoticeType;
	import com.YFFramework.game.core.module.systemReward.data.RewardIconType;
	import com.YFFramework.game.core.module.task.enum.RewardTypes;
	import com.YFFramework.game.core.module.task.manager.Task_rewardBasicManager;
	import com.YFFramework.game.core.module.task.model.Task_rewardBasicVo;
	import com.YFFramework.game.gameConfig.URLTool;
	import com.dolo.ui.controls.Button;
	import com.dolo.ui.controls.IconImage;
	import com.dolo.ui.controls.List;
	import com.dolo.ui.controls.Window;
	import com.dolo.ui.data.ListItem;
	import com.dolo.ui.tools.AutoBuild;
	import com.dolo.ui.tools.Xdis;
	import com.dolo.ui.tools.Xtip;
	import com.msg.grow_task.CFinishGrowTask;
	import com.msg.grow_task.CGetGrowTaskReward;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	/**
	 * @version 1.0.0
	 * creation time：2013-7-16 下午4:43:56
	 */
	public class GrowTaskWindow extends Window{
		
		private var _growTaskWindow:MovieClip;
		private var _taskList:List;
		private var reward_button:Button;
		private var _desc:TextField;
		private var _icons:Vector.<IconImage> = new Vector.<IconImage>();
		private var _numTxt:Vector.<TextField> = new Vector.<TextField>();
		private var _taskPicSp:Sprite;
		private var taskId:int=0;
		
		public function GrowTaskWindow(){
			_growTaskWindow = initByArgument(572,443,"growTaskWindow",WindowTittleName.GrowTask,true,DyModuleUIManager.growTaskWinBg) as MovieClip;
			setContentXY(26,26);
			
			_taskList = Xdis.getChild(_growTaskWindow,"task_list");
			_taskList.itemRender = TaskItemRender;
			_taskList.addEventListener(Event.CHANGE,updateTaskDetail);
			
			reward_button = Xdis.getChildAndAddClickEvent(onReward,_growTaskWindow,"reward_button");
			reward_button.enabled=false;
			
			_desc = Xdis.getChild(_growTaskWindow,"reward_txt");
			_taskPicSp = Xdis.getChild(_growTaskWindow,"taskIcon");
			
			for(var i:int=1;i<=5;i++){
				_icons.push(Xdis.getChild(_growTaskWindow,"icon"+i+"_iconImage"));
				_icons[i-1].isClearUnVisible=true;
				_numTxt.push(Xdis.getChild(_growTaskWindow,"num"+i+"_txt"));					
			}
		}
		
		/**选中更新
		 * @param e
		 */		
		private function updateTaskDetail(e:Event):void{
			clearIcons();
			_desc.text = "";
			var index:int=0;
			taskId=(e.currentTarget as List).selectedItem.taskId;
			var vo:GrowTaskDyVo = GrowTaskDyManager.Instance.getGrowTaskVo(taskId);
			var vec:Vector.<Task_rewardBasicVo> = Task_rewardBasicManager.Instance.getTaskRewards(vo.rewardId);
			var len:int = vec.length;
			for(var i:int=0;i<len;i++){
				switch(vec[i].rw_type){
//					case ReWardTypes.EXP:
//						_desc.appendText("经验奖励："+vec[i].rw_num+"\n");
//						break;
//					case ReWardTypes.SILVER:
//						_desc.appendText("银币奖励："+vec[i].rw_num+"\n");
//						break;
//					case ReWardTypes.NOTE:
//						_desc.appendText("银锭奖励："+vec[i].rw_num+"\n");
//						break;
//					case ReWardTypes.COUPON:
//						_desc.appendText("礼券奖励："+vec[i].rw_num+"\n");
//						break;
					case RewardTypes.EQUIP:
						if(index<_icons.length){
							_icons[index].url = EquipBasicManager.Instance.getURL(vec[i].rw_id);
							Xtip.registerLinkTip(_icons[index],EquipTip,TipUtil.equipTipInitFunc,0,vec[i].rw_id);
							_numTxt[index].text = "X"+vec[i].rw_num;
							index++;
						}
						break;
					case RewardTypes.PROPS:
						if(index<_icons.length){
							_icons[index].url = PropsBasicManager.Instance.getURL(vec[i].rw_id);
							Xtip.registerLinkTip(_icons[index],PropsTip,TipUtil.propsTipInitFunc,0,vec[i].rw_id);
							_numTxt[index].text = "X"+vec[i].rw_num;
							index++;
						}
						break;
					default:
						if(index<_icons.length){
							_icons[index].url=URLTool.getGoodsIcon(RewardIconType.getIconByReWardType(vec[i].rw_type));
							Xtip.registerTip(_icons[index],RewardTypes.getTypeStr(vec[i].rw_type));
							index++;
						}
						break;
				}
			}
			
			if(_taskPicSp.numChildren>0)	_taskPicSp.removeChildAt(0);
			IconLoader.initLoader(URLTool.getGrowTaskIcon(vo.iconId),_taskPicSp);
			
			if(vo.status==GrowTaskSource.GROW_TASK_FINISHED)	reward_button.enabled=true;
			else	reward_button.enabled=false;
		}
		
		/**清除Icons
		 */		
		private function clearIcons():void{
			for(var i:int=0;i<5;i++){
				_icons[i].clear();
				Xtip.clearLinkTip(_icons[i]);
				Xtip.clearTip(_icons[i]);
				_numTxt[i].text = "";				
			}
		}
		
		/**更新任务列表
		 */		
		public function updateTasks(forceupdate:Boolean=false):void{
			if(this.isOpen || forceupdate==true){
				_taskList.removeAll();
			
				var item:ListItem;
				var arr:Array = GrowTaskDyManager.Instance.getTaskListArray();
				var len:int=arr.length;
				for(var i:int=0;i<len;i++){
					item = new ListItem();
					var vo:GrowTaskDyVo = arr[i];
					item.taskId = vo.taskId;
					item.desc = vo.taskDesc;
					item.status = vo.status;
					_taskList.addItem(item);
				}
				if(_taskList.renderContainer.numChildren>0)	_taskList.selectedIndex=0;
			}
		}
		
		/**领取按钮点击
		 * @param e
		 */
		private function onReward(e:MouseEvent):void{
			if(checkBagSpace())
			{
				var msg:CGetGrowTaskReward = new CGetGrowTaskReward();
				msg.taskId = taskId;
				YFEventCenter.Instance.dispatchEventWith(GrowTaskEvent.GrowTaskRewardReq,msg);
			}
			else
			{
				NoticeManager.setNotice(NoticeType.Notice_id_302);//背包已满
				NoticeManager.setNotice(NoticeType.Notice_id_1900);//领取失败
			}
		}
		
		private function checkBagSpace():Boolean
		{
			var vo:GrowTaskDyVo = GrowTaskDyManager.Instance.getGrowTaskVo(taskId);
			var vec:Vector.<Task_rewardBasicVo> = Task_rewardBasicManager.Instance.getTaskRewards(vo.rewardId);
			var i:int,len:int=vec.length;
			var eq:Vector.<ObjectAmount>=new Vector.<ObjectAmount>;
			var pp:Vector.<ObjectAmount>=new Vector.<ObjectAmount>;
			var o:ObjectAmount,item:Task_rewardBasicVo;
			for(i=0;i<len;i++)
			{
				o=new ObjectAmount;
				item=vec[i];
				o.amount=item.rw_num;
				o.id=item.rw_id;
				if(item.rw_type==RewardTypes.EQUIP)
					eq.push(o);
				else if(item.rw_type==RewardTypes.PROPS)
					pp.push(o);
			}
			return BagStoreManager.instantce.containsEnoughSpace(eq,pp);
		}
		
		public override function open():void
		{
			NewGuideAddPoint.closeByType(NewGuideAddPoint.GrowTask);
			super.open();
		}
	}
} 