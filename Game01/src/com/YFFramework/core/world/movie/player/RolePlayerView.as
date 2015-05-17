package com.YFFramework.core.world.movie.player
{
	/**   角色动画类
	 * @author yefeng
	 *2012-4-20下午9:41:45
	 */
	
	import com.YFFramework.core.center.pool.IPool;
	import com.YFFramework.core.debug.print;
	import com.YFFramework.core.ui.movie.BodyView;
	import com.YFFramework.core.ui.movie.RolePartView;
	import com.YFFramework.core.ui.movie.data.ActionData;
	import com.YFFramework.core.ui.movie.data.TypeAction;
	import com.YFFramework.core.ui.movie.data.TypeDirection;
	import com.YFFramework.core.ui.res.CommonFla;
	import com.YFFramework.core.world.model.RoleDyVo;
	
	import flash.events.Event;
	
	//翅膀最上层   其实是 武器 再是 人物
	public class RolePlayerView extends PlayerView
	{
		/** 武器
		 */
		protected var _weapon:RolePartView;
		/**翅膀
		 */
		protected var _wing:RolePartView;
		
		
		
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
			_cloth=new BodyView(); 
			_cloth.start();
			_cloth.setBitmapDataEx(CommonFla.RoleFakeSkin);////设置  默认皮肤
			addChild(_cloth);
			_weapon=new RolePartView();
			_weapon.start();
			//		wing=new RoleBaseView(true);
			addChild(_weapon);
			//		addChild(wing);
			
		}
		
		override protected function initRoleDyVo():void
		{
			_roleDyVo=new RoleDyVo();	
		}
		

		
		
		/**更新翅膀
		 */
//		public function updateWing(actionData:ActionData):void
//		{
//			wing.initData(actionData);
//		}
//		/**脱去翅膀
//		 */
//		public function putOffWing():void
//		{
//		//	wing.stop();
//			removeChild(wing);
//			wing.dispose();
//			wing=null;
//		}
//		/** 脱去翅膀后需要 调用这个翅膀后才能调用  updateWing
//		 */		
//		public function startWing():void
//		{
//			wing=new RoleBaseView(false);
//			wing.start();
//			if(!contains(wing))addChildAt(wing,numChildren);///最上层
//		}
		
		/**更新武器
		 */
		public function updateWeapon(actionData:ActionData):void
		{
			_weapon.initData(actionData);
			if(_activeAction!=TypeAction.Dead)
			{
				play(_activeAction,_activeDirection,true,null,null,true);
			}
			else  /// dead 
			{
				stayDead(_activeDirection);
			}

		}
		/**脱去翅膀
		 */
		public function putOffWeapon():void
		{
			_weapon.stop();
			removeChild(_weapon);
		}
		/**当 脱去武器后  首先需要调用startWeapon  然后才能更新武器
		 */
		public function startWeapon():void
		{
	//		weapon=new RoleBaseView(false);
			_weapon.start();
			if(!contains(_weapon))
			{
				var bodyIndex:int=getChildIndex(_cloth);
				addChildAt(_weapon,bodyIndex+1);
			}
		}
		/**重置皮肤为默认状态
		 */		
		override public function resetSkin():void
		{
			super.resetSkin();
			_weapon.initData(null);
		}

		
		override public function play(action:int,direction:int=-1,loop:Boolean=true,completeFunc:Function=null,completeParam:Object=null,resetPlay:Boolean=false):void
		{
			if(direction==-1)	direction=_activeDirection;
			_activeAction=action;
			_activeDirection=direction;
			if(ActionData.isUsableActionData(_cloth.actionData))
			{
				
				_cloth.play(action,direction,loop,completeFunc,completeParam,resetPlay);
			}
			if(ActionData.isUsableActionData(_weapon.actionData))
			{
				_weapon.play(action,direction,loop,null,null,resetPlay);
			}
//			if(_wing)
//			{
//				_wing.play(action,direction,loop,null,null,resetPlay);
//			}
		}
		
		override public function playDefault(loop:Boolean=true, completeFunc:Function=null,completeParam:Object=null,resetPlay:Boolean=true):void
		{
			var actionData:ActionData;
			if(_cloth.actionData) actionData=_cloth.actionData;
			else if(_weapon.actionData)actionData=_weapon.actionData;
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
		}
		
		override public function startPlay():void
		{
			super.startPlay();
			_weapon.start();
		}
		
		


		
		override public  function gotoAndStop(action:int,direction:int,frameIndex:int):void
		{
			if(_cloth.actionData)	_cloth.gotoAndStop(frameIndex,action,direction);
			if(_weapon.actionData) _weapon.gotoAndStop(frameIndex,action,direction);
//			_cloth.scaleX=scaleX;
//			_weapon.scaleX=scaleX;
		}
		
		override public function stayDead(direction:int=-1):void
		{
			_activeAction=TypeAction.Dead;
			isDead=true;
			updateHp(0);
			if(direction==-1) direction=activeDirection;
			if(_cloth.actionData&&_weapon.actionData)
			{
				var index:int=_cloth.actionData.getDirectionLen(TypeAction.Dead,direction)-1;
				gotoAndStop(TypeAction.Dead,direction,index);
			}
		}

		
		/**瞬移层
		 */		
		override protected function removeBlinkLayer():void
		{
			if(contains(_blinkLayer))removeChild(_blinkLayer);
			_blinkLayer.disposeToPool();
			_blinkLayer=null;
			_cloth.start();
			_weapon.start();
	//		print(this,"cloth--start222-------");
		}
		
		
		/** 套装数据
		 */		
		public function get clothData():ActionData
		{
			return _cloth.actionData;
		}
		/**套装数据
		 */		
		public function set clothData(value:ActionData):void
		{
			_cloth.actionData=value;
		}
		/**武器数据
		 */		
		public function get weaponData():ActionData
		{
			return _weapon.actionData;
		}
		/**武器数据
		 */		
		public function set weaponData(value:ActionData):void
		{
			_weapon.actionData=value;
		}

		/**是否在坐骑上
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
				if(clothIndex>weaponIndex) swapChildren(_cloth,_weapon);
			}
		}
		
		
		override public function dispose(e:Event=null):void
		{
			if(_weapon)
			{  
				removeChild(_weapon);
				_weapon.dispose();
			}
			if(_wing)
			{
				removeChild(_wing);
				_wing.dispose();
			}
			super.dispose();
			
			//	weapon.dispose();
			//	wing.dispose();
		}

		
		/////对象池管理-----------------------------------------
		/**重置初始状态
		 */		
		override public function reset():void
		{
			super.reset();
			if(_weapon) _weapon.stop();

		}
		/**
		 * @param roleDyVo 为 RoleDyVo 类型
		 */		
		override public function constructor(roleDyVo:Object):IPool
		{
			super.constructor(roleDyVo);
			if(_weapon) _weapon.start();
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