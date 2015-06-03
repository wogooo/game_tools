package com.YFFramework.game.core.module.autoSetting.view
{
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.game.core.global.DataCenter;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.core.global.manager.DyModuleUIManager;
	import com.YFFramework.game.core.global.manager.MonsterBasicManager;
	import com.YFFramework.game.core.global.util.DragManager;
	import com.YFFramework.game.core.global.util.NoticeUtil;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.global.view.window.WindowTittleName;
	import com.YFFramework.game.core.module.autoSetting.event.AutoEvent;
	import com.YFFramework.game.core.module.autoSetting.manager.AutoManager;
	import com.YFFramework.game.core.module.autoSetting.manager.FlushPosManager;
	import com.YFFramework.game.core.module.autoSetting.manager.FlushUnitManager;
	import com.YFFramework.game.core.module.autoSetting.model.FlushUnitVo;
	import com.YFFramework.game.core.module.autoSetting.source.AutoSource;
	import com.YFFramework.game.core.module.mapScence.world.model.type.TypeRole;
	import com.YFFramework.game.core.module.raid.manager.RaidManager;
	import com.YFFramework.game.core.module.skill.mamanger.QuickBoxManager;
	import com.YFFramework.game.core.module.skill.model.SkillModuleType;
	import com.YFFramework.game.core.module.task.manager.TaskBasicManager;
	import com.YFFramework.game.core.module.task.manager.TaskDyManager;
	import com.YFFramework.game.core.module.task.model.TaskBasicVo;
	import com.YFFramework.game.core.module.task.model.TaskDyVo;
	import com.YFFramework.game.core.module.task.model.TaskTagDyVo;
	import com.dolo.ui.controls.Button;
	import com.dolo.ui.controls.CheckBox;
	import com.dolo.ui.controls.TileList;
	import com.dolo.ui.controls.Window;
	import com.dolo.ui.data.ListItem;
	import com.dolo.ui.tools.AutoBuild;
	import com.dolo.ui.tools.Xdis;
	import com.msg.sys.CAutoConfigSave;
	import com.msg.sys.ConfigBool;
	import com.msg.sys.ConfigInt;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;

	/**
	 * @version 1.0.0
	 * creation time：2013-7-17 下午4:52:29
	 */
	public class AutoWindow extends Window{
		
		private var _autoWindow:MovieClip;
		
		private var _targetList:TileList;
		private var no_button:Button;
		private var all_button:Button;
		private var monster_button:Button;
		private var _monsterInited:Boolean=false;
		
		private var _equipCheckBox:CheckBox;
		private var _equipQualityCB:Vector.<CheckBox>=new Vector.<CheckBox>();
		private var _propsCheckBox:CheckBox;
		private var _propsQualityCB:Vector.<CheckBox>=new Vector.<CheckBox>();
		
		private var default_button:Button;
		private var save_button:Button;
		private var clear_button:Button;
		private var fight_button:Button;
		
		private var _skillPane:Sprite;
		private var _skillGrids:Vector.<SkillGrid> = new Vector.<SkillGrid>();
		
		public function AutoWindow(){
			_autoWindow = initByArgument(572,445,"AutoWindow",WindowTittleName.Auto,true,DyModuleUIManager.autoSettingWinBg) as MovieClip;
			setContentXY(26,26);
			AutoBuild.replaceAll(_autoWindow);
			
			_targetList = Xdis.getChild(_autoWindow,"target_tileList");
			_targetList.itemRender = MonsterRender;
			
			all_button = Xdis.getChildAndAddClickEvent(onAll,_autoWindow,"all_button");
			no_button = Xdis.getChildAndAddClickEvent(onNo,_autoWindow,"no_button");
			
			_equipCheckBox = Xdis.getChild(_autoWindow,"equip_checkBox");
			_equipCheckBox.textField.width = 70;
			for(var i:int=0;i<6;i++){
				_equipQualityCB.push(Xdis.getChild(_autoWindow,"equip"+i+"_checkBox"));
			}
			_propsCheckBox = Xdis.getChild(_autoWindow,"props_checkBox");
			_propsCheckBox.textField.width = 70;
			for(i=0;i<5;i++){
				_propsQualityCB.push(Xdis.getChild(_autoWindow,"props"+i+"_checkBox"));
			}
			var skillGrid:SkillGrid;
			for(i=0;i<10;i++){
				skillGrid = new SkillGrid(48*i,0,i);
				_skillGrids.push(skillGrid);
				_autoWindow.skillMc.addChild(skillGrid.sp);
			}
			
			default_button = Xdis.getChildAndAddClickEvent(onDefault,_autoWindow,"default_button");
			save_button = Xdis.getChildAndAddClickEvent(onSave,_autoWindow,"save_button");
			clear_button = Xdis.getChildAndAddClickEvent(clearSkills,_autoWindow,"clear_button");
			fight_button = Xdis.getChildAndAddClickEvent(onStartFight,_autoWindow,"fight_button");
			monster_button = Xdis.getChildAndAddClickEvent(onMonster,_autoWindow,"monster_button");
			
			YFEventCenter.Instance.addEventListener(AutoEvent.ADD_SKILL,onAddSkill);
		}
		
		/**点击怪物按钮
		 * @param e
		 */		
		private function onMonster(e:MouseEvent):void{
			var monsterArr:Array = new Array();
			var vec:Vector.<TaskDyVo> = TaskDyManager.getInstance().nowTaskList;
			var len:int = vec.length;
			var taskbvo:TaskBasicVo;
			for(var i:int=0;i<len;i++){
				taskbvo = TaskBasicManager.Instance.getTaskBasicVo(vec[i].taskID);
				var taskTagDyVo:TaskTagDyVo;
				var len2:int = vec[i].tagList.length;
				for(var j:int=0;j<len2;j++){
					taskTagDyVo = vec[i].tagList[j];
					if(taskTagDyVo.tagType==TypeProps.TaskTargetType_Monster && taskTagDyVo.curNum<taskTagDyVo.totalNum){
						monsterArr.push(taskTagDyVo.tagID);
					}
				}
			}
			var isTaskMonster:Boolean;
			for(i=0;i<_targetList.renderContainer.numChildren;i++){
				isTaskMonster=false;
				for(j=0;j<monsterArr.length;j++){
					if(_targetList.getItemAt(i).monsterId==monsterArr[j]){
						isTaskMonster=true;
						break;
					}
				}
				if(isTaskMonster==true){
					MonsterRender(_targetList.getItemRenderAt(i)).setCheckBox(true);
				}else{
					MonsterRender(_targetList.getItemRenderAt(i)).setCheckBox(false);
				}
			}
		}
		
		/**开始挂机
		 * @param e 
		 */		
		private function onStartFight(e:MouseEvent):void{
			onSave();
			YFEventCenter.Instance.dispatchEventWith(GlobalEvent.StartAutoFight);
			this.close();
		}
		
		/**清除技能
		 * @param e
		 */		
		public function clearSkills(e:MouseEvent=null):void{
			for(var i:int=0;i<_skillGrids.length;i++){
				if(_skillGrids[i].item)	_skillGrids[i].removeContent();
			}
		}
		
		/**拖动添加新的技能
		 * @param e
		 */		
		private function onAddSkill(e:YFEvent):void{
			for(var i:int=0;i<_skillGrids.length;i++){
				if(_skillGrids[i].item){
					if(_skillGrids[i].item.skillId==e.param.vo.skillId && i!=e.param.index){
						_skillGrids[i].removeContent();
					}
				}
			}
		}
		
		/**保存
		 * @param e
		 */		
		public function onSave(e:MouseEvent=null):void{
			var monsterDict:Dictionary = new Dictionary();
			var len:int=_targetList.renderContainer.numChildren;
			for(var i:int=0;i<len;i++){
				if(MonsterRender(_targetList.getItemRenderAt(i)).getCheckBox().selected==true){
					monsterDict[_targetList.getItemAt(i).monsterId] = _targetList.getItemAt(i).vo;
				}
			}
			AutoManager.Instance.setMonsterIdArr(monsterDict);
			
			var msg:CAutoConfigSave = new CAutoConfigSave();
			
			msg.configIntArr = new Array();
			var ci:ConfigInt;
			
			for(i=0;i<_skillGrids.length;i++){
				if(_skillGrids[i].item)	AutoManager.Instance._skillArr[i]=_skillGrids[i].item.skillId;
				else	AutoManager.Instance._skillArr[i]=-1;
				ci = new ConfigInt();
				ci.configType = AutoSource.CT_SKILL_ARR[i];
				ci.configValue = AutoManager.Instance._skillArr[i];
				msg.configIntArr.push(ci);
			}
		
			msg.configBoolArr = new Array();
			
			var cb:ConfigBool = new ConfigBool();
			cb.configType = AutoSource.CT_EQUIPS;
			cb.configValue = _equipCheckBox.selected;
			msg.configBoolArr.push(cb);
			
			for(i=0;i<AutoSource.CT_EQUIT_ARR.length;i++){
				cb = new ConfigBool();
				cb.configType = AutoSource.CT_EQUIT_ARR[i];
				cb.configValue = _equipQualityCB[i].selected;
				msg.configBoolArr.push(cb);
			}
			
			cb = new ConfigBool();
			cb.configType = AutoSource.CT_PROPS;
			cb.configValue = _propsCheckBox.selected;
			msg.configBoolArr.push(cb);

			for(i=0;i<AutoSource.CT_PROPS_ARR.length;i++){
				cb = new ConfigBool();
				cb.configType = AutoSource.CT_PROPS_ARR[i];
				cb.configValue = _propsQualityCB[i].selected;
				msg.configBoolArr.push(cb);
			}

			AutoManager.Instance.loadConfig(msg.configBoolArr,null);
			YFEventCenter.Instance.dispatchEventWith(AutoEvent.SAVE,msg);
			//NoticeUtil.setOperatorNotice("挂机设置保存成功");
		}
		
		/**更新怪物
		 * @param initMonster
		 */		
		public function updateMonster(initMonster:Boolean=true):void{
			if(initMonster==true){
				_targetList.removeAll();
				
				var flushIdDict:Dictionary;
				if(DataCenter.Instance.mapSceneBasicVo.type!=TypeRole.MapScene_Raid){
					flushIdDict = FlushPosManager.Instance.getFlushIds(DataCenter.Instance.getMapId(),AutoSource.FLUSH_SCENE_TYPE_NORMAL);
				}else if(RaidManager.raidId!=-1){
					flushIdDict = FlushPosManager.Instance.getFlushIds(RaidManager.raidId,AutoSource.FLUSH_SCENE_TYPE_RAID);
				}
				
				var monsterDict:Dictionary = new Dictionary();
				for each(var id:int in flushIdDict){
//					var monsterId:int = FlushUnitManager.Instance.getMonsterId(flushIdDict[id]);
//					if(monsterId!=0)	monsterDict[monsterId] = monsterId;
					var flushUnitVo:FlushUnitVo = FlushUnitManager.Instance.getFlushUnitVo(flushIdDict[id]);
					if(flushUnitVo!=null){
						monsterDict[flushUnitVo.unitId1] = flushUnitVo;
					}
				}
				AutoManager.Instance.setMonsterIdArr(monsterDict);
				var item:ListItem;
				for each(flushUnitVo in monsterDict){
					if(flushUnitVo.canView==true){
						item = new ListItem();
						item.monsterId = flushUnitVo.unitId1;
						item.name = MonsterBasicManager.Instance.getMonsterBasicVo(flushUnitVo.unitId1).name;
						item.vo = flushUnitVo;
						item.isSelect = true;
						_targetList.addItem(item);
					}
				}
			}else{
				var len:int=_targetList.renderContainer.numChildren;
				for(var i:int=0;i<len;i++){
					if(AutoManager.Instance.getMonsterIdDict()[_targetList.getItemAt(i).monsterId]!=null){
						MonsterRender(_targetList.getItemRenderAt(i)).setCheckBox(true);
					}else{
						MonsterRender(_targetList.getItemRenderAt(i)).setCheckBox(false);
					}
				}
			}
		}
		
		/**更新挂机面板
		 */		
		public function updateAuto():void{
			_equipCheckBox.selected = AutoManager.Instance._equipPickable;
			_propsCheckBox.selected = AutoManager.Instance._propsPickable;
			for(var i:int=0;i<6;i++){
				_equipQualityCB[i].selected = AutoManager.Instance._equipVec[i];
			}
			for(i=0;i<5;i++){
				_propsQualityCB[i].selected = AutoManager.Instance._propsVec[i];
			}
			for(i=0;i<AutoSource.CT_SKILL_ARR.length;i++){
				_skillGrids[i].setContent(AutoManager.Instance._skillArr[i]);
			}
		}
		
		/**切换场景
		 */		
		public function onChangeScene():void{
			updateMonster();
		}

		/**全选怪物
		 * @param e
		 */		
		private function onAll(e:MouseEvent=null):void{
			var len:int = _targetList.renderContainer.numChildren;
			for(var i:int=0;i<len;i++){
				MonsterRender(_targetList.getItemRenderAt(i)).setCheckBox(true);	
			}
		}
		
		/**反选怪物
		 * @param e
		 */		
		private function onNo(e:MouseEvent):void{
			var len:int = _targetList.renderContainer.numChildren;
			for(var i:int=0;i<len;i++){
				MonsterRender(_targetList.getItemRenderAt(i)).setCheckBox(false);	
			}
		}

		/**默认设置
		 * @param e
		 */
		private function onDefault(e:MouseEvent):void{
			onAll();
			_equipCheckBox.selected=true;
			for(var i:int=0;i<6;i++){
				_equipQualityCB[i].selected=true;
			}
			_propsCheckBox.selected=true;
			for(i=0;i<5;i++){
				_propsQualityCB[i].selected=true;
			}
		}
	}
} 