package com.YFFramework.core.world.movie.player
{
	/**   角色动画类
	 * @author yefeng
	 *2012-4-20下午9:41:45
	 */
	
	import com.YFFramework.core.center.pool.IPool;
	import com.YFFramework.core.debug.print;
	import com.YFFramework.core.ui.abs.AbsView;
	import com.YFFramework.core.ui.movie.BitmapEx;
	import com.YFFramework.core.ui.movie.BodyView;
	import com.YFFramework.core.ui.movie.RolePartView;
	import com.YFFramework.core.ui.movie.data.ActionData;
	import com.YFFramework.core.ui.movie.data.BitmapDataEx;
	import com.YFFramework.core.ui.movie.data.TypeAction;
	import com.YFFramework.core.ui.movie.data.TypeDirection;
	import com.YFFramework.core.world.mapScence.map.BgMapScrollport;
	import com.YFFramework.core.world.model.RoleDyVo;
	import com.YFFramework.core.world.movie.player.utils.DirectionUtil;
	
	import flash.events.Event;
	import flash.filters.BlurFilter;
	
	//翅膀最上层   其实是 武器 再是 人物
	public class RolePlayerView extends PlayerView
	{
		/** 武器
		 */
		protected var _weapon:RolePartView;
		/**翅膀
		 */
		protected var _wing:RolePartView;
		
		
		/**  人物进行瞬移 产生的多个人物的容器
		 */
		protected var _blinkLayer:AbsView;
		
		/**  管理各个层级  处于上层特效层之间 下层特效层
		 */
	//	protected var bodyIndexArray:Array;
		
		/** 人物瞬移 需要的变量
		 */		
		private var _filters:BlurFilter
		private var _blinkComplete:Function;
		private var _blinkCompleteParams:Object;
		private const constValue:int=25;
		private	const constValueX:int=20;
		private const constValueY:int=16;
		private const maxBodyNum:int=15;
		
		public function RolePlayerView(roleDyVo:RoleDyVo=null)
		{
			super(roleDyVo);
		}
		override protected function initUI():void
		{
			super.initUI();
			_filters=new BlurFilter(3,3);
		}
		override protected function initEquipment():void
		{
			_cloth=new BodyView(); 
			_cloth.start();
			addChild(_cloth);
			_weapon=new RolePartView();
			_weapon.start();
			//		wing=new RoleBaseView(true);
			addChild(_weapon);
			//		addChild(wing);
			
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
			play(_activeAction,_activeDirection,true,null,null,true);

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
		
		override public function play(action:int,direction:int=-1,loop:Boolean=true,completeFunc:Function=null,completeParam:Object=null,resetPlay:Boolean=false):void
		{
			if(direction==-1)	direction=_activeDirection;
			_activeAction=action;
			_activeDirection=direction;
			if(direction>5)
			{
				_cloth.scaleX=-1;
				switch(direction)
				{
					case TypeDirection.LeftDown:
						direction=TypeDirection.RightDown
						break;
					case TypeDirection.Left:
						direction=TypeDirection.Right;
						break;
					case TypeDirection.LeftUp:
						direction=TypeDirection.RightUp;
						break;
				}
			}
			else if(direction>0)
			{
				_cloth.scaleX=1;
			}
			if(_cloth.actionData)
			{
				_cloth.play(action,direction,loop,completeFunc,completeParam,resetPlay);
			}
			
			
			if(_weapon.actionData)
			{
				_weapon.scaleX=_cloth.scaleX;
				_weapon.play(action,direction,loop,null,null,resetPlay);
			}
			if(_wing)
			{
				_wing.scaleX=_cloth.scaleX;

				_wing.play(action,direction,loop,null,null,resetPlay);
			}
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
		
		
		
		
		
		
	
		/** 瞬移  创建多个  body 进行移动    bodyNum 是瞬移产生的影子个数    移动
		 */
		public function blinkMove(mapX:Number,mapY:Number,complete:Function=null,completeParams:Object=null):void
		{
		//	_teenBezier.dispose();
			var len:int=Math.sqrt(Math.pow(mapX-_roleDyVo.mapX,2)+Math.pow(mapY-_roleDyVo.mapY,2));
			print(this,"len",len);
			var bodyNum:int=int(len/BgMapScrollport.HeroWidth);
			if(bodyNum>maxBodyNum) bodyNum=maxBodyNum;

			_blinkComplete=complete;
			_blinkCompleteParams=completeParams;
			var direction:int=DirectionUtil.getDirection(_roleDyVo.mapX,_roleDyVo.mapY,mapX,mapY);
			if(_blinkLayer) _blinkLayer.dispose();
			if(!_blinkLayer)
			{
				_blinkLayer=new AbsView(false);
				addChild(_blinkLayer);
			}
			
		// 创	建瞬移产生的body 
			
			///取第三张图片 
			var spaceX:int;
			var spaceY:int;
			var lastX:int=0;
			var lastY:int=0;		
			var scaleX:int=1;
			switch(direction)
			{
				case TypeDirection.Up:
					spaceX=0;
					spaceY=constValue;///从上往下排列
					break;;
				case TypeDirection.RightUp:
					spaceX=-constValueX;
					spaceY=constValueY;
					break;
				case TypeDirection.Right:
					spaceX=-constValue;
					spaceY=0;
					break;
				case TypeDirection.RightDown:
					spaceX=-constValueX;
					spaceY=-constValueY;
					break;
				case TypeDirection.Down:
					spaceX=0;
					spaceY=-constValue;
					break;
				case TypeDirection.LeftDown:
					spaceX=constValueX;
					spaceY=-constValueY;
					scaleX=-1;
					direction=TypeDirection.RightDown;
					break;
				case TypeDirection.Left:
					spaceX=constValue;
					spaceY=0;
					scaleX=-1;
					direction=TypeDirection.Right;
					break;
				case TypeDirection.LeftUp:
					spaceX=constValueX;
					spaceY=constValueY;
					scaleX=-1;
					direction=TypeDirection.RightUp;
					break;

			}
			var frameIndex:int=3;//停留的帧
			var arr:Vector.<BitmapDataEx>=_cloth.actionData.getDirectionData(TypeAction.Walk,direction);
			var bitmapDataEx:BitmapDataEx=arr[frameIndex];
			var mc:BitmapEx;
			for(var i:int=0;i!=bodyNum;++i)
			{
				lastX +=spaceX;
				lastY +=spaceY;
				mc=new BitmapEx();
				_blinkLayer.addChild(mc);
				mc.setBitmapDataEx(bitmapDataEx);
				mc.scaleX=scaleX;
//				mc.pivotX=lastX;
//				mc.pivotY =lastY;
				mc.setPivotXY(lastX,lastY);
				mc.alpha=1.1-i/bodyNum
				mc.filters=[_filters];
			}
			var speed:int=25;
			gotoAndStop(TypeAction.Walk,direction,frameIndex,scaleX);
			moveTo(mapX,mapY,speed,blinkComplete);
	//		TweenLite.to(_roleDyVo,2,{mapX:mapX,mapY:mapY,onComplete:blinkComplete,onUpdate:blinkUpdate});
		}
		///瞬移结束
		private function blinkComplete(data:Object=null):void
		{
			_cloth.start();
			_weapon.start();
			play(TypeAction.Stand,_activeDirection,true,null,null,true);
			removeChild(_blinkLayer);
			_blinkLayer.dispose();
			_blinkLayer=null;
			if(_blinkComplete!=null)_blinkComplete(_blinkCompleteParams);
		}
		
		protected  function gotoAndStop(action:int,direction:int,frameIndex:int,scaleX:int):void
		{
			_cloth.gotoAndStop(frameIndex,action,direction);
			_weapon.gotoAndStop(frameIndex,action,direction);
			_cloth.scaleX=scaleX;
			_weapon.scaleX=scaleX;
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
			
			_filters=null;
			_blinkComplete=null;
			_blinkCompleteParams=null;
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
			regPool(50);
		}

	}
}