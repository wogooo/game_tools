package com.YFFramework.game.core.module.system.view
{
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.ui.abs.AbsView;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.core.module.system.data.SystemConfigManager;
	import com.YFFramework.game.core.module.system.event.SystemEvent;
	import com.YFFramework.game.ui.sound.GlobalSoundControl;
	import com.YFFramework.game.ui.sound.SoundBgManager;
	import com.dolo.ui.controls.Button;
	import com.dolo.ui.controls.CheckBox;
	import com.dolo.ui.controls.Slider;
	import com.dolo.ui.tools.AutoBuild;
	import com.dolo.ui.tools.Xdis;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * @author jina;
	 * @version 1.0.0
	 * creation time：2013-7-18 上午10:01:48
	 */
	public class SettingPanel extends AbsView
	{
		//======================================================================
		//       public property
		//======================================================================
		
		//======================================================================
		//       private property
		//======================================================================
		private const CHECK_BOX_MAX:int=12;
		
		private var _ui:Sprite;
		
		/** 1隐藏所有特效
		 */		
		private var shieldEffBtn:CheckBox;
		/** 2隐藏所有血条
		 */		
		private var shieldHpBtn:CheckBox;
		/** 3隐藏其他玩家
		 */		
		private var shieldOtherHeroBtn:CheckBox;
		/** 4隐藏玩家宠物
		 */		
		private var shieldOtherPetBtn:CheckBox;
		/** 5不选中宠物
		 */		
		private var notSelectPetBtn:CheckBox;
		/** 6显示装备对比
		 */		
		private var showCompareBtn:CheckBox;
		/** 7显示玩家称号
		 */		
		private var showOtherTitle:CheckBox;
		/** 8拒绝切磋请求
		 */		
		private var rejectPkBtn:CheckBox;
		/** 9拒绝交易请求
		 */		
		private var rejectTradeBtn:CheckBox;
		/** 10拒绝组队请求
		 */
		private var rejectTeamBtn:CheckBox;
		/** 11拒绝好友请求
		 */		
		private var rejectFriendBtn:CheckBox;
		/** 12拒绝所有私聊
		 */		
		private var rejectTalkBtn:CheckBox;
		/** 13拒绝公会请求
		 */		
		private var rejectGuildBtn:CheckBox;
		/** 14显示所有掉落物名称
		 */		
		private var showAllItemNamebtn:CheckBox;
		/** 开启背景音乐
		 */		
		private var _bgmCheckBtn:CheckBox;
		private var _bgmSlider:Slider;
		/** 开启游戏音效 
		 */		
		private var _soundCheckBtn:CheckBox;
		private var _soundSlider:Slider;
		
		private var _saveBtn:Button;
		private var _resetBtn:Button;
		//======================================================================
		//        constructor
		//======================================================================
		
		public function SettingPanel(ui:Sprite)
		{
			_ui=ui;
			AutoBuild.replaceAll(_ui);
			
			shieldEffBtn=Xdis.getChild(_ui,"close1_checkBox");
			shieldHpBtn=Xdis.getChild(_ui,"close2_checkBox");
			shieldOtherHeroBtn=Xdis.getChild(_ui,"close3_checkBox");
			shieldOtherPetBtn=Xdis.getChild(_ui,"close4_checkBox");
			notSelectPetBtn=Xdis.getChild(_ui,"close5_checkBox");
			showCompareBtn=Xdis.getChild(_ui,"close6_checkBox");
			showOtherTitle=Xdis.getChild(_ui,"close7_checkBox");
			rejectPkBtn=Xdis.getChild(_ui,"close8_checkBox");
			rejectTradeBtn=Xdis.getChild(_ui,"close9_checkBox");
			rejectTeamBtn=Xdis.getChild(_ui,"close10_checkBox");
			rejectFriendBtn=Xdis.getChild(_ui,"close11_checkBox");
			rejectTalkBtn=Xdis.getChild(_ui,"close12_checkBox");
			rejectGuildBtn=Xdis.getChild(_ui,"close13_checkBox");
			showAllItemNamebtn=Xdis.getChild(_ui,"close14_checkBox");

			_bgmCheckBtn=Xdis.getChildAndAddClickEvent(bgmOnClick,_ui,"bgm_checkBox");
			_soundCheckBtn=Xdis.getChildAndAddClickEvent(soundOnClick,_ui,"sound_checkBox");
			_saveBtn=Xdis.getChildAndAddClickEvent(onSaveClick,_ui,"save_button");
			_resetBtn=Xdis.getChildAndAddClickEvent(onResetClick,_ui,"reset_button");
			
			_bgmSlider=Xdis.getChild(_ui,"bgm_slider");
			_soundSlider=Xdis.getChild(_ui,"sound_slider");
			
			_bgmSlider.addEventListener(Event.CHANGE,bgmChange);
			_soundSlider.addEventListener(Event.CHANGE,soundChange);
			
			shieldEffBtn.textField.width=83;
			shieldHpBtn.textField.width=83;
			shieldOtherHeroBtn.textField.width=83;
			shieldOtherPetBtn.textField.width=83;
			notSelectPetBtn.textField.width=83;
			showCompareBtn.textField.width=83;
			showOtherTitle.textField.width=83;
			rejectPkBtn.textField.width=83;
			rejectTradeBtn.textField.width=83;
			rejectTeamBtn.textField.width=83;
			rejectFriendBtn.textField.width=83;
			rejectTalkBtn.textField.width=83;
			rejectGuildBtn.textField.width=83;
			showAllItemNamebtn.textField.width=122;
			
			_bgmCheckBtn.textField.width=83;
			_soundCheckBtn.textField.width=83;
			
		}
		
		//======================================================================
		//        public function
		//======================================================================
		/**
		 * 更新各checkBox的选中状态 
		 */		
		public function updateCheckBoxState():void
		{
			shieldEffBtn.selected=SystemConfigManager.shieldEff;
			shieldHpBtn.selected=SystemConfigManager.shieldHp;
			shieldOtherHeroBtn.selected=SystemConfigManager.shieldOtherHero;
			shieldOtherPetBtn.selected=SystemConfigManager.shieldOtherPet;
			notSelectPetBtn.selected=SystemConfigManager.notSelectPet;
			showCompareBtn.selected=SystemConfigManager.showCompare;
			showOtherTitle.selected=SystemConfigManager.showTitle;
			rejectPkBtn.selected=SystemConfigManager.rejectPK;
			rejectTradeBtn.selected=SystemConfigManager.rejectTrade;
			rejectTalkBtn.selected=SystemConfigManager.rejectTalk;
			rejectFriendBtn.selected=SystemConfigManager.rejectFriend;
			rejectTeamBtn.selected=SystemConfigManager.rejectTeam;
			rejectGuildBtn.selected=SystemConfigManager.rejectGuild;
			showAllItemNamebtn.selected=SystemConfigManager.showAllItemName;
			
			_bgmSlider.value=SystemConfigManager.BGMValue;
			_bgmCheckBtn.selected=SystemConfigManager.enableBGM;
			_bgmSlider.enabled=SystemConfigManager.enableBGM;
			
			if(_bgmCheckBtn.selected == false)
				GlobalSoundControl.getInstance().mute();
			else
				GlobalSoundControl.getInstance().volume=_bgmSlider.value/100;
			
			_soundCheckBtn.selected=SystemConfigManager.enableSound;
			_soundSlider.enabled=SystemConfigManager.enableSound;
			_soundSlider.value=SystemConfigManager.soundValue;
		}
		//======================================================================
		//        private function
		//======================================================================
		/** 恢复默认值 
		 */		
		private  function reset():void
		{
			shieldEffBtn.selected=false;
			shieldHpBtn.selected=true;
			shieldOtherHeroBtn.selected=false;
			shieldOtherPetBtn.selected=false;
			notSelectPetBtn.selected=false;
			showCompareBtn.selected=true;
			showOtherTitle.selected=true;
			rejectPkBtn.selected=false;
			rejectTradeBtn.selected=false;
			rejectTalkBtn.selected=false;
			rejectFriendBtn.selected=false;
			rejectTeamBtn.selected=false;
			rejectGuildBtn.selected=false;
			showAllItemNamebtn.selected=true;
			_bgmCheckBtn.selected=true;
			_soundCheckBtn.selected=true;
			_bgmSlider.value=50;
			_soundSlider.value=50;
		}
		
		private function saveSetting():void
		{
			SystemConfigManager.shieldEff=shieldEffBtn.selected;
			SystemConfigManager.shieldHp=shieldHpBtn.selected;
			SystemConfigManager.shieldOtherHero=shieldOtherHeroBtn.selected;
			SystemConfigManager.shieldOtherPet=shieldOtherPetBtn.selected;
			SystemConfigManager.notSelectPet=notSelectPetBtn.selected;

			SystemConfigManager.rejectFriend=rejectFriendBtn.selected;
			SystemConfigManager.rejectGuild=rejectGuildBtn.selected;
			SystemConfigManager.rejectPK=rejectPkBtn.selected;
			SystemConfigManager.rejectTalk=rejectTalkBtn.selected;
			SystemConfigManager.rejectTeam=rejectTeamBtn.selected;
			SystemConfigManager.rejectTrade=rejectTradeBtn.selected;
			
			SystemConfigManager.showCompare=showCompareBtn.selected;
			SystemConfigManager.soundValue=_soundSlider.value;
			SystemConfigManager.showTitle=showOtherTitle.selected;
			SystemConfigManager.showAllItemName=showAllItemNamebtn.selected;
			
			SystemConfigManager.BGMValue=_bgmSlider.value;
			SystemConfigManager.enableBGM=_bgmCheckBtn.selected;
			
			SystemConfigManager.enableSound=_soundCheckBtn.selected;
			
			//如果上一个状态是静音，下个状态是取消静音，才继续播放
			if(SystemConfigManager.enableBGM == false)
				GlobalSoundControl.getInstance().mute();
			else
				GlobalSoundControl.getInstance().unMute();
		}

		//======================================================================
		//        event handler
		//======================================================================
		/** 是否启用背景音乐
		 * @param e
		 */		
		private function bgmOnClick(e:MouseEvent):void
		{
			_bgmSlider.enabled=_bgmCheckBtn.selected;
		}
		
		/** 是否启用音效
		 * @param e
		 */		
		private function soundOnClick(e:MouseEvent):void
		{
			_soundSlider.enabled=_soundCheckBtn.selected;
		}
		
		private function onSaveClick(e:MouseEvent):void
		{
			saveSetting();
			YFEventCenter.Instance.dispatchEventWith(SystemEvent.Save);
			YFEventCenter.Instance.dispatchEventWith(GlobalEvent.BGMControl);
		}
		
		private function onResetClick(e:MouseEvent):void
		{
			reset();
			saveSetting();
			YFEventCenter.Instance.dispatchEventWith(SystemEvent.Save);
			
		}
		
		private function bgmChange(e:Event):void
		{
			GlobalSoundControl.getInstance().volume=(_bgmSlider.value)/100;
		}
		
		private function soundChange(e:Event):void
		{
			
		}
		//======================================================================
		//        getter&setter
		//======================================================================
		
		
	}
} 