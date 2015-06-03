package com.YFFramework.game.core.module.autoSetting.view
{
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.proxy.StageProxy;
	import com.YFFramework.game.core.global.manager.SkillBasicManager;
	import com.YFFramework.game.core.global.util.DragManager;
	import com.YFFramework.game.core.global.view.tips.SkillTip;
	import com.YFFramework.game.core.global.view.tips.TipUtil;
	import com.YFFramework.game.core.module.autoSetting.event.AutoEvent;
	import com.YFFramework.game.core.module.autoSetting.manager.AutoManager;
	import com.YFFramework.game.core.module.skill.mamanger.SkillDyManager;
	import com.YFFramework.game.core.module.skill.model.DragData;
	import com.YFFramework.game.core.module.skill.model.SkillDyVo;
	import com.YFFramework.game.ui.layer.LayerManager;
	import com.dolo.ui.controls.BitmapControl;
	import com.dolo.ui.controls.IconImage;
	import com.dolo.ui.managers.UI;
	import com.dolo.ui.skin.Skins;
	import com.dolo.ui.tools.Xtip;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	/**
	 * @version 1.0.0
	 * creation time：2013-7-27 下午2:37:06
	 */
	public class SkillGrid{
		
		private var _sp:Sprite;
		private var _bg:BitmapControl;
		private var _iconImage:IconImage;
		private var _item:SkillDyVo;
		private var _index:int;
		
		public function SkillGrid(x:Number,y:Number,index:int){
			_sp= new Sprite();
			_sp.x = x;
			_sp.y = y;
			
			_index=index;
			
			_bg = new BitmapControl(Skins.bagGridSkin,index,false);
			_bg.setXYOffset(-4,-4);
			_sp.addChild(_bg);
			
			_iconImage = new IconImage();
//			_iconImage.x=3;
//			_iconImage.y=3;
			_sp.addChild(_iconImage);
			
			_sp.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
			_sp.addEventListener(MouseEvent.MOUSE_UP,onMouseUp);
		}
		
		public function get sp():Sprite{
			return _sp;
		}
		
		public function get item():SkillDyVo{
			return _item;
		}
		
		public function removeContent():void{
			_item = null;
			Xtip.clearTip(_iconImage);
			_iconImage.clear();
			_bg.clearFollowTargetMouse(_iconImage);
		}
		
		public function setContent(skillId:int):void{
			removeContent();
			if(skillId>0){
				_item = SkillDyManager.Instance.getSkillDyVo(skillId);
				_iconImage.url = SkillBasicManager.Instance.getURL(_item.skillId,_item.skillLevel);
				_bg.followTargetMouse(_iconImage);
				Xtip.registerLinkTip(_iconImage,SkillTip,TipUtil.skillTipInitFunc,_item.skillId,_item.skillLevel,true);
			}
		}
		
		private function onMouseDown(e:MouseEvent):void{
			if(_item){
				var dragData:DragData = new DragData();
				dragData.type = DragData.FROM_AUTO;
				dragData.data = new Object();
				dragData.data.id = _item.skillId;
				DragManager.Instance.startDrag(_iconImage,dragData);
				UI.stage.addEventListener(MouseEvent.MOUSE_UP,onStageMouseUp);
			}
		}
		
		private function onStageMouseUp(e:MouseEvent):void{
			UI.stage.removeEventListener(MouseEvent.MOUSE_UP,onStageMouseUp);
			var arr:Array = LayerManager.WindowLayer.getObjectsUnderPoint(new Point(StageProxy.Instance.stage.mouseX,StageProxy.Instance.stage.mouseY));
			var view:DisplayObject;
			for each(view in arr){
				if(view is AutoWindow)	return;
			}
			if(!_sp.getRect(_sp).contains(_sp.mouseX,_sp.mouseY)){
				removeContent();
			}
		}
		
		private function onMouseUp(e:MouseEvent):void{
			var fromData:DragData = DragManager.Instance.dragVo as DragData;
			if(fromData){
				if(fromData.type==DragData.From_Skill_Grid || fromData.type==DragData.From_QuickBox_SKill || fromData.type==DragData.FROM_AUTO){
					_iconImage.clear();
					_bg.clearFollowTargetMouse(_iconImage);
					_item = SkillDyManager.Instance.getSkillDyVo(fromData.data.id);
					_iconImage.url = SkillBasicManager.Instance.getURL(_item.skillId,_item.skillLevel);
					Xtip.registerLinkTip(_iconImage,SkillTip,TipUtil.skillTipInitFunc,_item.skillId,_item.skillLevel,true);
					_bg.followTargetMouse(_iconImage);
					YFEventCenter.Instance.dispatchEventWith(AutoEvent.ADD_SKILL,{vo:_item,index:_index});
				}
			}
		}
		
	}
} 