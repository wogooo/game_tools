package com.YFFramework.core.world.movie.player
{
	/**@author yefeng
	 *2012-4-20下午10:31:32
	 */
	import com.YFFramework.core.center.manager.update.TimeOut;
	import com.YFFramework.core.center.manager.update.UpdateManager;
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
	import com.YFFramework.core.ui.yf2d.view.avatar.BuffEffect2DView;
	import com.YFFramework.core.ui.yf2d.view.avatar.EffectPart2DView;
	import com.YFFramework.core.ui.yf2d.view.avatar.YF2dMovieClip;
	import com.YFFramework.core.ui.yf2d.view.avatar.YF2dProgressBar;
	import com.YFFramework.core.ui.yfComponent.controls.YFChatArrow;
	import com.YFFramework.core.utils.tween.game.TweenSuperSkill;
	import com.YFFramework.core.world.mapScence.map.BgMapScrollport;
	import com.YFFramework.core.world.model.MonsterDyVo;
	import com.YFFramework.core.world.movie.player.utils.DirectionUtil;
	import com.YFFramework.game.ui.imageText.ImageUtil;
	import com.YFFramework.game.ui.imageText.TypeImageText;
	
	import flash.display.DisplayObject;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	
	import yf2d.display.DisplayObject2D;
	import yf2d.display.sprite2D.YF2dClip;
	import yf2d.display.sprite2D.YF2dGameNameLabel;
	import yf2d.events.YF2dMouseEvent;
	
	public class PlayerView extends AbsAnimatorView
	{

		/**变白
		 */
		public static const WhiteColorTransform:ColorTransform=new ColorTransform(4,4,4,1,255,255,255);
		///人物角色变色
		protected static const DefaultColortransform:ColorTransform=new ColorTransform();
		///人物变色
		protected static const SelectBodyColorTransform:ColorTransform=new  ColorTransform(1.4, 1.4, 1.5, 1, 0, 0, 0);
		///名字变色
		protected  var SelectNameColorTransform:ColorTransform=new ColorTransform(4, 0, 0.1, 1, -61, -71, -176);

		/**是否已经死亡
		 */		
		public var isDead:Boolean;
		
		/**影子
		 */		
		protected var _shadow:YF2dMovieClip;
//		protected var _glowFilter:GlowFilter;
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
		
		/**buff特效播放层
		 */		
		protected var _buffEffectView:BuffEffect2DView;

		
		private const maxBodyNum:int=10;


		/**  人物血条
		 */		
		protected var _bloodMC:YF2dProgressBar;
		
		private var _tweenSuperSkill:TweenSuperSkill;
		/**场景聊天冒泡控件
		 */		
		protected var _chatArrow:YFChatArrow;

		/**是否发光
		 */
		protected var _glow:Boolean;
		
		///移形换影参数
		private var _blinkArr:Array;
		private var _completeBlink:Function;
		private var _completeBlinkParam:Object;

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
			_blinkArr=[];
//			_glowFilter=new GlowFilter(0xFF0000,1,10,10);
//			_filters=new BlurFilter(3,3);
		}

		protected function initNameLayer():void
		{
			_nameLayer=new Abs2dView();
			addChild(_nameLayer);
			_nameLayer.mouseChildren=_nameLayer.mouseEnabled=false;
			_nameLayer.y=-140;
			_nameLayer.x=-28;
			
			_nameItem1=new YF2dGameNameLabel();
			_nameLayer.addChild(_nameItem1);
//			_nameItem1.text=_roleDyVo.roleName?_roleDyVo.roleName:_nameItem1.text;
			updateName();
		}
		/** 更新 名称
		 */		
		public function updateName():void
		{
			_nameItem1.setText(roleDyVo.roleName);
		}
		
		/** 释放名字层其他名字内存
		 */		
		protected function removeNameLayer():void
		{
			_nameItem1.setText("");
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
			updateHp();
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
			_shadow=new YF2dMovieClip();
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
		/** 更新血量 血量由 当前血量hp / rodyVo.maxHp确定
		 */		
		public function updateHp():void
		{
			var value:Number=int(roleDyVo.hp*10000/roleDyVo.maxHp)/10000;
			if(value<0)value=0;
			_bloodMC.setPercent(value);
		}
		
		
		/**  发光  body对象发光
		 */
		protected function set glow(value:Boolean):void
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
		protected function get glow():Boolean
		{
			return _glow;
		}
		/**创建 受伤效果
		 */		
		protected function initInjureEffect(action:int):void
		{
			if(action==TypeAction.Injure)
			{
				setColorMatrix(WhiteColorTransform);
				var timeOut:TimeOut=new TimeOut(60,becomeNormal);
				timeOut.start();
			}
			else setColorMatrix(DefaultColortransform);
		}
		private function becomeNormal(obj:Object):void
		{
			setColorMatrix(DefaultColortransform);
		}
		/**设置人物颜色
		 */
		protected function setColorMatrix(colortransform:ColorTransform):void
		{
			_cloth.colorTransform=colortransform;
		}
		
		override public function play(action:int,direction:int=-1,loop:Boolean=true,completeFunc:Function=null,completeParam:Object=null,resetPlay:Boolean=false):void
		{
			initInjureEffect(action);
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
			if(_activeAction!=TypeAction.Dead)
			{
				if(_activeAction!=-1&&_activeDirection!=-1)	play(_activeAction,_activeDirection,true,null,null,true);
				else playDefault(true,null,null,true);
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
		public function updateBlinkMove(mapX:Number,mapY:Number,complete:Function=null,completeParams:Object=null,forceUpdate:Boolean=false):void
		{
			if(parent)
			{
				_completeBlink=complete;
				_completeBlinkParam=completeParams;
				var direction:int=DirectionUtil.getDirection(roleDyVo.mapX,roleDyVo.mapY,mapX,mapY);
				var stay:int=2;
				if(_blinkArr.length==0)
				{
					_blinkArr.push(this);
					var player:BlinkPlayer;
					///创建	 maxBodyNum
					for(var i:int=0;i!=maxBodyNum;++i)
					{
						player=new BlinkPlayer();
						parent.addChild(player);
						initBlinkPlayerData(player);
						_blinkArr.push(player);
					}
				}
				for each(var obj:DisplayObject2D in _blinkArr)
				{
					if(obj is BlinkPlayer)
					{
						BlinkPlayer(obj).x=x;
						BlinkPlayer(obj).y=y;
					}
					Object(obj).gotoAndStop(TypeAction.Walk,stay);
				}
			}
			UpdateManager.Instance.framePer.regFunc(blinkUpdate);
		}
		/** 创建瞬移数据
		 * @param player  瞬移对象
		 */		
		protected function initBlinkPlayerData(player:BlinkPlayer):void
		{
			player.initData(_cloth.actionData);
		}
		
		/** 移形换影 
		 * targetMC   目标mc   
		 * followMC 跟随目标  该对象向 targetMC靠近
		 */		
		private function followBlink(targetMC:DisplayObject2D,followMC:DisplayObject2D):void
		{
			followMC.x +=(targetMC.x-followMC.x)*0.4;
			followMC.y +=(targetMC.y-followMC.y)*0.4;
		}
		
		private function blinkUpdate():void
		{
			var len:int=_blinkArr.length;
			for(var i:int=0;i!=len-1;++i)
			{
				followBlink(_blinkArr[i],_blinkArr[i+1]);
			}
			if(len>1)
			{
				if(Math.pow(x-_blinkArr[len-1].x,2)+Math.pow(y-_blinkArr[len-1].y,2)<=3) 
				{
					disposeBlinkLayer();
					if(_completeBlink!=null)_completeBlink(_completeBlinkParam);
				}
					
			}
			else
			{
				disposeBlinkLayer();
				if(_completeBlink!=null)_completeBlink(_completeBlinkParam);
			}
		}
		
		/**释放瞬移层
		 */ 
		private function disposeBlinkLayer():void
		{
			UpdateManager.Instance.framePer.delFunc(blinkUpdate);
			var len:int=_blinkArr.length;
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
			_blinkArr=[];
		}
		/**瞬移结束
		 */		
//		private function blinkBreak(data:Object):void
//		{
//			var direction:int=int(data);
//			disposeBlinkLayer();
//			play(TypeAction.Stand,direction,true,null,null,true);
//			if(_blinkBreakFunc!=null)_blinkBreakFunc(_blinkBreakParam);
//		}
//		///瞬移结束
//		private function blinkComplete(data:Object=null):void
//		{
//			var direction:int=int(data);
//			disposeBlinkLayer();
//			play(TypeAction.Stand,direction,true,null,null,true);
//			if(_blinkComplete!=null)_blinkComplete(_blinkCompleteParams);
//			print(this,"blinkMoveComplete......");
//
//		} 
//		/**释放瞬移层
//		 */ 
//		private function disposeBlinkLayer():void
//		{
//			if(_blinkLayer)
//			{
//				print(this,"isPool:",_blinkLayer.isPool);
//				if(!_blinkLayer.isPool)  ///将瞬移层给去掉
//				{
//					removeBlinkLayer();
//				}
//			}
//		}
//		/**瞬移层
//		 */		
//		protected function removeBlinkLayer():void
//		{
//			if(contains(_blinkLayer))removeChild(_blinkLayer);
//			_blinkLayer.disposeToPool();
//			_blinkLayer=null;
//			_cloth.start();
//		//	print(this,"cloth--start1111-------");	
//		}
		/**上层特效
		 * @param timesArr 每隔多少时间 执行一次函数调用 播放一次数据 
		 * @param totalTimes 该特效播放的时间长度  不管特效是否循环播放 当超过这个世界就会将特效进行移除
		 * @loop  特效播放 是否循环 播放
		 */
		public function addFrontEffect(actionData:YF2dActionData,timesArr:Array,loop:Boolean=false,skinType:int=2,direction:int=-1,completeFunc:Function=null,completeParam:Object=null):void
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
				_upEffectPart=new EffectPart2DView();
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
		public function addBuffEffect(url:String):void
		{ 
			if(_buffEffectView)
			{
				if(!_buffEffectView.parent)
				{
					addChild(_buffEffectView);
				}
				_buffEffectView.addEffect(url);
			}
			else 
			{
				_buffEffectView=new BuffEffect2DView(this);
				addChild(_buffEffectView);
				_buffEffectView.addEffect(url);
			}
		}
		/**删除 buff特效
		 */		
		public function deleteBuffEffect(url:String):void
		{
			if(_buffEffectView)
			{
				_buffEffectView.deleteEffect(url);
			}
		}
		/**下层特效
		 * @param waitIme   播放该特效需要等待的时间
		 * @param totalTimes 该特效播放的时间长度  不管特效是否循环播放 当超过这个世界就会将特效进行移除
		 * @loop  特效播放 是否循环 播放
		 */
		public function addBackEffect(actionData:YF2dActionData,timesArr:Array,loop:Boolean=false,skinType:int=2,direction:int=-1,completeFunc:Function=null,completeParam:Object=null):void
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
				_downEffectPart=new EffectPart2DView();
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
				_downEffectPart=new EffectPart2DView();
				addChildAt(_downEffectPart,0);  
			}
			_downEffectPart.addSelectRoleiew(object);
		}
		/**取消角色选中
		 */		
		public function removeRoleSelect(object:DisplayObject2D):void
		{
			if(_downEffectPart!=null)_downEffectPart.removeSelectRoleiew(object);
			if(_downEffectPart.numChildren==0&&contains(_downEffectPart)) removeChild(_downEffectPart);
		}
		/** 扣血 文字
		 * 战斗性的文字  1 2 3 4 5 6 7  8 9 
		 * num  为显示的数字
		 * delayTime 为 延迟的时间 单位为毫秒
		 * curentHp 为当前血量
		 * completeFunc  血量更新完成后触发
		 */	
		public function addBloodText(num:int,curentHp:int,timeArr:Array,completeFunc:Function=null,param:Object=null):void
		{
			ImageUtil.Instance.showBloodEx(timeArr,num,x,y,TypeImageText.Num_Yellow_4,completeFunc,param);
			if(roleDyVo)
			{
				roleDyVo.hp=curentHp;
				updateHp();
			}
		}
		

		/** buff 改变显示血量
		 */		
		public function showBuffChange(hpChange:int):void
		{
			if(hpChange<0) ///扣血
			{
				ImageUtil.Instance.showBuffMinus(Math.abs(hpChange),x,y);
			}
			else //加血 
			{
				ImageUtil.Instance.showBuffAdd(hpChange,x,y);
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
		public function playDead(direction:int=-1):void
		{
			isDead=true;
//			disposeBlinkLayer();
			updateHp();
			pureStop();
//			if(direction==-1) direction=activeDirection;
//			play(TypeAction.Dead,direction,false);
//			var deadDirectionArr:Array=_cloth.actionData.getDirectionArr(TypeAction.Dead);
			play(TypeAction.Dead,TypeDirection.DeafultDead,false);
		}
		/**死亡状态  死亡只有一个动作
		 * 停留在死亡的帧上 没有播放的动作 而是直接停留在最后一帧
		 */		
		public function stayDead(direction:int=-1):void
		{
			_activeAction=TypeAction.Dead;
			isDead=true;
//			updateHp(0);
			if(direction==-1) direction=activeDirection;
			if(_cloth.actionData)
			{
			//	var index:int=_cloth.actionData.getDirectionLen(TypeAction.Dead,direction)-1;
//				var deadDirectionArr:Array=_cloth.actionData.getDirectionArr(TypeAction.Dead);
			//	var defaultDeadArr:Vector.<BitmapDataEx>=_cloth.actionData.getDirectionData(TypeAction.Dead,deadDirectionArr[0]);
				var defaultDeadArr:MovieData=_cloth.actionData.getDirectionData(TypeAction.Dead,TypeDirection.DeafultDead);
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
			var size:Point=getSkinSize()
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
			LayerManager.ChatPopLayer.addChild(_chatArrow);
			_chatArrow.y=-size.y;
			///等待 8s
			var timeOut:TimeOut=new TimeOut(5000,removeChatArrow,_chatArrow); 
			timeOut.start();
			UpdateManager.Instance.framePer.regFunc(chatArrowFollow);
		}
		/** 删除冒泡
		 */		
		private function removeChatArrow(obj:Object=null):void
		{
			if(_chatArrow)
			{
				if(!_chatArrow.isDispose)
				{
					LayerManager.ChatPopLayer.removeChild(_chatArrow);
					_chatArrow.dispose();
					_chatArrow=null;
				}
			}
			UpdateManager.Instance.framePer.delFunc(chatArrowFollow);
		}
		
		private function chatArrowFollow():void
		{
			if(_chatArrow)
			{
				_chatArrow.x=x;
				_chatArrow.y=y-100;
			}
		}
		
		override public function dispose(childrenDispose:Boolean=true):void
		{
			if(_shadow)removeChild(_shadow);
			_shadow=null;
			super.dispose(childrenDispose);
			_checkAlphaTilePt=null;
			_checkNode=null;
			removeChatArrow();
			if(_buffEffectView)
			{
				if(contains(_buffEffectView))removeChild(_buffEffectView);
				_buffEffectView.dispose();
			}
			_buffEffectView=null;
			if(_upEffectPart)
			{
				if(contains(_upEffectPart))removeChild(_upEffectPart);
				_upEffectPart.dispose();
			}
			_upEffectPart=null;
			if(_downEffectPart)
			{
				if(contains(_downEffectPart))removeChild(_downEffectPart);
				_downEffectPart.dispose();
			}
			_downEffectPart=null
			_nameItem1=null;
			_nameLayer=null;
			_bloodMC=null;
			if(_tweenSuperSkill)_tweenSuperSkill.disposeToPool();
			_tweenSuperSkill=null;
			
			disposeBlinkLayer();
			_blinkArr=null;
			_completeBlink=null;
			_completeBlinkParam=null;
		}

		/////对象池管理-----------------------------------------
		/**重置初始状态
		 */		
		override public function reset():void
		{
			super.reset();
			mouseEnabled=true;
			removeNameLayer();	
			if(_tweenSuperSkill)_tweenSuperSkill.disposeToPoolWidthStop();
			_tweenSuperSkill=null;
			glow=false;
			disposeBlinkLayer();
			removeChatArrow();
			if(_buffEffectView)
			{
				if(contains(_buffEffectView))removeChild(_buffEffectView);
				_buffEffectView.dispose();
			}
			_buffEffectView=null;
			if(_upEffectPart)
			{
				if(contains(_upEffectPart))removeChild(_upEffectPart);
				_upEffectPart.dispose();
			}
			_upEffectPart=null;
			if(_downEffectPart)
			{
				if(contains(_downEffectPart))removeChild(_downEffectPart);
				_downEffectPart.dispose();
			}
			_downEffectPart=null;
			_completeBlink=null;
			_completeBlinkParam=null;
		}
		/**
		 * @param roleDyVo 为 RoleDyVo 类型
		 */		
		override public function constructor(roleDyVo:Object):IPool
		{
			 super.constructor(roleDyVo);
			 isDead=false;
			 updateName();
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