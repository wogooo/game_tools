package com.YFFramework.game.core.module.rank.view
{
	/**
	 * @author jina;
	 * @version 1.0.0
	 * creation time：2013-11-13 下午5:35:59
	 */
	import com.YFFramework.core.ui.abs.AbsView;
	import com.YFFramework.game.core.global.DataCenter;
	import com.YFFramework.game.core.global.manager.DyModuleUIManager;
	import com.YFFramework.game.core.global.manager.EquipBasicManager;
	import com.YFFramework.game.core.global.manager.EquipDyManager;
	import com.YFFramework.game.core.global.model.EquipDyVo;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.global.view.player.SimplePlayer;
	import com.YFFramework.game.core.module.character.model.TitleBasicManager;
	import com.YFFramework.game.core.module.character.view.simpleView.BodyEquipView;
	import com.YFFramework.game.core.module.mapScence.world.model.type.TypeRole;
	import com.YFFramework.game.core.module.rank.data.OtherHeroDyVo;
	import com.YFFramework.game.ui.imageText.ImageTextManager;
	import com.YFFramework.game.ui.imageText.TypeImageText;
	import com.dolo.ui.controls.Window;
	import com.dolo.ui.managers.UI;
	import com.dolo.ui.tools.Xdis;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class RankRoleInfoWindow extends Window
	{
		//======================================================================
		//       public property
		//======================================================================
		
		//======================================================================
		//       private property
		//======================================================================
		private static var _instance:RankRoleInfoWindow;
		
		private var _mc:MovieClip;
		private var _avatarSp:Sprite;
		private var _avatar:SimplePlayer;
		private var _grids:Vector.<BodyEquipView>;
		private var _numSp:Sprite;
		private var _stars:Array;
		//======================================================================
		//        constructor
		//======================================================================
		
		public function RankRoleInfoWindow(backgroundBgId:int=0)
		{
			_mc=initByArgument(365,550,"rankShowCharacter",'',true,DyModuleUIManager.rankRoleBg) as MovieClip;
			setContentXY(30,35);
			tittleBgUI.visible=false;
			
			_grids=new Vector.<BodyEquipView>(12);
			for(var i:int=1;i<12;i++)
			{
				if(i == 10)
					continue;
				_grids[i]=new BodyEquipView(i,Xdis.getChild(_mc,"t"+i));
				_mc['mc'+i].addChild(_grids[i]);
			}
			
			_avatarSp=Xdis.getChild(_mc,"avatar");
			_avatar=new SimplePlayer();
			_avatar.mouseChildren=false;
			_avatar.mouseEnabled=false;
			_avatarSp.addChild(_avatar);	
			
			_numSp=Xdis.getChild(_mc,"numSp");
			
			_stars=[];
			for(i=0;i<3;i++)
			{
				_stars.push(Xdis.getChild(_mc,'star'+(i+1)));
			}
		}
		
		override public function close(event:Event=null):void
		{
			super.close(event);
			_avatar.stop();
		}
		//======================================================================
		//        public function
		//======================================================================
		public function updateCharacter(info:OtherHeroDyVo,isRank:Boolean=false):RankRoleInfoWindow
		{	
			///名称
			Object(_mc).txtName.text=info.name;
			//称号
			if(info.title_id > 0)
				Object(_mc).titleTxt.text=TitleBasicManager.Instance.getTitleBasicVo(info.title_id).name;
			else
				Object(_mc).titleTxt.text='';
			///职业 
			Object(_mc).careerTxt.text=TypeRole.getCareerName(info.career);
			//等级
			Object(_mc).levelTxt.text=info.level.toString();
			///公会
			Object(_mc).guildTxt.text=info.guildName;
			
			for(var i:int=1;i<12;i++)
			{
				if(i == 10)
					continue;
				_grids[i].disposeContent();
			}
			for each(var equipDyVo:EquipDyVo in info.equips)
			{
				var type:int=EquipBasicManager.Instance.getEquipBasicVo(equipDyVo.template_id).type;
				_grids[type].setContent(equipDyVo,true);
			}
			
			//人物模型
			_avatar=new SimplePlayer();
			UI.removeAllChilds(_avatarSp);
			_avatarSp.addChild(_avatar);
			_avatar.mouseEnabled=false;
			
			var sex:int=info.sex;
			var carrer:int=info.career;
			var cloth:EquipDyVo=getEquipInfoByPos(TypeProps.EQUIP_TYPE_CLOTHES,info.equips);
			var wings:EquipDyVo=getEquipInfoByPos(TypeProps.EQUIP_TYPE_WINGS,info.equips);
			var weapon:EquipDyVo=getEquipInfoByPos(TypeProps.EQUIP_TYPE_WEAPON,info.equips);
			if(cloth)
			{
				_avatar.updateClothId(cloth.template_id,sex,carrer,cloth.enhance_level);
			}
			else
			{
				_avatar.initDefaultCloth(sex,carrer);
			}
			if(wings)
			{
				_avatar.updateWingId(wings.template_id,sex);
			}
			else _avatar.updateWingId(-1,0);
			if(weapon)
			{
				_avatar.updateWeaponId(weapon.template_id,sex,carrer,weapon.enhance_level);
			}
			else _avatar.updateWeaponId(-1,0,carrer,-1);
			_avatar.start();
			_avatar.playDefault();
			
			var num:AbsView=ImageTextManager.Instance.createNum(info.power.toString(),TypeImageText.Num_power);
			UI.removeAllChilds(_numSp);
			_numSp.addChild(num);
			
			var starNum:int=EquipDyManager.instance.getTotalStrengthenAddition(info.equips);
			for(i=0;i<3;i++)//先把三颗星星灭掉
			{
				MovieClip(_stars[i]).visible=false;
			}
			for(i=0;i<starNum;i++)//再把星星依次亮起
			{
				MovieClip(_stars[i]).visible=true;
			}
			
			return this;
		}
		//======================================================================
		//        private function
		//======================================================================
		private function getEquipInfoByPos(targetType:int,equips:Array):EquipDyVo
		{
			for each(var equipDyVo:EquipDyVo in equips)
			{
				var type:int=EquipBasicManager.Instance.getEquipBasicVo(equipDyVo.template_id).type;
				if(type == targetType)
				{
					return equipDyVo;
				}
			}
			return null;
		}
		//======================================================================
		//        event handler
		//======================================================================
		
		//======================================================================
		//        getter&setter
		//======================================================================
		
		
		public static function get instance():RankRoleInfoWindow
		{
			if(_instance==null) _instance=new RankRoleInfoWindow();
			return _instance;
		}

	}
} 