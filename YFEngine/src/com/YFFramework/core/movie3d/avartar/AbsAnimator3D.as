package com.YFFramework.core.movie3d.avartar
{
	/**@author yefeng
	 *2013-3-18下午9:41:37
	 */
	import away3d.animators.SkeletonAnimator;
	import away3d.animators.transitions.CrossfadeTransition;
	import away3d.containers.ObjectContainer3D;
	import away3d.entities.Entity;
	import away3d.entities.Mesh;
	import away3d.entities.Sprite3D;
	import away3d.materials.ColorMaterial;
	import away3d.primitives.CubeGeometry;
	import away3d.primitives.PlaneGeometry;
	
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.movie3d.core.YFEngine;
	import com.YFFramework.core.utils.math.YFMath;
	import com.YFFramework.core.utils.tween.game.TweenBezier;
	import com.YFFramework.core.utils.tween.game.TweenSimple;
	import com.YFFramework.core.world.model.MonsterDyVo;
	import com.greensock.TweenLite;
	
	import flash.geom.Point;
	
	public class AbsAnimator3D extends AbsView3D implements IMoving3D
	{
		protected static const Transition:CrossfadeTransition = new CrossfadeTransition(0.3);

		
		private var _clothData:RolePard3D;
		
		/** 坐标  真实坐标 注意  roleDyVO里面的坐标 是 该坐标的取整  在进行移动时 用_mapX _mapY 进行计算然后进行取整
		 * _mapX _mapY  只是用作移动计算  最后的呈现是 取整 通过roleDyVo呈现整形坐标
		 */		
		public var _mapX:Number=0;
		/**地图坐标 x y 
		 */		
		public var _mapY:Number=0;
		/** flash坐标
		 */		
		protected var _flashX:int;
		protected var _flashY:int;
		//角色动态数据类型
		public var roleDyVo:MonsterDyVo;

		
		protected var _tweenSimple:TweenSimple;
		
		protected var _teenBezier:TweenBezier;
		/**正在播放的动作  因为  数据没有加载完成 所以需要在加载完成时自动播放
		 */		
		protected var _activeAction:String;
		protected var _activeDegree:Number;
		public function AbsAnimator3D()
		{
			super();
		}
		override protected function initUI():void
		{
			super.initUI();
			initData();
			initEquipment();
		}
		
		private function initData():void
		{
			_tweenSimple=new TweenSimple();
			_teenBezier=new TweenBezier();
			roleDyVo=new MonsterDyVo();
		}
		/**初始化各个装备部分  body     weapon    wing  等
		 */
		protected function initEquipment():void
		{
			resetSkin();
			_clothData=new RolePard3D();
			addChild(_clothData);
//			var cube:CubeGeometry=new CubeGeometry(100,100)
//		
//			var cubeMesh:Mesh=new Mesh(cube);
//			cubeMesh.material=new ColorMaterial(0xFFFFFF*Math.random());
//			addChild(cubeMesh);
//			rotationX=-180;
//			rotationY=0;
		}
		/**调节z坐标变为上下层   x  y 坐标最好不要动
		 *  可以改变 y  z 
		 */ 
		public function addEffect(effect:ObjectContainer3D):void
		{
			addChild(effect);
//			effect.y=effect.height
		}
		public function updateCloth(rolePart3DData:RolePart3DData):void
		{
			_clothData.initMesh(rolePart3DData);
			addChild(_clothData);
		}
		public function get clothData():RolePard3D
		{
			return _clothData;
		}
		/**重置皮肤为默认状态
		 */		
		public function resetSkin():void
		{
			
		}
		
		
		
		
		public function sMoveTo(path:Array, speed:int=5, completeFunc:Function=null, completeParam:Object=null, forceUpdate:Boolean=false):void
		{
			
		}
		
		public function setMapXY(mapX:int, mapY:int):void
		{
			_mapX=mapX;
			_mapY=mapY;
			updatePostion();
		}
		/**强制更新 
		 * @param mapX
		 * @param mapY
		 * 
		 */		
		public function  forceUpdate(mapX:int, mapY:int):void
		{
			setMapXY(mapX,mapY-3);
			moveToPt(mapX,mapY,2,forceUpdateComlete);
		}
		private function forceUpdateComlete(obj:Object):void
		{
			play(ActionName.Stand);
		}
		
		public function moveToPt(mapX:int,mapY:int,speed:int=4,completeFunc:Function=null,completeParam:Object=null,forceUpdate:Boolean=false):void
		{
			_teenBezier.destroy();   
			_tweenSimple.stop();   
			var degree:Number=YFMath.getDegree(roleDyVo.mapX,roleDyVo.mapY,mapX,mapY);
			degree=(degree+360)%360;
			play(ActionName.Walk,degree);
			_tweenSimple.tweenTo(this,"_mapX","_mapY",mapX,mapY,speed,completeFunc,completeParam,updateMoveTo,new Point(mapX,mapY),forceUpdate);
			_tweenSimple.start();

		}
		public function play(action:String,degree:Number=-1,loop:Boolean=true,completeFunc:Function=null,completeParam:Object=null,resetPlay:Boolean=false):void
		{
			if(degree==-1)degree=_activeDegree;
			_activeDegree=degree;
			_activeAction=action;
			if(_clothData.skeletonAniator)
			{
				_clothData.play(action,Transition);
				setRotationY(degree);
			}
		}

		protected function updateMoveTo(obj:Object):void
		{
			var pt:Point=Point(obj);
			updatePostion();
			updatePathDirection(pt);
		}
		protected function updatePostion(e:YFEvent=null):void
		{
			roleDyVo.mapX=int(_mapX);
			roleDyVo.mapY=int(_mapY);
//			_flashX =HeroProxy.x+_roleDyVo.mapX-HeroProxy.mapX;
//			_flashY=HeroProxy.y+_roleDyVo.mapY-HeroProxy.mapY;
			
			
			_flashX =roleDyVo.mapX;
			_flashY=roleDyVo.mapY;
			
			position=YFEngine.Instance.flashToModel3d(_flashX,_flashY);
//			clothData.position=new Vector3D(clothData.position.x,clothData.position.y,clothData.position.z);
		}
		
		/**  人物在路径上行走时方向 的变化
		 */		
		protected function updatePathDirection(obj:Point):void
		{
			if(_mapX!=obj.x||_mapY!=obj.y)  ///当不为最后一个  排除走到位置的触发s
			{
				var degree:Number=YFMath.getDegree(_mapX,_mapY,obj.x,obj.y);
				setRotationY(degree);
			}
			checkAlphaPoint();
		}	
		
		/**更新模型旋转方向
		 */		
		private function setRotationY(degree:Number):void
		{
//			print(this,"degree",degree);
//			if(degree<0)degree +=360;
			if(_clothData)
			{
//				degree +=-30;
				var mRotationY:Number=(degree-90);
				TweenLite.to(_clothData,0.5,{rotationY:mRotationY});
				_activeDegree=degree;
			}
		}
		/** 衣服的旋转角度
		 *  
		 */		
		public function updateRotationY(value:Number):void
		{
			_clothData.rolePart3DData.mesh.rotationY=value
		}
		public function updateScale(value:Number):void
		{
//			_clothData.scale(value); ///scale 是不断的进行缩放   scaleX  Y Z  是一个固定值
			_clothData.rolePart3DData.mesh.scaleX=value;
			_clothData.rolePart3DData.mesh.scaleY=value;
			_clothData.rolePart3DData.mesh.scaleZ=value;

		}
		
		/**检测当前点是否为消隐点  改变角色透明度
		 */		
		public function checkAlphaPoint():void
		{
//			_checkAlphaTilePt=RectMapUtil.getTilePosition(_roleDyVo.mapX,_roleDyVo.mapY);
//			_checkNode=GridData.Instance.getNode(_checkAlphaTilePt.x,_checkAlphaTilePt.y);
//			if(_checkNode)
//			{
//				if(_checkNode.id==TypeRoad.AlphaWalk)	this.alpha=TypeRoad.AlphaColor;    /////判断消隐点
//				else alpha=TypeRoad.AlphaNormal;
//			}
		}

		
		public function getFlashX():int
		{
			return _flashX;
		}
		public function getFlashY():int
		{
			return _flashY;
		}
		
		


			
		
		
	}
}