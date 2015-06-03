package com.YFFramework.game.core.module.chat.view
{
	import com.YFFramework.core.text.RichText;
	import com.YFFramework.core.text.RichTextCSS;
	import com.YFFramework.game.core.global.util.TypeProps;
	
	import flash.display.Sprite;
	import flash.text.TextField;

	/**多个RichText 容器，包装器
	 * @author flashk
	 */
	public class ChatRichTextSprite extends Sprite{
		
		public var isAddSpace:Boolean = true;
		
		protected var _nowHeight:int = 0;
		protected var _textWidth:int = 267;
		protected var _vy:int = 0;
		protected var _max:int = -1;
		
		public function ChatRichTextSprite(){
		}
		
		public function get max():int
		{
			return _max;
		}
		
		/**
		 * 最大条数 
		 */
		public function set max(value:int):void
		{
			_max = value;
		}

		public function get textWidth():int
		{
			return _textWidth;
		}

		/**
		 * 显示的宽度 
		 * @param value
		 * 
		 */
		public function set textWidth(value:int):void
		{
			_textWidth = value;
		}
		
		public function get viewHeight():Number
		{
			return _vy;
		}

		/**
		 * 清除所有RichText
		 * 
		 */
		public function clear():void
		{
			var rt:RichText;
			while(this.numChildren>0){
				rt = this.removeChildAt(0) as RichText;
				rt.dispose();
			}
			_vy = 0;
		}
		
		/**
		 * 添加一个新的历史记录 
		 * @param richText 记录的信息文本
		 * @param exeFun 点击文本触发的函数
		 * @param flyExeFun  点击图标触发的函数
		 * @param data 要追加放入的查找数据
		 * @param isSpace 是否前面显示空白间隔
		 * 
		 */
		public function addNewLine(richText:String,exeFun:Function=null,flyExeFun:Function=null,data:Object=null,isSpace:Boolean=false,yOffset:int=0):void
		{
			var rt:RichText = new RichText();
			rt.setText(richText,exeFun,flyExeFun,data);
			if(isSpace == true && isAddSpace == true){
				rt.x = 25;
				rt.width = _textWidth-25;
			}else{
				rt.width = _textWidth;
				rt.textStyleSheet=RichTextCSS.getChatCSS();
			}
			_vy += yOffset;
			rt.y = _vy;
			_vy += rt.height;
			this.addChild(rt);
			checkMax();
		}
		
		/**
		 * 检查是否超出最大条数，如果超出，删除第一条并上移 
		 * 
		 */
		public function checkMax():void
		{
			var rt:RichText;
			if(_max>-1 && this.numChildren>_max){
				rt = this.removeChildAt(0) as RichText;
				var fy:int = rt.height;
				rt.dispose();
				_vy -= fy;
				var len:int = this.numChildren;
				for(var i:int=0;i<len;i++){
					this.getChildAt(i).y = this.getChildAt(i).y-fy;
				}
			}
		}
		
	}
}