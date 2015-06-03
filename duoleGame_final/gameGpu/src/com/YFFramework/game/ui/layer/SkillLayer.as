package com.YFFramework.game.ui.layer
{
	/**  天空    地面 特效层
	 * @author yefeng
	 *2012-9-10下午12:59:53
	 */
	import com.YFFramework.core.center.manager.update.TimeOut;
	import com.YFFramework.core.ui.yf2d.data.ATFActionData;
	import com.YFFramework.core.ui.yf2d.view.Abs2dView;
	import com.YFFramework.core.utils.math.YFMath;
	import com.YFFramework.core.utils.net.SourceCache;
	import com.YFFramework.core.utils.tween.game.TweenSuperSkill;
	import com.YFFramework.game.core.global.manager.ParticleBasicManager;
	import com.YFFramework.game.core.global.model.ParticleBasicVo;
	import com.YFFramework.game.core.global.model.TypeSkill;
	import com.YFFramework.game.gameConfig.URLTool;
	import com.YFFramework.game.ui.yf2d.view.avatar.ThingEffect2DView;
	import com.YFFramework.game.ui.yf2d.view.avatar.ThingRotateEffect2DView;
	import com.YFFramework.game.ui.yf2d.view.avatar.pool.YF2dMovieClipPool;
	
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	public class SkillLayer extends Abs2dView
		
	{
		
		/**  常驻的动画播放器    当大于两个时 则需要创临时的播放器
		 */
		//	private var _movie:BitmapMovieClip;
		
		/** 运动技能拖尾 保存动画key 用来映射 粒子数据
		 */
		private var _particleDict:Dictionary;
		
		/**圆形 轨迹运动粒子缓存
		 */
//		private var _cicleParticleDict:Dictionary;

		
		
		public function SkillLayer()
		{
			super();
			mouseChildren=false;
			mouseEnabled=false;
			_particleDict=new Dictionary();
//			_cicleParticleDict=new Dictionary();
		}
		
		/**单纯的播放特效
		 * positionX  positionY  动画的位置  是世界地图坐标  mapX  mapY
		 * @param loop  该特效是否 循环播放     一般人物待机 时需要
		 * @param timesArr   特效时间轴
		 * @param completeFunc 每次特效播放完之后调用
		 * @param completeParam	参数
		 * @param totalTimes   特效播放的时间   这个这间之后 将移除特效   不管是否处于循环播放状态 所以 当是循环播放时  需要将 值 设为很大     
		 * particleRotate用作粒子时 该技能是否旋转
		 * particleDegree是粒子的方向
		 */
		public function playEffect(positionX:Number,positionY:Number,actionData:ATFActionData,timesArr:Array,loop:Boolean=false,particleRotate:int=-1,particleDegree:Number=-1):void
		{
			var data:Object={positionX:positionX,positionY:positionY,actionData:actionData,loop:loop,particleRotate:particleRotate,particleDegree:particleDegree};
			TweenSuperSkill.excute(timesArr,playMovie,data);
		}
		
		/**播放粒子特效
		 * @param positionX
		 * @param positionY
		 * @param actionData
		 * @param timesArr
		 * @param loop
		 * @param particleRotate
		 * @param particleDegree
		 * 
		 */
		private function playParticleSimpleEffect(positionX:Number,positionY:Number,actionData:ATFActionData,time:Number,loop:Boolean=false,particleRotate:int=-1,particleDegree:Number=-1):void
		{
			var data:Object={positionX:positionX,positionY:positionY,actionData:actionData,loop:loop,particleRotate:particleRotate,particleDegree:particleDegree};
			if(time>0)
			{
				var t:TimeOut=new TimeOut(time,playMovie,data);
				t.start();
			}
			else 
			{
				playMovie(data);
			}
		}

		
		/**
		 * @param
		 */
		private function playMovie(data:Object):void
		{
			var movie:ThingEffect2DView=YF2dMovieClipPool.getThingEffect2DView();//new ThingEffect2DView();//
			addChild(movie);
			movie.setMapXY(data.positionX,data.positionY);
			movie.initData(data.actionData);
			movie.start();
			var loop:Boolean=data.loop;
			movie.playDefault(loop,playComplete,movie,true);
			var particleRotate:int=data.particleRotate;
			switch(particleRotate)
			{
				case TypeSkill.ParticleLayer_Rotate_NONE:  //不旋转
					movie.rotationZ=0;
					break;
				case TypeSkill.ParticleLayer_Rotate_360: //360旋转
					var particleDegree:Number=data.particleDegree;
					movie.rotationZ=particleDegree;
					break;
				case TypeSkill.ParticleLayer_Rotate_Random:  //随机旋转
					movie.rotationZ=360*Math.random();
					break;
			}
		}
		
		/**播放完成后触发 
		 */
		private function playComplete(data:Object):void
		{
			var movie:ThingEffect2DView=data as ThingEffect2DView;
			if(contains(movie))	removeChild(movie);
			if(movie is ThingRotateEffect2DView)
			{
				YF2dMovieClipPool.toThingRotateEffect2DViewPool(movie);
			}
			else if(movie is ThingEffect2DView)
			{
				YF2dMovieClipPool.toThingEffect2DViewPool(movie);
			}
			_particleDict[movie]=null;
			delete _particleDict[movie];
		}
		
		
		/**timesArr  是时间轴 每隔数组里面某个元素的时间段就会播放一个技能
		 * 添加带速度的技能    能够运动的技能
		 * 所有的点都是地图上的点mapXY   (pivotX,pivotY)是起始点(地图坐标) ，   endX,endY是终点（地图坐标）   totalTimes 是技能运行的总时间,也就是距离除以速度speed的结果 actionData是数据源
		 * skillRotateType   值在TypeSkill里面 用来配置运动技能  表示 技能是否能够360度旋转
		 * particle_id 粒子 id
		 */ 
		
		public function addSuperSpeedEffect(rotateRad:Number,pivotX:int,pivotY:int,endX:int,endY:int,timesArr:Array,speed:Number,actionData:ATFActionData,skillRotateType:int,particle_id:int):void
		{			
			var data:Object={rotateRad:rotateRad,pivotX:pivotX,pivotY:pivotY,actionData:actionData,endX:endX,endY:endY,speed:speed,skillRotateType:skillRotateType,particle_id:particle_id}
			TweenSuperSkill.excute(timesArr,playSuperSKill,data);
		}
		
		
		private function playSuperSKill(data:Object):void
		{
			var pivotX:int=data.pivotX;
			var pivotY:int=data.pivotY;
			var actionData:ATFActionData=data.actionData;
			var endX:int=data.endX;
			var endY:int=data.endY;
			var speed:Number=data.speed;
			var rotation:Number=YFMath.radToDegree(data.rotateRad);
			var skillRotateType:int=data.skillRotateType;
			var movie:ThingEffect2DView;
			var particle_id:int=data.particle_id
			
			if(skillRotateType==TypeSkill.MoveSkillType_Rotate)
			{
				movie=YF2dMovieClipPool.getThingRotateEffect2DView();
			}
			else movie=YF2dMovieClipPool.getThingEffect2DView();//new ThingEffect2DView();
			addChild(movie);
			movie.setMapXY(pivotX,pivotY);
			movie.initData(actionData);
			movie.start();
			movie.playDefault(true,playComplete,movie,true);
			movie.moveTo(endX,endY,speed,playComplete,movie);
			if(skillRotateType==TypeSkill.MoveSkillType_Rotate)movie.rotationZ=rotation;
			//初始化例子计时器
			if(particle_id>0)
			{
				var degree:Number=YFMath.getDegree(pivotX,pivotY,endX,endY);
				var trigger:Boolean=initParticle(particle_id,movie,degree);
				if(trigger)
				{
					movie.updateFunc=playParticle;
					playParticle(movie);
				}
			}
		}
		
		private function initParticle(particleId:int,movie:ThingEffect2DView,degree:Number):Boolean
		{
			var particleData:ParticleData=ParticleData.getParticleData();
			var arr:Array=ParticleBasicManager.Instance.getParticleBasicVo(particleId);
			if(arr)
			{
				_particleDict[movie]=particleData;
				var len:int=arr.length;
				particleData.len=len;
				particleData.particleArr=arr;
				particleData.timeArr=[];
				particleData.degree=degree;
				for(var i:int=0;i!=len;++i)
				{
					particleData.timeArr[i]=0;
				}
				return true; 
			}
			return false;
		}
		
		
		//		private var _preT1:Number=0
		//		private var _preT2:Number=0
		private function playParticle(movie:ThingEffect2DView):void
		{
			var particleData:ParticleData=_particleDict[movie];
			var particleBasicVo:ParticleBasicVo;
			var actionData:ATFActionData;
			var url:String;
			for(var i:int=0;i!=particleData.len;++i)
			{
				particleBasicVo=particleData.particleArr[i];
				if(particleBasicVo.type==TypeSkill.ParticleType_Follow)
				{
					if(getTimer()-particleData.timeArr[i]>=particleBasicVo.interval)
					{
						url=URLTool.getSkill(particleBasicVo.model_id);
						actionData=SourceCache.Instance.getRes2(url) as ATFActionData;
						if(actionData)
						{
							switch(particleBasicVo.layer)
							{
								case TypeSkill.ParticleLayer_Up:
									LayerManager.SkySKillLayer.playParticleSimpleEffect(movie._mapX,movie._mapY,actionData,0,false,particleBasicVo.rotate_type,particleData.degree);
									break;
								case TypeSkill.ParticleLayer_Down:
									LayerManager.BgSkillLayer.playParticleSimpleEffect(movie._mapX,movie._mapY,actionData,0,false,particleBasicVo.rotate_type,particleData.degree);
									break;
								default:
									LayerManager.SkySKillLayer.playParticleSimpleEffect(movie._mapX,movie._mapY,actionData,0,false,particleBasicVo.rotate_type,particleData.degree);
									break;
							}
						}
						else 
						{
							SourceCache.Instance.loadRes(url);
						}
						particleData.timeArr[i]=getTimer();
					}
				}
			}
		}
		
		
		/**放置粒子
		 */
		public function playPointParticle(particle_id:int,mapX:Number,mapY:Number,offsetTime:Number):void
		{
			var arr:Array=ParticleBasicManager.Instance.getParticleBasicVo(particle_id);
			if(arr)
			{
				var particleBasicVo:ParticleBasicVo;
				var len:int=arr.length;
				var actionData:ATFActionData;
				var url:String;
				for(var i:int=0;i!=len;++i)
				{
					particleBasicVo=arr[i];
					if(particleBasicVo.type==TypeSkill.ParticleType_Point)
					{
						url=URLTool.getSkill(particleBasicVo.model_id);
						actionData=SourceCache.Instance.getRes2(url) as ATFActionData;
						if(actionData)
						{
							if(particleBasicVo.layer==TypeSkill.ParticleLayer_Down)
							{
								LayerManager.BgSkillLayer.playParticleSimpleEffect(mapX+particleBasicVo.offset[0],mapY+particleBasicVo.offset[1],actionData,offsetTime+particleBasicVo.interval,false,particleBasicVo.rotate_type,0);
							}
							else if(particleBasicVo.layer==TypeSkill.ParticleLayer_Up)
							{
								LayerManager.SkySKillLayer.playParticleSimpleEffect(mapX+particleBasicVo.offset[0],mapY+particleBasicVo.offset[1],actionData,offsetTime+particleBasicVo.interval,false,particleBasicVo.rotate_type,0);
							}
						}
						else 
						{
							SourceCache.Instance.loadRes(url);
						}
					}
				}
				
			}
		}
		
//		private function updateCircleParticle(particlePlayer:CirclePlayerParticle,x:Number,y:Number,degree:int):void
//		{
//			
//		}
//		private function completeCircleParticleCall(particlePlayer:CirclePlayerParticle):void
//		{
//			_cicleParticleDict[particlePlayer]=null;
//			delete _cicleParticleDict[particlePlayer];
//		}

		
	}
}