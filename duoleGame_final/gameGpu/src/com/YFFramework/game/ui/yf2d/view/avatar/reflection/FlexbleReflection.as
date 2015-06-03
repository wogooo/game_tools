package com.YFFramework.game.ui.yf2d.view.avatar.reflection
{
	/**@author yefeng
	 * 2013 2013-6-20 下午12:24:25 
	 */
	import com.YFFramework.core.ui.yf2d.data.ATFActionData;
	import com.YFFramework.core.ui.yf2d.data.ATFBitmapFrame;
	import com.YFFramework.core.ui.yf2d.view.Abs2dView;
	import com.YFFramework.core.yf2d.extension.face.IReflection;
	
	import flash.display.BitmapData;
	import flash.display3D.textures.TextureBase;
	
	/**生成 倒影的 类  倒影 也有 层级 关系 所以 必须单独成一个类    该 倒影类 只用于玩家    也就是 具有多个 部位的    对象   ，  
	 * 该类主要的作用是可以设置  xy   而 singleReflection 不能设置  x y 
	 */	
	public class FlexbleReflection extends Abs2dView implements IReflection
	{

		private var reflectionClip:SingleReflection;
		/**可以设置    xy 属性
		 */		
		public function FlexbleReflection()
		{
			super();
			
			reflectionClip=new SingleReflection();
			reflectionClip.initReflection()
//			reflectionClip.alpha=0.4;
//			reflectionClip.localModelMatrix=Part2DCombine.ReflectionMatrix.clone();
//			reflectionClip.uvScaleY=-1;
			addChild(reflectionClip);
		}
		public function initActionDataStandWalk(data:ATFActionData):void	
		{
			reflectionClip.initActionDataStandWalk(data);
		}
		
		public function initActionDataInjureDead(data:ATFActionData):void	
		{
			reflectionClip.initActionDataInjureDead(data);
		}

		public function initActionDataFight(data:ATFActionData):void	
		{
			reflectionClip.initActionDataFight(data);
		}
		
		/**特殊攻击动作1
		 */		
		public function initActionDataAtk_1(data:ATFActionData):void
		{
			reflectionClip.initActionDataAtk_1(data);
		}
		
		/**特殊动作  战斗待机
		 */		
		public function initActionDataFightStand(data:ATFActionData):void
		{
			reflectionClip.initActionDataFightStand(data);
		}
		
		public function setBitmapFrame(bitmapFrameData:ATFBitmapFrame,texture:TextureBase,atlasData:BitmapData,scaleX:Number=1):void
		{
			reflectionClip.setBitmapFrame(bitmapFrameData,texture,atlasData,scaleX);
		}
		public function play(action:int, direction:int=-1, loop:Boolean=true, completeFunc:Function=null,completeParam:Object=null,resetPlay:Boolean=false):void
		{
			reflectionClip.play(action,direction,loop,completeFunc,completeParam,resetPlay);
		}
		
		public function start():void
		{
			reflectionClip.start();
		}
		public function stop():void
		{
			reflectionClip.stop();
		}
		public function playDefault(loop:Boolean=true,completeFunc:Function=null,completeParam:Object=null,resetPlay:Boolean=true):void
		{
			 reflectionClip.playDefault(loop,completeFunc,completeParam,resetPlay);
		}
		public function playDefaultAction(direction:int,loop:Boolean=true,completeFunc:Function=null,completeParam:Object=null,resetPlay:Boolean=true):void
		{
			reflectionClip.playDefaultAction(direction,loop,completeFunc,completeParam,resetPlay);
		}
		public function pureStop():void
		{
			reflectionClip.pureStop();
		}
		
		public function gotoAndStop(index:int,action:int,direction:int):void
		{
			reflectionClip.gotoAndStop(index,action,direction);
		}
		public function resetData():void
		{
			reflectionClip.resetData();
		}
		
		override public function dispose(childrenDispose:Boolean=true):void
		{
			super.dispose(childrenDispose);
			reflectionClip=null;
		}
		
		public function disposeToPool():void
		{
			reflectionClip.disposeToPool();
			scaleX=1;
			scaleY=1;
			visible=true;
		}
		
		public function initFromPool():void
		{
			reflectionClip.initFromPool();
		}
	}
}