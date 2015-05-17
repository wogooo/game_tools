/**
 * 
 * 		   var chatArowLeft:YFChatArrow=new YFChatArrow(2);
		   addChild(chatArowLeft);
		   chatArowLeft.x=600;
		   chatArowLeft.x=500;
		   chatArowLeft.text="很低很低动画iodhdihdo当皇帝当皇帝电话当皇帝电话似乎【很多当皇帝是当皇帝电话当皇帝电话食品危害文化往往会我我iwhdhd";
 * 
 */ 

package com.YFFramework.core.ui.yfComponent.controls
{
	import com.YFFramework.core.text.RichText;
	import com.YFFramework.core.ui.abs.Scale9Bitmap;
	import com.YFFramework.core.ui.yfComponent.YFComponent;
	import com.YFFramework.core.ui.yfComponent.YFSkin;
	
	import flash.events.Event;
	
	/**场景聊天冒泡控件     id 为1  为 右边  2  为左边 皮肤
	 * 2012-10-19 上午10:28:43
	 *@author yefeng
	 */
	public class YFChatArrow extends YFComponent
	{
		/**背景
		 */		
		protected var _bg:Scale9Bitmap;
		/**内容标签
		 */		
		protected var _contentLabel:RichText;
		
		private var _minHeight:Number;
		/**
		 * @param skinId  1,2   1  为向 右   2 为向左
		 */		
		public function YFChatArrow(skinId:int=1)
		{
			_skinId=skinId;
			super(false);
			mouseChildren=mouseEnabled=false;
			width=170;

		}
		override protected function initUI():void
		{
			super.initUI();
			initSKin();
			initText();
		}
		/**初始化皮肤
		 */		
		protected function initSKin():void
		{
			switch(_skinId)
			{
				case 1:  //
					_style=YFSkin.Instance.getStyle(YFSkin.YFChatArrowLeft);
					_bg=_style.link as Scale9Bitmap;
					addChild(_bg);
					break;
				case 2:
					_style=YFSkin.Instance.getStyle(YFSkin.YFChatArrowRight);
					_bg=_style.link as Scale9Bitmap;
					addChild(_bg);
					break;
			}
			_bg.alpha=0.5;
			_minHeight=_bg.height;
		}
		
		private function initText():void
		{
			_contentLabel=new RichText();
			addChild(_contentLabel);
			_contentLabel.x=_bg.x+_style.scale9L;
			_contentLabel.y=_bg.y+_style.scale9T;
			_contentLabel.width=_bg.getContentWidth();
		//	_contentLabel.height=_bg.getContentHeight();
		}
		override public function set height(value:Number):void
		{
			value=_minHeight<value?value:_minHeight;
			_bg.height=value;
		//	_contentLabel.height=_bg.getContentHeight();
		}
		
		override public function set width(value:Number):void
		{
			_bg.width=value;
			_contentLabel.width=_bg.getContentWidth();

		}
		
		public function set text(txt:String):void
		{
			_contentLabel.setSimpleText(txt);	
			///更新 宽高
			width=_contentLabel.width+_style.scale9L+_style.scale9R;
			height=_contentLabel.height+_style.scale9T+_style.scale9B;
			locate();
		}
		
		public function get text():String
		{
			return _contentLabel.text;	
		}
		
		override public function dispose(e:Event=null):void
		{
			super.dispose(e);
			_bg=null;
			_contentLabel=null;
		}
		/**进行定位
		 */		
		private function locate():void
		{
			switch(_skinId)
			{
				case 1:
					_bg.x=-_bg.width+_style.scale9R+20;
					_bg.y=-_bg.height-20;
					break;
				case 2:
					_bg.x=-_style.scale9L;
					_bg.y=-_bg.height-20;
					break;
			}
			_contentLabel.x=_bg.x+_style.scale9L;
			_contentLabel.y=_bg.y+_style.scale9T;
		}
		
		
	}
}