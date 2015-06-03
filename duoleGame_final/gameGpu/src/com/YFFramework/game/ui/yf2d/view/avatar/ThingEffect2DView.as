package com.YFFramework.game.ui.yf2d.view.avatar
{
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.ui.movie.data.TypeAction;
	import com.YFFramework.core.utils.tween.game.TweenBezier;
	import com.YFFramework.core.utils.tween.game.TweenSimple;
	import com.YFFramework.core.world.movie.face.IMoving;
	import com.YFFramework.core.world.movie.player.utils.DirectionUtil;
	import com.YFFramework.core.yf2d.extension.ATFMovieClip;
	import com.YFFramework.core.yf2d.extension.SkillEffect2DView;
	import com.YFFramework.game.core.module.mapScence.events.MapScenceEvent;
	import com.YFFramework.game.core.module.mapScence.world.model.EffectMovieVo;
	import com.YFFramework.game.core.module.mapScence.world.view.player.CameraProxy;
	
	import flash.geom.Point;

	/**   技能特效 取自该类
	 * 场景建筑特效  在天空层 地表层等     独立的  动画特效 播放器  不需要进行嵌套到其他的 播放容器中    要嵌套到播放容器中使用 BItmapMovieclip 
	 *  该类主要是增加了 更新坐标的功能  坐标随 主角的坐标移动而发生改变     和AnimatorView 一样  只是他是容器    该类是 BItmap子类
	 * 2012-7-20 下午2:54:17
	 *@author yefeng
	 */
	public class ThingEffect2DView extends SkillEffect2DView implements IMoving 
	{
		/**更新位置时候的回掉
		 */
		public var updateFunc:Function;
		/**动画基本vo
		 */
		public  var roleDyVo:EffectMovieVo;
		protected var _tweenSimple:TweenSimple;
		protected var _teenBezier:TweenBezier;
		
		/**移动变量  rodyVo 的 mapX  Y 为整形 也是 游戏需要的数值
		 */ 
		public var _mapX:Number;
		public var _mapY:Number;

		public function ThingEffect2DView()
		{
			roleDyVo=new EffectMovieVo();
			_mapX=roleDyVo.mapX;
			_mapY=roleDyVo.mapY;
			mouseChildren=mouseEnabled=false;
			super();
		}
		override protected function initUI():void
		{
			super.initUI();
			_tweenSimple=new TweenSimple();
			_teenBezier=new TweenBezier();
		}
		
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
			roleDyVo.mapX=int(_mapX);
			roleDyVo.mapY=int(_mapY);
//			x =CameraProxy.Instance.x+roleDyVo.mapX-CameraProxy.Instance.mapX;
//			y=CameraProxy.Instance.y+roleDyVo.mapY-CameraProxy.Instance.mapY;
			setXY(CameraProxy.Instance.x+roleDyVo.mapX-CameraProxy.Instance.mapX,CameraProxy.Instance.y+roleDyVo.mapY-CameraProxy.Instance.mapY);
			if(updateFunc!=null)updateFunc(this);
		} 
		public function setMapXY(mapX:int,mapY:int):void
		{
			roleDyVo.mapX=mapX;
			roleDyVo.mapY=mapY;
			_mapX=mapX;
			_mapY=mapY;
			updatePostion();
		}
		
		public function moveTo(mapX:int,mapY:int,speed:Number=4,completeFunc:Function=null,completeParam:Object=null, forceUpdate:Boolean=false):void
		{
			var direction:int=DirectionUtil.getDirection(roleDyVo.mapX,roleDyVo.mapY,mapX,mapX);
			play(TypeAction.Walk,direction);
			_tweenSimple.tweenTo(this,"_mapX","_mapY",mapX,mapY,speed,completeFunc,completeParam,updatePostion,null,forceUpdate);
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
			_teenBezier.to(this,"_mapX","_mapY",path,speed,updateDatePath,completeFunc,completeParam,forceUpdate);
		}
		
		/** 路径行走更新
		 */
		protected function updateDatePath(data:Object):void
		{
			var obj:Point=Point(data);
			updatePostion();
		}
		
		
		override public function dispose(childrenDispose:Boolean=true):void
		{
			super.dispose(childrenDispose);	
			roleDyVo=null;
			if(_tweenSimple)_tweenSimple.dispose();
			_teenBezier.dispose();
			_teenBezier=null;
			updateFunc=null;
		}
		/////对象池
		override public function disposeToPool():void
		{
			super.disposeToPool();
			_tweenSimple.stop();
			_teenBezier.dispose();
			updateFunc=null;
		}
	}
}