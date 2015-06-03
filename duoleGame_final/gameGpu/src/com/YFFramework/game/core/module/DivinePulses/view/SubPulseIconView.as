package com.YFFramework.game.core.module.DivinePulses.view
{
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.game.core.module.DivinePulses.event.DivinePulseEvent;
	import com.YFFramework.game.core.module.DivinePulses.manager.DivinePulseManager;
	import com.YFFramework.game.core.module.DivinePulses.manager.Divine_pulseBasicManager;
	import com.YFFramework.game.core.module.DivinePulses.model.Divine_pulseBasicVo;
	import com.YFFramework.game.core.module.DivinePulses.model.TypePulse;
	import com.YFFramework.game.gameConfig.URLTool;
	import com.dolo.lang.LangBasic;
	import com.dolo.ui.controls.IconImage;
	import com.dolo.ui.controls.ToggleButton;
	import com.dolo.ui.managers.UI;
	import com.dolo.ui.tools.Xdis;
	import com.dolo.ui.tools.Xtip;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	/***
	 *支脉图标
	 *@author ludingchang 时间：2013-11-27 下午3:32:53
	 */
	public class SubPulseIconView
	{
		public var _basicVo:Divine_pulseBasicVo;
		private var _ui:Sprite;
		private var _icon:IconImage;
		private var _selected:Boolean;
		private var _select_eff:MovieClip;
		public function SubPulseIconView(ui:Sprite)
		{
			_ui=ui;
			_icon=Xdis.getChild(ui,"icon_iconImage");
			_select_eff=Xdis.getChild(ui,"eff");
			_select_eff.mouseEnabled=false;
		}
		public function initData(data:Divine_pulseBasicVo):void
		{
			_basicVo=data;
			_icon.url=URLTool.getPulseIcon(_basicVo.icon_id);
		}
		public function update():void
		{
			//设置等级，注册tips
			var vo:Divine_pulseBasicVo=DivinePulseManager.Instence.getLearnedPulse(_basicVo.element,_basicVo.pos);
			var next:Divine_pulseBasicVo;
			if(!vo)//如果未学习
			{
				UI.setEnable(_icon,false,false);
				vo=Divine_pulseBasicManager.Instance.getDivine_pulseBasicVo(_basicVo.element,_basicVo.pos,1);
				next=vo;
			}
			else//如果学习了
			{
				UI.setEnable(_icon,true,false);
				if(vo.lv==TypePulse.LV_PULSES)//已经是最高等级
					next=vo;
				else
					next=Divine_pulseBasicManager.Instance.getDivine_pulseBasicVo(_basicVo.element,_basicVo.pos,vo.lv+1);
			}
			Xtip.registerTip(_icon,getDes(next));//注册TIPS
		}
		private function getDes(vo:Divine_pulseBasicVo):String
		{
			var msg:String=vo.des;
			if(vo.hp>0)
				msg+=("\n"+LangBasic.divine_pulse_hp+vo.hp);
			if(vo.mp>0)
				msg+=("\n"+LangBasic.divine_pulse_mp+vo.mp);
			if(vo.phy_atk>0)
				msg+=("\n"+LangBasic.divine_pulse_physics_attack+vo.phy_atk);
			if(vo.phy_dfs>0)
				msg+=("\n"+LangBasic.divine_pulse_physics_defance+vo.phy_dfs);
			if(vo.magic_atk>0)
				msg+=("\n"+LangBasic.divine_pulse_magic_attack+vo.magic_atk);
			if(vo.magic_dfs>0)
				msg+=("\n"+LangBasic.divine_pulse_magic_defance+vo.magic_dfs);
			if(vo.crit_rating>0)
				msg+=("\n"+LangBasic.divine_pulse_crit+vo.crit_rating);
			if(vo.avoid_rating>0)
				msg+=("\n"+LangBasic.divine_pulse_avoid+vo.avoid_rating);
			if(vo.hit_rating>0)
				msg+=("\n"+LangBasic.divine_pulse_hit+vo.hit_rating);
			if(vo.tenacity_rating>0)
				msg+=("\n"+LangBasic.divine_pulse_tenacity+vo.tenacity_rating);
			if(vo.phy_pierce>0)
				msg+=("\n"+LangBasic.divine_pulse_physics_pierce+vo.phy_pierce);
			if(vo.magic_pierce>0)
				msg+=("\n"+LangBasic.divine_pulse_magic_pierce+vo.magic_pierce);
			return msg;
		}
		public function get select():Boolean
		{
			return _selected;
		}
		public function set select(b:Boolean):void
		{
			_selected=b;
			_select_eff.visible=b;
		}
	}
}