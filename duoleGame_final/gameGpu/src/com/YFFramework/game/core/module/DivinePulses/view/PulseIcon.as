package com.YFFramework.game.core.module.DivinePulses.view
{
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.game.core.module.DivinePulses.event.DivinePulseEvent;
	import com.YFFramework.game.core.module.DivinePulses.manager.DivinePulseManager;
	import com.YFFramework.game.core.module.DivinePulses.manager.Divine_pulseBasicManager;
	import com.YFFramework.game.core.module.DivinePulses.model.Divine_pulseBasicVo;
	import com.YFFramework.game.core.module.DivinePulses.model.TypePulse;
	import com.YFFramework.game.gameConfig.URLTool;
	import com.dolo.ui.controls.BitmapControl;
	import com.dolo.ui.controls.IconImage;
	import com.dolo.ui.skin.Skins;
	import com.dolo.ui.tools.Xdis;
	import com.dolo.ui.tools.Xtip;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	/***
	 *神脉图标控制（主脉）
	 *@author ludingchang 时间：2013-11-13 上午9:40:06
	 */
	public class PulseIcon
	{
		private var _ui:Sprite;
		private var _icon:IconImage;
		private var _txt:TextField;
		public var _basicVo:Divine_pulseBasicVo;
		private var _bg:BitmapControl;
		public function PulseIcon(ui:Sprite)
		{
			_ui=ui;
			_icon=Xdis.getChild(ui,"icon_iconImage");
			_txt=Xdis.getTextChild(ui,"lv_txt");
			
			_icon.mouseEnabled=false;
			_icon.mouseChildren=false;
			
			_bg=new BitmapControl(Skins.bagGridSkin);
			_bg.addEventListener(MouseEvent.CLICK,onClick);
			ui.addChildAt(_bg,1);
			_bg.x=3;
			_bg.y=3;
			_bg.setXYOffset(-4.5,-4.5);
		}
		
		protected function onClick(event:MouseEvent):void
		{
			var selected_element:int=DivinePulseManager.Instence.left_selected;
			if(selected_element!=_basicVo.element)
			{
				DivinePulseManager.Instence.left_selected=_basicVo.element;
				DivinePulseManager.Instence.updateCurrentSelected();
			}
			YFEventCenter.Instance.dispatchEventWith(DivinePulseEvent.DivinePulseUpdate);
		}
		public function initData(data:Divine_pulseBasicVo):void
		{
			_basicVo=data;
		}
		public function update():void
		{
			//设置等级，注册tips
			var vo:Divine_pulseBasicVo=DivinePulseManager.Instence.getLearnedPulse(_basicVo.element,_basicVo.pos);
			if(!vo)//如果未学习
			{
				vo=Divine_pulseBasicManager.Instance.getDivine_pulseBasicVo(_basicVo.element,_basicVo.pos,1);
			}
			else//如果学习了
			{
				if(vo.lv<TypePulse.LV_PULSES)//主脉且等级没有到最高级
				{
					vo=Divine_pulseBasicManager.Instance.getDivine_pulseBasicVo(vo.element,vo.pos,vo.lv+1);
				}
			}
			if(vo)
				_txt.text="LV."+vo.lv;
			_icon.url=URLTool.getPulseBigIcon(TypePulse.getIconIdByElement(_basicVo.element));
		}
		
		public function set select(b:Boolean):void
		{
			_bg.select=b;
		}
		public function get select():Boolean
		{
			return _bg.select;
		}
	}
}