package com.YFFramework.game.core.module.skill.window
{
	import com.CMD.GameCmd;
	import com.YFFramework.core.debug.print;
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.net.loader.image_swf.IconLoader;
	import com.YFFramework.core.net.loader.image_swf.UILoader;
	import com.YFFramework.core.ui.layer.LayerManager;
	import com.YFFramework.core.utils.HashMap;
	import com.YFFramework.core.utils.URLTool;
	import com.YFFramework.game.core.global.DataCenter;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.core.global.manager.CharacterDyManager;
	import com.YFFramework.game.core.global.manager.SkillBasicManager;
	import com.YFFramework.game.core.global.model.SkillBasicVo;
	import com.YFFramework.game.core.global.view.tips.SkillTip;
	import com.YFFramework.game.core.global.view.tips.TipUtil;
	import com.YFFramework.game.core.module.skill.mamanger.SkillDyManager;
	import com.YFFramework.game.core.module.skill.model.SkillDyVo;
	import com.dolo.lang.LangBasic;
	import com.dolo.ui.controls.Button;
	import com.dolo.ui.controls.IconImage;
	import com.dolo.ui.controls.VScrollBar;
	import com.dolo.ui.managers.UI;
	import com.dolo.ui.tools.AutoBuild;
	import com.dolo.ui.tools.Xdis;
	import com.dolo.ui.tools.Xtip;
	import com.greensock.TweenLite;
	import com.msg.skill_pro.CLearnSkill;
	import com.net.MsgPool;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.utils.Dictionary;

	/**
	 * 单个技能面板Tab 
	 * @author flashk
	 * 
	 */
	public class SkillTabUIC
	{
		public static var warnColor:uint = 0xFF0000;
		
		private var _ui:Sprite;
		private var _tree:Sprite;
		private var _scroll:VScrollBar;
		private var _learnButton:Button;
		private var _index:int;
		private var _allVOSPs:Array;
		private var _tops:Array = [];
		private var _lefts:Array = [];
		private var _right:Array = [];
		private var _allVO:Vector.<SkillDyVo>;
		private var _topVct:Vector.<SkillBasicVo>;
		private var _leftVct:Vector.<SkillBasicVo>;
		private var _rightVct:Vector.<SkillBasicVo>;
		private var _icon:IconImage;
		private var _skillNameTxt:TextField;
		private var _levelTxt:TextField;
		private var _effectTxt:TextField;
		private var _tiaoJianTxt1:TextField;
		private var _tiaoJianTxt2:TextField;
		private var _tiaoJianTxt3:TextField;
		private var _tiaoJianTxt4:TextField;
		private var _tiaoJianTxt5:TextField;
		private var _defaultTextColors:Array = [];
		private var _lastSelect:Sprite;
		private var _selectVO:SkillBasicVo;
		private var _dragManager:SkillDragManager;
		private var _nowSelectSP:Sprite;
		
		public function SkillTabUIC(target:Sprite,tabIndex:int)
		{
			YFEventCenter.Instance.addEventListener(GlobalEvent.SKILL_TREE_UPDATE,updateTree);
			YFEventCenter.Instance.addEventListener(GlobalEvent.HeroLevelUp,updateLevelSelectCheck);
			YFEventCenter.Instance.addEventListener(GlobalEvent.MoneyChange,updateLevelSelectCheck);
			
			_dragManager = new SkillDragManager(this);
			_index = tabIndex;
			_ui = target;
			_tree = Xdis.getChild(_ui,"skillTree");
			_scroll = Xdis.getChild(_ui,"pet_vScrollBar");
			_scroll.setTarget(_tree,false,250,485);
			_scroll.updateSize(_tree.height);
			_icon = Xdis.getChild(_ui,"icon_iconImage");
			_skillNameTxt = Xdis.getChild(_ui,"skill_name");
			_levelTxt = Xdis.getChild(_ui,"skill_level");
			_effectTxt = Xdis.getChild(_ui,"effect");
			_learnButton = Xdis.getChild(_ui,"learn_button");
			_learnButton.addEventListener(MouseEvent.CLICK,onLearnClick);
			_learnButton.enabled = false;
			_tiaoJianTxt1 = Xdis.getChild(_ui,"tiao_jian_1");
			_tiaoJianTxt2 = Xdis.getChild(_ui,"tiao_jian_2");
			_tiaoJianTxt3 = Xdis.getChild(_ui,"tiao_jian_3");
			_tiaoJianTxt4 = Xdis.getChild(_ui,"tiao_jian_4");
			_tiaoJianTxt5 = Xdis.getChild(_ui,"tiao_jian_5");
			_defaultTextColors[1] = _tiaoJianTxt1.textColor;
			_defaultTextColors[2] = _tiaoJianTxt2.textColor;
			_defaultTextColors[3] = _tiaoJianTxt3.textColor;
			_defaultTextColors[4] = _tiaoJianTxt4.textColor;
			_defaultTextColors[5] = _tiaoJianTxt5.textColor;
			SkillTree.init();
			var bigType:int = tabIndex-1;
			_topVct = SkillTree.getInstance().getTop(bigType);
			_leftVct = SkillTree.getInstance().getLeft(bigType);
			_rightVct = SkillTree.getInstance().getRight(bigType);
			
			var i:int;
			var sp:Sprite;
			for(i=1;i<=4;i++){
				sp = Xdis.getChild(_tree,"bt"+i);
				_tops.push(sp);
				_dragManager.add(sp);
				DisplayObject(Xdis.getChild(_tree,"bt"+i,"select_sp")).visible = false;
				SimpleButton(Xdis.getChild(_tree,"bt"+i,"hit")).useHandCursor = false;
			}
			for(i=105;i<=110;i++){
				sp = Xdis.getChild(_tree,"bt"+i);
				_lefts.push(sp);
				_dragManager.add(sp);
				DisplayObject(Xdis.getChild(_tree,"bt"+i,"select_sp")).visible = false;
				SimpleButton(Xdis.getChild(_tree,"bt"+i,"hit")).useHandCursor = false;
			}
			for(i=205;i<=210;i++){
				sp = Xdis.getChild(_tree,"bt"+i);
				_right.push(sp);
				_dragManager.add(sp);
				_dragManager.add(Xdis.getChild(_tree,"bt"+i));
				DisplayObject(Xdis.getChild(_tree,"bt"+i,"select_sp")).visible = false;
				SimpleButton(Xdis.getChild(_tree,"bt"+i,"hit")).useHandCursor = false;
			}
			
			initIcons();
			updateTree();
			onIconClick(null,_tops[0]);
		}
		
		private function updateLevelSelectCheck(event:YFEvent):void
		{
			if(_nowSelectSP){
				try{
					onIconClick(null,_nowSelectSP);
				} 
				catch(error:Error){
					
				}
			}
		}
		
		protected function onLearnClick(event:MouseEvent):void
		{
			if(_selectVO == null) return;
			var msg:CLearnSkill = new CLearnSkill();
			msg.skillId = _selectVO.skill_id;
			MsgPool.sendGameMsg(GameCmd.CLearnSkill,msg);
		}
		
		private function updateTree(event:Object = null):void
		{
			_allVOSPs = [];
			_allVO = SkillDyManager.Instance.getAllSkill();
			var j:int;
			var vo:SkillDyVo;
			var len:int = _allVO.length;
			for(var i:int=0;i<len;i++){
				vo = _allVO[i];
				for(j=0;j<_topVct.length;j++){
					if(_topVct[j]){
						if(_topVct[j].skill_id == vo.skillId){
							lightSkill(1,j,vo.skillLevel,i,vo.skillId);
						}
					}
				}
				for(j=0;j<_leftVct.length;j++){
					if(_leftVct[j]){
						if(_leftVct[j].skill_id == vo.skillId){
							lightSkill(2,j,vo.skillLevel,i,vo.skillId);
						}
					}
				}
				for(j=0;j<_rightVct.length;j++){
					if(_rightVct[j]){
						if(_rightVct[j].skill_id == vo.skillId){
							lightSkill(3,j,vo.skillLevel,i,vo.skillId);
						}
					}
				}
			}
			if(_nowSelectSP){
				onIconClick(null,_nowSelectSP);
			}
		}
		
		private function checkSkillHasLearn(skillID:int):Boolean
		{
			if(_allVO == null) return false;
			for(var i:int=0;i<_allVO.length;i++){
				if(_allVO[i].skillId == skillID){
					return true;
				}
			}
			return false;
		}
		
		private function lightSkill(type:int,index:int,level:int,allVOIndex:int,skillID:int):void
		{
			var sp:Sprite;
			var idStr:String;
			switch(type){
				case 1:
					sp = _tops[index];
					break;
				case 2:
					sp = _lefts[index];
					break;
				case 3:
					sp = _right[index];
					break;
			}
			_allVOSPs[allVOIndex] = sp;
			if(sp == null) return;
			Xtip.registerLinkTip(sp,SkillTip,TipUtil.skillTipInitFunc,skillID,level);
			UI.setEnable(sp,true);
			TextField(sp.getChildByName("level_txt")).text = String(level);
			var icon:IconImage;
			icon = sp.getChildByName("icon_iconImage") as IconImage;
			if(icon){
				icon.url = SkillBasicManager.Instance.getURL(skillID,level);
			}
			idStr = sp.name.slice(2);
			var arrDis:MovieClip = Xdis.getChild(_tree,"arr"+idStr);
			if(arrDis){
				arrDis.gotoAndStop(2);
			}
		}
		
		private function initIcons():void
		{
			var i:int;
			var sp:Sprite;
			var icon:IconImage;
			var vo:SkillBasicVo;
			var len:int;
			len = _tops.length;
			for(i=0;i< len;i++){
				vo = _topVct[i];
				if(vo){
					sp = _tops[i];
					Xtip.registerLinkTip(sp,SkillTip,TipUtil.skillTipInitFunc,vo.skill_id,vo.skill_level);
					sp.addEventListener(MouseEvent.CLICK,onIconClick);
					UI.setEnable(sp,false,false);
					icon = sp.getChildByName("icon_iconImage") as IconImage;
					icon.url = URLTool.getSkillIcon(vo.icon_id);
				}
			}
			len = _lefts.length;
			for(i=0;i<len;i++){
				vo = _leftVct[i];
				if(vo){
					sp = _lefts[i];
					sp.addEventListener(MouseEvent.CLICK,onIconClick);
					Xtip.registerLinkTip(sp,SkillTip,TipUtil.skillTipInitFunc,vo.skill_id,vo.skill_level);
					UI.setEnable(sp,false,false);
					icon = sp.getChildByName("icon_iconImage") as IconImage;
					icon.url = URLTool.getSkillIcon(vo.icon_id);
				}
			}
			len = _right.length;
			for(i=0;i<len;i++){
				vo = _rightVct[i];
				if(vo){
					sp = _right[i];
					sp.addEventListener(MouseEvent.CLICK,onIconClick);
					Xtip.registerLinkTip(sp,SkillTip,TipUtil.skillTipInitFunc,vo.skill_id,vo.skill_level);
					UI.setEnable(sp,false,false);
					icon = sp.getChildByName("icon_iconImage") as IconImage;
					icon.url = URLTool.getSkillIcon(vo.icon_id);
				}
			}
		}
		
		public function findDyVO(sp:Sprite):SkillDyVo
		{
			if(_allVOSPs == null) return null;
			for(var i:int=0;i<_allVOSPs.length;i++){
				if(_allVOSPs[i] == sp){
					return _allVO[i];
				}
			}
			return null;
		}
		
		public function findVO(sp:Sprite):SkillBasicVo
		{
			var vo:SkillBasicVo;
			var i:int;
			var len:int;
			len = _tops.length;
			for(i=0;i<len;i++){
				if(_tops[i] == sp){
					vo = _topVct[i];
					return vo;
				}
			}
			len = _lefts.length;
			for(i=0;i<len;i++){
				if(_lefts[i] == sp){
					vo = _leftVct[i];
					return vo;
				}
			}
			len = _right.length;
			for(i=0;i<len;i++){
				if(_right[i] == sp){
					vo = _rightVct[i];
					return vo;
				}
			}
			return null;
		}
		
		protected function onIconClick(event:MouseEvent,targetSp:Sprite=null):void
		{
			var sp:Sprite;
			if(event != null){
				sp = event.currentTarget as Sprite;
			}else{
				sp = targetSp;
			}
			_nowSelectSP = sp;
			var vo:SkillBasicVo;
			var dyVO:SkillDyVo = findDyVO(sp);
			if(dyVO != null){	
				_learnButton.label = "升级";
				vo = SkillBasicManager.Instance.getSkillBasicVo(dyVO.skillId,dyVO.skillLevel);
			}else{
				_learnButton.label = "学习";
				vo = findVO(sp);
			}
			if(vo == null) return;
			_selectVO = vo;
			var level:int = vo.skill_level;
			switchSelect(sp);
			_icon.url = SkillBasicManager.Instance.getURL(vo.skill_id,vo.skill_level);
			_skillNameTxt.text = vo.name;
			_levelTxt.text = LangBasic.level+level;
			_effectTxt.text = vo.description+"\n\n"+vo.effect_desc;
			if(dyVO != null){
				vo =  SkillBasicManager.Instance.getSkillBasicVo(dyVO.skillId,dyVO.skillLevel+1);
			}
			if(vo != null){
				_tiaoJianTxt1.text = LangBasic.beforeSkill+getSkillName(vo.before_skill);
				_tiaoJianTxt2.text = LangBasic.excludeSkill+getSkillName(vo.exclude_skill);
				_tiaoJianTxt3.text = LangBasic.playerLevel + vo.character_level;
				_tiaoJianTxt4.text = LangBasic.seeConsume + vo.see_consume;
				_tiaoJianTxt5.text = LangBasic.noteConsume + vo.note_consume;
				//判断技能是否符合条件
				var cantCount:int=0;
				if(checkSkillHasLearn(vo.before_skill) == true || vo.before_skill == 0){
					_tiaoJianTxt1.textColor = _defaultTextColors[1];
				}else{
					_tiaoJianTxt1.textColor = warnColor;
					cantCount++;
				}
				if(checkSkillHasLearn(vo.exclude_skill) == false || vo.exclude_skill == 0){
					_tiaoJianTxt2.textColor = _defaultTextColors[2];
				}else{
					_tiaoJianTxt2.textColor = warnColor;
					cantCount++;
				}
				if(DataCenter.Instance.roleSelfVo.roleDyVo.level >= vo.character_level){
					_tiaoJianTxt3.textColor = _defaultTextColors[3];
				}else{
					_tiaoJianTxt3.textColor = warnColor;
					cantCount++;
				}
				if(CharacterDyManager.Instance.yueli >= vo.see_consume){
					_tiaoJianTxt4.textColor = _defaultTextColors[4];
				}else{
					_tiaoJianTxt4.textColor = warnColor;
					cantCount++;
				}
				if(DataCenter.Instance.roleSelfVo.silver >= vo.note_consume){
					_tiaoJianTxt5.textColor = _defaultTextColors[5];
				}else{
					_tiaoJianTxt5.textColor = warnColor;
					cantCount++;
				}
				if(cantCount>0){
					_learnButton.enabled = false;
				}else{
					_learnButton.enabled = true;
				}
			}else{
				_tiaoJianTxt1.text = LangBasic.skillLevelFull;
				_tiaoJianTxt2.text = LangBasic.skillLevelFull;
				_tiaoJianTxt3.text = LangBasic.skillLevelFull;
				_tiaoJianTxt4.text = LangBasic.skillLevelFull;
				_tiaoJianTxt5.text = LangBasic.skillLevelFull;
				var textColorUse:uint = warnColor;
				_tiaoJianTxt1.textColor = textColorUse;
				_tiaoJianTxt2.textColor = textColorUse;
				_tiaoJianTxt3.textColor = textColorUse;
				_tiaoJianTxt4.textColor = textColorUse;
				_tiaoJianTxt5.textColor = textColorUse;
				_learnButton.enabled = false;
			}
		}
		
		private function switchSelect(sp:Sprite):void
		{
			var selDis:DisplayObject;
			if(_lastSelect){
				selDis = _lastSelect.getChildByName("select_sp");
				TweenLite.to(selDis,0.6,{alpha:0});
			}
			_lastSelect = sp;
			selDis = _lastSelect.getChildByName("select_sp");
			selDis.visible = true;
			selDis.alpha = 0;
			TweenLite.to(selDis,0.4,{alpha:1});
		}
		
		private function getSkillName(id:int):String
		{
			if(id == 0) return "无";
			var vo:SkillBasicVo = SkillBasicManager.Instance.getSkillBasicVo(id,1);
			return vo.name;
		}
		
	}
}