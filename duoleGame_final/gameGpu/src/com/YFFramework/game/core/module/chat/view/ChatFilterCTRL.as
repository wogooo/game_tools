package com.YFFramework.game.core.module.chat.view
{
	import com.YFFramework.core.utils.StringUtil;
	import com.dolo.common.XFind;
	import com.dolo.ui.controls.CheckBox;
	import com.dolo.ui.sets.UIStyles;
	import com.dolo.ui.tools.AutoBuild;
	import com.dolo.ui.tools.HTMLFormat;
	
	import flash.display.Sprite;
	import flash.events.Event;

	/**聊天频道屏蔽/开启控制 
	 */
	public class ChatFilterCTRL{
		/**状态索引 
		 */
		public static var stateIndex:Array = [5,4,3,2,1,3,-1];
		/**状态标记
		 */
		public static var states:Array = [];
		
		/**UI显示容器 
		 */
		private var _ui:Sprite;
		/**所有的CheckBox组件 
		 */
		private var _checkBoxs:Vector.<CheckBox> = new Vector.<CheckBox>();
		
		public function ChatFilterCTRL(target:Sprite){
			_ui = target;
			AutoBuild.replaceAll(_ui);
			//初始化各个CheckBox的文本，事件和状态标记
			for(var i:int=1;i<=5;i++){
				var ck:CheckBox = _ui.getChildByName("a"+i+"_checkBox") as CheckBox;
				_checkBoxs.push(ck);
				ck.label = HTMLFormat.color(ChatView.shortChannels[i-1],ChatView.channelColos[i-1]);
				ck.textField.filters = UIStyles.textGlowFilters;
				ck.addEventListener(Event.CHANGE,onCheckBoxChange);
				states[i-1] = false;
			}
		}
		
		/**用户点击更改Checkbox时触发，更改状态标记，在聊天内容里输出文字
		 * @param event
		 */
		protected function onCheckBoxChange(event:Event):void{
			var ck:CheckBox = event.currentTarget as CheckBox;
			var index:int = XFind.findIndexInVector(ck,_checkBoxs);
			var stateStr:String;
			if(ck.selected == false)	stateStr = "开启";
			else	stateStr = "屏蔽";
			states[index] = ck.selected;
			var channelStr:String = ChatView.shortChannels[index];
			var a:String;
			a = StringUtil.trimAll(channelStr);
			ChatView.Instance.addNewMessageInAll("{#A7D86B|"+a+"频道已"+stateStr+"}");
		}
		
	}
}