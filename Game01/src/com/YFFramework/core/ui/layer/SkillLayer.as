package com.YFFramework.core.ui.layer
{
	/**  天空    地面 特效层
	 * @author yefeng
	 *2012-9-10下午12:59:53
	 */
	import com.YFFramework.core.center.pool.PoolCenter;
	import com.YFFramework.core.ui.abs.AbsView;
	import com.YFFramework.core.ui.movie.data.ActionData;
	import com.YFFramework.core.utils.tween.game.TweenSuperSkill;
	import com.YFFramework.core.world.movie.thing.ThingEffectView;
	import com.YFFramework.core.world.movie.thing.ThingRotateEffectView;
	
	import flash.utils.Dictionary;

	public class SkillLayer extends AbsView
	{
		
		/**  常驻的动画播放器    当大于两个时 则需要创临时的播放器
		 */
		//	private var _movie:BitmapMovieClip;
		
		/**动画大于两个时创建临时的播放器  播放完之后立刻释放播放器内存
		 */
		private var _tempDict:Dictionary;
		
		public function SkillLayer()
		{
			super(false);
			mouseChildren=false;
			mouseEnabled=false;
		}
		
		/**单纯的播放特效
		 * positionX  positionY  动画的位置  是世界地图坐标  mapX  mapY
		 * @param loop  该特效是否 循环播放     一般人物待机 时需要
		 * @param timesArr   特效时间轴
		 * @param completeFunc 每次特效播放完之后调用
		 * @param completeParam	参数
		 * @param totalTimes   特效播放的时间   这个这间之后 将移除特效   不管是否处于循环播放状态 所以 当是循环播放时  需要将 值 设为很大     
		 */
		public function playEffect(positionX:Number,positionY:Number,actionData:ActionData,timesArr:Array,loop:Boolean=false):void
		{
			
			var movie:ThingEffectView=PoolCenter.Instance.getFromPool(ThingEffectView,null) as ThingEffectView;
			addChild(movie);
			movie.setMapXY(positionX,positionY);
			movie.initData(actionData);
			movie.start();
			var data:Object={movie:movie,loop:loop}
			TweenSuperSkill.excute(timesArr,playMovie,data);
		}
		/**
		 * @param data={movie:BitmapMovieClip,complete:Function,loop:Boolean}
		 */
		private function playMovie(data:Object):void
		{
			var  movie:ThingEffectView=data.movie as ThingEffectView;
			var loop:Boolean=data.loop;
			movie.playDefault(loop,playComplete,movie,true);
		}
		
		/**播放完成后触发 
		 */
		private function playComplete(data:Object):void
		{
			var movie:ThingEffectView=data as ThingEffectView;
			if(contains(movie))	removeChild(movie);
			movie.disposeToPool();
		}
		/**动画移动完成
		 */ 
		private function moveComplete(oj:Object):void
		{
			var movie:ThingRotateEffectView=oj as ThingRotateEffectView;
			if(contains(movie)) removeChild(movie);
		}
		
		/**添加带速度的技能    能够运动的技能
		 * 所有的点都是地图上的点mapXY   (pivotX,pivotY)是起始点(地图坐标) ，   endX,endY是终点（地图坐标）   totalTimes 是技能运行的总时间,也就是距离除以速度speed的结果 actionData是数据源
		 */ 
		public function addSpeedEffect(pivotX:int,pivotY:int,endX:int,endY:int,speed:int,actionData:ActionData):void
		{
			var movie:ThingRotateEffectView=PoolCenter.Instance.getFromPool(ThingRotateEffectView,null) as ThingRotateEffectView;
			addChild(movie);
			movie.setMapXY(pivotX,pivotY);
			movie.initData(actionData);
			movie.start();
			var data:Object={movie:movie,loop:true}
			TweenSuperSkill.excute([0],playMovie,data);
			movie.moveTo(endX,endY,speed,moveComplete,movie);
		}
		
		
		
		/**timesArr  是时间轴 每隔数组里面某个元素的时间段就会播放一个技能
		 * 添加带速度的技能    能够运动的技能
		 * 所有的点都是地图上的点mapXY   (pivotX,pivotY)是起始点(地图坐标) ，   endX,endY是终点（地图坐标）   totalTimes 是技能运行的总时间,也就是距离除以速度speed的结果 actionData是数据源
		 */ 

		public function addSuperSpeedEffect(pivotX:int,pivotY:int,endX:int,endY:int,timesArr:Array,speed:int,actionData:ActionData):void
		{			
			var data:Object={pivotX:pivotX,pivotY:pivotY,actionData:actionData,endX:endX,endY:endY,speed:speed}
			TweenSuperSkill.excute(timesArr,playSuperSKill,data);
		}
		
		
		private function playSuperSKill(data:Object):void
		{
			var pivotX:int=data.pivotX;
			var pivotY:int=data.pivotY;
			var actionData:ActionData=data.actionData;
			var endX:int=data.endX;
			var endY:int=data.endY;
			var speed:int=data.speed;
			var movie:ThingRotateEffectView=PoolCenter.Instance.getFromPool(ThingRotateEffectView,null) as ThingRotateEffectView;
			addChild(movie);
			movie.setMapXY(pivotX,pivotY);
			movie.initData(actionData);
			movie.start();
			movie.playDefault(true,playComplete,movie,true);
			movie.moveTo(endX,endY,speed,moveComplete,movie);

		}
		
		
	}
}