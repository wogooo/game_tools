package com.YFFramework.game.core.module.skill.window
{
	import com.CMD.GameCmd;
	import com.YFFramework.game.core.global.manager.ConstMapBasicManager;
	import com.YFFramework.game.core.global.manager.PropsBasicManager;
	import com.YFFramework.game.core.global.manager.PropsDyManager;
	import com.YFFramework.game.core.global.model.PropsBasicVo;
	import com.YFFramework.game.core.global.model.PropsDyVo;
	import com.YFFramework.game.core.global.util.DragManager;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.module.gameView.view.GameView;
	import com.YFFramework.game.core.module.skill.model.SkillDyVo;
	import com.dolo.common.XFind;
	import com.dolo.lang.LangBasic;
	import com.dolo.ui.controls.Alert;
	import com.dolo.ui.controls.Window;
	import com.dolo.ui.managers.TabsManager;
	import com.dolo.ui.tools.Xdis;
	import com.msg.enumdef.RspMsg;
	import com.msg.hero.CSetQuickBox;
	import com.msg.hero.QuickBox;
	import com.msg.hero.SSetQuickBox;
	import com.net.MsgPool;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	/**
	 * 技能窗口 
	 * @author Administrator
	 * 
	 */
	public class SkillWindow extends Window
	{
		public static var skillGridWidth:Number = 40;
		public static var skillGridHeight:Number = 40;
		
		private static var _ins:SkillWindow;
		private static var _dragType:int=0;
		
		private var _ui:Sprite;
		private var _tabs:TabsManager;
		private var _uics:Array = [];
		private var _isInit:Boolean = false;
		private var _dragData:DragData;
		private var _gridMax:int = 10;
		private var _bagIDs:Array = [];
		
		public function SkillWindow()
		{
			_ins = this;
			GameView.SkillPaneUI.addEventListener(MouseEvent.MOUSE_UP,onSkillPanelUIMouseUp);
			MsgPool.addCallBack(GameCmd.SSetQuickBox,SSetQuickBox,onServerSSetQuickBox);
		}
		
		public static function get dragType():int
		{
			return _dragType;
		}

		public static function get ins():SkillWindow
		{
			return _ins;
		}

		private function onServerSSetQuickBox(data:SSetQuickBox):void
		{
			if(data.code == RspMsg.RSPMSG_SUCCESS){
				showOKLater();
				SkillGridManager.getInstance().resetTwoGrid(data.newBoxInfo,data.oldBoxInfo);
			}
		}
		
		private function showOKLater():void
		{
			switch(_dragType){
				case 1:
//					Alert.show(LangBasic.skillDragSuccess1,LangBasic.skill);
					break;
				case 2:
//					Alert.show(LangBasic.skillDragSuccess2,LangBasic.skill);
					break;
				case 3:
//					Alert.show(LangBasic.skillDragSuccess3,LangBasic.skill);
					break;
			}
		}
		
		protected function onSkillPanelUIMouseUp(event:MouseEvent):void
		{
			var mx:int = DisplayObject(event.currentTarget).mouseX;
			var my:int = DisplayObject(event.currentTarget).mouseY;
			var gx:int = Math.floor((mx-5)/skillGridWidth);
			var gy:int = Math.floor(my/skillGridHeight);
			if(gy < 0) gy *= -1;
			if(gx >= _gridMax) return;
			gx += gy*_gridMax;
			SkillGridManager.isInGrids = true;
			var vo:SkillDyVo = DragManager.Instance.dragVo as SkillDyVo;
			var msg:CSetQuickBox;
			var qb:QuickBox;
			if(vo){
				_dragType = 1;
				msg = new CSetQuickBox();
				qb = new QuickBox();
				qb.keyId = -1;
				qb.boxType = TypeProps.BT_SKILL;
				qb.boxId = vo.skillId;
				msg.fromBoxInfo = qb;
				msg.targetKeyId = gx;
				MsgPool.sendGameMsg(GameCmd.CSetQuickBox,msg);
				return;
			}
			var dragData:DragData = DragManager.Instance.dragVo as DragData;
			if(dragData == null) return;
			if(dragData.type == DragData.dragFromGrid){
				_dragType = 2;
				_dragData = dragData;
				_dragData.toID = gx;
				msg = new CSetQuickBox();
				qb = new QuickBox();
				qb.keyId = dragData.fromID;
				if(dragData.data is  SkillDyVo){
					var bsvo:SkillDyVo = dragData.data as SkillDyVo;
					qb.boxType = TypeProps.BT_SKILL;
					qb.boxId = bsvo.skillId;
				}else if(dragData.data is PropsDyVo){
					var prosvo:PropsDyVo = dragData.data as PropsDyVo;
					qb.boxType = TypeProps.BT_ITEM;
					qb.boxId = prosvo.propsId;
				}
				msg.fromBoxInfo = qb;
				msg.targetKeyId = gx;
				MsgPool.sendGameMsg(GameCmd.CSetQuickBox,msg);
			}else if(dragData.type == DragData.FROM_BAG){
				_dragType = 4;
				_dragData = dragData;
				var itemVO:PropsDyVo = PropsDyManager.instance.getPropsInfo(_dragData.data.id);
				if(itemVO ){
					var pbvo:PropsBasicVo = PropsBasicManager.Instance.getPropsBasicVo(itemVO.templateId);
					if(pbvo.type == TypeProps.PROPS_TYPE_DRUG)
					{
						msg = new CSetQuickBox();
						qb = new QuickBox();
						qb.keyId = -1;
						qb.boxType = TypeProps.BT_ITEM;
						qb.boxId = itemVO.propsId;
						msg.fromBoxInfo = qb;
						msg.targetKeyId = gx;
						MsgPool.sendGameMsg(GameCmd.CSetQuickBox,msg);
					}else{
						Alert.show("此物品不可以被放入快捷栏！",LangBasic.skill);
					}
				}else{
					Alert.show("此物品不可以被放入快捷栏！",LangBasic.skill);
				}
			}
		}
		
		public function deleteSkill():void
		{
			var msg:CSetQuickBox;
			var qb:QuickBox;
			var dragData:DragData = DragManager.Instance.dragVo as DragData;
			_dragData = dragData;
			_dragType = 3;
			msg = new CSetQuickBox();
			qb = new QuickBox();
			qb.keyId = dragData.fromID;
			if(dragData.data is SkillDyVo){
				var bsvo:SkillDyVo = dragData.data as SkillDyVo;
				qb.boxType = TypeProps.BT_SKILL;
				qb.boxId = bsvo.skillId;
			}else  if(dragData.data is PropsBasicVo){
				var prosvo:PropsBasicVo = dragData.data as PropsBasicVo;
				qb.boxType = TypeProps.BT_ITEM;
				qb.boxId = prosvo.template_id;
			}
			msg.fromBoxInfo = qb;
			msg.targetKeyId = -1;
			MsgPool.sendGameMsg(GameCmd.CSetQuickBox,msg);
		}
		
		override public function open():void
		{
			if(_isInit == false){
				_ui = initByArgument(490,535+Window.titleHeight,"ui.SkillUI","技能");
				_tabs = new TabsManager();
				_tabs.initTabs(_ui,Xdis.getChild(_ui,"tabs_sp"),3,"skillPanel");
				_uics.push(new SkillTabUIC(Xdis.getChild(_ui,"skillPanel1"),1));
				_uics.push(new SkillTabUIC(Xdis.getChild(_ui,"skillPanel2"),2));
				_uics.push(new SkillTabUIC(Xdis.getChild(_ui,"skillPanel3"),3));
			}
			_isInit = true;
			super.open();
		}
		
	}
}