package com.YFFramework.game.ui.yf2d.view.avatar
{
	import com.YFFramework.core.ui.yf2d.data.ATFActionData;
	import com.YFFramework.core.ui.yf2d.data.ATFBitmapFrame;
	import com.YFFramework.core.yf2d.display.DisplayObject2D;
	import com.YFFramework.core.yf2d.display.DisplayObjectContainer2D;
	import com.YFFramework.core.yf2d.extension.RolePartEffect2DView;
	import com.YFFramework.core.yf2d.extension.ShadowClip;
	import com.YFFramework.core.yf2d.extension.face.IReflection;
	import com.YFFramework.core.yf2d.extension.face.IYF2dMovie;
	import com.YFFramework.game.core.module.mapScence.world.view.player.AbsAnimatorView;
	
	import flash.display.BitmapData;
	import flash.display3D.textures.TextureBase;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix3D;
	import flash.geom.Point;

	/**包含  主场景 显示 对象 和 影子
	 * @author yefeng
	 * 2013 2013-5-9 上午10:09:28 
	 */
	public class Part2DCombine
	{
		/**阴影模版矩阵
		 */		
//		public static const ShadowMatrix:Matrix3D=new Matrix3D(Vector.<Number>([1,0,0,0,0.4959869384765625,0.70794677734375,0,0,0,0,1,0,-4.4499969482421875,2.649993896484375,0,1]));
		
		
		public static const RightShadowMatrix:Matrix3D=new Matrix3D(Vector.<Number>([1,0,0,0,0.3136444091796875,0.770477294921875,0,0,0,0,1,0,-2.8000030517578125,2.100006103515625,0,1]));
		
		
		public static const LeftShadowMatrix:Matrix3D=new Matrix3D(Vector.<Number>([1,0,0,0,-0.3136444091796875,0.770477294921875,0,0,0,0,1,0,2.8000030517578125,2.100006103515625,0,1]));

		
		
		
//		/**倒影采用 镜像  UV贴图翻转
//		 */		
		public static const ReflectionMatrix:Matrix3D=new Matrix3D(Vector.<Number>([1,0,0,0,0,0.787506103515625,0,0,0,0,1,0,0,1.899993896484375,0,1]));
		public static const RefleactionScaleY:Number=0.787506103515625;

		public static const MyColorTransform:ColorTransform=new ColorTransform(0,0,0,1.5,1.5,1.5);
		
		
		
		/**普通 动作
		 */		
		public var actionDataStandWalk:ATFActionData;
		/**战斗数据
		 */
		public var actionDataFight:ATFActionData;
		
		/**受击 死亡数据
		 */
		public var actionDataInjureDead:ATFActionData;

		
		/** 特殊 攻击动作 数据
		 */		
		public var actionDataAtk_1:ATFActionData;
		
		/** 战斗待机数据
		 */		
		public var actionDataFightStand:ATFActionData;
		
		
		
		
		
		
		/**普通 动作
		 */		
		public var effectStandWalk:ATFActionData;
		/**战斗数据
		 */
		public var effectFight:ATFActionData;
		
		/**受击 死亡数据
		 */
		public var effectInjureDead:ATFActionData;
		
		
		/** 特殊 攻击动作 数据
		 */		
		public var effectAtk_1:ATFActionData;
		
		/** 战斗待机数据
		 */		
		public var effectFightStand:ATFActionData;
		
		

		
		/**场景上的对象
		 */		
		public var mainClip:IYF2dMovie;
		/** 影子层上的对象
		 */		
		public var shadowClip:ShadowClip;
		/**倒影  SingleReflection 或者FlexbleReflection类
		 */		
		public var reflectionClip:IReflection;
		
		/**该玩家
		 */		
		private var _playerView:AbsAnimatorView;
		
		private var _leftMatrix:Matrix3D;
		private var _rightMatrix:Matrix3D;
		public function Part2DCombine(playerView:AbsAnimatorView)
		{
			initPlayer(playerView);
			shadowClip=new ShadowClip();
//			shadowClip.localColorTransform=MyColorTransform;
//			shadowClip.localModelMatrix=ShadowMatrix.clone();
//			shadowClip.alpha=0.3;
			initShadow();
		}
		/**创建影子矩阵
		 */		
		public  function initShadow():void
		{
			shadowClip.localColorTransform=MyColorTransform;
			shadowClip.alpha=0.3;
			_leftMatrix=LeftShadowMatrix.clone();
			_rightMatrix=RightShadowMatrix.clone();
			shadowClip.localModelMatrix=_leftMatrix;
		}
		public function initPlayer(playerView:AbsAnimatorView):void
		{
			_playerView=playerView;
		}
		public function initActionDataWalkStand(data:ATFActionData):void	
		{
			actionDataStandWalk=data;
			mainClip.initActionDataStandWalk(data);
			shadowClip.initActionDataStandWalk(data);
			reflectionClip.initActionDataStandWalk(data);
		} 
		
		public function initActionDataFight(data:ATFActionData):void	
		{
			actionDataFight=data;
			mainClip.initActionDataFight(data);
			shadowClip.initActionDataFight(data);
			reflectionClip.initActionDataFight(data);
		}

		
		public function initActionDataInjureDead(data:ATFActionData):void	
		{
			actionDataInjureDead=data;
			mainClip.initActionDataInjureDead(data);
			shadowClip.initActionDataInjureDead(data);
			reflectionClip.initActionDataInjureDead(data);
		}

		/**特殊攻击动作1
		 */		
		public function initActionDataAtk_1(data:ATFActionData):void
		{
			actionDataAtk_1=data;
			mainClip.initActionDataAtk_1(data);
			shadowClip.initActionDataAtk_1(data);
			reflectionClip.initActionDataAtk_1(data);
		}
		/**战斗待机
		 */		
		public function initActionDataFightStand(data:ATFActionData):void
		{
			actionDataFightStand=data;
			mainClip.initActionDataFightStand(data);
			shadowClip.initActionDataFightStand(data);
			reflectionClip.initActionDataFightStand(data);
		}
		
		
		/**添加光效
		 */
		public function initEffectStandWalk(data:ATFActionData):void	
		{
			effectStandWalk=data;
			RolePartEffect2DView(mainClip).initEffectStandWalk(data);
		}
		
		public function initEffectInjureDead(data:ATFActionData):void	
		{
			effectInjureDead=data;
			RolePartEffect2DView(mainClip).initEffectInjureDead(data);
		}

		public function initEffectFight(data:ATFActionData):void	
		{
			effectFight=data;
			RolePartEffect2DView(mainClip).initEffectFight(data);
		}

		
		/**特殊攻击动作1   光效
		 */		
		public function initEffectAtk_1(data:ATFActionData):void
		{
			effectAtk_1=data;
			RolePartEffect2DView(mainClip).initEffectAtk_1(data);
		}
		/**战斗待机    光效 
		 */		
		public function initEffectFightStand(data:ATFActionData):void
		{
			effectFightStand=data;
			RolePartEffect2DView(mainClip).initEffectFightStand(data);
		}
		public function setBitmapFrame(bitmapFrameData:ATFBitmapFrame,texture:TextureBase,atlasData:BitmapData,scaleX:Number=1):void
		{
			mainClip.setBitmapFrame(bitmapFrameData,texture,atlasData,scaleX);
			shadowClip.setBitmapFrame(bitmapFrameData,texture,atlasData,scaleX);
			reflectionClip.setBitmapFrame(bitmapFrameData,texture,atlasData,scaleX);
		}
		/**停止播放
		 */		
		public function playTweenStop():void
		{
			mainClip.stop();
			shadowClip.stop();
			reflectionClip.stop();
		}

		public function play(action:int, direction:int=-1, loop:Boolean=true, completeFunc:Function=null,completeParam:Object=null,resetPlay:Boolean=false):void
		{
			if(direction>=1&&direction<=4)
			{
				shadowClip.localModelMatrix=_rightMatrix;
			}
			else 
			{
				shadowClip.localModelMatrix=_leftMatrix;
			}
			mainClip.play(action,direction,loop,completeFunc,completeParam,resetPlay);
			shadowClip.play(action,direction,loop,null,null,resetPlay);
			if(_playerView.isReflection)
			{
				reflectionClip.play(action,direction,loop,null,null,true);
				reflectionClip.start();
			}
			else 
			{
				reflectionClip.stop();
			}
		}
		
		public function start():void
		{
			mainClip.start();
			shadowClip.start();
		}
		public function stop():void
		{
			mainClip.stop();
			shadowClip.stop();
			reflectionClip.stop();
		}
		

		
		public function playDefault(loop:Boolean=true,completeFunc:Function=null,completeParam:Object=null,resetPlay:Boolean=true):void
		{
			mainClip.playDefault(loop,completeFunc,completeParam,resetPlay);
			shadowClip.playDefault(loop,null,null,resetPlay);
			if(_playerView.isReflection)
			{
				reflectionClip.playDefault(loop,null,null,true);
				reflectionClip.start();
			}
			else reflectionClip.stop();
		}
		public function playDefaultAction(direction:int,loop:Boolean=true,completeFunc:Function=null,completeParam:Object=null,resetPlay:Boolean=true):void
		{
			mainClip.playDefaultAction(direction,loop,completeFunc,completeParam,resetPlay);
			shadowClip.playDefaultAction(direction,loop,null,null,resetPlay);
			if(_playerView.isReflection)
			{
				reflectionClip.playDefaultAction(direction,loop,null,null,true);
				reflectionClip.start();
			}
			else reflectionClip.stop();
		}
		public function pureStop():void
		{
			mainClip.pureStop();
			shadowClip.pureStop();
			reflectionClip.pureStop();
		}
		
		public function gotoAndStop(index:int,action:int,direction:int):void
		{
			mainClip.gotoAndStop(index,action,direction);
			shadowClip.gotoAndStop(index,action,direction);
			if(_playerView.isReflection)
			{
				reflectionClip.gotoAndStop(index,action,direction);
			}
		}
		
		public function getIntersect(parentPt:Point,parentContainer:DisplayObjectContainer2D=null):Boolean
		{
			return mainClip.getIntersect(parentPt,parentContainer);
		}


		
		public function resetData():void
		{
			mainClip.resetData();
			shadowClip.resetData();
			reflectionClip.resetData();
		}
		
		public function set visible(value:Boolean):void
		{
			DisplayObject2D(mainClip).visible=value;
			shadowClip.visible=value;
			DisplayObject2D(reflectionClip).visible=value;
		}
		public function get visible():Boolean
		{
			return DisplayObject2D(mainClip).visible;
		}
		public function dispose():void
		{
			_playerView=null;
			if(DisplayObject2D(mainClip).parent)DisplayObject2D(mainClip).parent.removeChild(DisplayObject2D(mainClip));
			if(shadowClip.parent)shadowClip.parent.removeChild(shadowClip);
			if(DisplayObject2D(reflectionClip).parent)DisplayObject2D(reflectionClip).parent.removeChild(DisplayObject2D(reflectionClip));
			DisplayObject2D(mainClip).dispose(true);
			shadowClip.dispose(true);
			DisplayObject2D(reflectionClip).dispose(true);
			mainClip=null;
			shadowClip=null;
			reflectionClip=null;
			actionDataStandWalk=null;
		}

		public function get scaleY():Number
		{
			if(mainClip)
			{
				return DisplayObject2D(mainClip).scaleY;
			}
			return 0.001;
		}
		
		public function set scaleY(value:Number):void
		{
			if(mainClip)  //没有释放内存的话
			{
				DisplayObject2D(mainClip).scaleY=value;
				shadowClip.scaleY=value;
				DisplayObject2D(reflectionClip).scaleY=value;
			}
		}
		
		public function set scaleX(value:Number):void
		{
			if(mainClip)  //没有释放内存的话
			{
				DisplayObject2D(mainClip).scaleX=value;
				shadowClip.scaleX=value;
				DisplayObject2D(reflectionClip).scaleX=value;
			}
		}
		public function get scaleX():Number
		{
			if(mainClip)return DisplayObject2D(mainClip).scaleX;
			else return 0.001;
		}

		/**释放到对象池
		 */		
		public function disposeToPool():void
		{
			_playerView=null;
			actionDataStandWalk=null;
			actionDataAtk_1=null;
			actionDataFightStand=null;
			actionDataFight=null;
			actionDataInjureDead=null;
			if(DisplayObject2D(mainClip).parent)DisplayObject2D(mainClip).parent.removeChild(DisplayObject2D(mainClip));
			if(shadowClip.parent)shadowClip.parent.removeChild(shadowClip);
			if(DisplayObject2D(reflectionClip).parent)DisplayObject2D(reflectionClip).parent.removeChild(DisplayObject2D(reflectionClip));
			mainClip.disposeToPool();
			shadowClip.disposeToPool();
			reflectionClip.disposeToPool();
		}
		/** 从对象池中初始化
		 */		
		public function initFromPool():void
		{
			mainClip.initFromPool();
			shadowClip.initFromPool();
			reflectionClip.initFromPool();
		}
		
	}
}