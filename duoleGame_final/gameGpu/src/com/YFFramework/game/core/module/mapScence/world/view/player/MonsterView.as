package com.YFFramework.game.core.module.mapScence.world.view.player
{
	import com.YFFramework.core.center.manager.update.TimeOut;
	import com.YFFramework.core.center.manager.update.UpdateManager;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.ui.movie.data.TypeAction;
	import com.YFFramework.core.ui.movie.data.TypeDirection;
	import com.YFFramework.core.ui.yf2d.data.ATFMovieData;
	import com.YFFramework.core.utils.math.YFMath;
	import com.YFFramework.core.world.movie.player.utils.DirectionUtil;
	import com.YFFramework.core.yf2d.display.DisplayObject2D;
	import com.YFFramework.game.core.global.MouseManager;
	import com.YFFramework.game.core.global.MouseStyle;
	import com.YFFramework.game.core.module.mapScence.events.MapScenceEvent;
	import com.YFFramework.game.core.module.mapScence.model.BackSlideMoveVo;
	import com.YFFramework.game.core.module.mapScence.world.model.MonsterMoveVo;  
	import com.YFFramework.game.core.module.mapScence.world.model.RoleDyVo;
	import com.YFFramework.game.ui.imageText.ImageUtil;
	import com.YFFramework.game.ui.imageText.TypeImageText;
	import com.YFFramework.game.ui.yf2d.view.avatar.Part2DCombine;
	import com.greensock.TweenLite;
	import com.greensock.easing.Linear;
	
	import flash.geom.Point;
	
	/**
	 * 怪物 动画UI 具备  坐标反馈给服务端的功能
	 * 2012-8-28 上午9:55:24
	 *@author yefeng
	 */
	public class MonsterView extends PlayerView
	{
		
		/**  说话的总次数  用来比较怪物 该谁说话了
		 */		
		public var sayWordTimes:int;
		
		public function MonsterView(roleDyVo:RoleDyVo=null)
		{
			super(roleDyVo);
			
			//怪物选中的颜色
//			SelectNameColorTransform=new ColorTransform(4, 0.7, 0.7, 1, 1, 0, 0);
		}
		override protected function initUI():void
		{
			super.initUI();	
			initCheckAlpha();
		}
		/**是否 进行alpha检测   怪物不进行alpha检测    只有怪物不进行alpha检测
		 */		
		protected function initCheckAlpha():void
		{
			DisplayObject2D(_cloth.mainClip).checkAlpha=false; //怪物不进行alpha检测
		}
		
		/***推拉人物  通讯  
		 * direction  是人物站立 滑动的方向
		 */ 
//		override public function backSlideMoveTo(mapX:int, mapY:int,direction:int, speed:Number=4, completeFunc:Function=null, completeParam:Object=null, forceUpdate:Boolean=false):void
//		{
//			if(_hasTarget) noticeBackSlideMove(mapX,mapY);
//			super.backSlideMoveTo(mapX, mapY, direction,speed, completeFunc, completeParam, forceUpdate);
//		}
		
		override public function play(action:int, direction:int=-1, loop:Boolean=true, completeFunc:Function=null, completeParam:Object=null, resetPlay:Boolean=false, isHitMove:Boolean=false):void
		{
			if(!_isDispose)
			{
				super.play(action, direction, loop, completeFunc, completeParam, resetPlay, isHitMove);
			}
		}
		/**显示手势光标
		 */		
		override protected function initMouseCursor(select:Boolean):void
		{
			if(select)
				MouseManager.changeMouse(MouseStyle.Attack);
			else 
				MouseManager.resetToDefaultMouse();
		}

		
		/**创建 受伤效果
		 * 人会击退  会向后稍微退一像素
		 */		
		override protected function initInjureEffect(action:int,direction:int,isHitMove:Boolean=false):int
		{
			return moveInjure(action,direction,isHitMove);
		}
		private function moveInjure(action:int,direction:int,isHitMove:Boolean):int
		{ 
			if(action==TypeAction.Injure)
			{
				if(isHitMove) ///击退效果
				{
					setColorMatrix(WhiteColorTransform);
					var degree:int=DirectionUtil.getDirectionDegree(direction);
					var _realX:int=roleDyVo.mapX;
					var _realY:int=roleDyVo.mapY;
					var pt:Point=YFMath.getLinePoint4(_realX,_realY,1,degree); //向后退2像素
					setMapXY(pt.x,pt.y);
					var timeOut:TimeOut=new TimeOut(60,moveInjureComplete,{mapX:_realX,mapY:_realY});
					timeOut.start();
					return action;
				}
				else return doSimpleInjure(action,direction);
			}
			else if(action==TypeAction.Dead)  //为死亡  怪物的死亡是播放受击动作
			{
				if(_cloth.actionDataInjureDead)
				{
					if(_cloth.actionDataInjureDead.dataDict[action])  //有 死亡动作
					{
						setColorMatrix(DefaultColortransform);
						return action;
					}
					else  
					{
						doSimpleInjure(TypeAction.Injure,direction); //没有死亡动作
						return action;
					}
				}
				else 
				{
					 doSimpleInjure(TypeAction.Injure,direction);
					 return action;
				}
			}
			else  setColorMatrix(DefaultColortransform);
			return action;
		}
		/**后退受击 完成
		 */		
		private function moveInjureComplete(obj:Object):void
		{
			if(!isDispose)
			{
				setMapXY(obj.mapX,obj.mapY);
				setColorMatrix(DefaultColortransform);
			}
		}
		/** 怪物死亡动作
		 *  怪物没有死亡动作
		 */		
		override public function stayDead(direction:int=-1):void
		{
			_activeAction=TypeAction.Dead;
//			isDead=true;
			//			updateHp(0);
			if(direction==-1) direction=_activeDirection;
			if(direction==-1) direction=1;
			_activeDirection=direction;
			
			var directionObj:Object=TypeDirection.getCopyDirection(direction);
			direction=directionObj.direction;
			_cloth.scaleX=directionObj.scaleX;
			if(_cloth.actionDataInjureDead)
			{
				//	var index:int=_cloth.actionData.getDirectionLen(TypeAction.Dead,direction)-1;
				//				var deadDirectionArr:Array=_cloth.actionData.getDirectionArr(TypeAction.Dead);
				//	var defaultDeadArr:Vector.<BitmapDataEx>=_cloth.actionData.getDirectionData(TypeAction.Dead,deadDirectionArr[0]);
				var defaultDeadArr:ATFMovieData=_cloth.actionDataInjureDead.getDirectionData(TypeAction.Injure,direction);
				var index:int=defaultDeadArr.dataArr.length-1;  ///停留在最后一帧
				gotoAndStop(TypeAction.Injure,direction,index);
			}
		}

		
		/**通讯 角色的拉取或者退离
		 */ 
		private function noticeBackSlideMove(endMapX:int,endMapY:int):void
		{
			var backSlideMoveVo:BackSlideMoveVo=new BackSlideMoveVo();
			backSlideMoveVo.dyId=roleDyVo.dyId;
			backSlideMoveVo.mapX=roleDyVo.mapX;
			backSlideMoveVo.mapX=roleDyVo.mapY;
			backSlideMoveVo.endX=endMapX;
			backSlideMoveVo.endY=endMapY;
			YFEventCenter.Instance.dispatchEventWith(MapScenceEvent.C_BackSlideMove,backSlideMoveVo);
		}
		
		/**
		 * @param data  下一个目标点 
		 */		 
		override protected function updateDatePath(data:Object):void
		{
			updatePostion();			
			updatePathDirection(Point(data));
//			if(_hasTarget)
//			{
//				++_movingIndex;
//				if(_movingIndex>=MovingLen)
//				{
//					_movingIndex=0;
//					_movingPath=_teenBezier.getPlayPath();
//					var postion:Point=new Point(_roleDyVo.mapX,_roleDyVo.mapY);
//					noticeMonsterMove(postion,_movingPath,_moveSpeed);
//				}
//			}
		}
		
		
		override public function showBufHpfChange(hpChange:int):void
		{
			var my:Number=-50;
			if(_cloth.actionDataStandWalk)my=_cloth.actionDataStandWalk.getBlood().y*0.5;
			if(hpChange<0) ///扣血
			{
				ImageUtil.Instance.showBuffHpMinus(Math.abs(hpChange),flashContainer,my,TypeImageText.Monster);
			}
			else //加血 
			{
				ImageUtil.Instance.showBuffHpAdd(hpChange,flashContainer,my,TypeImageText.Monster);
			}
		}
		/**  移动 行走  更新
		 */		
//		override protected function updateMoveTo(obj:Object):void
//		{
//			super.updateMoveTo(obj);
//			///移动进行通讯 
//			if(_hasTarget)
//			{
//				++_moveToIndex;
//				if(_moveToIndex>=MoveToLen)
//				{
//					_moveToIndex=0;
//					_movingPath=[obj];
//					var postion:Point=new Point(_roleDyVo.mapX,_roleDyVo.mapY);
//					noticeMonsterMove(postion,_movingPath,_moveSpeed);
//				}
//			}
//		}


		

		/** 怪物发生移动  通知socket 
		 */		 
//		private function noticeMonsterMove(position:Point,path:Array,speed:Number):void
//		{
//			var playerMoveVo:MonsterMoveVo=new MonsterMoveVo();//PoolCenter.Instance.getFromPool(MonsterMoveVo) as MonsterMoveVo;
//			playerMoveVo.path=path;
//			playerMoveVo.dyId=roleDyVo.dyId;
//			playerMoveVo.curentPostion=position;
//			playerMoveVo.speed=speed;
//			YFEventCenter.Instance.dispatchEventWith(MapScenceEvent.C_MonsterMoving,playerMoveVo);
//		}
		
		


		override public function addBloodText(num:int,curentHp:int,timeArr:Array,completeFunc:Function=null,param:Object=null,damageType:int=0,showNum:Boolean=true):void
		{
//			ImageUtil.Instance.showBloodEx(timeArr,num,x,y,TypeImageText.Num_MonsterHurt,onBloodComplete,{param:param,func:completeFunc},damageType);
			var myY:Number=0;
			if(roleDyVo)
			{
				roleDyVo.hp=curentHp;
			}
			if(showNum)
			{
				ImageUtil.Instance.showBloodEx(timeArr,num,flashContainer,myY,TypeImageText.Monster,onBloodComplete,{param:param,func:completeFunc},damageType);
			}
			else 
			{
				onBloodComplete({param:param,func:completeFunc});
			}
		}
		/**设置怪物的颜色
		 */
		override public function updateName():void
		{
			_nameItem1.setText(roleDyVo.roleName,0x00FF00);
			reLocateNamePosition();
		}
		override public function dispose(childrenDispose:Boolean=true):void
		{
			super.dispose(childrenDispose);
		}
		
//		/** 怪物  死亡时候的移动  放在 player基类
//		 */		
//		public function deadMove(mapX:int,mapY:int,speed:Number=4,completeFunc:Function=null,completeParam:Object=null,forceUpdate:Boolean=false):void
//		{
//			pureMoveTo(mapX,mapY,speed,completeFunc,completeParam,forceUpdate);
//			var time:Number=(YFMath.distance(_mapX,_mapY,mapX,mapY)*UpdateManager.IntervalRate/speed)*0.001; // 单位为 s 
//			var moveY:Number=180*time/0.4;
//			if(_cloth.mainClip)	TweenLite.to(_cloth.mainClip,time*0.5,{scaleX:2,scaleY:2,y:-moveY, ease:Linear.easeNone,onComplete:completeOperator,onCompleteParams:[_cloth,time]});
////			TweenLite.to(_cloth.reflectionClip,time*0.5,{scaleX:2,scaleY:2,y:-100, ease:Linear.easeNone});
//		}
//		private function completeOperator(_cloth:Part2DCombine,time:Number):void
//		{
//			if(_cloth.mainClip)TweenLite.to(_cloth.mainClip,time*0.5,{scaleX:1,scaleY:1,y:0, ease:Linear.easeNone});
////			TweenLite.to(_cloth.reflectionClip,time*0.5,{scaleX:1,scaleY:1,y:0, ease:Linear.easeNone});
//
//		}
		


	}
}