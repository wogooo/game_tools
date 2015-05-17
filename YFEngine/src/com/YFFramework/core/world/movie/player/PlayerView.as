package com.YFFramework.core.world.movie.player
{
	/**@author yefeng
	 *2012-4-20下午10:31:32
	 */
	import com.YFFramework.core.center.pool.AbsUIPool;
	import com.YFFramework.core.center.pool.IPool;
	import com.YFFramework.core.center.pool.PoolCenter;
	import com.YFFramework.core.debug.print;
	import com.YFFramework.core.ui.layer.LayerManager;
	import com.YFFramework.core.ui.movie.data.TypeAction;
	import com.YFFramework.core.ui.movie.data.TypeDirection;
	import com.YFFramework.core.ui.res.CommonFla;
	import com.YFFramework.core.ui.yf2d.data.BitmapFrameData;
	import com.YFFramework.core.ui.yf2d.data.MovieData;
	import com.YFFramework.core.ui.yf2d.data.YF2dActionData;
	import com.YFFramework.core.ui.yf2d.view.Abs2dView;
	import com.YFFramework.core.ui.yf2d.view.Abs2dViewPool;
	import com.YFFramework.core.ui.yf2d.view.avatar.BodyView2D;
	import com.YFFramework.core.ui.yf2d.view.avatar.EffectPart2DView;
	import com.YFFramework.core.ui.yf2d.view.avatar.YF2dChatArrow;
	import com.YFFramework.core.ui.yf2d.view.avatar.YF2dProgressBar;
	import com.YFFramework.core.utils.tween.game.TweenSkill;
	import com.YFFramework.core.utils.tween.game.TweenSuperSkill;
	import com.YFFramework.core.world.mapScence.map.BgMapScrollport;
	import com.YFFramework.core.world.model.MonsterDyVo;
	import com.YFFramework.core.world.movie.player.utils.DirectionUtil;
	import com.YFFramework.game.ui.imageText.ImageTextManager;
	import com.YFFramework.game.ui.imageText.TypeImageText;
	import com.greensock.TweenLite;
	import com.greensock.easing.Back;
	
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	
	import yf2d.display.sprite2D.YF2dClip;
	import yf2d.display.sprite2D.YF2dGameNameLabel;
	import yf2d.events.YF2dMouseEvent;
	
	public class PlayerView extends AbsAnimatorView
	{

		/**是否已经死亡
		 */		
		public var isDead:Boolean;
		
		/**影子
		 */		
		protected var _shadow:YF2dClip;
		///人物角色变色
		protected static const DefaultColortransform:ColorTransform=new ColorTransform();
		///人物变色
		protected static const SelectBodyColorTransform:ColorTransform=new  ColorTransform(1.4, 1.4, 1.5, 1, 0, 0, 0);
		///名字变色
		protected static const SelectNameColorTransform:ColorTransform=new ColorTransform(1.5, 0, 0.1, 1, -61, -71, -176);

		protected var _nameLayer:Abs2dView;
		/**角色名称1
		 */
		protected  var _nameItem1:YF2dGameNameLabel;
		/**特效容器   比如升级  
		 */
		protected var _upEffectPart:EffectPart2DView;

		/** 最里层特效层
		 */
		protected var _downEffectPart:EffectPart2DView;
		
		
		
		/**  人物进行瞬移 产生的多个人物的容器
		 */
		protected var _blinkLayer:Abs2dViewPool;
		///瞬移中断执行函数
		private var _blinkBreakFunc:Function;
		private var _blinkBreakParam:Object;
		/** 人物瞬移 需要的变量
		 */		
//		private var _filters:BlurFilter;
		private var _blinkComplete:Function;
		private var _blinkCompleteParams:Object;
		private const constValue:int=25;
		private	const constValueX:int=20;
		private const constValueY:int=16;
		private const maxBodyNum:int=10;


		/**  人物血条
		 */		
		protected var _bloodMC:YF2dProgressBar;
		
		private var _tweenSuperSkill:TweenSuperSkill;
		/**场景聊天冒泡控件
		 */		
		protected var _chatArrow:YF2dChatArrow;

		/**是否发光
		 */
		protected var _glow:Boolean;
		public function PlayerView(roleDyVo:MonsterDyVo=null)
		{
			super(roleDyVo);
			mouseChildren=false;
		}
		override protected function initUI():void
		{
			super.initUI();
			initShowdow();
			initBloodLayer();
			initNameLayer();
//			_filters=new BlurFilter(3,3);
		}

		protected function initNameLayer():void
		{
			_nameLayer=new Abs2dView();
			addChild(_nameLayer);
			_nameLayer.mouseEnabled=false;
			_nameLayer.y=-140;
			_nameLayer.x=-28;
			
			_nameItem1=new YF2dGameNameLabel();
			_nameLayer.addChild(_nameItem1);
	//		_nameItem1.setText(_roleDyVo.roleName?_roleDyVo.roleName:_nameItem1.text);
			addNameItem();
		}
		/**初始化其他名称
		 */		
		protected function addNameItem():void
		{
		//	_nameItem1.text=roleDyVo.roleName;
			_nameItem1.setText(roleDyVo.roleName);
		//	_nameItem1.extractWidth();
		}
		/** 释放名字层其他名字内存
		 */		
		protected function removeNameLayer():void
		{
//			_nameItem1.text="";
			_nameLayer.removeChild(_nameItem1);
			_nameLayer.removeAllChildren(true);  ///释放其他内存
			_nameLayer.addChild(_nameItem1);
		}
		
		/**初始化血条
		 */ 
		protected function initBloodLayer():void
		{
			_bloodMC=new YF2dProgressBar();
			_bloodMC.x=-28;
			_bloodMC.y=-120;
			_bloodMC.mouseChildren=_bloodMC.mouseEnabled=false;
			addChild(_bloodMC);
			updateHp(1);
		}
		override protected function initEquipment():void
		{
			_cloth=new BodyView2D();
			_cloth.start();
			resetSkin();
			addChild(_cloth);
		}
		protected function initShowdow():void
		{
			_shadow=new YF2dClip();
			_shadow.setBitmapFrame(CommonFla.ShadowTexture,CommonFla.ShadowTexture.flashTexture,CommonFla.ShadowTexture.atlasData);
			addChild(_shadow);
			_shadow.pivotX=-_shadow.width*0.5;
			_shadow.pivotY=-_shadow.height*0.5;
		}
		/// 透明度不能去掉
		override protected function addEvents():void
		{
			super.addEvents();
			addEventListener(YF2dMouseEvent.MOUSE_OUT,onMouseEvent);
			addEventListener(YF2dMouseEvent.MOUSE_OVER,onMouseEvent);
		}
		
		override protected function removeEvents():void
		{
			super.removeEvents();
			removeEventListener(YF2dMouseEvent.MOUSE_OUT,onMouseEvent);
			removeEventListener(YF2dMouseEvent.MOUSE_OVER,onMouseEvent);

		}
		private function onMouseEvent(e:YF2dMouseEvent):void
		{

				switch(e.type)
				{
					case YF2dMouseEvent.MOUSE_OUT:
						glow=false;
						break;
					case YF2dMouseEvent.MOUSE_OVER:
						glow=true;
						break;
				}	
			
		}
		/** 设置血量 value  为百分比  value的值为 0-1
		 */		
		public function updateHp(value:Number):void
		{
			if(value<0)value=0;
			_bloodMC.setPercent(value);
		}
		
		
		/**  发光  body对象发光
		 */
		private function set glow(value:Boolean):void
		{
			_glow=value;
			if(value)
			{
				_cloth.colorTransform=SelectBodyColorTransform;
				///名字变颜色
				_nameItem1.colorTransform=SelectNameColorTransform;
				
			}
			else 
			{
				_cloth.colorTransform=DefaultColortransform;
				///名字变颜色
				_nameItem1.colorTransform=DefaultColortransform;
			}
		}
		private function get glow():Boolean
		{
			return _glow;
		}
		
		override public function play(action:int,direction:int=-1,loop:Boolean=true,completeFunc:Function=null,completeParam:Object=null,resetPlay:Boolean=false):void
		{
			if(direction==-1)	direction=_activeDirection;
			_activeAction=action;
			_activeDirection=direction;

			if(YF2dActionData.isUsableActionData(_cloth.actionData))
			{
				_cloth.play(action,direction,loop,completeFunc,completeParam,resetPlay);
			}
		}
		
		
		override public function updateCloth(actionData:YF2dActionData):void
		{
			super.updateCloth(actionData);
		//	var isLoop:Boolean=true;
			if(_activeAction!=TypeAction.Dead)
			{
				if(_activeAction!=-1&&_activeDirection!=-1)	play(_activeAction,_activeDirection,true,null,null,true);
				else playDefault(true);
			}
			else  /// dead 
			{
				stayDead(_activeDirection);
			}
		}
		
		
		override public function set roleDyVo(roleDyvo:MonsterDyVo):void
		{
			super.roleDyVo=roleDyvo;
			_nameItem1.setText(_roleDyVo.roleName?_roleDyVo.roleName:_nameItem1.text);
		}
		
		
		/** 瞬移  创建多个  body 进行移动    bodyNum 是瞬移产生的影子个数    移动
		 */
		public function updateBlinkMove(mapX:Number,mapY:Number,complete:Function=null,completeParams:Object=null,forceUpdate:Boolean=false,breakFunc:Function=null,breakParam:Object=null):void
		{
			///方向
			_blinkBreakFunc=breakFunc;
			_blinkBreakParam=breakParam;
			var len:int=Math.sqrt(Math.pow(mapX-_roleDyVo.mapX,2)+Math.pow(mapY-_roleDyVo.mapY,2));
	//		print(this,"len",len);
			var bodyNum:int=int(len/BgMapScrollport.HeroWidth);
			if(bodyNum>maxBodyNum) bodyNum=maxBodyNum;
			
			_blinkComplete=complete;
			_blinkCompleteParams=completeParams;
			var direction:int=DirectionUtil.getDirection(_roleDyVo.mapX,_roleDyVo.mapY,mapX,mapY);
			var roleDirection:int=direction;///角色站立的方向实际方向
			if(_blinkLayer)
			{
				_blinkLayer.disposeToPool();  ///释放上一次的瞬移
				_blinkLayer=null;
			}
			_blinkLayer=PoolCenter.Instance.getFromPool(Abs2dViewPool) as Abs2dViewPool;
			if(!contains(_blinkLayer))addChild(_blinkLayer);
			
			///取第三张图片 
			var spaceX:int;
			var spaceY:int;
			var lastX:int=0;
			var lastY:int=0;		
			var scaleX:int=1;
			switch(direction)
			{
				case TypeDirection.Up:
					spaceX=0;
					spaceY=constValue;///从上往下排列
					break;;
				case TypeDirection.RightUp:
					spaceX=-constValueX;
					spaceY=constValueY;
					break;
				case TypeDirection.Right:
					spaceX=-constValue;
					spaceY=0;
					break;
				case TypeDirection.RightDown:
					spaceX=-constValueX;
					spaceY=-constValueY;
					break;
				case TypeDirection.Down:
					spaceX=0;
					spaceY=-constValue;
					break;
				case TypeDirection.LeftDown:
					spaceX=constValueX;
					spaceY=-constValueY;
					scaleX=-1;
					direction=TypeDirection.RightDown;
					break;
				case TypeDirection.Left:
					spaceX=constValue;
					spaceY=0;
					scaleX=-1;
					direction=TypeDirection.Right;
					break;
				case TypeDirection.LeftUp:
					spaceX=constValueX;
					spaceY=constValueY;
					scaleX=-1;
					direction=TypeDirection.RightUp;
					break;
				
			}
			var frameIndex:int=3;//停留的帧
			var movieData:MovieData;
			var bitmapDataEx:BitmapFrameData;
			if(_cloth.actionData)
			{
				movieData=_cloth.actionData.getDirectionData(TypeAction.Walk,direction); ////镜像所需要的方向
				bitmapDataEx=movieData.dataArr[frameIndex];
			}
			else bitmapDataEx=_cloth.getBitmapFrameData();
			
			var mc:YF2dClip;
			for(var i:int=0;i!=bodyNum;++i)
			{
				lastX +=spaceX;
				lastY +=spaceY;
				mc=new YF2dClip();
				_blinkLayer.addChild(mc);
				mc.setBitmapFrame(bitmapDataEx,movieData.getTexture(),movieData.bitmapData,scaleX);
				mc.updateUVData(bitmapDataEx.getUVData(scaleX));   ///更新  uv 进行翻转
				mc.letTopRegister();
				///定位
				mc.x=lastX;
				mc.y=lastY;
				mc.alpha=1.1-i/bodyNum
			}
			var speed:int=30; ///瞬移速度
			gotoAndStop(TypeAction.Walk,roleDirection,frameIndex); ////
			pureMoveTo(mapX,mapY,speed,blinkComplete,roleDirection,forceUpdate,blinkBreak,roleDirection);
		}
		/**瞬移结束
		 */		
		private function blinkBreak(data:Object):void
		{
			var direction:int=int(data);
			disposeBlinkLayer();
			play(TypeAction.Stand,direction,true,null,null,true);
			if(_blinkBreakFunc!=null)_blinkBreakFunc(_blinkBreakParam);
		}
		///瞬移结束
		private function blinkComplete(data:Object=null):void
		{
			var direction:int=int(data);
			disposeBlinkLayer();
			play(TypeAction.Stand,direction,true,null,null,true);
			if(_blinkComplete!=null)_blinkComplete(_blinkCompleteParams);
			print(this,"blinkMoveComplete......");

		} 
		/**释放瞬移层
		 */ 
		private function disposeBlinkLayer():void
		{
			if(_blinkLayer)
			{
				print(this,"isPool:",_blinkLayer.isPool);
				if(!_blinkLayer.isPool)  ///将瞬移层给去掉
				{
					removeBlinkLayer();
				}
			}
		}
		/**瞬移层
		 */		
		protected function removeBlinkLayer():void
		{
			if(contains(_blinkLayer))removeChild(_blinkLayer);
			_blinkLayer.disposeToPool();
			_blinkLayer=null;
			_cloth.start();
		//	print(this,"cloth--start1111-------");	
		}
		
//		public  function gotoAndStop(action:int,direction:int,frameIndex:int,scaleX:int):void
//		{
//			_activeAction=action;
//			_activeDirection=direction;
//			_cloth.gotoAndStop(frameIndex,action,direction);
//			_cloth.scaleX=scaleX;
//		}

		
		/**上层特效
		 * @param timesArr 每隔多少时间 执行一次函数调用 播放一次数据 
		 * @param totalTimes 该特效播放的时间长度  不管特效是否循环播放 当超过这个世界就会将特效进行移除
		 * @loop  特效播放 是否循环 播放
		 */
		public function addFrontEffect(actionData:YF2dActionData,timesArr:Array,loop:Boolean=false,skinType:int=2,direction:int=-1):void
		{
			if(direction==-1) direction=_activeDirection;
			if(_upEffectPart)
			{
				if(!_upEffectPart.parent)
				{
					addChild(_upEffectPart);
				}
				_upEffectPart.playEffect(actionData,timesArr,loop,skinType,direction);
			}
			else 
			{
				_upEffectPart=new EffectPart2DView()
				addChild(_upEffectPart);
				_upEffectPart.playEffect(actionData,timesArr,loop,skinType,direction);
			}
		}
		/** 移除上层特效
		 */		
		public function removeFrontEffect():void
		{
			if(_upEffectPart)
			{
				if(_upEffectPart.parent)
				{
				//	_upEffectPart.dispose();
					_upEffectPart.removeAllMovie();
				}
					
			}
		}
		
		
		
		/**下层特效
		 * @param waitIme   播放该特效需要等待的时间
		 * @param totalTimes 该特效播放的时间长度  不管特效是否循环播放 当超过这个世界就会将特效进行移除
		 * @loop  特效播放 是否循环 播放
		 */
		public function addBackEffect(actionData:YF2dActionData,timesArr:Array,loop:Boolean=false,skinType:int=2,direction:int=-1):void
		{
			if(direction==-1) direction=_activeDirection;
			if(_downEffectPart)
			{
				if(!_downEffectPart.parent)
				{
					addChildAt(_downEffectPart,0);
				}
				_downEffectPart.playEffect(actionData,timesArr,loop,skinType,direction);
			}
			else 
			{
				_downEffectPart=new EffectPart2DView();
				addChildAt(_downEffectPart,0);  
				_downEffectPart.playEffect(actionData,timesArr,loop,skinType,direction);
			}
		}
	
		/** 扣血 文字
		 * 战斗性的文字  1 2 3 4 5 6 7  8 9 
		 * num  为显示的数字
		 * delayTime 为 延迟的时间 单位为毫秒
		 */	
		public function addBloodText(num:int,hpPercent:Number,delayTime:int):void
		{
			waitToExcute(num,hpPercent,delayTime);
		}
		
		protected function addBloodTextFunc(obj:Object):void
		{
			var num:int=obj.num;
			var hpPercent:Number=obj.hpPercent;
			var numSkinId:int=TypeImageText.Num_Yellow_4;
			var ui:AbsUIPool=ImageTextManager.Instance.createNumWidthPre(num.toString(),numSkinId);
			LayerManager.FightTextLayer.addChild(ui);
			ui.x=x-ui.width*0.5;
			ui.y=y-100;
			TweenLite.to(ui,0.5,{y:ui.y-70,x:ui.x,ease:Back.easeOut,onComplete:completeFightText,onCompleteParams:[ui]});
			///扣血
			updateHp(hpPercent);
		}
		private function waitToExcute(num:int,hpPercent:Number,delayTime:int=200):void
		{
			TweenSkill.WaitToExcute(delayTime,addBloodTextFunc,{num:num,hpPercent:hpPercent});
		}
		
		
		/** 添加 描述性文字 比如经验增加多少 啊 
		 * 创建文字   包含文本和数字
		 *   比如 经验+5     textId 就是  经验      num 是 5   skinId 是num的样式  文字默认有 +号 
		 * numType 值为 0 表示没有 + - 号  为  1 表示 +  为2  表示-
		 */		
		public function  addFightTextEffect(textId:int,num:String,numSkinId:int):void
		{
			var ui:AbsUIPool=ImageTextManager.Instance.createTextNum(textId,num,numSkinId);
			LayerManager.FightTextLayer.addChild(ui);
			ui.x=x-10;
			ui.y=y-100;
			TweenLite.to(ui,0.5,{y:ui.y-150,x:ui.x,ease:Back.easeOut,onComplete:completeFightText,onCompleteParams:[ui]});
		}
		protected function completeFightText(params:Object):void
		{
			var ui:AbsUIPool=params as AbsUIPool;
			LayerManager.FightTextLayer.removeChild(ui);
			ui.disposeToPool();
		}
		
		/**
		 * @param action  动作
		 * @param direction 值为  -1 表示采用 先前的方向
		 * @param timesArr	函数播放时间轴 
		 * @param playFunc	执行函数
		 * @param playParam	函数参数
		 * @completeFunc   playFunc每次执行完成后调用
		 * @completeParam	playFunc参数
		 * @totalTimes  执行的总时间     totalTimes一般大于等于 timesArr[timesArr.length-1]
		 * @totalCompleteFunc  时间到后执行的函数
		 * breakFunc   在 totalCompleteFunc 还没有执行 而被强行终止后调用的函数
		 * breakParam  breakFunc参数
		 */
		public function splay(action:int,direction:int,timesArr:Array,completeFunc:Function=null,completeParam:Object=null,totalTimes:int=-1,totalCompleteFunc:Function=null,totalCompleteParam:Object=null,breakFunc:Function=null,breakParam:Object=null):void
		{
			if(_tweenSuperSkill)
			{
				_tweenSuperSkill.disposeToPool();
			}
			var data:Object={action:action,direction:direction,completeFunc:completeFunc,completeParam:completeParam};
			_tweenSuperSkill=TweenSuperSkill.excute(timesArr,toSplay,data,totalTimes,totalCompleteFunc,totalCompleteParam,breakFunc,breakParam);
			
		}
		private function toSplay(data:Object):void
		{
			var action:int=data.action;
			var direction:int=data.direction;
			var completeFunc:Function=data.completeFunc;
			var completeParam:Object=data.completeParam;
			play(action,direction,false,completeFunc,completeParam,true);
			
		}

		
//		override public function sMoveTo(path:Array, speed:int=5, completeFunc:Function=null, completeParam:Object=null, forceUpdate:Boolean=false):void
//		{
//		//	disposeBlinkLayer();
//			super.sMoveTo(path, speed, completeFunc, completeParam, forceUpdate);
//		}
		/**立马停止播放
		 */		
		public function stopSplay():void
		{
			if(_tweenSuperSkill)_tweenSuperSkill.disposeToPoolWidthStop();
		}
		/**停止  移动   并且停止播放   不包含任何的动作播放
		 */ 
		override public function pureStop():void
		{
			super.pureStop();
			stopSplay();
		}
		
		/**播放死亡
		 */		
		public function playDead(direction:int=-1):void
		{
			isDead=true;
			disposeBlinkLayer();
			updateHp(0);
			pureStop();
			if(direction==-1) direction=activeDirection;
			play(TypeAction.Dead,direction,false);
		}
		/**死亡状态
		 * 停留在死亡的帧上 没有播放的动作 而是直接停留在最后一帧
		 */		
		public function stayDead(direction:int=-1):void
		{
			_activeAction=TypeAction.Dead;
			isDead=true;
			updateHp(0);
			if(direction==-1) direction=activeDirection;
			if(_cloth.actionData)
			{
				var index:int=_cloth.actionData.getDirectionLen(TypeAction.Dead,direction)-1;
				gotoAndStop(TypeAction.Dead,direction,index);
			}
		}
		/**停止移动 
		 */
		override public function stopMove(direction:int=-1):void
		{
			_teenBezier.destroy();
			_tweenSimple.stop();
			if(!isDead)play(TypeAction.Stand,direction);
			else playDead(direction);
		}
		
		
		
		/** 进行场景冒泡说话 
		 * direction  人物站立的方向
		 */		
		public function say(txt:String,direction:int=-1):void
		{
			if(direction==-1) direction=_activeDirection;
			var skinId:int;
			var size:Point=getSkinSize()
			if(direction<=4)
			{
				skinId=1;
			}
			else 
			{
				skinId=2;
			}
		//	var chatArrow:YFChatArrow=new YFChatArrow(skinId);
			if(_chatArrow)
			{
				if(!_chatArrow.isDispose)
				{
					if(contains(_chatArrow)) removeChild(_chatArrow);
					_chatArrow.dispose();
				}
			}
			_chatArrow=new YF2dChatArrow(skinId);
			_chatArrow.text=txt;
			addChild(_chatArrow);
			_chatArrow.y=-size.y;
			///等待 8s
			TweenSkill.WaitToExcute(5000,removeChatArrow,_chatArrow);
		}
		private function removeChatArrow(obj:Object):void
		{
			if(_chatArrow)
			{
				if(!_chatArrow.isDispose)
				{
					removeChild(_chatArrow);
					_chatArrow.dispose();
					_chatArrow=null;
				}
			}
		}
		override public function dispose(childrenDispose:Boolean=true):void
		{
			if(_shadow)removeChild(_shadow);
			_shadow=null;
			super.dispose(childrenDispose);
			_checkAlphaTilePt=null;
			_checkNode=null;
			_downEffectPart=null;
			_upEffectPart=null;
			_nameItem1=null;
			_nameLayer=null;
			_bloodMC=null;
			if(_tweenSuperSkill)_tweenSuperSkill.disposeToPool();
			_tweenSuperSkill=null;
			_blinkComplete=null;
			_blinkCompleteParams=null;
		}

		/////对象池管理-----------------------------------------
		/**重置初始状态
		 */		
		override public function reset():void
		{
			super.reset();
			mouseEnabled=true;
			removeNameLayer();	
			updateHp(1);
			if(_tweenSuperSkill)_tweenSuperSkill.disposeToPoolWidthStop();
			_tweenSuperSkill=null;
			isDead=false;
			glow=false;
			_blinkComplete=null;
			_blinkCompleteParams=null;
			alpha=1;
		}
		/**
		 * @param roleDyVo 为 RoleDyVo 类型
		 */		
		override public function constructor(roleDyVo:Object):IPool
		{
			 super.constructor(roleDyVo);
			 addNameItem();
			 return this;
		}
		/**设置对象池个数
		 */		
		override protected function setPoolNum():void
		{
			regPool(10);
		}
		
	}
}