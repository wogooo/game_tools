package com.YFFramework.game.core.module.skill.view
{
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.proxy.StageProxy;
	import com.YFFramework.core.ui.yfComponent.controls.YFCD;
	import com.YFFramework.game.core.global.DataCenter;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.core.global.manager.PropsBasicManager;
	import com.YFFramework.game.core.global.manager.PropsDyManager;
	import com.YFFramework.game.core.global.manager.SkillBasicManager;
	import com.YFFramework.game.core.global.model.PropsBasicVo;
	import com.YFFramework.game.core.global.model.PropsDyVo;
	import com.YFFramework.game.core.global.model.SkillBasicVo;
	import com.YFFramework.game.core.global.util.DragManager;
	import com.YFFramework.game.core.global.util.NoticeUtil;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.module.autoSetting.view.AutoWindow;
	import com.YFFramework.game.core.module.bag.data.BagStoreManager;
	import com.YFFramework.game.core.module.gameView.view.GameView;
	import com.YFFramework.game.core.module.mapScence.manager.ActionManager;
	import com.YFFramework.game.core.module.notice.manager.NoticeManager;
	import com.YFFramework.game.core.module.notice.model.NoticeType;
	import com.YFFramework.game.core.module.skill.events.SkillEvent;
	import com.YFFramework.game.core.module.skill.mamanger.QuickBoxManager;
	import com.YFFramework.game.core.module.skill.mamanger.SKillCDViewManager;
	import com.YFFramework.game.core.module.skill.mamanger.SkillDyManager;
	import com.YFFramework.game.core.module.skill.model.AutoPutSkillVo;
	import com.YFFramework.game.core.module.skill.model.DragData;
	import com.YFFramework.game.core.module.skill.model.QuickBoxDyVo;
	import com.YFFramework.game.core.module.skill.model.SetQuikBoxVo;
	import com.YFFramework.game.core.module.skill.model.SkillDyVo;
	import com.YFFramework.game.core.module.skill.model.SkillModuleType;
	import com.YFFramework.game.ui.layer.LayerManager;
	import com.dolo.ui.tools.SimpleBuild;
	import com.msg.hero.CUseItem;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;

	/**  技能快捷栏设置
	 * @author yefeng
	 * 2013 2013-7-24 下午3:19:12 
	 */
	public class SkillQuickPane
	{
		/**技能格 横向个数
		 */		
		public static const TotalColumn:int=10;
		/**技能格 纵向个数
		 */		
		public static const TotalRow:int=2;
		private var _mc:MovieClip;
		/**存储快捷栏  UI    索引 和 key_id 一一对应
		 */		
		private var _quickBoxArr:Array;
		
		/** 防止快速按键
		 */		
		private var _keyPressTime:Number=0;
		private var _skillBoxes:Array;

		private var _skilledQuickBoxDic:Dictionary;
		public function SkillQuickPane()
		{
			initUI();
			addEvents();
		}
		
		private function addEvents():void
		{
			_mc.addEventListener(MouseEvent.MOUSE_UP,onSkillPanelUIMouseUp);///设置为 捕获
			StageProxy.Instance.mouseUp.regFunc(onStageMouseUp);
			
			YFEventCenter.Instance.addEventListener(GlobalEvent.KeyDownNum_1,onKeyDown);
			YFEventCenter.Instance.addEventListener(GlobalEvent.KeyDownNum_2,onKeyDown);
			YFEventCenter.Instance.addEventListener(GlobalEvent.KeyDownNum_3,onKeyDown);
			YFEventCenter.Instance.addEventListener(GlobalEvent.KeyDownNum_4,onKeyDown);
			YFEventCenter.Instance.addEventListener(GlobalEvent.KeyDownNum_5,onKeyDown);
			YFEventCenter.Instance.addEventListener(GlobalEvent.KeyDownNum_6,onKeyDown);
			YFEventCenter.Instance.addEventListener(GlobalEvent.KeyDownNum_7,onKeyDown);
			YFEventCenter.Instance.addEventListener(GlobalEvent.KeyDownNum_8,onKeyDown);
			YFEventCenter.Instance.addEventListener(GlobalEvent.KeyDownNum_9,onKeyDown);
			YFEventCenter.Instance.addEventListener(GlobalEvent.KeyDownNum_0,onKeyDown);
			YFEventCenter.Instance.addEventListener(GlobalEvent.KeyDownQ,onKeyDown);
			YFEventCenter.Instance.addEventListener(GlobalEvent.KeyDownW,onKeyDown);
			YFEventCenter.Instance.addEventListener(GlobalEvent.KeyDownE,onKeyDown);
			YFEventCenter.Instance.addEventListener(GlobalEvent.KeyDownR,onKeyDown);
			YFEventCenter.Instance.addEventListener(GlobalEvent.KeyDownT,onKeyDown);
			YFEventCenter.Instance.addEventListener(GlobalEvent.KeyDownA,onKeyDown);
			YFEventCenter.Instance.addEventListener(GlobalEvent.KeyDownS,onKeyDown);
			YFEventCenter.Instance.addEventListener(GlobalEvent.KeyDownD,onKeyDown);
			YFEventCenter.Instance.addEventListener(GlobalEvent.KeyDownF,onKeyDown);
			YFEventCenter.Instance.addEventListener(GlobalEvent.KeyDownG,onKeyDown);
			
			// 播放技能CD  服务端 返回后进行播放
			YFEventCenter.Instance.addEventListener(GlobalEvent.SKillPlayCD,onSkillPlayCD);
			//服务端没有返回的时候 客户端主动播放的CD
			YFEventCenter.Instance.addEventListener(GlobalEvent.SKillSelfPlayCD,onSkillSelfPlayCD);

			
		}
		private function onSkillSelfPlayCD(e:YFEvent):void
		{
			var skillId:int=int(e.param);
			playSelfCD(skillId);;
		}
			

		
		private function onSkillPlayCD(e:YFEvent):void
		{
			var skillId:int=int(e.param);
	//		playSelfCD(skillId);
			playCommonCD(skillId);
		}
		 
		/**播放自己的CD 
		 * @param skillId 
		 */
		private function playSelfCD(skillId:int):void
		{
			var quickBoxDyVo:QuickBoxDyVo=QuickBoxManager.Instance.getQuickBoxDyVoId(SkillModuleType.QuickType_BT_SKILL,skillId);
			if(quickBoxDyVo)
			{
				var skillQuickBoxView:SkillQuickBoxView=_quickBoxArr[quickBoxDyVo.key_id-1];  //获取UI 
				var skillDyVo:SkillDyVo=SkillDyManager.Instance.getSkillDyVo(skillId);
				var skillBasicVo:SkillBasicVo=SkillBasicManager.Instance.getSkillBasicVo(skillDyVo.skillId,skillDyVo.skillLevel);
				skillQuickBoxView.playCD(skillBasicVo.getCDViewTime());
				SKillCDViewManager.Instance.addCD(skillBasicVo.skill_id,skillQuickBoxView.getCD());
			}
		}
		
		/**播放公共 CD 
		 * exceptSkill   除去的技能 该技能播放自己的技能CD， 不进行公共CD播放
		 */		
		private function playCommonCD(exceptSkill:int):void
		{
			var dict:Dictionary=SkillDyManager.Instance.getDict();
			var skillBasicVo:SkillBasicVo;
			var skillQuickBoxView:SkillQuickBoxView;
			var quickBoxDyVo:QuickBoxDyVo;
			var cd:YFCD;
			
			for each(var skillDyVo:SkillDyVo in dict)
			{  
				skillQuickBoxView=null;
				quickBoxDyVo=null;
				skillBasicVo=SkillBasicManager.Instance.getSkillBasicVo(skillDyVo.skillId,skillDyVo.skillLevel);
				quickBoxDyVo=QuickBoxManager.Instance.getQuickBoxDyVoId(SkillModuleType.QuickType_BT_SKILL,skillDyVo.skillId);
				skillBasicVo.updateCommonCD()//所有技能进行公共CD  源技能进行CD
				if(quickBoxDyVo&&exceptSkill!=skillDyVo.skillId) //
				{
					
					skillQuickBoxView=_quickBoxArr[quickBoxDyVo.key_id-1];  //获取UI 
					if(!skillBasicVo.isInCD())	skillQuickBoxView.playCD(skillBasicVo.getCommonCDViewTime());
				}
				if(skillQuickBoxView) //存储CD 备份动画
				{
					SKillCDViewManager.Instance.addCD(skillBasicVo.skill_id,skillQuickBoxView.getCD());
				}
				else  if(exceptSkill!=skillDyVo.skillId)
				{
					SKillCDViewManager.Instance.playCD(skillBasicVo);
				}
			}
		} 
		
		/**按下
		 */		 
		private function onKeyDown(e:YFEvent):void
		{
			if(getTimer()-_keyPressTime<SkillBasicVo.CommonCDTime)
			{
				return ;
			}
			else 
			{
				_keyPressTime=getTimer();
			}
			var key_id:int=0; //格子位置
			switch(e.type)
			{
				case GlobalEvent.KeyDownNum_1:
					key_id=1;
					break;
				case GlobalEvent.KeyDownNum_2:
					key_id=2;
					break;
				case GlobalEvent.KeyDownNum_3:
					key_id=3;
					break;
				case GlobalEvent.KeyDownNum_4:
					key_id=4;
					break;
				case GlobalEvent.KeyDownNum_5:
					key_id=5;
					break;
				case GlobalEvent.KeyDownNum_6:
					key_id=6;
					break;
				case GlobalEvent.KeyDownNum_7:
					key_id=7;
					break;
				case GlobalEvent.KeyDownNum_8:
					key_id=8;
					break;
				case GlobalEvent.KeyDownNum_9:
					key_id=9;
					break;
				case GlobalEvent.KeyDownNum_0:
					key_id=10;
					break;
				case GlobalEvent.KeyDownQ:
					key_id=11;
					break;
				case GlobalEvent.KeyDownW:
					key_id=12;
					break;
				case GlobalEvent.KeyDownE:
					key_id=13;
					break;
				case GlobalEvent.KeyDownR:
					key_id=14;
					break;
				case GlobalEvent.KeyDownT:
					key_id=15;
					break;
				case GlobalEvent.KeyDownA:
					key_id=16;
					break;
				case GlobalEvent.KeyDownS:
					key_id=17;
					break;
				case GlobalEvent.KeyDownD:
					key_id=18;
					break;
				case GlobalEvent.KeyDownF:
					key_id=19;
					break;
				case GlobalEvent.KeyDownG:
					key_id=20;
					break;
			}
			var quickBoxDyVo:QuickBoxDyVo=QuickBoxManager.Instance.getQuickBoxDyVoByKeyId(key_id);
			if(quickBoxDyVo)
			{
				switch(quickBoxDyVo.type)
				{
					case SkillModuleType.QuickType_BT_ITEM: //为消耗性道具
//						var propsDyVo:PropsDyVo=PropsDyManager.instance.getPropsInfo(quickBoxDyVo.id);
						var propsBasicVo:PropsBasicVo=PropsBasicManager.Instance.getPropsBasicVo(quickBoxDyVo.id);
						if(BagStoreManager.instantce.getCd(propsBasicVo.cd_type) != null)
						{
							NoticeUtil.setOperatorNotice("正在冷却中");
//							NoticeManager.setNotice(NoticeType.Notice_id_905);
							return;
						}
						if(propsBasicVo.template_id == TypeProps.PROPS_TYPE_HP_DRUG)  //加血
						{
							if(DataCenter.Instance.roleSelfVo.roleDyVo.hp == DataCenter.Instance.roleSelfVo.roleDyVo.maxHp)
							{
								NoticeUtil.setOperatorNotice("人物血量已满！");
								propsBasicVo.resetCD();
								return;
							}
						}
						else if(propsBasicVo.template_id == TypeProps.PROPS_TYPE_MP_DRUG)//蓝瓶
						{
							if(DataCenter.Instance.roleSelfVo.roleDyVo.mp == DataCenter.Instance.roleSelfVo.roleDyVo.maxMp)
							{
								NoticeUtil.setOperatorNotice("人物魔法值已满！");
								propsBasicVo.resetCD();
								return;
							}
						}
						var msg:CUseItem = new CUseItem();
						msg.itemPos = PropsDyManager.instance.getFirstPropsPos(propsBasicVo.template_id);
						YFEventCenter.Instance.dispatchEventWith(GlobalEvent.USE_ITEM,msg);
						break;
					case SkillModuleType.QuickType_BT_SKILL: //为技能
						var skillDyVo:SkillDyVo=SkillDyManager.Instance.getSkillDyVo(quickBoxDyVo.id);
						var skillBasicVo:SkillBasicVo=SkillBasicManager.Instance.getSkillBasicVo(skillDyVo.skillId,skillDyVo.skillLevel);
						var cantrigger:Boolean=false;
						if(skillBasicVo.skillCanfire())
						{
							cantrigger=SkillDyManager.Instance.canTriggerSkillByConsume(skillBasicVo,true);
//							switch(skillBasicVo.consume_type)
//							{
//								case SkillModuleType.Consume_MP:
//									if(DataCenter.Instance.roleSelfVo.roleDyVo.mp >= skillBasicVo.consume_value)
//									{
//										cantrigger=true;
//									}
//									else 
//										//									NoticeUtil.setOperatorNotice("魔法不够");
//										NoticeManager.setNotice(NoticeType.Notice_id_904);
//									break;
//								case SkillModuleType.Consume_HP:
//									if(DataCenter.Instance.roleSelfVo.roleDyVo.hp >= skillBasicVo.consume_value)
//									{
//										cantrigger=true;
//									}
//									else NoticeUtil.setOperatorNotice("血量不够");
//									break;
//								default:
//									cantrigger=true;
//									break;
//							}
						}
						else 
						{
							ActionManager.Instance.lastSkillId=skillBasicVo.skill_id;//记录将要播放 而没有播放成功的技能
								NoticeManager.setNotice(NoticeType.Notice_id_905); //技能CD 中
						}
						if(cantrigger)
						{
							YFEventCenter.Instance.dispatchEventWith(GlobalEvent.SkillTrigger,skillDyVo.skillId);
						}
						break;
				}
			}
		}
		//只做两排 技能  第三排技能不能拖上
		private function initUI():void
		{
			_skilledQuickBoxDic=new Dictionary;
			_quickBoxArr=[];
			_skillBoxes=[];
			_mc=GameView.SkillPaneUI;
			var skillbar:MovieClip;
			var iconImage:MovieClip;
			var skillQuickBox:SkillQuickBoxView;
			var key:int;
			var skillbox:Sprite;
			for(var i:int=1;i<=TotalRow;++i)
			{
				skillbar=_mc["skillbar"+i];
				for(var j:int=1;j<=TotalColumn;++j)
				{
					iconImage=skillbar["icon"+j+"_iconImage"];
					skillQuickBox=SimpleBuild.replaceToClass(skillbar,iconImage.name,SkillQuickBoxView);
					skillQuickBox.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
					skillQuickBox.addEventListener(MouseEvent.CLICK,onClick);
					key=(i-1)*TotalColumn+j-1;
					_quickBoxArr[key]=skillQuickBox;
					skillbox=skillbar["skillBox"+j];
					skillQuickBox.addEventListener(MouseEvent.ROLL_OVER,onRollOver);
					skillQuickBox.addEventListener(MouseEvent.ROLL_OUT,onRollOut);
					skillbox.visible=false;
					skillbox.mouseEnabled=false;
					skillbox.mouseChildren=false;
					_skillBoxes[key]=skillbox;
				}
			}
		}
		
		protected function onRollOut(event:MouseEvent):void
		{
			var skillQuickBox:SkillQuickBoxView=event.currentTarget as SkillQuickBoxView;
			var key:int=_quickBoxArr.indexOf(skillQuickBox);
			_skillBoxes[key].visible=false;
		}
		
		protected function onRollOver(event:MouseEvent):void
		{
			var skillQuickBox:SkillQuickBoxView=event.currentTarget as SkillQuickBoxView;
			var key:int=_quickBoxArr.indexOf(skillQuickBox);
			_skillBoxes[key].visible=true;
		}		
		
		/**使用快捷栏
		 */		
		private function onClick(e:MouseEvent):void
		{
			var skillQuickBoxView:SkillQuickBoxView=e.currentTarget as SkillQuickBoxView;
			if(skillQuickBoxView)
			{
				if(skillQuickBoxView.quickBoxDyVo)  //存在数据
				{
					switch(skillQuickBoxView.quickBoxDyVo.key_id)  //格子  1  到 10 
					{
						case 1:
							YFEventCenter.Instance.dispatchEventWith(GlobalEvent.KeyDownNum_1);
							break;
						case 2:
							YFEventCenter.Instance.dispatchEventWith(GlobalEvent.KeyDownNum_2);
							break;
						case 3:
							YFEventCenter.Instance.dispatchEventWith(GlobalEvent.KeyDownNum_3);
							break;
						case 4:
							YFEventCenter.Instance.dispatchEventWith(GlobalEvent.KeyDownNum_4);
							break;
						case 5:
							YFEventCenter.Instance.dispatchEventWith(GlobalEvent.KeyDownNum_5);
							break;
						case 6:
							YFEventCenter.Instance.dispatchEventWith(GlobalEvent.KeyDownNum_6);
							break;
						case 7:
							YFEventCenter.Instance.dispatchEventWith(GlobalEvent.KeyDownNum_7);
							break;
						case 8:
							YFEventCenter.Instance.dispatchEventWith(GlobalEvent.KeyDownNum_8);
							break;
						case 9:
							YFEventCenter.Instance.dispatchEventWith(GlobalEvent.KeyDownNum_9);
							break;
						case 10:
							YFEventCenter.Instance.dispatchEventWith(GlobalEvent.KeyDownNum_0);
							break;
						case 11:
							YFEventCenter.Instance.dispatchEventWith(GlobalEvent.KeyDownQ);
							break;
						case 12:
							YFEventCenter.Instance.dispatchEventWith(GlobalEvent.KeyDownW);
							break;
						case 13:
							YFEventCenter.Instance.dispatchEventWith(GlobalEvent.KeyDownE);
							break;
						case 14:
							YFEventCenter.Instance.dispatchEventWith(GlobalEvent.KeyDownR);
							break;
						case 15:
							YFEventCenter.Instance.dispatchEventWith(GlobalEvent.KeyDownT);
							break;
						case 16:
							YFEventCenter.Instance.dispatchEventWith(GlobalEvent.KeyDownA);
							break;
						case 17:
							YFEventCenter.Instance.dispatchEventWith(GlobalEvent.KeyDownS);
							break;
						case 18:
							YFEventCenter.Instance.dispatchEventWith(GlobalEvent.KeyDownD);
							break;
						case 19:
							YFEventCenter.Instance.dispatchEventWith(GlobalEvent.KeyDownF);
							break;
						case 20:
							YFEventCenter.Instance.dispatchEventWith(GlobalEvent.KeyDownG);
							break;
					}
				}
			}
		}	
		
		/**鼠标按下快捷栏技能图标  进行图标拖动
		 */
		private function onMouseDown(e:MouseEvent):void
		{
			var skillQuickBox:SkillQuickBoxView=e.currentTarget as SkillQuickBoxView;	
			if(skillQuickBox.quickBoxDyVo)
			{
				var dragData:DragData=new DragData();
				dragData.data={};
				if(skillQuickBox.quickBoxDyVo.type==SkillModuleType.QuickType_BT_SKILL)
				{
					dragData.type=DragData.From_QuickBox_SKill;
				}
				else if(skillQuickBox.quickBoxDyVo.type==SkillModuleType.QuickType_BT_ITEM)
				{
					dragData.type=DragData.From_QuickBox_Item;
				}
				dragData.data.id=skillQuickBox.quickBoxDyVo.id;
				DragManager.Instance.startDrag(skillQuickBox,dragData);
			}
		}
		/** view  是否在窗口 windowClass里面
		 * @param view
		 * @param windowClass
		 * @return 
		 */		
		private function isInWindow(view:DisplayObject,windowClass:Class):Boolean
		{
			var obj:DisplayObject=view;
			while(obj)
			{
				if(obj is windowClass) return true;
				obj=obj.parent;
			}
			return false;
		}
		
		/**鼠标弹起来
		 */		
		private function onStageMouseUp(e:MouseEvent=null):void
		{
			var dragData:DragData=DragManager.Instance.dragVo as DragData;
			if(dragData)  //根据位置确定其选中的目标
			{
				var arrSkillWindowArr:Array=LayerManager.WindowLayer.getObjectsUnderPoint(new Point(StageProxy.Instance.stage.mouseX,StageProxy.Instance.stage.mouseY));
				var view:DisplayObject;
				if(dragData.type==DragData.FROM_BAG||dragData.type==DragData.From_Skill_Grid||dragData.type==DragData.From_QuickBox_SKill)
				{
					for each(view in arrSkillWindowArr)
					{
//						if(view is SkillNewWindow) return ;
						if(isInWindow(view,SkillNewWindow))return ;
					}
				}
				
				var arrAutoWindowArr:Array=LayerManager.WindowLayer.getObjectsUnderPoint(new Point(StageProxy.Instance.stage.mouseX,StageProxy.Instance.stage.mouseY));
				if(dragData.type==DragData.FROM_BAG||dragData.type==DragData.From_Skill_Grid||dragData.type==DragData.From_QuickBox_SKill)
				{
					for each(view in arrAutoWindowArr)
					{
//						if(view is AutoWindow) return ; //挂机窗口
						if(isInWindow(view,AutoWindow))return ;
					}
				}
				
				var trigger:Boolean=false;
				var myType:int;
				if(dragData.type==DragData.From_QuickBox_SKill)
				{
					myType=SkillModuleType.QuickType_BT_SKILL;
					trigger=true;
				}
				else if(dragData.type==DragData.From_QuickBox_Item)
				{
					myType=SkillModuleType.QuickType_BT_ITEM;
					trigger=true;
				}
				if(trigger)
				{
					var quckBoxDyVo:QuickBoxDyVo=QuickBoxManager.Instance.getQuickBoxDyVoId(myType,dragData.data.id);  //判断 这个物品之前是否丢在快捷栏上
					var setQuickBoxVo:SetQuikBoxVo=new SetQuikBoxVo();
					setQuickBoxVo.fromKeyId=-1;
					setQuickBoxVo.boxType=SkillModuleType.QuickType_BT_NONE;
					setQuickBoxVo.boxId=dragData.data.id;  //传道具模版id 
					setQuickBoxVo.target_key_id=-1;
					
					if(quckBoxDyVo)
					{
						setQuickBoxVo.fromKeyId=quckBoxDyVo.key_id;
					}
					YFEventCenter.Instance.dispatchEventWith(SkillEvent.C_SetQuickBox,setQuickBoxVo);
				}
			}
		}
		protected function onSkillPanelUIMouseUp(e:MouseEvent=null):void
		{
			var dragData:DragData=DragManager.Instance.dragVo as DragData;
			if(dragData)  //根据位置确定其选中的目标
			{
				var propBasicVo:PropsBasicVo;
				var mouseX:Number=_mc.mouseX;
				var mouseY:Number=_mc.mouseY;
				var currentColumn:int=mouseX/SkillQuickBoxView.skillGridWidth;
				var currentRow:int;
				if(mouseY>=0)currentRow=mouseY/SkillQuickBoxView.skillGridHeight;
				else 
				{
					currentRow=int(Math.abs(mouseY)/SkillQuickBoxView.skillGridHeight)+1;
				}
				var target_key_id:int=currentRow*TotalColumn+currentColumn +1; //从 1 开始
				var setQuickBoxVo:SetQuikBoxVo=new SetQuikBoxVo();
				var quckBoxDyVo:QuickBoxDyVo;
				switch(dragData.type)
				{
					case DragData.From_Skill_Grid: //技能格子的拖动
					case DragData.From_QuickBox_SKill : //快捷栏拖动技能
						setQuickBoxVo.fromKeyId=-1;
						setQuickBoxVo.boxType=SkillModuleType.QuickType_BT_SKILL;
						setQuickBoxVo.boxId=dragData.data.id;
						setQuickBoxVo.target_key_id=target_key_id;
						quckBoxDyVo=QuickBoxManager.Instance.getQuickBoxDyVoId(setQuickBoxVo.boxType,setQuickBoxVo.boxId);  //判断 这个物品之前是否丢在快捷栏上
						if(quckBoxDyVo)
						{
							setQuickBoxVo.fromKeyId=quckBoxDyVo.key_id;
							if(quckBoxDyVo.key_id==target_key_id)  //如果 拖到的是同一个位置 则不进行处理
							{
								DragManager.Instance.dragVo=null;
								return ;
							}
						}
						YFEventCenter.Instance.dispatchEventWith(SkillEvent.C_SetQuickBox,setQuickBoxVo);
						break;
					case DragData.FROM_BAG:
						var propDyVo:PropsDyVo=PropsDyManager.instance.getPropsInfo(dragData.data.id);
						if(propDyVo)
						{
							propBasicVo=PropsBasicManager.Instance.getPropsBasicVo(propDyVo.templateId);
							if(propBasicVo.type==TypeProps.PROPS_TYPE_HP_DRUG || propBasicVo.type==TypeProps.PROPS_TYPE_MP_DRUG)
							{
								setQuickBoxVo.fromKeyId=-1;
								setQuickBoxVo.boxType=SkillModuleType.QuickType_BT_ITEM;
								setQuickBoxVo.boxId=propDyVo.templateId;  //传道具模版id 
								setQuickBoxVo.target_key_id=target_key_id;
								quckBoxDyVo=QuickBoxManager.Instance.getQuickBoxDyVoId(setQuickBoxVo.boxType,setQuickBoxVo.boxId);  //判断 这个物品之前是否丢在快捷栏上
								if(quckBoxDyVo)
								{
									setQuickBoxVo.fromKeyId=quckBoxDyVo.key_id;
									if(quckBoxDyVo.key_id==target_key_id)  //如果 拖到的是同一个位置 则不进行处理
									{
										DragManager.Instance.dragVo=null;
										return ;
									}
								}
								YFEventCenter.Instance.dispatchEventWith(SkillEvent.C_SetQuickBox,setQuickBoxVo);
							}
							else 
							{
								NoticeUtil.setOperatorNotice("此物品不可以被放入快捷栏！");
							}
						}
						else 
						{
							NoticeUtil.setOperatorNotice("此物品不可以被放入快捷栏！");
						}
						break;
					case DragData.From_QuickBox_Item://快捷栏拖动药品
						//						var propDyVo:PropsDyVo=PropsDyManager.instance.getPropsInfo(dragData.data.id);
						var propTempId:int=dragData.data.id;
						var num:int=PropsDyManager.instance.getPropsQuantity(propTempId);  //获取道具总数量
						if(num>0)
						{
							propBasicVo=PropsBasicManager.Instance.getPropsBasicVo(propTempId);
							if(propBasicVo.type==TypeProps.PROPS_TYPE_HP_DRUG || propBasicVo.type==TypeProps.PROPS_TYPE_MP_DRUG)
							{
								setQuickBoxVo.fromKeyId=-1;
								setQuickBoxVo.boxType=SkillModuleType.QuickType_BT_ITEM;
								setQuickBoxVo.boxId=propTempId;  //传道具模版id 
								setQuickBoxVo.target_key_id=target_key_id;
								quckBoxDyVo=QuickBoxManager.Instance.getQuickBoxDyVoId(setQuickBoxVo.boxType,setQuickBoxVo.boxId);  //判断 这个物品之前是否丢在快捷栏上
								if(quckBoxDyVo)
								{
									setQuickBoxVo.fromKeyId=quckBoxDyVo.key_id;
									if(quckBoxDyVo.key_id==target_key_id)  //如果 拖到的是同一个位置 则不进行处理
									{
										DragManager.Instance.dragVo=null;
										return ;
									}
								}
								YFEventCenter.Instance.dispatchEventWith(SkillEvent.C_SetQuickBox,setQuickBoxVo);
							}
							else 
							{
								NoticeUtil.setOperatorNotice("此物品不可以被放入快捷栏！");
							}
						}
						else 
						{
							NoticeUtil.setOperatorNotice("此物品不可以被放入快捷栏！");
						}
				}
			}
			DragManager.Instance.dragVo=null;
		}
		/**技能重置时清空字典*/
		public function resetSkill():void
		{
			_skilledQuickBoxDic=new Dictionary;
			
		}
		
		public function updateQuickBoxUI():void
		{
			for each(var skillQuickBox:SkillQuickBoxView in _quickBoxArr)
			{
				skillQuickBox.clearData();
			}
			//清空Ui
			var dict:Dictionary=QuickBoxManager.Instance.getDict();
			var key:int;
			var skillQuickView:SkillQuickBoxView;
			for each(var quickBoxDyVo:QuickBoxDyVo in dict)
			{
				key=quickBoxDyVo.key_id-1;
				skillQuickView=_quickBoxArr[key];
				if(skillQuickView)
				{
					skillQuickView.quickBoxDyVo=quickBoxDyVo;
 					skillQuickView.updateView();
				}
			}
		}
		/**更新快捷栏的显示个数
		 */		
		public function updateQuickBoxNum():void
		{
			var dict:Dictionary=QuickBoxManager.Instance.getDict();
			var key:int;
			var skillQuickView:SkillQuickBoxView;
			for each(var quickBoxDyVo:QuickBoxDyVo in dict)
			{
				key=quickBoxDyVo.key_id-1;
				skillQuickView=_quickBoxArr[key];
				if(skillQuickView)
				{
					skillQuickView.quickBoxDyVo=quickBoxDyVo;
					skillQuickView.updateView();
				}
			}
		}
		/**目标给自的信息
		 */		
		public function getAvailableQuickBox():AutoPutSkillVo
		{
			var len:int=_quickBoxArr.length;
			var skillQuickBoxView:SkillQuickBoxView;
			var pos:Point;
			var autoPutSkillVO:AutoPutSkillVo;
			for(var i:int=0;i!=len;++i)
			{
				skillQuickBoxView=_quickBoxArr[i];
				if(!skillQuickBoxView.quickBoxDyVo&&!_skilledQuickBoxDic[skillQuickBoxView])
				{
					//不存在 则表示 该格子可用
					autoPutSkillVO=new AutoPutSkillVo();
					autoPutSkillVO.key_id=i+1;
					pos=LayerManager.getUILayePos(skillQuickBoxView);
					autoPutSkillVO.x=pos.x;
					autoPutSkillVO.y=pos.y;
					_skilledQuickBoxDic[skillQuickBoxView]=true;
					return autoPutSkillVO;
				}
			}
			return null;
		}
	}
}