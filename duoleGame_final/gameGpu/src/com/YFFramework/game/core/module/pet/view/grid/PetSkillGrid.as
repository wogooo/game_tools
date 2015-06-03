package com.YFFramework.game.core.module.pet.view.grid
{
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.net.loader.image_swf.IconLoader;
	import com.YFFramework.core.utils.common.ClassInstance;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.core.global.manager.SkillBasicManager;
	import com.YFFramework.game.core.global.view.tips.SkillTip;
	import com.YFFramework.game.core.global.view.tips.TipUtil;
	import com.YFFramework.game.core.module.pet.events.PetEvent;
	import com.dolo.ui.controls.BitmapControl;
	import com.dolo.ui.skin.Skins;
	import com.dolo.ui.tools.Xtip;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	/**
	 * @version 1.0.0
	 * creation time：2013-8-20 上午10:08:34
	 */
	public class PetSkillGrid{
		
		private var _skillId:int;
		private var _skillLv:int;
		private var _index:int;
		private var _lock:Boolean;
		private var _sp:Sprite;
		private var _bg:BitmapControl;
		private var _selectable:Boolean;
		private var _seleted:Boolean=false;
		private var _deselectable:Boolean;
		
		public function PetSkillGrid(index:int,lock:Boolean,selectable:Boolean,sp:Sprite,skillId:int=0,skillLv:int=0,deselectable:Boolean=false)
		{
			_sp = sp;	
			_index = index;
			_lock = lock;
			_deselectable = deselectable;
			if(_lock){
				var lockImg:MovieClip = ClassInstance.getInstance("petSkillGrid");
				lockImg.x=1;
//				lockImg.y=-3;
				_sp.addChild(lockImg);
			}else{
				if(skillId>0){
					IconLoader.initLoader(SkillBasicManager.Instance.getURL(skillId,skillLv),_sp);
					_skillId = skillId;
					_skillLv = skillLv;
					Xtip.registerLinkTip(_sp,SkillTip,TipUtil.skillTipInitFunc,_skillId,_skillLv);
				}
				_bg = new BitmapControl(Skins.bagGridSkin,index,true);
				_bg.setXYOffset(-4,-4);
//				_bg.x=-1;
//				_bg.y=-1;
				_sp.addChildAt(_bg,0);
			}
			_selectable = selectable;
			_sp.addEventListener(MouseEvent.CLICK,onClick);
		}
		
		public function dispose():void{
			while(_sp.numChildren>0){
				_sp.removeChildAt(0);
			}
			if(_bg)	_bg.dispose();
			_sp.removeEventListener(MouseEvent.CLICK,onClick);
			_sp=null;
		}
		
		public function setSelect(value:Boolean):void{
			if(_bg)	_bg.select=value;
			_seleted=value;
		}
		
		public function getSelected():Boolean{
			return _seleted;
		}
		
		public function getMC():Sprite{
			return _sp;
		}
		
		public function getIndex():int{
			return _index;
		}
		
		public function getSkillId():int{
			return _skillId;
		}
		
		public function getSkillLv():int{
			return _skillLv;
		}
		
		public function removeListener():void{
			if(_sp.hasEventListener(MouseEvent.CLICK))	_sp.removeEventListener(MouseEvent.CLICK,onClick);
		}
		
		private function onClick(e:MouseEvent):void{
			if(_deselectable){
				if(_seleted==true){
					setSelect(false);
				}else{
					setSelect(true);
				}
				YFEventCenter.Instance.dispatchEventWith(PetEvent.Select_Inherit_Skill,this);
			}
			else if(!_selectable){
				setSelect(false);
			}else{
				if(_lock==true)	YFEventCenter.Instance.dispatchEventWith(GlobalEvent.OPEN_PET_PANEL,2);
				else	YFEventCenter.Instance.dispatchEventWith(PetEvent.Select_Skill,this);
			}
		}
	}
} 