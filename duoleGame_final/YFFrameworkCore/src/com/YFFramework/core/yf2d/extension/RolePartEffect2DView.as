package com.YFFramework.core.yf2d.extension
{
	/**人物模型部位   含有   特效 的模型部位   如  人物  衣服  武器
	 * @author yefeng
	 * 2013 2013-8-16 下午2:50:23 
	 */
	import com.YFFramework.core.ui.yf2d.data.ATFActionData;
	import com.YFFramework.core.ui.yf2d.data.ATFBitmapFrame;
	import com.YFFramework.core.yf2d.display.DisplayObjectContainer2D;
	import com.YFFramework.core.yf2d.extension.face.IYF2dMovie;
	
	import flash.display.BitmapData;
	import flash.display3D.textures.TextureBase;
	import flash.geom.Point;
	
	public class RolePartEffect2DView extends DisplayObjectContainer2D  implements IYF2dMovie
	{
		private var _part:RolePart2DView;
		
		private var _effect:RolePart2DView;
		
		
		public function RolePartEffect2DView()
		{
			super();
			initUI();
		}
		/**初始化UI 
		 */		
		private function initUI():void
		{
			_part=new RolePart2DView();
			addChild(_part);
		}
		/**更新  模型
		 */		
		public function initActionDataStandWalk(actionData:ATFActionData):void
		{
			_part.initActionDataStandWalk(actionData);
		}
		
		public function initActionDataInjureDead(actionData:ATFActionData):void
		{
			_part.initActionDataInjureDead(actionData);
		}

		public function initActionDataFight(actionData:ATFActionData):void
		{
			_part.initActionDataFight(actionData);
		}
		
		/** 特殊攻击
		 */
		public function initActionDataAtk_1(actionData:ATFActionData):void
		{
			_part.initActionDataAtk_1(actionData);
		}
		
		public function initActionDataFightStand(actionData:ATFActionData):void
		{
			_part.initActionDataFightStand(actionData);
		}
		
		
		/**更新特效
		 */		
		public function initEffectStandWalk(actionData:ATFActionData):void
		{
			if(actionData)	
			{
				if(!_effect)
				{
					_effect=new RolePart2DView();
					addChild(_effect);
				}
				else 
				{
					if(!contains(_effect)) addChild(_effect);
				}
				_effect.initActionDataStandWalk(actionData);
			}
			else  //null
			{
				if(_effect)
				{
					_effect.initActionDataStandWalk(null);
					_effect.resetData();
					if(contains(_effect)) removeChild(_effect);
				}
			}
		}
		
		/** 特效特殊攻击
		 */
		public function initEffectInjureDead(actionData:ATFActionData):void
		{
			if(actionData)	
			{
				if(!_effect)
				{
					_effect=new RolePart2DView();
					addChild(_effect);
				}
				else 
				{
					if(!contains(_effect)) addChild(_effect);
				}
				_effect.initActionDataInjureDead(actionData);
			}
			else  //null
			{
				if(_effect)
				{
					_effect.initActionDataInjureDead(null);
					_effect.resetData();
					if(contains(_effect)) removeChild(_effect);
				}
			}
		}
		
		/** 特效特殊攻击
		 */
		public function initEffectFight(actionData:ATFActionData):void
		{
			if(actionData)	
			{
				if(!_effect)
				{
					_effect=new RolePart2DView();
					addChild(_effect);
				}
				else 
				{
					if(!contains(_effect)) addChild(_effect);
				}
				_effect.initActionDataFight(actionData);
			}
			else  //null
			{
				if(_effect)
				{
					_effect.initActionDataFight(null);
					_effect.resetData();
					if(contains(_effect)) removeChild(_effect);
				}
			}
		}
		
		/** 特效特殊攻击
		 */
		public function initEffectAtk_1(actionData:ATFActionData):void
		{
			if(actionData)	
			{
				if(!_effect)
				{
					_effect=new RolePart2DView();
					addChild(_effect);
				}
				else 
				{
					if(!contains(_effect)) addChild(_effect);
				}
				_effect.initActionDataAtk_1(actionData);
			}
			else  //null
			{
				if(_effect)
				{
					_effect.initActionDataAtk_1(null);
					_effect.resetData();
					if(contains(_effect)) removeChild(_effect);
				}
			}
		}
		/**特效战斗待机
		 */		
		public function initEffectFightStand(actionData:ATFActionData):void
		{
			if(actionData)	
			{
				if(!_effect)
				{
					_effect=new RolePart2DView();
					addChild(_effect);
				}
				else 
				{
					if(!contains(_effect)) addChild(_effect);
				}
				_effect.initActionDataFightStand(actionData);
			}
			else  //null
			{
				if(_effect)
				{
					_effect.initActionDataFightStand(null);
					_effect.resetData();
					if(contains(_effect)) removeChild(_effect);
				}
			}
		}
		
		public function get partActionData():ATFActionData
		{
			return _part.actionDataStandWalk;
		}
		
		public function start():void
		{
			_part.start();
			if(_effect)_effect.start();
		}
		
		public function stop():void
		{
			_part.stop();
			if(_effect)_effect.stop();
		}
		
		public function play(action:int, direction:int=-1, loop:Boolean=true, completeFunc:Function=null, completeParam:Object=null, resetPlay:Boolean=false):void
		{
			_part.play(action,direction,loop,completeFunc,completeParam,resetPlay);
			if(_effect)_effect.play(action,direction,loop,null,null,resetPlay);
		}
		
		public function playDefault(loop:Boolean=true,completeFunc:Function=null,completeParam:Object=null,resetPlay:Boolean=true):void
		{
			_part.playDefault(loop,completeFunc,completeParam,resetPlay);
			if(_effect)_effect.playDefault(loop,null,null,resetPlay);
		}
		/** 播放默认动作
		 */		
		public function playDefaultAction(direction:int,loop:Boolean=true,completeFunc:Function=null,completeParam:Object=null,resetPlay:Boolean=true):void
		{
			_part.playDefaultAction(direction,loop,completeFunc,completeParam,resetPlay);
			if(_effect)_effect.playDefaultAction(direction,loop,null,null,resetPlay);
		}
		
		public function resetData():void
		{
			_part.resetData();
			if(_effect)_effect.resetData();
		}
		
		public function setBitmapFrame(bitmapFrameData:ATFBitmapFrame, texture:TextureBase, atlasData:BitmapData, scaleX:Number=1):void
		{
			_part.setBitmapFrame(bitmapFrameData,texture,atlasData,scaleX);
			if(_effect)_effect.setBitmapFrame(bitmapFrameData,texture,atlasData,scaleX);
		}
		

		/**单纯的停止播放
		 */		
		public function pureStop():void
		{
			_part.pureStop();
			if(_effect)_effect.pureStop();
		}
		
		public function gotoAndStop(index:int,action:int,direction:int):void
		{
			_part.gotoAndStop(index,action,direction);
			if(_effect)_effect.gotoAndStop(index,action,direction);
		}

		/** parentPt是  parentContainer坐标系下的坐标，parentContainer为空时表示根容器舞台 
		 *   判断该点是否在 Sprite2D对象身上   假如该点透明也就不在身上
		 */
		public function getIntersect(parentPt:Point,parentContainer:DisplayObjectContainer2D=null):Boolean
		{
			return _part.getIntersect(parentPt,parentContainer);
		}

		
		override public function dispose(childrenDispose:Boolean=true):void
		{
			super.dispose(childrenDispose);
			if(_effect)
			{
				if(!_effect.isDispose)_effect.dispose(childrenDispose);
			}
			_part=null;
			_effect=null;
		}
		
		
		public function disposeToPool():void 
		{
			_part.disposeToPool();
			if(_effect)_effect.disposeToPool();
		}
		
		public function initFromPool():void
		{
			_part.initFromPool();
			if(_effect)_effect.initFromPool();
			visible=true;
//			x=0;
//			y=0;
//			scaleX=1;
//			scaleY=1;
			setXYScaleXY(0,0,1,1);
		}

		
	}
}