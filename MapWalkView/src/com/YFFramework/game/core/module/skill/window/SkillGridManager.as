package com.YFFramework.game.core.module.skill.window
{
	import com.CMD.GameCmd;
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.proxy.StageProxy;
	import com.YFFramework.core.ui.yfComponent.controls.YFCD;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.core.global.manager.PropsBasicManager;
	import com.YFFramework.game.core.global.manager.PropsDyManager;
	import com.YFFramework.game.core.global.manager.SkillBasicManager;
	import com.YFFramework.game.core.global.model.PropsBasicVo;
	import com.YFFramework.game.core.global.model.PropsDyVo;
	import com.YFFramework.game.core.global.model.SkillBasicVo;
	import com.YFFramework.game.core.global.util.DragManager;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.global.view.tips.PropsTip;
	import com.YFFramework.game.core.global.view.tips.SkillTip;
	import com.YFFramework.game.core.global.view.tips.TipUtil;
	import com.YFFramework.game.core.module.gameView.view.GameView;
	import com.YFFramework.game.core.module.skill.mamanger.SkillDyManager;
	import com.YFFramework.game.core.module.skill.model.SkillDyVo;
	import com.dolo.common.XFind;
	import com.dolo.ui.controls.IconImage;
	import com.dolo.ui.managers.UI;
	import com.dolo.ui.tools.AutoBuild;
	import com.dolo.ui.tools.MovieClipButton;
	import com.dolo.ui.tools.Xdis;
	import com.dolo.ui.tools.Xtip;
	import com.msg.hero.CUseItem;
	import com.msg.hero.QuickBox;
	import com.net.MsgPool;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.utils.setTimeout;

	/**
	 * 技能快捷栏控制 
	 * @author flashk
	 * 
	 */
	public class SkillGridManager
	{
		public static var skillGridWidth:Number = 37;
		public static var skillGridHeight:Number = 42;
		public static var isInGrids:Boolean = false;
		
		private static var _ins:SkillGridManager;
		
		private var _ui:Sprite;
		private var _max:int = 10;
		private var _lineCount:int = 3;
		private var _icons:Array = [];
		private var _nums:Array = [];
		private var _vos:Array = [];
		private var _mbs:Array = [];
		private var _gridsUIs:Array = [];
		private var _cds:Array = [];
		private var _enableState:Array = [];
		
		public function SkillGridManager()
		{
			YFEventCenter.Instance.addEventListener(GlobalEvent.KeyDownNum_1,onKeyDownNum1);
			YFEventCenter.Instance.addEventListener(GlobalEvent.KeyDownNum_2,onKeyDownNum2);
			YFEventCenter.Instance.addEventListener(GlobalEvent.KeyDownNum_3,onKeyDownNum3);
			YFEventCenter.Instance.addEventListener(GlobalEvent.KeyDownNum_4,onKeyDownNum4);
			YFEventCenter.Instance.addEventListener(GlobalEvent.KeyDownNum_5,onKeyDownNum5);
			YFEventCenter.Instance.addEventListener(GlobalEvent.KeyDownNum_6,onKeyDownNum6);
			YFEventCenter.Instance.addEventListener(GlobalEvent.KeyDownNum_7,onKeyDownNum7);
			YFEventCenter.Instance.addEventListener(GlobalEvent.KeyDownNum_8,onKeyDownNum8);
			YFEventCenter.Instance.addEventListener(GlobalEvent.KeyDownNum_9,onKeyDownNum9);
			YFEventCenter.Instance.addEventListener(GlobalEvent.KeyDownNum_0,onKeyDownNum0);
			YFEventCenter.Instance.addEventListener(GlobalEvent.SKILL_TREE_UPDATE,onSkillTreeUpdate);
			YFEventCenter.Instance.addEventListener(GlobalEvent.SKillPlayCD,onSkillPlayCD);
			YFEventCenter.Instance.addEventListener(GlobalEvent.BagDrugUseItemResp,onBagUseItemSuccess);
			YFEventCenter.Instance.addEventListener(GlobalEvent.BagChange,onGagChange);
			
			_ui = GameView.SkillPaneUI;
			UI.setMouseAble(Xdis.getChild(_ui,"quickKeyTxt"),false);
			UI.setMouseAble(Xdis.getChild(_ui,"quickKeyTxt2"),false);
			for(i=1;i<=_lineCount;i++){
				_gridsUIs.push(Xdis.getChild(_ui,"skillbar"+i));
				AutoBuild.replaceAll(_gridsUIs[i-1]);
			}
			
			var i:int=0;
			var mb:MovieClipButton;
			var gridsUI:Sprite;
			var index:int=0;
			var icon:DisplayObject;
			var cd:YFCD;
			
			for(var j:int=0;j<_gridsUIs.length;j++){
				gridsUI = _gridsUIs[j];
				for(i=1;i<=_max;i++){
					icon = Xdis.getChild(gridsUI,"icon"+i+"_iconImage") ;
					_icons.push( icon );
					_nums.push( Xdis.getChild(gridsUI,"num"+i+"_txt") );
					UI.setMouseAble(_icons[index] as Sprite,false);
					TextField(_nums[index]).mouseEnabled = false;
					mb = new MovieClipButton(Xdis.getChild(gridsUI,"effect_"+i));
					mb.hit.addEventListener(MouseEvent.MOUSE_DOWN,startDragSkill);
					mb.hit.addEventListener(MouseEvent.CLICK,onSkillGridClick);
					_mbs.push(mb);
					cd = new YFCD(39,39);
					cd.mouseChildren = false;
					cd.mouseEnabled = false;
					cd.x = icon.x;
					cd.y = icon.y;
					gridsUI.addChild(cd);
					_cds.push(cd);
					index++;
				}
			}
		}
		
		private function onGagChange(event:YFEvent):void
		{
			var vo:PropsDyVo;
			for(var i:int=0;i<_vos.length;i++){
				updatePropsNum(i);
			}
		}
		
		private function updatePropsNum(index:int):void
		{
			var propVO:PropsDyVo = _vos[index] as PropsDyVo ;
			var txt:TextField = getTextField(index);
			if(propVO == null ||  txt == null) return;
			var num:int = PropsDyManager.instance.getPropsQuantity(propVO.templateId);
			if(num>0){
				txt.text = String(num) ;
			}else{
				clearOldGrid(index);
			}
		}
		
		private function onBagUseItemSuccess(event:YFEvent):void
		{
			var vo:PropsDyVo;
			for(var i:int=0;i<_vos.length;i++){
				vo = _vos[i] as PropsDyVo;
				if(vo != null){
					var pbvo:PropsBasicVo = PropsBasicManager.Instance.getPropsBasicVo(vo.templateId);
					var num:int = PropsDyManager.instance.getPropsQuantity(vo.templateId)
					if(pbvo && num > 0){
						startCD(pbvo.cd_time,i);
					}
				}
			}
		}
		
		private function onSkillPlayCD(event:YFEvent):void
		{
			var id:int = int(event.param);
			var vo:SkillDyVo;
			var skillBaicVO:SkillBasicVo;
			var mb:MovieClipButton;
			for(var i:int=0;i<_vos.length;i++){
				vo = _vos[i] as SkillDyVo;
				if(vo != null){
					skillBaicVO = SkillBasicManager.Instance.getSkillBasicVo(vo.skillId,vo.skillLevel);
					if(skillBaicVO){
						if(vo.skillId == id){
							startCD(skillBaicVO.cooldown_time,i);
						}else{
							startCD(1000,i);
						}
					}
				}
			}
		}
		
		private function startCD(cooldownTime:int,index:int):void
		{
			var i:int = index;
			YFCD(_cds[i]).play(cooldownTime,0,false,onCDPlayComplete,i);
			YFCD(_cds[i]).start();
			setEnableGrid(i,false);
		}
		
		private function setEnableGrid(index:int,enable:Boolean):void
		{
			var mb:MovieClipButton;
			_enableState[index] = enable;
			mb = _mbs[index];
//			UI.setEnable(mb.mc,enable,false);
		}
		
		private function onCDPlayComplete(index:int):void
		{
			setEnableGrid(index,true);
		}
		
		private function onSkillTreeUpdate(event:YFEvent):void
		{
			var data:Array = event.param as Array;
			var skillVO:SkillDyVo;
			for(var i:int=0;i<_nums.length;i++){
				skillVO = _vos[i] as SkillDyVo;
				if(skillVO && skillVO.skillId == data[0]){
					getTextField(i).text = data[1];
					getIcon(i).url = SkillBasicManager.Instance.getURL(skillVO.skillId,skillVO.skillLevel);
					var mb:MovieClipButton;
					mb = _mbs[i];
					Xtip.registerLinkTip(mb.hit,SkillTip,TipUtil.skillTipInitFunc,skillVO.skillId,skillVO.skillLevel);
				}
			}
		}
		
		protected function onSkillGridClick(event:MouseEvent):void
		{
			DragManager.Instance.deleteDrag();
			var index:int = int(DisplayObject(event.currentTarget).parent.name.slice(7));
			var findIndex:int = XFind.findIndexInArray(DisplayObject(event.currentTarget).parent.parent,_gridsUIs);
			if(findIndex >0){
				index += _max*findIndex;
			}
			index--;
			sendUseEvent(index);
		}
		
		private function onKeyDownNum1(event:Object=null):void
		{
			sendUseEvent(0);
		}
		
		private function onKeyDownNum2(event:Object=null):void
		{
			sendUseEvent(1);
		}
		
		private function onKeyDownNum3(event:Object=null):void
		{
			sendUseEvent(2);
		}
		
		private function onKeyDownNum4(event:Object=null):void
		{
			sendUseEvent(3);
		}
		
		private function onKeyDownNum5(event:Object=null):void
		{
			sendUseEvent(4);
		}
		
		private function onKeyDownNum6(event:Object=null):void
		{
			sendUseEvent(5);
		}
		
		private function onKeyDownNum7(event:Object=null):void
		{
			sendUseEvent(6);
		}
		
		private function onKeyDownNum8(event:Object=null):void
		{
			sendUseEvent(7);
		}
		
		private function onKeyDownNum9(event:Object=null):void
		{
			sendUseEvent(8);
		}
		
		private function onKeyDownNum0(event:Object=null):void
		{
			sendUseEvent(9);
		}
		
		private function sendUseEvent(index:int):void
		{
			if(_enableState[index] == false) return;
			if(_vos[index] == null) return;
			if(_vos[index] is SkillDyVo){
				YFEventCenter.Instance.dispatchEventWith(GlobalEvent.SkillTrigger,{id:getSkillVOAt(index).skillId,level:getSkillVOAt(index).skillLevel});
			}else if(_vos[index] is PropsDyVo){
				var pvo:PropsDyVo = _vos[index];
				var msg:CUseItem = new CUseItem();
				msg.itemPos = PropsDyManager.instance.getPropsPostion(pvo.propsId);
				MsgPool.sendGameMsg(GameCmd.CUseItem,msg);
			}
		}
				
		private function getSkillVOAt(index:int):SkillDyVo
		{
			return _vos[index] as SkillDyVo;
		}
		
		protected function startDragSkill(event:MouseEvent):void
		{
			var index:int = int(DisplayObject(event.currentTarget).parent.name.slice(7));
			var findIndex:int = XFind.findIndexInArray(DisplayObject(event.currentTarget).parent.parent,_gridsUIs);
			if(findIndex >0){
				index += _max*findIndex;
			}
			index--;
			if(_vos[index] != null){
				var dragVO:DragData = new DragData();
				dragVO.type = DragData.dragFromGrid;
				dragVO.fromID = index;
				dragVO.data = _vos[index];
				isInGrids = false;
				StageProxy.Instance.stage.addEventListener(MouseEvent.MOUSE_UP,onStageMouseUp);
				DragManager.Instance.startDrag(getIcon(index),dragVO);
			}
		}
		
		private function onStageMouseUp(event:Event):void
		{
			StageProxy.Instance.stage.removeEventListener(MouseEvent.MOUSE_UP,onStageMouseUp);
			setTimeout(checkMouseUpLater,5);
		}
		
		private function checkMouseUpLater():void
		{
			if(isInGrids == false && DragManager.Instance.dragVo != null){
				SkillWindow.ins.deleteSkill();
			}
		}
		
		public static function getInstance():SkillGridManager
		{
			if(_ins == null) _ins = new SkillGridManager();
			return _ins;
		}
		
		public function putOneBox(vo:QuickBox):void
		{
			setVO(vo);
		}
		
		public function changeTwoVO(from:int,to:int):void
		{
			var data:Object = _vos[to];
			_vos[to] = _vos[from];
			_vos[from] = data;
			_vos[from] = null;
		}
		
		public function getIcon(index:int):IconImage
		{
			return _icons[index]  as IconImage;
		}
		
		public function resetTwoGrid(newVO:QuickBox,oldVO:QuickBox):void
		{
			if(newVO.keyId == -1){
				clearOldGrid(oldVO.keyId);
			}
			if(oldVO.keyId == -1){
				putOneBox(newVO);
			}
			if(newVO.keyId != -1 && oldVO.keyId != -1){
				var needClear:Boolean = false;
				if(_vos[newVO.keyId] == null){
					needClear = true;
				}
				resetGrid(newVO);
				if(needClear == false){
					resetGrid(oldVO);
				}else{
					clearOldGrid(oldVO.keyId);
				}
			}
		}
		
		public function clearOldGrid(index:int):void
		{
			getIcon(index).clear();
			getTextField(index).text = "";
			_vos[index] = null;
			var mb:MovieClipButton;
			mb = _mbs[index];
			Xtip.clearLinkTip(mb.hit,TipUtil.skillTipInitFunc);
		}
		
		public function getTextField(index:int):TextField
		{
			return _nums[index] as TextField;
		}
		
		private function setVO(vo:QuickBox):void
		{
			if(vo.keyId>=_max*_lineCount) return;
			if(vo.keyId == -1) return;
			var mb:MovieClipButton;
			switch(vo.boxType){
				case TypeProps.BT_SKILL:
					var skillVO:SkillDyVo =SkillDyManager.Instance.getSkillDyVo(vo.boxId);
					if(skillVO){
						getIcon(vo.keyId).url = SkillBasicManager.Instance.getURL(skillVO.skillId,skillVO.skillLevel);
						getTextField(vo.keyId).text = String(skillVO.skillLevel);
						_vos[vo.keyId] = skillVO;
						mb = _mbs[vo.keyId];
						Xtip.registerLinkTip(mb.hit,SkillTip,TipUtil.skillTipInitFunc,skillVO.skillId,skillVO.skillLevel);
					} 
					break;
				case TypeProps.BT_ITEM:
					var propVO:PropsDyVo = PropsDyManager.instance.getPropsInfo(vo.boxId);
					if(propVO){
						getIcon(vo.keyId).url = PropsBasicManager.Instance.getURL(propVO.templateId);
						getTextField(vo.keyId).text = String(PropsDyManager.instance.getPropsQuantity(propVO.templateId));
						_vos[vo.keyId] = propVO;
						mb = _mbs[vo.keyId];
						Xtip.registerLinkTip(mb.hit,PropsTip,TipUtil.propsTipInitFunc,propVO.propsId,propVO.templateId);
					}
					break;
			}
		}
		
		public function resetGrid(vo:QuickBox):void
		{
			if(vo.keyId>=_max*_lineCount) return;
			if(vo.boxId == 0){
				getIcon(vo.keyId).clear();
			}else{
				setVO(vo);
			}
		}
		
	}
}