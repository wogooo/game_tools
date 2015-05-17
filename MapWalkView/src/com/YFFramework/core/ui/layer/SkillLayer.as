package com.YFFramework.core.ui.layer
{
	/**  天空    地面 特效层
	 * @author yefeng
	 *2012-9-10下午12:59:53
	 */
	import com.YFFramework.core.center.pool.PoolCenter;
	import com.YFFramework.core.ui.movie.data.ActionData;
	import com.YFFramework.core.ui.yf2d.data.YF2dActionData;
	import com.YFFramework.core.ui.yf2d.view.Abs2dView;
	import com.YFFramework.core.ui.yf2d.view.avatar.ThingEffect2DView;
	import com.YFFramework.core.ui.yf2d.view.avatar.ThingRotateEffect2DView;
	import com.YFFramework.core.utils.tween.game.TweenSuperSkill;
	
	import flash.utils.Dictionary;

	public class SkillLayer extends Abs2dView
		
	{
		
		/**  常驻的动画播放器    当大于两个时 则需要创临时的播放器
		 */
		//	private var _movie:BitmapMovieClip;
		
		/**动画大于两个时创建临时的播放器  播放完之后立刻释放播放器内存
		 */
		private var _tempDict:Dictionary;
		
		public function SkillLayer()
		{
			super();
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
		public function playEffect(positionX:Number,positionY:Number,actionData:YF2dActionData,timesArr:Array,loop:Boolean=false):void
		{
			
			var movie:ThingEffect2DView=PoolCenter.Instance.getFromPool(ThingEffect2DView,null) as ThingEffect2DView;
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
			var  movie:ThingEffect2DView=data.movie as ThingEffect2DView;
			var loop:Boolean=data.loop;
			movie.playDefault(loop,playComplete,movie,true);
		}
		
		/**播放完成后触发 
		 */
		private function playComplete(data:Object):void
		{
			var movie:ThingEffect2DView=data as ThingEffect2DView;
			if(contains(movie))	removeChild(movie);
			movie.disposeToPool();
		}
		/**动画移动完成
		 */ 
//		private function moveComplete(oj:Object):void
//		{
//			var movie:ThingRotateEffectView=oj as ThingRotateEffectView;
//			if(contains(movie)) removeChild(movie);
//		}
		
		/**添加带速度的技能    能够运动的技能
		 * 所有的点都是地图上的点mapXY   (pivotX,pivotY)是起始点(地图坐标) ，   endX,endY是终点（地图坐标）   totalTimes 是技能运行的总时间,也就是距离除以速度speed的结果 actionData是数据源
		 */ 
//		public function addSpeedEffect(pivotX:int,pivotY:int,endX:int,endY:int,speed:int,actionData:ActionData):void
//		{
//			var movie:ThingRotateEffectView=PoolCenter.Instance.getFromPool(ThingRotateEffectView,null) as ThingRotateEffectView;
//			addChild(movie);
//			movie.setMapXY(pivotX,pivotY);
//			movie.initData(actionData);
//			movie.start();
//			var data:Object={movie:movie,loop:true}
//			TweenSuperSkill.excute([0],playMovie,data);
//			movie.moveTo(endX,endY,speed,moveComplete,movie);
//		}
		
		
		
		/**timesArr  是时间轴 每隔数组里面某个元素的时间段就会播放一个技能
		 * 添加带速度的技能    能够运动的技能
		 * 所有的点都是地图上的点mapXY   (pivotX,pivotY)是起始点(地图坐标) ，   endX,endY是终点（地图坐标）   totalTimes 是技能运行的总时间,也就是距离除以速度speed的结果 actionData是数据源
		 * skillRotateType   值在TypeSkill里面 用来配置运动技能  表示 技能是否能够360度旋转
		 */ 

		public function addSuperSpeedEffect(pivotX:int,pivotY:int,endX:int,endY:int,timesArr:Array,speed:Number,actionData:YF2dActionData,skillRotateType:int):void
		{			
			var data:Object={pivotX:pivotX,pivotY:pivotY,actionData:actionData,endX:endX,endY:endY,speed:speed}
			TweenSuperSkill.excute(timesArr,playSuperSKill,data);
		}
		
		
		private function playSuperSKill(data:Object):void
		{
			var pivotX:int=data.pivotX;
			var pivotY:int=data.pivotY;
			var actionData:YF2dActionData=data.actionData;
			var endX:int=data.endX;
			var endY:int=data.endY;
			var speed:Number=data.speed;
			var movie:ThingRotateEffect2DView=PoolCenter.Instance.getFromPool(ThingRotateEffect2DView,null) as ThingRotateEffect2DView;
			addChild(movie);
			movie.setMapXY(pivotX,pivotY);
			movie.initData(actionData);
			movie.start();
			movie.playDefault(true,playComplete,movie,true);
			movie.moveTo(endX,endY,speed,playComplete,movie);

		}
		
		
	}
}