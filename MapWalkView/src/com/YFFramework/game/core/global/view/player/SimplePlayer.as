package com.YFFramework.game.core.global.view.player
{
	/**用于人物面板呈现
	 * @author yefeng
	 * 2013 2013-4-7 上午9:24:18 
	 */
	import com.YFFramework.core.debug.print;
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.ui.abs.AbsView;
	import com.YFFramework.core.ui.movie.BitmapMovieClip;
	import com.YFFramework.core.ui.movie.data.ActionData;
	import com.YFFramework.core.ui.movie.data.TypeAction;
	import com.YFFramework.core.ui.movie.data.TypeDirection;
	import com.YFFramework.core.utils.URLTool;
	import com.YFFramework.core.utils.net.SourceCache;
	import com.YFFramework.core.world.model.type.TypeRole;
	import com.YFFramework.game.core.global.manager.EquipBasicManager;
	import com.YFFramework.game.core.global.model.EquipBasicVo;
	
	import flash.events.Event;
	
	public class SimplePlayer extends AbsView
	{
		private var _cloth:BitmapMovieClip;
		
		private var _weapon:BitmapMovieClip;
		
		private var _wing:BitmapMovieClip;
		
		private var _playAction:int=TypeAction.Stand;
		private var _playDirection:int=TypeDirection.Down;
		private var _dyId:int;
		
		public function SimplePlayer()
		{
			super(false);
			
		}
		
		override protected function initUI():void
		{
			super.initUI();
			this.mouseChildren=false;
			_cloth=new BitmapMovieClip();
			_weapon=new BitmapMovieClip();
			_wing=new BitmapMovieClip();
			addChild(_cloth);
			addChild(_weapon);
			addChild(_wing);
			start();
		}
		
//		/** 更新衣服
//		 */		
//		private function updateCloth(actionData:ActionData):void
//		{
//			_cloth.initData(actionData);
//		}
//		/**  更新武器
//		 */
//		private function updateWeapon(actionData:ActionData):void
//		{
//			_weapon.initData(actionData);
//		}
//		/**翅膀
//		 */		
//		private function updateWing(actionData:ActionData):void
//		{
//			_wing.initData(actionData);
//		}
		
		private function play(action:int,direction:int=-1,loop:Boolean=true,completeFunc:Function=null,completeParam:Object=null,resetPlay:Boolean=false):void
		{
			_playAction=action;
			_playDirection=direction;
			if(_cloth.actionData)
				_cloth.play(action,direction,loop,completeFunc,completeParam,resetPlay);
			if(_weapon.actionData)
				_weapon.play(action,direction,loop,completeFunc,completeParam,resetPlay);
			if(_wing.actionData)
				_wing.play(action,direction,loop,completeFunc,completeParam,resetPlay);
		}
		
		public function playDefault():void
		{
			play(TypeAction.Stand,TypeDirection.Down);
		}
		
		/**
		 * @param basicId    衣服的 静态id 
		 */
		public function updateClothId(basicId:int,sex:int):void
		{
			initActionData(basicId,sex,_cloth);
		}
		/**更新武器 id  武器的静态id 
		 */		
		public function updateWeaponId(basicId:int,sex:int):void
		{
			initActionData(basicId,sex,_weapon);
		}
		/**   更新翅膀 翅膀的静态id 
		 */		
		public function updateWingId(basicId:int,sex:int):void
		{
			 initActionData(basicId,sex,_wing);
		}
		/**默认衣服
		 */		
		public function initDefaultCloth(sex:int,career:int):void
		{
			var url:String=URLTool.getClothNormal(TypeRole.getDefaultSkin(sex,career));
			loadActionData(url,_cloth);
		}
		
		private function initActionData(basicId:int,sex:int,movie:BitmapMovieClip):void
		{
			if(basicId>0)
			{
				var equipBasicVo:EquipBasicVo=EquipBasicManager.Instance.getEquipBasicVo(basicId);
				var url:String;
				switch(movie)
				{
					case _cloth:
						url=URLTool.getClothNormal(equipBasicVo.getModelId(sex));
						break;
					case _weapon:
						url=URLTool.getWeaponNormal(equipBasicVo.getModelId(sex));
						break;
					case _wing:
						url=URLTool.getWingNormal(equipBasicVo.getModelId(sex));
						break;
				}
				
				loadActionData(url,movie);
			}
			else print(this,"basicId不存在");
		}
		private function loadActionData(url:String,movie:BitmapMovieClip):void
		{
			var actionData:ActionData=SourceCache.Instance.getRes2(url) as ActionData;
			if(!actionData)
			{
				SourceCache.Instance.addEventListener(url,onDataComplete);
				SourceCache.Instance.loadRes(url,{player:this,movie:movie}); //也有可能其他玩家加载 
			}
			else 
			{
				movie.initData(actionData);
				play(_playAction,_playDirection);
			}
		}
		
		
		private function onDataComplete(e:YFEvent):void
		{
			var url:String=e.type;
			SourceCache.Instance.removeEventListener(url,onDataComplete);
			var actionData:ActionData=SourceCache.Instance.getRes2(url) as ActionData;
			var arr:Vector.<Object>=e.param as Vector.<Object>;
			var movie:BitmapMovieClip;
			var player:SimplePlayer;
			for each(var obj:Object in arr)
			{
				movie=obj.movie;
				player=obj.player;
				movie.initData(actionData);
				player.play(player._playAction,player._playDirection);
			}
			
		}
		
		override public function dispose(e:Event=null):void
		{
			super.dispose(e);
			_cloth=null;
			_weapon=null;
			_wing=null;
		}
		
		
		
		/**  向坐旋转
		 */		
		public function turnLeft():void
		{
			var direction:int = _playDirection%TypeDirection.DirectionLen +1;
			play(_playAction,direction);
		}
		
		/**向右旋转
		 */
		public function turnRight():void
		{
			var direction:int=_playDirection-1+TypeDirection.DirectionLen;
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
		
	}
}