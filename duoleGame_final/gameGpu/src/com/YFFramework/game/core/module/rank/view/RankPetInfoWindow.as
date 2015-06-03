package com.YFFramework.game.core.module.rank.view
{
	/**
	 * @author jina;
	 * @version 1.0.0
	 * creation time：2013-11-13 下午4:51:30
	 */
	import com.YFFramework.core.event.ParamEvent;
	import com.YFFramework.core.ui.movie.AvatarShow;
	import com.YFFramework.core.ui.movie.data.ActionData;
	import com.YFFramework.core.ui.movie.data.TypeAction;
	import com.YFFramework.core.ui.movie.data.TypeDirection;
	import com.YFFramework.core.ui.yf2d.data.YF2dActionData;
	import com.YFFramework.core.utils.common.ClassInstance;
	import com.YFFramework.core.utils.net.SourceCache;
	import com.YFFramework.game.core.global.manager.PetBasicManager;
	import com.YFFramework.game.core.global.model.PetBasicVo;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.module.notice.model.NoticeType;
	import com.YFFramework.game.core.module.notice.model.NoticeUtils;
	import com.YFFramework.game.core.module.pet.model.PetDyVo;
	import com.YFFramework.game.core.module.rank.data.RankDyVo;
	import com.YFFramework.game.gameConfig.URLTool;
	import com.dolo.ui.controls.IconImage;
	import com.dolo.ui.controls.Window;
	import com.dolo.ui.managers.UI;
	import com.dolo.ui.tools.Xdis;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class RankPetInfoWindow extends Window
	{
		//======================================================================
		//       public property
		//======================================================================
		
		//======================================================================
		//       private property
		//======================================================================
		private static var _instance:RankPetInfoWindow;
		
		private var _mc:MovieClip;
		private var _avatar:AvatarShow;
		private var _petDyVo:PetDyVo;
		private var _skills:Vector.<OtherPetSkillGrid>;
		//======================================================================
		//        constructor
		//======================================================================
		
		public function RankPetInfoWindow(backgroundBgId:int=0)
		{
			_mc=initByArgument(365,550,"rankShowPet") as MovieClip;
			tittleBgUI.visible=false;
			
			_avatar=new AvatarShow();
			
			_skills=new Vector.<OtherPetSkillGrid>();
			var skill:OtherPetSkillGrid;
			var str:String;
			var icon:IconImage;
			for(var i:int=0;i<8;i++)
			{
				str="i"+i+"_iconImage";
				icon=Xdis.getChild(_mc,str);
				skill=new OtherPetSkillGrid(icon);
				_skills.push(skill);
			}
		}
		
		override public function close(e:Event=null):void
		{
			super.close(e);
			_avatar.stop();
		}
		//======================================================================
		//        public function
		//======================================================================
		public function updatePetInfo(petDyVo:PetDyVo):RankPetInfoWindow
		{	
			_petDyVo=petDyVo;
			var petConfigVo:PetBasicVo = PetBasicManager.Instance.getPetConfigVo(petDyVo.basicId);
			
			Object(_mc).petTypeTxt.text = NoticeUtils.getStr(NoticeType.Notice_id_100053)+petConfigVo.pet_type_name;
			Object(_mc).petLvTxt.text = "Lv： "+petDyVo.level;
			Object(_mc).attTxt.text = NoticeUtils.getStr(NoticeType.Notice_id_100054)+int(petDyVo.fightAttrs[TypeProps.EA_PHYSIC_ATK]);
			Object(_mc).magicTxt.text = NoticeUtils.getStr(NoticeType.Notice_id_100055)+int(petDyVo.fightAttrs[TypeProps.EA_MAGIC_ATK]);
			Object(_mc).defTxt.text = NoticeUtils.getStr(NoticeType.Notice_id_100056)+int(petDyVo.fightAttrs[TypeProps.EA_PHYSIC_DEFENSE]);
			Object(_mc).magicDefTxt.text = NoticeUtils.getStr(NoticeType.Notice_id_100057)+int(petDyVo.fightAttrs[TypeProps.EA_MAGIC_DEFENSE]);
						
			UI.removeAllChilds(_mc.avatarImg);
			_mc.avatarImg.addChild(_avatar);
			_mc.avatarImg.mouseChildren=false;
			_mc.avatarImg.mouseEnabled=false;
			
			var url:String=URLTool.getPetView(PetBasicManager.Instance.getPetConfigVo(petDyVo.basicId).model_id);
			var actionData:ActionData=SourceCache.Instance.getRes2(url) as ActionData;
			if(actionData){
				_avatar.initData(actionData);
				_avatar.start();
				_avatar.play(TypeAction.Stand,TypeDirection.Down,true,null,null,true);
			}
			else{
				addEventListener(url,loaded); //加载
				SourceCache.Instance.loadRes(url,null,SourceCache.ExistAllScene,null,{dispatcher:this});
			}
			
			//宠物技能
			var skills:Array=_petDyVo.skillAttrs;
			var skillsLen:int=skills.length;
			for(var i:int=0;i<skillsLen;i++)
			{
				if(skills[i].skillId == _petDyVo.defaultSkillId)
				{
					skills.splice(i);
					break;
				}
			}
			
			for(i=0;i<8;i++)
			{
				_skills[i].clearSkill();
				if(skills[i])
					_skills[i].updateSkill(skills[i]);
			}
			
			return this;
		}

		private function loaded(e:ParamEvent):void{
			var url:String=e.type;
			this.removeEventListener(url,loaded);
			if(_petDyVo==null)	return;
			var selectUrl:String=URLTool.getPetView(PetBasicManager.Instance.getPetConfigVo(_petDyVo.basicId).model_id);
			var actionData:ActionData=SourceCache.Instance.getRes2(selectUrl) as ActionData;
			//播放选中的宠物
			if(actionData){
				_avatar.initData(actionData);
				_avatar.start();
				_avatar.play(TypeAction.Stand,TypeDirection.Down,true,null,null,true);
			}
		}
		//======================================================================
		//        event handler
		//======================================================================
		
		//======================================================================
		//        getter&setter
		//======================================================================	
		public static function get instance():RankPetInfoWindow
		{
			if(_instance==null) _instance=new RankPetInfoWindow();
			return _instance;
		}

	}
} 