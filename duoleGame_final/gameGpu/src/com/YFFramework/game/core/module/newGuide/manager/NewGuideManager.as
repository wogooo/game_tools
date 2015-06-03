package com.YFFramework.game.core.module.newGuide.manager
{
	import com.YFFramework.core.ui.yfComponent.PopUpSprite;
	import com.YFFramework.game.core.global.DataCenter;
	import com.YFFramework.game.core.global.manager.CharacterDyManager;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.module.gameView.view.GameViewPositonProxy;
	import com.YFFramework.game.core.module.mapScence.world.model.MapSceneBasicVo;
	import com.YFFramework.game.core.module.mapScence.world.model.type.TypeRole;
	import com.YFFramework.game.core.module.newGuide.model.NewGuideFuncOpenConfig;
	import com.YFFramework.game.core.module.newGuide.model.NewGuideOpenFuncType;
	import com.YFFramework.game.core.module.newGuide.model.NewGuideStep;
	import com.YFFramework.game.core.module.newGuide.view.NewGuideMovieClipWidthArrow;
	import com.YFFramework.game.core.module.newGuide.view.NewGuideOpenFuncWindow;
	import com.YFFramework.game.core.module.skill.mamanger.SkillDyManager;
	import com.YFFramework.game.core.module.task.manager.TaskDyManager;
	import com.YFFramework.game.core.module.task.model.TaskDyVo;
	import com.YFFramework.game.core.module.task.model.Task_targetBasicVo;
	import com.YFFramework.game.ui.layer.LayerManager;
	import com.dolo.ui.controls.Panel;
	import com.dolo.ui.controls.Window;
	
	import flash.utils.Dictionary;

	/** 新手引导的一些常量控制
	 * @author yefeng
	 * 2013 2013-7-5 上午10:04:38 
	 */
	public class NewGuideManager
	{
		
		
		
		
		/** 转职任务 id   ///转职任务作为对话任务来做
		 *  这个任务id 目前是写死的     可提交的任务触发
		 */		
		public static const ChangeCareerTaskId:int=13;
		
		/**  获得的任务id 
		 */
		public static const SkipToMainCityGetTaskId:int=12;
		
		/**进主城前 完成的任务id 
		 */
		public static const SkipToMainCityFinishTaskId:int=11;

		
		////开启功能  触发对应的任务 id 
		/**开启背包功能 的触发任务 id为  1     为当前任务列表时触发
		 */
		public static const Open_BagFunc_TaskId:int=1;
		
		
		/**接受任务触发 人物面板打开引导
		 */
		public static const CharactorGuideAcceptTaskId:int=14;
		
		
		/**开启技能功能 的当前任务为 Open_skillFunc_TaskId
		 */
		public static const Open_skillFunc_TaskId:int=15;
		
		/**开启 好友功能的当前任务的  任务id 
		 */		
		public static const Open_FriendFunc_TaskId:int=18;
		
		/**锻造 功能开启
		 */
		public static const Open_ForageFunc_TaskId:int=51;


		/**引导的 最大 等级 为  30    达到 30 级  则不进行引导了     level<MaxGuideLevel   才会进行引导
		 */		
		public static const MaxGuideLevel:int=30;
		
		
		
		/**主界面UI引导
		 */
		public static var CharactorMainUIGuideFunc:Function;
		
		/**任务模块  主动触发响应寻路     该函数引导的是 TaskMiniPanel的  autoTrigger方法
		 */		
		public static var taskGuideFunc:Function;
		
		/**引用小飞鞋方法
		 */		
		public static var taskFlyBootFunc:Function;
		
		/**是否可以引导
		 */		
		public static var canGuide:Boolean=false;
		/**新手 引导触发的 ＣＤ
		 */			
		public static const  NewGuideCD:Number=3000;
		
		
		/**宠物出战 引导 主界面引导打开宠物
		 */
		public static  var PetMainUIGuideFunc:Function=null;
		
		
		/**引导坐骑出战
		 */
		public static var MountGuideFunc:Function=null;
		
		
		/**引导打开背包
		 */
		public static var BagGuideFunc:Function;
	
		//引导打开技能
		/**引导打开技能面板
		 */
		public static var SkillMainUIGuide:Function;
		
		///引导 打开锻造面板
		
		/** 锻造面板 打开
		 */
		public static var ForageMainUIGuide:Function; 
		
		
		/**  剧情 引导
		 */
		public static var movieStoryGuideFunc:Function;
		
		
		
		/**触发 任务  默认 任务 延迟 2s 触发 
		 */
		private var _taskHandleGuide:Boolean=false;
		/**字典里面 只需要 触发一次
		 */
		private static var tiggerDict:Dictionary=new Dictionary();
		
		
		
		
		public static var isInit:Boolean=false; 
		public function NewGuideManager()
		{
		}
		
		
		/**功能开启引导
		 */
		private static function handleGuideFuncOpen():Boolean
		{
			var cantrigger:Boolean=true;///是否触发任务强制引导 

			if(cantrigger)
			{
				if(PetMainUIGuideFunc!=null)
				{
					if(PetMainUIGuideFunc())  //宠物出战引导
					{
						cantrigger=false;
					}
				}
			}
			if(cantrigger)
			{
				if(MountGuideFunc!=null)
				{
					if(MountGuideFunc())
					{
						cantrigger=false;
					}
				}
			}
			if(cantrigger)
			{
				if(BagGuideFunc!=null)
				{
					if(BagGuideFunc())
					{
						cantrigger=false;
					}
				}
			}
			if(cantrigger)
			{
				if(ForageMainUIGuide!=null)
				{
					if(ForageMainUIGuide())
					{
						cantrigger=false;
					}
				}
			}
			
			// 宠物功能面板开启
			if(cantrigger)
			{
				if(PetGuideFuncOpen())
				{
					cantrigger=false;
				}
			}
			// 翅膀功能面板开启
			if(cantrigger)
			{
				if(WingGuideFuncOpen())
				{
					cantrigger=false;
				}
			}
			
			// 坐骑功能面板开启
			if(cantrigger)
			{
				if(MountGuideFuncOpen())
				{
					cantrigger=false;
				}
			}
			///功能面板开启
			if(cantrigger)  //开启 功能面板
			{
				if(BagGuideFuncOpen())
				{
					cantrigger=false;
				}
			}
			
			//主界面UI引导
			if(cantrigger)  //主界面UI引导
			{
				if(CharactorMainUIGuide())
				{
					cantrigger=false;
				}
			}
			
			if(cantrigger)  //引导打开技能面板
			{
				if(SkillMainUIGuide!=null)
				{
					if(SkillMainUIGuide())
					{
						cantrigger=false;
					}
				}
			}
			
			if(cantrigger)  // 商城功能引导
			{
				if(MallGuideFuncOpen())
				{
					cantrigger=false;
				}
			}
			
			if(cantrigger)  // 组队功能引导
			{
				if(TeamGuideFuncOpen())
				{
					cantrigger=false;
				}
			}
			if(cantrigger)  // 市场功能引导
			{
				if(MarketGuideFuncOpen())
				{
					cantrigger=false;
				}
			}
			
			if(cantrigger)  // 工会功能引导
			{
				if(GuildGuideFuncOpen())
				{
					cantrigger=false;
				}
			}
			//剧情引导
			if(cantrigger)
			{
				if(movieStoryGuideFunc!=null)	
				{
					if(movieStoryGuideFunc())
					{
						cantrigger=false;
					}
				}
			}
			return cantrigger;
		}
		
		/**开始引导
		 */			
		public static function DoGuide():Boolean
		{
			if(isInit)
			{
				var window:Panel;
				var cantrigger:Boolean=true;///是否触发任务强制引导 
				var mapSceneBasicVo:MapSceneBasicVo;
				var len:int;
				var i:int;
				var mainTaskDyVo:TaskDyVo;
				if(DataCenter.Instance.roleSelfVo.roleDyVo.hp>0&&DataCenter.Instance.roleSelfVo.roleDyVo.level<MaxGuideLevel)  //为 0 时候 玩家死亡
				{
					if(NewGuideManager.taskGuideFunc!=null&&canGuide)
					{
						mapSceneBasicVo=DataCenter.Instance.mapSceneBasicVo;
						if(mapSceneBasicVo)
						{
							if(mapSceneBasicVo.type!=TypeRole.MapScene_Raid)  //不为副本地图
							{
								
								
								cantrigger=handleGuideFuncOpen();
								
								
								////////  功能按钮箭头引导
								//检查pop层的窗口
								if(cantrigger)
								{
									len=LayerManager.PopLayer.numChildren;
									var popSp:PopUpSprite;
									for(i=len-1;i>=0;i--)
									{
										popSp=LayerManager.PopLayer.getChildAt(i) as PopUpSprite;
										if(popSp)
										{
											window=popSp.getContent() as Window;
											if(window)
											{
												if(window.getNewGuideVo())
												{
													cantrigger=false; 
													break;
												}
											}
										}
									}
								}
								
								///窗口内部引导
								if(cantrigger)
								{
									//检查 window层 是否有新手引导窗口
									len=LayerManager.WindowLayer.numChildren;
									for(i=len-1;i>=0;i--)
									{
										window=LayerManager.WindowLayer.getChildAt(i) as Panel;
										if(window)
										{
											if(window.getNewGuideVo())
											{
												cantrigger=false;
												break;
											}
										}
									}
								}
								
								
								if(cantrigger)
								{
									//重置所有的技能CD  使人 可以继续杀下一个怪物
									return NewGuideManager.taskGuideFunc() as Boolean; //主动触发任务
								}
							}
						}
					}
				}
				else   //超过新手引导的任务引导  会主动接受任务 但是不会自动打怪
				{
					
					if(NewGuideManager.taskGuideFunc!=null&&canGuide)
					{
						mapSceneBasicVo=DataCenter.Instance.mapSceneBasicVo;
						if(mapSceneBasicVo)
						{
							if(mapSceneBasicVo.type!=TypeRole.MapScene_Raid)  //不为副本地图
							{
								
								cantrigger=handleGuideFuncOpen();
								
								if(cantrigger)
								{
									//检查 window层 是否有新手引导窗口
									len=LayerManager.WindowLayer.numChildren;
									for(i=len-1;i>=0;i--)
									{
										window=LayerManager.WindowLayer.getChildAt(i) as Panel;
										if(window)
										{
											if(window.getNewGuideVo())
											{
												cantrigger=false;
												break;
											}
										}
									} 
								}

								if(cantrigger)
								{
									//								return NewGuideManager.taskGuideFunc() as Boolean; //主动触发任务
									//							//  //如果 主线任务 不是打怪任务 
									var task_targetBasicVo:Task_targetBasicVo=TaskDyManager.getInstance().getMainTrunkCurrentTaskTargetBasicVo();
									if(task_targetBasicVo)  //如果主线为对话 或者 采集
									{
										if(task_targetBasicVo.seach_type==TypeProps.TaskTargetType_NPCDialog||task_targetBasicVo.seach_type==TypeProps.TaskTargetType_NPCSimpleDialog||task_targetBasicVo.seach_type==TypeProps.TaskTargetType_Gather||task_targetBasicVo.seach_type==TypeProps.TaskTargetType_Stroy)
											return NewGuideManager.taskGuideFunc() as Boolean; //主动触发任务
									}
									else if(TaskDyManager.getInstance().getAbleListLength()>0)  //如果处于接任务阶段
									{
										return NewGuideManager.taskGuideFunc() as Boolean; //主动触发任务
									}
								}
							}
						} 
						
					}
				}
			}
			return false;
		}
		
		
		
		
		
		/**背包功能格开启    技能功能格子开启
		 *  技能开启  
		 * 好友开启
		 */
		public static function BagGuideFuncOpen():Boolean
		{
			if(DataCenter.Instance.roleSelfVo.roleDyVo.level<MaxGuideLevel)
			{
				var mainTaskDyVo:TaskDyVo=TaskDyManager.getInstance().getMainTrunkCurrentTaskVo();
				if(mainTaskDyVo)
				{
					var newGuideOpenFuncWindow:NewGuideOpenFuncWindow;
					switch(mainTaskDyVo.taskID)
					{
						case Open_BagFunc_TaskId:   //开启背包
							if(!tiggerDict[NewGuideOpenFuncType.Open_Bag]&&NewGuideFuncOpenConfig.isOpen(NewGuideFuncOpenConfig.BagOpen)==false)
							{
								newGuideOpenFuncWindow=new NewGuideOpenFuncWindow(NewGuideOpenFuncType.Open_Bag);
								newGuideOpenFuncWindow.show()
								tiggerDict[NewGuideOpenFuncType.Open_Bag]=1;
								return true;
							}
							break;
						case Open_skillFunc_TaskId: //开启技能
							if(!tiggerDict[NewGuideOpenFuncType.Open_Skill]&&SkillDyManager.Instance.findNextCanLearnSkill(1)&&NewGuideFuncOpenConfig.isOpen(NewGuideFuncOpenConfig.SkillOpen)==false)  //有可以学习的技能
							{
								newGuideOpenFuncWindow=new NewGuideOpenFuncWindow(NewGuideOpenFuncType.Open_Skill);
								newGuideOpenFuncWindow.show()
								tiggerDict[NewGuideOpenFuncType.Open_Skill]=1;
								NewGuideStep.SkillGuideStep=NewGuideStep.SkillMainUI
								return true;
							}
							break;
						case Open_FriendFunc_TaskId://开启好友功能
							if(!tiggerDict[NewGuideOpenFuncType.Open_Friend]&&NewGuideFuncOpenConfig.isOpen(NewGuideFuncOpenConfig.ForageOpen)==false)
							{
								newGuideOpenFuncWindow=new NewGuideOpenFuncWindow(NewGuideOpenFuncType.Open_Friend);
								newGuideOpenFuncWindow.show()
								tiggerDict[NewGuideOpenFuncType.Open_Friend]=1;
								return true;
							}
							break;
						case Open_ForageFunc_TaskId: //锻造 功能开启 
							if(!tiggerDict[NewGuideOpenFuncType.Open_Forage]&&NewGuideFuncOpenConfig.isOpen(NewGuideFuncOpenConfig.ForageOpen)==false) //开启锻造功能
							{
								newGuideOpenFuncWindow=new NewGuideOpenFuncWindow(NewGuideOpenFuncType.Open_Forage);
								newGuideOpenFuncWindow.show();
								tiggerDict[NewGuideOpenFuncType.Open_Forage]=1;
							}
							break;
					}
				}

			}
			return false;
		}
		
		/**人物面板打开引导
		 */		
		public static function CharactorMainUIGuide():Boolean
		{
			if(DataCenter.Instance.roleSelfVo.roleDyVo.level<MaxGuideLevel)
			{
				var mainTaskDyVo:TaskDyVo=TaskDyManager.getInstance().getMainTrunkAbleListTaskVo();
				if(mainTaskDyVo)
				{
					if(mainTaskDyVo.taskID==CharactorGuideAcceptTaskId&&CharacterDyManager.Instance.potential>0) //并且潜力点大于0
					{
						if(tiggerDict[NewGuideStep.CharactorMainUI]==null)
						{
							NewGuideStep.CharactorGuideStep=NewGuideStep.CharactorMainUI;
							tiggerDict[NewGuideStep.CharactorMainUI]=1
							return CharactorMainUIGuideFunc();
						}
					}
				}
			}
			return false;
		}
		
		
		/**宠物新功能开启
		 */
		public static function PetGuideFuncOpen():Boolean
		{
			if(NewGuideStep.PetGuideStep==NewGuideStep.PetFuncOpen&&NewGuideFuncOpenConfig.isOpen(NewGuideFuncOpenConfig.PetOpen)==false)
			{
				var newGuideOpenFuncWindow:NewGuideOpenFuncWindow=new NewGuideOpenFuncWindow(NewGuideOpenFuncType.Open_Pet);
				newGuideOpenFuncWindow.show()
				tiggerDict[NewGuideOpenFuncType.Open_Bag]=1;
				NewGuideStep.PetGuideStep=NewGuideStep.PetMainUIBtn
				return true;
			}
			return false;
		}
		
		/**翅膀新功能开启
		 */
		public static function WingGuideFuncOpen():Boolean
		{
			if(NewGuideStep.WingGuideStep==NewGuideStep.WingGuideFunOpen&&NewGuideFuncOpenConfig.isOpen(NewGuideFuncOpenConfig.WingOpen)==false)
			{
				var newGuideOpenFuncWindow:NewGuideOpenFuncWindow=new NewGuideOpenFuncWindow(NewGuideOpenFuncType.Open_Wing);
				newGuideOpenFuncWindow.show()
				tiggerDict[NewGuideOpenFuncType.Open_Wing]=1;
				NewGuideStep.WingGuideStep=-1;
				return true;
			}
			return false;
		}
 
		 
		/**坐骑新功能开启
		 */
		public static function MountGuideFuncOpen():Boolean
		{
			if(NewGuideStep.MountGuideStep==NewGuideStep.MountGuideFuncOpen&&NewGuideFuncOpenConfig.isOpen(NewGuideFuncOpenConfig.MountOpen)==false)
			{
				var newGuideOpenFuncWindow:NewGuideOpenFuncWindow=new NewGuideOpenFuncWindow(NewGuideOpenFuncType.Open_Mount);
				newGuideOpenFuncWindow.show()
				tiggerDict[NewGuideOpenFuncType.Open_Mount]=1;
				NewGuideStep.MountGuideStep=NewGuideStep.MountMainUIMountBtn; 
				return true;
			}
			return false;
		}

		
		/**商城打开引导
		 */
		public static function MallGuideFuncOpen():Boolean
		{
			if(NewGuideStep.MallGuideStep==NewGuideStep.MallGuideFuncOpen&&NewGuideFuncOpenConfig.isOpen(NewGuideFuncOpenConfig.MallOpen)==false)
			{
				var newGuideOpenFuncWindow:NewGuideOpenFuncWindow=new NewGuideOpenFuncWindow(NewGuideOpenFuncType.Open_Mall);
				newGuideOpenFuncWindow.show()
				tiggerDict[NewGuideOpenFuncType.Open_Mall]=1;
				NewGuideStep.MallGuideStep=-1; 
				return true;
			}
			return false;
		}
		/**  组队开启
		 */		
		public static function TeamGuideFuncOpen():Boolean
		{
			if(NewGuideStep.TeamGuideStep==NewGuideStep.TeamGuideFuncOpen&&NewGuideFuncOpenConfig.isOpen(NewGuideFuncOpenConfig.TeamOpen)==false)
			{
				var newGuideOpenFuncWindow:NewGuideOpenFuncWindow=new NewGuideOpenFuncWindow(NewGuideOpenFuncType.Open_Team);
				newGuideOpenFuncWindow.show()
				tiggerDict[NewGuideOpenFuncType.Open_Team]=1;
				NewGuideStep.TeamGuideStep=-1; 
				return true;
			}
			return false;
		}

		
		/**市场 开启
		 **/
		public static function MarketGuideFuncOpen():Boolean
		{
			if(NewGuideStep.MarketGuideStep==NewGuideStep.MarketGuideFuncOpen&&NewGuideFuncOpenConfig.isOpen(NewGuideFuncOpenConfig.MarkcketOpen)==false)
			{
				var newGuideOpenFuncWindow:NewGuideOpenFuncWindow=new NewGuideOpenFuncWindow(NewGuideOpenFuncType.Open_Market);
				newGuideOpenFuncWindow.show()
				tiggerDict[NewGuideOpenFuncType.Open_Market]=1;
				NewGuideStep.MarketGuideStep=-1; 
				return true;
			}
			return false;
		}

		/**工会开启
		 */		
		public static function GuildGuideFuncOpen():Boolean
		{
			if(NewGuideStep.GuildGuideStep==NewGuideStep.GuildGuideFuncOpen&&NewGuideFuncOpenConfig.isOpen(NewGuideFuncOpenConfig.GuildOpen)==false)
			{
				var newGuideOpenFuncWindow:NewGuideOpenFuncWindow=new NewGuideOpenFuncWindow(NewGuideOpenFuncType.Open_Guild);
				newGuideOpenFuncWindow.show()
				tiggerDict[NewGuideOpenFuncType.Open_Guild]=1;
				NewGuideStep.GuildGuideStep=-1; 
				return true;
			}
			return false;
		}
		
		
	}
}