package com.YFFramework.game.core.module.skill.view
{
	/**@author yefeng
	 * 2013 2013-7-23 下午3:33:04 
	 */
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.proxy.StageProxy;
	import com.YFFramework.core.utils.HashMap;
	import com.YFFramework.core.utils.common.ClassInstance;
	import com.YFFramework.game.core.global.DataCenter;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.core.global.manager.CharacterDyManager;
	import com.YFFramework.game.core.global.manager.DyModuleUIManager;
	import com.YFFramework.game.core.global.manager.SkillBasicManager;
	import com.YFFramework.game.core.global.model.SkillBasicVo;
	import com.YFFramework.game.core.global.model.TypeSkill;
	import com.YFFramework.game.core.global.util.DragManager;
	import com.YFFramework.game.core.global.util.UIPositionUtil;
	import com.YFFramework.game.core.module.gameView.view.EjectBtnView;
	import com.YFFramework.game.core.module.mapScence.world.model.RoleDyVo;
	import com.YFFramework.game.core.module.newGuide.manager.NewGuideDrawHoleUtil;
	import com.YFFramework.game.core.module.newGuide.manager.NewGuideManager;
	import com.YFFramework.game.core.module.newGuide.model.NewGuideStep;
	import com.YFFramework.game.core.module.newGuide.view.NewGuideMovieClipWidthArrow;
	import com.YFFramework.game.core.module.notice.manager.NoticeManager;
	import com.YFFramework.game.core.module.notice.model.NoticeType;
	import com.YFFramework.game.core.module.skill.events.SkillEvent;
	import com.YFFramework.game.core.module.skill.mamanger.SkillDyManager;
	import com.YFFramework.game.core.module.skill.model.AutoPutSkillVo;
	import com.YFFramework.game.core.module.skill.model.DragData;
	import com.YFFramework.game.core.module.skill.model.SetQuikBoxVo;
	import com.YFFramework.game.core.module.skill.model.SkillCareerTreePositon;
	import com.YFFramework.game.core.module.skill.model.SkillDyVo;
	import com.YFFramework.game.core.module.skill.model.SkillModuleType;
	import com.YFFramework.game.ui.layer.LayerManager;
	import com.dolo.ui.controls.Button;
	import com.dolo.ui.controls.Window;
	import com.dolo.ui.tools.SimpleBuild;
	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;
	
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.utils.Dictionary;
	
	/**   技能面板UI 
	 */	
	public class SkillNewWindow extends Window
	{
		private var _mc:MovieClip;
		/**存储技能格子 UI
		 */		
		private var _skillCareerDict:Dictionary;
		/**技能学习按钮
		 */		
		private var _learnBtn:Button;
		/**学习MC 
		 */		
		private var _learnItMC:MovieClip;
		/** 等级到达上线后 要显示的文本 TextFiled  技能等级已达上限
		 */		
		private var _finnishLearnTxt:TextField;
		/**要学习的技能
		 */		
		private var _selectSkillBasicVo:SkillBasicVo;
		/**技能快捷方式UI
		 */		
		public var skillQuickPane:SkillQuickPane;
		/**是否被打开过 
		 */		
		private var _isOpened:Boolean=false;
		private var _closeBtn:SimpleButton;
		
		/**自动将技能拉到快捷栏的字典工具
		 */
		private var _skillAutoDict:Dictionary;
		public function SkillNewWindow()
		{
			super(NoneBg);
			_mc=ClassInstance.getInstance("new_skillUI");
			bgUrl=DyModuleUIManager.skillWinBg;
			content=_mc;
			_learnItMC=_mc.skillPanel_1.learnIt;
			_finnishLearnTxt=_mc.skillPanel_1.finishLearn;
			_finnishLearnTxt.selectable=false;
			_finnishLearnTxt.visible=false;
			_learnBtn=SimpleBuild.replaceButton(_mc.skillPanel_1.learnIt,"learn_button");

			setSize(881,660);
			_closeBtn=_mc.close_button;
			_closeBtn.addEventListener(MouseEvent.CLICK,close);
//			_closeBtn.x = _compoWidth - 60;
//			_closeBtn.y=12;
			_skillCareerDict=new Dictionary();
			initCareerSkillUI();
			clearSkillInfo();
			skillQuickPane=new SkillQuickPane();
			addEvents();
			_closeButton.visible=false;
			_dragArea.addChild(_closeBtn);
			_skillAutoDict=new Dictionary();
		}
		private function addEvents():void
		{
			//学习技能
			_learnBtn.addEventListener(MouseEvent.CLICK,onLearnClick); 
		}
		private function onLearnClick(e:MouseEvent):void
		{
			if(_selectSkillBasicVo)//如果有选中的技能
			{
				if (CharacterDyManager.Instance.yueli<_selectSkillBasicVo.see_consume)//阅历>=需求的阅历
				{
					NoticeManager.setNotice(NoticeType.Notice_id_2102);
					return;
				}
				if(DataCenter.Instance.roleSelfVo.roleDyVo.level<_selectSkillBasicVo.character_level)//等级>=需求的等级
				{
					NoticeManager.setNotice(NoticeType.Notice_id_2101);
					return;
				}
				if(DataCenter.Instance.roleSelfVo.note<_selectSkillBasicVo.note_consume)//钱 
				{
					NoticeManager.setNotice(NoticeType.Notice_id_2103);
					return;
				}
				YFEventCenter.Instance.dispatchEventWith(SkillEvent.C_LearnSkill,_selectSkillBasicVo.skill_id);
			}
			
			
			
			if(NewGuideStep.SkillGuideStep==NewGuideStep.SkillGuideCloseWindow)
			{
				NewGuideManager.DoGuide();
			}
			
		}
		/**初始化职业技能的UI
		 */		
		private function initCareerSkillUI():void
		{
			  // 0 是选中的技能格子
			var len:int=SkillCareerTreePositon.Len;
			var skillCellView:SkillCellView;
			var name:String;
			var mc:MovieClip;
			for(var i:int=0;i<=len;++i)
			{
				name="skill_"+i;  ///  UI界面上 的命名规则是 skill_1  skill_2  ... skill_10
				mc=_mc.skillPanel_1.getChildByName(name) as MovieClip;  
				skillCellView=new SkillCellView(mc.canUp_icon);  //将其丢进 icon_iconImage
				mc.icon_iconImage.addChild(skillCellView);
				_skillCareerDict[name]=skillCellView;
//				skillCellView.container=mc;
				if(i>0)
				{
					//加上事件侦听
					mc.addEventListener(MouseEvent.MOUSE_DOWN,onSkillIconDown);
				}
			}
			_skillCareerDict["skill_0"].hideLvTxt();
		}
		
		/**单击技能图标  进行技能图标拖动
		 */
		private function onSkillIconDown(e:MouseEvent):void
		{
			var target:MovieClip=e.currentTarget as MovieClip;
			var name:String=target.name;
			var skillCellView:SkillCellView=_skillCareerDict[name];
			if(skillCellView.skillId!=-1)
			{
				updateSkillDesInfo(skillCellView.skillId);
				var skillDyVo:SkillDyVo=SkillDyManager.Instance.getSkillDyVo(skillCellView.skillId);
				if(skillDyVo)  //该技能存在 则表示其可以进行拖拽
				{
					var skillBasicVo:SkillBasicVo=SkillBasicManager.Instance.getSkillBasicVo(skillDyVo.skillId,skillDyVo.skillLevel);
					if(skillBasicVo.use_type!=TypeSkill.UseType_Passive)  // 不为 被动技能时s
					{
						var dragData:DragData=new DragData();
						dragData.data={};
						dragData.type=DragData.From_Skill_Grid;
						dragData.data.id=skillCellView.skillId;
						DragManager.Instance.startDrag(skillCellView,dragData);
					}
				}
			}
		}
		/**自动将技能拖到快捷栏
		 */		
		public function updateAutoPullSkill(skillId:int):void
		{
			if(isOpen&&_skillAutoDict[skillId]==null) //如果窗口打开
			{
				var skillDyVo:SkillDyVo=SkillDyManager.Instance.getSkillDyVo(skillId);
				var skillBasicVo:SkillBasicVo=SkillBasicManager.Instance.getSkillBasicVo(skillDyVo.skillId,skillDyVo.skillLevel);
				if(skillBasicVo.use_type!=TypeSkill.UseType_Passive)  //不是 被动 技能 
				{
					var name:String="skill_"+skillBasicVo.list_pos;
					var skillCellView:SkillCellView=_skillCareerDict[name];
					//获取其在舞台上的坐标
					var fromPt:Point=LayerManager.getWindowLayePos(skillCellView); //其实技能位置 
					var autoPutSkillVo:AutoPutSkillVo=skillQuickPane.getAvailableQuickBox();
					if(autoPutSkillVo)
					{
						var setQuickBoxVo:SetQuikBoxVo=new SetQuikBoxVo();
						setQuickBoxVo.fromKeyId=-1;
						setQuickBoxVo.target_key_id=autoPutSkillVo.key_id;
						setQuickBoxVo.boxType=SkillModuleType.QuickType_BT_SKILL;
						setQuickBoxVo.boxId=skillId;
						var bitmap:Bitmap=skillCellView.getLightBitmap();//获取图标
						bitmap.x=fromPt.x;
						bitmap.y=fromPt.y;
						LayerManager.DisableLayer.addChild(bitmap);
						TweenLite.to(bitmap,1,{x:autoPutSkillVo.x,y:autoPutSkillVo.y,ease:Cubic.easeOut,onComplete:onMoveIconEnd,onCompleteParams:[bitmap,setQuickBoxVo]});
						_skillAutoDict[skillId]=1;
					}
				}
			}
		}
		/**设置快捷方式
		 */		
		private function onMoveIconEnd(bitmap:Bitmap,setQuickBoxVo:SetQuikBoxVo):void
		{
			if(LayerManager.DisableLayer.contains(bitmap))
			{
				LayerManager.DisableLayer.removeChild(bitmap);
			}
			bitmap.bitmapData.dispose();
			YFEventCenter.Instance.dispatchEventWith(SkillEvent.C_SetQuickBox,setQuickBoxVo);
		}
		/**单击技能图标后更新描述信息
		 * skillBasicVo  该技能对应的 vo 
		 *  isLearn 该 技能是否学习
		 */
		private function updateSkillDesInfo(skillId:int):void
		{
			var skillDyVo:SkillDyVo=SkillDyManager.Instance.getSkillDyVo(skillId);
			var skillBasicVo:SkillBasicVo;
			if(!skillDyVo)  //没有学习   进行技能学习
			{
				skillBasicVo=SkillBasicManager.Instance.getSkillBasicVo(skillId,1);
				fillSkillInfo(skillBasicVo,skillBasicVo);
				_learnBtn.label="学习";
			}
			else//已经学习了  进行下一等级的 升级学习
			{
				skillBasicVo=SkillBasicManager.Instance.getSkillBasicVo(skillId,skillDyVo.skillLevel);
				var nextlevel:int=skillBasicVo.skill_level+1; //下一等级
				var mySkillBasicVo:SkillBasicVo=SkillBasicManager.Instance.getSkillBasicVo(skillBasicVo.skill_id,nextlevel);
				if(mySkillBasicVo) //如果下一等级存在
				{
					fillSkillInfo(skillBasicVo,mySkillBasicVo);
					_learnBtn.label="升级";
				}
				else //下一等级不存在  则表示该等级已经到达上线了
				{
					
					fillSkillInfo(skillBasicVo,null);
					_learnBtn.label="升级";
				}
			}
		}
		/**
		 * @param currentskillBasicVo 当前  技能等级的vo 
		 * @param nextSkillBasicVo    下一技能等级的vo 
		 * 
		 */		
		private function  fillSkillInfo(currentskillBasicVo:SkillBasicVo,nextSkillBasicVo:SkillBasicVo):void
		{
			_mc.skillPanel_1.skill_name.text=currentskillBasicVo.name;			//名称
			_mc.skillPanel_1.skill_level.text="Lv."+currentskillBasicVo.skill_level;	//等级
			_mc.skillPanel_1.atkLen.text=currentskillBasicVo.use_distance+"";		//攻击距离
			// skill_0 图标
			var skillCellView:SkillCellView=_skillCareerDict["skill_0"];
			
			skillCellView.url=SkillBasicManager.Instance.getURL(currentskillBasicVo.skill_id,1);
			if(currentskillBasicVo.consume_type==SkillModuleType.Consume_MP)	//魔法消耗 
			{
				_mc.skillPanel_1.mpConsume.text=currentskillBasicVo.consume_value;	
			}
			else 
			{
				_mc.skillPanel_1.mpConsume.text="0";	
			}
			_mc.skillPanel_1.cdTimetxt.text=currentskillBasicVo.cooldown_time/1000+"秒";	//CD时间
			_mc.skillPanel_1.skillDesTxt.text=currentskillBasicVo.effect_desc;		//技能描述
			//下一等级
			if(nextSkillBasicVo)
			{
				var level:int=nextSkillBasicVo.character_level;
				var see_consum:int=nextSkillBasicVo.see_consume;
				var note_consum:int=nextSkillBasicVo.note_consume;
				var roleDyVo:RoleDyVo=DataCenter.Instance.roleSelfVo.roleDyVo;
				setTxt(_learnItMC.learnSkillLevel,level,roleDyVo.level);//人物学习等级
				setTxt(_learnItMC.yueliConsume,see_consum,CharacterDyManager.Instance.yueli);//	消耗阅历
				setTxt(_learnItMC.moneyConsume,note_consum,DataCenter.Instance.roleSelfVo.note);//消耗银锭	
				
				if(nextSkillBasicVo.character_level>roleDyVo.level)
				{
					_learnBtn.enabled=false;
				}
				else 
				{
					_learnBtn.enabled=true;
				}
				_learnItMC.visible=true;
				_finnishLearnTxt.visible=false
			}
			else 
			{
				_learnItMC.visible=false;
				_finnishLearnTxt.visible=true;
				_learnBtn.enabled=false;
			}
			_selectSkillBasicVo=nextSkillBasicVo;
		}
		
		/**
		 *设置文本框内容，更具是否满足自动改变颜色 
		 * @param txt：文本框
		 * @param need：需要的值
		 * @param current：当前的值
		 * 
		 */		
		private function setTxt(txt:TextField,need:int,current:int):void
		{
			txt.text=need.toString();
			if(current>=need)
			{
				txt.textColor=0xffffff;
			}
			else
			{
				txt.textColor=0xff0000;
			}
		}
		
		/** 清除技能描述
		 */		
		private function clearSkillInfo():void
		{
			_mc.skillPanel_1.skill_name.text="";			//名称
			_mc.skillPanel_1.skill_level.text="";	//等级
			_mc.skillPanel_1.atkLen.text="";		//攻击距离
			_mc.skillPanel_1.mpConsume.text="";	
			_mc.skillPanel_1.cdTimetxt.text="";	//CD时间
			_mc.skillPanel_1.skillDesTxt.text="";		//技能描述
			
			_learnItMC.learnSkillLevel.text="";  //人物学习等级
			_learnItMC.yueliConsume.text="";	//	消耗阅历	
			_learnItMC.moneyConsume.text="";	//消耗银币	
		}
		override public function open():void
		{
			super.open();
			_isOpened=true;
			setSelectNextSkill();
			YFEventCenter.Instance.dispatchEventWith(GlobalEvent.RemoveEjectBtn,EjectBtnView.newSkill);//打开技能界面时就把技图标移除
		}
		
		/**初始化职业技能UI 
		 */		
		public function updateCareerSkillUI():void
		{
			if(_isOpened)
			{
				var career:int=DataCenter.Instance.roleSelfVo.roleDyVo.career;
				var  hashMap:HashMap=SkillBasicManager.Instance.getSkillList(career);
				var arr:Array=hashMap.values();
				////初始化所有的UI
				var skillCellView:SkillCellView;
				var skillDyVo:SkillDyVo;
				var mySkillBasicVo:SkillBasicVo;
				for each(var skillBasicVo:SkillBasicVo in arr)
				{
					if(skillBasicVo.list_pos>0&&skillBasicVo.skill_big_category==TypeSkill.BigCategory_Career)
					{
						skillCellView=_skillCareerDict["skill_"+skillBasicVo.list_pos];
						if(skillCellView)
						{
							if(skillCellView.skillId==-1)  //如果没有点亮
							{
								skillCellView.skillId=skillBasicVo.skill_id;
								skillCellView.url=SkillBasicManager.Instance.getURL(skillCellView.skillId,1);
							}
							skillCellView.updateView();
						}
					}
				}
				///更新选中的
				if(_selectSkillBasicVo)
				{
					updateSkillDesInfo(_selectSkillBasicVo.skill_id);
				}
				else // 选中第一个 
				{
					skillCellView=_skillCareerDict["skill_1"];// 第一个技能UI
					if(skillCellView.skillId!=-1)	updateSkillDesInfo(skillCellView.skillId);
					else _learnBtn.enabled=false;
				}
			}
		}
		
		/**刷新技能学习区描述*/
		public function updateLearnInfo():void
		{
			if(_selectSkillBasicVo&&isOpen)
				updateSkillDesInfo(_selectSkillBasicVo.skill_id);
		}
		
		/**重置所有技能 
		 */		
		public function updateResetAlSkill():void
		{
			for each(var skillCellView:SkillCellView in _skillCareerDict)
			{
				skillCellView.skillId=-1;
			}
			_skillAutoDict=new Dictionary();
		}
		/**选中下一个可升级的技能图标*/
		public function setSelectNextSkill():void
		{
			var pos:int=1;
			if(_selectSkillBasicVo)
				pos=_selectSkillBasicVo.list_pos;
			var nextSkillVo:SkillBasicVo=SkillDyManager.Instance.findNextCanLearnSkill(pos);
			if(nextSkillVo)
			{
				_selectSkillBasicVo=nextSkillVo;
				var name:String="skill_"+nextSkillVo.list_pos;
				var skillCellView:SkillCellView=_skillCareerDict[name];
				skillCellView.setSelected();
			}
		}
		override public function close(event:Event=null):void
		{
			closeTo(StageProxy.Instance.getWidth()-400,StageProxy.Instance.getHeight()-100);
			
			handleSkillNewGuideHideGuide();
		}
		
		
		
		
		
		/** 引导学习按钮
		 */
		private function handleRectStudyBtn():Boolean
		{
			if(NewGuideStep.SkillGuideStep==NewGuideStep.SkillGuideRectStudyBtn) //引导 技能学习按钮
			{
//				var pt:Point=UIPositionUtil.getPosition(_learnBtn,_mc);
//				NewGuideMovieClipWidthArrow.Instance.initRect(pt.x,pt.y,_learnBtn.width,_learnBtn.height,NewGuideMovieClipWidthArrow.ArrowDirection_Left);
//				NewGuideMovieClipWidthArrow.Instance.addToContainer(_mc);
				var pt:Point=UIPositionUtil.getUIRootPosition(_learnBtn);
				NewGuideDrawHoleUtil.drawHoleByNewGuideMovieClipWidthArrow(pt.x,pt.y,_learnBtn.width,_learnBtn.height,NewGuideMovieClipWidthArrow.ArrowDirection_Left,_learnBtn);
				NewGuideStep.SkillGuideStep=NewGuideStep.SkillGuideCloseWindow
				return true;
			}
			return false;
		}
		
		 
		/**引导关闭窗口
		 */
		private function handleMountNewGuideCloseWindow():Boolean
		{
			if(NewGuideStep.SkillGuideStep==NewGuideStep.SkillGuideCloseWindow)
			{
//				var pt:Point=UIPositionUtil.getPosition(_closeBtn,this);
//				NewGuideMovieClipWidthArrow.Instance.initRect(pt.x,pt.y,_closeBtn.width,_closeBtn.height,NewGuideMovieClipWidthArrow.ArrowDirection_Left);
//				NewGuideMovieClipWidthArrow.Instance.addToContainer(this);
				
				var pt:Point=UIPositionUtil.getUIRootPosition(_closeBtn);
				NewGuideDrawHoleUtil.drawHoleByNewGuideMovieClipWidthArrow(pt.x,pt.y,_closeBtn.width,_closeBtn.height,NewGuideMovieClipWidthArrow.ArrowDirection_Left,_closeBtn);
				NewGuideStep.SkillGuideStep=NewGuideStep.SkillGuideNone;
				return true;
			}
			return false;
		}

		/**隐藏引导箭头  关闭按钮时候触发
		 */ 
		private function handleSkillNewGuideHideGuide():Boolean
		{
			if(NewGuideStep.SkillGuideStep==NewGuideStep.SkillGuideNone)
			{
				NewGuideMovieClipWidthArrow.Instance.hide();
				NewGuideStep.SkillGuideStep=-1;
				NewGuideManager.DoGuide();
				return true;
			}
			return false;
		}
		
		
		override public function getNewGuideVo():*
		{
			var trigger:Boolean=false;
			
			trigger=handleRectStudyBtn();
			if(!trigger)
			{
				trigger=handleMountNewGuideCloseWindow();
			}
			if(!trigger)
			{
				trigger=handleSkillNewGuideHideGuide();
			}
			return trigger;
		}
		
	}
}