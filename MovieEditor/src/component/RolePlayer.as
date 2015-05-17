package component
{
	/**
	 *  @author yefeng
	 *   @time:2012-4-6下午07:39:05
	 */
	import com.YFFramework.air.flex.DragUI;
	import com.YFFramework.air.flex.FlexUI;
	import com.YFFramework.core.center.manager.update.UpdateManager;
	import com.YFFramework.core.ui.utils.Draw;
	
	import events.ParamEvent;
	
	import flash.utils.getTimer;
	
	import manager.ActionData;
	import manager.BitmapDataEx;
	
	import mx.events.FlexEvent;
	
	import spark.components.Image;
	import spark.filters.GlowFilter;
	
	import utils.MovieDictUtil;
	import utils.TweenPlay;
	
	public class RolePlayer extends DragUI
	{
		
		private var frameUI:FlexUI; 
		private var playImage:Image;
		
		private var registerUI:FlexUI;
		
		private var playTween:TweenPlay;
		
		
		public var actionData:ActionData;
		
		public function RolePlayer()
		{
			mouseChildren=false;
			playImage=new Image();
			addElement(playImage);
			frameUI=new FlexUI(false);
			addElement(frameUI);
			 
			registerUI=new FlexUI();
			addElement(registerUI);
			Draw.DrawCircle(registerUI.graphics,5,0,0,0x0000FF);
			
			playTween=new TweenPlay();
			UpdateManager.Instance.framePer.regFunc(playTween.update);
			super(false);
			frameUIVisible=false;
			registerUIVisible=false;
			mouseChildren=false;
			buttonMode=true;
			
		}
		/**
		 * @param actionData
		 * @param dispose   当  为 替换局部动作时  该参数需要设置为flase
		 */		
		public function initData(actionData:ActionData,dispose:Boolean=true):void
		{
			if(this.actionData&&dispose)            
			{
				this.actionData.dispose();
			} 
			this.actionData=actionData;
			
			
			if(actionData.headerData["filters"])
			{
				var filter1:GlowFilter=createFilter(actionData.headerData["filter1"]);
				var filter2:GlowFilter=createFilter(actionData.headerData["filter2"]);
				filters=[filter1,filter2];
			}
			else filters=[];
		}
		
		public static  function createFilter(data:Object):GlowFilter
		{
			var filter:GlowFilter=new GlowFilter();
			filter.blurX=data.blurX;
			filter.blurY=data.blurY;
			filter.color=data.color;
			filter.inner=data.inner;
			filter.strength=data.strength;
			return filter;
		}

		public function updateRole(data:BitmapDataEx):void
		{
			playImage.source=data.bitmapData;
			playImage.x=data.x;
			playImage.y=data.y;
			
			Draw.DrawRectLine(frameUI.graphics,playImage.x,playImage.y,data.bitmapData.width,data.bitmapData.height,0xFF0000);
			if(hasEventListener(ParamEvent.RolePlay))dispatchEvent(new ParamEvent(ParamEvent.RolePlay,data));
		}
		
		
		public function set  registerUIVisible(value:Boolean):void
		{
			registerUI.visible=value;
		}
		public function set  frameUIVisible(value:Boolean):void
		{
			frameUI.visible=value;
		}
		public function play(playArr:Vector.<BitmapDataEx>,frameRate:int,loop:Boolean=true,loopTime:int=1):void
		{
			if(hasEventListener(ParamEvent.RoleBeginPlay))dispatchEvent(new ParamEvent(ParamEvent.RoleBeginPlay,playArr));
			if(playArr.length==0) 
			{
				playTween.stop();
				return ;
			}
			playTween.initData(updateRole,playArr,frameRate,loop,loopTime);
			playTween.start();
		}
		
		/**  播放动作
		 */
		public function  playAction(action:int,loop:Boolean=true):void
		{
			if(!actionData) return ;
			
			var t:Number=getTimer();
			var arr:Vector.<BitmapDataEx>=	MovieDictUtil.GetActionArr(actionData.dataDict,action);
			trace("动作角色耗时",getTimer()-t);
			play(arr,int(actionData.headerData[action]["frameRate"]),loop);
			
		}
	
		/**  播放方向
		 */
		public function playDirection(action:int,direction:int,loop:Boolean=true):void
		{
			if(!actionData) return ;
			var t:Number=getTimer();

			var arr:Vector.<BitmapDataEx>=	actionData.dataDict[action][direction] as Vector.<BitmapDataEx>;
			trace("方向角色耗时",getTimer()-t);

			
			play(arr,int(actionData.headerData[action]["frameRate"]),loop);
				
		}
		
		
		public function playAll(loopTime:int):void
		{
			if(actionData)
			{
				var arr:Vector.<BitmapDataEx>=MovieDictUtil.getAllArr(actionData);
				var action:int=actionData.headerData["action"][0];
				if(loopTime<=0)
				{
					play(arr,actionData.headerData[action]["frameRate"],true,loopTime);
				}
				else 
				{
					play(arr,actionData.headerData[action]["frameRate"],false,loopTime);
				}
			}
		}
				
		
		override public function dispose(e:FlexEvent=null):void
		{
			super.dispose();
			UpdateManager.Instance.framePer.delFunc(playTween.update);
			playTween.dispose();
			playTween=null;
		}

		
		public function prePlay():void
		{
			if(!actionData) return ;
			playTween.prePlay();
		}
		public function nextPlay():void
		{
			if(!actionData) return ;
			playTween.nextPlay();
		}
		
		public function continuePlay(loopTime:int):void
		{
			if(!actionData) return ;
			playTween.continuePlay(loopTime);
		}
		
		public function stop():void
		{
			if(!actionData) return ;
			playTween.stop();
		}
				
	}
}