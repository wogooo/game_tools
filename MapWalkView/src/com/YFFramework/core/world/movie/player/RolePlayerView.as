package com.YFFramework.core.world.movie.player
{
	/**   角色动画类
	 * @author yefeng
	 *2012-4-20下午9:41:45
	 */
	
	import com.YFFramework.core.center.pool.IPool;
	import com.YFFramework.core.ui.movie.data.TypeAction;
	import com.YFFramework.core.ui.res.CommonFla;
	import com.YFFramework.core.ui.yf2d.data.YF2dActionData;
	import com.YFFramework.core.ui.yf2d.view.avatar.BodyView2D;
	import com.YFFramework.core.ui.yf2d.view.avatar.RolePart2DView;
	import com.YFFramework.core.world.model.RoleDyVo;
	
	import flash.geom.ColorTransform;
	
	//翅膀最上层   其实是 武器 再是 人物
	public class RolePlayerView extends PlayerView
	{
		/** 武器    左手武器
		 */
		private var _weapon:RolePart2DView;
		
//		private var _head:RolePart2DView;
		/**翅膀
		 */
		private var _wing:RolePart2DView;
//		/**盾牌  右手武器
//		 */		
//		private var _shield:RolePart2DView;
		
		
		
		/**  管理各个层级  处于上层特效层之间 下层特效层
		 */
	//	protected var bodyIndexArray:Array;
		
		
		public function RolePlayerView(roleDyVo:RoleDyVo=null)
		{
			super(roleDyVo);
		}
//		override protected function initUI():void
//		{
//			super.initUI();
//		}
		override protected function initEquipment():void
		{
			_cloth=new BodyView2D(); 
			_cloth.start();
			_cloth.setBitmapFrame(CommonFla.RoleFakeSkin,CommonFla.RoleFakeSkin.flashTexture,CommonFla.RoleFakeSkin.atlasData);////设置  默认皮肤
			_weapon=new RolePart2DView();
			_weapon.start();
			addChild(_cloth);
			addChild(_weapon);
		///人物头部
//			_head=new RolePart2DView();
//			_head.start();
//			addChild(_head);
//			///盾牌 
//			_shield=new RolePart2DView();
		//	addChild(_shield);
			///翅膀
			_wing=new RolePart2DView();
			addChild(_wing);
			_wing.start();
		}
		
		
		override protected function set glow(value:Boolean):void
		{
			super.glow=value;
			if(value)
			{
				_wing.colorTransform=SelectBodyColorTransform;
			}
			else 
			{
				_wing.colorTransform=DefaultColortransform;
			}
		}

		
		override protected function initRoleDyVo():void
		{
			_roleDyVo=new RoleDyVo();	
		}
		
		/**更新武器
		 */
		public function updateWeapon(actionData:YF2dActionData):void
		{
			if(actionData)
			{
				_weapon.initData(actionData);
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
				_weapon.initData(null);
				_weapon.resetData();
				_weapon.stop();
			}
		}
		/**更新翅膀
		 * @param actionData
		 */		
		public function updateWing(actionData:YF2dActionData):void
		{
			if(actionData) ///穿上翅膀
			{
				_wing.initData(actionData);
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
				_wing.initData(null);
				_wing.resetData();
				_wing.stop();
			}

		}


		
		
		/**重置皮肤为默认状态
		 */		
//		override public function resetSkin():void
//		{
//			super.resetSkin();
////			_weapon.initData(null);
//		}
		/**设置颜色值
		 */		
		override protected function setColorMatrix(colortransform:ColorTransform):void
		{
			super.setColorMatrix(colortransform);
			_weapon.colorTransform=colortransform;
			_wing.colorTransform=colortransform;
		}
		
		override public function play(action:int,direction:int=-1,loop:Boolean=true,completeFunc:Function=null,completeParam:Object=null,resetPlay:Boolean=false):void
		{
			initInjureEffect(action);
			if(direction==-1)	direction=_activeDirection;
			_activeAction=action;
			_activeDirection=direction;
			if(YF2dActionData.isUsableActionData(_cloth.actionData))
			{
				_cloth.play(action,direction,loop,completeFunc,completeParam,resetPlay);
			}
			///武器没有死亡动作
			if(action!=TypeAction.Dead)
			{
				if(YF2dActionData.isUsableActionData(_weapon.actionData))
				{
					_weapon.play(action,direction,loop,null,null,resetPlay);
				}
				_weapon.visible=true;
			}
			else 
			{
				_weapon.visible=false;
				_weapon.pureStop();
			}
			
			if(YF2dActionData.isUsableActionData(_wing.actionData))
			{
				_wing.play(action,direction,loop,null,null,resetPlay);
			}
//			if(YF2dActionData.isUsableActionData(_shield.actionData))
//			{
//				_head.play(action,direction,loop,null,null,resetPlay);
//			}

		}
		
		override public function playDefault(loop:Boolean=true, completeFunc:Function=null,completeParam:Object=null,resetPlay:Boolean=true):void
		{
			var actionData:YF2dActionData;
			if(_cloth.actionData) actionData=_cloth.actionData;
			else if(_weapon.actionData)actionData=_weapon.actionData;
			else if(_wing.actionData)actionData=_wing.actionData;
			if(actionData)
			{
				var action:int=actionData.getActionArr()[0];
				var direction:int=actionData.getDirectionArr(action)[0];
				play(action,direction,loop,completeFunc,completeParam,resetPlay);
			}
		}
		
		override public function stopPlay():void
		{
			super.stopPlay();
			_weapon.stop();
			_wing.stop();
		}
		
		override public function startPlay():void
		{
			super.startPlay();
			_weapon.start();
			_wing.start();
		}
		
		


		
		override public  function gotoAndStop(action:int,direction:int,frameIndex:int):void
		{
			if(_cloth.actionData)	_cloth.gotoAndStop(frameIndex,action,direction);
			if(action!=TypeAction.Dead) 
			{
				_weapon.visible=true;
				if(_weapon.actionData)_weapon.gotoAndStop(frameIndex,action,direction);
			}
			else _weapon.visible=false;
			if(_wing.actionData) _wing.gotoAndStop(frameIndex,action,direction);
//			if(_shield.actionData) _shield.gotoAndStop(frameIndex,action,direction);

//			_cloth.scaleX=scaleX;
//			_weapon.scaleX=scaleX;
		}
		
		override public function stayDead(direction:int=-1):void
		{
			_activeAction=TypeAction.Dead;
			isDead=true;
			updateHp();
//			if(direction==-1) direction=activeDirection;
			//死亡只有一个动作
			if(_cloth.actionData)
			{
				direction=_cloth.actionData.getDirectionArr(TypeAction.Dead)[0];
				var index:int=_cloth.actionData.getDirectionLen(TypeAction.Dead,direction)-1;
				gotoAndStop(TypeAction.Dead,direction,index);
			}
		}

		/** 瞬移层 数据初始化
		 */		
		override protected function initBlinkPlayerData(player:BlinkPlayer):void
		{
			player.initData(_cloth.actionData,_weapon.actionData,_wing.actionData);
		}

		
		/** 套装数据
		 */		
		public function get clothData():YF2dActionData
		{
			return _cloth.actionData;
		}
		/**套装数据
		 */		
		public function set clothData(value:YF2dActionData):void
		{
			_cloth.actionData=value;
		}
		/**武器数据
		 */		
		public function get weaponData():YF2dActionData
		{
			return _weapon.actionData;
		}
		/** 头部数据
		 */		
		public function get wingData():YF2dActionData
		{
			return _wing.actionData;
		}
		/**武器数据
		 */		
		public function set weaponData(value:YF2dActionData):void
		{
			_weapon.actionData=value;
		}

		/**是否在坐骑上    进行层级转化
		 */		
		public function swapIndex(isMount:Boolean):void
		{
		//	var index:int;
			var clothIndex:int=getChildIndex(_cloth);
			var weaponIndex:int=getChildIndex(_weapon);
			if(isMount)   ///套装在外层
			{
				if(clothIndex<weaponIndex) swapChildren(_cloth,_weapon);
			}
			else   //套装在内层 武器在外层
			{
				if(clothIndex<weaponIndex) swapChildren(_cloth,_weapon);
//				if(clothIndex>weaponIndex) swapChildren(_cloth,_weapon);
			}
		}
		
		
		override public function dispose(childrenDispose:Boolean=true):void
		{
			if(_weapon)
			{  
				removeChild(_weapon);
				_weapon.dispose();
			}
			if(_wing)
			{
				if(contains(_wing))	removeChild(_wing);
				_wing.dispose();
			}
//			if(_head)
//			{
//				if(contains(_head))	removeChild(_head);
//				_head.dispose();
//			}
			super.dispose(childrenDispose);
		}

		
		/////对象池管理-----------------------------------------
		/**重置初始状态
		 */		
		override public function reset():void
		{
			super.reset();
			if(_weapon) _weapon.stop();
			if(_wing)_wing.stop();
//			if(_shield) _shield.stop();

		}
		/**
		 * @param roleDyVo 为 RoleDyVo 类型
		 */		
		override public function constructor(roleDyVo:Object):IPool
		{
			super.constructor(roleDyVo);
			if(_weapon) _weapon.start();
			if(_wing) _wing.start();
			return this;
		}

		/**设置对象池个数
		 */		
		override protected function setPoolNum():void
		{
			regPool(10);
		}

	}
}