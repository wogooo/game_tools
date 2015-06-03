package com.dolo.ui.data
{
	
	/**
	 * List.addItem的简易Data 
	 * @author flashk
	 * 
	 */
	dynamic public class ListItem
	{
		public var label:String = "";
		
		public var value:*;
		
		public var icon:*;
		
		public var vo:*;
		
		public function ListItem(labelValue:String="",valueValue:*=null,iconValue:*=null,voValue:*=null)
		{
			label = labelValue;
			value = valueValue;
			icon = iconValue;
			vo = voValue;
		}
		
	}
}