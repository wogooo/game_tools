package com.YFFramework.game.core.module.chat.view
{
	import com.YFFramework.core.text.RichText;

	/**
	 * 聊天（千里传音）历史记录的RichText容器，包装器
	 * @author flashk
	 * 
	 */
	public class ChatHistroyTextSprite extends ChatRichTextSprite
	{
		public function ChatHistroyTextSprite()
		{
			
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
		override public function addNewLine(richText:String,exeFun:Function=null,flyExeFun:Function=null,data:Object=null,isSpace:Boolean=false,yOffest:int=0):void
		{
			var rt:RichText = new RichText();
			if(isSpace == true && isAddSpace == true){
				rt.x = 25;
				rt.width = _textWidth-25;
			}else{
				rt.width = _textWidth;
			}
			rt.setText(richText,exeFun,flyExeFun,data);
			rt.y = _vy;
			_vy += rt.height+15;
			this.addChild(rt);
			checkMax();
		}
		
	}
}