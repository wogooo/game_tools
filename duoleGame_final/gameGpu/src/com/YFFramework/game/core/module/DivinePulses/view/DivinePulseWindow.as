package com.YFFramework.game.core.module.DivinePulses.view
{
	import com.YFFramework.core.text.HTMLUtil;
	import com.YFFramework.game.core.global.manager.DyModuleUIManager;
	import com.YFFramework.game.core.global.view.window.WindowTittleName;
	import com.YFFramework.game.core.module.DivinePulses.manager.DivinePulseManager;
	import com.YFFramework.game.core.module.DivinePulses.manager.Divine_pulseBasicManager;
	import com.YFFramework.game.core.module.DivinePulses.model.Divine_pulseBasicVo;
	import com.YFFramework.game.core.module.DivinePulses.model.TypePulse;
	import com.YFFramework.game.core.module.guild.manager.GuildBackgroundManager;
	import com.YFFramework.game.gameConfig.URLTool;
	import com.dolo.lang.LangBasic;
	import com.dolo.ui.controls.Window;
	import com.dolo.ui.tools.HTMLFormat;
	import com.dolo.ui.tools.Xdis;
	
	import flash.display.Sprite;
	import flash.text.TextField;
	
	/***
	 *天命神脉 窗口
	 *@author ludingchang 时间：2013-11-12 上午11:58:56
	 */
	public class DivinePulseWindow extends Window
	{
		private static const PulseNum:int=7;//5+2个主神脉
		private static const UIName:String="DivinePulse";
		private var _sp:Sprite;
		private var _pulses:Vector.<PulseIcon>;
		private var _txts1:Array;
		private var _txts2:Array;
		private var _group:PulseGroup;
		private var _pulseInfo:PulseInfo;
		private var _bg:Sprite;
		public function DivinePulseWindow()
		{
			_sp=initByArgument(717,576,UIName,WindowTittleName.titleDivinePulse,true,DyModuleUIManager.guildMarketWinBg);
			setContentXY(25,27);
			_pulses=new Vector.<PulseIcon>;
			_group=new PulseGroup;
			var elements:Vector.<Divine_pulseBasicVo>=Divine_pulseBasicManager.Instance.getAllElementsVo();
			for(var i:int=0;i<PulseNum;i++)
			{
				var item:Sprite=Xdis.getSpriteChild(_sp,"item"+(i+1));
				var icon:PulseIcon=new PulseIcon(item);
				_pulses.push(icon);
				icon.initData(elements[i]);
				_group.add(icon);
			}
			
			_txts1=new Array;
			_txts2=new Array;
			for(var j:int=1;j<=6;j++)
			{
				var txt1:TextField=Xdis.getTextChild(_sp,"txt"+j);
				var txt2:TextField=Xdis.getTextChild(_sp,"txt2"+j);
				_txts1.push(txt1);
				_txts2.push(txt2);
			}
			
			var info:Sprite=Xdis.getChild(_sp,"right");
			_pulseInfo=new PulseInfo(info);
			
			_bg=new Sprite;
			_sp.addChildAt(_bg,0);
		}
		
		override public function update():void
		{
			if(!isOpen)
				return;
			_group.selected=DivinePulseManager.Instence.left_selected-1;
			var i:int,len:int=_pulses.length;
			for(i=0;i<len;i++)
			{
				_pulses[i].update();//跟新图标
			}
			
			_pulseInfo.update();
			//更新下面属性加成
			var total:Divine_pulseBasicVo=DivinePulseManager.Instence.getTotalBuff();
			setText(_txts1[0],LangBasic.divine_pulse_hp,total.hp);
			setText(_txts1[1],LangBasic.divine_pulse_mp,total.mp);
			setText(_txts1[2],LangBasic.divine_pulse_physics_attack,total.phy_atk);
			setText(_txts1[3],LangBasic.divine_pulse_magic_attack,total.magic_atk);
			setText(_txts1[4],LangBasic.divine_pulse_physics_defance,total.phy_dfs);
			setText(_txts1[5],LangBasic.divine_pulse_magic_defance,total.magic_dfs);
			
			setText(_txts2[0],LangBasic.divine_pulse_crit,total.crit_rating);
			setText(_txts2[1],LangBasic.divine_pulse_avoid,total.avoid_rating);
			setText(_txts2[2],LangBasic.divine_pulse_hit,total.hit_rating);
			setText(_txts2[3],LangBasic.divine_pulse_tenacity,total.tenacity_rating);
			setText(_txts2[4],LangBasic.divine_pulse_physics_pierce,total.phy_pierce);
			setText(_txts2[5],LangBasic.divine_pulse_magic_pierce,total.magic_pierce);
		}
		override public function open():void
		{
			checkBackground();
			super.open();
			update();
		}
		private function setText(txt:TextField,des:String,value:int):void
		{
			var msg:String=HTMLFormat.color(des,0xfff0b6);
			msg+=HTMLFormat.color("+"+value,0xf3fbfa);
			txt.htmlText=msg;
		}
		private function checkBackground():void
		{
			if(_bg.numChildren==0)
			{
				GuildBackgroundManager.Instence.loadBG(DyModuleUIManager.divinePulseBg,_bg);
			}
		}
	}
}