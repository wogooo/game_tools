package com.YFFramework.game.core.module.DivinePulses.view
{
	import com.CMD.GameCmd;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.game.core.global.DataCenter;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.core.global.manager.CharacterDyManager;
	import com.YFFramework.game.core.global.manager.PropsBasicManager;
	import com.YFFramework.game.core.global.manager.PropsDyManager;
	import com.YFFramework.game.core.global.model.PropsBasicVo;
	import com.YFFramework.game.core.global.util.NoticeUtil;
	import com.YFFramework.game.core.global.view.tips.PropsTip;
	import com.YFFramework.game.core.global.view.tips.TipUtil;
	import com.YFFramework.game.core.module.DivinePulses.manager.DivinePulseManager;
	import com.YFFramework.game.core.module.DivinePulses.manager.Divine_pulseBasicManager;
	import com.YFFramework.game.core.module.DivinePulses.model.Divine_pulseBasicVo;
	import com.YFFramework.game.core.module.DivinePulses.model.TypePulse;
	import com.YFFramework.game.core.module.feed.model.FeedID;
	import com.YFFramework.game.core.module.notice.manager.NoticeManager;
	import com.YFFramework.game.core.module.notice.model.NoticeType;
	import com.YFFramework.game.core.module.skill.mamanger.SkillDyManager;
	import com.YFFramework.game.gameConfig.URLTool;
	import com.dolo.lang.LangBasic;
	import com.dolo.ui.controls.Button;
	import com.dolo.ui.controls.IconImage;
	import com.dolo.ui.tools.HTMLFormat;
	import com.dolo.ui.tools.Xdis;
	import com.dolo.ui.tools.Xtip;
	import com.msg.divine_pulse_pro.CDivinePulseReq;
	import com.net.MsgPool;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	/***
	 *神脉右侧详细信息
	 *@author ludingchang 时间：2013-11-13 上午10:01:09
	 */
	public class PulseInfo
	{
		private static const PULSE_NUM:int=TypePulse.NUMBER_SUB_PULSES;//10个支脉
		
		private static const COLOR_NORMAL:uint=0xffce12;//正常情况下
		private static const COLOR_WARNING:uint=0xff1c5c;//数量不够时，红色
		private static const COLOR_GREEN:uint=0x8cf213;//绿色
		private static const COLOR_WHILTE:uint=0xf3fbfa;//白色
		
		private var _ui:Sprite;
		/**中间主脉*/
		private var _big_pulse:IconImage;
		/**10个支脉**/
		private var _pulses:Vector.<SubPulseIconView>;
		/**需求的道具图标*/
		private var _daoju_icon:IconImage;
		/**需求的道具的名字*/
		private var _daoju_name:TextField;
		/**需求的道具的数量*/
		private var _daoju_num:TextField;
		/**需求条件*/
		private var _needs:Array;
		/**冥想按钮*/
		private var _learn_btn:Button;
		private var _group:PulseGroup;
		/**效果描述*/
		private var _eff:TextField;
		private var _name_lv:TextField;

		private var _selectedVo:Divine_pulseBasicVo,_nextVo:Divine_pulseBasicVo,_currentVo:Divine_pulseBasicVo;
		
		public function PulseInfo(ui:Sprite)
		{
			_ui=ui;
			_group=new PulseGroup;
			var temp:Sprite;
			_big_pulse=Xdis.getChild(ui,"big_pulse_iconImage");
			_pulses=new Vector.<SubPulseIconView>;
			for(var i:int=1;i<=PULSE_NUM;i++)
			{
				temp=Xdis.getSpriteChild(ui,"pulse"+i);
				var pulse:SubPulseIconView=new SubPulseIconView(temp);
				_pulses.push(pulse);
				_group.add(pulse);
			}
			_eff=Xdis.getTextChild(ui,"eff");
			_name_lv=Xdis.getTextChild(ui,"pulse_name_txt");
			_daoju_icon=Xdis.getChild(ui,"daoju_iconImage");
			_daoju_name=Xdis.getTextChild(ui,"daoju_name");
			_daoju_num=Xdis.getTextChild(ui,"daoju_num");
			_needs=new Array;
			for(var k:int=1;k<=4;k++)
			{
				var need:TextField=Xdis.getTextChild(ui,"need"+k);
				_needs.push(need);
			}
			_learn_btn=Xdis.getChildAndAddClickEvent(onClick,ui,"learn_button");
		}
		
		private function onClick(e:MouseEvent):void
		{
			// TODO 学习
			var selected:int=_group.selected;
			var vo:Divine_pulseBasicVo=_pulses[selected]._basicVo;
			var nextVo:Divine_pulseBasicVo=DivinePulseManager.Instence.getNextLearnVo(vo.element,vo.pos);
			if(nextVo)
			{
				var isLv:Boolean=DataCenter.Instance.roleSelfVo.roleDyVo.level>=nextVo.limit_lv;
				if(!isLv)
				{
					NoticeManager.setNotice(NoticeType.Notice_id_2101);
					return;
				}
				var isSee:Boolean=CharacterDyManager.Instance.yueli>=nextVo.see;
				if(!isSee)
				{
					NoticeManager.setNotice(NoticeType.Notice_id_2102);
					return;
				}
				var isNote:Boolean=DataCenter.Instance.roleSelfVo.note>=nextVo.note;
				if(!isNote)
				{
					NoticeManager.setNotice(NoticeType.Notice_id_2103);
					return;
				}
				var isDiamond:Boolean=DataCenter.Instance.roleSelfVo.diamond>=nextVo.diamond;
				if(!isDiamond)
				{
					NoticeManager.setNotice(NoticeType.Notice_id_2104);
					return;
				}
				if(nextVo.daoju_id!=0)
				{
					var count:int=PropsDyManager.instance.getPropsQuantity(nextVo.daoju_id);
					if(count<nextVo.daoju_num)
					{
						NoticeManager.setNotice(NoticeType.Notice_id_2105);
						return;
					}
				}
				
				var msg:CDivinePulseReq=new CDivinePulseReq;
				msg.divinePulseId=nextVo.id;
				if(nextVo.daoju_id==0)
					msg.propInfo=[];
				else
					msg.propInfo=PropsDyManager.instance.getPropsPosArray(nextVo.daoju_id,nextVo.daoju_num);
				MsgPool.sendGameMsg(GameCmd.CUpdateDivinePulseReq,msg);
			}
		}
		/**
		 *刷新 
		 */		
		public function update():void
		{
			var element:int=DivinePulseManager.Instence.left_selected;
			var subs:Vector.<Divine_pulseBasicVo>=Divine_pulseBasicManager.Instance.getDivine_pulseBasicVosByElement(element);
			for(var i:int=0;i<PULSE_NUM;i++)
			{
				_pulses[i].initData(subs[i]);
				_pulses[i].update();
			}
			_group.selected=DivinePulseManager.Instence.right_selected-1;
			var big:Divine_pulseBasicVo=Divine_pulseBasicManager.Instance.getMainPulseByElement(element);
			var big2:Divine_pulseBasicVo=DivinePulseManager.Instence.getLearnedPulse(element,big.pos);
			_big_pulse.url=URLTool.getPulseBigIcon(TypePulse.getIconIdByElement(big.element));
			if(!big2)//没有学过该神脉
			{
				_name_lv.text=big.name+" LV."+big.lv;
			}
			else//学过该神脉
			{
				if(big2.lv<TypePulse.LV_PULSES)//且神脉等级不是最高级，则这里显示的是下一级
					_name_lv.text=big.name+" LV."+(big2.lv+1);
				else
					_name_lv.text=big.name+" LV."+big2.lv;//若已经为最高级，则显示最高级
			}
			
			//取当前等级和下一等级的数据
			getCurrentVoAndNextVo();
			//更新描述
			updateDes();
			//更新学习条件
			updateNeeds();
		}
		private function getCurrentVoAndNextVo():void
		{
			var selectedIndex:int=DivinePulseManager.Instence.right_selected;
			if(selectedIndex==0)
			{
				_selectedVo=null;
				_currentVo=null;
				_nextVo=null;
				return;
			}
			_selectedVo=_pulses[selectedIndex-1]._basicVo;
			_currentVo=DivinePulseManager.Instence.getLearnedPulse(_selectedVo.element,_selectedVo.pos);
			if(!_currentVo)
				_nextVo=Divine_pulseBasicManager.Instance.getDivine_pulseBasicVo(_selectedVo.element,_selectedVo.pos,1);
			else if(_currentVo.lv<TypePulse.LV_PULSES)//不到最大等级
				_nextVo=Divine_pulseBasicManager.Instance.getDivine_pulseBasicVo(_selectedVo.element,_selectedVo.pos,_currentVo.lv+1);
			else
				_nextVo=null;
		}
		
		private function updateNeeds():void
		{
			if(_selectedVo==null)
			{
				_needs[0].text="";
				_needs[1].text="";
				_needs[2].text="";
				_needs[3].text="";
				_learn_btn.enabled=false;
				return;
			}
			if(_nextVo!=null)
			{
				var isLv:Boolean=DataCenter.Instance.roleSelfVo.roleDyVo.level>=_nextVo.limit_lv;
				setTextColor(_needs[0],LangBasic.divine_pulse_level,_nextVo.limit_lv.toString(),isLv);//等级限制
				var isSee:Boolean=CharacterDyManager.Instance.yueli>=_nextVo.see;
				setTextColor(_needs[1],LangBasic.divine_pulse_see,_nextVo.see.toString(),isSee);//阅历
				var isNote:Boolean=DataCenter.Instance.roleSelfVo.note>=_nextVo.note;
				setTextColor(_needs[2],LangBasic.divine_pulse_note,_nextVo.note.toString(),isNote);//银锭
				var isDiamond:Boolean=DataCenter.Instance.roleSelfVo.diamond>=_nextVo.diamond;
				setTextColor(_needs[3],LangBasic.divine_pulse_diamond,_nextVo.diamond.toString(),isDiamond);//魔钻
				_learn_btn.enabled=true;
				_learn_btn.label=LangBasic.divine_pulse_learn;
				if(_nextVo.daoju_id==0)
				{
					_daoju_icon.visible=false;
					_daoju_name.text="";
					_daoju_num.text="";
				}
				else
				{
					_daoju_icon.visible=true;
					var daoju:PropsBasicVo=PropsBasicManager.Instance.getPropsBasicVo(_nextVo.daoju_id);
					_daoju_icon.url=URLTool.getGoodsIcon(daoju.icon_id);
					_daoju_name.text=daoju.name;
					var count:int=PropsDyManager.instance.getPropsQuantity(_nextVo.daoju_id);
					_daoju_num.text=count+"/"+_nextVo.daoju_num;
					if(count>=_nextVo.daoju_num)
						_daoju_num.htmlText=HTMLFormat.color(count+"/"+_nextVo.daoju_num,COLOR_NORMAL);
					else
						_daoju_num.htmlText=HTMLFormat.color(count.toString(),COLOR_WARNING)+HTMLFormat.color("/"+_nextVo.daoju_num,COLOR_NORMAL);
					Xtip.registerLinkTip(_daoju_icon,PropsTip,TipUtil.propsTipInitFunc,0,daoju.template_id);
				}
			}
			else
			{
				setTextColor(_needs[0],LangBasic.divine_pulse_level,"-",true);
				setTextColor(_needs[1],LangBasic.divine_pulse_see,"-",true);
				setTextColor(_needs[2],LangBasic.divine_pulse_note,"-",true);
				setTextColor(_needs[3],LangBasic.divine_pulse_diamond,"-",true);
				_daoju_icon.visible=false;
				_daoju_name.text="";
				_daoju_num.text="";
				_learn_btn.enabled=false;
				_learn_btn.label=LangBasic.divine_pulse_max_level;
			}
			
		}
		
		private function setTextColor(text:TextField,des:String,value:String,b:Boolean):void
		{
			var msg:String=HTMLFormat.color(des,0xfff0b6);
			if(b)
				msg+=HTMLFormat.color(value,COLOR_NORMAL);
			else
				msg+=HTMLFormat.color(value,COLOR_WARNING);
			text.htmlText=msg;
		}
		
		private function getNextHtml(value:int):String
		{
			return HTMLFormat.color("(",COLOR_GREEN)+HTMLFormat.color(value.toString(),COLOR_WHILTE)+HTMLFormat.color(")",COLOR_GREEN);
		}
		
		private function updateDes():void
		{
			if(_currentVo==null)
			{
				setDesText(_nextVo,null);//当前vo为空表示还没与学过该支脉，所以只显示第一级支脉的属性
			}
			else
			{
				setDesText(_currentVo,_nextVo);
			}
		}
		
		
		private function setDesText(current:Divine_pulseBasicVo,next:Divine_pulseBasicVo):void
		{
			var msg:String="";
			
			if(current.hp>0)
			{
				msg+="<br>"+HTMLFormat.color(LangBasic.divine_pulse_hp+current.hp,COLOR_GREEN);//HP
				if(next)
					msg+=getNextHtml(next.hp);
			}
			
			if(current.mp>0)
			{
				msg+=("<br>"+HTMLFormat.color(LangBasic.divine_pulse_mp+current.mp,COLOR_GREEN));//MP
				if(next)
					msg+=getNextHtml(next.mp);
			}
			
			if(current.phy_atk>0)
			{
				msg+=("<br>"+HTMLFormat.color(LangBasic.divine_pulse_physics_attack+current.phy_atk,COLOR_GREEN));//物攻
				if(next)
					msg+=getNextHtml(next.phy_atk);
			}
			
			if(current.magic_atk>0)
			{
				msg+=("<br>"+HTMLFormat.color(LangBasic.divine_pulse_magic_attack+current.magic_atk,COLOR_GREEN));//法攻
				if(next)
					msg+=getNextHtml(next.magic_atk);
			}
			
			if(current.phy_dfs>0)
			{
				msg+=("<br>"+HTMLFormat.color(LangBasic.divine_pulse_physics_defance+current.phy_dfs,COLOR_GREEN));//物防
				if(next)
					msg+=getNextHtml(next.phy_dfs);
			}
			
			if(current.magic_dfs>0)
			{
				msg+=("<br>"+HTMLFormat.color(LangBasic.divine_pulse_magic_defance+current.magic_dfs,COLOR_GREEN));//法防
				if(next)
					msg+=getNextHtml(next.magic_dfs);
			}
			
			if(current.crit_rating>0)
			{
				msg+=("<br>"+HTMLFormat.color(LangBasic.divine_pulse_crit+current.crit_rating,COLOR_GREEN));//暴击
				if(next)
					msg+=getNextHtml(next.crit_rating);
			}
			
			if(current.avoid_rating>0)
			{
				msg+=("<br>"+HTMLFormat.color(LangBasic.divine_pulse_avoid+current.avoid_rating,COLOR_GREEN));//闪避
				if(next)
					msg+=getNextHtml(next.avoid_rating);
			}
			
			if(current.hit_rating>0)
			{
				msg+=("<br>"+HTMLFormat.color(LangBasic.divine_pulse_hit+current.hit_rating,COLOR_GREEN));//命中
				if(next)
					msg+=getNextHtml(next.hit_rating);
			}
			
			if(current.tenacity_rating>0)
			{
				msg+=("<br>"+HTMLFormat.color(LangBasic.divine_pulse_tenacity+current.tenacity_rating,COLOR_GREEN));//韧性
				if(next)
					msg+=getNextHtml(next.tenacity_rating);
			}
			
			if(current.phy_pierce>0)
			{
				msg+=("<br>"+HTMLFormat.color(LangBasic.divine_pulse_physics_pierce+current.phy_pierce,COLOR_GREEN));//物理穿透
				if(next)
					msg+=getNextHtml(next.phy_pierce);
			}
			
			if(current.magic_pierce>0)
			{
				msg+=("<br>"+HTMLFormat.color(LangBasic.divine_pulse_magic_pierce+current.magic_pierce,COLOR_GREEN));//魔法穿透
				if(next)
					msg+=getNextHtml(next.magic_pierce);
			}
			
			msg+=("<br>"+HTMLFormat.color(current.des,COLOR_GREEN));
			
			_eff.htmlText=msg.substr(4);//去掉第一个换行
		}
		
		
	}
}