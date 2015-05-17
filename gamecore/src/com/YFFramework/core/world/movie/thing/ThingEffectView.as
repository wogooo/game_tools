package com.YFFramework.core.world.movie.thing
{
	import com.YFFramework.core.center.pool.IPool;
	import com.YFFramework.core.center.pool.PoolCenter;
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.ui.movie.BitmapMovieClip;
	import com.YFFramework.core.ui.movie.data.TypeAction;
	import com.YFFramework.core.utils.tween.game.TweenBezier;
	import com.YFFramework.core.utils.tween.game.TweenSimple;
	import com.YFFramework.core.world.mapScence.events.MapScenceEvent;
	import com.YFFramework.core.world.model.EffectMovieVo;
	import com.YFFramework.core.world.movie.face.IMoving;
	import com.YFFramework.core.world.movie.player.HeroProxy;
	import com.YFFramework.core.world.movie.player.utils.DirectionUtil;
	
	import flash.geom.Point;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	/**   技能特效 取自该类
	 * 场景建筑特效  在天空层 地表层等     独立的  动画特效 播放器  不需要进行嵌套到其他的 播放容器中    要嵌套到播放容器中使用 BItmapMovieclip 
	 *  该类主要是增加了 更新坐标的功能  坐标随 主角的坐标移动而发生改变     和AnimatorView 一样  只是他是容器    该类是 BItmap子类
	 * 2012-7-20 下午2:54:17
	 *@author yefeng
	 */
	public class ThingEffectView extends BitmapMovieClip implements IMoving,IPool 
	{
		/**动画基本vo
		 */
		public  var roleDyVo:EffectMovieVo;
		protected var _tweenSimple:TweenSimple;
		protected var _teenBezier:TweenBezier;

		
		//////对象池
		/**是否 将其回收率   为true时表示 其 已经被回收率 了 false表示其还没有进行回收
		 */		
		protected var _isPool:Boolean;

		public function ThingEffectView()
		{
			roleDyVo=new EffectMovieVo();
			super();
			regPool(30);
		}
		/**注册对象池
		 */			
		protected function regPool(size:int):void
		{
			var className:String=getQualifiedClassName(this);
			var myClass:Class=getDefinitionByName(className) as Class;
			PoolCenter.Instance.regClass(myClass,size);
		}

		
		
		override protected function initUI():void
		{
			super.initUI();
			_tweenSimple=PoolCenter.Instance.getFromPool(TweenSimple) as TweenSimple;//new TweenSimple();
			_teenBezier=new TweenBezier();

		}
		/**调整坐标 相对主角
		 */		
		override protected function addEvents():void
		{
			super.addEvents();
			YFEventCenter.Instance.addEventListener(MapScenceEvent.HeroMove,updatePostion);
		}
		override protected function removeEvents():void
		{
			super.removeEvents();
			YFEventCenter.Instance.removeEventListener(MapScenceEvent.HeroMove,updatePostion);	
			
		}

		protected function updatePostion(e:YFEvent=null):void
		{
			var _pivotX:Number =HeroProxy.x+roleDyVo.mapX-HeroProxy.mapX;
			var _pivotY:Number=HeroProxy.y+roleDyVo.mapY-HeroProxy.mapY;
			setPivotXY(_pivotX,_pivotY);
		}
		public function setMapXY(mapX:Number,mapY:Number):void
		{
			roleDyVo.mapX=mapX;
			roleDyVo.mapY=mapY;
			updatePostion();
		}
		
		public function moveTo(mapX:Number,mapY:Number,speed:Number=4,completeFunc:Function=null,completeParam:Object=null):void
		{
			var direction:int=DirectionUtil.getDirection(roleDyVo.mapX,roleDyVo.mapY,mapX,mapX);
			play(TypeAction.Walk,direction);
			_tweenSimple.tweenTo(roleDyVo,"mapX","mapY",mapX,mapY,speed,completeFunc,completeParam,updatePostion);
			_tweenSimple.start();
			
		}
		/**@param forceUpdate 强制渲染开始帧  表示 是否 一调用 就立刻开始 渲染 改变位置  
		* 在 觉开始移动时 将其设置为false 角色在移动中调用该函数 需要强制渲染一帧  也就是其他玩家强制渲染一帧
		*  以达到尽量与其他玩家同步     S_OtherRoleBeginMovePath 设置为false   S_otherRoleMoving 时 设置为true
		*/
		public function sMoveTo(path:Array,speed:Number=5,completeFunc:Function=null,completeParam:Object=null,forceUpdate:Boolean=false):void
		{
			_teenBezier.destroy();
			_tweenSimple.stop();
			_teenBezier.to(roleDyVo,"mapX","mapY",path,speed,updateDatePath,completeFunc,completeParam,forceUpdate);
		}

		/** 路径行走更新
		 */
		protected function updateDatePath(data:Object):void
		{
			var obj:Point=Point(data);
			updatePostion();
		}
		

		override public function dispose():void
		{
			super.dispose();	
			roleDyVo=null;
		//	_tweenSimple.dispose();
		///	_tweenSimple=null;
			PoolCenter.Instance.toPool(_tweenSimple);
			_teenBezier.dispose();
			_teenBezier=null;

		}
		
		/////对象池
		
		
		/**创建对象
		 */ 
		public function constructor(roleDyVo:Object):IPool
		{
			
			_isPool=false;
			addEvents();
			start();
			return this;
		}
		/**变为初始状态
		 */		
		public function reset():void
		{
			removeEvents();
			_tweenSimple.stop();
			_teenBezier.stop();
			stop();
		}
		
		
		public function toPool():void
		{
			_isPool=true;
			reset();
		}
		/**是否已经回收
		 */		
		public function get isPool():Boolean
		{
			return _isPool;
		}
	}
}