package com.YFFramework.game.core.module.mapScence.world.view.player
{
	/**@author yefeng
	 *2012-4-20下午10:31:32
	 */
	import com.YFFramework.core.center.manager.update.TimeLine;
	import com.YFFramework.core.center.manager.update.TimeOut;
	import com.YFFramework.core.center.manager.update.UpdateManager;
	import com.YFFramework.core.ui.abs.AbsView;
	import com.YFFramework.core.ui.movie.BitmapMovieClip;
	import com.YFFramework.core.ui.movie.data.ActionData;
	import com.YFFramework.core.ui.movie.data.TypeAction;
	import com.YFFramework.core.ui.movie.data.TypeDirection;
	import com.YFFramework.core.ui.yf2d.data.ATFActionData;
	import com.YFFramework.core.ui.yf2d.data.ATFMovieData;
	import com.YFFramework.core.ui.yfComponent.controls.YFChatArrow;
	import com.YFFramework.core.ui.yfComponent.controls.YFLabel;
	import com.YFFramework.core.utils.math.YFMath;
	import com.YFFramework.core.utils.tween.game.TweenSuperSkill;
	import com.YFFramework.core.world.movie.player.utils.DirectionUtil;
	import com.YFFramework.core.yf2d.display.DisplayObject2D;
	import com.YFFramework.core.yf2d.events.YF2dMouseEvent;
	import com.YFFramework.game.core.module.mapScence.world.model.RoleDyVo;
	import com.YFFramework.game.core.module.mapScence.world.model.type.TypeRole;
	import com.YFFramework.game.core.module.system.data.SystemConfigManager;
	import com.YFFramework.game.ui.imageText.ImageUtil;
	import com.YFFramework.game.ui.imageText.TypeImageText;
	import com.YFFramework.game.ui.yf2d.view.avatar.BuffEffect2DView;
	import com.YFFramework.game.ui.yf2d.view.avatar.EffectPart2DView;
	import com.YFFramework.game.ui.yf2d.view.avatar.Part2DCombine;
	import com.YFFramework.game.ui.yf2d.view.avatar.YF2dProgressBar;
	import com.greensock.TweenLite;
	import com.greensock.easing.Linear;
	
	import flash.display.MovieClip;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	
	public class PlayerView extends AbsAnimatorView
	{
		
		/**变白
		 */
		public static const WhiteColorTransform:ColorTransform=new ColorTransform(4,4,4,1,255,255,255);
		///人物角色变色
		protected static const DefaultColortransform:ColorTransform=new ColorTransform();
		///人物变色
		protected static const SelectBodyColorTransform:ColorTransform=new  ColorTransform(1.4, 1.4, 1.5, 1, 0, 0, 0);
		/**角色名称1
		 */
		protected  var _nameItem1:YFLabel;
		
		/**名字cengc
		 */
		protected var _nameLayer:AbsView;
		

		/**  人物血条
		 */		
		protected var _bloodMC:YF2dProgressBar;
		
		
		/**tittle效果
		 */
		protected var _tittleClip:BitmapMovieClip;
		
		/**特效容器   比如升级  
		 */
		protected var _upEffectPart:EffectPart2DView;
		
		/** 最里层特效层
		 */
		protected var _downEffectPart:EffectPart2DView;
		
		/**buff特效播放层
		 */		
		protected var _upBuffEffectView:BuffEffect2DView;
		/**下层buff特效层
		 */		
		protected var _downBuffEffectView:BuffEffect2DView;

		private const maxBodyNum:int=9;

		private var _tweenSuperSkill:TweenSuperSkill;
		/**场景聊天冒泡控件
		 */		
		protected var _chatArrow:YFChatArrow;
		/** flash 层
		 */		
		public var flashContainer:AbsView;
		

		/**是否发光
		 */
		protected var _glow:Boolean;
		
		///移形换影参数
		private var _blinkArr:Array;
		private var _completeBlink:Function;
		private var _completeBlinkParam:Object;

		public function PlayerView(roleDyVo:RoleDyVo=null)
		{
			super(roleDyVo);
			mouseChildren=false;
		}
		
		
		public function get isDead():Boolean
		{
			if(roleDyVo.hp<=0)
			{
				return true;
			}
			return false;
		}
		override protected function initUI():void
		{
			super.initUI();
			flashContainer=new AbsView();
			initBloodLayer();
			initNameLayer();
			_blinkArr=[];
		}

		protected function initNameLayer():void
		{
			_nameLayer=new AbsView(false);    
			flashContainer.addChild(_nameLayer);
			_nameLayer.y=-140;
			_nameItem1=YFLabel.getYFLabel();//YFGameLabel.getYFGameLabel();///YFLabel.getYFLabel();//new YFLabel();
			_nameLayer.addChild(_nameItem1);
			updateName();
//			initNameLayerMouse();
			_nameLayer.mouseChildren=_nameLayer.mouseEnabled=false;
			_nameItem1.mouseEnabled=_nameItem1.mouseChildren=false;
			_nameLayer.cacheAsBitmap=true;
		}
//		/**是否响应鼠标事件 
//		 */
//		protected function initNameLayerMouse():void
//		{
//		}
		/** 更新 名称
		 */		
		public function updateName():void
		{
			var nameColor:uint=TypeRole.getNameColor(roleDyVo.nameColor);
			_nameItem1.setText(roleDyVo.roleName,nameColor);
			var mc:MovieClip=TypeRole.getVIPMC(roleDyVo.vipType,roleDyVo.vipLevel);
			if(mc)
			{
				_nameItem1.setVipIcon(mc);
			}
			reLocateNamePosition();
		} 
		/**重新定位名字的位置
		 */		 
		protected function reLocateNamePosition():void
		{
			_nameItem1.x=-_nameItem1.textWidth*0.5;
		}
		/**初始化血条
		 */ 
		protected function initBloodLayer():void
		{
			_bloodMC=YF2dProgressBar.getYF2dProgressBar();//new YF2dProgressBar();
//			_bloodMC.setXYPivotXY(-50,-120,-_bloodMC.width*0.5,-_bloodMC.height*0.5);
			_bloodMC.setXYPivotXY(-YF2dProgressBar.Width,-120,-YF2dProgressBar.Width*0.5,-YF2dProgressBar.Height*0.5);
 
			_bloodMC.mouseChildren=_bloodMC.mouseEnabled=false; 
			addChild(_bloodMC);
			updateHp();

		}
		/**初始化tittle
		 */		
		protected function initTittle():void
		{
			_tittleClip=new BitmapMovieClip();//YF2dMovieClipPool.getSkillEffect2DView();
			_tittleClip.mouseChildren=_tittleClip.mouseEnabled=false;
//			_tittleClip.setXY(0,_nameItem1.y-40);
			_tittleClip.y=_nameItem1.y-40;
		}
		/**更新tittle   tittle的  数据都是在编辑器里居中原点显示的 
		 */		
		public function updateTittle(actionData:ActionData):void
		{
			if(!_tittleClip)initTittle();
			if(actionData)
			{
				_tittleClip.initData(actionData);
				_tittleClip.playDefault();
				_tittleClip.start();
				if(!flashContainer.contains(_tittleClip))flashContainer.addChild(_tittleClip);
			}
			else  
			{
				_tittleClip.initData(null);
				_tittleClip.stop();
				_tittleClip.bitmapData=null;
				if(flashContainer.contains(_tittleClip))flashContainer.removeChild(_tittleClip);
			}
		}
		/**重新定位血条和  名字的位置
		 *   当重新给 cloth值时 需要调用
		 * NPC没有血条 
		 */		 
		protected  function reLocateBloodName():void
		{
			var obj:Object=_cloth.actionDataStandWalk.getBlood();
			_bloodMC.setY(obj.y);
			
			_nameLayer.y=obj.y-20
			if(_tittleClip)
			{
				_tittleClip.y=_nameLayer.y-40;
//				_tittleClip.y=_nameItem1.y-40;
//				_tittleClip.setXY(0,_nameItem1.y-40);
			}
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
						initMouseCursor(false);
						break;
					case YF2dMouseEvent.MOUSE_OVER:
						glow=true;
						initMouseCursor(true);
						break;
				}	
			
		}
		/** 更新血量 血量由 当前血量hp / rodyVo.maxHp确定
		 */		
		public function updateHp():void
		{
			var value:Number=int(roleDyVo.hp*10000/roleDyVo.maxHp)/10000;
			if(value<0)
			{
				value=0;
			}
			_bloodMC.setPercent(value);
		}
		
		
		/**  发光  body对象发光
		 */
		protected function set glow(value:Boolean):void
		{
			_glow=value;
			if(value)
			{
				DisplayObject2D(_cloth.mainClip).localColorTransform=SelectBodyColorTransform;
				///名字变颜色
//				_nameItem1.colorTransform=SelectNameColorTransform;
			}
			else 
			{
				DisplayObject2D(_cloth.mainClip).localColorTransform=DefaultColortransform;
				///名字变颜色
//				_nameItem1.colorTransform=DefaultColortransform;
				
			}
		}
		/**
		 * @param select 是否滑上选中  子类覆盖重写
		 */		
		protected function initMouseCursor(select:Boolean):void
		{
		}
		protected function get glow():Boolean
		{
			return _glow;
		}
		/**创建 受伤效果
		 *   怪物    和宠物重写了该方法
		 * isHitMove 是否击退
		 */		
		protected function initInjureEffect(action:int,direction:int,isHitMove:Boolean=false):int
		{
			return doSimpleInjure(action,direction);
		}
		/**简单受击效果  人物只进行变色
		 * 返回的是动作
		 */		
		protected function doSimpleInjure(action:int,direction:int,isHitMove:Boolean=false):int
		{
			if(action==TypeAction.Injure)
			{
				setColorMatrix(WhiteColorTransform);
				var timeOut:TimeOut=new TimeOut(150,injureSimpleBecomeNormal);
				timeOut.start();
			}
			else setColorMatrix(DefaultColortransform);
			return action;
		}
		
		/**简单的 受击后结束的效果
		 */		
		private function injureSimpleBecomeNormal(obj:Object):void
		{
			if(!_isDispose)setColorMatrix(DefaultColortransform);
		}
		
		
		
		/**设置人物颜色
		 */
		protected function setColorMatrix(colortransform:ColorTransform):void
		{
			if(!isDispose)DisplayObject2D(_cloth.mainClip).localColorTransform=colortransform;
		}
		/**
		 * @param isHitMove  怪物击退，只有 怪物使用
		 * 
		 */		
		override public function play(action:int,direction:int=-1,loop:Boolean=true,completeFunc:Function=null,completeParam:Object=null,resetPlay:Boolean=false,isHitMove:Boolean=false):void
		{
			var istrigger:Boolean=true;
			//当上一次处于 攻击状态     现在要立刻播放受击时候 需要进行忽略
			if(action==TypeAction.Injure&&(_activeAction==TypeAction.Attack||_activeAction==TypeAction.SpecialAtk_1))  
			{
				istrigger=false;
			}
			if(istrigger)
			{
				if(direction==-1)	direction=_activeDirection;
				_activeAction=action;
				_activeDirection=direction;
				action=initInjureEffect(action,direction,isHitMove);
//				if(YF2dActionData.isUsableActionData(_cloth.actionDataStandWalk))
//				{
					_cloth.play(action,direction,loop,completeFunc,completeParam,resetPlay);
//				}
			}
		}
		
		
		override public function updateClothStandWalk(actionData:ATFActionData):void
		{
			super.updateClothStandWalk(actionData);
			_cloth.start();
			if(_activeAction!=TypeAction.Dead)
			{
//				if(_activeAction!=-1&&_activeDirection!=-1)	play(_activeAction,_activeDirection,true,null,null,true);
				if((_activeAction==TypeAction.Stand||_activeAction==TypeAction.Walk||_activeAction==TypeAction.FightStand)&&_activeDirection!=-1)	play(_activeAction,_activeDirection,true,null,null,true);
				else playDefault(true,null,null,true);
			}
			else  /// dead 
			{
				stayDead(_activeDirection);
			}
			doReLocateBloodName();
		}
		/**重新定位血条和文本
		 *  子类 因为坐骑 需要覆盖
		 */		
		protected function doReLocateBloodName():void
		{
			reLocateBloodName();
		}
		
		
		override public function set roleDyVo(roleDyvo:RoleDyVo):void
		{
			super.roleDyVo=roleDyvo;
			if(_roleDyVo.roleName)
			{
				_nameItem1.setText(roleDyvo.roleName);
			}
		}
		 
		/**击退  滑动 
		 */
		public function backSlideMove(endMapX:int,endMapY:int,speed:Number,slideComplete:Function=null,slideCompleteParam:Object=null):void
		{
			var direction:int=DirectionUtil.getDirection(endMapX,endMapY,roleDyVo.mapX,roleDyVo.mapY);
			gotoAndStop(TypeAction.Walk,direction,1); //停留在第二帧
			//开始 进行移动
			pureMoveTo(endMapX,endMapY,speed,slideComplete,slideCompleteParam,false);
		}
		/** 瞬移  创建多个  body 进行移动    bodyNum 是瞬移产生的影子个数    移动
		 * 
		 * oppsite   方向是否为反方向  如果为 true  则    方向为   mapX,mapY  指向 玩家当前方向  也就是玩家 倒退 移动的 效果
		 */
		public function updateBlinkMove(mapX:int,mapY:int,speed:int=10,complete:Function=null,completeParams:Object=null,forceUpdate:Boolean=false,oppsite:Boolean=false):void
		{
			_completeBlink=null;
			if(parent)
			{
				_completeBlink=complete;
				_completeBlinkParam=completeParams;
				var direction:int=DirectionUtil.getDirection(roleDyVo.mapX,roleDyVo.mapY,mapX,mapY);
				if(oppsite)direction=TypeDirection.getOppsiteDirection(direction);
				var stayIndex:int=2;///停留帧数
				var testAlpha:Number=0.8;
				if(_blinkArr.length==0)
				{
					_blinkArr.push(this);
					var player:BlinkPlayer;
					///创建	 maxBodyNum
					for(var i:int=0;i!=maxBodyNum;++i)
					{
						player=new BlinkPlayer();
						initBlinkPlayerData(player);
						_blinkArr.push(player);
						player.alpha=testAlpha;
						testAlpha=testAlpha-0.09;
						if(testAlpha<=0.1)testAlpha=0.1
					}
				}
				var timeLine:TimeLine=new TimeLine();
				for each(var obj:DisplayObject2D in _blinkArr)
				{
					if(obj is BlinkPlayer)
					{
						BlinkPlayer(obj).setMapXY(roleDyVo.mapX,roleDyVo.mapY);
						parent.addChild(BlinkPlayer(obj));
						BlinkPlayer(obj).visible=false;
						timeLine.addFunc(onBlinkFunc,{player:BlinkPlayer(obj),direction:direction,endX:mapX,endY:mapY,speed:speed,mapX:roleDyVo.mapX,mapY:roleDyVo.mapY},0);
						timeLine.addWait(30);
					}
				}
				timeLine.start();
//				moveTo(mapX,mapY,speed,onBlinkComplete,completeParams,forceUpdate);
				pureMoveTo(mapX,mapY,speed,onBlinkComplete,completeParams,forceUpdate); ///单纯的移动
				gotoAndStop(TypeAction.Walk,direction,2);
				var myDistance:int=YFMath.distance(mapX,mapY,roleDyVo.mapX,roleDyVo.mapY);
				var exeTime:Number=myDistance*UpdateManager.IntervalRate/speed;
				var checkDisposeTime:TimeOut=new TimeOut(exeTime,onBlinkComplete);
				checkDisposeTime.start();
			}
			else 
			{
				if(complete!=null)	complete(completeParams);
			}
		}

		private function onBlinkComplete(obj:Object):void
		{
			disposeBlinkLayer();
			if(_completeBlink!=null) _completeBlink(_completeBlinkParam);
			_completeBlink=null;
		}
		
		protected function onBlinkFunc(obj:Object):void
		{
			if(parent)
			{
				var player:BlinkPlayer=obj.player;
				if(!player.isDispose)
				{
					var path:Array=obj.path;
					var speed:Number=obj.speed;
					var mapX:Number=obj.mapX;
					var mapY:Number=obj.mapY;
					var endX:Number=obj.endX;
					var endY:Number=obj.endY;
					var direction:int=obj.direction;
					player.visible=true;
					player.moveTo(endX,endY,speed);
					player.blinkWalk(direction);
//					player.gotoAndStop(TypeAction.Walk,direction,2);
				}
			}
		}
		
		/** 创建瞬移数据
		 * @param player  瞬移对象
		 */		
		protected function initBlinkPlayerData(player:BlinkPlayer):void
		{
			player.initData(_cloth.actionDataStandWalk);
		}
		
		
		/**释放瞬移层
		 */ 
		private function disposeBlinkLayer(param:Object=null):void
		{
			if(_blinkArr)
			{
				var len:int=_blinkArr.length;
				if(len>0)
				{
					var player:BlinkPlayer;
					for each(var obj:DisplayObject2D in _blinkArr )
					{
						player=obj as BlinkPlayer;
						if(player)
						{
							if(player.parent) player.parent.removeChild(player);
							player.dispose();
						}
					}
				}
				_blinkArr=[];
			}
		}
		
		
		
		
		/**上层特效
		 * @param timesArr 每隔多少时间 执行一次函数调用 播放一次数据 
		 * @param totalTimes 该特效播放的时间长度  不管特效是否循环播放 当超过这个世界就会将特效进行移除
		 * @loop  特效播放 是否循环 播放
		 */
		public function addFrontEffect(actionData:ATFActionData,timesArr:Array,loop:Boolean=false,skinType:int=2,direction:int=-1,completeFunc:Function=null,completeParam:Object=null):void
		{
			if(direction==-1) direction=_activeDirection;
			if(_upEffectPart)
			{
				if(!_upEffectPart.parent)
				{
					addChild(_upEffectPart);
				}
				_upEffectPart.playEffect(actionData,timesArr,loop,skinType,direction,completeFunc,completeParam);
			}
			else 
			{
				_upEffectPart=EffectPart2DView.getEffectPart2DViewPool();//new EffectPart2DView();
				addChild(_upEffectPart);
				_upEffectPart.playEffect(actionData,timesArr,loop,skinType,direction,completeFunc,completeParam);
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
					_upEffectPart.dispose();
				}
					
			}
		}
		
		/**添加Buff特效
		 * @param actionDataUrl    
		 */
		public function addUpBuffEffect(url:String):void
		{ 
			if(_upBuffEffectView)
			{
				if(!_upBuffEffectView.parent)
				{
					addChild(_upBuffEffectView);
				}
				_upBuffEffectView.addEffect(url);
			}
			else 
			{
				_upBuffEffectView=BuffEffect2DView.getBuffEffect2DViewPool(this);//new BuffEffect2DView(this);
				addChild(_upBuffEffectView);
				_upBuffEffectView.addEffect(url);
			}
		}
		/**删除 buff特效
		 */		
		public function deleteUpBuffEffect(url:String):void
		{
			if(_upBuffEffectView)
			{
				_upBuffEffectView.deleteEffect(url);
			}
		}
		
		/**下层buff特效
		 */		
		public function addDownBuffEffect(url:String):void
		{ 
			if(_downBuffEffectView)
			{
				if(!_downBuffEffectView.parent)
				{
					addChildAt(_downBuffEffectView,0);
				}
				_downBuffEffectView.addEffect(url);
			}
			else 
			{
				_downBuffEffectView=BuffEffect2DView.getBuffEffect2DViewPool(this);//new BuffEffect2DView(this);
				addChildAt(_downBuffEffectView,0);
				_downBuffEffectView.addEffect(url);
			}
		}
		/**删除 buff特效
		 */		
		public function deleteDownBuffEffect(url:String):void
		{
			if(_downBuffEffectView)
			{
				_downBuffEffectView.deleteEffect(url);
			}
		}
		
		/**设置下层 buff 
		 */
		protected function setDownBuffEffectIndex():void
		{
			if(_downBuffEffectView)
			{
				if(_downBuffEffectView.parent)
				{
					_downBuffEffectView.parent.setChildIndex(_downBuffEffectView,0);
				}
			}
		}
		
		
		/**下层特效
		 * @param waitIme   播放该特效需要等待的时间
		 * @param totalTimes 该特效播放的时间长度  不管特效是否循环播放 当超过这个世界就会将特效进行移除
		 * @loop  特效播放 是否循环 播放
		 */
		public function addBackEffect(actionData:ATFActionData,timesArr:Array,loop:Boolean=false,skinType:int=2,direction:int=-1,completeFunc:Function=null,completeParam:Object=null):void
		{
			if(direction==-1) direction=_activeDirection;
			if(_downEffectPart)
			{
				if(!_downEffectPart.parent)
				{
					addChildAt(_downEffectPart,0);
				}
				_downEffectPart.playEffect(actionData,timesArr,loop,skinType,direction,completeFunc,completeParam);
			}
			else 
			{
				_downEffectPart=EffectPart2DView.getEffectPart2DViewPool();//new EffectPart2DView();
				addChildAt(_downEffectPart,0);  
				_downEffectPart.playEffect(actionData,timesArr,loop,skinType,direction,completeFunc,completeParam);
			}
		}
		/** 角色被选中
		 */		
		public  function addRoleSelect(object:DisplayObject2D):void
		{
			if(_downEffectPart)
			{
				if(!_downEffectPart.parent)
				{
					addChildAt(_downEffectPart,0);
				}
			}
			else 
			{
				_downEffectPart=EffectPart2DView.getEffectPart2DViewPool()//new EffectPart2DView();
				addChildAt(_downEffectPart,0);  
			}
			_downEffectPart.addSelectRoleiew(object);
		}
		/**取消角色选中
		 */		
		public function removeRoleSelect(object:DisplayObject2D):void
		{
			if(_downEffectPart!=null)
			{
				_downEffectPart.removeSelectRoleiew(object);
//				if(_downEffectPart.numChildren==0&&contains(_downEffectPart)) removeChild(_downEffectPart);
			}
			
		}
		/** 扣血 文字
		 * 战斗性的文字  1 2 3 4 5 6 7  8 9 
		 * num  为显示的数字
		 * delayTime 为 延迟的时间 单位为毫秒
		 * curentHp 为当前血量
		 * completeFunc  血量更新完成后触发
		 * damageType 伤害类型  是  暴击    FightDamageType  
		 * showNum表示是否显示数字
		 */	
		public function addBloodText(num:int,curentHp:int,timeArr:Array,completeFunc:Function=null,param:Object=null,damageType:int=0,showNum:Boolean=true):void
		{
			var myY:Number=0;
			if(roleDyVo)
			{
				roleDyVo.hp=curentHp;
			}
			if(showNum)
			{
				ImageUtil.Instance.showBloodEx(timeArr,num,flashContainer,myY,TypeImageText.Role,onBloodComplete,{param:param,func:completeFunc},damageType);
			}
			else 
			{
				onBloodComplete({param:param,func:completeFunc});
			}
			
		}
		
		protected function onBloodComplete(obj:Object):void
		{
			if(!isDispose) updateHp();
			var param:Object=obj.param;
			var func:Function=obj.func;
			if(func!=null)func(param);
		}
		

		/** buff 改变显示血量
		 */		
		public function showBufHpfChange(hpChange:int):void
		{
			var my:Number=-50;
			if(_cloth.actionDataStandWalk)my=_cloth.actionDataStandWalk.getBlood().y*0.5;
			if(hpChange<0) ///扣血
			{
				ImageUtil.Instance.showBuffHpMinus(Math.abs(hpChange),flashContainer,my,TypeImageText.Role);
			}
			else //加血 
			{
				ImageUtil.Instance.showBuffHpAdd(hpChange,flashContainer,my,TypeImageText.Role);
			}
		}
		/** buff 改变魔法值
		 */		
	
		public function showBuffMpChange(hpChange:int):void
		{
			var my:Number=-50;
			if(_cloth.actionDataStandWalk)my=_cloth.actionDataStandWalk.getBlood().y*0.5;
			if(hpChange<0) ///扣血
			{
				ImageUtil.Instance.showBuffMpMinus(Math.abs(hpChange),flashContainer,my,TypeImageText.Role);
			}
			else //加血 
			{
				ImageUtil.Instance.showBuffMpAdd(hpChange,flashContainer,my,TypeImageText.Role);
			}
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
		 */
		public function splay(action:int,direction:int,timesArr:Array,completeFunc:Function=null,completeParam:Object=null,totalTimes:int=-1,totalCompleteFunc:Function=null,totalCompleteParam:Object=null):void
		{
//			if(_tweenSuperSkill)
//			{
//				_tweenSuperSkill.disposeToPool();
//			}
			var data:Object={action:action,direction:direction,completeFunc:completeFunc,completeParam:completeParam};
			_tweenSuperSkill=TweenSuperSkill.excute(timesArr,toSplay,data,totalTimes,totalCompleteFunc,totalCompleteParam);
			
		}
		private function toSplay(data:Object):void
		{
			if(!isDispose)
			{
				var action:int=data.action;
				var direction:int=data.direction;
				var completeFunc:Function=data.completeFunc;
				var completeParam:Object=data.completeParam;
				var isHitMove:Boolean=data.isHitMove; ///isHitMove  属性  来自于TweenSuperSkill内部 添加 ， 优化添加
				play(action,direction,false,completeFunc,completeParam,true,isHitMove);
			}
		}
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
		
		/**播放死亡 死亡只有一个动作
		 */		
//		public function playDead(direction:int=-1):void
//		{
//			isDead=true;
//			updateHp();
//			pureStop();
//			play(TypeAction.Dead,TypeDirection.DeafultDead,false);
//		}
		/**死亡状态  死亡只有一个动作
		 * 停留在死亡的帧上 没有播放的动作 而是直接停留在最后一帧
		 *  怪物没有死亡动作  怪物需要重写该方法
		 */		
		public function stayDead(direction:int=-1):void
		{
			_activeAction=TypeAction.Dead;
//			isDead=true;
//			updateHp(0);
			if(direction==-1) direction=_activeDirection;
			if(_cloth.actionDataInjureDead)
			{
				var defaultDeadArr:ATFMovieData=_cloth.actionDataInjureDead.getDirectionData(TypeAction.Dead,TypeDirection.DeafultDead);
				var index:int=defaultDeadArr.dataArr.length-1;  ///停留在最后一帧
				gotoAndStop(TypeAction.Dead,direction,index);
			}
		}
		
		/** 进行场景冒泡说话  
		 * direction  人物站立的方向
		 */		
		public function say(txt:String,direction:int=-1):void
		{
			if(direction==-1) direction=_activeDirection;
			var skinId:int;
			if(direction<=4)
			{
				skinId=1;
			}
			else 
			{
				skinId=2;
			}
			removeChatArrow();
			_chatArrow=new YFChatArrow(skinId);
			_chatArrow.text=txt;
			flashContainer.addChild(_chatArrow);
			setChatArrowPos();
			///等待 8s
			var timeOut:TimeOut=new TimeOut(5000,removeChatArrow,_chatArrow); 
			timeOut.start();
		}
		
		
		
		/** 怪物  死亡时候的移动  以及人物击退的动作
		 */		
		public function deadMove(mapX:int,mapY:int,speed:Number=4,completeFunc:Function=null,completeParam:Object=null,forceUpdate:Boolean=false):void
		{
//			pureMoveTo(mapX,mapY,speed,completeFunc,completeParam,forceUpdate);
			pureMoveTo(mapX,mapY,speed,null,null,forceUpdate);

			var time:Number=(YFMath.distance(_mapX,_mapY,mapX,mapY)*UpdateManager.IntervalRate/speed)*0.001; // 单位为 s 
			var moveY:Number=180*time/0.4;
			if(_cloth.mainClip)	TweenLite.to(_cloth.mainClip,time*0.5,{scaleX:2,scaleY:2,y:-moveY, ease:Linear.easeNone,onComplete:completeOperator,onCompleteParams:[_cloth,time]});
			
			var t:TimeOut=new TimeOut(time*1000,completeFunc,completeParam);
			t.start();
		}
		private function completeOperator(_cloth:Part2DCombine,time:Number):void
		{
			if(_cloth.mainClip)TweenLite.to(_cloth.mainClip,time*0.5,{scaleX:1,scaleY:1,y:0, ease:Linear.easeNone});
			//			TweenLite.to(_cloth.reflectionClip,time*0.5,{scaleX:1,scaleY:1,y:0, ease:Linear.easeNone});
		}

		
		
		
		/**设置冒泡的坐标
		 */		
		protected function setChatArrowPos():void
		{
			var size:Point=getSkinSize()
			_chatArrow.y=-size.y;
			if(_cloth.actionDataStandWalk)_chatArrow.y=_cloth.actionDataStandWalk.getBlood().y-25
		}
		
		
		/** 删除冒泡
		 */		
		private function removeChatArrow(obj:Object=null):void
		{
			if(_chatArrow)
			{
				if(!_chatArrow.isDispose)
				{
					flashContainer.removeChild(_chatArrow);
					_chatArrow.dispose();
					_chatArrow=null;
				}
			}
		}
		
		private function chatArrowFollow():void
		{
			if(_chatArrow)
			{
				_chatArrow.x=x;
				_chatArrow.y=y-100;
			}
		}
		
		override protected function updateOtherPostion():void
		{
			super.updateOtherPostion();
			flashContainer.x=x;
			flashContainer.y=y;
		}
		
		/**人物 数据
		 */		
		public function getClothWalkStand():ATFActionData
		{
			return _cloth.actionDataStandWalk;
		}
		
		/**人物 受伤 死亡数据
		 */
		public function getClothInjureDead():ATFActionData
		{
			return _cloth.actionDataInjureDead;
		}

		/**人物战斗数据
		 */
		public function getClothFight():ATFActionData
		{
			return _cloth.actionDataFight;
		}
		
		/**人物战斗待机数据
		 */
		public function getClothFightStand():ATFActionData
		{
			return _cloth.actionDataFightStand;
		}

		/**人物特殊攻击数据
		 */
		public function getClothAtk_1():ATFActionData
		{
			return _cloth.actionDataAtk_1;
		}
		
		
		override public function dispose(childrenDispose:Boolean=true):void
		{
			if(_upBuffEffectView)  ///有可能   _buffEffectView 没有addChild进去
			{
				if(contains(_upBuffEffectView))removeChild(_upBuffEffectView);
//				_upBuffEffectView.dispose();
				BuffEffect2DView.toBuffEffect2DViewPool(_upBuffEffectView);
			}
			_upBuffEffectView=null;
			
			if(_downBuffEffectView)  ///有可能   _buffEffectView 没有addChild进去
			{
				if(contains(_downBuffEffectView))removeChild(_downBuffEffectView);
//				_downBuffEffectView.dispose();
				BuffEffect2DView.toBuffEffect2DViewPool(_downBuffEffectView);
			}
			_downBuffEffectView=null;
			
			if(_upEffectPart)
			{
				if(contains(_upEffectPart))removeChild(_upEffectPart);
//				_upEffectPart.dispose();
				EffectPart2DView.toEffectPart2DViewPool(_upEffectPart);
			}
			_upEffectPart=null;
			if(_downEffectPart)
			{
				if(contains(_downEffectPart))removeChild(_downEffectPart);
//				_downEffectPart.dispose();
				EffectPart2DView.toEffectPart2DViewPool(_downEffectPart); 
			}
//			if(_tittleClip)
//			{
//				if(contains(_tittleClip))removeChild(_tittleClip);
//				YF2dMovieClipPool.toSkillEffect2DViewPool(_tittleClip);
//			}
			
			
			if(_bloodMC)  // npc没有bloodMC 
			{
				if(_bloodMC.parent)	_bloodMC.parent.removeChild(_bloodMC);
				YF2dProgressBar.toYF2dProgressBarPool(_bloodMC);
			}
			 
			super.dispose(childrenDispose);
			disposeBlinkLayer();
			removeChatArrow();
			if(_tweenSuperSkill)_tweenSuperSkill.disposeToPoolWidthStop();
			_tweenSuperSkill=null;
			_tittleClip=null;
			
			if(_nameItem1.parent)_nameItem1.parent.removeChild(_nameItem1);
			YFLabel.toYFLabelPool(_nameItem1);
			if(_nameLayer.parent)_nameLayer.parent.removeChild(_nameLayer);
			if(flashContainer.parent)flashContainer.parent.removeChild(flashContainer);
			flashContainer.dispose();
			flashContainer=null; 
			_nameItem1=null;
			_nameLayer=null;
			_bloodMC=null;
			_tweenSuperSkill=null;
			_upBuffEffectView=null;
			_upEffectPart=null;
			_downEffectPart=null;
			_completeBlink=null;
			_completeBlinkParam=null;
			_blinkArr=null;
			_tittleClip=null;
			_chatArrow=null;
		}
		
		/**@override 
		 *    更新系统配置  子类重写
		 */		
		public function updateSystemConfig():void
		{
			_bloodMC.visible=!SystemConfigManager.shieldHp;  //隐藏血条
			if(_tittleClip)			//隐藏玩家称号
			{
				_tittleClip.visible=SystemConfigManager.showTitle;   
			}
			_cloth.visible=!SystemConfigManager.shieldOtherHero;			//隐藏其他玩家玩家
		}
		
		
		
	}
}