package com.YFFramework.game.core.module.chat.view
{
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.text.RichText;
	import com.YFFramework.core.ui.movie.BitmapMovieClip;
	import com.YFFramework.core.ui.movie.data.ActionData;
	import com.YFFramework.core.utils.net.SourceCache;
	import com.YFFramework.game.core.global.manager.CommonEffectURLManager;
	import com.msg.chat.SForwardChatMsg;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;

	/**
	 * 大喇叭（千里传音）的消息显示控制 
	 * @author flashk
	 */
	public class ChatSpeakerChatViewCTRL
	{
		/**
		 * UI界面的Sprite 
		 */
		private var _ui:Sprite;
		/**
		 * RichText文本
		 */
		private var _richText:RichText;
		/**
		 *  RichText文本显示的宽度
		 */
		private var _textWidth:int = 280;
		/**同一条发言最多显示30秒 
		 */
		private var _maxShowTime:int = 30000;
		/**超时Timer 
		 */
		private var _timer:Timer;
		/**大喇叭内容是否显示 
		 */
		private var _visible:Boolean;
		/**动画特效显示 
		 */
		private var movie:BitmapMovieClip;
		
		public function ChatSpeakerChatViewCTRL(target:Sprite){
			_ui = target;
			visible = false;
			_richText = new RichText();
			_richText.x = 30;
			_richText.width = _textWidth - _richText.x;
			_ui.addChild(_richText);
			_timer = new Timer(_maxShowTime);
			_timer.addEventListener(TimerEvent.TIMER,onTimer);
			loadEffect();
		}
		
		/**加载特效 
		 */
		private function loadEffect():void{
			movie =new BitmapMovieClip();
//			movie.setPivotXY(0,-9);
			movie.x=0;
			movie.y=-9;
			
			_ui.addChildAt(movie,1);
			visible = _visible;
			SourceCache.Instance.addEventListener(CommonEffectURLManager.SpeakerFlash,onComplete);
			SourceCache.Instance.loadRes(CommonEffectURLManager.SpeakerFlash,null,SourceCache.ExistAllScene,new Point(-140,-35));
		}
		
		/**特效资源加载完成 
		 * @param e
		 */
		private function onComplete(e:YFEvent):void{
			var url:String=e.type;
			SourceCache.Instance.removeEventListener(CommonEffectURLManager.SpeakerFlash,onComplete);
			var actionData:ActionData=SourceCache.Instance.getRes(url) as ActionData;
			movie.initData(actionData);
			movie.start();
			movie.playDefault();
		}
		
		public function get visible():Boolean{
			return _visible;
		}

		/**大喇叭内容是否显示  
		 * @param value 是否显示
		 */
		public function set visible(value:Boolean):void{
			_visible = value;
			var len:int = _ui.numChildren;
			var dis:DisplayObject;
			for(var i:int=0;i<len;i++){
				dis = _ui.getChildAt(i);
				if(dis.name != "icon_mc"){
					dis.visible = _visible;
				}
			}
			if(movie){
				if(_visible == true){
					movie.start();
					movie.playDefault();
				}else{
					movie.stop();
				}
			}
		}

		/**超时 
		 * @param event
		 */
		protected function onTimer(event:TimerEvent):void{
			visible = false;
			_richText.setText("");
			_timer.stop();
		}
		
		/**显示大喇叭（千里传音）内容 
		 * @param data
		 */
		public function showMessage(data:SForwardChatMsg):void{
			var msg:String = getSpeakerString(data);
			_richText.setText(msg,exeFunc,flyExeFunc,null);
			visible = true;
			ChatSpeakerHistroyWindow.getInstance().addtoHistroy(data);
			_timer.reset();
			_timer.start();
		}
		
		/**格式化大喇叭文本内容
		 * @param data 服务器返回的数据
		 * @return  RichText格式的文本内容
		 */
		public static function getSpeakerString(data:SForwardChatMsg):String{
			var msg:String = data.msg;
			var male:int = data.fromGender;
			var maleStr:String;
			if(male == 0){
				maleStr = "♀";
			}else{
				maleStr = "♂";
			}
			var vipLevel:int = data.fromVipLv;
			var roleName:String = data.fromName;
			var roleID:int = data.fromId;
			var vipStr:String = ChatSetUtil.getVipText(vipLevel);
			var fontColor:String;
			fontColor = "{#FFFF00|"
			msg = fontColor+maleStr+vipStr+"}"+fontColor+roleName+"|"+roleID+"}"+fontColor+"："+msg+"}";
			return msg;
		}
		
		/**RichText人名文本点击要执行的函数 
		 * @param obj
		 */
		private function exeFunc(obj:Object):void{
			
		}
		
		/**
		 * RichText图标点击要执行的函数 
		 * @param obj
		 * 
		 */
		private function flyExeFunc(obj:Object):void{
			
		}
		
	}
}