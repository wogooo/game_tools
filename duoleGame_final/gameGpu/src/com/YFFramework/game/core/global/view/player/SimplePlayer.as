package com.YFFramework.game.core.global.view.player
{
	/**用于人物面板呈现
	 * @author yefeng
	 * 2013 2013-4-7 上午9:24:18 
	 */
	import com.YFFramework.core.debug.print;
	import com.YFFramework.core.event.ParamEvent;
	import com.YFFramework.core.ui.abs.AbsView;
	import com.YFFramework.core.ui.movie.data.ActionData;
	import com.YFFramework.core.ui.movie.data.TypeAction;
	import com.YFFramework.core.ui.movie.data.TypeDirection;
	import com.YFFramework.core.ui.yf2d.data.ATFActionData;
	import com.YFFramework.core.ui.yf2d.graphic.IGraphicPlayer;
	import com.YFFramework.core.ui.yf2d.graphic.ShapePartEffectView;
	import com.YFFramework.core.ui.yf2d.graphic.ShapePartView;
	import com.YFFramework.core.utils.net.SourceCache;
	import com.YFFramework.game.core.global.manager.EnhanceEffectBasicManager;
	import com.YFFramework.game.core.global.manager.EquipBasicManager;
	import com.YFFramework.game.core.global.model.EquipBasicVo;
	import com.YFFramework.game.core.module.mapScence.world.model.type.EquipCategory;
	import com.YFFramework.game.core.module.mapScence.world.model.type.TypeRole;
	import com.YFFramework.game.gameConfig.URLTool;
	
	import flash.events.Event;
	
	public class SimplePlayer extends AbsView
	{
		private var _cloth:ShapePartEffectView;
		
		private var _weapon:ShapePartEffectView;
		
		private var _wing:ShapePartView;
		
		private var _playAction:int=TypeAction.Stand;
		private var _activeDirection:int=TypeDirection.Down;
		private var _dyId:int;
		/**能否改变层级
		 */		
		private var _canSwapIndex:Boolean=false;
		public function SimplePlayer()
		{
			super(false);
			
		}
		
		override protected function initUI():void
		{
			super.initUI();
			this.mouseChildren=false;
			_cloth=new ShapePartEffectView();
			_weapon=new ShapePartEffectView();
			_wing=new ShapePartView();
			addChild(_cloth);
			addChild(_weapon);
			addChild(_wing);
			start();
		}
		

		private function play(action:int,direction:int=-1,loop:Boolean=true,completeFunc:Function=null,completeParam:Object=null,resetPlay:Boolean=false):void
		{
			if(direction!=_activeDirection&&direction!=-1)
			{
				_canSwapIndex=true;
			}
			_playAction=action;
			_activeDirection=direction;
			if(_cloth.actionData)
				_cloth.play(action,direction,loop,completeFunc,completeParam,resetPlay);
			if(_weapon.actionData)
				_weapon.play(action,direction,loop,completeFunc,completeParam,resetPlay);
			if(_wing.actionData)
				_wing.play(action,direction,loop,completeFunc,completeParam,resetPlay);
			//设置层级
			if(_canSwapIndex)swapAllIndex();
		}
		
		public function playDefault():void
		{
			play(TypeAction.Stand,TypeDirection.Down);
		}
		
		/**
		 * @param basicId    衣服的 静态id 
		 * clothEnhanceLevel    衣服强化等级
		 */
		public function updateClothId(basicId:int,sex:int,career:int,clothEnhanceLevel:int):void
		{
			initActionData(basicId,sex,_cloth);
			initEffectActionData(clothEnhanceLevel,sex,_cloth,career);
		}
		/**更新武器 id  武器的静态id 
		 */		
		public function updateWeaponId(basicId:int,sex:int,career:int,weaponEnhanceLevel:int):void
		{
			if(basicId>0)
			{
				initActionData(basicId,sex,_weapon);
			}
			else 
			{
				_weapon.stop();
				_weapon.initData(null);
				_weapon.clear();
			}
			initEffectActionData(weaponEnhanceLevel,sex,_weapon,career);
		}
		/**   更新翅膀 翅膀的静态id 
		 */		
		public function updateWingId(basicId:int,sex:int):void
		{
			if(basicId>0)
			 	initActionData(basicId,sex,_wing);
			else 
			{
				_wing.stop();
				_wing.initData(null);
				_wing.clear();
			}
		}
		/**默认衣服
		 */		
		public function initDefaultCloth(sex:int,career:int):void
		{
			var url:String=URLTool.getClothStandWalkView(TypeRole.getDefaultSkin(sex,career));
			loadActionData(url,_cloth);
		}
		
		private function initActionData(basicId:int,sex:int,movie:IGraphicPlayer):void
		{
			movie.clear();
			if(basicId>0)
			{
				var equipBasicVo:EquipBasicVo=EquipBasicManager.Instance.getEquipBasicVo(basicId);
				var url:String;
				switch(movie)
				{
					case _cloth:
//						url=URLTool.getClothStandWalk(equipBasicVo.getModelId(sex));
						url=URLTool.getClothStandWalkView(equipBasicVo.getModelId(sex));
						break;
					case _weapon:
//						url=URLTool.getWeaponStandWalk(equipBasicVo.getModelId(sex));
						url=URLTool.getWeaponStandWalkView(equipBasicVo.getModelId(sex));
						break;
					case _wing:
//						url=URLTool.getWingStandWalk(equipBasicVo.getModelId(sex));
						url=URLTool.getWingStandWalkView(equipBasicVo.getModelId(sex));
						break;
				}
				
				loadActionData(url,movie);
			}
			else 
			{
				print(this,"basicId不存在");
				movie.clear();
			}
		}
		
		/** 加载光效 
		 */
		private function initEffectActionData(enhanceLevel:int,sex:int,movie:ShapePartEffectView,career:int):void
		{
			movie.clear();
			movie.initEffectActionData(null);
			play(_playAction,_activeDirection,true,null,null,true);
			if(enhanceLevel>0)
			{
				var enchanceId:int;
				var url:String=null;
				switch(movie)
				{
					case _cloth:
						enchanceId	=EnhanceEffectBasicManager.Instance.getEnhanceEffectId(EquipCategory.Cloth,sex,enhanceLevel,career);
						if(enchanceId>0)
						{
//							url=URLTool.getClothEffectStandWalk(enchanceId);
							url=URLTool.getClothEffectStandWalkView(enchanceId);
						}
						break;
					case _weapon:
						enchanceId	=EnhanceEffectBasicManager.Instance.getEnhanceEffectId(EquipCategory.Weapon,sex,enhanceLevel,career);
						if(enchanceId>0)
						{
//							url=URLTool.getWeaponEffectStandWalk(enchanceId);
							url=URLTool.getWeaponEffectStandWalkView(enchanceId);
						}
						break;
				}
				if(url)
				{
					loadEffectActionData(url,movie);
				}
			}
			else 
			{
//				print(this,"basicId不存在");
			}
		}

		
		private function loadActionData(url:String,movie: IGraphicPlayer):void
		{
			_canSwapIndex=true;
			var actionData:ActionData=SourceCache.Instance.getRes2(url) as ActionData;
			if(!actionData)
			{
				addEventListener(url,onDataComplete);  ///加载  cpu渲染加载
				SourceCache.Instance.loadRes(url,null,SourceCache.ExistAllScene,null,{dispatcher:this,data:movie});
			}
			else 
			{
				movie.initData(actionData);
				play(_playAction,_activeDirection,true,null,null,true);
				
			}
		}
		
		private function loadEffectActionData(url:String,movie: ShapePartEffectView):void
		{
			var actionData:ActionData=SourceCache.Instance.getRes2(url) as ActionData;
			if(!actionData)
			{
				addEventListener(url,onEffectDataComplete);  ///加载  cpu渲染加载
				SourceCache.Instance.loadRes(url,null,SourceCache.ExistAllScene,null,{dispatcher:this,data:movie});
			}
			else 
			{
				movie.initEffectActionData(actionData);
				play(_playAction,_activeDirection,true,null,null,true);
				
			}
		}
		private function onEffectDataComplete(e:ParamEvent):void
		{
			var url:String=e.type;
			removeEventListener(url,onEffectDataComplete);
			if(!_isDispose)
			{
				var actionData:ActionData=SourceCache.Instance.getRes2(url) as ActionData;
				var movie:ShapePartEffectView=e.param as ShapePartEffectView;
				movie.initEffectActionData(actionData);
				play(_playAction,_activeDirection,true,null,null,true);
			}
		}

		
		
		
		
		private function onDataComplete(e:ParamEvent):void
		{
			var url:String=e.type;
			removeEventListener(url,onDataComplete);
			if(!_isDispose)
			{
				var actionData:ActionData=SourceCache.Instance.getRes2(url) as ActionData;
				var movie:Object=e.param as IGraphicPlayer;
				movie.initData(actionData);
				play(_playAction,_activeDirection,true,null,null,true);
			}
		}
		
		/**  向坐旋转
		 */		
		public function turnLeft():void
		{
			var direction:int = _activeDirection%TypeDirection.DirectionLen +1;
			play(_playAction,direction);
		}
		
		/**向右旋转
		 */
		public function turnRight():void
		{
			var direction:int=_activeDirection-1+TypeDirection.DirectionLen;
			direction=(direction-1)%TypeDirection.DirectionLen +1;
			play(_playAction,direction);
		}
		/** 开始播放
		 */		
		public function start():void
		{
			_cloth.start();
			_weapon.start();
			_wing.start();

		}
		/**停止播放
		 */ 
		public function stop():void
		{
			_cloth.stop();
			_weapon.stop();
			_wing.stop();
		}
		
		public function getDyId():int{
			return _dyId;
		}
		
		public function setDyId(id:int):void{
			_dyId = id;
		}
		
		
		override public function dispose(e:Event=null):void
		{
			super.dispose(e);
			_cloth=null;
			_weapon=null;
			_wing=null;
		}
		
		/**设置层级
		 */		
		private function swapAllIndex():void
		{
			_canSwapIndex=false;
			
			var clothIndex:int=getChildIndex(_cloth);
			var wingIndex:int=getChildIndex(_wing);
			var weaponIndex:int=getChildIndex(_weapon);

			//武器始终在人上面
			if(weaponIndex!=-1) //如果武器存在
			{
				if(weaponIndex<clothIndex)  //武器在下层  则将武器放到上层 
				{
					swapChildren(_weapon,_cloth);
					weaponIndex=clothIndex;
					clothIndex=getChildIndex(_cloth);
				}
				//处理   翅膀   翅膀 
				if(_activeDirection==TypeDirection.Up||_activeDirection==TypeDirection.LeftUp||_activeDirection==TypeDirection.RightUp) //翅膀在最上层
				{
					if(wingIndex<weaponIndex) //如果翅膀在 衣服下层
					{
						swapChildren(_wing,_weapon);
					}
				}
				else //翅膀在最下层  
				{
					if(wingIndex>clothIndex) //如果翅膀在 衣服下层
					{
						swapChildren(_wing,_cloth);
						clothIndex=wingIndex;
					}
					if(weaponIndex<clothIndex)  //武器在下层  则将武器放到上层 
					{
						swapChildren(_weapon,_cloth);
					}
				}
			}
			else    //武器不存在
			{
				//处理   翅膀   翅膀 
				if(_activeDirection==TypeDirection.Up||_activeDirection==TypeDirection.LeftUp||_activeDirection==TypeDirection.RightUp) //翅膀在最上层
				{
					if(wingIndex<clothIndex) //如果翅膀在 衣服下层
					{
						swapChildren(_wing,_cloth);
					}
				}
				else //翅膀在最下层  
				{
					if(wingIndex>clothIndex) //如果翅膀在 衣服下层
					{
						swapChildren(_wing,_cloth);
					}
				}
			}
		}
		
	}
}