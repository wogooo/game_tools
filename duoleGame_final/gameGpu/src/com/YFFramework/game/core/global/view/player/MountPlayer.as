package com.YFFramework.game.core.global.view.player
{
	/**
	 * @author yefeng
	 * 2013 2013-4-25 下午4:26:14 
	 */
	import com.YFFramework.core.debug.print;
	import com.YFFramework.core.event.ParamEvent;
	import com.YFFramework.core.ui.abs.AbsView;
	import com.YFFramework.core.ui.movie.data.ActionData;
	import com.YFFramework.core.ui.movie.data.TypeAction;
	import com.YFFramework.core.ui.movie.data.TypeDirection;
	import com.YFFramework.core.ui.yf2d.data.ATFActionData;
	import com.YFFramework.core.ui.yf2d.graphic.ShapePartView;
	import com.YFFramework.core.utils.net.SourceCache;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.module.mount.manager.MountBasicManager;
	import com.YFFramework.game.core.module.mount.model.MountBasicVo;
	import com.YFFramework.game.gameConfig.URLTool;
	
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	public class MountPlayer extends AbsView
	{
		
		private var _mountBody:ShapePartView;
		
		private var _mountHead:ShapePartView;

		private var _playAction:int=TypeAction.Stand;
		private var _playDirection:int=TypeDirection.Down;
		
		private var _dict:Dictionary;
		
		/**加载完成后的回调
		 */
		public var loadComplete:Function;
		/**是否已经触发
		 */
		private var _hastrigger:Boolean;
		public function MountPlayer(autoRemove:Boolean=false)
		{
			super(autoRemove);
		}
		override protected function initUI():void
		{
			super.initUI();
			_dict=new Dictionary();
			this.mouseChildren=false;
			_mountBody=new ShapePartView();
			_mountHead=new ShapePartView();
			addChild(_mountBody);
			addChild(_mountHead);
			start();
		}
		
		private function play(action:int,direction:int=-1,loop:Boolean=true,completeFunc:Function=null,completeParam:Object=null,resetPlay:Boolean=false):void
		{
			_playAction=action;
			_playDirection=direction;
			if(_mountBody.actionData)
				_mountBody.play(action,direction,loop,completeFunc,completeParam,resetPlay);
			if(_mountHead.actionData)
				_mountHead.play(action,direction,loop,completeFunc,completeParam,resetPlay);
			swapAllIndex();
		}
		
		public function playDefault():void
		{
			play(TypeAction.Stand,TypeDirection.RightDown);
		}
		
		/**
		 * @param basicId     坐骑 静态 id
		 */
		public function updateMount(basicId:int):void
		{
			_hastrigger=false;
//			_mountBody.bitmapData=null;
			_mountBody.clear();
			_mountBody.stop();
//			_mountHead.bitmapData=null;
			_mountHead.clear()
			_mountHead.stop();
			_mountBody.initData(null);
			_mountHead.initData(null);
			if(basicId>0)
			{
				var mountBasicVo:MountBasicVo=MountBasicManager.Instance.getMountBasicVo(basicId);
				var modelId:int=MountBasicManager.Instance.getMountModelId(basicId);
				var mountBodyUrl:String=URLTool.getMountBodyView(modelId);		//	URLTool.getMountBody(modelId);
				var mountHeadUrl:String=URLTool.getMountHeadView(modelId);//URLTool.getMountHead(modelId);
				_dict["mount"]={mountBodyUrl:null,mountHeadUrl:mountHeadUrl}
				if(mountBasicVo.parts==TypeProps.MOUNT_PARTS_2)  ///坐骑 分 2个
				{
					_dict["mount"].mountBodyUrl=mountBodyUrl;
					loadActionData(mountBodyUrl,_mountBody);
				}
				loadActionData(mountHeadUrl,_mountHead);

			}
			else 
			{
				handleComplete();
				print(this,"basicId不存在");
//				_mountBody.bitmapData=null;
//				_mountHead.bitmapData=null;
				_mountBody.clear();
				_mountHead.clear();
			}
		}
		
		private function loadActionData(url:String,movie:ShapePartView):void
		{
			var actionData:ActionData=SourceCache.Instance.getRes2(url) as ActionData;
			if(!actionData)
			{
//				SourceCache.Instance.addEventListener(url,onDataComplete);
//				SourceCache.Instance.loadRes(url,{player:this,movie:movie}); //也有可能其他玩家加载 
				addEventListener(url,onDataComplete);
				SourceCache.Instance.loadRes(url,null,SourceCache.ExistAllScene,null,{dispatcher:this,data:movie}); //也有可能其他玩家加载 

			}
			else 
			{
				handleComplete();
				movie.initData(actionData);
				movie.start();
				play(_playAction,_playDirection,true,null,null,true);
			}
		}
		/**资源加载完成
		 */		
		private function handleComplete():void
		{
			if(!_hastrigger)
			{
				_hastrigger=true;
				if(loadComplete!=null)loadComplete();
			}
			
		}
		
		
		private function onDataComplete(e:ParamEvent):void
		{
			handleComplete();
			
			var url:String=e.type;
			removeEventListener(url,onDataComplete);
			var mountObj:Object=_dict["mount"];
			
			var mountBodyUrl:String=mountObj.mountBodyUrl;
			var mountHeadUrl:String=mountObj.mountHeadUrl;
			if(mountHeadUrl==url||mountBodyUrl==url)
			{
				var actionData:ActionData=SourceCache.Instance.getRes2(url) as ActionData;
//				var arr:Vector.<Object>=e.param as Vector.<Object>;
				var movie:ShapePartView=e.param as ShapePartView;
//				var player:MountPlayer;
//				for each(var obj:Object in arr)
//				{
//					movie=obj.movie;
//					player=obj.player;
//					movie.initData(actionData);
//					movie.start();
//					player.play(player._playAction,player._playDirection);
//				}
				movie.initData(actionData);
				play(_playAction,_playDirection,true,null,null,true);
				movie.start();
			}
			
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
			_mountBody.start();
			_mountHead.start();
		}
		/**停止播放
		 */ 
		public function stop():void
		{
			_mountBody.stop();
			_mountHead.stop();
		}
		override public function dispose(e:Event=null):void
		{
			super.dispose(e);
			_mountBody=null;
			_mountHead=null;
		}
		
		
		/**设置层级
		 */		
		private function swapAllIndex():void
		{
			var mountBody:int=getChildIndex(_mountBody);
			var mountHead:int=getChildIndex(_mountHead);
			if(_playDirection==TypeDirection.Up||_playDirection==TypeDirection.LeftUp||_playDirection==TypeDirection.RightUp)
			{
				if(mountHead>mountBody) //头应该在下面
				{
					swapChildren(_mountHead,_mountBody);
				}
			}
			else 
			{
				if(mountHead<mountBody) //头应该在下面
				{
					swapChildren(_mountHead,_mountBody);
				}
			}
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
	}
}