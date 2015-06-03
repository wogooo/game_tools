package com.YFFramework.game.core.module.mapScence.world.view.player
{
	/**   角色动画类
	 * @author yefeng
	 *2012-4-20下午9:41:45
	 */
	
	import com.YFFramework.core.ui.movie.data.TypeAction;
	import com.YFFramework.core.ui.movie.data.TypeDirection;
	import com.YFFramework.core.ui.yf2d.data.ATFActionData;
	import com.YFFramework.core.ui.yf2d.view.Abs2dView;
	import com.YFFramework.core.yf2d.display.DisplayObject2D;
	import com.YFFramework.core.yf2d.extension.MountHeadPart;
	import com.YFFramework.game.core.module.mapScence.world.model.RoleDyVo;
	import com.YFFramework.game.core.module.system.data.SystemConfigManager;
	import com.YFFramework.game.ui.yf2d.view.avatar.Part2DCombine;
	import com.YFFramework.game.ui.yf2d.view.avatar.pool.Part2dCombinePool;
	
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	
	//翅膀最上层   其实是 武器 再是 人物
	
	/**  坐骑引导人物动 
	 */ 
	public class RolePlayerView extends PlayerView
	{
		
		/** 武器     以及坐骑的躯干来进行代替
		 */
		private var _weapon:Part2DCombine;
		/**坐骑头部  信息绑定在头部     weapon  和head 来组成 一个整的坐骑
		 */		
		private var _mountHead:Part2DCombine;
		/**翅膀
		 */
		private var _wing:Part2DCombine;
		/**  衣服 和翅膀的容器    因为  坐骑的引导点 要引导  翅膀 和人物衣服
		 */		
		//		private var _bodyContainer:Abs2dView; 
		//		
		//		/**倒影层body
		//		 */		
		//		private var _reflectionBodyContainer:Abs2dView;
		//		
		//		private var _bodyShadowContainer:Abs2dView;
		
		/**存放  翅膀  衣服  等 受 坐骑引导的  部位的 影子
		 */		
		private var _guideShadowContainer:Abs2dView;
		/**能否切换层级
		 */		
		private var _canSwapIndex:Boolean=false;
		public function RolePlayerView(roleDyVo:RoleDyVo=null)
		{
			super(roleDyVo);
		}
		
		override protected function initEquipment():void
		{
			_guideShadowContainer=new Abs2dView();
			shadowContainer.addChild(_guideShadowContainer);
			
			
//			_cloth=Part2dCombinePool.getPart2dCombineWing(this);
			_cloth=Part2dCombinePool.getPart2dCombineCloth(this);
			resetSkin();
			_cloth.start();
			addChild(DisplayObject2D(_cloth.mainClip));
			_guideShadowContainer.addChild(_cloth.shadowClip);
			_reflectionContainer.addChild(DisplayObject2D(_cloth.reflectionClip));
			
		}
		
		private function createWeapon():void
		{
//			_weapon=Part2dCombinePool.getPart2dCombineSimple(this);
			_weapon=Part2dCombinePool.getPart2dCombineWeapon(this);
		}
		private function createWing():void
		{
			_wing=Part2dCombinePool.getPart2dCombineWing(this);
		}
		private function createMountHead():void
		{
			_mountHead=Part2dCombinePool.getPart2dCombineMountHead(this,guideBodyContainer);
		}
		override protected function addReflectionClip():void
		{
			isReflection=true;
			if(!shadowContainer.contains(_reflectionContainer))
			{
				shadowContainer.addChild(_reflectionContainer);
			}
			
			if(_mountHead&&_mountHead.actionDataStandWalk)
			{
				_mountHead.reflectionClip.play(_activeAction,_activeDirection,true,null,null,true);
				_mountHead.reflectionClip.start();
			}
			if(_weapon&&_weapon.actionDataStandWalk)
			{
				_weapon.reflectionClip.play(_activeAction,_activeDirection,true,null,null,true);
				_weapon.reflectionClip.start();
			}
			if(_cloth.actionDataStandWalk)
			{
				_cloth.reflectionClip.play(_activeAction,_activeDirection,true,null,null,true);
				_cloth.reflectionClip.start();
			}
			if(_wing&&_wing.actionDataStandWalk)
			{
				_wing.reflectionClip.play(_activeAction,_activeDirection,true,null,null,true);
				_wing.reflectionClip.start();
			}
		}
		override protected function removeReflectionClip():void
		{
			isReflection=false;
			if(shadowContainer.contains(_reflectionContainer))
			{
				shadowContainer.removeChild(_reflectionContainer);
			}
			_cloth.reflectionClip.stop();
			_cloth.reflectionClip.resetData();

			if(_mountHead)	
			{
				_mountHead.reflectionClip.stop();
				_mountHead.reflectionClip.resetData();
			}
			if(_weapon)
			{
				_weapon.reflectionClip.stop();
				_weapon.reflectionClip.resetData()
			}
			if(_wing)
			{
				_wing.reflectionClip.stop();
				_wing.reflectionClip.resetData();
			}
		}
		
		
		
		/**坐骑状态下引导  衣服 和翅膀上下起伏的动
		 * object =={x,y,delay}
		 * mScaleX   值为 1  或者 -1 
		 */ 
		private function guideBodyContainer(object:Object,mScaleX:Number):void  //翅膀 和 衣服 之所以没有放到一个容器里面去  是因为   翅膀 坐骑  衣服有层级关系设置  所以才没有放到容器里面
		{
			  
//			_cloth.mainClip.x=mScaleX*object.x;   // 衣服  
//			_cloth.mainClip.y=object.y;
			_cloth.mainClip.setXY(mScaleX*object.x,object.y);
			
			
//			_cloth.reflectionClip.x=_cloth.mainClip.x;				//衣服  倒影  X
//			_cloth.reflectionClip.y=-_cloth.mainClip.y*Part2DCombine.RefleactionScaleY;  //  //衣服  倒影  Y 
			_cloth.reflectionClip.setXY(_cloth.mainClip.x,-_cloth.mainClip.y*Part2DCombine.RefleactionScaleY);
			
			// 衣服影子
//			_guideShadowContainer.x=_cloth.mainClip.x; // 内部存放的  衣服 和  翅膀  的影子   因为 衣服 和翅膀 会随着坐骑点  浮动 发生位置变化
//			_guideShadowContainer.y=_cloth.mainClip.y;
			_guideShadowContainer.setXY(_cloth.mainClip.x,_cloth.mainClip.y);
			
			///设置 翅膀 坐标     和  衣服坐标一样
			if(_wing)
			{
//				_wing.mainClip.x=_cloth.mainClip.x;  // 衣服 和  影子
//				_wing.mainClip.y=_cloth.mainClip.y;	
				_wing.mainClip.setXY(_cloth.mainClip.x,_cloth.mainClip.y);
				
//				_wing.reflectionClip.x=_cloth.mainClip.x;	//倒影
//				_wing.reflectionClip.y=_cloth.reflectionClip.y;
				_wing.reflectionClip.setXY(_cloth.mainClip.x,_cloth.reflectionClip.y);
			}
			
		}
		/**停止引导body
		 */		
		private function stopGuideBody():void
		{
			
			//设置  衣服坐标
//			_cloth.mainClip.x=_cloth.reflectionClip.x=0;
//			_cloth.mainClip.y=_cloth.reflectionClip.y=0;
			_cloth.mainClip.setXY(0,0);
			_cloth.reflectionClip.setXY(0,0);
			
			//设置     影子
//			_guideShadowContainer.x=_cloth.mainClip.x; // 内部存放的  衣服 和  翅膀  的影子   因为 衣服 和翅膀 会随着坐骑点  浮动 发生位置变化
//			_guideShadowContainer.y=_cloth.mainClip.y;
			_guideShadowContainer.setXY(_cloth.mainClip.x,_cloth.mainClip.y);
			//设置翅膀坐标
			if(_wing)
			{
//				_wing.mainClip.x=_wing.reflectionClip.x=0;
//				_wing.mainClip.y=_wing.reflectionClip.y=0;
				_wing.mainClip.setXY(0,0);
				_wing.reflectionClip.setXY(0,0);
			}
			MountHeadPart(_mountHead.mainClip).stopGuide();
		}
		override protected function set glow(value:Boolean):void
		{
			super.glow=value;
			if(value)
			{
				if(_wing)DisplayObject2D(_wing.mainClip).localColorTransform=SelectBodyColorTransform;
				if(_mountHead)DisplayObject2D(_mountHead.mainClip).localColorTransform=SelectBodyColorTransform;
				if(_weapon)DisplayObject2D(_weapon.mainClip).localColorTransform=SelectBodyColorTransform;
			}
			else 
			{
				if(_wing)DisplayObject2D(_wing.mainClip).localColorTransform=DefaultColortransform;
				if(_mountHead)DisplayObject2D(_mountHead.mainClip).localColorTransform=DefaultColortransform;
				if(_weapon)DisplayObject2D(_weapon.mainClip).localColorTransform=DefaultColortransform;
			}
		}
		
		
		override protected function initRoleDyVo():void
		{
			_roleDyVo=new RoleDyVo();	
		}
		/**只有头部没有信息时候 才以衣服血条定位
		 */		
		override protected function doReLocateBloodName():void
		{
			if(_mountHead&&ATFActionData.isUsableActionData(_mountHead.actionDataStandWalk))
			{
				reLocateBloodNameByMountHead();
			}
			else 
			{
				reLocateBloodName();
			}
		}
		/**  依据坐骑信息定位
		 */		
		protected  function reLocateBloodNameByMountHead():void
		{
			var obj:Object=_mountHead.actionDataStandWalk.getBlood();
			_bloodMC.setY(obj.y);
//			_nameItem1.setY(obj.y-20);
			_nameLayer.y=obj.y-20;
			if(_tittleClip)
			{
//				_tittleClip.x=0;  ///
////				_tittleClip.y=_nameLayer.y-40;
//				_tittleClip.y=_nameItem1.y-40;
				
//				_tittleClip.setXY(0,_nameItem1.y-40);
				_tittleClip.y=_nameLayer.y-40;
			}
		}
		
		/**是否响应鼠标事件 
		 */
//		override protected function initNameLayerMouse():void
//		{
//			_nameLayer.mouseChildren=_nameLayer.mouseEnabled=true;
//			_nameItem1.mouseEnabled=_nameItem1.mouseChildren=true;
//		}
		
		override public function updateClothStandWalk(actionData:ATFActionData):void
		{
			super.updateClothStandWalk(actionData);
			if(actionData)_canSwapIndex=true;
		}
		
		/**衣服特效
		 */
		public function updateClothEffectStandWalk(actionData:ATFActionData):void
		{
			if(actionData)
			{
				_cloth.initEffectStandWalk(actionData);
				_cloth.start();
				if(_activeAction!=TypeAction.Dead)
				{
					play(_activeAction,_activeDirection,true,null,null,true);
				}
				else  /// dead 
				{
					stayDead(_activeDirection);
				}
			}
			else 
			{
				_cloth.initEffectStandWalk(null);
			}
		}
		
		/**更新 1
		 */		
		public function updateClothEffectFight(actionData:ATFActionData):void
		{
			_cloth.initEffectFight(actionData);
		}

		/**更新 
		 */		
		public function updateClothEffectInjureDead(actionData:ATFActionData):void
		{
			_cloth.initEffectInjureDead(actionData);
		}

		/**更新 衣服特殊攻击动作 1
		 */		
		public function updateClothEffectAtk_1(actionData:ATFActionData):void
		{
			_cloth.initEffectAtk_1(actionData);
		}
		/**更新 衣服战斗待机
		 */		
		public function updateClothEffectFightStand(actionData:ATFActionData):void
		{
			_cloth.initEffectFightStand(actionData);
		}
		/**更新武器
		 */
		public function updateWeaponStandWalk(actionData:ATFActionData):void
		{
			if(actionData)
			{
				_canSwapIndex=true;  //武器  改变层级 有可能 是    单个部位的坐骑 所以也需要改变层级 所以这里把他拿到外面来了
				if(!_weapon)
				{
					createWeapon();
				}
//				_canSwapIndex=true;
				if(!contains(DisplayObject2D(_weapon.mainClip)))
				{
					addChildAt(DisplayObject2D(_weapon.mainClip),0);
					shadowContainer.addChildAt(_weapon.shadowClip,0);
					_reflectionContainer.addChildAt(DisplayObject2D(_weapon.reflectionClip),0);
				}
				_weapon.initActionDataWalkStand(actionData);
				_weapon.start();
				if(_activeAction!=TypeAction.Dead)
				{
					play(_activeAction,_activeDirection,true,null,null,true);
				}
				else  /// dead 
				{
					stayDead(_activeDirection);
				}
			}
			else 
			{
				if(_weapon)
				{
					if(contains(DisplayObject2D(_weapon.mainClip)))
					{
						removeChild(DisplayObject2D(_weapon.mainClip));
						shadowContainer.removeChild(_weapon.shadowClip);
						_reflectionContainer.removeChild(DisplayObject2D(_weapon.reflectionClip));
					}
					_weapon.initActionDataWalkStand(null);
					_weapon.resetData();
					_weapon.stop();
				}
			}
		}
		
		
		/**武器战斗
		 */		
		public function updateWeaponFight(actionData:ATFActionData):void
		{
			if(actionData)
			{
				if(!_weapon)
				{
					createWeapon();
				}
				_weapon.initActionDataFight(actionData);
			}
			else 
			{
				if(_weapon)		_weapon.initActionDataFight(null);
			}
		}
		/**武器受击死亡
		 */		
		public function updateWeaponInjureDead(actionData:ATFActionData):void
		{
			if(actionData)
			{
				if(!_weapon)
				{
					createWeapon();
				}
				_weapon.initActionDataInjureDead(actionData);
			}
			else 
			{
				if(_weapon)		_weapon.initActionDataInjureDead(null);
			}
		}
		/**武器特殊攻击动作1
		 */		
		public function updateWeaponAtk_1(actionData:ATFActionData):void
		{
			if(actionData)
			{
				if(!_weapon)
				{
					createWeapon();
				}
				_weapon.initActionDataAtk_1(actionData);
			}
			else 
			{
				if(_weapon)		_weapon.initActionDataAtk_1(null);
			}
		}
		/**武器战斗待机
		 */		
		public function updateWeaponFightStand(actionData:ATFActionData):void
		{
			if(actionData)
			{
				if(!_weapon)
				{
					createWeapon();
				}
				_weapon.initActionDataFightStand(actionData);
			}
			else 
			{
				if(_weapon)		_weapon.initActionDataAtk_1(null);
			}
		}
		
		/**武器 光效
		 */
		public function updateWeaponEffectStandWalk(actionData:ATFActionData):void
		{
			if(actionData)
			{
				if(!_weapon)
				{
					createWeapon();
				}
				//				_canSwapIndex=true;
				if(!contains(DisplayObject2D(_weapon.mainClip)))
				{
					addChildAt(DisplayObject2D(_weapon.mainClip),0);
					shadowContainer.addChildAt(_weapon.shadowClip,0);
					_reflectionContainer.addChildAt(DisplayObject2D(_weapon.reflectionClip),0);
				}
				_weapon.initEffectStandWalk(actionData);
				_weapon.start();
				if(_activeAction!=TypeAction.Dead)
				{
					play(_activeAction,_activeDirection,true,null,null,true);
				}
				else  /// dead 
				{
					stayDead(_activeDirection);
				}
			}
			else 
			{
				if(_weapon)		_weapon.initEffectStandWalk(null);
			}
		}
		
		/**更新 武器战斗
		 */
		public function updateWeaponEffectFight(actionData:ATFActionData):void
		{
			if(actionData)
			{
				if(!_weapon)
				{
					createWeapon();
				}
				_weapon.initEffectFight(actionData);
			}
			else  
			{
				if(_weapon)		_weapon.initEffectFight(null);
			}
		}
		
		
		/**更新武器战斗
		 */
		public function updateWeaponEffectInjureDead(actionData:ATFActionData):void
		{
			if(actionData)
			{
				if(!_weapon)
				{
					createWeapon();
				}
				_weapon.initEffectInjureDead(actionData);
			}
			else  
			{
				if(_weapon)		_weapon.initEffectInjureDead(null);
			}
		}
		
		
		/**武器特殊攻击动作1  光效
		 */		
		public function updateWeaponEffectAtk_1(actionData:ATFActionData):void
		{
			if(actionData)
			{
				if(!_weapon)
				{
					createWeapon();
				}
				_weapon.initEffectAtk_1(actionData);
			}
			else  
			{
				if(_weapon)		_weapon.initEffectAtk_1(null);
			}
		}
		/**武器战斗待机   光效
		 */		
		public function updateWeaponEffectFightStand(actionData:ATFActionData):void
		{
			if(actionData)
			{
				if(!_weapon)
				{
					createWeapon();
				}
				_weapon.initEffectFightStand(actionData);
			}
			else  
			{
				if(_weapon)		_weapon.initEffectFightStand(null);
			}
		}
		/**更新翅膀
		 * @param actionData
		 */		
		public function updateWingStandWalk(actionData:ATFActionData):void
		{
			if(actionData) ///穿上翅膀
			{
				_canSwapIndex=true;
				if(!_wing)
				{
					createWing();
				}
				if(!contains(DisplayObject2D(_wing.mainClip)))
				{
					addChildAt(DisplayObject2D(_wing.mainClip),0);
					_guideShadowContainer.addChildAt(_wing.shadowClip,0);
					_reflectionContainer.addChildAt(DisplayObject2D(_wing.reflectionClip),0);
				}
				_wing.initActionDataWalkStand(actionData);
				_wing.start();
				if(_activeAction!=TypeAction.Dead)
				{
					play(_activeAction,_activeDirection,true,null,null,true);
				}
				else  /// dead 
				{
					stayDead(_activeDirection);
				}
			}
			else 
			{
				if(_wing)
				{
					if(contains(DisplayObject2D(_wing.mainClip)))
					{
						removeChild(DisplayObject2D(_wing.mainClip));
						_guideShadowContainer.removeChild(_wing.shadowClip);
						_reflectionContainer.removeChild(DisplayObject2D(_wing.reflectionClip));
					}
					_wing.initActionDataWalkStand(null);
					_wing.resetData();
					_wing.stop();
				}
			}
		}
		
		public function updateWingFight(actionData:ATFActionData):void
		{
			if(actionData)
			{
				if(!_wing)
				{
					createWing();
				}
				_wing.initActionDataFight(actionData);
			}
			else 
			{
				if(_wing)_wing.initActionDataFight(null);
			}

		}

		
		public function updateWingInjureDead(actionData:ATFActionData):void
		{
			if(actionData)
			{
				if(!_wing)
				{
					createWing();
				}
				_wing.initActionDataInjureDead(actionData);
			}
			else 
			{
				if(_wing)_wing.initActionDataInjureDead(null);
			}
		}
		
		/**翅膀特殊攻击动作1
		 */		
		public function updateWingAtk_1(actionData:ATFActionData):void
		{
			if(actionData)
			{
				if(!_wing)
				{
					createWing();
				}
				_wing.initActionDataAtk_1(actionData);
			}
			else 
			{
				if(_wing)_wing.initActionDataAtk_1(null);
			}
		}
		/**翅膀战斗待机
		 */		
		public function updateWingFightStand(actionData:ATFActionData):void
		{
			if(actionData)
			{
				if(!_wing)
				{
					createWing();
				}
				_wing.initActionDataFightStand(actionData);
			}
			else 
			{
				if(_wing)_wing.initActionDataFightStand(null);
			}
		}
		
		/**更新坐骑头部
		 */		
		public function updateMountHead(actionData:ATFActionData):void
		{
			if(actionData) ///穿上坐骑
			{
				_canSwapIndex=true;
				if(!_mountHead)
				{
					createMountHead();
				}
				if(!contains(DisplayObject2D(_mountHead.mainClip))) 
				{
					addChildAt(DisplayObject2D(_mountHead.mainClip),0);
					shadowContainer.addChildAt(_mountHead.shadowClip,0);
					_reflectionContainer.addChildAt(DisplayObject2D(_mountHead.reflectionClip),0);
				}
				_mountHead.initActionDataWalkStand(actionData);
				_mountHead.start();
				if(_activeAction!=TypeAction.Dead)
				{
					play(_activeAction,_activeDirection,true,null,null,true);
				}
				else  /// dead 
				{
					stayDead(_activeDirection);
				}
				MountHeadPart(_mountHead.mainClip).startGuide();
				reLocateBloodNameByMountHead();
			}
			else 
			{
				if(_mountHead)
				{
					if(contains(DisplayObject2D(_mountHead.mainClip))) 
					{
						removeChild(DisplayObject2D(_mountHead.mainClip));
						shadowContainer.removeChild(_mountHead.shadowClip);
						_reflectionContainer.removeChild(DisplayObject2D(_mountHead.reflectionClip));
					}
					_mountHead.initActionDataWalkStand(null);
					_mountHead.resetData();
					_mountHead.stop();
					stopGuideBody();
				}
			}
		}
		
		/**设置冒泡的坐标
		 */		
		override protected function setChatArrowPos():void
		{
			var size:Point=getSkinSize()
			_chatArrow.y=-size.y;
			var mountHeadIndex:int=-1;
			if(_mountHead)mountHeadIndex=getChildIndex(DisplayObject2D(_mountHead.mainClip));
			if(mountHeadIndex==-1) //如果不在坐骑上
			{
				if(_cloth.actionDataStandWalk)_chatArrow.y=_cloth.actionDataStandWalk.getBlood().y-25;
			}
			else 
			{
				if(_mountHead.actionDataStandWalk)_chatArrow.y=_mountHead.actionDataStandWalk.getBlood().y-25;
			}
		}

		/**设置颜色值
		 */		
		override protected function setColorMatrix(colortransform:ColorTransform):void
		{
			
			super.setColorMatrix(colortransform);
			if(!isDispose)
			{
				if(_weapon)DisplayObject2D(	_weapon.mainClip).localColorTransform=colortransform;
				if(_wing)DisplayObject2D(_wing.mainClip).localColorTransform=colortransform;
				if(_mountHead)DisplayObject2D(_mountHead.mainClip).localColorTransform=colortransform;
			}
		}
		/**
		 * @param isHitMove  只有怪物使用 向后击退
		 */		
		override public function play(action:int,direction:int=-1,loop:Boolean=true,completeFunc:Function=null,completeParam:Object=null,resetPlay:Boolean=false,isHitMove:Boolean=false):void
		{
			var istrigger:Boolean=true;
			
			//当上一次处于 攻击状态     现在要立刻播放受击时候 需要进行忽略
			if(action==TypeAction.Injure&&(_activeAction==TypeAction.Attack||_activeAction==TypeAction.SpecialAtk_1))  
			{
				istrigger=false;
			}
			if(istrigger)
			{
				initInjureEffect(action,direction,isHitMove);
				if(_activeDirection!=direction&&direction!=-1)
				{
					_canSwapIndex=true;//方向发生改变了  可以设置层级  
				}
				if(direction==-1)	direction=_activeDirection;
				_activeAction=action;
				_activeDirection=direction;
				
				if(action==TypeAction.Dead)
				{
					_activeDirection=TypeDirection.Down ;///人物模型死亡动作 只有1 个方向是朝下的
				}

//				if(YF2dActionData.isUsableActionData(_cloth.actionDataStandWalk))
//				{
					_cloth.play(action,direction,loop,completeFunc,completeParam,resetPlay);
//				}
				///武器没有死亡动作
				if(_weapon)
				{
					if(action!=TypeAction.Dead)
					{
//						if(YF2dActionData.isUsableActionData(_weapon.actionDataStandWalk))
//						{
							_weapon.play(action,direction,loop,null,null,resetPlay);
//						}
						_weapon.visible=true;
					}
					else 
					{
						_weapon.visible=false;
						_weapon.pureStop();
					}
				}
//				if(_wing&&YF2dActionData.isUsableActionData(_wing.actionDataStandWalk))
				if(_wing)
				{
					_wing.play(action,direction,loop,null,null,resetPlay);
				}
//				if(_mountHead&&YF2dActionData.isUsableActionData(_mountHead.actionDataStandWalk)) //在坐骑上
				if(_mountHead) //在坐骑上
				{
					_mountHead.play(action,direction,loop,null,null,resetPlay);
					//					if(_weapon.actionData)	setMount2Index(direction);   //坐骑由两部分组成
					//					else setMount1Index();		//坐骑由一部分组成
				}
				
				
				//设置层级关系
				if(_canSwapIndex)  //湿热之层级关系
				{
					setAllObjectIndex();
				}
			}
		}
		
		override public function playDefault(loop:Boolean=true, completeFunc:Function=null,completeParam:Object=null,resetPlay:Boolean=true):void
		{
			var actionData:ATFActionData;
			if(_cloth.actionDataStandWalk) actionData=_cloth.actionDataStandWalk;
			else if(_weapon.actionDataStandWalk)actionData=_weapon.actionDataStandWalk;
			else if(_wing.actionDataStandWalk)actionData=_wing.actionDataStandWalk;
			else if(_mountHead.actionDataStandWalk)actionData=_mountHead.actionDataStandWalk;
			if(actionData)
			{
				var action:int=actionData.getActionArr()[0];
				var direction:int=actionData.getDirectionArr(action)[0];
				play(action,direction,loop,completeFunc,completeParam,resetPlay);
			}
		}
		override public  function gotoAndStop(action:int,direction:int,frameIndex:int):void
		{
			switch(action)
			{
				case TypeAction.Stand:
				case TypeAction.Walk:
					if(_cloth.actionDataStandWalk)	_cloth.gotoAndStop(frameIndex,action,direction);
					if(_weapon)
					{
						if(action!=TypeAction.Dead) 
						{
							_weapon.visible=true;
							if(_weapon.actionDataStandWalk)_weapon.gotoAndStop(frameIndex,action,direction);
						}
						else _weapon.visible=false;
					}
					if(_wing&&_wing.actionDataStandWalk) _wing.gotoAndStop(frameIndex,action,direction);
					if(_mountHead&&_mountHead.actionDataStandWalk) _mountHead.gotoAndStop(frameIndex,action,direction);
					break;
				case TypeAction.Injure:
				case TypeAction.Dead:
					if(_cloth.actionDataInjureDead)	_cloth.gotoAndStop(frameIndex,action,direction);
					if(_weapon)
					{
						if(action!=TypeAction.Dead) 
						{
							_weapon.visible=true;
							if(_weapon.actionDataInjureDead)_weapon.gotoAndStop(frameIndex,action,direction);
						}
						else _weapon.visible=false;
					}
					if(_wing&&_wing.actionDataInjureDead) _wing.gotoAndStop(frameIndex,action,direction);
					if(_mountHead&&_mountHead.actionDataInjureDead) _mountHead.gotoAndStop(frameIndex,action,direction);
					break;
				case TypeAction.Attack:
					if(_cloth.actionDataFight)	_cloth.gotoAndStop(frameIndex,action,direction);
					if(_weapon)
					{
						if(action!=TypeAction.Dead) 
						{
							_weapon.visible=true;
							if(_weapon.actionDataFight)_weapon.gotoAndStop(frameIndex,action,direction);
						}
						else _weapon.visible=false;
					}
					if(_wing&&_wing.actionDataFight) _wing.gotoAndStop(frameIndex,action,direction);
					if(_mountHead&&_mountHead.actionDataFight) _mountHead.gotoAndStop(frameIndex,action,direction);
					break;
			}
		}
		
		override public function stayDead(direction:int=-1):void
		{
			_activeAction=TypeAction.Dead;
//			isDead=true;
			updateHp();
			//死亡只有一个动作
			if(_cloth.actionDataInjureDead)
			{
				direction=_cloth.actionDataInjureDead.getDirectionArr(TypeAction.Dead)[0];
				var index:int=_cloth.actionDataInjureDead.getDirectionLen(TypeAction.Dead,direction)-1;
				gotoAndStop(TypeAction.Dead,direction,index);
			}
		}
		
		/** 瞬移层 数据初始化
		 */		
		override protected function initBlinkPlayerData(player:BlinkPlayer):void
		{
			var waponData:ATFActionData;
			if(_weapon)
			{
				waponData=_weapon.actionDataStandWalk;
			}
			var wingData:ATFActionData;
			if(_wing)
			{
				wingData=_wing.actionDataStandWalk;
			}
			var mountHeadData:ATFActionData;
			if(_mountHead)
			{
				mountHeadData=_mountHead.actionDataStandWalk;
			}
			player.initData(_cloth.actionDataStandWalk,waponData,wingData,mountHeadData);
		}
		

		
		/**人物 数据
		 */		
		public function getWeaponWalkStand():ATFActionData
		{
			if(_weapon)
			{
				return _weapon.actionDataStandWalk;
			}
			return null;
		}
		/**人物 受伤 死亡数据
		 */
		public function getWeaponInjureDead():ATFActionData
		{
			if(_weapon)
			{
				return _weapon.actionDataInjureDead;
			}
			return null;
		}
		
		/**人物战斗数据
		 */
		public function getWeaponFight():ATFActionData
		{
			if(_weapon)
			{
				return _weapon.actionDataFight;
			}
			return null;
		}
		
		/**人物战斗待机数据
		 */
		public function getWeaponFightStand():ATFActionData
		{
			if(_weapon)
			{
				return _weapon.actionDataFightStand;
			}
			return null;
		}
		
		/**人物特殊攻击数据
		 */
		public function getWeaponAtk_1():ATFActionData
		{
			if(_weapon)
			{
				return _weapon.actionDataAtk_1;
			}
			return null;
		}
		

		/**人物 数据
		 */		
		public function getWingWalkStand():ATFActionData
		{
			if(_wing)
			{
				return _wing.actionDataStandWalk;
			}
			return null;
		}
		/**人物 受伤 死亡数据
		 */
		public function getWingInjureDead():ATFActionData
		{
			if(_wing)
			{
				return _wing.actionDataInjureDead;
			}
			return null;
		}
		
		/**人物战斗数据
		 */
		public function getWingFight():ATFActionData
		{
			if(_wing)
			{
				return _wing.actionDataFight;
			}
			return null;
		}
		
		/**人物战斗待机数据
		 */
		public function getWingFightStand():ATFActionData
		{
			if(_wing)
			{
				return _wing.actionDataFightStand;
			}
			return null;
		}
		
		/**人物特殊攻击数据
		 */
		public function getWingAtk_1():ATFActionData
		{
			if(_wing)
			{
				return _wing.actionDataAtk_1;
			}
			return null;
		}
		
		
		/**人物 数据
		 */		
		public function getWeaponEffectWalkStand():ATFActionData
		{
			if(_weapon)
			{
				return _weapon.effectStandWalk;
			}
			return null;
		}
		/**人物 受伤 死亡数据
		 */
		public function getWeaponEffectInjureDead():ATFActionData
		{
			if(_weapon)
			{
				return _weapon.effectInjureDead;
			}
			return null;
		}
		
		/**人物战斗数据
		 */
		public function getWeaponEffectFight():ATFActionData
		{
			if(_weapon)
			{
				return _weapon.effectFight;
			}
			return null;
		}
		
		/**人物战斗待机数据
		 */
		public function getWeaponEffectFightStand():ATFActionData
		{
			if(_weapon)
			{
				return _weapon.effectFightStand;
			}
			return null;
		}
		
		/**人物特殊攻击数据
		 */
		public function getWeaponEffectAtk_1():ATFActionData
		{
			if(_weapon)
			{
				return _weapon.effectAtk_1;
			}
			return null;
		}
		
		/**人物 数据
		 */		
		public function getClothEffectWalkStand():ATFActionData
		{
			return _cloth.effectStandWalk;
		}
		/**人物 受伤 死亡数据
		 */
		public function getClothEffectInjureDead():ATFActionData
		{
			return _cloth.effectInjureDead;
		}
		
		/**人物战斗数据
		 */
		public function getClothEffectFight():ATFActionData
		{
			return _cloth.effectFight;
		}
		
		/**人物战斗待机数据
		 */
		public function getClothEffectFightStand():ATFActionData
		{
			return _cloth.effectFightStand;
		}
		
		/**人物特殊攻击数据
		 */
		public function getClothEffectAtk_1():ATFActionData
		{
			return _cloth.effectAtk_1;
		}
		
	
		/**设置所有部件的层级关系      地面上  武器在人的上层   
		 */		
		private function setAllObjectIndex():void
		{
			_canSwapIndex=false;
			var clothIndex:int=getChildIndex(DisplayObject2D(_cloth.mainClip));
			var wingIndex:int=-1;
			if(_wing)wingIndex=getChildIndex(DisplayObject2D(_wing.mainClip));
			var weaponIndex:int=-1;
			if(_weapon)weaponIndex=getChildIndex(DisplayObject2D(_weapon.mainClip))
			var mountHeadIndex:int=-1;
			if(_mountHead)	mountHeadIndex=getChildIndex(DisplayObject2D(_mountHead.mainClip));
			if(mountHeadIndex==-1)   //不再坐骑上
			{
				if(wingIndex==-1) //没有翅膀
				{
					//武器始终在人上面
					if(weaponIndex!=-1) //如果武器存在
					{
						if(weaponIndex<clothIndex)  //武器在下层  则将武器放到上层 
						{
							swapChildren(DisplayObject2D(_weapon.mainClip),DisplayObject2D(_cloth.mainClip));
							_reflectionContainer.swapChildren(DisplayObject2D(_weapon.reflectionClip),DisplayObject2D(_cloth.reflectionClip));
						}
					}
				}
				else   //有翅膀
				{
					//武器始终在人上面
					if(weaponIndex!=-1) //如果武器存在
					{
						if(weaponIndex<clothIndex)  //武器在下层  则将武器放到上层 
						{
							swapChildren(DisplayObject2D(_weapon.mainClip),DisplayObject2D(_cloth.mainClip));
							_reflectionContainer.swapChildren(DisplayObject2D(_weapon.reflectionClip),DisplayObject2D(_cloth.reflectionClip));
							weaponIndex=clothIndex;
							clothIndex=getChildIndex(DisplayObject2D(_cloth.mainClip));
						}
						//处理   翅膀   翅膀 
						if(_activeDirection==TypeDirection.Up||_activeDirection==TypeDirection.LeftUp||_activeDirection==TypeDirection.RightUp) //翅膀在最上层
//						if(_activeDirection==TypeDirection.Up||_activeDirection==TypeDirection.LeftUp||_activeDirection==TypeDirection.RightUp||_activeDirection==TypeDirection.Left||_activeDirection==TypeDirection.Right) //翅膀在最上层
						{
							if(wingIndex<weaponIndex) //如果翅膀在 衣服下层
							{
//								swapChildren(DisplayObject2D(_wing.mainClip),DisplayObject2D(_weapon.mainClip));
//								_reflectionContainer.swapChildren(DisplayObject2D(_wing.reflectionClip),DisplayObject2D(_weapon.reflectionClip));
								setChildIndex(DisplayObject2D(_wing.mainClip),weaponIndex);
								_reflectionContainer.setChildIndex(DisplayObject2D(_wing.reflectionClip),weaponIndex);
							}
						}
						else //翅膀在最下层  
						{
							if(clothIndex<wingIndex) //如果翅膀在 衣服下层
							{
								swapChildren(DisplayObject2D(_wing.mainClip),DisplayObject2D(_cloth.mainClip));
								_reflectionContainer.swapChildren(DisplayObject2D(_wing.reflectionClip),DisplayObject2D(_cloth.reflectionClip));
								clothIndex=wingIndex;
							}
							if(weaponIndex<clothIndex)  //武器在下层  则将武器放到上层 
							{
//								swapChildren(DisplayObject2D(_weapon.mainClip),DisplayObject2D(_cloth.mainClip));
//								_reflectionContainer.swapChildren(DisplayObject2D(_weapon.reflectionClip),DisplayObject2D(_cloth.reflectionClip));
								setChildIndex(DisplayObject2D(_weapon.mainClip),clothIndex);
								_reflectionContainer.setChildIndex(DisplayObject2D(_weapon.reflectionClip),clothIndex);
							}
//							if(weaponIndex>wingIndex)  //武器在下层  则将武器放到上层 
//							{
////								swapChildren(DisplayObject2D(_weapon.mainClip),DisplayObject2D(_cloth.mainClip));
////								_reflectionContainer.swapChildren(DisplayObject2D(_weapon.reflectionClip),DisplayObject2D(_cloth.reflectionClip));
//								setChildIndex(DisplayObject2D(_weapon.mainClip),wingIndex);
//								_reflectionContainer.setChildIndex(DisplayObject2D(_weapon.reflectionClip),wingIndex);
//							}
						}
					}
					else    //武器不存在
					{
						//处理   翅膀   翅膀 
						if(_activeDirection==TypeDirection.Up||_activeDirection==TypeDirection.LeftUp||_activeDirection==TypeDirection.RightUp) //翅膀在最上层
//						if(_activeDirection==TypeDirection.Up||_activeDirection==TypeDirection.LeftUp||_activeDirection==TypeDirection.RightUp||_activeDirection==TypeDirection.Left||_activeDirection==TypeDirection.Right) //翅膀在最上层
						{
							if(wingIndex<clothIndex) //如果翅膀在 衣服下层
							{
								swapChildren(DisplayObject2D(_wing.mainClip),DisplayObject2D(_cloth.mainClip));
								_reflectionContainer.swapChildren(DisplayObject2D(_wing.reflectionClip),DisplayObject2D(_cloth.reflectionClip));
							}
						}
						else //翅膀在最下层  
						{
							if(wingIndex>clothIndex) //如果翅膀在 衣服下层
							{
								swapChildren(DisplayObject2D(_wing.mainClip),DisplayObject2D(_cloth.mainClip));
								_reflectionContainer.swapChildren(DisplayObject2D(_wing.reflectionClip),DisplayObject2D(_cloth.reflectionClip));
							}
						}
					}
				}
			}
			else  ///如果在坐骑上 
			{
				if(wingIndex==-1) //没有翅膀
				{
					//武器始终在人上面
					if(weaponIndex!=-1) //如果 为 2  个坐骑
					{
						if(_activeDirection==TypeDirection.Up||_activeDirection==TypeDirection.LeftUp||_activeDirection==TypeDirection.RightUp)//头在下面     躯干  在上面  ，  人物 在最上面 
						{
							if(mountHeadIndex>weaponIndex)  //如果 头部在躯干上面 则进行交换
							{
								swapChildren(DisplayObject2D(_mountHead.mainClip),DisplayObject2D(_weapon.mainClip));
								_reflectionContainer.swapChildren(DisplayObject2D(_mountHead.reflectionClip),DisplayObject2D(_weapon.reflectionClip));
								weaponIndex=mountHeadIndex;  //
							}
//							if(clothIndex>weaponIndex)  ///大翅膀坐骑配置				  //此处分两种 情况 一种是待翅膀的大坐骑 一种是 不带翅膀的 普通坐骑
//							if(clothIndex<weaponIndex)   //不带翅膀的配置
							if(_mountHead.actionDataStandWalk)
							{
								if(_mountHead.actionDataStandWalk.isWingMount()) //大翅膀坐骑
								{
									if(clothIndex>weaponIndex)
									{
										setChildIndex(DisplayObject2D(_cloth.mainClip),weaponIndex);
										_reflectionContainer.setChildIndex(DisplayObject2D(_cloth.reflectionClip),weaponIndex);
									}
								}
								else //不是大翅膀
								{
									if(clothIndex<weaponIndex)   //不带翅膀的配置
									{
										setChildIndex(DisplayObject2D(_cloth.mainClip),weaponIndex);
										_reflectionContainer.setChildIndex(DisplayObject2D(_cloth.reflectionClip),weaponIndex);
									}
								}
							}
						}
						else //头在前面   头在最上层        人在第二层    身体 weapon在最下层
						{
							if(weaponIndex>clothIndex) //如果 坐骑躯干在上面
							{
								swapChildren(DisplayObject2D(_cloth.mainClip),DisplayObject2D(_weapon.mainClip));
								_reflectionContainer.swapChildren(DisplayObject2D(_cloth.reflectionClip),DisplayObject2D(_weapon.reflectionClip));
								clothIndex=weaponIndex;  //
							}
							if(clothIndex>mountHeadIndex) //坐骑头向前插入
							{
								setChildIndex(DisplayObject2D(_mountHead.mainClip),clothIndex);
								_reflectionContainer.setChildIndex(DisplayObject2D(_mountHead.reflectionClip),clothIndex);
							}
						}
					}
					else  //坐骑    单一坐骑      人物  始终在最上面       cloth 在最上面   mountHead 在最下面
					{
						if(clothIndex<mountHeadIndex)  //交换 衣服 和  头
						{
							swapChildren(DisplayObject2D(_cloth.mainClip),DisplayObject2D(_mountHead.mainClip));
							_reflectionContainer.swapChildren(DisplayObject2D(_cloth.reflectionClip),DisplayObject2D(_mountHead.reflectionClip));
						}
					}
				}
				else   //有翅膀
				{
					//武器始终在人上面
					if(weaponIndex!=-1) //如果 为 2  个坐骑
					{
						if(_activeDirection==TypeDirection.LeftUp||_activeDirection==TypeDirection.RightUp||_activeDirection==TypeDirection.Up)//头在下面     躯干  在上面  ，  人物 在最上面   //翅膀在最上层
						{
							if(mountHeadIndex>weaponIndex)  //如果 头部在躯干上面 则进行交换
							{
								swapChildren(DisplayObject2D(_mountHead.mainClip),DisplayObject2D(_weapon.mainClip));
								_reflectionContainer.swapChildren(DisplayObject2D(_mountHead.reflectionClip),DisplayObject2D(_weapon.reflectionClip));
								weaponIndex=mountHeadIndex;  //
							}

//							if(clothIndex>weaponIndex)  ///大翅膀坐骑配置				  //此处分两种 情况 一种是待翅膀的大坐骑 一种是 不带翅膀的 普通坐骑
//							if(clothIndex<weaponIndex)   //不带翅膀的配置
							if(_mountHead.actionDataStandWalk)
							{
								if(_mountHead.actionDataStandWalk.isWingMount()) //大翅膀坐骑
								{
									if(clothIndex>weaponIndex)
									{
										setChildIndex(DisplayObject2D(_cloth.mainClip),weaponIndex);
										_reflectionContainer.setChildIndex(DisplayObject2D(_cloth.reflectionClip),weaponIndex);
									}
								}
								else //不是大翅膀
								{
									if(clothIndex<weaponIndex)   //不带翅膀的配置
									{
										setChildIndex(DisplayObject2D(_cloth.mainClip),weaponIndex);
										_reflectionContainer.setChildIndex(DisplayObject2D(_cloth.reflectionClip),weaponIndex);
									}
								}
								clothIndex=weaponIndex;
							}
							///处理翅膀
							if(wingIndex<clothIndex) //如果翅膀在 衣服下层  ,将翅膀放到最上层
							{
								setChildIndex(DisplayObject2D(_wing.mainClip),clothIndex);
								_reflectionContainer.setChildIndex(DisplayObject2D(_wing.reflectionClip),clothIndex);
							}
						}
						
						else //头在前面           人在第二层    身体 weapon在最下层   			  翅膀在人物下层
						{
							if(weaponIndex>clothIndex) //如果 坐骑躯干在上面
							{
								swapChildren(DisplayObject2D(_cloth.mainClip),DisplayObject2D(_weapon.mainClip));
								_reflectionContainer.swapChildren(DisplayObject2D(_cloth.reflectionClip),DisplayObject2D(_weapon.reflectionClip));
								clothIndex=weaponIndex;  //
								weaponIndex=getChildIndex(DisplayObject2D(_weapon.mainClip));
							}
							if(clothIndex>mountHeadIndex) //坐骑头向前插入
							{
								setChildIndex(DisplayObject2D(_mountHead.mainClip),clothIndex);
								_reflectionContainer.setChildIndex(DisplayObject2D(_mountHead.reflectionClip),clothIndex);
								clothIndex=mountHeadIndex;
							}
							if(wingIndex>clothIndex) //  如果翅膀在衣服上层
							{
								setChildIndex(DisplayObject2D(_wing.mainClip),clothIndex);
								_reflectionContainer.setChildIndex(DisplayObject2D(_wing.reflectionClip),clothIndex);
								wingIndex=clothIndex;
							}
							if(wingIndex<weaponIndex)//如果翅膀在 躯干下层      将翅膀放到 躯干上层
							{
								setChildIndex(DisplayObject2D(_wing.mainClip),weaponIndex);
								_reflectionContainer.setChildIndex(DisplayObject2D(_wing.reflectionClip),weaponIndex);
							}
						}
					}
					else  //单一 坐骑 
					{
						if(clothIndex<mountHeadIndex)  //交换 衣服 和  头
						{
							swapChildren(DisplayObject2D(_cloth.mainClip),DisplayObject2D(_mountHead.mainClip));
							_reflectionContainer.swapChildren(DisplayObject2D(_cloth.reflectionClip),DisplayObject2D(_mountHead.reflectionClip));
							clothIndex=mountHeadIndex;
						}
						if(_activeDirection==TypeDirection.Up||_activeDirection==TypeDirection.LeftUp||_activeDirection==TypeDirection.RightUp)//坐骑在最下层   衣服在第二层 ，  翅膀在最上层
//						if(_activeDirection==TypeDirection.Up||_activeDirection==TypeDirection.LeftUp||_activeDirection==TypeDirection.RightUp||_activeDirection==TypeDirection.Left||_activeDirection==TypeDirection.Right) //翅膀在最上层
						{
							if(wingIndex<clothIndex)
							{
								setChildIndex(DisplayObject2D(_wing.mainClip),clothIndex);
								_reflectionContainer.setChildIndex(DisplayObject2D(_wing.reflectionClip),clothIndex);
							}
						}
						else ///坐骑在最下层   衣服在第二层   翅膀在最  衣服前面一层
						{
							if(wingIndex>clothIndex)
							{
								setChildIndex(DisplayObject2D(_wing.mainClip),clothIndex);
								_reflectionContainer.setChildIndex(DisplayObject2D(_wing.reflectionClip),clothIndex);
							}
						}
					} 
					
				}
			} 
			
			//设置buff层级
			setDownBuffEffectIndex();
		}
		override protected function disposeCloth():void
		{
//			Part2dCombinePool.toPart2dCombineWingPool(_cloth);//释放到对象池
			Part2dCombinePool.toPart2dCombineClothPool(_cloth);//释放到对象池

		}
		override public function dispose(childrenDispose:Boolean=true):void
		{
//			if(_weapon)	_weapon.dispose();
//			if(_wing)_wing.dispose();
//			if(_mountHead)_mountHead.dispose();
			if(_weapon)	
			{
				Part2dCombinePool.toPart2dCombineWeaponPool(_weapon);
			}
			if(_wing)
			{
				Part2dCombinePool.toPart2dCombineWingPool(_wing);
			}
			if(_mountHead)
			{
				Part2dCombinePool.toPart2dCombineMountHeadPool(_mountHead);
			}
			super.dispose(childrenDispose);
			_weapon=null;
			_wing=null;
			_mountHead=null;
			//			_bodyShadowContainer=null;
			//			_reflectionBodyContainer=null;
			//			_bodyContainer=null;
		}
		
		
		
		/**@override    更新系统配置  子类重写
		 */		
		override public function updateSystemConfig():void
		{
			_bloodMC.visible=!SystemConfigManager.shieldHp;  //隐藏血条
			if(_tittleClip)			//隐藏玩家称号
			{
				_tittleClip.visible=SystemConfigManager.showTitle;   
			}
			_cloth.visible=!SystemConfigManager.shieldOtherHero;			//隐藏其他玩家玩家
			if(_weapon)  
			{
				_weapon.visible=!SystemConfigManager.shieldOtherHero;
			}
			if(_mountHead)
			{
				_mountHead.visible=!SystemConfigManager.shieldOtherHero;
			}
			if(_wing)
			{
				_wing.visible=!SystemConfigManager.shieldOtherHero;
			}
		}

		
		
		
	}
}