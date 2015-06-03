package com.YFFramework.game.core.module.task.view
{
	import com.YFFramework.core.text.RichText;
	import com.YFFramework.game.core.global.manager.EquipBasicManager;
	import com.YFFramework.game.core.global.manager.PropsBasicManager;
	import com.YFFramework.game.core.global.view.tips.EquipTip;
	import com.YFFramework.game.core.global.view.tips.PropsTip;
	import com.YFFramework.game.core.global.view.tips.TipUtil;
	import com.YFFramework.game.core.module.systemReward.data.RewardIconType;
	import com.YFFramework.game.core.module.task.controller.TaskModule;
	import com.YFFramework.game.core.module.task.enum.RewardTypes;
	import com.YFFramework.game.core.module.task.manager.EquipIDManager;
	import com.YFFramework.game.core.module.task.manager.TaskBasicManager;
	import com.YFFramework.game.core.module.task.manager.Task_rewardBasicManager;
	import com.YFFramework.game.core.module.task.model.TaskBasicVo;
	import com.YFFramework.game.core.module.task.model.TaskDyVo;
	import com.YFFramework.game.core.module.task.model.Task_rewardBasicVo;
	import com.YFFramework.game.core.module.task.model.TypeTask;
	import com.YFFramework.game.gameConfig.URLTool;
	import com.dolo.lang.LangBasic;
	import com.dolo.ui.controls.Button;
	import com.dolo.ui.controls.DoubleDeckTree;
	import com.dolo.ui.controls.IconImage;
	import com.dolo.ui.data.ListItem;
	import com.dolo.ui.tools.Xdis;
	import com.dolo.ui.tools.Xtip;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	/**
	 * 任务窗口控制基类 
	 * @author flashk
	 * 
	 */
	public class TaskCOLBase
	{
		protected var _tree:DoubleDeckTree;
		protected var _ui:Sprite;
		protected var _infoTxt:TextField;
		protected var _rewardTxt:TextField;
		protected var _targetRichText:RichText;
		protected var _icons:Vector.<IconImage> = new Vector.<IconImage>();
		protected var _nowSelectVO:TaskBasicVo;
		protected var _cannelButton:Button;
		protected var _stateTxt:TextField;
		protected var _cannelButtonY:int;
		protected var _numTxts:Vector.<TextField> = new Vector.<TextField>();
		
		public function TaskCOLBase(target:Sprite)
		{
			_ui = target;
			_tree = Xdis.getChild(_ui,"all_tree");
			_tree.trunkDefaultOpen = true;
			_tree.addEventListener(Event.CHANGE,onTreeSelectChange);
			var item:ListItem;
			item = new ListItem();
			item.label = "主线任务";
			_tree.addTrunk(item);
			item = new ListItem();
			item.label = "支线任务";
			_tree.addTrunk(item);
			item = new ListItem();
			item.label = "循环任务";
			_tree.addTrunk(item);
			item = new ListItem();
			item.label = "跑环任务";
			_tree.addTrunk(item);

			_infoTxt = Xdis.getChild(_ui,"info_txt");
			_rewardTxt = Xdis.getChild(_ui,"reward_txt");
			_stateTxt = Xdis.getChild(_ui,"state_txt");
			_numTxts.push(Xdis.getChild(_ui,"num1_txt"));
			_numTxts.push(Xdis.getChild(_ui,"num2_txt"));
			_numTxts.push(Xdis.getChild(_ui,"num3_txt"));
			_numTxts.push(Xdis.getChild(_ui,"num4_txt"));
			_numTxts.push(Xdis.getChild(_ui,"num5_txt"));
			_numTxts.push(Xdis.getChild(_ui,"num6_txt"));
			_targetRichText = new RichText();
			var tmpTxt:TextField = Xdis.getChild(_ui,"target_txt");
			if(tmpTxt){
				_targetRichText.x = int(tmpTxt.x);
				_targetRichText.y = int(tmpTxt.y);
				_targetRichText.width = int(tmpTxt.width);
				tmpTxt.parent.removeChild(tmpTxt);
			}
			_ui.addChild(_targetRichText);
			for(var i:int=1;i<=6;i++){
				_icons.push(Xdis.getChild(_ui,"icon"+i+"_iconImage"));
				_icons[_icons.length-1].isClearUnVisible = true;
			}
			_cannelButton = Xdis.getChild(_ui,"operate_button");
			_cannelButton.visible = false;
			_cannelButtonY = _cannelButton.y;
			_cannelButton.addEventListener(MouseEvent.CLICK,onCannelBtnClick);
		}
		
		protected function onCannelBtnClick(event:MouseEvent):void
		{
			if(_nowSelectVO == null) return;
			TaskModule.getInstance().giveUpTask(_nowSelectVO.task_id,_nowSelectVO.loopID,_nowSelectVO.run_rings_id);
		}
		
		protected function clearNumTxts():void
		{
			var len:int = _numTxts.length;
			for(var i:int=0;i<len;i++){
				_numTxts[i].text = "";
			}
		}
		
		/**
		 * 清除整个树的所有子级和UI界面
		 * 
		 */
		protected function cleanTree():void
		{
			_tree.clearTrunkAllChilds(0);
			_tree.clearTrunkAllChilds(1);
			_tree.clearTrunkAllChilds(2);
			_tree.clearTrunkAllChilds(3);
			_infoTxt.text = "";
			_rewardTxt.text = "";
			_stateTxt.text = "";
			clearIcons();
			_cannelButton.y += 500;
			_cannelButton.visible = false;
			_targetRichText.setText("",exeFunc,flyExeFunc); 
			clearNumTxts();
		}
		
		protected function clearIcons():void
		{
			var len:int = _icons.length;
			for(var i:int=0;i<len;i++){
				_icons[i].clear();
				Xtip.clearLinkTip(_icons[i]);
			}
		}
		
		protected function setRichTextInfo():void
		{
			
		}
		
		protected function onTreeSelectChange(event:Event):void
		{
			var vo:TaskBasicVo = _tree.selectedItem.vo;
			_nowSelectVO = vo;
			_infoTxt.text = vo.description;
			setRichTextInfo();
			_rewardTxt.text = "";
			clearIcons();
			clearNumTxts();
			var index:int = 0;
			var vct:Vector.<Task_rewardBasicVo> = Task_rewardBasicManager.Instance.getTaskRewards(vo.task_reward_id);
			var len:int = vct.length;
			for(var i:int=0;i<len;i++){
				Xtip.clearLinkTip(_icons[index]);
				Xtip.clearTip(_icons[index]);
				switch(vct[i].rw_type)
				{
					case RewardTypes.EQUIP:
						var equipId:int = EquipIDManager.getCareerEquipID(vct[i].rw_id);
						if(index<_icons.length){
							_icons[index].url = EquipBasicManager.Instance.getURL(equipId);
							Xtip.registerLinkTip(_icons[index],EquipTip,TipUtil.equipTipInitFunc,0,equipId);
							_numTxts[index].text = "x"+vct[i].rw_num;
							index++;
						}
						break;
					case RewardTypes.PROPS:
						if(index<_icons.length){
							_icons[index].url = PropsBasicManager.Instance.getURL(vct[i].rw_id);
							Xtip.registerLinkTip(_icons[index],PropsTip,TipUtil.propsTipInitFunc,0,vct[i].rw_id);
							_numTxts[index].text = "x"+vct[i].rw_num;
							index++;
						}
						break;
					default:
						if(index<_icons.length){
							_icons[index].url=URLTool.getGoodsIcon(RewardIconType.getIconByReWardType(vct[i].rw_type));
							Xtip.registerTip(_icons[index],RewardTypes.getTypeStr(vct[i].rw_type));
							index++;
						}
						break;
				}
			}
		}
		
		protected function exeFunc(obj:Object):void
		{
			
		}
		
		protected function flyExeFunc(obj:Object):void
		{
			
		}
		
		protected function clearTreeTrunkNodes():void
		{
			_tree.clearTrunkAllChilds(0);
			_tree.clearTrunkAllChilds(1);
			_tree.clearTrunkAllChilds(2);
			_tree.clearTrunkAllChilds(3);
		}
		
		protected function addAll(vos:Vector.<TaskDyVo>):void
		{
			clearTreeTrunkNodes();
			var len:int = vos.length;
			var vo:TaskDyVo;
			var bVO:TaskBasicVo;
			var i:int;
			for(i=0;i<len;i++){
				vo = vos[i];
				bVO = TaskBasicManager.Instance.getTaskBasicVo(vo.taskID);
				bVO.loopID = vo.loopId;
				bVO.run_rings_id=vo.run_rings_id;
				addOneTask(bVO);
//				addOneTaskVO(vo);
			}
		}
		
		protected function addOneTaskVO(vo:TaskDyVo):void
		{
			
		}
		
		protected function addOneTask(bVO:TaskBasicVo):void
		{
			if(bVO){
				switch(bVO.task_type)
				{
					case TypeTask.TASK_TYPE_TRUNK:
						addTaskIn(0,bVO);
						break;
					case TypeTask.TASK_TYPE_BRANCH:
						addTaskIn(1,bVO);
						break;
					case TypeTask.TASK_TYPE_LOOP:
						addTaskIn(2,bVO);
						break;
					case TypeTask.TASK_TYPE_RUN:
						addTaskIn(3,bVO);
						break;
					default:
						break;
				}
			}
		}
		
		protected function addTaskIn(trunkIndex:int,bVO:TaskBasicVo):void
		{
			var item:ListItem = new ListItem();
			item.label = bVO.name;
			item.vo = bVO;
			_tree.addNote(item,trunkIndex);
		}
		
	}
}