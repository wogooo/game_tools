package com.YFFramework.game.core.module.task.view
{
	import com.YFFramework.core.text.RichText;
	import com.YFFramework.core.text.RichTextCSS;
	import com.YFFramework.core.utils.HashMap;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;

	/**RichText多个容器  内部 可能含有新手引导的 对象     内部保存的是 新手引导的 NewGuideMovieClip 和RichText  对象
	 * @author flashk
	 */
	public class RichTextSprite extends Sprite{
		
		/**富文本的  x 坐标
		 */		
		public static const RichTextX:int=25;
		
		public var isAddSpace:Boolean = true;
		private var _nowHeight:int = 0;
		private var _textWidth:int = 267;
		private var _vy:int = 0;
		
		/**存储 可用到  richText
		 */		
		private var _richTextArr:Array;
		public function RichTextSprite()
		{
			_richTextArr=[];
		}
		
		public function get textWidth():int
		{
			return _textWidth;
		}

		public function set textWidth(value:int):void{
			_textWidth = value;
		}
		
		public function get viewHeight():Number{
			return _vy;
		}

		public function clear():void{
//			var rt:RichText;
			var rt:DisplayObject;
			while(this.numChildren>0){
//				rt = this.removeChildAt(0) as RichText;
//				rt.dispose();
				rt=this.removeChildAt(0);
				if(rt.hasOwnProperty("dispose"))Object(rt).dispose();
			}
			_vy = 0;
			_richTextArr=[];
		}
		/** 添加 新的 一行 数据 返回的是新手引导 需要的数据
		 */		
		public function addNewLine(richText:String,exeFun:Function=null,flyExeFun:Function=null,data:Object=null,isSpace:Boolean=false):Object{
			var rt:RichText = new RichText();
			var canUse:Boolean=false;
			if(isSpace == true && isAddSpace == true){  //可用的 文本  
				rt.x = RichTextX;
				rt.width = _textWidth-88;
				_richTextArr.push(rt);
				canUse=true;
				rt.textStyleSheet=RichTextCSS.getTaskCSS();
			}else{  //   [主]
				rt.width = _textWidth;
			}
			var guideTxt:String=rt.setText(richText,exeFun,flyExeFun,data);
			rt.y = _vy;
			_vy += rt.height;
			this.addChild(rt);
			if(guideTxt&&canUse)	return {guideTxt:guideTxt,richText:rt};
			return null;
		}
		
		/**新手 引导时  自动触发 第一个
		 */		
		public function triggerFirst():void
		{
			var len:int=_richTextArr.length;
			var richText:RichText;
			var useFul:Boolean=false;
			for(var i:int=0;i!=len;++i)
			{
				richText=_richTextArr[i];
				if(richText)
				{
					useFul=richText.triggerIt();
					if(useFul)	return ;
				}
			}
		}
		
		/** 触发第一个任务的小飞鞋
		 */		
		public function triggerFirstFlyBoot():void
		{
			var len:int=_richTextArr.length;
			var richText:RichText;
			var useFul:Boolean=false;
			for(var i:int=0;i!=len;++i)
			{
				richText=_richTextArr[i];
				if(richText)
				{
					useFul=richText.triggerFlyBoot()
					if(useFul)	return ;
				}
			}
		}
		
		/**获取富文本个数
		 */		
		public function get richTextNum():int
		{
			return _richTextArr.length;
		}
		
	}
}