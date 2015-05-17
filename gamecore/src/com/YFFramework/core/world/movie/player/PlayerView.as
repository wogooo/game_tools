package com.YFFramework.core.world.movie.player
{
	/**@author yefeng
	 *2012-4-20下午10:31:32
	 */
	import com.YFFramework.core.center.pool.IPool;
	import com.YFFramework.core.map.rectMap.RectMapUtil;
	import com.YFFramework.core.map.rectMap.findPath.GridData;
	import com.YFFramework.core.map.rectMap.findPath.Node;
	import com.YFFramework.core.map.rectMap.findPath.TypeRoad;
	import com.YFFramework.core.ui.abs.AbsView;
	import com.YFFramework.core.ui.movie.BitmapEx;
	import com.YFFramework.core.ui.movie.BodyView;
	import com.YFFramework.core.ui.movie.data.ActionData;
	import com.YFFramework.core.ui.movie.data.TypeDirection;
	import com.YFFramework.core.ui.res.CommonFla;
	import com.YFFramework.core.utils.tween.game.TweenSuperSkill;
	import com.YFFramework.core.world.model.RoleDyVo;
	import com.YFFramework.core.world.movie.player.parts.EffectPartView;
	import com.YFFramework.core.world.movie.player.parts.NameItemView;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	
	public class PlayerView extends AbsAnimatorView
	{

		/**影子
		 */		
		protected var _shadow:BitmapEx;
		protected var _glowFilter:GlowFilter;
		protected var _nameLayer:AbsView;
		
		
		/**角色名称1
		 */
		protected  var _nameItem1:NameItemView;
		/**特效容器   比如升级  
		 */
		protected var _upEffectPart:EffectPartView;

		/** 最里层特效层
		 */
		protected var _downEffectPart:EffectPartView;
		
		
		/**检测该点是否为消隐点  人物行走路径时 需要
		 */
		protected var _checkAlphaTilePt:Point;
		/**检测该点是否为消隐点  人物行走路径时 需要
		 */
		protected var _checkNode:Node;

		/**是否发光
		 */
		protected var _glow:Boolean;
		public function PlayerView(roleDyVo:RoleDyVo=null)
		{
			super(roleDyVo);
			mouseChildren=false;
		}
		override protected function initUI():void
		{
			super.initUI();
			initShowdow();
			initNameLayer();
			_glowFilter=new GlowFilter(0xFFFFFF,1,8,8);
		}
		
		

		protected function initNameLayer():void
		{
			_nameLayer=new AbsView(false);
			addChild(_nameLayer);
			_nameLayer.y=-140;
			_nameLayer.x=-28;
			
			_nameItem1=new NameItemView();
			_nameLayer.addChild(_nameItem1);
			_nameItem1.text=_roleDyVo.roleName?_roleDyVo.roleName:_nameItem1.text;
			addNameItem();
		}
		/**初始化其他名称
		 */		
		private function addNameItem():void
		{
		}
		/** 释放名字层其他名字内存
		 */		
		protected function removeNameLayer():void
		{
			_nameLayer.removeChild(_nameItem1);
			_nameLayer.removeAllContent(true);  ///释放其他内存
			_nameLayer.addChild(_nameItem1);
		}
		override protected function initEquipment():void
		{
			_cloth=new BodyView(); 
			_cloth.start();
			addChild(_cloth);
		}
		
		
		protected function initShowdow():void
		{
			_shadow=new BitmapEx();
			_shadow.setBitmapDataEx(CommonFla.ShadowBitmapDataEx);
			
			addChild(_shadow);
		}
		/// 透明度不能去掉
		override protected function addEvents():void
		{
			super.addEvents();
			addEventListener(MouseEvent.MOUSE_OUT,onMouseEvent);
		}
		
		override protected function removeEvents():void
		{
			super.removeEvents();
			removeEventListener(MouseEvent.MOUSE_OUT,onMouseEvent);
		}
		private function onMouseEvent(e:MouseEvent):void
		{
			glow=false;
		}
		
		/**  发光  body对象发光
		 */
		public function set glow(value:Boolean):void
		{
			_glow=value;
			if(value)_cloth.filters=[_glowFilter];
			else _cloth.filters=[];
		}
		public function get glow():Boolean
		{
			return _glow;
		}
		
		override public function play(action:int,direction:int=-1,loop:Boolean=true,completeFunc:Function=null,completeParam:Object=null,resetPlay:Boolean=false):void
		{
			if(direction==-1)	direction=_activeDirection;
			_activeAction=action;
			_activeDirection=direction;
			if(direction>5)
			{
				_cloth.scaleX=-1;
			//	_body.updateScale(-1,1);
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
			//	_body.updateScale(1,1);
			}
			if(_cloth.actionData)
			{
				_cloth.play(action,direction,loop,completeFunc,completeParam,resetPlay);
			}
		}
		
		
		override public function updateCloth(actionData:ActionData):void
		{
			super.updateCloth(actionData);
			play(_activeAction,_activeDirection,true,null,null,true);
		}
		
		
		override public function set roleDyVo(roleDyvo:RoleDyVo):void
		{
			super.roleDyVo=roleDyvo;
			_nameItem1.text=_roleDyVo.roleName?_roleDyVo.roleName:_nameItem1.text;
		}
		
		
		/**上层特效
		 * @param timesArr 每隔多少时间 执行一次函数调用 播放一次数据 
		 * @param totalTimes 该特效播放的时间长度  不管特效是否循环播放 当超过这个世界就会将特效进行移除
		 * @loop  特效播放 是否循环 播放
		 */
		public function addUpEffect(actionData:ActionData,timesArr:Vector.<Number>,loop:Boolean=false,totalTimes:int=2000):void
		{
			if(_upEffectPart)
			{
				if(!_upEffectPart.parent)
				{
					addChild(_upEffectPart);
				}
				_upEffectPart.playEffect(actionData,timesArr,loop,totalTimes);
			}
			else 
			{
				_upEffectPart=new EffectPartView(false);
				addChild(_upEffectPart);
				_upEffectPart.playEffect(actionData,timesArr,loop,totalTimes);
			}
					
		}
		
		/**下层特效
		 * @param waitIme   播放该特效需要等待的时间
		 * @param totalTimes 该特效播放的时间长度  不管特效是否循环播放 当超过这个世界就会将特效进行移除
		 * @loop  特效播放 是否循环 播放
		 */
		public function addDownEffect(actionData:ActionData,timesArr:Vector.<Number>,loop:Boolean=false,totalTimes:int=-1):void
		{
			if(_downEffectPart)
			{
				if(!_downEffectPart.parent)
				{
					addChildAt(_downEffectPart,0);
				}
				_downEffectPart.playEffect(actionData,timesArr,loop,totalTimes);
			}
			else 
			{
				_downEffectPart=new EffectPartView(false);
				addChildAt(_downEffectPart,0);  
				_downEffectPart.playEffect(actionData,timesArr,loop,totalTimes);
			}
		}
		
		/**
		 * @param action  动作
		 * @param direction 值为  -1 表示采用 先前的方向
		 * @param timesArr	函数播放时间轴 
		 * @param playFunc	执行函数
		 * @param playParam	函数参数
		 * @completeFunc   playFunc每次执行完成后调用
		 * @completeParam	playFunc参数
		 * @totalTimes  执行的总时间     totalTimes一般大于等于 timesArr[timesArr.length-1]
		 * @totalCompleteFunc  时间到后执行的函数
		 */
		public function splay(action:int,direction:int,timesArr:Vector.<Number>,completeFunc:Function=null,completeParam:Object=null,totalTimes:int=-1,totalCompleteFunc:Function=null,totalCompleteParam:Object=null):void
		{
			var data:Object={action:action,direction:direction,completeFunc:completeFunc,completeParam:completeParam};
			TweenSuperSkill.excute(timesArr,toSplay,data,totalTimes,totalCompleteFunc,totalCompleteParam);
			
		}
		private function toSplay(data:Object):void
		{
			var action:int=data.action;
			var direction:int=data.direction;
			var completeFunc:Function=data.completeFunc;
			var completeParam:Object=data.completeParam;
			play(action,direction,false,completeFunc,completeParam,true);

		}
		
		/**  人物在路径上行走  加上消隐点
		 */		
		override protected function updatePathDirection(obj:Point):void
		{
			// TODO Auto Generated method stub
			super.updatePathDirection(obj);
	//		print(this,"mapXY",_roleDyVo.mapX,_roleDyVo.mapY);
			_checkAlphaTilePt=RectMapUtil.getTilePosition(_roleDyVo.mapX,_roleDyVo.mapY);
			_checkNode=GridData.Instance.getNode(_checkAlphaTilePt.x,_checkAlphaTilePt.y);
			if(_checkNode.id==TypeRoad.AlphaWalk)	this.alpha=TypeRoad.AlphaColor;
			else alpha=TypeRoad.AlphaNormal;
			
		}
		
		
		override public function dispose(e:Event=null):void
		{
			removeChild(_shadow);
			_shadow=null;
			super.dispose();
			filters=null;
			_glowFilter=null;
			_checkAlphaTilePt=null;
			_checkNode=null;
			_downEffectPart=null;
			_upEffectPart=null;
			_checkAlphaTilePt=null;
			_checkNode=null;
			_nameItem1=null;
			_nameLayer=null;
		}

		/////对象池管理-----------------------------------------
		/**重置初始状态
		 */		
		override public function reset():void
		{
			super.reset();
			removeNameLayer();		
		}
		/**
		 * @param roleDyVo 为 RoleDyVo 类型
		 */		
		override public function constructor(roleDyVo:Object):IPool
		{
			 super.constructor(roleDyVo);
			 addNameItem();
			 return this;
		}
		/**设置对象池个数
		 */		
		override protected function setPoolNum():void
		{
			regPool(30);
		}
		
	}
}