package view
{
	import com.YFFramework.air.flex.DragUI;
	import com.YFFramework.air.flex.FlexUI;
	import com.YFFramework.core.center.manager.update.UpdateManager;
	import com.YFFramework.core.ui.utils.Draw;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.filters.GlowFilter;
	
	import manager.ActionData;
	import manager.BitmapDataEx;
	import manager.MovieClipPlayer;
	import manager.TweenMoviePlay;
	
	import mx.controls.Alert;
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	
	import spark.components.Image;
	import spark.components.TextInput;


	/**  2012-7-11
	 *	@author yefeng
	 */
	public class FlexMovieClip extends DragUI
	{
		/**可以带上数据
		 */ 
		public var myData:Object;
		public var actionData:ActionData;
		private var _playImage:Image;
		protected var _playTween:TweenMoviePlay;
		protected var _completeFunc:Function;
		protected var _completeParam:Object;

		private var _label:TextInput;
		
		
		public function FlexMovieClip()
		{
			super(false);
		}
		override protected function initUI():void
		{
			super.initUI();
			_playImage=new Image(); 
			addElement(_playImage);
			_playTween=new TweenMoviePlay();
			_label=new TextInput();
			_label.width=90;
//			var bg:FlexUI=new FlexUI(false);
//			addElement(bg);
//			Draw.DrawCircle(bg.graphics,5,0,0,0xFF00000);
		}
//		public function doTransform():void
//		{
//			translationManager.addItem(this);
//		}
		public function set text(value:String):void
		{
			_label.text=value;
			if(!_label.parent) addElement(_label);
			_label.x=-40;
			_label.y=-20;
		}
		
		public function get text():String
		{
			return _label.text;
		}
		/**特殊对象
		 */ 
		public function setSpecailColor():void
		{
			var filter:GlowFilter=new GlowFilter(0xFF0000,1,10,10);
			_label.filters=[filter]
		}
		
		public function removeText():void
		{
			if(_label.parent)		removeElement(_label);
		}
		private function updateRole(data:BitmapDataEx):void
		{
			_playImage.source=data.bitmapData;
			_playImage.x=data.x;
			_playImage.y=data.y;
		}

		override protected function addEvent():void
		{
			super.addEvent();
			_playTween.addEventListener(Event.COMPLETE,onPlayComplete);
		}
		override protected function removeEvent():void
		{
			super.removeEvent();
			_playTween.removeEventListener(Event.COMPLETE,onPlayComplete);
		}
		protected function onPlayComplete(e:Event):void
		{
			if(_completeFunc!=null)_completeFunc(_completeParam);
		}

		public function initData(src:Object):void
		{
			if(src is ActionData) actionData=src as ActionData;
			else if(src is MovieClip)
			{
				var uic:UIComponent = new UIComponent();
				var mc:MovieClip = src as MovieClip;
				var player:MovieClipPlayer=new MovieClipPlayer(mc,30);
				uic.addChild(player);
				player.playDefault();
				this.addElement(uic);
			}
			else Alert.show("FlexMovieClip数据不正确");
		}
		protected function playInit(playArr:Vector.<BitmapDataEx>,frameRate:int,loop:Boolean=true):void
		{
			_playTween.initData(updateRole,playArr,frameRate,loop);
			_playTween.start();
		}
		
		/**  播放方向
		 */
		public function play(action:int,direction:int=-1,loop:Boolean=true,completeFunc:Function=null,completeParam:Object=null,mresetPlay:Boolean=false):void
		{
			_completeFunc=completeFunc;
			_completeParam=completeParam;
			var arr:Vector.<BitmapDataEx>=	actionData.dataDict[action][direction];
			playInit(arr,int(actionData.headerData[action]["frameRate"]),loop);
		}
		override public function dispose(e:FlexEvent=null):void
		{
			super.dispose();
			UpdateManager.Instance.framePer.delFunc(_playTween.update);
			_playTween.dispose();
			_playTween=null;
			actionData=null;
			_completeFunc=null;
			_playImage=null;
			myData=null;
		}
		/**调用 stop方法后 需要调用 start方法 重新启动后才能使用play方法
		 */		
		public function start():void
		{
			UpdateManager.Instance.framePer.regFunc(_playTween.update);
		}
		/**再次启用需要调用start方法
		 */		
		public function stop():void
		{
			_playTween.stop();
			UpdateManager.Instance.framePer.delFunc(_playTween.update);
		}
		
		public function playDefault(loop:Boolean=true,completeFunc:Function=null,completeParam:Object=null,resetPlay:Boolean=true):void
		{
			if(actionData)
			{
				var action:int=actionData.getActionArr()[0];
				var direction:int=actionData.getDirectionArr(action)[0];
				play(action,direction,loop,completeFunc,completeParam,resetPlay);
			}
		}
		/**
		 * @param index  在 action  direction 的数组中停留在 index 帧上
		 * @param action
		 * @param direction
		 * 
		 */
		public function gotoAndStop(index:int,action:int,direction:int):void
		{
			play(action,direction,false);
			_playTween.gotoAndStop(index);
			UpdateManager.Instance.framePer.delFunc(_playTween.update);
		}

		
	}
}